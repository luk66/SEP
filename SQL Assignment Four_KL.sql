--- Assignment Four ---
1.	What is View? What are the benefits of using views?
	virtual table that refernce to data from one or multiple tables
2.	Can data be modified through views? 
	yes
3.	What is stored procedure and what are the benefits of using it?
	prepared sql query that we can save and reuse over and over again
4.	What is the difference between view and stored procedure?
	view does not accept parameters
5.	What is the difference between stored procedure and functions?
	Function must have return value but stored procedure may not have one.
6.	Can stored procedure return multiple result sets?
	yes
7.	Can stored procedure be executed as part of SELECT Statement? Why?
	no
8.	What is Trigger? What types of Triggers are there?
	A trigger is a special type of stored procedure that automatically runs when an event occurs in the database server. There are DDL trigger, DML trigger, and Logon trigger
9.	What are the scenarios to use Triggers?
	One may use trigger to: automatically update the 'sum' column when 'elements' column is changed to ensure data integrity. Or: record and update logfile when someone modifies or queues data
10.	What is the difference between Trigger and Stored Procedure?
	Trigger runs automatically but stored procedure runs upon calls

USE NORTHWIND
GO

--- 1 ---
--SKIPPED

--- 2 ---
--SKIPPED

--- 3 ---
--SKIPPED

--- 4 ---
CREATE VIEW [view_product_order_LU] 
AS
SELECT P.ProductID, ISNULL(SUM(OD.QUANTITY),0) AS QTY
FROM DBO.Products P
LEFT JOIN DBO.[Order Details] OD
ON P.ProductID = OD.ProductID
GROUP BY P.ProductID

SELECT * FROM view_product_order_LU


--- 5 ---
--CREATE PROC [SP_PRODUCT_ORDER_QUANTITY_LU]
ALTER PROC [SP_PRODUCT_ORDER_QUANTITY_LU]
@PRODUCTID INT,
@TOTALQTY INT OUT
AS
BEGIN
SELECT @TOTALQTY = SUM(OD.QUANTITY)
FROM DBO.Products P
JOIN DBO.[Order Details] OD 
ON P.ProductID = OD.ProductID
WHERE P.ProductID = @PRODUCTID
END

BEGIN
DECLARE @QTY INT
EXEC SP_PRODUCT_ORDER_QUANTITY_LU 1, @QTY OUT
PRINT @QTY
END

--- 6 --- CHECK
CREATE PROC [SP_PRODUCT_ORDER_CITY_LU]
@PRODUCTNAME NVARCHAR(50),
@CITYOUT NVARCHAR(200) OUT,
@QTYOUT NVARCHAR(200) OUT
AS
BEGIN
SELECT TOP 5 @CITYOUT = O.ShipCity, @QTYOUT = SUM(OD.QUANTITY)
FROM (DBO.Products P JOIN DBO.[Order Details] OD ON P.ProductID = OD.ProductID)
JOIN DBO.Orders O
ON O.OrderID = OD.OrderID
WHERE @PRODUCTNAME = P.ProductName
GROUP BY O.ShipCity
ORDER BY SUM(OD.QUANTITY) DESC
END

SELECT DISTINCT PRODUCTNAME
FROM DBO.Products

BEGIN
DECLARE @CITYOUT NVARCHAR(MAX), @QTYOUT NVARCHAR(MAX)
EXEC SP_PRODUCT_ORDER_CITY_LU 'Chai', @CITYOUT OUT, @QTYOUT OUT 
PRINT(@CITYOUT)
PRINT(@QTYOUT)
END




--- 7 ---
--SKIPPED

--- 8 ---
--SKIPPED


--- 9 ---
CREATE TABLE PEOPLE_LU(
ID INT PRIMARY KEY,
NAME VARCHAR(30),
CITY INT
)
INSERT INTO PEOPLE_LU
VALUES
(1,'Aaron Roders',2),
(2,'Russell Wilson',1),
(3,'Jody Nelson',2)

SELECT *
FROM PEOPLE_LU

CREATE TABLE CITY_LU(
ID INT PRIMARY KEY,
CITY VARCHAR(50)
)

INSERT INTO CITY_LU
VALUES
(1,'Seattle'),
(2,'Green Bay')

SELECT *
FROM CITY_LU

UPDATE CITY_LU
SET CITY = 'Madison'
WHERE ID = 1

CREATE VIEW PACKERS_LU
AS
SELECT PEOPLE_LU.NAME 
FROM PEOPLE_LU
JOIN CITY_LU
ON PEOPLE_LU.CITY = CITY_LU.ID
WHERE CITY_LU.CITY = 'Green Bay'

DROP VIEW PACKERS_LU
DROP TABLE CITY_LU
DROP TABLE PEOPLE_LU

--- 10 ---
CREATE PROC SP_BIRTHDAY_EMPLOYEES_LU
AS
BEGIN
CREATE TABLE BIRTHDAY_EMPLOYEES_LU(
NAME VARCHAR(50)
)

INSERT INTO BIRTHDAY_EMPLOYEES_LU
SELECT E.FirstName +' '+E.LastName AS NAME
FROM DBO.Employees E
WHERE MONTH(E.BirthDate) = 2
END

EXEC SP_BIRTHDAY_EMPLOYEES_LU
SELECT * FROM BIRTHDAY_EMPLOYEES_LU
--- 11 --- CHECK
CREATE PROC SP_LU_1
@CITY VARCHAR(MAX) OUT
AS
BEGIN
SELECT @CITY = 
END

CREATE PROC SP_LU_2
AS
BEGIN

END


--- 12 ---
--USE MINUS 

--- 14 ---
SELECT [FIRST NAME] + ' ' + [LAST NAME] + IFNULL([MIDDLE NAME]+'.','') FROM TABLE 

--- 15 ---
SELEC TOP 1 Marks
FROM TABLE
WHERE SEX = 'F'
ORDER BY MARKS

--- 16 ---
SELECT *
FROM TABLE
ORDER BY SEX, MARKS DESC