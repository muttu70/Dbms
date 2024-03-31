

1. Count the customers with grades above Bangalore’saverage
SELECT GRADE, COUNT (DISTINCT CID) FROM
CUSTOMER
GROUP BY GRADE
HAVING GRADE > (SELECT AVG(GRADE)
FROM CUSTOMER
WHERE CITY='BANGALORE');

2. Find the name and numbers of all salesmen who had more than one customer.
SELECT sid,name
  FROM salesman
  WHERE sid IN (SELECT salesman_id
                          FROM customer
                          GROUP BY salesman_id
                          HAVING COUNT(*) > 1);              

3. List all salesmen and indicate those who have and don’t have customers in their cities (Use UNION operation.)

SELECT SALESMAN.SID, NAME, CNAME, COMMISSION FROM
SALESMAN, CUSTOMER
WHERE SALESMAN.CITY = CUSTOMER.CITY
UNION
SELECT SID, NAME, 'NO MATCH', COMMISSION
FROM SALESMAN
WHERE NOT CITY = ANY
(SELECT CITY
FROM CUSTOMER)
ORDER BY 2 DESC;


4. Create a view that finds the salesman who has the customer with the highest order of a day.
CREATE VIEW ELITSALESMAN AS
SELECT B.ORD_DATE, A.SID, A.NAME FROM
SALESMAN A, ORDER1 B
WHERE A.SID = B.SALESMAN_ID
AND B.PURCHASE_AMT=(SELECT MAX (PURCHASE_AMT)
FROM ORDER1 C
WHERE C.ORD_DATE = B.ORD_DATE);

select * from ELITSALESMAN;


5. Demonstrate the DELETE operation by removing salesman with id 1000. All his orders
must also be deleted.
DELETE FROM SALESMAN WHERE SID=1000;
SELECT * FROM SALESMAN;






1.	List all the student details studying in fourth semester ‘C’ section.
SELECT s.usn,s.sname,s.address,s.phone
FROM Student s, Semsec n, Class c
WHERE n.sem=4 and n.sec='C' and s.usn=c.usn and c.ssid=n.ssid;



2.	Compute the total number of male and female students in each semester and in each section.
SELECT c.ssid room_no, sec section, sem semester,
			SUM(CASE WHEN s.gender='M' THEN 1 ELSE 0 END) AS MALE,
			SUM(CASE WHEN s.gender='F' THEN 1 ELSE 0 END ) AS FEMALE
FROM Class c, Student s, Semsec m
WHERE s.usn=c.usn AND m.ssid=c.ssid GROUP BY c.ssid, sem, sec;



3.	Create a view of Test1 marks of student USN ‘1BI15CS101’ in all subjects.
CREATE VIEW Test1_Marks AS
SELECT test1 FROM IAmarks WHERE usn='3br15cs005';

select * from Test1_Marks;



4.	Calculate the FinalIA (average of best two test marks) and update the corresponding table for all students.
UPDATE iamarks SET finalia= (GREATEST(test1+test2,test2+test3,test3+test1))/2; 

SELECT * FROM IAmarks;


5.	Categorize students based on the following criterion:
If FinalIA = 17 to 20 then CAT = ‘Outstanding’ If FinalIA = 12 to 16 then CAT = ‘Average’
If FinalIA< 12 then CAT = ‘Weak’
Give these details only for 8th semester A, B, and C section students.

SELECT i.usn,i.test1,i.test2,i.test3,i.finalia,

		(CASE WHEN i.finalia>=17 AND i.finalia<=20 THEN 'outstanding' 
		      WHEN i.finalia>=12 AND i.finalia<=17 THEN 'average' 
		      WHEN i.finalia>12 THEN 'weak'
		      ELSE 'invalid'
		END) AS grade

FROM IAmarks i, Class c, Semsec s
WHERE i.usn=c.usn AND c.ssid=s.ssid AND s.sem=8 and s.sec IN ('A','B','C')




	

1. List the details of the candidates who are contesting from more than one constituency which are belongs to different states.
select c.cand_id,cd.name,count(c.cons_id)from contest c,candidates cd where
c.cand_id=cd.cand_id group by(c.cand_id) having count(c.cons_id)>1;
cand_id	name	count(c.cons_id)
198	raksha	2

2. Display the state name having maximum number of constituencies.
select csstate,count(cons_id) from constituency group by csstate order by
count(cons_id) desc limit 1;
csstate	count(cons_id)
kerala	3

3. Create a stored procedure to insert the tuple into the voter table by checking the voter age. If
voter’s age is at least 18 years old, then insert the tuple into the voter else display the “Not
an eligible voter msg”.
SQL> create   procedure agechecking ( id in number,age in number)
  2  as
  3  BEGIN
  4  if age>18 then
  5  insert into voter(vid,vage) values (id,age);
  6  else
  7  dbms_output.put_line('age should be high');
  8  end if;
  9  end agechecking;
 10  /

Procedure created.

SQL> set serveroutput on;
SQL> exec agechecking (25,21);

PL/SQL procedure successfully completed.

SQL> exec agechecking (20,15);
age should be high

PL/SQL procedure successfully completed.

SQL> select * from voter;

       VID VNAME                      VAGE VADDR                   CONS_ID
