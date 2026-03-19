-- Valentin Esparza

-- Q1: Check which users have access to the database
SELECT USER_ID, USERNAME, CREATED, PASSWORD_CHANGE_DATE
FROM USER_USERS;

-- Q2: Check what tables are present in the database
SELECT *
FROM USER_TABLES;

-- Q3a: Describe the ORDERS table
DESCRIBE ORDERS;

-- Q3b: Describe the PRODUCTLIST table
DESCRIBE PRODUCTLIST;

-- Q3c: Describe the REVIEWS table
DESCRIBE REVIEWS;

-- Q3d: Describe the STOREFRONT table
DESCRIBE STOREFRONT;

-- Q3e: Describe the USERBASE table
DESCRIBE USERBASE;

-- Q3f: Describe the USERLIBRARY table
DESCRIBE USERLIBRARY;

-- Q4a: Display all data in the ORDERS table
SELECT *
FROM ORDERS;

-- Q4b: Display all data in the PRODUCTLIST table
SELECT *
FROM PRODUCTLIST;

-- Q4c: Display all data in the REVIEWS table
SELECT *
FROM REVIEWS;

-- Q4d: Display all data in the STOREFRONT table
SELECT *
FROM STOREFRONT;

-- Q4e: Display all data in the USERBASE table
SELECT *
FROM USERBASE;

-- Q4f: Display all data in the USERLIBRARY table
SELECT *
FROM USERLIBRARY;

-- Q5: Check constraints present in the database
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE, STATUS
FROM USER_CONSTRAINTS;

-- Q6: Check views present in the database
SELECT VIEW_NAME, TEXT
FROM USER_VIEWS;

-- Q7: Display every USERNAME in alphabetical order
SELECT USERNAME
FROM USERBASE
ORDER BY USERNAME;

-- Q8: Display users with Yahoo email addresses
SELECT FIRSTNAME, LASTNAME, USERNAME, PASSWORD, EMAIL
FROM USERBASE
WHERE LOWER(EMAIL) LIKE '%yahoo%';

-- Q9: Display users with less than $25 in funds
SELECT USERNAME, BIRTHDAY, WALLETFUNDS
FROM USERBASE
WHERE WALLETFUNDS < 25;

-- Q10: Display users with more than 100 HOURSPLAYED
SELECT USERID, PRODUCTCODE
FROM USERLIBRARY
WHERE HOURSPLAYED > 100;

-- Q11: Display games with less than 10 HOURSPLAYED
SELECT PRODUCTCODE
FROM USERLIBRARY
WHERE HOURSPLAYED < 10;

-- Q12: Display every unique PUBLISHER
SELECT DISTINCT PUBLISHER
FROM PRODUCTLIST;

-- Q13: Display product info sorted by GENRE
SELECT PRODUCTNAME, RELEASEDATE, PUBLISHER, GENRE
FROM PRODUCTLIST
ORDER BY GENRE;

-- Q14: Display products in 'Strategy' GENRE
SELECT PRODUCTCODE, PUBLISHER
FROM PRODUCTLIST
WHERE GENRE = 'Strategy';

-- Q15: Display products costing more than $25, descending PRICE
SELECT PRODUCTCODE, DESCRIPTION, PRICE
FROM PRODUCTLIST
WHERE PRICE > 25
ORDER BY PRICE DESC;

-- Q16: Display all storefront inventory sorted by ascending PRICE
SELECT INVENTORYID, PRICE
FROM STOREFRONT
ORDER BY PRICE ASC;

-- Q17: Display products with RATING = 1
SELECT PRODUCTCODE, REVIEW
FROM REVIEWS
WHERE RATING = 1;

-- Q18: Display products with RATING >= 4
SELECT PRODUCTCODE, REVIEW
FROM REVIEWS
WHERE RATING >= 4;

-- Q19: Display unique USERID from orders
SELECT DISTINCT USERID
FROM ORDERS;

-- Q20: Display all orders sorted by earliest PURCHASEDATE
SELECT *
FROM ORDERS
ORDER BY PURCHASEDATE;