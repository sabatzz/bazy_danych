USE AdventureWorks2019;

--ZADANIE 1-------------------------------------------------------------

-- Napisz zapytanie, kt�re wykorzystuje transakcj� (zaczyna j�), a nast�pnie
--aktualizuje cen� produktu o ProductID r�wnym 680 w tabeli Production.Product
--o 10% i nast�pnie zatwierdza transakcj�.

SELECT * FROM Production.Product WHERE ProductID = 680

BEGIN TRANSACTION;

UPDATE Production.Product SET ListPrice = ListPrice * 1.1
WHERE ProductID = 680;

COMMIT TRANSACTION;

SELECT * FROM Production.Product

--ZADANIE 2----------------------------------------------------------------

-- Napisz zapytanie, kt�re zaczyna transakcj�, usuwa produkt o ProductID r�wnym
--707 z tabeli Production.Product, ale nast�pnie wycofuje transakcj�. 

SELECT * FROM Production.Product WHERE ProductID = 707;

--Wy��czenie sprawdzania ogranicze� (kluczy obcych, regu�)
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all";  

BEGIN TRANSACTION;

DELETE FROM Production.Product
WHERE ProductID = 707;

ROLLBACK TRANSACTION;

--ZADANIE 3------------------------------------------------------------------

-- Napisz zapytanie, kt�re zaczyna transakcj�, dodaje nowy produkt do tabeli
--Production.Product, a nast�pnie zatwierdza transakcj� 

--W��czenie mo�liwo�ci wstawiania kolumn
SET IDENTITY_INSERT Production.Product ON 

BEGIN TRANSACTION;

INSERT INTO Production.Product (ProductID, Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate, rowguid, ModifiedDate)
VALUES (1000, 'Nowy produkt', 'ABC-123', 1, 1, 200, 500, 1234.56, 2000.00, 1000, '2013-06-01 10:00:00.000', 'F5752C9C-56BA-41A7-83FD-139DA28C15FB', '2014-02-08 10:01:25.100');

COMMIT TRANSACTION;

SELECT * FROM Production.Product WHERE ProductID = 1000;

--ZADANIE 4-------------------------------------------------------------------

--Napisz zapytanie, kt�re zaczyna transakcj� i aktualizuje StandardCost wszystkich
--produkt�w w tabeli Production.Product o 10%, je�eli suma wszystkich
--StandardCost po aktualizacji nie przekracza 50000. W przeciwnym razie zapytanie
--powinno wycofa� transakcj�.

BEGIN TRANSACTION;

-- Aktualizacja StandardCost o 10%
UPDATE Production.Product
SET StandardCost = StandardCost * 1.1;

-- Sprawdzenie sumy wszystkich StandardCost po aktualizacji
DECLARE @TotalCost DECIMAL(10, 2);
SELECT @TotalCost = SUM(StandardCost) FROM Production.Product;

-- Warunek sprawdzaj�cy sum� i zatwierdzenie lub wycofanie transakcji
IF @TotalCost <= 50000
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Transakcja zosta�a zatwierdzona.';
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transakcja zosta�a wycofana, poniewa� suma StandardCost przekroczy�a 50000.';
END

--ZADANIE 5------------------------------------------------------------------

--Napisz zapytanie SQL, kt�re zaczyna transakcj� i pr�buje doda� nowy produkt do
--tabeli Production.Product. Je�li ProductNumber ju� istnieje w tabeli, zapytanie
--powinno wycofa� transakcj�. 

--W��czenie mo�liwo�ci wstawiania kolumn
SET IDENTITY_INSERT Production.Product ON 

BEGIN TRANSACTION;

-- Sprawdzenie, czy ProductNumber ju� istnieje w tabeli
IF EXISTS (SELECT 1 FROM Production.Product WHERE ProductNumber = 'NP-123')
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transakcja zosta�a wycofana, poniewa� ProductNumber ju� istnieje w tabeli.';
END
ELSE
BEGIN
    -- Dodanie nowego produktu
    INSERT INTO Production.Product (ProductID, Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate, rowguid, ModifiedDate)
	VALUES (1001, 'Nowszy produkt', 'NP-123', 1, 1, 350, 250, 3000, 2500, 30, '2013-05-30 00:00:00.000', 'F5752C9C-56BA-41A7-83FD-139DA28C15FC', '2014-02-08 10:01:36.827');

    COMMIT TRANSACTION;
    PRINT 'Transakcja zosta�a zatwierdzona. Dodano nowy produkt.';
END

--ZADANIE 6---------------------------------------------------------------------

--Napisz zapytanie SQL, kt�re zaczyna transakcj� i aktualizuje warto�� OrderQty
--dla ka�dego zam�wienia w tabeli Sales.SalesOrderDetail. Je�eli kt�rykolwiek z
--zam�wie� ma OrderQty r�wn� 0, zapytanie powinno wycofa� transakcj�.

BEGIN TRANSACTION;

-- Sprawdzenie, czy kt�rykolwiek z zam�wie� ma OrderQty r�wn� 0
IF EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE OrderQty = 0)
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transakcja wycofana. Jedno z zam�wie� ma OrderQty r�wn� 0.';
END
ELSE
BEGIN
    -- Aktualizacja warto�ci OrderQty dla wszystkich zam�wie�
    UPDATE Sales.SalesOrderDetail
    SET OrderQty = OrderQty + 1; -- dowolna operacja aktualizacji

    COMMIT TRANSACTION;
    PRINT 'Transakcja zatwierdzona. Warto�ci OrderQty zosta�y zaktualizowane dla wszystkich zam�wie�.';
END

--Napisz zapytanie SQL, kt�re zaczyna transakcj� i usuwa wszystkie produkty,
--kt�rych StandardCost jest wy�szy ni� �redni koszt wszystkich produkt�w w tabeli
--Production.Product. Je�eli liczba produkt�w do usuni�cia przekracza 10,
--zapytanie powinno wycofa� transakcj�   

BEGIN TRANSACTION;

-- Obliczenie �redniego kosztu wszystkich produkt�w
DECLARE @AverageCost DECIMAL(10, 2);
SELECT @AverageCost = AVG(StandardCost) FROM Production.Product;

-- Usuni�cie produkt�w, kt�rych StandardCost jest wy�szy ni� �redni koszt
DELETE FROM Production.Product
WHERE StandardCost > @AverageCost;

-- Sprawdzenie liczby usuni�tych produkt�w
DECLARE @DeletedCount INT;
SELECT @DeletedCount = @@ROWCOUNT;

-- Sprawdzenie, czy liczba usuni�tych produkt�w przekracza 10
IF @DeletedCount > 10
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transakcja zosta�a wycofana, poniewa� liczba produkt�w do usuni�cia jest wi�ksza ni� 10.';
END
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Transakcja zosta�a zatwierdzona. Usuni�to ' + CAST(@DeletedCount AS VARCHAR) + ' produkt�w.';
END