---------- -------------------- ---------- -------------------- ----------
   CAND_ID
----------
       901 prasad                       19 kanakpura                   111
       198

       903 aa                           19 kanakpura                   444
       199

       904 dd                           21 ramnagar                    444
       199


       VID VNAME                      VAGE VADDR                   CONS_ID
---------- -------------------- ---------- -------------------- ----------
   CAND_ID
----------
       905 tt                           21 mandya                      444
       199

        25                              21



4. Display the constituency name, state and number of voters in each state in descending
order using rank() function
SQL> SELECT csname, csstate, no_of_voters,
  2  RANK () OVER (partition BY csstate order by no_of_voters desc) AS Rank_No
  3  FROM constituency;

CSNAME               CSSTATE              NO_OF_VOTERS    RANK_NO
-------------------- -------------------- ------------ ----------
rajajinagar          karnataka                       5          1
tnagar               karnataka                       4          2
anagar               kerala                          1          1


5. Create a TRIGGER to UPDATE the count of “Number_of_voters” of the respective
constituency in “CONSTITUENCY” table, AFTER inserting a tuple into the “VOTERS”
table.
SQL> create  trigger count
  2  after insert on voter
  3  for each row
  4  begin
  5  update constituency
  6  set no_of_voters = no_of_voters + 1
  7  where cons_id=:new.cons_id;
  8  end count;
  9  /

Trigger created.

SQL> select * from constituency;

   CONS_ID CSNAME               CSSTATE              NO_OF_VOTERS
---------- -------------------- -------------------- ------------
       111 rajajinagar          karnataka                       5
       444 anagar               kerala                          1
       555 tnagar               karnataka                       4

SQL> insert into voter values(399,'nagesh',30,'mandya',111,199);

1 row created.

SQL> select * from constituency;

   CONS_ID CSNAME               CSSTATE              NO_OF_VOTERS
---------- -------------------- -------------------- ------------
       111 rajajinagar          karnataka                       6
       444 anagar               kerala                          1
       555 tnagar               karnataka                       4





	   

1.List the titles of all movies directed by ‘Hitchcock’.
SELECT mov_title
FROM Movie m,director d
WHERE d.dir_id=m.dir_id and d.dir_name='Hitchcock’;

2.Find the movie names where one or more actors acted in two or more movies. 
SELECT MOV_TITLE
FROM MOVIES M,MOVIE_CAST MC
WHERE M.MOV_ID=MC.MOV_ID AND ACT_ID IN (SELECT ACT_ID
FROM MOVIE_CAST GROUP BY ACT_ID
HAVING COUNT(ACT_ID)>1)
GROUP BY MOV_TITLE
HAVING COUNT(*)>1;

3. List all actors who acted in a movie before 2000 and also in a movie after 2015 (use JOIN operation).
SELECT ACT_NAME
FROM ACTOR A
JOIN MOVIE_CAST C
ON A.ACT_ID=C.ACT_ID
JOIN MOVIES M
ON C.MOV_ID=M.MOV_ID
WHERE M.MOV_YEAR NOT BETWEEN 2000 AND 2015;

4.Find the title of movies and number of stars for each movie that has at least one rating and find the highest number of stars that movie received. Sort the result by movie title.
SELECT mov_title, MAX(rev_stars)
FROM movie m, rating r WHERE m.mov_id=r.mov_id
GROUP BY mov_title
HAVING MAX(rev_stars)>0
ORDER BY mov_title;


5.Update rating of all movies directed by ‘Steven Spielberg’ to 5.
UPDATE rating SET rev_stars=5
WHERE mov_ID in (SELECT m.mov_ID
FROM Movie m, rating r
WHERE M.mov_ID=r.mov_ID and m.dir_id in (SELECT dir_id FROM director
WHERE dir_name='david'));




.Display the yougest player (in terms of age) Name,Team name,age in which he belongs of the the tournament.

       SELECT pname,tname,age
       FROM player p,team t
       WHERE p.tid=t.tid and age=(SELECT min(age) FROM player);


2.List the details of the stadium where the maximum number of matches were played.
     
       SELECT * FROM stadium WHERE sid in
       (SELECT sid from match 
       GROUP BY sid HAVING count(sid)=(SELECT max(count(sid)) FROM match GROUP BY sid));


3.List the details of the player who is not a captain but got the man_of_match award atleast in two matches.
    
     SELECT * FROM player WHERE pid NOT IN
     (SELECT captain_pid from team) AND pid IN
     (SELECT man_of_match FROM match 
     GROUP BY man_of_match HAVING count(man_of_match)>=2);

4.Display the teams details who won the maximum matches.

    SELECT * FROM team WHERE tid IN
    (SELECT winning_team_id FROM match
    GROUP BY winning_team_id HAVING count(winning_team_id)=
    (SELECT max(count(winning_team_id) FROM match
    GROUP BY winning_team_id));

5.Display the team name where all its won matches played in the same stadium.

   SELECT tname FROM team WHERE tid IN
   (SELECT winning_team_id FROM match 
   GROUP BY (winning_team_id) HAVING count(*) IN
   (SELECT count(winning_team_id) FROM match 
   GROUP BY winning_team_id));
   
