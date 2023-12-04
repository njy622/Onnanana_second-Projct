
/* Drop Triggers */

-- DROP TRIGGER TRI_anniversary_aid;
-- DROP TRIGGER TRI_schedule_sid;



/* Drop Tables */

-- DROP TABLE anniversary CASCADE CONSTRAINTS;
-- DROP TABLE schedule CASCADE CONSTRAINTS;
-- DROP TABLE users CASCADE CONSTRAINTS;



/* Drop Sequences */

-- DROP SEQUENCE SEQ_anniversary_aid;
-- DROP SEQUENCE SEQ_schedule_sid;




/* Create Sequences */

CREATE SEQUENCE SEQ_anniversary_aid INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE SEQ_schedule_sid INCREMENT BY 1 START WITH 1;



/* Create Tables */

CREATE TABLE anniversary
(
	aid number NOT NULL,
	"uid" varchar2(12),
	aname varchar2(32) NOT NULL,
	adate char(8) NOT NULL,
	isHoliday number DEFAULT 0 NOT NULL,
	PRIMARY KEY (aid)
);


CREATE TABLE schedule
(
	sid number NOT NULL,
	"uid" varchar2(12),
	sdate char(8) NOT NULL,
	title varchar2(40) NOT NULL,
	place varchar2(40),
	startTime timestamp NOT NULL,
	endTime timestamp,
	isImportant number DEFAULT 0,
	memo varchar2(80),
	PRIMARY KEY (sid)
);


-- CREATE TABLE users
-- (
-- 	"uid" varchar2(12) NOT NULL,
-- 	pwd char(60) NOT NULL,
-- 	uname varchar2(16) NOT NULL,
-- 	email varchar2(40) NOT NULL,
-- 	regDate date DEFAULT SYSDATE,
-- 	isDeleted number DEFAULT 0,
-- 	PRIMARY KEY ("uid")
-- );



/* Create Foreign Keys */

ALTER TABLE anniversary
	ADD FOREIGN KEY ("uid")
	REFERENCES users ("uid")
;


ALTER TABLE schedule
	ADD FOREIGN KEY ("uid")
	REFERENCES users ("uid")
;



/* Create Triggers */

CREATE OR REPLACE TRIGGER TRI_anniversary_aid BEFORE INSERT ON anniversary
FOR EACH ROW
BEGIN
	SELECT SEQ_anniversary_aid.nextval
	INTO :new.aid
	FROM dual;
END;

/

CREATE OR REPLACE TRIGGER TRI_schedule_sid BEFORE INSERT ON schedule
FOR EACH ROW
BEGIN
	SELECT SEQ_schedule_sid.nextval
	INTO :new.sid
	FROM dual;
END;

/




