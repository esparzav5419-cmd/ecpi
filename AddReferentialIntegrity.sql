-- Valentin Esparza
-- Week 3 - AddReferentialIntegrity

------------------------------------------------------------
-- Question 1: Add foreign key constraints
------------------------------------------------------------
ALTER TABLE ORDERS
ADD CONSTRAINT fk_orders_user
FOREIGN KEY (USERID) REFERENCES USERBASE(USERID);

ALTER TABLE REVIEWS
ADD CONSTRAINT fk_reviews_user
FOREIGN KEY (USERID) REFERENCES USERBASE(USERID);

ALTER TABLE REVIEWS
ADD CONSTRAINT fk_reviews_product
FOREIGN KEY (PRODUCTCODE) REFERENCES PRODUCTLIST(PRODUCTCODE);

ALTER TABLE USERLIBRARY
ADD CONSTRAINT fk_library_user
FOREIGN KEY (USERID) REFERENCES USERBASE(USERID);

ALTER TABLE USERLIBRARY
ADD CONSTRAINT fk_library_product
FOREIGN KEY (PRODUCTCODE) REFERENCES PRODUCTLIST(PRODUCTCODE);

------------------------------------------------------------
-- Question 2: Users 18+ with full name and username
------------------------------------------------------------
SELECT FIRSTNAME || ' ' || LASTNAME AS FULLNAME, USERNAME
FROM USERBASE
WHERE FLOOR(MONTHS_BETWEEN(SYSDATE, DATEOFBIRTH)/12) >= 18;

------------------------------------------------------------
-- Question 3: Max and average username length
------------------------------------------------------------
SELECT MAX(LENGTH(USERNAME)) AS MAX_LENGTH,
       AVG(LENGTH(USERNAME)) AS AVG_LENGTH
FROM USERBASE;

------------------------------------------------------------
-- Question 4: Questions starting with 'What is' or 'What was'
------------------------------------------------------------
SELECT QUESTION
FROM SECURITYQUESTION
WHERE QUESTION LIKE 'What is%' OR QUESTION LIKE 'What was%';

------------------------------------------------------------
-- Question 5: Product reviews summary
------------------------------------------------------------
SELECT PRODUCTCODE,
       MIN(RATING) AS LOWEST_RATING,
       COUNT(*) AS REVIEW_COUNT
FROM REVIEWS
GROUP BY PRODUCTCODE
ORDER BY REVIEW_COUNT DESC;

------------------------------------------------------------
-- Question 6: Products ranked #1 in wishlist
------------------------------------------------------------
SELECT PRODUCTCODE,
       COUNT(*) AS NUM_USERS
FROM WISHLIST
WHERE POSITION = 1
GROUP BY PRODUCTCODE;

------------------------------------------------------------
-- Question 7: Total spent per user
------------------------------------------------------------
SELECT USERID,
       SUM(TOTALAMOUNT) AS TOTAL_SPENT
FROM ORDERS
GROUP BY USERID;

------------------------------------------------------------
-- Question 8: Profit by purchase date
------------------------------------------------------------
SELECT PURCHASEDATE,
       SUM(TOTALAMOUNT) AS TOTAL_PROFIT
FROM ORDERS
GROUP BY PURCHASEDATE
ORDER BY TOTAL_PROFIT DESC;

------------------------------------------------------------
-- Question 9: Top 5 games by playtime
------------------------------------------------------------
SELECT PRODUCTCODE,
       SUM(HOURSPLAYED) AS TOTAL_HOURS
FROM USERLIBRARY
GROUP BY PRODUCTCODE
ORDER BY TOTAL_HOURS DESC
FETCH FIRST 5 ROWS ONLY;

------------------------------------------------------------
-- Question 10: View for infractions per user
------------------------------------------------------------
CREATE VIEW vw_user_infractions AS
SELECT USERID,
       COUNT(*) AS INFRACTION_COUNT
FROM INFRACTIONS
GROUP BY USERID
ORDER BY INFRACTION_COUNT DESC;

------------------------------------------------------------
-- Question 11: View for infractions per rule per user
------------------------------------------------------------
CREATE VIEW vw_user_rule_infractions AS
SELECT USERID,
       RULENUM,
       COUNT(*) AS RULE_COUNT
FROM INFRACTIONS
GROUP BY USERID, RULENUM
ORDER BY USERID;

------------------------------------------------------------
-- Question 12: Penalty counts per rule
------------------------------------------------------------
SELECT RULENUM,
       PENALTY,
       COUNT(*) AS PENALTY_COUNT
FROM INFRACTIONS
GROUP BY RULENUM, PENALTY;

------------------------------------------------------------
-- Question 13: Ticket turnaround stats (CLOSED)
------------------------------------------------------------
SELECT AVG(DATEUPDATED - DATESUBMITTED) AS AVG_TIME,
       MAX(DATEUPDATED - DATESUBMITTED) AS MAX_TIME,
       MIN(DATEUPDATED - DATESUBMITTED) AS MIN_TIME
FROM USERSUPPORT
WHERE STATUS = 'CLOSED';

------------------------------------------------------------
-- Question 14: Duplicate issues (NEW tickets)
------------------------------------------------------------
SELECT EMAIL,
       ISSUE,
       COUNT(*) AS ISSUE_COUNT
FROM USERSUPPORT
WHERE STATUS = 'NEW'
GROUP BY EMAIL, ISSUE, DATESUBMITTED
ORDER BY ISSUE_COUNT;

------------------------------------------------------------
-- Question 15: Users with weak passwords
------------------------------------------------------------
SELECT USERID, FIRSTNAME, LASTNAME, PASSWORD
FROM USERBASE
WHERE LOWER(PASSWORD) LIKE '%' || LOWER(FIRSTNAME) || '%'
   OR LOWER(PASSWORD) LIKE '%' || LOWER(LASTNAME) || '%';

------------------------------------------------------------
-- Question 16: Avg price per publisher
------------------------------------------------------------
SELECT PUBLISHER,
       AVG(PRICE) AS AVG_PRICE
FROM PRODUCTLIST
GROUP BY PUBLISHER
ORDER BY PUBLISHER;

------------------------------------------------------------
-- Question 17: View for discounted older products
------------------------------------------------------------
CREATE VIEW vw_old_products_discount AS
SELECT PRODUCTNAME,
       PRICE * 0.75 AS DISCOUNTED_PRICE
FROM PRODUCTLIST
WHERE RELEASEDATE <= ADD_MONTHS(SYSDATE, -60);

------------------------------------------------------------
-- Question 18: Max and min price by genre
------------------------------------------------------------
SELECT GENRE,
       MAX(PRICE) AS MAX_PRICE,
       MIN(PRICE) AS MIN_PRICE
FROM PRODUCTLIST
GROUP BY GENRE;

------------------------------------------------------------
-- Question 19: View for recent chat messages (last 7 days)
------------------------------------------------------------
CREATE VIEW vw_recent_chatlog AS
SELECT *
FROM CHATLOG
WHERE DATESENT BETWEEN SYSDATE - 7 AND SYSDATE;

------------------------------------------------------------
-- Question 20: View for recent infractions with penalties
------------------------------------------------------------
CREATE VIEW vw_recent_penalties AS
SELECT USERID, DATEASSIGNED, PENALTY
FROM INFRACTIONS
WHERE PENALTY IS NOT NULL
  AND DATEASSIGNED >= ADD_MONTHS(SYSDATE, -1);