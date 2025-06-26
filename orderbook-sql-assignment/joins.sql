USE orderbook;

 

-- #1: Display the dateJoined and username for users of the admin role
select `User`.uname,
    `User`.dateJoined,
    `Role`.`name`
from `User`
-- join UserRoles using (userid) 
join UserRoles on UserRoles.userid = `User`.userid -- you can join with on keyword or using
join `Role` using (roleid) -- You can ONLY join with using keyword if it is unambiguous
where `Role`.`name` = 'admin';

 
 

-- #2: Display the top absolute order amount (share*price), status, symbol, trade data, and username.
-- for the past 24 hours. The now and interval function  may be useful.
-- Keep the top 5 results with largest the absolute order net (share*price).
-- Include only orders that were not canceled or partially canceled.
SELECT 
    ABS(shares * price) AS absolute_price, 
    o.`status`,
    o.symbol, 
    o.orderTime,
    u.uname
FROM `Order` o
JOIN `User` u USING (userid)
WHERE o.`status` NOT IN ('canceled', 'canceled_partial_fill')
  AND o.orderTime BETWEEN (NOW() - INTERVAL 1 DAY) AND NOW()
ORDER BY absolute_price DESC
LIMIT 5;


 

-- #3: Display the orderid, symbol, status, order shares, filled shares, and price for orders with fills.
-- Filter out any order placed by a non-admin user
-- Note that filledShares are the opposite sign (+-) because they subtract from ordershares!
select `Order`.orderid,
    `Order`.symbol,
    `Order`.`status`,
    `Order`.shares as order_shares,
    -Fill.`share` as filled_shares, -- adjusted to minus
    `Order`.price
from `Order`
join `User` using (userid)
join UserRoles using (userid)
join `Role` using (roleid)
join Fill using (orderid)
where `Order`.`status`= 'filled'
	and `Role`.`name` = 'admin';
;


-- #4: Display the username and user role for users who have not placed an order.
-- You may need to test this by creating a new user and not placing an order
-- Remember using the  JOIN keyword is same as INNER JOIN
-- and using LEFT or RIGHT keyword is same as LEFT OUTER or RIGHT OUTER
-- adding a direction makes it directionally outer.
select u.uname, r.name
FROM `User` u
inner join UserRoles using (userid) -- inner can be ommitted, by default it is inner
inner join `Role` r using (roleid)
left outer join `Order` using (userid) -- outer can be ommitted, by default directional joins are outer
where `Order`.orderid is null;

-- or with subquery instead of outer join
SELECT  u.uname, r.name
FROM orderbook.`User` u
inner join UserRoles using (userid)
inner join `Role` r using (roleid)
WHERE NOT EXISTS (
    SELECT 1
    FROM orderbook.`Order` o
    WHERE o.userid = u.userid
);


 

 

 

-- #5: Display orderid, username, role, symbol, price, and number of shares for orders with no fills.
-- Remember using the  JOIN keyword is same as INNER JOIN
-- and using LEFT or RIGHT keyword is same as LEFT OUTER or RIGHT OUTER
-- adding a direction makes it directionally outer.
select `Order`.orderid,
    `User`.uname as username,
    `Role`.`name` as role_name,
    `Order`.symbol,
    `Order`.price,
    `Order`.shares
from `Order`
join `User` using (userid)
join UserRoles using (userid)
join `Role` using (roleid)
left join Fill using (orderid)
where Fill.fillid is null;


 

 

-- #6: Display the symbol, username, role, order shares, and product name 
-- where the product name has the word "spdr" anywhere in it.
select `Order`.symbol, 
	`User`.uname as username,
    `Role`.`name` as role_name,
    `Order`.shares,
    `Product`.name
from `Order`
join `User` using (userid)
join UserRoles using (userid)
join `Role` using (roleid)
join Product using (symbol)
where Product.name LIKE '%spdr%'
;


-- #7: Use the UNION keyword to perform a full outer join
-- MySQL does not support full outer joins (some DBMS systems do), UNION is a workaround
-- Union will unite the results of  two queries into one
-- Find all orders and all Fills, whether there is a matching order or not

-- Note, you will need to perform a Left Join, Union, then Right Join
-- First select all Orders and left join fills.
-- Then Select all fills and right join orders. 
-- Fill any potential missing shares values with 0.

SELECT o.orderid, o.shares, IFNULL(f.share, 0) AS filled_shares
FROM `Order` o
LEFT JOIN `Fill` f ON o.orderid = f.orderid

UNION

SELECT o.orderid, IFNULL(o.shares, 0) AS total_shares, f.share
FROM `Fill` f
RIGHT JOIN `Order` o ON f.orderid = o.orderid;
