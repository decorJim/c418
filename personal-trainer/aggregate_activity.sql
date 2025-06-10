use PersonalTrainer;

-- Use an aggregate to count the number of Clients.
-- 500 rows

SELECT COUNT(*) FROM `Client` c;

-- Use an aggregate to count Client.BirthDate.
-- The number is different than total Clients. Why?
-- 463 rows

SELECT COUNT(BirthDate) FROM `Client`;

-- Group Clients by City and count them.
-- Order by the number of Clients desc.
-- 20 rows

SELECT c.City, COUNT(*) clientNum FROM `Client` c
GROUP BY c.City
ORDER BY clientNum DESC;


-- Calculate a total per invoice using only the InvoiceLineItem table.
-- Group by InvoiceId.
-- You'll need an expression for the line item total: Price * Quantity.
-- Aggregate per group using SUM().
-- 1000 rows

SELECT SUM(Price*Quantity) FROM InvoiceLineItem
GROUP BY InvoiceId;


-- Calculate a total per invoice using only the InvoiceLineItem table.
-- (See above.)
-- Only include totals greater than $500.00.
-- Order from lowest total to highest.
-- 234 rows

SELECT SUM(Price*Quantity) total FROM InvoiceLineItem
GROUP BY InvoiceId
HAVING total > 500;



-- Calculate the average line item total
-- grouped by InvoiceLineItem.Description.
-- 3 rows


SELECT ili.`Description`, AVG(Price*Quantity) average FROM InvoiceLineItem ili
GROUP BY ili.`Description`;

-- Select ClientId, FirstName, and LastName from Client
-- for clients who have *paid* over $1000 total.
-- Paid is Invoice.InvoiceStatus = 2.
-- Order by LastName, then FirstName.
-- 146 rows

SELECT c.ClientId, c.FirstName, c.LastName, SUM(ili.Price*ili.Quantity) total FROM `Client` c 
JOIN Invoice i USING(ClientId)
JOIN InvoiceLineItem ili USING(InvoiceId)
WHERE i.InvoiceStatus = 2 
GROUP BY c.ClientId
HAVING total > 1000
ORDER BY c.LastName, c.FirstName;



-- Count exercises by category.
-- Group by ExerciseCategory.Name.
-- Order by exercise count descending.
-- 13 rows

SELECT COUNT(*) total FROM Exercise e 
JOIN ExerciseCategory ec USING(ExerciseCategoryId)
GROUP BY ec.`Name`
ORDER BY total DESC;


-- Select Exercise.Name along with the minimum, maximum,
-- and average ExerciseInstance.Sets.
-- Order by Exercise.Name.
-- 64 rows

SELECT e.`Name`, MIN(ei.Sets), MAX(ei.Sets), AVG(ei.Sets) FROM Exercise e
JOIN ExerciseInstance ei USING(ExerciseId)
GROUP BY e.ExerciseId, e.`Name`
ORDER BY e.`Name`;


-- Find the minimum and maximum Client.BirthDate
-- per Workout.
-- 26 rows
-- Sample: 
-- WorkoutName, EarliestBirthDate, LatestBirthDate
-- '3, 2, 1... Yoga!', '1928-04-28', '1993-02-07'

SELECT MIN(c.BirthDate), MAX(c.BirthDate) FROM `Client` c 
JOIN ClientWorkout cw USING(ClientId)
JOIN Workout w USING(WorkoutId)
GROUP BY w.WorkoutId;


-- Count client goals.
-- Be careful not to exclude rows for clients without goals.
-- 500 rows total
-- 50 rows with no goals

SELECT c.ClientId, COUNT(cg.GoalId) goals FROM `Client` c
LEFT JOIN ClientGoal cg USING(ClientId)
GROUP BY c.ClientId
ORDER BY goals;


-- Select Exercise.Name, Unit.Name, 
-- and minimum and maximum ExerciseInstanceUnitValue.Value
-- for all exercises with a configured ExerciseInstanceUnitValue.
-- Order by Exercise.Name, then Unit.Name.
-- 82 rows

SELECT e.`Name`, u.`Name`, MIN(eiuv.`Value`), MAX(eiuv.`Value`) FROM Exercise e
JOIN ExerciseInstance ei USING(ExerciseId)
JOIN ExerciseInstanceUnitValue eiuv USING(ExerciseInstanceId)
JOIN Unit u USING(UnitId)
GROUP BY e.ExerciseId, e.`Name`, u.UnitId, u.`Name`
ORDER BY e.`Name`,u.`Name`;



-- Modify the query above to include ExerciseCategory.Name.
-- Order by ExerciseCategory.Name, then Exercise.Name, then Unit.Name.
-- 82 rows

SELECT ec.`Name`, e.`Name`, u.`Name`, MIN(eiuv.`Value`), MAX(eiuv.`Value`) FROM ExerciseCategory ec
JOIN Exercise e USING(ExerciseCategoryId)
JOIN ExerciseInstance ei USING(ExerciseId)
JOIN ExerciseInstanceUnitValue eiuv USING(ExerciseInstanceId)
JOIN Unit u USING(UnitId)
GROUP BY e.ExerciseId, e.`Name`, u.UnitId, u.`Name`
ORDER BY ec.`Name`, e.`Name`,u.`Name`;


-- Select the minimum and maximum age in years for
-- each Level.
-- To calculate age in years, use the MySQL function DATEDIFF.
-- 4 rows

-- DATEDIFF(CURDATE(), c.BirthDay) total number of days
-- divide by 365 to get years

SELECT MIN(DATEDIFF(NOW(), c.BirthDate)/365) now_min, MAX(DATEDIFF(NOW(), c.BirthDate)) now_max,
MIN(DATEDIFF(CURDATE(), c.BirthDate)/365) min, MAX(DATEDIFF(CURDATE(), c.BirthDate)) max FROM `Client` c 
JOIN ClientWorkout cw USING(ClientId)
JOIN Workout w USING(WorkoutId) 
JOIN `Level` l USING(LevelId)
GROUP BY l.levelId, l.`Name`;

-- Stretch Goal!
-- Count logins by email extension (.com, .net, .org, etc...).
-- Research SQL functions to isolate a very specific part of a string value.
-- 27 rows (27 unique email extensions)
SELECT SUBSTRING_INDEX(EmailAddress, '.', -1) extensions, 
	COUNT(*) extension_count
FROM Login
GROUP BY SUBSTRING_INDEX(EmailAddress, '.', -1);
# take the EmailAddress
# split by .
# -1 take everything after the .




-- Stretch Goal!
-- Match client goals to workout goals.
-- Select Client FirstName and LastName and Workout.Name for
-- all workouts that match at least 2 of a client's goals.
-- Order by the client's last name, then first name.
-- 139 rows

SELECT c.FirstName, c.LastName, w.`Name` 
FROM `Client` c
JOIN ClientGoal cg USING(ClientId)
JOIN WorkoutGoal wg USING(GoalId)
JOIN Workout w USING(WorkoutId)
GROUP BY c.FirstName, c.LastName, w.`Name`
HAVING COUNT(wg.GoalId) > 1;




