/** ******************************************
** Author: Ana Alarcon **
** Created: September 11, 2023 **
** Description: Lab Unit 1 **

****************************************** */




SET ECHO ON

drop table MY_TABLE;
drop view VW_MOVIE_RENTAL;
DROP SEQUENCE seq_movie_id;

spool unit1_lab1.txt
/*1.	Display the structure of the MM_MEMBER table*/
DESC MM_MEMBER;


/*2.	Add yourself as a member*/
INSERT INTO MM_MEMBER(member_id, last, first)
values(15, 'Alarcon', 'Ana');

/*3.	Modify your membership by adding a made-up credit card number.
 Do not use your real-life credit card number*/
UPDATE MM_MEMBER
SET CREDIT_CARD = '666666666666'
WHERE MEMBER_ID = 15;

/*4.	Remove your membership*/
DELETE FROM MM_MEMBER
WHERE member_id = 15;

/*5.	Save your data changes*/
COMMIT;

--6.	Display the title of each movie,
-- the rental ID and the last names of all members who have rented those movies. (2 marks)
SELECT movie_title, rental_id, last
FROM mm_rental rental JOIN  mm_movie movie ON (rental.movie_id = movie.movie_id)
                        JOIN mm_member member  	ON (rental.member_id = member.member_id)
order by 2;

--7.	Display the title of each movie, the rental ID, 
--and the last names of all members who have rented those movies. 
SELECT movie_title, rental_id, last
FROM mm_rental, mm_movie, mm_member
WHERE mm_movie.movie_id = mm_rental.movie_id
    AND mm_rental.member_id = mm_member.member_id;

/*8.	Create a new table called MY_TABLE that is made up of three columns: MY_NUMBER, MY_DATE and MY_STRING,
 and that have data types: NUMBER, DATE and VARCHAR2(5), respectively*/
CREATE TABLE MY_TABLE
    (MY_NUMBER   NUMBER,
    MY_DATE DATE,
    MY_STRING VARCHAR2(5));


/*9.	Create a new sequence called seq_movie_id. 
Have the sequence start at 20 and increment by 2. */
CREATE SEQUENCE seq_movie_id
START with 20
INCREMENT BY 2
NOCACHE
NOCYCLE;


/*10.	Display the sequence information (at least the last number and increment by)
 from the data dictionary’s user_sequences view. */    
SELECT SEQUENCE_NAME, LAST_NUMBER, INCREMENT_BY FROM USER_SEQUENCES
WHERE SEQUENCE_NAME = 'SEQ_MOVIE_ID';

--11.	Use a query to display the next sequence number on the screen. (2 marks)
SELECT SEQ_MOVIE_ID.NEXTVAL FROM DUAL;

--12.	Change the sequence created in Step 9 to increment by 5 instead of 2
ALTER SEQUENCE seq_movie_id
INCREMENT BY 5;

/*13.	Add your favorite movie to the MM_MOVIE table 
using the sequence created in Step 9 for the movie_id. */
--DESC MM_MOVIE;

--SELECT * FROM MM_MOVIE;
--SELECT * from mm_movie_type;
INSERT INTO mm_movie ( movie_id,  movie_title, movie_cat_id, movie_value, movie_qty)
    VALUES(seq_movie_id.NEXTVAL, 'Frozen', 4, 10, 3);

-- 14.	Create a view named VW_MOVIE_RENTAL using the query from either Step 6 or Step 7. 
CREATE OR REPLACE VIEW VW_MOVIE_RENTAL AS
    SELECT movie_title, rental_id, last
    FROM mm_rental rental JOIN  mm_movie movie ON (rental.movie_id = movie.movie_id)
                            JOIN mm_member member  	ON (rental.member_id = member.member_id)
    order by 2;

--15.	Use a query to display the data accessed by the VW_MOVIE_RENTAL view. 
-- Task 15: Display the data accessed by the VW_MOVIE_RENTAL view
SELECT * FROM VW_MOVIE_RENTAL;

--16.	Make the VW_MOVIE_RENTAL view read only
CREATE OR REPLACE VIEW VW_MOVIE_RENTAL AS
    SELECT  movie_title, rental_id, last
    FROM mm_rental, mm_movie, mm_member
    WHERE mm_rental.movie_id = mm_movie.movie_id 
    AND mm_rental.member_id = mm_member.member_id
    WITH READ only;

/*17.	Using the VW_MOVIE_RENTAL view in Step 14, 
change the last name of the member who rented the
 movie with the ID of 2 to Tangier 1. (2 marks)
a.	Why does this UPDATE cause an error?
BECAUSE HAVING THE DISTINCT KEYWORD, or operators such as UNION, MINUS, AVG etc
prevent alter the data in the view.
*/
UPDATE VW_MOVIE_RENTAL
SET last = 'Tangier 1'
WHERE RENTAL_id = 2;


spool OFF
