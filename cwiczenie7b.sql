-- Napisz procedurê wypisuj¹c¹ do konsoli ci¹g Fibonacciego. 
--Procedura musi przyjmowaæ jako argument wejœciowy liczbê n. 
--Generowanie ci¹gu Fibonacciego musi zostaæ zaimplementowane jako osobna funkcja, wywo³ywana przez procedurê.

CREATE PROCEDURE Fibonacci
	@n INT  --liczba argumentów
AS
BEGIN
	DECLARE @i INT = 1; --iteracja

	WHILE @i <= @n   --przejœcie pêtli przez iteracje
	BEGIN
		PRINT dbo.FibonacciGenerate(@i); --druk na konsoli
		SET @i = @i +1; --inkrementacja
	END
END
GO

CREATE FUNCTION FibonacciGenerate
(
	@n INT --liczba argumentów
)
RETURNS BIGINT
AS
BEGIN
	DECLARE @numer1 INT = 0;   --pierwsz liczba
	DECLARE @numer2 INT = 1;   --druga liczba
	DECLARE @wynik BIGINT;     --aktualnie generowana liczba
	DECLARE @i INT = 1;        --iteracje

	WHILE @i<=@n   --przejœcie pêtli przez iteracje
	BEGIN
		SET @wynik = @numer1 + @numer2;
		SET @numer1 = @numer2;
		SET @numer2 = @wynik;
		SET @i = @i+1;
	END
RETURN @numer1; --ostania wygenerowana liczba w ci¹gu
END
GO

EXEC Fibonacci @n = 12;

USE AdventureWorks2019;

--Przygotuj trigger ‘taxRateMonitoring’, 
--który wyœwietli komunikat o b³êdzie, je¿eli nast¹pi 
--zmiana wartoœci w polu ‘TaxRate’ o wiêcej ni¿ 30%.

CREATE TRIGGER taxRateMonitoring1
ON Sales.SalesTaxRate
AFTER UPDATE --trigger ma byæ wyzwalany po operacji update
AS
BEGIN
--Sprawdzenie zmienionych rekordów
	IF UPDATE(TaxRate)
	BEGIN
	--Pobranie nowych i starych wartosci TaxRate
	    DECLARE @NewTaxRate DECIMAL(10, 2);
        DECLARE @OldTaxRate DECIMAL(10, 2);

        SELECT @NewTaxRate = TaxRate FROM inserted; --nowe wartoœci
        SELECT @OldTaxRate = TaxRate FROM deleted;  --poprzednie wartoœci (przed update)

        -- Obliczenie ró¿nicy 
        DECLARE @PercentageChange DECIMAL(10, 2);
        SET @PercentageChange = ABS((@NewTaxRate - @OldTaxRate) / @OldTaxRate * 100);

        -- Wyœwietlenie komunikatu o b³êdzie, jeœli zmiana przekracza 30%
        IF @PercentageChange > 30
        BEGIN
            THROW 50000, 'B³¹d! Zmiana wartoœci pola TaxRate przekracza 30%.', 1;
        END
    END
END

UPDATE Sales.SalesTaxRate SET TaxRate = 0.35 WHERE SalesTaxRateID = 1;

SELECT * FROM Sales.SalesTaxRate



-- Napisz trigger DML, który po wprowadzeniu danych do tabeli Persons zmodyfikuje nazwisko 
--tak, aby by³o napisane du¿ymi literami. 

CREATE TRIGGER KonwersjaNazwisko
ON AdventureWorks2019.Person.Person
AFTER INSERT
AS
UPDATE Person.Person
SET LastName = UPPER(LastName)


INSERT INTO Person.BusinessEntity(rowguid) VALUES(newID())

INSERT INTO Person.Person(BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName) 
VALUES(20778, 'IN', 0, NULL, 'Zuzanna', 'Magdalena', 'Sabat')

SELECT * FROM Person.Person
GO

