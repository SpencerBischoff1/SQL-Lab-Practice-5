


-- Logical Query Processing 

/*
SELECT -- List Columns to be shown
FROM -- specifcy tables to include in the query 
	JOIN -- additional tables can be added to the working data set
WHERE -- boolean logic used to filter rows from the working data set
	AND/OR -- subsequent boolean logic can be applied using ...
GROUP BY -- Collapses group of rows into a single row
HAVING -- filtesr rows based on boolean logic applied to aggregations 
ORDER BY -- Used to sort the working dataset


-- Logical query processing (order the rdbms runs it in)
FROM
	JOIN
WHERE
GROUP BY
HAVING
SELECT
ORDER BY 
*/

SELECT CustomerID,
	CONCAT( FirstName, '', MiddleName, '', LastName ) AS CustomerName,
	[State],
	EmailOptIn
FROM Customers
	WHERE State <> 'NM'
	AND EmailOptIn = 'Y'
ORDER BY CustomerID ASC;

-- Joins

SELECT P.ProductID,
	   ProductName,
	   PriceChangeDate,
	   p.SalesPrice
FROM Products AS P
INNER JOIN ProductPriceHistory AS H
	ON P.ProductID = H.ProductID


-- Question 3

SELECT E.EmployeeID,
	   CONCAT( E.FirstName, '', MiddleName, '', E.LastName, '') AS EmployeeName,
	   COUNT( DependentNumber ) AS DependentCount
FROM Employees AS E
INNER JOIN Dependents AS D
	ON E.EmployeeID = D.EmployeeID
GROUP BY E.EmployeeID,
	CONCAT( E.FirstName, '', MiddleName, '', E.LastName, '')
ORDER BY DependentCount DESC 

-- Question 4

SELECT C.CustomerID, 
	   C.FirstName,
	   C.LastName
FROM Customers AS C
INNER JOIN CustomerEmails as E
ON C.CustomerID = E.CustomerID
WHERE E.PrimaryEmailFlag = 'N'

-- Question 5

Select C.CustomerID,
	   FirstName,
	   LastName,
	   [State],
	   OrderDate,
	   (Price * Quantity) AS OrderTotal
FROM Customers AS C
INNER JOIN Orders AS O
ON C.CustomerID = O.CustomerID
INNER JOIN OrderLines AS OL
ON O.OrderID = OL.OrderID
WHERE [State] IN ('WA','CA')
GROUP BY C.CustomerID, FirstName, LastName, [State], OrderDate, OL.Price, OL.Quantity
ORDER BY OrderDate DESC


-- Question 6

SELECT E.EmployeeID,
	   CONCAT( E.FirstName, '', E.MiddleName, '' , E.LastName, '') AS EmployeeName,
	   [State],
	   CONCAT( D.FirstName, '', D.LastName, '') AS DependentName,
	   FLOOR( DATEDIFF(DAY, BirthDate, GETDATE() ) / 365.25) AS Age
FROM Employees AS E
INNER JOIN Dependents AS D
ON E.EmployeeID = E.EmployeeID
WHERE [State] = 'CO'
ORDER BY BirthDate DESC


-- Question 7

SELECT YEAR(O.OrderDate) AS OrderYear,
	   MONTH(O.OrderDate) AS OrderMonth,
	   SUM(Price * Quantity) AS SalesVolume	   
FROM Orders AS O
INNER JOIN OrderLines AS OL
ON O.OrderID = O.OrderID
GROUP BY O.OrderDate, Price, Quantity
ORDER BY OrderYear ASC, OrderMonth DESC

-- Question 8

SELECT O.OrderID,
	   OrderDate
FROM Orders AS O
	WHERE O.OrderID, OrderDate IN ( SELECT TOP 1 StatusName 
		FROM Statuses AS S
		INNER JOIN OrderStatuses AS OS
	ON S.StatusID = OS.StatusID
	    
	   ) AS CurrentStatus
FROM Orders AS O
--INNER JOIN OrderStatuses AS OS
--ON O.OrderID = OS.OrderID

-- Question 9

SELECT CONCAT(FirstName, '', MiddleName, '', LastName),
	   Title,
	   Salary
FROM Employees
WHERE Salary IN (SELECT AVG(Salary)
				 FROM Employees
				 GROUP BY Salary
				);


-- Question 10

SELECT V.VendorID,
	   VendorName,
	   VendorDescription,
	   ProductName
FROM Vendors AS V
INNER JOIN ProductVendors AS PV
ON V.VendorID = PV.VendorID
INNER JOIN Products AS P
ON PV.ProductID = P.ProductID
WHERE ProductName LIKE '%Bear%'
ORDER BY VendorID ASC