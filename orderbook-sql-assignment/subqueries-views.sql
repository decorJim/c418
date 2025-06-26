USE orderbook;

-- #1: Create a view that allows us to quickly query each symbol
-- and the number of shares ordered with that symbol.
-- Then query the view. 
-- REMEMBER a view does not make queries faster, it just makes them easier!

DROP VIEW IF EXISTS TotalOrderValue;
CREATE VIEW TotalOrderValue AS
SELECT 
    o.symbol, 
    SUM(o.shares) AS total_value
FROM orderbook.`Order` o
GROUP BY o.symbol;

-- Querying the view
SELECT * FROM TotalOrderValue;

-- #2: For each Symbol count how many filled, pending, and cancled orders exists.
-- Group by symbol only, and make a column for each filled, pending, and cancel.
-- Note that you may need to make use of the CASE WHEN to make a column that returns either 1 or 0
-- and take the sum of that column. When complete, try it without a CASE by adding status to the group by.
SELECT 
    o.symbol, 
    SUM(CASE WHEN o.status = 'filled' THEN 1 ELSE 0 END) AS completed_orders,
    SUM(CASE WHEN o.status LIKE '%pending%' THEN 1 ELSE 0 END) AS pending_orders,
    SUM(CASE WHEN o.status LIKE '%cancel%' THEN 1 ELSE 0 END) AS canceled_orders
FROM orderbook.`Order` o
GROUP BY o.symbol;

-- with group by
SELECT o.symbol, o.status , COUNT(*)
FROM orderbook.`Order` o
GROUP BY o.symbol, o.status;



-- #3: Calculate the running total of shares ordered by each user.
-- Determine how many shares each user has ordered cumulatively up to and including each order.
-- Use the SUM() window function to calculate a running total of shares for each user. 
-- Partition the results by userid and order them by orderTime to get the cumulative shares ordered by each user over time.
SELECT 
    o.orderid, 
    u.uname, 
    o.symbol, 
    o.shares,
    -- sums shares for each userid in the order of ordertime
    SUM(o.shares) OVER (PARTITION BY u.userid ORDER BY o.orderTime) AS running_total_shares
FROM `Order` o
JOIN `User` u USING(userid)
ORDER BY u.uname, o.orderid;

-- #4: Select the orderid and absolute shares from orders
-- That have more shares than the average absolute order shares
-- Note that you will need to use a subquery to calculate the average absolute order amount
SELECT o.orderid, o.shares
FROM `Order` o
WHERE o.shares > (
    SELECT AVG(ABS(shares))
    FROM `Order`
);

-- #5: Find the most recent order for each user
-- Select the userid, orderid, and orderTime
-- The WHERE condition on orderTime will need a subquery that selects the MAX ordertime
-- NOTE: This query may take a long time
SELECT userid, orderid, orderTime FROM `Order`
WHERE orderTime IN (
	SELECT MAX(orderTime) FROM `Order`
    GROUP BY userid
)
ORDER BY userid;

-- #6 Create a Temporary table from the query above named RecentOrder. 
-- Make sure to add a statement to delete the table if it exists.
-- Run a select on the temp table. 
-- Temporary tables are often used to cache query results and can help improve performance, particularly for complex queries that are executed multiple times.
-- They only last for the sql session, so after logging out the temp table will be gone.
-- Use the explain keyword to examine the difference between the query above and the select on the temp table. 

DROP TEMPORARY TABLE IF EXISTS RecentOrder;
CREATE TEMPORARY TABLE RecentOrder AS
    SELECT userid, orderid, orderTime FROM `Order`
    WHERE orderTime IN (
	    SELECT MAX(orderTime) FROM `Order`
       GROUP BY userid
   )
   ORDER BY userid;
    
SELECT * 
FROM RecentOrder;
    
EXPLAIN SELECT * 
FROM RecentOrder;

EXPLAIN SELECT userid, orderid, orderTime FROM `Order`
WHERE orderTime IN (
	SELECT MAX(orderTime) FROM `Order`
    GROUP BY userid
)
ORDER BY userid;
    
