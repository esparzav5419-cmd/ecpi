-- Valentin Esparza

-- 1. Display every USERNAME and the lowest RATING they have left in a review.
SELECT u.USERNAME,
       MIN(r.RATING) AS lowest_rating
FROM USERS u
JOIN REVIEWS r ON u.USERID = r.USERID
GROUP BY u.USERNAME;

-- 2. Display every user’s EMAIL, QUESTION, and ANSWER.
SELECT u.EMAIL,
       s.QUESTION,
       s.ANSWER
FROM USERS u
JOIN SECURITYQA s ON u.USERID = s.USERID;

-- 3. Display users without a wishlist.
SELECT u.FIRSTNAME,
       u.EMAIL,
       u.WALLETFUNDS
FROM USERS u
LEFT JOIN WISHLIST w ON u.USERID = w.USERID
WHERE w.USERID IS NULL;

-- 4. Display every USERNAME and number of products ordered.
SELECT u.USERNAME,
       COUNT(o.PRODUCTID) AS total_orders
FROM USERS u
JOIN ORDERS o ON u.USERID = o.USERID
GROUP BY u.USERNAME;

-- 5. Display the age of users who ordered in last 6 months.
SELECT DISTINCT FLOOR(MONTHS_BETWEEN(SYSDATE, u.BIRTHDAY)/12) AS age
FROM USERS u
JOIN ORDERS o ON u.USERID = o.USERID
WHERE o.ORDERDATE >= ADD_MONTHS(SYSDATE, -6);

-- 6. Display the user with highest friend count.
SELECT USERNAME,
       BIRTHDAY
FROM USERS
WHERE FRIENDCOUNT = (SELECT MAX(FRIENDCOUNT) FROM USERS);

-- 7. Display products in wishlist.
SELECT p.PRODUCTNAME,
       p.RELEASEDATE,
       p.PRICE,
       p.DESCRIPTION
FROM PRODUCTS p
JOIN WISHLIST w ON p.PRODUCTID = w.PRODUCTID;

-- 8. Display product rating stats.
SELECT p.PRODUCTNAME,
       MAX(r.RATING) AS highest_rating,
       COUNT(r.RATING) AS review_count
FROM PRODUCTS p
JOIN REVIEWS r ON p.PRODUCTID = r.PRODUCTID
GROUP BY p.PRODUCTNAME
ORDER BY highest_rating DESC;

-- 9. Create view for extreme ratings.
CREATE VIEW product_extreme_ratings AS
SELECT p.PRODUCTNAME,
       p.GENRE,
       r.RATING
FROM PRODUCTS p
JOIN REVIEWS r ON p.PRODUCTID = r.PRODUCTID
WHERE r.RATING IN (1, 5)
ORDER BY r.RATING;

-- 10. Count products ordered by genre.
SELECT p.GENRE,
       COUNT(o.PRODUCTID) AS total_orders
FROM PRODUCTS p
JOIN ORDERS o ON p.PRODUCTID = o.PRODUCTID
GROUP BY p.GENRE
ORDER BY p.GENRE;

-- 11. Create publisher stats view.
CREATE VIEW publisher_stats AS
SELECT p.PUBLISHER,
       AVG(p.PRICE) AS avg_price,
       SUM(p.HOURSPLAYED) AS total_hours
FROM PRODUCTS p
GROUP BY p.PUBLISHER;

-- 12. Sum of money spent by publisher.
SELECT p.PUBLISHER,
       SUM(p.PRICE) AS total_spent
FROM PRODUCTS p
JOIN ORDERS o ON p.PRODUCTID = o.PRODUCTID
GROUP BY p.PUBLISHER
ORDER BY total_spent DESC;

-- 13. Active support tickets.
SELECT t.TICKETID,
       u.USERNAME,
       u.EMAIL,
       t.ISSUE
FROM TICKETS t
JOIN USERS u ON t.USERID = u.USERID
WHERE t.STATUS IN ('NEW', 'IN PROGRESS')
ORDER BY t.DATEUPDATED DESC;

-- 14. Ticket count per user.
SELECT u.USERNAME,
       COUNT(t.TICKETID) AS ticket_count
FROM USERS u
JOIN TICKETS t ON u.USERID = t.USERID
GROUP BY u.USERNAME;

-- 15. Emails containing names.
SELECT DISTINCT u.USERID,
       u.EMAIL
FROM USERS u
JOIN TICKETS t ON u.USERID = t.USERID
WHERE LOWER(u.EMAIL) LIKE '%' || LOWER(u.FIRSTNAME) || '%'
   OR LOWER(u.EMAIL) LIKE '%' || LOWER(u.LASTNAME) || '%';

-- 16. Emails not in userbase.
SELECT DISTINCT t.EMAIL
FROM TICKETS t
LEFT JOIN USERS u ON t.EMAIL = u.EMAIL
WHERE t.STATUS IN ('NEW', 'IN PROGRESS')
  AND u.EMAIL IS NULL;

-- 17. Username mentioned in issue.
SELECT t.TICKETID,
       u.FIRSTNAME,
       u.LASTNAME,
       u.USERNAME
FROM USERS u
JOIN TICKETS t
    ON LOWER(t.ISSUE) LIKE '%' || LOWER(u.USERNAME) || '%';

-- 18. Username and password from ticket email.
SELECT u.USERNAME,
       u.PASSWORD
FROM USERS u
JOIN TICKETS t ON u.EMAIL = t.EMAIL;

-- 19. Create view for recent penalties.
CREATE VIEW recent_penalties AS
SELECT u.USERNAME,
       i.DATEASSIGNED,
       i.PENALTY
FROM INFRACTIONS i
JOIN USERS u ON i.USERID = u.USERID
WHERE i.PENALTY IS NOT NULL
  AND i.DATEASSIGNED >= ADD_MONTHS(SYSDATE, -1);

-- 20. Users 18+ without recent infractions.
SELECT u.USERNAME,
       u.EMAIL
FROM USERS u
LEFT JOIN INFRACTIONS i ON u.USERID = i.USERID
    AND i.DATEASSIGNED >= ADD_MONTHS(SYSDATE, -4)
WHERE FLOOR(MONTHS_BETWEEN(SYSDATE, u.BIRTHDAY)/12) >= 18
  AND i.USERID IS NULL;

-- 21. Rule violations.
SELECT u.USERNAME,
       i.DATEASSIGNED,
       r.RULENUM || ' ' || r.TITLE AS guideline
FROM INFRACTIONS i
JOIN USERS u ON i.USERID = u.USERID
JOIN RULES r ON i.RULEID = r.RULEID;

-- 22. Severity points per user.
SELECT u.USERID,
       u.USERNAME,
       u.EMAIL,
       SUM(i.SEVERITYPOINTS) AS total_points
FROM USERS u
JOIN INFRACTIONS i ON u.USERID = i.USERID
GROUP BY u.USERID, u.USERNAME, u.EMAIL;

-- 23. All infractions.
SELECT TITLE,
       DESCRIPTION,
       PENALTY
FROM INFRACTIONS;

-- 24. Users with 15+ infractions.
SELECT u.USERNAME,
       COUNT(i.USERID) AS infraction_count
FROM USERS u
JOIN INFRACTIONS i ON u.USERID = i.USERID
GROUP BY u.USERNAME
HAVING COUNT(i.USERID) >= 15;