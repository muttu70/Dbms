create table team( tid int primary key,tname varchar(20),coach varchar(20),captain_pid int,city varchar(20));
create table player( pid int primary key,pname varchar(2),age int,tid int references team(tid));
create table stadium(sid int primary key,sname varchar(20),picode number(8),city varchar(20),area varchar(20));
create table match(mid int primary key,mdate date,time varchar(6),sid int references stadium(sid),team1_id int references team(tid),team2_id int references team(tid),winning_team_id int references team(tid),man_of_match int references player(pid), pid int references player(pid));
create table player_phone( pid int references player(pid),phone int,primary key(pid,phone));



1. Display the youngest player (in terms of age) Name, Team name, age in which he belongs of the tournament.
Select pname, tname, age from player p,team t where p.tid=t.tid and age =(select min(age) from player);
pname	tname	age
kohli	rcb	23

2. List the details of the stadium where the maximum number of matches were played.
select m.sid,count(m.mid),s.sname from match m,stadium s where m.sid=s.sid group by m.sid order by m.mid limit 1;
sid	count(m.mid)	sname
111	3	chinnaswamy

3. List the details of the player who is not a captain but got the man_of _match award at least in two matches.
select * from player where pid not in(select captain_pid from team) and pid in(select m.pid from match m group by m.man_of_match having count(m.man_of_match)>1);
pid	pname	age	tid
3	dhoni	30	123

4. Display the Team details who won the maximum matches.
select m.winning_team_id,count(m.winning_team_id) from match m group by m.winning_team_id order by count(m.winning_team_id) desc limit 1;
winning_team_id	count(m.winning_team_id)
127	2


5. Display the team name where all its won matches played in the same stadium.
select m.winning_team_id,t.tname,m.sid,s.sname from match m,team t,stadium s where m.winning_team_id=t.tid and m.sid=s.sid group by m.winning_team_id having count( distinct m.sid)=1;
winning_team_id	tname	sid	sname
123	rcb	111	chinnaswamy
