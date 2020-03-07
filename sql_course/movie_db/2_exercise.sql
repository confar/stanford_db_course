-- Find the names of all reviewers who rated Gone with the Wind.

Select distinct name from Reviewer rw
join Rating r using(rid)
join Movie m using(mid)
where m.title = 'Gone with the Wind'

-- For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.

Select distinct name, m.title, r.stars from Reviewer rw
join Rating r using(rid)
join Movie m using(mid)
where rw.name = m.director

-- Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)

Select name from Reviewer 
UNION
select title from Movie
ORDER by 1

-- Find the titles of all movies not reviewed by Chris Jackson.

select title from Movie except
Select title from Movie m
join Rating r using(mid)
join Reviewer rw using(rid)
where rw.name = 'Chris Jackson'

-------




------

-- For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.

select rw.name, m.title, r.stars
from Rating r join Movie m using(mid)
join Reviewer rw using (rid)
where r.stars = (select min(stars) from Rating)

-- List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.
Select m.title, avg(r.stars) 
from Movie m join Rating r using (mid)
group by mid
order by 2 desc, 1

-- Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)

Select distinct rw.name from Reviewer rw 
join Rating r using(rid)
where 3 <= (select count(rid) from Rating r1 where r.rid = r1.rid)


-- Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)

select m.title, m.director from Movie m where director in (
select m.director from Movie m
group by m.director
having count(*) > 1)
order by 2, 1