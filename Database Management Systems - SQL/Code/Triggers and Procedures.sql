CREATE SCHEMA `Project 001`;
USE `Project 001`;

DROP SCHEMA `Project 1`;
CREATE SCHEMA `Project 1`;
USE `Project 1`;

DROP TRIGGER IF EXISTS ProductInsertTrigger;
DROP PROCEDURE IF EXISTS FindCommissionDiff;

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

INSERT INTO Orders
VALUES
 ('A','Male',20,1,'Alpha',100,'Milk Boba Tea',1,'Large','Light Ice','NA','Brown Sugar',10,4,10,2,4),
 ('B','Female',18,2,'Beta',101,'Strawberry Boba Tea',1,'Small','No Ice','NA','Light Sugar',7,5,12,2.5,5);

CREATE TABLE OrderDescr
(
ProductID INT,
ProductName VARCHAR(50),
OrderCategory VARCHAR(20),
DefaultPrice INT,
SugarDefault VARCHAR(25)
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

INSERT INTO OrderDescr
VALUES
 (100,'Milk Boba Tea','Drinks',10,'Brown Sugar'),
 (101,'Strawberry Boba Tea','Drinks',7,'Light Sugar'),
 (102,'Honey Boba Tea','Drinks',8,'No Sugar'),
 (103,'Tofu Bites','Snacks',4,'NA'),
 (104,'Calamari','Snacks',4,'NA'),
 (105,'Thai Tea','Drinks',6,'Brown Sugar');

CREATE TABLE OrderFrequency
(
Product                CHAR(20),
NumOrders        INT
); 

#Find Server, Payrate, and ShiftID of Server who took the most orders, sorted by Total orders.
#This will let us see which servers do most/least amount of work. Also let's us see how they are compensated.
SELECT Servers.ServerID, Servers.PayRate, Servers.ShiftID, 
COUNT(Orders.OrderID) AS OrdersTotal
FROM Servers
INNER JOIN Orders
ON Servers.ServerName = Orders.ServerName
GROUP BY  Servers.ServerName
Order BY OrdersTotal DESC;

#Find what shifts are the most pouplar among college students and see orders and ratings
SELECT Servers.ShiftName, SUM(Servers.OrdersTaken) AS TotOrders, AVG(Servers.Rating) AS AvgRate 
FROM Servers WHERE 
Servers.ServerName IN
	(SELECT Orders.ServerName FROM Orders 
    WHERE Orders.Age = 18 OR Orders.Age = 19 OR Orders.Age = 20 
    OR Orders.Age = 21 OR Orders.Age = 22)
ORDER BY AvgRate;

#There are usually more women who visits Boba Shops than men. Are there specific drinks or food they prefer.
#Subquery shows which drinks or food women might prefer.
SELECT COUNT(OrderDescr.ProductID) AS ItemCount, OrderDescr.ProductName, OrderDescr.OrderCategory, OrderDescr.DefaultPrice
FROM OrderDescr WHERE
OrderDescr.ProductID IN
	(SELECT Orders.ProductID FROM Orders
    WHERE Gender = 'Female')
GROUP BY OrderDescr.ProductName;

#Find top 10 drinks and the total amount paid and tips total
#We can have special promotions for these drinks or adjust pricings.
SELECT Orders.ProductName, SUM(Orders.Price) AS TotalPaid, SUM(Orders.Tip) AS TotalTips
FROM Orders WHERE
Orders.ProductID IN
	(SELECT OrderDescr.ProductID FROM OrderDescr    
	WHERE OrderDescr.OrderCategory = 'Drink')
GROUP BY Orders.ProductName
ORDER BY TotalPaid DESC LIMIT 10;

#List Employees amount of Revenue (Excluding Tips) collected for employees who worked 5 or more hours.
#Revenue must exceed $500 total
SELECT Servers.ServerID, Servers.ServerName, Servers.OrdersTaken, SUM(Orders.Price) AS Revenue
FROM Servers
INNER JOIN Orders
ON Servers.ServerName = Orders.ServerName
WHERE Servers.Hours >= 5
GROUP BY Servers.ServerName
HAVING Revenue >= 500
ORDER BY Revenue;

#1 A query to initialize the OrderFrequency table by inserting one row for each ProductID already in the OrderDescr table, and having the 
# accurate count of the number of orders for that product.

INSERT INTO OrderFrequency
SELECT OrderDescr.ProductName, COUNT(OrderDescr.ProductName) AS "#Orders" FROM OrderDescr GROUP BY OrderDescr.ProductName ORDER BY "#Orders";

SELECT * FROM OrderFrequency;

#2 Write a trigger to update NumEmployeesByLastName whenever a new record is inserted into the Employee table.
DELIMITER //
CREATE TRIGGER ProductInsertTrigger AFTER INSERT ON OrderDescr
FOR EACH ROW
BEGIN
IF 
((SELECT COUNT(*) FROM OrderFrequency WHERE Product = NEW.ProductName) = 0)
THEN
INSERT INTO OrderFrequency SELECT ProductName, COUNT(ProductName) FROM OrderDescr 
WHERE ProductName = NEW.ProductName GROUP BY ProductName;
ELSE 
UPDATE OrderFrequency SET NumOrders = (SELECT COUNT(ProductName) FROM OrderDescr
WHERE ProductName = NEW.ProductName GROUP BY ProductName)
WHERE Product=New.ProductName;
END IF;
END //
DELIMITER ;

SET SQL_SAFE_UPDATES = 0;
INSERT INTO OrderDescr VALUES (102,'Honey Boba Tea','Drinks',8,'No Sugar');
INSERT INTO OrderDescr VALUES (201, 'Fries', 'Snacks',4,'NA');
SELECT * FROM OrderFrequency;

#3 Create a procedure CompareCustomerRating that takes 2 products as input. The procedure returns the difference in the customer rating 
# of these two products

DELIMITER $$
CREATE PROCEDURE CompareCustomerRating (IN ProdID1 INT, IN ProdID2 INT, OUT CustRatingDiff INT )
BEGIN
    DECLARE CustRating1 INT;
    DECLARE CustRating2 INT;
    SELECT CustomerExperienceRating INTO CustRating1 FROM Orders where Orders.ProductID = ProdID1;
    SELECT CustomerExperienceRating INTO CustRating2 FROM Orders where Orders.ProductID = ProdID2;
	SET CustRatingDiff = CustRating1 - CustRating2;
END $$

DELIMITER ;

CALL CompareCustomerRating(100, 101, @df);
SELECT @df;

