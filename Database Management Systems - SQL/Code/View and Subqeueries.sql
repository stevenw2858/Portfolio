CREATE SCHEMA `Project 1`;
USE `Project 1`;

#Project Week 3

CREATE TABLE Orders
(
CustomerName VARCHAR(20) NOT NULL,
Gender VARCHAR(20),
Age INT,
OrderID INT NOT NULL PRIMARY KEY,
ServerName VARCHAR(20),
ProductID INT,
ProductName VarChar(20),
ProductQuantity INT,
Size VARCHAR(10) NOT NULL,
IceLevel VARCHAR(20),
Toppings VARCHAR(20),
SugarAmount VARCHAR(20),
Price FLOAT,
ReviewRating INT,
TimeSpent INT,
Tip FLOAT,
CustomerExperienceRating INT
);

DROP TABLE OrderDescr;
CREATE TABLE OrderDescr
(
ProductID INT,
ProductName VARCHAR(50),
OrderCategory VARCHAR(20),
DefaultPrice INT,
SugarDefault VARCHAR(10)
);


CREATE TABLE Servers
(
ServerID VARCHAR(20) NOT NULL PRIMARY KEY,
OrderID INT,
ServerName VARCHAR(20) NOT NULL,
PayRate BIGINT NOT NULL,
ShiftID BIGINT NOT NULL,
ShiftName VARCHAR(50) NOT NULL,
Hours BIGINT,
OrdersTaken BIGINT,
Rating INT
);

#Views

#Our First view is a list of all the products we sell to see how many items are priced low, medium or high
CREATE VIEW PriceCategory AS
SELECT ProductID, ProductName, DefaultPrice,
CASE
	WHEN DefaultPrice > 7 THEN 'High'
    WHEN DefaultPrice > 3 THEN 'Medium'
    WHEN DefaultPrice > 0 THEN 'Low'
    ELSE 'N/A'
END AS PriceRange
FROM OrderDescr;

SELECT * FROM PriceCategory;

#View Displays what type of hours employees worked for that day. Here we can see if they worked a lot/few hours by and classify hours as Double OT, OT, regular or reduced shift
#This data can be used to redistribute hours if necessary. 
CREATE VIEW EmployeeWorked AS
SELECT ServerID, ServerName, PayRate, Hours,
CASE
	WHEN Hours > 10 THEN 'Double OT'
    WHEN Hours > 6 THEN 'OT'
    WHEN 4 > 0 THEN 'Regular'
    ELSE 'Reduced Shift'
END AS Worktype
FROM Servers;

SELECT * FROM EmployeeWorked;

#SELECT Queries

SELECT ProductID, ProductName, COUNT(ProductID) FROM Orders ORDER BY COUNT(ProductID) DESC; 
# Most popular drink/snack and how many of those items were ordered.

SELECT ProductID, Tip, ReviewRating FROM Orders ORDER BY ReviewRating DESC; 
# The Order Category that is most appreciated as seen by the rating and amount of tips received

SELECT OrderCategory, AVG(DefaultPrice) AS AveragePrice FROM OrderDescr 
GROUP BY OrderCategory 
ORDER BY AveragePrice DESC; 
# Most expensive order categories, and average price.

SELECT Age, AVG(TimeSpent) AS AverageTimeSpent FROM Orders WHERE Age IN(18, 19, 20, 21, 22, 23, 24)
GROUP BY Age ORDER BY AverageTimeSpent DESC; 
# Find out what age spend the most time in the store.

SELECT ServerID, ServerName, Rating FROM Servers ORDER BY Rating LIMIT 5; 
#S erver who had the highest ratings.

