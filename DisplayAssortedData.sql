-- Valentin Esparza
-- DisplayAssortedData.sql

-- 1. Users with no orders
SELECT userid
FROM userbase
MINUS
SELECT userid
FROM orders;

-- 2. Products with no reviews
SELECT productcode
FROM productlist
MINUS
SELECT productcode
FROM reviews;

-- 3. Adult or Minor
SELECT u.*,
       CASE 
           WHEN (MONTHS_BETWEEN(SYSDATE, u.birthday)/12) >= 18 THEN 'Adult'
           ELSE 'Minor'
       END AS age_group
FROM userbase u;

-- 4. Product pricing category
SELECT p.*,
       CASE 
           WHEN p.price <= 20 THEN 'On Sale'
           ELSE 'Base Price'
       END AS price_status
FROM productlist p;

-- 5. Users who played GAME6 and have a profile image
SELECT userid
FROM userlibrary
WHERE productcode = 'GAME6'
INTERSECT
SELECT userid
FROM userprofile
WHERE profile_image IS NOT NULL;

-- 6. Products in wishlist and reviews with conditions
SELECT productcode
FROM wishlist
WHERE position IN (1,2)
INTERSECT
SELECT productcode
FROM reviews
WHERE rating >= 3;

-- 7. Users with same birthday
SELECT a.username,
       a.birthday,
       b.username
FROM userbase a
JOIN userbase b
    ON a.birthday = b.birthday
   AND a.userid <> b.userid;

-- 8. Cartesian product of userlibrary and wishlist
SELECT *
FROM userlibrary
CROSS JOIN wishlist;

-- 9. Union all users and products
SELECT userid AS id,
       username AS name
FROM userbase
UNION ALL
SELECT productcode,
       productname
FROM productlist;

-- 10. Union all chatlog and userprofile
SELECT userid,
       message AS activity
FROM chatlog
UNION ALL
SELECT userid,
       profile_image
FROM userprofile;

-- 11. Users with no infractions
SELECT username
FROM userbase
MINUS
SELECT username
FROM infractions;

-- 12. Rules not broken
SELECT title,
       description
FROM communityrules
MINUS
SELECT cr.title,
       cr.description
FROM communityrules cr
JOIN infractions i
    ON cr.rulenum = i.rulenum;

-- 13. Users with penalties
SELECT u.username,
       u.email
FROM userbase u
JOIN infractions i
    ON u.userid = i.userid
WHERE i.penalty IS NOT NULL;

-- 14. Same date infraction and support ticket
SELECT i.dateassigned
FROM infractions i
INTERSECT
SELECT us.dateupdated
FROM usersupport us;

-- 15. Rule title and penalty
SELECT title,
       penalty
FROM communityrules;

-- 16. Rule severity category
SELECT cr.*,
       CASE 
           WHEN cr.severitypoints >= 10 THEN 'Bannable'
           ELSE 'Appealable'
       END AS rule_status
FROM communityrules cr;

-- 17. High priority tickets
SELECT us.*,
       CASE 
           WHEN us.status <> 'CLOSED'
                AND us.dateupdated < SYSDATE - 7
           THEN 'High Priority'
           ELSE 'Normal'
       END AS priority
FROM usersupport us;

-- 18. Cartesian product support and infractions
SELECT *
FROM usersupport
CROSS JOIN infractions;

-- 19. Closed tickets same update day
SELECT ticketid,
       dateupdated
FROM usersupport
WHERE status = 'CLOSED'
GROUP BY ticketid, dateupdated
HAVING COUNT(*) > 1;

-- 20. Union all users and infractions
SELECT userid,
       username AS activity
FROM userbase
UNION ALL
SELECT userid,
       penalty
FROM infractions;