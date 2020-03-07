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