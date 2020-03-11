-- It's time for the seniors to graduate. Remove all 12th graders from Highschooler.

delete from Highschooler where grade = 12

-- If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple

DELETE FROM Likes where id1 in (Select id1 from Friend JOIN Likes using(id1, id2) 
                                where id1 not in (SELECT id2 from Friend JOIN Likes using(id1, id2))) 
                                       and id2 in (
                                       Select id2 from Friend JOIN Likes using(id1, id2) 
                                        where id1 not in (SELECT id2 from Friend JOIN Likes using(id1, id2)));
                        
-- For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. 
-- Do not add duplicate friendships, friendships that already exist, or friendships with oneself. 

INSERT INTO FRIEND SELECT ABC.A, ABC.C
FROM (SELECT AB.A, AB.B, f.id2 as C from (Select id1 as A,id2 as B from Friend 
JOIN Friend using(id1, id2)) AB JOIN FRIEND f ON AB.B = f.id1) ABC 
WHERE ABC.A != ABC.C EXCEPT Select id2, id1 from Friend JOIN Friend using(id1, id2)