CREATE SCHEMA `Project 1`;
USE `Project 1`;

#1st Denormalized Table
CREATE TABLE MasterDenorm
(
CustomerName VARCHAR(20) NOT NULL,
Gender VARCHAR(20),
Age INT,
OrderID INT NOT NULL PRIMARY KEY,
ServerName VARCHAR(20),
Orders VARCHAR(50),
OrderCategory VARCHAR(20),
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

#Master Table 1NF
CREATE TABLE MasterNorm 
(
CustomerName VARCHAR(20) NOT NULL,
Gender VARCHAR(20),
Age INT,
OrderID INT NOT NULL PRIMARY KEY,
ServerName VARCHAR(20),
ProductID INT,
ProductName VARCHAR(50),
ProductQuantity INT,
OrderCategory VARCHAR(20),
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

#Order Table 2NF
CREATE TABLE Orders 
(
OrderID INT NOT NULL PRIMARY KEY,
CustomerName VARCHAR(20)
);

#Product Table 2NF
CREATE TABLE Product 
(
ProductID INT NOT NULL PRIMARY KEY,
ProductName VARCHAR(50)
);

#OrderDetails Table 2NF
CREATE TABLE OrderDetails
(
OrderID INT NOT NULL PRIMARY KEY,
ProductID INT NOT NULL,
ProductQuantity INT
);


#Import Data from CSV Files

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Master.csv' 
INTO TABLE MasterDenorm
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/MasterNorm.csv' 
INTO TABLE MasterNorm
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Orders.csv' 
INTO TABLE Orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Product.csv' 
INTO TABLE Product
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/OrderDetails.csv' 
INTO TABLE OrderDetails
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


#Populate Data
SELECT * FROM MasterDenorm;
Select * FROM MasterNorm;
Select * FROM Orders;
Select * FROM Product;
Select * FROM OrderDetails;


#2nd Denormalized Table
CREATE TABLE ServerDenormalized
(
ServerID VARCHAR(20) NOT NULL,
ServerName VARCHAR(20),
PayRate BIGINT NOT NULL,
ShiftInformation VARCHAR(50) NOT NULL,
OrdersTaken BIGINT NOT NULL,
CONSTRAINT PKServerID PRIMARY KEY (ServerID)
);

#Normalized for Servers Table 2
CREATE TABLE Server1NF
(
ServerID VARCHAR(20) NOT NULL,
ServerName VARCHAR(20) NOT NULL,
PayRate BIGINT NOT NULL,
ShiftID BIGINT NOT NULL,
ShiftName VARCHAR(50) NOT NULL,
Hours BIGINT NOT NULL,
OrdersTaken BIGINT NOT NULL
);

#Normalized for Servers Table 2NF
CREATE TABLE Server2NF1
(
ServerID VARCHAR(20) NOT NULL,
ServerName VARCHAR(20) NOT NULL,
CONSTRAINT PKServerID PRIMARY KEY (ServerID)
);

#Normalized for Servers Table 2NF #2
CREATE TABLE Server2NF2
(
ShiftID VARCHAR(20) NOT NULL,
ShiftName VARCHAR(20) NOT NULL,
CONSTRAINT PKShiftID PRIMARY KEY (ShiftID)
);

#Normalized for Servers Table 2NF #2
#(Server ID, Shift ID) --> Hours
CREATE TABLE Server2NF3
(
ServerID VARCHAR(20) NOT NULL,
ShiftID VARCHAR(20) NOT NULL,
Hours BIGINT NOT NULL
);

#Normalized for Servers Table 2NF #3
#(Server ID, Shift ID) --> Number of Orders Taken
CREATE TABLE Server2NF4
(
ServerID VARCHAR(20) NOT NULL,
ShiftID VARCHAR(20) NOT NULL,
OrdersTaken BIGINT NOT NULL
);

#Import Data from CSV Files

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Denormalized 2.csv' 
INTO TABLE ServerDenormalized
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Normalized 2.1.csv' 
INTO TABLE Server1NF
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Normalized 2.2.csv' 
INTO TABLE Server2NF1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Normalized 2.3.csv' 
INTO TABLE Server2NF2
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Normalized 2.4.csv' 
INTO TABLE Server2NF3
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Normalized 2.5.csv' 
INTO TABLE Server2NF4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#Populate Data
SELECT * FROM ServerDenormalized;
Select * FROM Server1NF;
Select * FROM Server2NF1;
Select * FROM Server2NF2;
Select * FROM Server2NF3;
Select * FROM Server2NF4;

