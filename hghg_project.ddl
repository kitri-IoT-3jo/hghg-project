
CREATE TABLE APPOINTMENT_MEMBER
(
	appointment_id       NUMBER NOT NULL ,
	member_id            VARCHAR2(20) NOT NULL ,
	check_host           CHAR(1) NOT NULL ,
	member_table_id      NUMBER NOT NULL 
);



CREATE UNIQUE INDEX XPKAPPOINTMENT_MEMBER ON APPOINTMENT_MEMBER
(member_table_id   ASC);



ALTER TABLE APPOINTMENT_MEMBER
	ADD CONSTRAINT  XPKAPPOINTMENT_MEMBER PRIMARY KEY (member_table_id);



CREATE TABLE BOARD
(
	board_id             NUMBER NOT NULL ,
	board_title          VARCHAR2(40) NOT NULL ,
	board_content        CLOB NOT NULL ,
	create_date          DATE NOT NULL ,
	user_id              VARCHAR2(20) NOT NULL ,
	board_enable         CHAR(1) NOT NULL 
);



CREATE UNIQUE INDEX XPKBOARD ON BOARD
(board_id   ASC);



ALTER TABLE BOARD
	ADD CONSTRAINT  XPKBOARD PRIMARY KEY (board_id);



CREATE TABLE COMMENT
(
	comment_id           NUMBER NOT NULL ,
	written_date         DATE NOT NULL ,
	user_id              VARCHAR2(20) NOT NULL ,
	comment_content      VARCHAR2(4000) NOT NULL ,
	board_id             NUMBER NOT NULL ,
	comment_enable       CHAR(1) NOT NULL 
);



CREATE UNIQUE INDEX XPKCOMMENT ON COMMENT
(comment_id   ASC);



ALTER TABLE COMMENT
	ADD CONSTRAINT  XPKCOMMENT PRIMARY KEY (comment_id);



CREATE TABLE RESTAURANT
(
	restaurant_id        NUMBER NOT NULL ,
	restaurant_name      VARCHAR2(40) NOT NULL ,
	restaurant_eval      NUMBER NULL ,
	restaurant_enable    CHAR(1) NOT NULL 
);



CREATE UNIQUE INDEX XPKRESTAURANT ON RESTAURANT
(restaurant_id   ASC);



ALTER TABLE RESTAURANT
	ADD CONSTRAINT  XPKRESTAURANT PRIMARY KEY (restaurant_id);



CREATE TABLE RESTAURANT_APPOINTMENT
(
	appointment_id       NUMBER NOT NULL ,
	appointment_date     DATE NOT NULL ,
	max_people           NUMBER NOT NULL ,
	current_people       NUMBER NOT NULL ,
	restaurant_id        NUMBER NOT NULL ,
	appointment_enable   CHAR(1) NOT NULL ,
	appointment_title    VARCHAR2(40) NOT NULL 
);



CREATE UNIQUE INDEX XPKRESTAURANT_APPOINTMENT ON RESTAURANT_APPOINTMENT
(appointment_id   ASC);



ALTER TABLE RESTAURANT_APPOINTMENT
	ADD CONSTRAINT  XPKRESTAURANT_APPOINTMENT PRIMARY KEY (appointment_id);



CREATE TABLE RESTAURANT_PHOTO
(
	photo_id             NUMBER NOT NULL ,
	restaurant_id        NUMBER NOT NULL 
);



CREATE UNIQUE INDEX XPKRESTAURANT_PHOTO ON RESTAURANT_PHOTO
(photo_id   ASC);



ALTER TABLE RESTAURANT_PHOTO
	ADD CONSTRAINT  XPKRESTAURANT_PHOTO PRIMARY KEY (photo_id);



CREATE TABLE USER
(
	user_id              VARCHAR2(20) NOT NULL ,
	user_pw              VARCHAR2(20) NOT NULL ,
	user_name            VARCHAR2(30) NOT NULL ,
	email_id             VARCHAR2(30) NOT NULL ,
	gender               CHAR(1) NOT NULL ,
	birth_date           DATE NOT NULL ,
	email_domain         VARCHAR2(20) NOT NULL ,
	user_nickname        VARCHAR2(20) NOT NULL ,
	user_enable          CHAR(1) NOT NULL 
);



