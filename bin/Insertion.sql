--The script for inserting data into the database
INSERT  INTO person_detail (
 id  ,
 person_nbr   ,
 first_name  ,
 last_name  ,
 age  ,
 address 
)
VALUES(1, '200502265873', 'Carl','Gunnarsson',16,'Ågatan 12, 11255 STOCKHOLM'),
(2, '196601235512','Bertil','Von Bon', 55, 'Åsvägen 1, 74651 BÅLSTA'),
(3, '196601235512','Erik','Von Bon', 55, 'Åsvägen 2, 74651 BÅLSTA'),
(4, '200685783853','Lisa','Svensson', 15, 'Tjenavägen 2, 11646 Stockholm'),
(5, '200783874823','Karin','Karlsson', 14, 'Kanongatan 2, 29274 Kristianstad'),
(6, '200782342849','Stina','Larsson', 14, 'Hejvägen 2, 11255 Stockholm');

INSERT  INTO instructor (
 id  ,
 ensemble_yes_or_no  ,
 person_detail_id  
)
VALUES(1,'yes',2),
(2,'yes',3),
(3,'yes',3);

INSERT  INTO eligible_instrument (
 instructor_id  ,
 eligible_instrument  
)
VALUES(1, 'Trumpet'),
(2, 'Guitar, Drums');

INSERT  INTO instructor_payment (
 instructor_id  ,
 amount  ,
 month    
)
VALUES(1,30000,'DECEMBER'),
(2, 35000, 'DECEMBER');


INSERT  INTO phone (
 person_detail_id  ,
 phone    
)
VALUES(1, '070-12312399'),
(2, '070-32132122'),
(3, '076-02020112'),
(4, '074-37265203'),
(5, '075-49447378'),
(6, '076-02938487');

INSERT  INTO email (
 person_detail_id  ,
 email     
)
VALUES(1, 'CarlG@gmail.com'),
(2, 'Bertil69@gmail.com'),
(3, 'Erikx99x@gmail.com'),
(4, 'LisaS@gmail.com'),
(5, 'KarinK@gmail.com'),
(6, 'Stinahej@gmail.com');

INSERT  INTO enrollment_submission (
 id  ,
 skill_level  ,
 enrollment_decision  ,
 submission_time   ,
 parent_name  ,
 person_detail_id  
)
VALUES(1,'Beginner','Accepted','2016-06-22 19:10:25-07','Rolf',1 ),
(2,'Advanced','Accepted','2016-06-22 19:10:25-07','Anna',4 ),
(3,'Beginner','Accepted','2016-06-22 19:10:25-07','Paul',5 ),
(4,'Intermediate','Accepted','2016-06-22 19:10:25-07','Sven',6 );



INSERT  INTO student (
 id  ,
 enrollment_date ,
 nbr_of_instrument_rented  ,
 instrument_lease_id  ,
 enrollment_submission_id  
)
VALUES(1, CURRENT_DATE, 1, 1,1),
(2, CURRENT_DATE, 1, 1,2),
(3, CURRENT_DATE, 0, 0,3),
(4, CURRENT_DATE, 0, 0,4);


INSERT  INTO instrument (
 id  ,
 type    ,
 nbr_in_stock  ,
 rented  ,
 brand  ,
 price  
)
VALUES(1,'Saxophone', 3, 1, 'Yamaha', 500),
(2,'Violin', 11, 9, 'Violinbrand', 300),
(3,'Gitarr', 8, 3, 'Gitarrbrand', 250),
(4,'Flute', 20, 0, 'Flutebrand', 100);


INSERT  INTO instrument_lease (
 instrument_id  ,
 start_month   ,
 end_month   ,
 student_id,
 active_rental
)
VALUES(1,'2020-11-01', '2021-02-01', 2, 'No'),
(1,'2020-12-01', '2021-05-01', 3, 'No'),
(2,'2021-11-01', '2022-02-01', 1, 'Yes');


INSERT  INTO monthly_bill (
 student_id  ,
 discount  ,
 total_amount  ,
 month    
)
VALUES(1,1,150, 'DECEMBER');

INSERT  INTO phone_parent (
 enrollment_submission_id  ,
 phone_parent    
)
VALUES(1, '070-12312323');

INSERT  INTO ensemble (
 id  ,
 minimum_nbr  ,
 maximum_nbr  ,
 price  ,
 spots_left
)
VALUES(1, 5, 30, 200, 1),
(2, 5, 20, 200, 2),
(3, 5, 30, 200, 3);

INSERT  INTO group_lesson (
 id  ,
 minimum_nbr  ,
 maximum_nbr  ,
 skill_level  ,
 price  ,
 spots_left
)
VALUES(1,3,8,'Beginner',100,7),
(2,3,8,'Intermediate',150,7),
(3,3,8,'Advanced',200,7);


INSERT  INTO individual_lesson (
 id  ,
 skill_level  ,
 price  
)
VALUES(1,'Beginner', 100),
(2,'Intermediate', 150),
(3,'Advanced', 200);

INSERT  INTO class_type (
 id  ,
 type_of_instrument_or_genre     ,
 instrument_or_ensemble    ,
 start_time   ,
 end_time   ,
 group_lesson_id  ,
 individual_lesson_id  ,
 ensemble_id  ,
 instructor_id  
)
VALUES(1, 'Rock', 'ensemble','2022-01-20 13:00:00-07','2022-01-20 14:00:00-07',NULL,NULL,1,1),
(2, 'Guitar','instrument','2022-01-20 13:00:00-07','2022-01-20 14:00:00-07', 1, NULL, NULL,2),
(3, 'Drums', 'instrument','2022-01-20 15:00:00-07','2022-01-20 16:00:00-07', NULL, 1, NULL,2),
(4, 'Pop', 'ensemble','2021-02-20 13:00:00-07','2021-02-20 14:00:00-07',NULL,NULL,3,1),
(5, 'Piano','instrument','2021-02-20 13:00:00-07','2021-02-20 14:00:00-07', 2, NULL, NULL,2),
(6, 'Singing', 'instrument','2021-02-20 15:00:00-07','2021-02-20 16:00:00-07', NULL, 2, NULL,2),
(7, 'Classical', 'ensemble','2021-03-20 13:00:00-07','2021-03-20 14:00:00-07',NULL,NULL,2,3),
(8, 'Trumpet','instrument','2021-03-20 13:00:00-07','2021-03-20 14:00:00-07', 3, NULL, NULL,3),
(9, 'Violin', 'instrument','2021-03-20 15:00:00-07','2021-03-20 16:00:00-07', NULL, 3, NULL,3);