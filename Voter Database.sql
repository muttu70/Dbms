create table constituency(cons_id number(20) primary key,csname varchar(20),csstate varchar(20),no_of_voters number(10));

create table party(pid number(20) primary key,pname varchar(20),psymbol varchar(10));

create table candidates(cand_id number(12) primary key,phone_no number(10),age number(2),state varchar(20),name varchar(20),pid int references party(pid));

create table contest(cons_id number(20) references constituency(cons_id),cand_id number(12) references candidates(cand_id),primary key(cons_id,cand_id));
                     
create table voter(vid number(20) primary key,vname varchar(20),vage number(5),vaddr varchar(20),cons_id number(20) references constituency(cons_id),cand_id number(12) references candidates(cand_id));



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



