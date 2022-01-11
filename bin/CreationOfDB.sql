--The script for creating the database
CREATE TABLE ensemble (
 id INT NOT NULL,
 minimum_nbr INT NOT NULL,
 maximum_nbr INT,
 price DECIMAL(10),
 spots_left INT
);

ALTER TABLE ensemble ADD CONSTRAINT PK_ensemble PRIMARY KEY (id);


CREATE TABLE group_lesson (
 id INT NOT NULL,
 minimum_nbr INT NOT NULL,
 maximum_nbr INT,
 skill_level VARCHAR(100),
 price DECIMAL(10),
 spots_left INT
);

ALTER TABLE group_lesson ADD CONSTRAINT PK_group_lesson PRIMARY KEY (id);


CREATE TABLE individual_lesson (
 id INT NOT NULL,
 skill_level VARCHAR(100),
 price DECIMAL(10)
);

ALTER TABLE individual_lesson ADD CONSTRAINT PK_individual_lesson PRIMARY KEY (id);


CREATE TABLE instrument (
 id INT NOT NULL,
 type VARCHAR(500) NOT NULL,
 nbr_in_stock INT,
 rented INT,
 brand VARCHAR(500),
 price DECIMAL(10)
);

ALTER TABLE instrument ADD CONSTRAINT PK_instrument PRIMARY KEY (id);


CREATE TABLE person_detail (
 id INT NOT NULL,
 person_nbr VARCHAR(12) NOT NULL,
 first_name VARCHAR(500),
 last_name VARCHAR(500),
 age INT,
 address VARCHAR(1500)
);

ALTER TABLE person_detail ADD CONSTRAINT PK_person_detail PRIMARY KEY (id);


CREATE TABLE phone (
 phone VARCHAR(500) NOT NULL,
 person_detail_id INT NOT NULL
);

ALTER TABLE phone ADD CONSTRAINT PK_phone PRIMARY KEY (phone,person_detail_id);


CREATE TABLE email (
 email  VARCHAR(500) NOT NULL,
 person_detail_id INT NOT NULL
);

ALTER TABLE email ADD CONSTRAINT PK_email PRIMARY KEY (email ,person_detail_id);


CREATE TABLE enrollment_submission (
 id INT NOT NULL,
 skill_level VARCHAR(100),
 enrollment_decision VARCHAR(500),
 submission_time TIMESTAMP(6) NOT NULL,
 parent_name VARCHAR(500),
 person_detail_id INT NOT NULL
);

ALTER TABLE enrollment_submission ADD CONSTRAINT PK_enrollment_submission PRIMARY KEY (id);


CREATE TABLE instructor (
 id INT NOT NULL,
 ensemble_yes_or_no VARCHAR(100),
 person_detail_id INT NOT NULL
);

ALTER TABLE instructor ADD CONSTRAINT PK_instructor PRIMARY KEY (id);


CREATE TABLE instructor_payment (
 instructor_id INT NOT NULL,
 amount DECIMAL(10),
 month VARCHAR(500) NOT NULL
);

ALTER TABLE instructor_payment ADD CONSTRAINT PK_instructor_payment PRIMARY KEY (instructor_id);


CREATE TABLE phone_parent (
 phone_parent VARCHAR(500) NOT NULL,
 enrollment_submission_id INT NOT NULL
);

ALTER TABLE phone_parent ADD CONSTRAINT PK_phone_parent PRIMARY KEY (phone_parent,enrollment_submission_id);


CREATE TABLE student (
 id INT NOT NULL,
 enrollment_date DATE NOT NULL,
 nbr_of_instrument_rented INT,
 instrument_lease_id INT NOT NULL,
 enrollment_submission_id INT NOT NULL
);

ALTER TABLE student ADD CONSTRAINT PK_student PRIMARY KEY (id);


CREATE TABLE student_student (
 student_id_1 INT NOT NULL,
 student_id_2 INT NOT NULL
);

ALTER TABLE student_student ADD CONSTRAINT PK_student_student PRIMARY KEY (student_id_1,student_id_2);


CREATE TABLE class_type (
 id INT NOT NULL,
 type_of_instrument/genre  VARCHAR(500) NOT NULL,
 instrument_or_ensemble VARCHAR(100) NOT NULL,
 start_time TIMESTAMP(10) NOT NULL,
 end_time TIMESTAMP(10) NOT NULL,
 group_lesson_id INT,
 individual_lesson_id INT,
 ensemble_id INT,
 instructor_id INT NOT NULL
);

