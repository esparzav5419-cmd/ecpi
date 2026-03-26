-- Valentin Esparza
-- Week 3 - Performance Assessment: ManipulateDBStructure

------------------------------------------------------------
-- Question 1: Move data from STOREFRONT to PRODUCTLIST and drop STOREFRONT
------------------------------------------------------------
ALTER TABLE PRODUCTLIST ADD (PRICE NUMBER(8,2), DESCRIPTION VARCHAR2(250));

UPDATE PRODUCTLIST p
SET PRICE = (SELECT s.PRICE FROM STOREFRONT s WHERE s.PRODUCTCODE = p.PRODUCTCODE),
    DESCRIPTION = (SELECT s.DESCRIPTION FROM STOREFRONT s WHERE s.PRODUCTCODE = p.PRODUCTCODE);

DROP TABLE STOREFRONT;

------------------------------------------------------------
-- Question 2: Create CHATLOG table and insert sample data
------------------------------------------------------------
CREATE TABLE CHATLOG (
    CHATID NUMBER(3) PRIMARY KEY,
    RECEIVERID NUMBER(3),
    SENDERID NUMBER(3),
    DATESENT DATE,
    CONTENT VARCHAR2(250),
    CONSTRAINT fk_chat_receiver FOREIGN KEY (RECEIVERID) REFERENCES USERBASE(USERID),
    CONSTRAINT fk_chat_sender FOREIGN KEY (SENDERID) REFERENCES USERBASE(USERID)
);

INSERT INTO CHATLOG VALUES (1, 101, 102, SYSDATE, 'Hello, welcome!');
INSERT INTO CHATLOG VALUES (2, 102, 101, SYSDATE, 'Thanks!');

------------------------------------------------------------
-- Question 3: Create FRIENDSLIST table and insert sample data
------------------------------------------------------------
CREATE TABLE FRIENDSLIST (
    USERID NUMBER(3),
    FRIENDID NUMBER(3),
    PRIMARY KEY (USERID, FRIENDID),
    CONSTRAINT fk_friend_user FOREIGN KEY (USERID) REFERENCES USERBASE(USERID),
    CONSTRAINT fk_friend_friend FOREIGN KEY (FRIENDID) REFERENCES USERBASE(USERID)
);

INSERT INTO FRIENDSLIST VALUES (101, 102);
INSERT INTO FRIENDSLIST VALUES (101, 103);

------------------------------------------------------------
-- Question 4: Create WISHLIST table and insert sample data
------------------------------------------------------------
CREATE TABLE WISHLIST (
    USERID NUMBER(3),
    PRODUCTCODE VARCHAR2(5),
    POSITION NUMBER(3),
    PRIMARY KEY (USERID, PRODUCTCODE),
    CONSTRAINT fk_wishlist_user FOREIGN KEY (USERID) REFERENCES USERBASE(USERID),
    CONSTRAINT fk_wishlist_product FOREIGN KEY (PRODUCTCODE) REFERENCES PRODUCTLIST(PRODUCTCODE)
);

INSERT INTO WISHLIST VALUES (101, 'P001', 1);
INSERT INTO WISHLIST VALUES (101, 'P002', 2);

------------------------------------------------------------
-- Question 5: Create USERPROFILE table and insert sample data
------------------------------------------------------------
CREATE TABLE USERPROFILE (
    USERID NUMBER(3) PRIMARY KEY,
    IMAGEFILE VARCHAR2(250),
    DESCRIPTION VARCHAR2(250),
    CONSTRAINT fk_profile_user FOREIGN KEY (USERID) REFERENCES USERBASE(USERID)
);

INSERT INTO USERPROFILE VALUES (101, 'C:/images/user101.png', 'Gamer and developer');

------------------------------------------------------------
-- Question 6: Create SECURITYQUESTION table and insert sample data
------------------------------------------------------------
CREATE TABLE SECURITYQUESTION (
    QUESTIONID NUMBER PRIMARY KEY,
    USERID NUMBER(3),
    QUESTION VARCHAR2(250),
    ANSWER VARCHAR2(250),
    CONSTRAINT fk_secq_user FOREIGN KEY (USERID) REFERENCES USERBASE(USERID)
);

INSERT INTO SECURITYQUESTION VALUES (1, 101, 'Mother’s maiden name?', 'Smith');

------------------------------------------------------------
-- Question 7: Create COMMUNITYRULES table and insert sample data
------------------------------------------------------------
CREATE TABLE COMMUNITYRULES (
    RULENUM NUMBER(3) PRIMARY KEY,
    TITLE VARCHAR2(250),
    DESCRIPTION VARCHAR2(250),
    SEVERITYPOINT NUMBER(4)
);