CREATE UNIQUE INDEX XPKUSER ON USER
(user_id   ASC);



ALTER TABLE USER
	ADD CONSTRAINT  XPKUSER PRIMARY KEY (user_id);



ALTER TABLE APPOINTMENT_MEMBER
	ADD (CONSTRAINT R_8 FOREIGN KEY (appointment_id) REFERENCES RESTAURANT_APPOINTMENT (appointment_id));



ALTER TABLE APPOINTMENT_MEMBER
	ADD (CONSTRAINT R_9 FOREIGN KEY (member_id) REFERENCES USER (user_id));



ALTER TABLE BOARD
	ADD (CONSTRAINT R_1 FOREIGN KEY (user_id) REFERENCES USER (user_id) ON DELETE SET NULL);



ALTER TABLE COMMENT
	ADD (CONSTRAINT R_3 FOREIGN KEY (user_id) REFERENCES USER (user_id) ON DELETE SET NULL);



ALTER TABLE COMMENT
	ADD (CONSTRAINT R_6 FOREIGN KEY (board_id) REFERENCES BOARD (board_id) ON DELETE SET NULL);



ALTER TABLE RESTAURANT_APPOINTMENT
	ADD (CONSTRAINT R_5 FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT (restaurant_id) ON DELETE SET NULL);



ALTER TABLE RESTAURANT_PHOTO
	ADD (CONSTRAINT R_10 FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT (restaurant_id) ON DELETE SET NULL);



CREATE  TRIGGER tI_APPOINTMENT_MEMBER BEFORE INSERT ON APPOINTMENT_MEMBER for each row
-- ERwin Builtin Trigger
-- INSERT trigger on APPOINTMENT_MEMBER 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* RESTAURANT_APPOINTMENT  APPOINTMENT_MEMBER on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0002335d", PARENT_OWNER="", PARENT_TABLE="RESTAURANT_APPOINTMENT"
    CHILD_OWNER="", CHILD_TABLE="APPOINTMENT_MEMBER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="appointment_id" */
    SELECT count(*) INTO NUMROWS
      FROM RESTAURANT_APPOINTMENT
      WHERE
        /* %JoinFKPK(:%New,RESTAURANT_APPOINTMENT," = "," AND") */
        :new.appointment_id = RESTAURANT_APPOINTMENT.appointment_id;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert APPOINTMENT_MEMBER because RESTAURANT_APPOINTMENT does not exist.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* USER  APPOINTMENT_MEMBER on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="USER"
    CHILD_OWNER="", CHILD_TABLE="APPOINTMENT_MEMBER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="member_id" */
    SELECT count(*) INTO NUMROWS
      FROM USER
      WHERE
        /* %JoinFKPK(:%New,USER," = "," AND") */
        :new.member_id = USER.user_id;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert APPOINTMENT_MEMBER because USER does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_APPOINTMENT_MEMBER AFTER UPDATE ON APPOINTMENT_MEMBER for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on APPOINTMENT_MEMBER 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* RESTAURANT_APPOINTMENT  APPOINTMENT_MEMBER on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00021fee", PARENT_OWNER="", PARENT_TABLE="RESTAURANT_APPOINTMENT"
    CHILD_OWNER="", CHILD_TABLE="APPOINTMENT_MEMBER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="appointment_id" */
  SELECT count(*) INTO NUMROWS
    FROM RESTAURANT_APPOINTMENT
    WHERE
      /* %JoinFKPK(:%New,RESTAURANT_APPOINTMENT," = "," AND") */
      :new.appointment_id = RESTAURANT_APPOINTMENT.appointment_id;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update APPOINTMENT_MEMBER because RESTAURANT_APPOINTMENT does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* USER  APPOINTMENT_MEMBER on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="USER"
    CHILD_OWNER="", CHILD_TABLE="APPOINTMENT_MEMBER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="member_id" */
  SELECT count(*) INTO NUMROWS
    FROM USER
    WHERE
      /* %JoinFKPK(:%New,USER," = "," AND") */
      :new.member_id = USER.user_id;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update APPOINTMENT_MEMBER because USER does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_BOARD BEFORE INSERT ON BOARD for each row
