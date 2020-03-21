-- Your triggers are created in SQLite, so you must conform to the trigger constructs supported by SQLite.

CREATE TRIGGER friendly AFTER INSERT
ON Highschooler
WHEN new.name = 'Friendly'
BEGIN
   INSERT INTO LIKES(ID1, ID2) Select DISTINCT new.id, id from Highschooler where grade = new.grade and name != 'Friendly';
END;

-- Write one or more triggers to manage the grade attribute of new Highschoolers. If the inserted tuple has a value less than 9 or greater than 12, change the value to NULL. On the other hand, if the inserted tuple has a null value for grade, change it to 9.


CREATE TRIGGER graded AFTER INSERT
ON Highschooler
BEGIN
   Update Highschooler set grade = (CASE WHEN new.grade < 9 or new.grade > 12 THEN NULL
                                    WHEN new.grade is NULL then 9
                                    ELSE new.grade END) where id = new.id;
END;

-- Write one or more triggers to maintain symmetry in friend relationships. Specifically, if (A,B) is deleted from Friend, then (B,A) should be deleted too. If (A,B) is inserted into Friend then (B,A) should be inserted too. Don't worry about updates to the Friend table.


CREATE TRIGGER unfriended AFTER DELETE
ON Friend
BEGIN
   DELETE FROM Friend where id1 = old.id2 and id2 = old.id1;
END;


CREATE TRIGGER friended AFTER INSERT
ON Friend
BEGIN
   INSERT INTO Friend Values (new.id2, new.id1);
END;

-- Write a trigger that automatically deletes students when they graduate, i.e., when their grade is updated to exceed 12.

CREATE TRIGGER graduated AFTER UPDATE
ON Highschooler
WHEN new.grade > 12
BEGIN
   DELETE FROM Highschooler where id=new.id;
END;

-- Write a trigger that automatically deletes students when they graduate, i.e., when their grade is updated to exceed 12 (same as Question 4). In addition, write a trigger so when a student is moved ahead one grade, then so are all of his or her friends.

CREATE TRIGGER graduated AFTER UPDATE
ON Highschooler
WHEN new.grade > 12
BEGIN
   DELETE FROM Highschooler where id=new.id;
END;


CREATE TRIGGER moved_ahead AFTER UPDATE
ON Highschooler
WHEN old.grade <= 12 and new.grade = old.grade + 1
BEGIN
   Update Highschooler SET grade = grade+1 where id in (
   select id2 from Friend where id1=new.id
   UNION
   select id1 from Friend where id2=new.id);
END;

-- Write a trigger to enforce the following behavior: If A liked B but is updated to A liking C instead, and B and C were friends, make B and C no longer friends. Don't forget to delete the friendship in both directions, and make sure the trigger only runs when the "liked" (ID2) person is changed but the "liking" (ID1) person is not changed.

CREATE TRIGGER unfriended_decision AFTER UPDATE
ON Likes
WHEN old.id1 = new.id1 and old.id2 != new.id2
BEGIN
   DELETE FROM Friend where id1 in (SElECT id1 from Friend where 
   ((id1 = old.id2 and id2 = new.id2) OR (id1 = new.id2 and id2 = old.id2)))
   and id2 in (SElECT id2 from Friend where 
   ((id1 = old.id2 and id2 = new.id2) OR (id1 = new.id2 and id2 = old.id2)));
END;
