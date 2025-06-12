USE orderbook;

 

-- #1: Display the dateJoined and username for users of the admin role

 
 

-- #2: Display the top absolute order amount (share*price), status, symbol, trade data, and username.
-- for the past 24 hours. The current_date and interval function  may be useful.
-- Keep the top 5 results with largest the absolute order net (share*price).
-- Include only orders that were not canceled or partially canceled.

 

-- #3: Display the orderid, symbol, status, order shares, filled shares, and price for orders with fills.
-- Filter out any order placed by a non-admin user
-- Note that filledShares are the opposite sign (+-) because they subtract from ordershares!



-- #4: Display the username and user role for users who have not placed an order.
-- You may need to test this by creating a new user and not placing an order
-- Remember using the  JOIN keyword is same as INNER JOIN
-- and using LEFT or RIGHT keyword is same as LEFT OUTER or RIGHT OUTER
-- adding a direction makes it directionally outer.


 

 

-- #5: Display orderid, username, role, symbol, price, and number of shares for orders with no fills.
-- Remember using the  JOIN keyword is same as INNER JOIN
-- and using LEFT or RIGHT keyword is same as LEFT OUTER or RIGHT OUTER
-- adding a direction makes it directionally outer.


 

 

-- #6: Display the symbol, username, role, order shares, and product name 
-- where the product name has the word "spdr" anywhere in it.



-- #7: Use the UNION keyword to perform a full outer join
-- MySQL does not support full outer joins (some DBMS systems do), UNION is a workaround
-- Union will unite the results of  two queries into one
-- Find all orders and all Fills, whether there is a matching order or not

-- Note, you will need to perform a Left Join, Union, then Right Join
-- First select all Orders and left join fills.
-- Then Select all fills and right join orders. 
-- Fill any potential missing shares values with 0.


 