-- ERwin Builtin Trigger
-- INSERT trigger on BOARD 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* USER  BOARD on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0000cfec", PARENT_OWNER="", PARENT_TABLE="USER"
    CHILD_OWNER="", CHILD_TABLE="BOARD"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="user_id" */
    UPDATE BOARD
      SET
        /* %SetFK(BOARD,NULL) */
        BOARD.user_id = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM USER
            WHERE
              /* %JoinFKPK(:%New,USER," = "," AND") */
              :new.user_id = USER.user_id
        ) 
        /* %JoinPKPK(BOARD,:%New," = "," AND") */
         and BOARD.board_id = :new.board_id;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER  tD_BOARD AFTER DELETE ON BOARD for each row
-- ERwin Builtin Trigger
-- DELETE trigger on BOARD 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* BOARD  COMMENT on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000adda", PARENT_OWNER="", PARENT_TABLE="BOARD"
    CHILD_OWNER="", CHILD_TABLE="COMMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="board_id" */
    UPDATE COMMENT
      SET
        /* %SetFK(COMMENT,NULL) */
        COMMENT.board_id = NULL
      WHERE
        /* %JoinFKPK(COMMENT,:%Old," = "," AND") */
        COMMENT.board_id = :old.board_id;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_BOARD AFTER UPDATE ON BOARD for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on BOARD 
DECLARE NUMROWS INTEGER;
BEGIN
  /* BOARD  COMMENT on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0001cbfe", PARENT_OWNER="", PARENT_TABLE="BOARD"
    CHILD_OWNER="", CHILD_TABLE="COMMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="board_id" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.board_id <> :new.board_id
  THEN
    UPDATE COMMENT
      SET
        /* %SetFK(COMMENT,NULL) */
        COMMENT.board_id = NULL
      WHERE
        /* %JoinFKPK(COMMENT,:%Old," = ",",") */
        COMMENT.board_id = :old.board_id;
  END IF;

  /* ERwin Builtin Trigger */
  /* USER  BOARD on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="USER"
    CHILD_OWNER="", CHILD_TABLE="BOARD"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="user_id" */
  SELECT count(*) INTO NUMROWS
    FROM USER
    WHERE
      /* %JoinFKPK(:%New,USER," = "," AND") */
      :new.user_id = USER.user_id;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.user_id IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update BOARD because USER does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_COMMENT BEFORE INSERT ON COMMENT for each row
-- ERwin Builtin Trigger
-- INSERT trigger on COMMENT 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* USER  COMMENT on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0001d000", PARENT_OWNER="", PARENT_TABLE="USER"
    CHILD_OWNER="", CHILD_TABLE="COMMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="user_id" */
    UPDATE COMMENT
      SET
        /* %SetFK(COMMENT,NULL) */
        COMMENT.user_id = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM USER
            WHERE
              /* %JoinFKPK(:%New,USER," = "," AND") */
              :new.user_id = USER.user_id
        ) 
        /* %JoinPKPK(COMMENT,:%New," = "," AND") */
         and COMMENT.comment_id = :new.comment_id;

    /* ERwin Builtin Trigger */
    /* BOARD  COMMENT on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="BOARD"
    CHILD_OWNER="", CHILD_TABLE="COMMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="board_id" */
    UPDATE COMMENT
      SET
        /* %SetFK(COMMENT,NULL) */
        COMMENT.board_id = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM BOARD
            WHERE
              /* %JoinFKPK(:%New,BOARD," = "," AND") */
              :new.board_id = BOARD.board_id
        ) 
        /* %JoinPKPK(COMMENT,:%New," = "," AND") */
         and COMMENT.comment_id = :new.comment_id;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_COMMENT AFTER UPDATE ON COMMENT for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on COMMENT 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* USER  COMMENT on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0001e7a4", PARENT_OWNER="", PARENT_TABLE="USER"
    CHILD_OWNER="", CHILD_TABLE="COMMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="user_id" */
  SELECT count(*) INTO NUMROWS
    FROM USER
    WHERE
      /* %JoinFKPK(:%New,USER," = "," AND") */
      :new.user_id = USER.user_id;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.user_id IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update COMMENT because USER does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* BOARD  COMMENT on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="BOARD"
    CHILD_OWNER="", CHILD_TABLE="COMMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="board_id" */
  SELECT count(*) INTO NUMROWS
    FROM BOARD
    WHERE
      /* %JoinFKPK(:%New,BOARD," = "," AND") */
      :new.board_id = BOARD.board_id;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.board_id IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update COMMENT because BOARD does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_RESTAURANT AFTER DELETE ON RESTAURANT for each row
