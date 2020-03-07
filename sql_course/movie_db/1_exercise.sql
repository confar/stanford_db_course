/* 
You've started a new movie-rating website, and you've been collecting data on reviewers' ratings of various movies. There's not much data yet, but you can still try out some interesting queries. Here's the schema:

Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.

Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate.
*/


-- Find the titles of all movies directed by Steven Spielberg.

select title from Movie where director = 'Steven Spielberg'


-- Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

Select distinct year from Movie m 
join Rating r using(mid) 
where r.stars in (4, 5)
order by year


-- Find the titles of all movies that have no ratings.

Select title from Movie m 
left join Rating r using(mid) 
where r.mid is null

-- Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.

Select name from Reviewer rv 
left join Rating rt using(rid) 
where rt.ratingDate is null

-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.

Select rv.name, m.title, rt.stars, rt.ratingdate from Reviewer rv 
join Rating rt using(rid)
join Movie m using(mid)
order by 1,2,3

-- For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.?

select name, title from (SELECT r.rid as rid, mid, min(ratingDate) as minrating, max(ratingDate) as maxrating FROM Reviewer r
JOIN Rating rt using (rid)
group by r.rid, r.name, mid
having count(*) = 2)  d 
join Rating r1 on r1.rid = d.rid and r1.mid = d.mid and r1.ratingDate = minrating
join Rating r2 on r2.rid = d.rid and r2.mid = d.mid and r2.ratingDate = maxrating
join Reviewer rv  on d.rid = rv.rid
join Movie m  on d.mid = m.mid
where r2.stars > r1.stars

-- For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.

Select title, max(stars) 
from Movie m join Rating r using(mid)
group by title
order by 1

-- For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.

Select title, max(stars) - min(stars) 
from Movie m join Rating r using(mid)
group by title
order by 2 DESC, 1

-- Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)

select (select avg(avgm.stars) from
(Select title, avg(stars) as stars, year
from Movie m join Rating r using(mid)
group by mid 
having year < 1980) as avgm) - (select avg(avgm.stars) from
(Select title, avg(stars) as stars, year
from Movie m join Rating r using(mid)
group by mid 
having year > 1980) as avgm);