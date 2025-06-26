/*

Basic Selects

 

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query

                 Also include the total records returned.

             

             

*/

 

USE orderbook_activity_db;

 

-- #1: List all users, including username and dateJoined.

select

      `User`.uname,

    `User`.dateJoined

from `User`;

 

/*

admin 2023-02-14 13:13:28

wiley 2023-04-01 13:13:28

james 2023-03-15 19:15:48

kendra      2023-03-15 19:16:06

alice 2023-03-15 19:16:21

7 rows

*/

 

-- #2: List the username and datejoined from users with the newest users at the top.

select

    `User`.uname,

    `User`.dateJoined

from `User`;

order by

      `User`.dateJoined desc;

 

/*

admin 2023-02-14 13:13:28

wiley 2023-04-01 13:13:28

james 2023-03-15 19:15:48

kendra      2023-03-15 19:16:06

alice 2023-03-15 19:16:21

7 rows

*/

 

 

-- #3: List all usernames and dateJoined for users who joined in March 2023.

select

      `User`.uname,

    `User`.dateJoined

from `User`

where dateJoined LIKE '2023-03%';

 

/*

james 2023-03-15 19:15:48

kendra      2023-03-15 19:16:06

alice 2023-03-15 19:16:21

robert      2023-03-15 19:16:43

sam   2023-03-15 19:16:59

5 rows

*/

 

-- #4: List the different role names a user can have.

select `name`

from `Role`;

 

/*

admin

it

user

3 rows

*/

 

-- #5: List all the orders.

 

select * from `Order`;

 

/*

1     1     WLY   1     2023-03-15 19:20:35     100   38.73 partial_fill

2     6     WLY   2     2023-03-15 19:20:50     -10   38.73 filled

3     6     NFLX  2     2023-03-15 19:21:12     -100  243.15      pending

4     5     A     1     2023-03-15 19:21:31     10    129.89      filled

5     3     A     2     2023-03-15 19:21:39     -10   129.89      filled

25 rows 1 null

*/

 

-- #6: List all orders in March where the absolute net order amount is greater than 1000.

select

      *,

      abs(shares * price) as absolute_price

from `Order`

where

      month(orderTime) = 3

    and abs(shares * price) > 1000;

 

/*

1     1     WLY   1     2023-03-15 19:20:35     100   38.73 partial_fill      3873.00

3     6     NFLX  2     2023-03-15 19:21:12     -100  243.15      pending     24315.00

4     5     A     1     2023-03-15 19:21:31     10    129.89      filled      1298.90

5     3     A     2     2023-03-15 19:21:39     -10   129.89      filled      1298.90

6     1     GS    1     2023-03-15 19:22:11     100   305.63      canceled_partial_fill   30563.00

16 rows

*/

 

 

-- #7: List all the unique status types from orders.

select distinct status

from `Order`;

 

/*

partial_fill

filled

pending

canceled_partial_fill

canceled

5 rows

*/

 

-- #8: List all pending and partial fill orders with oldest orders first.

select

      orderid,

    `status`,

    orderTime

from `Order`

where status in ('pending', 'partial_fill')

order by orderTime asc;

 

/*

3     pending     2023-03-15 19:21:12

12    pending     2023-03-15 19:24:32

13    pending     2023-03-15 19:24:32

20    pending     2023-03-15 19:51:06

21    pending     2023-03-15 20:09:38

8 rows 1 null

*/

 

-- #9: List the 10 most expensive financial products where the productType is stock.

-- Sort the results with the most expensive product at the top

 

select

      `name`,

    price

from Product

where productType = 'stock'

order by price desc

limit 10;

 

/*

Samsung Biologics Co.,Ltd.    830000.00

Taekwang Industrial Co., Ltd. 715000.00

Young Poong Corporation 630000.00

Korea Zinc Company, Ltd.      616000.00

Samsung SDI Co., Ltd.   605000.00

10 rows

*/

 

-- #10: Display orderid, fillid, userid, symbol, and absolute net fill amount

-- from fills where the absolute net fill is greater than $1000.

-- Sort the results with the largest absolute net fill at the top.

 

select

    orderid,

    fillid,

    userid,

    symbol,

    abs(share * price) as absolute_net_fill_amount

from

    Fill

where

    abs(share * price) > 1000;

 

/*

4     3     5     A     1298.90

5     4     3     A     1298.90

6     5     1     GS    3056.30

7     6     4     GS    3056.30

8     7     6     AAPL  1407.60

10 rows

*/