-- ERwin Builtin Trigger
-- DELETE trigger on RESTAURANT 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* RESTAURANT  RESTAURANT_APPOINTMENT on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0001df0a", PARENT_OWNER="", PARENT_TABLE="RESTAURANT"
    CHILD_OWNER="", CHILD_TABLE="RESTAURANT_APPOINTMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="restaurant_id" */
    UPDATE RESTAURANT_APPOINTMENT
      SET
        /* %SetFK(RESTAURANT_APPOINTMENT,NULL) */
        RESTAURANT_APPOINTMENT.restaurant_id = NULL
      WHERE
        /* %JoinFKPK(RESTAURANT_APPOINTMENT,:%Old," = "," AND") */
        RESTAURANT_APPOINTMENT.restaurant_id = :old.restaurant_id;

    /* ERwin Builtin Trigger */
    /* RESTAURANT  RESTAURANT_PHOTO on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RESTAURANT"
    CHILD_OWNER="", CHILD_TABLE="RESTAURANT_PHOTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="restaurant_id" */
    UPDATE RESTAURANT_PHOTO
      SET
        /* %SetFK(RESTAURANT_PHOTO,NULL) */
        RESTAURANT_PHOTO.restaurant_id = NULL
      WHERE
        /* %JoinFKPK(RESTAURANT_PHOTO,:%Old," = "," AND") */
        RESTAURANT_PHOTO.restaurant_id = :old.restaurant_id;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_RESTAURANT AFTER UPDATE ON RESTAURANT for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on RESTAURANT 
DECLARE NUMROWS INTEGER;
BEGIN
  /* RESTAURANT  RESTAURANT_APPOINTMENT on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00021e0e", PARENT_OWNER="", PARENT_TABLE="RESTAURANT"
    CHILD_OWNER="", CHILD_TABLE="RESTAURANT_APPOINTMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="restaurant_id" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.restaurant_id <> :new.restaurant_id
  THEN
    UPDATE RESTAURANT_APPOINTMENT
      SET
        /* %SetFK(RESTAURANT_APPOINTMENT,NULL) */
        RESTAURANT_APPOINTMENT.restaurant_id = NULL
      WHERE
        /* %JoinFKPK(RESTAURANT_APPOINTMENT,:%Old," = ",",") */
        RESTAURANT_APPOINTMENT.restaurant_id = :old.restaurant_id;
  END IF;

  /* RESTAURANT  RESTAURANT_PHOTO on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RESTAURANT"
    CHILD_OWNER="", CHILD_TABLE="RESTAURANT_PHOTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="restaurant_id" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.restaurant_id <> :new.restaurant_id
  THEN
    UPDATE RESTAURANT_PHOTO
      SET
        /* %SetFK(RESTAURANT_PHOTO,NULL) */
        RESTAURANT_PHOTO.restaurant_id = NULL
      WHERE
        /* %JoinFKPK(RESTAURANT_PHOTO,:%Old," = ",",") */
        RESTAURANT_PHOTO.restaurant_id = :old.restaurant_id;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_RESTAURANT_APPOINTMENT BEFORE INSERT ON RESTAURANT_APPOINTMENT for each row
