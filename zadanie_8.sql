-- 1. Wykorzystuj¹c wyra¿enie CTE zbuduj zapytanie, które znajdzie informacje na temat stawki 
--pracownika oraz jego danych, a nastêpnie zapisze je do tabeli tymczasowej 

USE AdventureWorks2019;

WITH TempEmployeeInfo(
NationalIDNumber,
LoginID,
JobTitle,
BirthDate,
MaritalStatus,
Gender,
Rate)

AS(
SELECT NationalIDNumber,
LoginID,
JobTitle,
BirthDate,
MaritalStatus,
Gender,
Rate
FROM AdventureWorks2019.HumanResources.Employee e
INNER JOIN AdventureWorks2019.HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
)
SELECT * FROM TempEmployeeInfo;


--2. Uzyskaj informacje na temat przychodów ze sprzeda¿y wed³ug firmy i kontaktu (za pomoc¹ 
--CTE i bazy AdventureWorksL)
WITH IncomeInfo(
	Contact,
	Income
)
AS 
(
SELECT 	CONCAT(CompanyName, ' (', FirstName,' ', LastName, ')') AS Contact,
	TotalDue AS Income
FROM AdventureWorksLT2019.SalesLT.Customer c
INNER JOIN AdventureWorksLT2019.SalesLT.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
)

SELECT * FROM IncomeInfo
ORDER BY Contact;


--3. Napisz zapytanie, które zwróci wartoœæ sprzeda¿y dla poszczególnych kategorii produktów.
--Wykorzystaj CTE i bazê AdventureWorksLT
--UnitPrice- cena produktu
--UnitPriceDiscount - zni¿ka
--OrderQty - zamówiona iloœæ

WITH Sales(
	Category,
	SalesPrice
)
AS
(
SELECT pc."Name" AS Category,
	SUM(ROUND((UnitPrice-UnitPriceDiscount)*OrderQty, 2)) AS SalesPrice
FROM AdventureWorksLT2019.SalesLT.Product p
INNER JOIN AdventureWorksLT2019.SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
INNER JOIN AdventureWorksLT2019.SalesLT.SalesOrderDetail sod ON p.ProductID = sod.ProductID	
GROUP BY pc."Name"
)

SELECT * FROM Sales;