-- #7 Find all orders where the absolute order amount is greater than 1 standard deviation of 
-- all orders. Remember calculate the average + 1 * SD and look for orders greater than that.
-- Dont forget to use ABS(price * shares) and ABS(SD). You may need a sub-query for this.
SELECT *
FROM orderbook.`Order` o
WHERE ABS(o.price * shares) > (
        SELECT AVG(ABS(o.price * shares)) + 1 * stddev(ABS(o.price * shares)) as top_price
        FROM orderbook.`Order` o
    ) 
;




-- #8 Find all orders that are less than 50% filled. You can devide the sum of fill shares
-- by order shares. Remember to include orders with no fills and fill in missing fill shares with 0
-- also use absolute value

SELECT 
    o.orderid,
    o.shares AS total_shares,
    IFNULL(SUM(f.share), 0) AS filled_shares,
    ABS((IFNULL(SUM(f.share), 0) / o.shares) * 100) AS fill_percentage
FROM `Order` o
LEFT JOIN `Fill` f ON o.orderid = f.orderid
GROUP BY o.orderid
HAVING fill_percentage < 50;

-- With Common Table Expression (CTE)
WITH OrderFillPercentage AS (
    SELECT 
        o.orderid,
        o.shares AS total_shares,
        IFNULL(SUM(f.share), 0) AS filled_shares,
        ABS((IFNULL(SUM(f.share), 0) / o.shares) * 100) AS fill_percentage
    FROM `Order` o
    LEFT JOIN `Fill` f ON o.orderid = f.orderid
    GROUP BY o.orderid
)
SELECT orderid, total_shares, filled_shares, fill_percentage
FROM OrderFillPercentage
WHERE fill_percentage < 50
;



-- #9: Identify the top 10% of orders based on their net impact.
-- Rank all pending orders by their absolute amount outstanding and return only those that fall in the top 10%.

-- Hints:
-- Use a ROW_NUMBER() window function to rank the orders by net impact in descending order.
-- Use COUNT(*) OVER () to get the total number of orders.
-- Use a subquery to calculate which row corresponds to the 90th percentile, and then filter the orders based on that.
-- You will need at least three steps to first calculate the net_impact, then rank the orders, and finally filter based on the percentile.

-- After looking at the solution for this one, try to break it down and run each piece of it.

WITH PriceImpact AS (
    -- First, calculate the net impact for each order
    SELECT 
        o.orderid,
        -- Net impact is calculated by adding the sum of filled shares to the total shares
        -- of the order and multiplying by the order price
        ABS(IFNULL(SUM(f.share), 0) + o.shares) * o.price AS net_impact
    FROM `Order` o
    -- Use a LEFT JOIN to ensure we include orders with no fills
    LEFT JOIN `Fill` f ON o.orderid = f.orderid
    WHERE o.status != 'Filled' AND o.status NOT LIKE '%cancel%' -- Filter out filled or canceled orders
    GROUP BY o.orderid
),
RankedImpacts AS (
    -- Rank each order by its absolute amount outstanding and calculate total number of orders
    SELECT
        orderid,
        net_impact,
        -- Use ROW_NUMBER() to rank orders by absolute amount outstanding  in descending order
        -- Essentially, each row is provided a unique number (rank) where the highes absolute amount outstanding gets a 1
        ROW_NUMBER() OVER (ORDER BY net_impact DESC) AS row_num,
        -- COUNT(*) OVER() gives the total number of orders, without affecting the ranking
        COUNT(*) OVER () AS total_orders
    FROM PriceImpact
),
ImpactPercentiles AS (
    -- Calculate the row corresponding to the 90th percentile
    SELECT
        orderid,
        net_impact,
        total_orders,
        row_num,
        -- Multiply total orders by 0.9 to get the row number at the 90th percentile
        (total_orders * 0.9) AS pct_90_row
    FROM RankedImpacts
)
-- Filter for orders where the row number is greater than or equal to the 90th percentile
SELECT orderid, net_impact
FROM ImpactPercentiles
WHERE row_num >= pct_90_row;