-- ERwin Builtin Trigger
-- INSERT trigger on RESTAURANT_APPOINTMENT 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* RESTAURANT  RESTAURANT_APPOINTMENT on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="000122d2", PARENT_OWNER="", PARENT_TABLE="RESTAURANT"
    CHILD_OWNER="", CHILD_TABLE="RESTAURANT_APPOINTMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="restaurant_id" */
    UPDATE RESTAURANT_APPOINTMENT
      SET
        /* %SetFK(RESTAURANT_APPOINTMENT,NULL) */
        RESTAURANT_APPOINTMENT.restaurant_id = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM RESTAURANT
            WHERE
              /* %JoinFKPK(:%New,RESTAURANT," = "," AND") */
              :new.restaurant_id = RESTAURANT.restaurant_id
        ) 
        /* %JoinPKPK(RESTAURANT_APPOINTMENT,:%New," = "," AND") */
         and RESTAURANT_APPOINTMENT.appointment_id = :new.appointment_id;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER  tD_RESTAURANT_APPOINTMENT AFTER DELETE ON RESTAURANT_APPOINTMENT for each row
-- ERwin Builtin Trigger
-- DELETE trigger on RESTAURANT_APPOINTMENT 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* RESTAURANT_APPOINTMENT  APPOINTMENT_MEMBER on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00010f4f", PARENT_OWNER="", PARENT_TABLE="RESTAURANT_APPOINTMENT"
    CHILD_OWNER="", CHILD_TABLE="APPOINTMENT_MEMBER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="appointment_id" */
    SELECT count(*) INTO NUMROWS
      FROM APPOINTMENT_MEMBER
      WHERE
        /*  %JoinFKPK(APPOINTMENT_MEMBER,:%Old," = "," AND") */
        APPOINTMENT_MEMBER.appointment_id = :old.appointment_id;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete RESTAURANT_APPOINTMENT because APPOINTMENT_MEMBER exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_RESTAURANT_APPOINTMENT AFTER UPDATE ON RESTAURANT_APPOINTMENT for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on RESTAURANT_APPOINTMENT 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* RESTAURANT_APPOINTMENT  APPOINTMENT_MEMBER on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00025bc6", PARENT_OWNER="", PARENT_TABLE="RESTAURANT_APPOINTMENT"
    CHILD_OWNER="", CHILD_TABLE="APPOINTMENT_MEMBER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="appointment_id" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.appointment_id <> :new.appointment_id
  THEN
    SELECT count(*) INTO NUMROWS
      FROM APPOINTMENT_MEMBER
      WHERE
        /*  %JoinFKPK(APPOINTMENT_MEMBER,:%Old," = "," AND") */
        APPOINTMENT_MEMBER.appointment_id = :old.appointment_id;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update RESTAURANT_APPOINTMENT because APPOINTMENT_MEMBER exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* RESTAURANT  RESTAURANT_APPOINTMENT on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RESTAURANT"
    CHILD_OWNER="", CHILD_TABLE="RESTAURANT_APPOINTMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="restaurant_id" */
  SELECT count(*) INTO NUMROWS
    FROM RESTAURANT
    WHERE
      /* %JoinFKPK(:%New,RESTAURANT," = "," AND") */
      :new.restaurant_id = RESTAURANT.restaurant_id;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.restaurant_id IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update RESTAURANT_APPOINTMENT because RESTAURANT does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_RESTAURANT_PHOTO BEFORE INSERT ON RESTAURANT_PHOTO for each row
-- ERwin Builtin Trigger
-- INSERT trigger on RESTAURANT_PHOTO 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* RESTAURANT  RESTAURANT_PHOTO on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00010891", PARENT_OWNER="", PARENT_TABLE="RESTAURANT"
    CHILD_OWNER="", CHILD_TABLE="RESTAURANT_PHOTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="restaurant_id" */
    UPDATE RESTAURANT_PHOTO
      SET
        /* %SetFK(RESTAURANT_PHOTO,NULL) */
        RESTAURANT_PHOTO.restaurant_id = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM RESTAURANT
            WHERE
              /* %JoinFKPK(:%New,RESTAURANT," = "," AND") */
              :new.restaurant_id = RESTAURANT.restaurant_id
        ) 
        /* %JoinPKPK(RESTAURANT_PHOTO,:%New," = "," AND") */
         and RESTAURANT_PHOTO.photo_id = :new.photo_id;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_RESTAURANT_PHOTO AFTER UPDATE ON RESTAURANT_PHOTO for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on RESTAURANT_PHOTO 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* RESTAURANT  RESTAURANT_PHOTO on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0001106b", PARENT_OWNER="", PARENT_TABLE="RESTAURANT"
    CHILD_OWNER="", CHILD_TABLE="RESTAURANT_PHOTO"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="restaurant_id" */
  SELECT count(*) INTO NUMROWS
    FROM RESTAURANT
    WHERE
      /* %JoinFKPK(:%New,RESTAURANT," = "," AND") */
      :new.restaurant_id = RESTAURANT.restaurant_id;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.restaurant_id IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update RESTAURANT_PHOTO because RESTAURANT does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_USER AFTER DELETE ON USER for each row
