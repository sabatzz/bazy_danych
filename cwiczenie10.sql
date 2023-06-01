USE AdventureWorks2019;

--ZADANIE 1-------------------------------------------------------------

-- Napisz zapytanie, które wykorzystuje transakcjê (zaczyna j¹), a nastêpnie
--aktualizuje cenê produktu o ProductID równym 680 w tabeli Production.Product
--o 10% i nastêpnie zatwierdza transakcjê.

SELECT * FROM Production.Product WHERE ProductID = 680

BEGIN TRANSACTION;

UPDATE Production.Product SET ListPrice = ListPrice * 1.1
WHERE ProductID = 680;

COMMIT TRANSACTION;

SELECT * FROM Production.Product

--ZADANIE 2----------------------------------------------------------------

-- Napisz zapytanie, które zaczyna transakcjê, usuwa produkt o ProductID równym
--707 z tabeli Production.Product, ale nastêpnie wycofuje transakcjê. 

SELECT * FROM Production.Product WHERE ProductID = 707;

--Wy³¹czenie sprawdzania ograniczeñ (kluczy obcych, regu³)
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all";  

BEGIN TRANSACTION;

DELETE FROM Production.Product
WHERE ProductID = 707;

ROLLBACK TRANSACTION;

--ZADANIE 3------------------------------------------------------------------

-- Napisz zapytanie, które zaczyna transakcjê, dodaje nowy produkt do tabeli
--Production.Product, a nastêpnie zatwierdza transakcjê 

--W³¹czenie mo¿liwoœci wstawiania kolumn
SET IDENTITY_INSERT Production.Product ON 

BEGIN TRANSACTION;

INSERT INTO Production.Product (ProductID, Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate, rowguid, ModifiedDate)
VALUES (1000, 'Nowy produkt', 'ABC-123', 1, 1, 200, 500, 1234.56, 2000.00, 1000, '2013-06-01 10:00:00.000', 'F5752C9C-56BA-41A7-83FD-139DA28C15FB', '2014-02-08 10:01:25.100');

COMMIT TRANSACTION;

SELECT * FROM Production.Product WHERE ProductID = 1000;

--ZADANIE 4-------------------------------------------------------------------

--Napisz zapytanie, które zaczyna transakcjê i aktualizuje StandardCost wszystkich
--produktów w tabeli Production.Product o 10%, je¿eli suma wszystkich
--StandardCost po aktualizacji nie przekracza 50000. W przeciwnym razie zapytanie
--powinno wycofaæ transakcjê.

BEGIN TRANSACTION;

-- Aktualizacja StandardCost o 10%
UPDATE Production.Product
SET StandardCost = StandardCost * 1.1;

-- Sprawdzenie sumy wszystkich StandardCost po aktualizacji
DECLARE @TotalCost DECIMAL(10, 2);
SELECT @TotalCost = SUM(StandardCost) FROM Production.Product;

-- Warunek sprawdzaj¹cy sumê i zatwierdzenie lub wycofanie transakcji
IF @TotalCost <= 50000
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Transakcja zosta³a zatwierdzona.';
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transakcja zosta³a wycofana, poniewa¿ suma StandardCost przekroczy³a 50000.';
END

--ZADANIE 5------------------------------------------------------------------

--Napisz zapytanie SQL, które zaczyna transakcjê i próbuje dodaæ nowy produkt do
--tabeli Production.Product. Jeœli ProductNumber ju¿ istnieje w tabeli, zapytanie
--powinno wycofaæ transakcjê. 

--W³¹czenie mo¿liwoœci wstawiania kolumn
SET IDENTITY_INSERT Production.Product ON 

BEGIN TRANSACTION;

-- Sprawdzenie, czy ProductNumber ju¿ istnieje w tabeli
IF EXISTS (SELECT 1 FROM Production.Product WHERE ProductNumber = 'NP-123')
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transakcja zosta³a wycofana, poniewa¿ ProductNumber ju¿ istnieje w tabeli.';
END
ELSE
BEGIN
    -- Dodanie nowego produktu
    INSERT INTO Production.Product (ProductID, Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate, rowguid, ModifiedDate)
	VALUES (1001, 'Nowszy produkt', 'NP-123', 1, 1, 350, 250, 3000, 2500, 30, '2013-05-30 00:00:00.000', 'F5752C9C-56BA-41A7-83FD-139DA28C15FC', '2014-02-08 10:01:36.827');

    COMMIT TRANSACTION;
    PRINT 'Transakcja zosta³a zatwierdzona. Dodano nowy produkt.';
END

--ZADANIE 6---------------------------------------------------------------------

--Napisz zapytanie SQL, które zaczyna transakcjê i aktualizuje wartoœæ OrderQty
--dla ka¿dego zamówienia w tabeli Sales.SalesOrderDetail. Je¿eli którykolwiek z
--zamówieñ ma OrderQty równ¹ 0, zapytanie powinno wycofaæ transakcjê.

BEGIN TRANSACTION;

-- Sprawdzenie, czy którykolwiek z zamówieñ ma OrderQty równ¹ 0
IF EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE OrderQty = 0)
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transakcja wycofana. Jedno z zamówieñ ma OrderQty równ¹ 0.';
END
ELSE
BEGIN
    -- Aktualizacja wartoœci OrderQty dla wszystkich zamówieñ
    UPDATE Sales.SalesOrderDetail
    SET OrderQty = OrderQty + 1; -- dowolna operacja aktualizacji

    COMMIT TRANSACTION;
    PRINT 'Transakcja zatwierdzona. Wartoœci OrderQty zosta³y zaktualizowane dla wszystkich zamówieñ.';
END

--Napisz zapytanie SQL, które zaczyna transakcjê i usuwa wszystkie produkty,
--których StandardCost jest wy¿szy ni¿ œredni koszt wszystkich produktów w tabeli
--Production.Product. Je¿eli liczba produktów do usuniêcia przekracza 10,
--zapytanie powinno wycofaæ transakcjê   

BEGIN TRANSACTION;

-- Obliczenie œredniego kosztu wszystkich produktów
DECLARE @AverageCost DECIMAL(10, 2);
SELECT @AverageCost = AVG(StandardCost) FROM Production.Product;

-- Usuniêcie produktów, których StandardCost jest wy¿szy ni¿ œredni koszt
DELETE FROM Production.Product
WHERE StandardCost > @AverageCost;

-- Sprawdzenie liczby usuniêtych produktów
DECLARE @DeletedCount INT;
SELECT @DeletedCount = @@ROWCOUNT;

-- Sprawdzenie, czy liczba usuniêtych produktów przekracza 10
IF @DeletedCount > 10
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transakcja zosta³a wycofana, poniewa¿ liczba produktów do usuniêcia jest wiêksza ni¿ 10.';
END
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Transakcja zosta³a zatwierdzona. Usuniêto ' + CAST(@DeletedCount AS VARCHAR) + ' produktów.';
END

