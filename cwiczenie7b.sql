-- Napisz procedur� wypisuj�c� do konsoli ci�g Fibonacciego. 
--Procedura musi przyjmowa� jako argument wej�ciowy liczb� n. 
--Generowanie ci�gu Fibonacciego musi zosta� zaimplementowane jako osobna funkcja, wywo�ywana przez procedur�.

CREATE PROCEDURE Fibonacci
	@n INT  --liczba argument�w
AS
BEGIN
	DECLARE @i INT = 1; --iteracja

	WHILE @i <= @n   --przej�cie p�tli przez iteracje
	BEGIN
		PRINT dbo.FibonacciGenerate(@i); --druk na konsoli
		SET @i = @i +1; --inkrementacja
	END
END
GO

CREATE FUNCTION FibonacciGenerate
(
	@n INT --liczba argument�w
)
RETURNS BIGINT
AS
BEGIN
	DECLARE @numer1 INT = 0;   --pierwsz liczba
	DECLARE @numer2 INT = 1;   --druga liczba
	DECLARE @wynik BIGINT;     --aktualnie generowana liczba
	DECLARE @i INT = 1;        --iteracje

	WHILE @i<=@n   --przej�cie p�tli przez iteracje
	BEGIN
		SET @wynik = @numer1 + @numer2;
		SET @numer1 = @numer2;
		SET @numer2 = @wynik;
		SET @i = @i+1;
	END
RETURN @numer1; --ostania wygenerowana liczba w ci�gu
END
GO

EXEC Fibonacci @n = 12;

USE AdventureWorks2019;

--Przygotuj trigger �taxRateMonitoring�, 
--kt�ry wy�wietli komunikat o b��dzie, je�eli nast�pi 
--zmiana warto�ci w polu �TaxRate� o wi�cej ni� 30%.

CREATE TRIGGER taxRateMonitoring1
ON Sales.SalesTaxRate
AFTER UPDATE --trigger ma by� wyzwalany po operacji update
AS
BEGIN
--Sprawdzenie zmienionych rekord�w
	IF UPDATE(TaxRate)
	BEGIN
	--Pobranie nowych i starych wartosci TaxRate
	    DECLARE @NewTaxRate DECIMAL(10, 2);
        DECLARE @OldTaxRate DECIMAL(10, 2);

        SELECT @NewTaxRate = TaxRate FROM inserted; --nowe warto�ci
        SELECT @OldTaxRate = TaxRate FROM deleted;  --poprzednie warto�ci (przed update)

        -- Obliczenie r�nicy 
        DECLARE @PercentageChange DECIMAL(10, 2);
        SET @PercentageChange = ABS((@NewTaxRate - @OldTaxRate) / @OldTaxRate * 100);

        -- Wy�wietlenie komunikatu o b��dzie, je�li zmiana przekracza 30%
        IF @PercentageChange > 30
        BEGIN
            THROW 50000, 'B��d! Zmiana warto�ci pola TaxRate przekracza 30%.', 1;
        END
    END
END

UPDATE Sales.SalesTaxRate SET TaxRate = 0.35 WHERE SalesTaxRateID = 1;

SELECT * FROM Sales.SalesTaxRate



-- Napisz trigger DML, kt�ry po wprowadzeniu danych do tabeli Persons zmodyfikuje nazwisko 
--tak, aby by�o napisane du�ymi literami. 

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