-- ERwin Builtin Trigger
-- DELETE trigger on USER 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* USER  BOARD on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00025e8c", PARENT_OWNER="", PARENT_TABLE="USER"
    CHILD_OWNER="", CHILD_TABLE="BOARD"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="user_id" */
    UPDATE BOARD
      SET
        /* %SetFK(BOARD,NULL) */
        BOARD.user_id = NULL
      WHERE
        /* %JoinFKPK(BOARD,:%Old," = "," AND") */
        BOARD.user_id = :old.user_id;

    /* ERwin Builtin Trigger */
    /* USER  COMMENT on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="USER"
    CHILD_OWNER="", CHILD_TABLE="COMMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="user_id" */
    UPDATE COMMENT
      SET
        /* %SetFK(COMMENT,NULL) */
        COMMENT.user_id = NULL
      WHERE
        /* %JoinFKPK(COMMENT,:%Old," = "," AND") */
        COMMENT.user_id = :old.user_id;

    /* ERwin Builtin Trigger */
    /* USER  APPOINTMENT_MEMBER on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="USER"
    CHILD_OWNER="", CHILD_TABLE="APPOINTMENT_MEMBER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="member_id" */
    SELECT count(*) INTO NUMROWS
      FROM APPOINTMENT_MEMBER
      WHERE
        /*  %JoinFKPK(APPOINTMENT_MEMBER,:%Old," = "," AND") */
        APPOINTMENT_MEMBER.member_id = :old.user_id;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete USER because APPOINTMENT_MEMBER exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_USER AFTER UPDATE ON USER for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on USER 
DECLARE NUMROWS INTEGER;
BEGIN
  /* USER  BOARD on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0002c3b6", PARENT_OWNER="", PARENT_TABLE="USER"
    CHILD_OWNER="", CHILD_TABLE="BOARD"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="user_id" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.user_id <> :new.user_id
  THEN
    UPDATE BOARD
      SET
        /* %SetFK(BOARD,NULL) */
        BOARD.user_id = NULL
      WHERE
        /* %JoinFKPK(BOARD,:%Old," = ",",") */
        BOARD.user_id = :old.user_id;
  END IF;

  /* USER  COMMENT on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="USER"
    CHILD_OWNER="", CHILD_TABLE="COMMENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="user_id" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.user_id <> :new.user_id
  THEN
    UPDATE COMMENT
      SET
        /* %SetFK(COMMENT,NULL) */
        COMMENT.user_id = NULL
      WHERE
        /* %JoinFKPK(COMMENT,:%Old," = ",",") */
        COMMENT.user_id = :old.user_id;
  END IF;

  /* ERwin Builtin Trigger */
  /* USER  APPOINTMENT_MEMBER on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="USER"
    CHILD_OWNER="", CHILD_TABLE="APPOINTMENT_MEMBER"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="member_id" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.user_id <> :new.user_id
  THEN
    SELECT count(*) INTO NUMROWS
      FROM APPOINTMENT_MEMBER
      WHERE
        /*  %JoinFKPK(APPOINTMENT_MEMBER,:%Old," = "," AND") */
        APPOINTMENT_MEMBER.member_id = :old.user_id;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update USER because APPOINTMENT_MEMBER exists.'
      );
    END IF;
  END IF;


-- ERwin Builtin Trigger
END;
/

