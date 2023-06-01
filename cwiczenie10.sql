USE AdventureWorks2019;

--ZADANIE 1-------------------------------------------------------------

-- Napisz zapytanie, które wykorzystuje transakcję (zaczyna ją), a następnie
--aktualizuje cenę produktu o ProductID równym 680 w tabeli Production.Product
--o 10% i następnie zatwierdza transakcję.

SELECT * FROM Production.Product WHERE ProductID = 680

BEGIN TRANSACTION;

UPDATE Production.Product SET ListPrice = ListPrice * 1.1
WHERE ProductID = 680;

COMMIT TRANSACTION;

SELECT * FROM Production.Product

--ZADANIE 2----------------------------------------------------------------

-- Napisz zapytanie, które zaczyna transakcję, usuwa produkt o ProductID równym
--707 z tabeli Production.Product, ale następnie wycofuje transakcję. 

SELECT * FROM Production.Product WHERE ProductID = 707;

--Wyłączenie sprawdzania ograniczeń (kluczy obcych, reguł)
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all";  

BEGIN TRANSACTION;

DELETE FROM Production.Product
WHERE ProductID = 707;

ROLLBACK TRANSACTION;

--ZADANIE 3------------------------------------------------------------------

-- Napisz zapytanie, które zaczyna transakcję, dodaje nowy produkt do tabeli
--Production.Product, a następnie zatwierdza transakcję 

--Włączenie możliwości wstawiania kolumn
SET IDENTITY_INSERT Production.Product ON 

BEGIN TRANSACTION;

INSERT INTO Production.Product (ProductID, Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate, rowguid, ModifiedDate)
VALUES (1000, 'Nowy produkt', 'ABC-123', 1, 1, 200, 500, 1234.56, 2000.00, 1000, '2013-06-01 10:00:00.000', 'F5752C9C-56BA-41A7-83FD-139DA28C15FB', '2014-02-08 10:01:25.100');

COMMIT TRANSACTION;

SELECT * FROM Production.Product WHERE ProductID = 1000;

--ZADANIE 4-------------------------------------------------------------------

--Napisz zapytanie, które zaczyna transakcję i aktualizuje StandardCost wszystkich
--produktów w tabeli Production.Product o 10%, jeżeli suma wszystkich
--StandardCost po aktualizacji nie przekracza 50000. W przeciwnym razie zapytanie
--powinno wycofać transakcję.

BEGIN TRANSACTION;

-- Aktualizacja StandardCost o 10%
UPDATE Production.Product
SET StandardCost = StandardCost * 1.1;

-- Sprawdzenie sumy wszystkich StandardCost po aktualizacji
DECLARE @TotalCost DECIMAL(10, 2);
SELECT @TotalCost = SUM(StandardCost) FROM Production.Product;

-- Warunek sprawdzający sumę i zatwierdzenie lub wycofanie transakcji
IF @TotalCost <= 50000
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Transakcja została zatwierdzona.';
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transakcja została wycofana, ponieważ suma StandardCost przekroczyła 50000.';
END

--ZADANIE 5------------------------------------------------------------------

--Napisz zapytanie SQL, które zaczyna transakcję i próbuje dodać nowy produkt do
--tabeli Production.Product. Jeśli ProductNumber już istnieje w tabeli, zapytanie
--powinno wycofać transakcję. 

--Włączenie możliwości wstawiania kolumn
SET IDENTITY_INSERT Production.Product ON 

BEGIN TRANSACTION;

-- Sprawdzenie, czy ProductNumber już istnieje w tabeli
IF EXISTS (SELECT 1 FROM Production.Product WHERE ProductNumber = 'NP-123')
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transakcja została wycofana, ponieważ ProductNumber już istnieje w tabeli.';
END
ELSE
BEGIN
    -- Dodanie nowego produktu
    INSERT INTO Production.Product (ProductID, Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate, rowguid, ModifiedDate)
	VALUES (1001, 'Nowszy produkt', 'NP-123', 1, 1, 350, 250, 3000, 2500, 30, '2013-05-30 00:00:00.000', 'F5752C9C-56BA-41A7-83FD-139DA28C15FC', '2014-02-08 10:01:36.827');

    COMMIT TRANSACTION;
    PRINT 'Transakcja została zatwierdzona. Dodano nowy produkt.';
END

--ZADANIE 6---------------------------------------------------------------------

--Napisz zapytanie SQL, które zaczyna transakcję i aktualizuje wartość OrderQty
--dla każdego zamówienia w tabeli Sales.SalesOrderDetail. Jeżeli którykolwiek z
--zamówień ma OrderQty równą 0, zapytanie powinno wycofać transakcję.

BEGIN TRANSACTION;

-- Sprawdzenie, czy którykolwiek z zamówień ma OrderQty równą 0
IF EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE OrderQty = 0)
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transakcja wycofana. Jedno z zamówień ma OrderQty równą 0.';
END
ELSE
BEGIN
    -- Aktualizacja wartości OrderQty dla wszystkich zamówień
    UPDATE Sales.SalesOrderDetail
    SET OrderQty = OrderQty + 1; -- dowolna operacja aktualizacji

    COMMIT TRANSACTION;
    PRINT 'Transakcja zatwierdzona. Wartości OrderQty zostały zaktualizowane dla wszystkich zamówień.';
END

--ZADANIE 7-----------------------------------------------------------------------

--Napisz zapytanie SQL, które zaczyna transakcję i usuwa wszystkie produkty,
--których StandardCost jest wyższy niż średni koszt wszystkich produktów w tabeli
--Production.Product. Jeżeli liczba produktów do usunięcia przekracza 10,
--zapytanie powinno wycofać transakcję   

BEGIN TRANSACTION;

-- Obliczenie średniego kosztu wszystkich produktów
DECLARE @AverageCost DECIMAL(10, 2);
SELECT @AverageCost = AVG(StandardCost) FROM Production.Product;

-- Usunięcie produktów, których StandardCost jest wyższy niż średni koszt
DELETE FROM Production.Product
WHERE StandardCost > @AverageCost;

-- Sprawdzenie liczby usuniętych produktów
DECLARE @DeletedCount INT;
SELECT @DeletedCount = @@ROWCOUNT;

-- Sprawdzenie, czy liczba usuniętych produktów przekracza 10
IF @DeletedCount > 10
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transakcja została wycofana, ponieważ liczba produktów do usunięcia jest większa niż 10.';
END
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Transakcja została zatwierdzona. Usunięto ' + CAST(@DeletedCount AS VARCHAR) + ' produktów.';
END

