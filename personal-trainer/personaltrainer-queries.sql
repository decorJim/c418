USE PersonalTrainer;

# Select all rows and columns from the Exercise table (64 rows)
SELECT * FROM Exercise;

# Select all rows and columns from the Client table. (500 rows)
SELECT * FROM `Client`;

# Select all columns from Client where the City is Metairie. (29 rows)
SELECT * FROM `Client` WHERE City = 'Metairie';

# Is there a Client with the ClientId '818u7faf-7b4b-48a2-bf12-7a26c92de20c' (0 rows)
SELECT * FROM `Client` WHERE ClientId = '818u7faf-7b4b-48a2-bf12-7a26c92de20c';

# How many rows are in the Goal table? (17 rows)
SELECT COUNT(*) FROM Goal;

# Select Name and LevelId from the Workout table. (26 rows)
SELECT `Name`, LevelId FROM Workout;

# Select Name, LevelId, and Notes from Workout where LevelId is 2. (11 rows)
SELECT `Name`, LevelId, Notes FROM Workout 
WHERE LevelId = 2;

# Select FirstName, LastName, and City from Client where City is Metairie, Kenner, or Gretna. (77 rows)
SELECT FirstName, LastName, City FROM `Client`
WHERE City IN ('Metairie','Kenner','Gretna');

# Select FirstName, LastName, and BirthDate from Client for Clients born in the 1980s. (72 rows)
SELECT FirstName, LastName, BirthDate FROM `Client`
WHERE YEAR(BirthDate) >= '1980' AND YEAR(BirthDate) < '1990';

# If you didn't use BETWEEN, use it!
SELECT FirstName, LastName, BirthDate FROM `Client`
WHERE YEAR(BirthDate) BETWEEN '1980' AND '1989';

# How many rows in the Login table have a .gov EmailAddress? (17 rows)
SELECT COUNT(*) FROM Login 
WHERE EmailAddress LIKE '%.gov';

# How many Logins do NOT have a .com EmailAddress? (122 rows)
SELECT COUNT(*) FROM Login
WHERE EmailAddress NOT LIKE '%.com';

# Select first and last name of Clients without a BirthDate. (37 rows)
SELECT FirstName, LastName FROM `Client`
WHERE BirthDate IS NULL;

# Select the Name of each ExerciseCategory that has a parent (ParentCategoryId value is not null). (12 rows)
SELECT `Name` FROM ExerciseCategory 
WHERE ParentCategoryId IS NOT NULL;

# Select Name and Notes of each level 3 Workout that contains the word 'you' in its Notes. (4 rows)
SELECT `Name`, Notes FROM Workout
WHERE LevelId = 3 AND Notes LIKE '%you%';

# Select FirstName, LastName, City from Client whose LastName starts with L,M, or N and who live in LaPlace. (5 rows)
SELECT FirstName, LastName, City FROM `Client`
WHERE (LastName LIKE 'L%' OR LastName LIKE '%M' OR LastName LIKE 'N%') AND City = 'LaPlace';

# Select InvoiceId, Description, Price, Quantity, ServiceDate and the line item total, a calculated value, from InvoiceLineItem, where the line item total is between 15 and 25 dollars. (667 rows)
SELECT t1.InvoiceId, t1.`Description`, t1.Price, t1.Quantity, t1.ServiceDate, t1.lineItemTotal FROM 
(
SELECT *, (Price*Quantity) AS lineItemTotal FROM InvoiceLineItem 
) AS t1
WHERE t1.lineItemTotal BETWEEN 15 AND 25;

# Does the database include an email address for the Client, Estrella Bazely?
SELECT * FROM
(
SELECT *  FROM Login l INNER JOIN `Client` c
USING (clientId)  # will not duplicate the column if they have the same name
) AS t1
WHERE t1.FirstName = 'Estrella' AND t1.LastName = 'Bazely';

# What are the Goals of the Workout with the Name 'This Is Parkour'?
SELECT g.* FROM Workout w INNER JOIN WorkoutGoal wg
USING (WorkoutId) INNER JOIN Goal g 
USING (GoalId) 
WHERE w.`Name` = 'This Is Parkour';











