USE orderbook;

-- #1: Create a view that allows us to quickly query each symbol
-- and the number of shares ordered with that symbol.
-- Then query the view. 
-- REMEMBER a view does not make queries faster, it just makes them easier!


-- #2: For each Symbol count how many filled, pending, and cancled orders exists.
-- Group by symbol only, and make a column for each filled, pending, and cancel.
-- Note that you may need to make use of the CASE WHEN to make a column that returns either 1 or 0
-- and take the sum of that column. When complete, try it without a CASE by adding status to the group by.




-- #3: Calculate the running total of shares ordered by each user.
-- Determine how many shares each user has ordered cumulatively up to and including each order.
-- Use the SUM() window function to calculate a running total of shares for each user. 
-- Partition the results by userid and order them by orderTime to get the cumulative shares ordered by each user over time.


-- #4: Select the orderid and absolute shares from orders
-- That have more shares than the average absolute order shares
-- Note that you will need to use a subquery to calculate the average absolute order amount


-- #5: Find the most recent order for each user
-- Select the userid, orderid, and orderTime
-- The WHERE condition on orderTime will need a subquery that selects the MAX ordertime
-- NOTE: This query may take a long time


-- #6 Create a Temporary table from the query above named RecentOrder. 
-- Make sure to add a statement to delete the table if it exists.
-- Run a select on the temp table. 
-- Temporary tables are often used to cache query results and can help improve performance, particularly for complex queries that are executed multiple times.
-- They only last for the sql session, so after logging out the temp table will be gone.
-- Use the explain keyword to examine the difference between the query above and the select on the temp table. 

-- #7 Find all orders where the absolute order amount is greater than 1 standard deviation of 
-- all orders. Remember calculate the average + 1 * SD and look for orders greater than that.
-- Dont forget to use ABS(price * shares) and ABS(SD). You may need a sub-query for this.





-- #8 Find all orders that are less than 50% filled. You can devide the sum of fill shares
-- by order shares. Remember to include orders with no fills and fill in missing fill shares with 0
-- also use absolute value





-- #9: Identify the top 10% of orders based on their net impact.
-- Rank all pending orders by their absolute amount outstanding and return only those that fall in the top 10%.

-- Hints:
-- Use a ROW_NUMBER() window function to rank the orders by net impact in descending order.
-- Use COUNT(*) OVER () to get the total number of orders.
-- Use a subquery to calculate which row corresponds to the 90th percentile, and then filter the orders based on that.
-- You will need at least three steps to first calculate the net_impact, then rank the orders, and finally filter based on the percentile.

-- After looking at the solution for this one, try to break it down and run each piece of it.

