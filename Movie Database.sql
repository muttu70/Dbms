CREATE TABLE actor (
act_id	NUMBER(10)	PRIMARY KEY	NOT NULL, 
act_name	VARCHAR(20) NOT NULL,
act_gender VARCHAR(20) NOT NULL
);

CREATE TABLE director (
dir_id	NUMBER(10)	PRIMARY KEY NOT NULL,
dir_name	VARCHAR(20)	NOT NULL,
dir_phone	NUMBER(10)	NOT NULL
);

CREATE TABLE Movie (
mov_id	NUMBER(10)	PRIMARY KEY NOT NULL,
mov_title	VARCHAR(20)	NOT NULL,
mov_year	NUMBER(10)	NOT NULL,
mov_lang	VARCHAR(20)	NOT NULL,
dir_id	NUMBER(10)	NOT NULL REFERENCES director(dir_id)
);
 
CREATE TABLE  movie_cast (
act_id	NUMBER(10)	NOT NULL REFERENCES actor(act_id), 
mov_id	NUMBER(10)	NOT NULL REFERENCES movie(mov_id), 
role	VARCHAR(20)	NOT NULL,
PRIMARY KEY (act_id1, mov_id1)
);

CREATE TABLE rating (
mov_id	NUMBER(10)	NOT NULL REFERENCES movie(mov_id),
rev_stars	NUMBER(10)	NOT NULL,
PRIMARY KEY (mov_id11,rev_stars)
);

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