ALTER TABLE class_type ADD CONSTRAINT PK_class_type PRIMARY KEY (id);


CREATE TABLE eligible_instrument (
 eligible_instrument VARCHAR(500) NOT NULL,
 instructor_id INT NOT NULL
);

ALTER TABLE eligible_instrument ADD CONSTRAINT PK_eligible_instrument PRIMARY KEY (eligible_instrument,instructor_id);


CREATE TABLE instrument_lease (
 instrument_id INT NOT NULL,
 student_id INT NOT NULL,
 start_month DATE NOT NULL,
 end_month DATE NOT NULL,
 active_rental VARCHAR(100) NOT NULL
);

ALTER TABLE instrument_lease ADD CONSTRAINT PK_instrument_lease PRIMARY KEY (instrument_id,student_id);


CREATE TABLE monthly_bill (
 student_id INT NOT NULL,
 discount DECIMAL(10),
 total_amount DECIMAL(10),
 month VARCHAR(500) NOT NULL
);

ALTER TABLE monthly_bill ADD CONSTRAINT PK_monthly_bill PRIMARY KEY (student_id);


CREATE TABLE student_class_type (
 student_id INT NOT NULL,
 class_type_id INT NOT NULL
);

ALTER TABLE student_class_type ADD CONSTRAINT PK_student_class_type PRIMARY KEY (student_id,class_type_id);


ALTER TABLE phone ADD CONSTRAINT FK_phone_0 FOREIGN KEY (person_detail_id) REFERENCES person_detail (id);


ALTER TABLE email ADD CONSTRAINT FK_email_0 FOREIGN KEY (person_detail_id) REFERENCES person_detail (id);


ALTER TABLE enrollment_submission ADD CONSTRAINT FK_enrollment_submission_0 FOREIGN KEY (person_detail_id) REFERENCES person_detail (id);


ALTER TABLE instructor ADD CONSTRAINT FK_instructor_0 FOREIGN KEY (person_detail_id) REFERENCES person_detail (id);


ALTER TABLE instructor_payment ADD CONSTRAINT FK_instructor_payment_0 FOREIGN KEY (instructor_id) REFERENCES instructor (id);


ALTER TABLE phone_parent ADD CONSTRAINT FK_phone_parent_0 FOREIGN KEY (enrollment_submission_id) REFERENCES enrollment_submission (id);


ALTER TABLE student ADD CONSTRAINT FK_student_0 FOREIGN KEY (enrollment_submission_id) REFERENCES enrollment_submission (id);


ALTER TABLE student_student ADD CONSTRAINT FK_student_student_0 FOREIGN KEY (student_id_1) REFERENCES student (id);
ALTER TABLE student_student ADD CONSTRAINT FK_student_student_1 FOREIGN KEY (student_id_2) REFERENCES student (id);


ALTER TABLE class_type ADD CONSTRAINT FK_class_type_0 FOREIGN KEY (group_lesson_id) REFERENCES group_lesson (id);
ALTER TABLE class_type ADD CONSTRAINT FK_class_type_1 FOREIGN KEY (individual_lesson_id) REFERENCES individual_lesson (id);
ALTER TABLE class_type ADD CONSTRAINT FK_class_type_2 FOREIGN KEY (ensemble_id) REFERENCES ensemble (id);
ALTER TABLE class_type ADD CONSTRAINT FK_class_type_3 FOREIGN KEY (instructor_id) REFERENCES instructor (id);


ALTER TABLE eligible_instrument ADD CONSTRAINT FK_eligible_instrument_0 FOREIGN KEY (instructor_id) REFERENCES instructor (id);


ALTER TABLE instrument_lease ADD CONSTRAINT FK_instrument_lease_0 FOREIGN KEY (instrument_id) REFERENCES instrument (id);
ALTER TABLE instrument_lease ADD CONSTRAINT FK_instrument_lease_1 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE monthly_bill ADD CONSTRAINT FK_monthly_bill_0 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE student_class_type ADD CONSTRAINT FK_student_class_type_0 FOREIGN KEY (student_id) REFERENCES student (id);
ALTER TABLE student_class_type ADD CONSTRAINT FK_student_class_type_1 FOREIGN KEY (class_type_id) REFERENCES class_type (id);

