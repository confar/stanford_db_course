
-- Add the reviewer Roger Ebert to your database, with an rID of 209.

Insert into Reviewer Values(209, 'Roger Ebert')

-- Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.

Insert into Rating
SELECT distinct jc.rid, m.mid, 5, Null FROM 
(select rid from Reviewer where name = 'James Cameron') as jc,
(select mid from Movie) as m,
Rating r 


-- For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.)

Update Movie set year=year + 25 where mid in (
Select mid from Movie m 
join Rating r using (mid) 
group by mid 
having (avg(stars)) >=4)


-- Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.

Delete from Rating where mid in (select mid from Movie where (year < 1970 or year > 2000) and stars < 4)