INSERT INTO COMMUNITYRULES VALUES (1, 'No Spamming', 'Do not send unsolicited messages', 10);
INSERT INTO COMMUNITYRULES VALUES (2, 'No Harassment', 'Do not harass or bully other users', 20);
INSERT INTO COMMUNITYRULES VALUES (3, 'Respect Privacy', 'Do not share personal information of others', 25);
INSERT INTO COMMUNITYRULES VALUES (4, 'No Hate Speech', 'Hate speech or discrimination is not allowed', 30);
INSERT INTO COMMUNITYRULES VALUES (5, 'Appropriate Content', 'Keep all content appropriate and respectful', 15);
INSERT INTO COMMUNITYRULES VALUES (6, 'No Cheating', 'Do not exploit or cheat within the platform', 20);
INSERT INTO COMMUNITYRULES VALUES (7, 'Follow Guidelines', 'Follow all platform rules and guidelines', 10);
INSERT INTO COMMUNITYRULES VALUES (8, 'No Impersonation', 'Do not impersonate other users or staff', 25);
INSERT INTO COMMUNITYRULES VALUES (9, 'Report Issues', 'Report bugs or issues responsibly', 5);
INSERT INTO COMMUNITYRULES VALUES (10, 'No Advertising', 'Do not advertise without permission', 15);
INSERT INTO COMMUNITYRULES VALUES (11, 'Use Appropriate Language', 'Avoid offensive or inappropriate language', 15);
INSERT INTO COMMUNITYRULES VALUES (12, 'No Illegal Activity', 'Do not engage in illegal activities', 30);
INSERT INTO COMMUNITYRULES VALUES (13, 'Respect Moderators', 'Follow instructions from moderators', 10);
INSERT INTO COMMUNITYRULES VALUES (14, 'No Duplicate Accounts', 'Do not create multiple accounts to bypass rules', 20);

------------------------------------------------------------
-- Question 8: Create INFRACTIONS table and insert sample data
------------------------------------------------------------
CREATE TABLE INFRACTIONS (
    INFRACTIONID NUMBER PRIMARY KEY,
    USERID NUMBER(3),
    RULENUM NUMBER(3),
    DATEASSIGNED DATE,
    PENALTY VARCHAR2(250),
    CONSTRAINT fk_infraction_user FOREIGN KEY (USERID) REFERENCES USERBASE(USERID),
    CONSTRAINT fk_infraction_rule FOREIGN KEY (RULENUM) REFERENCES COMMUNITYRULES(RULENUM)
);

INSERT INTO INFRACTIONS VALUES (1, 101, 1, SYSDATE, 'Warning');

------------------------------------------------------------
-- Question 9: Create USERSUPPORT table and insert sample data
------------------------------------------------------------
CREATE TABLE USERSUPPORT (
    TICKETID NUMBER PRIMARY KEY,
    EMAIL VARCHAR2(250),
    ISSUE VARCHAR2(250),
    DATESUBMITTED DATE,
    DATEUPDATED DATE,
    STATUS VARCHAR2(250)
);

INSERT INTO USERSUPPORT VALUES (1, 'user101@example.com', 'Cannot log in', SYSDATE, SYSDATE, 'NEW');
INSERT INTO USERSUPPORT VALUES (2, 'user102@example.com', 'Forgot password', SYSDATE, SYSDATE, 'NEW');
INSERT INTO USERSUPPORT VALUES (3, 'user103@example.com', 'App crashing on launch', SYSDATE, SYSDATE, 'IN PROGRESS');
INSERT INTO USERSUPPORT VALUES (4, 'user104@example.com', 'Unable to update profile', SYSDATE, SYSDATE, 'NEW');
INSERT INTO USERSUPPORT VALUES (5, 'user105@example.com', 'Payment not going through', SYSDATE, SYSDATE, 'IN PROGRESS');
INSERT INTO USERSUPPORT VALUES (6, 'user106@example.com', 'Error loading dashboard', SYSDATE, SYSDATE, 'CLOSED');
INSERT INTO USERSUPPORT VALUES (7, 'user107@example.com', 'Account locked', SYSDATE, SYSDATE, 'NEW');
INSERT INTO USERSUPPORT VALUES (8, 'user108@example.com', 'Missing purchase history', SYSDATE, SYSDATE, 'IN PROGRESS');
INSERT INTO USERSUPPORT VALUES (9, 'user109@example.com', 'Slow performance', SYSDATE, SYSDATE, 'CLOSED');
INSERT INTO USERSUPPORT VALUES (10, 'user110@example.com', 'Bug in messaging feature', SYSDATE, SYSDATE, 'NEW');
INSERT INTO USERSUPPORT VALUES (11, 'user111@example.com', 'Unable to upload image', SYSDATE, SYSDATE, 'IN PROGRESS');
INSERT INTO USERSUPPORT VALUES (12, 'user112@example.com', 'Notification not working', SYSDATE, SYSDATE, 'CLOSED');
INSERT INTO USERSUPPORT VALUES (13, 'user113@example.com', 'Incorrect billing amount', SYSDATE, SYSDATE, 'NEW');
INSERT INTO USERSUPPORT VALUES (14, 'user114@example.com', 'Feature request: dark mode', SYSDATE, SYSDATE, 'IN PROGRESS');

------------------------------------------------------------
-- Question 10: Create required views
------------------------------------------------------------

CREATE VIEW vw_unique_questions AS
SELECT DISTINCT question
FROM SECURITYQUESTION;

CREATE VIEW vw_active_tickets AS
SELECT ticketid, email, issue, dateupdated
FROM USERSUPPORT
WHERE status IN ('NEW', 'IN PROGRESS')
ORDER BY dateupdated;