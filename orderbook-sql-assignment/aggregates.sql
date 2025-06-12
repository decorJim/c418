USE orderbook;


-- #1: How many users do we have?
SELECT DISTINCT COUNT(u.userid) FROM `User` u;


-- #2: List the username, userid, and number of
-- orders each user has placed.
SELECT uname, userid, COUNT(o.orderid) numOrders FROM `User` u
JOIN `Order` o USING(userid)
GROUP BY userid;


-- #3: List the username, symbol, and number of
-- orders placed for each user and for each symbol.
-- Sort results in alphabetical order by symbol.
SELECT u.uname, o.symbol, COUNT(orderid) FROM `User` u 
JOIN `Order` o USING(userid)
GROUP BY u.userid, o.symbol
ORDER BY o.symbol;




-- #4: Perform the same query as the one above,
-- but only include admin users.
SELECT u.uname, o.symbol, COUNT(orderid) orderNum FROM `User` u 
JOIN `Order` o USING(userid)
JOIN UserRoles ur USING(userid)
JOIN Role r USING(roleid)
WHERE r.name = 'admin'
GROUP BY u.userid, o.symbol
ORDER BY o.symbol;

 


-- #5: List the usernames and the absolute average trade amount for each user.
-- Remember that order amount is shares * price.
-- Round the result to the nearest hundredth and use an alias (averageTradePrice).
-- Sort the results by averageTradePrice with the largest value at the top.
SELECT u.userid, u.uname, ROUND(AVG(ABS(o.shares*o.price)), -2) averageTradePrice FROM `User` u
JOIN `Order` o USING(userid)
GROUP BY u.userid
ORDER BY averageTradePrice DESC;




-- #6: How many shares for each symbol does each user have?
-- Remember to use the Fill table. Also remember that shares in the fill table are opposite.
-- Display the username and symbol with number of shares.
-- Sort it alphabetically first by user and symbol
SELECT u.userid, o.symbol, COUNT(f.`share`) totalShares FROM `User` u
JOIN `Order` o USING(userid)
JOIN Fill f USING(orderid)
GROUP BY o.symbol, u.userid
ORDER BY u.uname, o.symbol;



-- #7: What symbols have at least 3 orders?
SELECT o.symbol, COUNT(o.orderid) numOrder FROM `Order` o
GROUP BY o.symbol
HAVING numOrder > 3;



-- #8: List all the symbols and absolute net. Remember to take absolute of share * price before sum.
-- fills that have total fills exceeding $1000.
-- Do not include the GLD symbol in the results.
-- Sort the results by highest net with the largest value at the top.
SELECT f.symbol, SUM(ABS(share * price)) absolute_net FROM Fill f
WHERE f.symbol != 'GLD'
GROUP BY f.symbol
HAVING absolute_net > 1000
ORDER BY absolute_net DESC;




-- #9: List the top five orders with the greatest absolute outstanding order amount.
-- outstanding order amount is the Fill.share + Order.shares * o.price
-- Include the username, orderid, and outstanding order amount.
-- Dont forget to use an outer join for orders that have no fills and use IFNULL(SUM(Fill.share),0) for total shares filled

SElECT ( ABS(IFNULL(SUM(f.`share`),0) + o.shares) * o.price) outstanding_order, u.uname, o.orderid FROM `User` u
JOIN `Order` o USING(userid)
LEFT JOIN Fill f USING(orderid)
WHERE  status != "Filled" AND status NOT LIKE "%cancel%"
GROUP BY o.orderid
ORDER BY outstanding_order DESC
LIMIT 5;








