/*
Students at your hometown high school have decided to organize their social network using databases. So far, they have collected information about sixteen students in four grades, 9-12. Here's the schema:

Highschooler ( ID, name, grade )
English: There is a high school student with unique ID and a given first name in a certain grade.

Friend ( ID1, ID2 )
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123).

Likes ( ID1, ID2 )
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present.
*/

-- Find the names of all students who are friends with someone named Gabriel.

select distinct name from (select f.id1, f.id2 from Friend f
join Highschooler h on f.id1 = h.id or  f.id2 = h.id 
where h.name = 'Gabriel') friends join
Highschooler h on friends.id1 = h.id or friends.id2 = h.id
EXCEPT select 'Gabriel'

-- For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.

select h1.name, h1.grade, h2.name, h2.grade  from Likes l
join Highschooler h1 on l.id1 = h1.id
join Highschooler h2 on l.id2 = h2.id
where abs(h2.grade - h1.grade)  >=2

-- For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.

select h1.name, h1.grade, h2.name, h2.grade 
from Likes l
join Highschooler h1 on l.id1 = h1.id
join Highschooler h2 on l.id2 = h2.id
join Likes l1 on l1.id1 = l.id2 and l1.id2 = l.id1
where h1.name < h2.name
order by 1

-- Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.

select name, grade from Highschooler where id not in (
select id1 from Likes
UNION
select id2 from Likes)
order by  2, 1


-- For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.

select h1.name, h1.grade, h2.name, h2.grade  from Likes l1, 
Highschooler h1, Highschooler h2 where l1.id2 not in (select id1 from Likes) and l1.id1 = h1.id and l1.id2 = h2.id;

-- Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.

SElect DISTINCT h1.name, h1.grade From Friend f, Highschooler h1, Highschooler h2 
where h1.id = f.id1 and h2.id = f.id2 and h1.grade = h2.grade
EXCEPT SElect DISTINCT h1.name, h1.grade From Friend f, Highschooler h1, Highschooler h2 
where h1.id = f.id1 and h2.id = f.id2 and h1.grade != h2.grade 
 order by h1.grade, h1.name
 
 
--  For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C


-- Find the difference between the number of students in the school and the number of different first names.

select count(distinct id) - count(distinct name) from Highschooler

-- Find the name and grade of all students who are liked by more than one other student.

select h.name, h.grade from Highschooler h
join Likes l on l.id2 = h.id
group by h.id
having count(*) > 1

