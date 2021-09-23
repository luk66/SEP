----- Assignment Day2 –SQL:  Comprehensive practice ----
--1.	What is a result set? 
		--Result set is a set of rows from a database, as well as metadata about the query such as the column names, and the types and sizes of each column.

--2.	What is the difference between Union and Union All?
		-- UNION will remove the duplicates, UNION ALL does not
		--  UNOIN values for first column will be sorted automatically. UNION will not.
		-- UNION cannot be used in recursive cte, UNION ALL can

--3.	What are the other Set Operators SQL Server has? 
		--INTERSETCT, MINUS

--4.	What is the difference between Union and Join?  
		--Union combines in rows while join combines in columns.

--5.	What is the difference between INNER JOIN and FULL JOIN? 
		--Inner join only returns mathed rows pairs while full join returns all the row pairs.

--6.	What is difference between left join and outer join? 
		--Left join return all records from left table, matched records from right table; for the non-matched records in the right table, return null values
		-- Outer join gives rows in both tables, filling null with no maching rows 

--7.	What is cross join?
		-- cross join creates the Cartesian product of two tables, which is all the combination.

--8.	What is the difference between WHERE clause and HAVING clause?
		--1) HAVING applies only to groups as a whole, but WHERE applied to individual rows
		--2) WHERE goes before aggregations, HAVING goes after the aggreagations
		--3) WHERE can be used with SELECT and UPDATE; Having only SELECT

--9.	Can there be multiple group by columns? 
		-- Yes 

USE [AdventureWorks2019]
----- 1 ----
SELECT COUNT(ProductID) 
FROM Production.Product

----- 2 ----
SELECT COUNT(ProductSubcategoryID)
FROM Production.Product

---- 3 ----
SELECT ProductSubcategoryID , COUNT(ProductSubcategoryID) CountedProducts
FROM Production.Product 
GROUP BY ProductSubcategoryID

---- 4 ---- 
SELECT COUNT(*)
FROM Production.Product
WHERE ProductSubcategoryID IS NULL


---- 5 ----
SELECT SUM(Quantity)
FROM Production.ProductInventory

---- 6 ----
SELECT ProductID, SUM(Quantity) TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(QUANTITY) < 100

--- 7 ---
SELECT Shelf, ProductID, SUM(Quantity) TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(QUANTITY) < 100

--- 8 ---
SELECT ProductID, AVG(Quantity) TheAvg
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID

--- 9 ---
SELECT Shelf, ProductID, AVG(Quantity) TheAvg
FROM Production.ProductInventory
GROUP BY Shelf, ProductID

--- 10 ---
SELECT Shelf, ProductID, AVG(Quantity) TheAvg
FROM Production.ProductInventory
WHERE Shelf <> 'N/A'
GROUP BY Shelf, ProductID

--- 11 ---
SELECT Color, Class, COUNT(*) as 'TheCount', AVG(ListPrice) as'AvgPrice'
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class

--- JOIN ---
--- 12 ---
SELECT CR.Name AS Country, SP.Name AS Province
FROM Person.CountryRegion CR
JOIN PERSON.StateProvince SP
ON CR.CountryRegionCode = SP.CountryRegionCode

--- 13 ---
SELECT CR.Name AS Country, SP.Name AS Province
FROM Person.CountryRegion CR
JOIN PERSON.StateProvince SP
ON CR.CountryRegionCode = SP.CountryRegionCode
WHERE CR.Name IN ('Germany', 'Canada')

USE [Northwind]
--- 14 --- 
SELECT OD.ProductID, O.OrderDate
FROM DBO.Orders O
JOIN DBO.[Order Details] OD
ON O.OrderID = OD.OrderID
WHERE YEAR(GETDATE()) - YEAR(O.OrderDate) <= 25

--- 15 ---
SELECT TOP 5 O.ShipPostalCode, COUNT(O.OrderID) 'TOTAL'
FROM DBO.Orders O
GROUP BY O.ShipPostalCode
ORDER BY COUNT(*) DESC

--- 16 ---
SELECT TOP 5 O.ShipPostalCode, COUNT(O.OrderID) 'TOTAL'
FROM DBO.Orders O
WHERE YEAR(GETDATE()) - YEAR(O.OrderDate) <= 25
GROUP BY O.ShipPostalCode
ORDER BY COUNT(*) DESC

--- 17 ---
SELECT City, COUNT(*) COUNTNUM
FROM DBO.Customers
GROUP BY City

--- 18 ---
SELECT City, COUNT(*) COUNTNUM
FROM DBO.Customers
GROUP BY City
HAVING COUNT(*) >= 2

--- 19 ---
DECLARE @date date= '1998-1-1';  
SELECT C.ContactName, O.OrderDate
FROM DBO.Customers C
JOIN DBO.Orders O
ON O.CustomerID = C.CustomerID
WHERE O.OrderDate > @date

--- 20 ---
SELECT C.ContactName, MAX(O.OrderDate)
FROM DBO.Customers C
JOIN DBO.Orders O
ON O.CustomerID = C.CustomerID
GROUP BY C.ContactName

--- 21 ---
SELECT C.ContactName, SUM(OD.QUANTITY)
FROM DBO.Customers C
JOIN (DBO.[Order Details] OD JOIN DBO.Orders O ON OD.OrderID = O.OrderID)
ON C.CustomerID = O.CustomerID
GROUP BY C.ContactName

--- 22 ---
SELECT O.CustomerID, SUM(OD.QUANTITY)
FROM DBO.Orders O
JOIN DBO.[Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY O.CustomerID
HAVING SUM(OD.QUANTITY)>100

--- 23 ---
SELECT SU.CompanyName 'Supplier Company NamE', SH.CompanyName 'Shipping Company Name'
FROM DBO.Suppliers SU
CROSS JOIN DBO.Shippers SH

--- 24 ---
SELECT O.OrderDate, (SELECT PRODUCTNAME FROM DBO.Products WHERE ProductID = OD.ProductID) 'PRODUCTNAME'
FROM DBO.Orders O
JOIN DBO.[Order Details] OD
ON O.OrderID = OD.OrderID

--- 25 ---
SELECT A.EmployeeID, B.EmployeeID, A.Title, B.Title
FROM DBO.Employees A
JOIN DBO.Employees B
ON A.Title = B.Title
WHERE A.EmployeeID <> B.EmployeeID

--- 26 --- CHECK
SELECT A.EmployeeID
FROM DBO.Employees A, DBO.Employees B
WHERE B.ReportsTo = A.EmployeeID
GROUP BY A.EmployeeID
HAVING COUNT(*) > 2

--- 27 ---
SELECT C.City 'CITY NAME', C.ContactName 'CONTACT NAME', 'CUSTOMER' AS 'TYPE'
FROM DBO.Customers C
UNION
SELECT S.City 'CITY NAME', S.ContactName 'CONTACT NAME', 'SUPPLIER' AS 'TYPE'
FROM DBO.Suppliers S
