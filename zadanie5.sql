--1.Stworz nowa baze danych
CREATE DATABASE firma2;

USE firma2;

--2.Stworz schemat ksiegowosc
CREATE SCHEMA ksiegowosc;

--3.Dodaj do schematu tabele pracownicy
CREATE TABLE ksiegowosc.pracownicy (
id_pracownika INT PRIMARY KEY,
imie VARCHAR(50),
nazwisko VARCHAR(70) NOT NULL,
adres VARCHAR(150),
telefon VARCHAR(12) UNIQUE,
);
--Dodaj do schematu tabele godziny
CREATE TABLE ksiegowosc.godziny (
id_godziny INT PRIMARY KEY,
data1 DATE NOT NULL,
liczba_godzin INT NOT NULL,
id_pracownika INT
);
--Dodaj do schematu tabele pensje
CREATE TABLE ksiegowosc.pensje (
id_pensji INT PRIMARY KEY,
stanowisko VARCHAR(50) NOT NULL,
kwota DECIMAL NOT NULL,
);
--Dodaj do schematu tabele premie
CREATE TABLE ksiegowosc.premie (
id_premii INT PRIMARY KEY,
rodzaj VARCHAR(50),
kwota DECIMAL NOT NULL
);
--Dodaj do schematu tabele wynagrodzenia
CREATE TABLE ksiegowosc.wynagrodzenia (
id_wynagrodzenia INT PRIMARY KEY,
data1 DATE, 
id_pracownika INT NOT NULL,
id_godziny INT,
id_pensji INT,
id_premii INT
);

--Dodawanie kluczy obcych

ALTER TABLE ksiegowosc.godziny
ADD FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika);

ALTER TABLE ksiegowosc.wynagrodzenia
ADD FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika);

ALTER TABLE ksiegowosc.wynagrodzenia
ADD FOREIGN KEY (id_godziny) REFERENCES ksiegowosc.godziny(id_godziny);

ALTER TABLE ksiegowosc.wynagrodzenia
ADD FOREIGN KEY (id_pensji) REFERENCES ksiegowosc.pensje(id_pensji);

ALTER TABLE ksiegowosc.wynagrodzenia
ADD FOREIGN KEY (id_premii) REFERENCES ksiegowosc.premie(id_premii);

--Komentarz do tabeli pracownicy
EXEC sp_addextendedproperty
@name = 'Opis tabeli pracownicy',
@value = 'Tabela zawierająca dane pracowników',
@level0type = 'Schema',
@level0name = 'ksiegowosc',
@level1type = 'Table',
@level1name = 'pracownicy';

--Komentarz do tabeli godziny
EXEC sp_addextendedproperty
@name = 'Opis tabeli godziny',
@value = 'Tabela zawierająca informacje o czasie pracy',
@level0type = 'Schema',
@level0name = 'ksiegowosc',
@level1type = 'Table',
@level1name = 'godziny';

--Komentarz do tabeli pensje
EXEC sp_addextendedproperty
@name = 'Opis tabeli pensje',
@value = 'Tabela zawierająca informacje o pensjach pracowników',
@level0type = 'Schema',
@level0name = 'ksiegowosc',
@level1type = 'Table',
@level1name = 'pensje';

--Komentarz do tabeli premie
EXEC sp_addextendedproperty
@name = 'Opis tabeli premie',
@value = 'Tabela zawierająca informacje o premiach pracowników',
@level0type = 'Schema',
@level0name = 'ksiegowosc',
@level1type = 'Table',
@level1name = 'premie';

--Komentarz do tabeli wynagrodzenia
EXEC sp_addextendedproperty
@name = 'Opis tabeli wynagrodzenia',
@value = 'Tabela zwierająca informacje o pełnym wynagrodzeniu',
@level0type = 'Schema',
@level0name = 'ksiegowosc',
@level1type = 'Table',
@level1name = 'wynagrodzenia';

-- Wyświetlanie komentarzy do tabel

SELECT value AS Comment
FROM sys.extended_properties
WHERE major_id = 
OBJECT_ID('księgowość.pracownicy')
AND minor_id = 0
AND class = 1;


--4. Wprowadzenie danych do tabeli
INSERT INTO ksiegowosc.pracownicy VALUES (1, 'Stefan', 'Maj', 'ul. Zwierzyniecka 5, Krakow, 32-890', '+48475839445')
INSERT INTO ksiegowosc.pracownicy VALUES (2, 'Weronika', 'Kuna', 'ul. Magnoliowa 1b, Katowice, 35-890', '+48775490637')
INSERT INTO ksiegowosc.pracownicy VALUES (3, 'Jan', 'Adamczyk', 'ul. Prosta 65/45, Kraków, 30-059', '+48389778565')
INSERT INTO ksiegowosc.pracownicy VALUES (4, 'Natalia', 'Drabek', 'ul. Krótka 56, Kraków, 31-098', '+48789676300')
INSERT INTO ksiegowosc.pracownicy VALUES (5, 'Adam', 'Koj', 'al.Mickiewicza 15, Kraków, 31-867', '+48664056730')
INSERT INTO ksiegowosc.pracownicy VALUES (6, 'Filip', 'Las', 'ul. Zakątek 3/49, Lublin, 70-388', '+48504367590')
INSERT INTO ksiegowosc.pracownicy VALUES (7, 'Wojciech', 'Maj', 'ul. Dąbrowskiej 3a, Łódź, 90-001', '+48998034504')
INSERT INTO ksiegowosc.pracownicy VALUES (8, 'Katarzyna', 'Nowak', 'ul. Dąbrowskiej 80, Niepołomice, 33-657', '+48202345489')
INSERT INTO ksiegowosc.pracownicy VALUES (9, 'Ewa', 'Koc', 'ul. Maki 22/34, Warszawa, 22-005', '+48336948576')
INSERT INTO ksiegowosc.pracownicy VALUES (10, 'Mateusz', 'Kowalski', 'ul. Dobczycka 78/1, Wieliczka, 32-768', '+48116748500')

INSERT INTO ksiegowosc.godziny VALUES (154, '2023-04-20', 160, 10)
INSERT INTO ksiegowosc.godziny VALUES (155, '2023-04-20', 170, 2)
INSERT INTO ksiegowosc.godziny VALUES (156, '2023-04-20', 160, 3)
INSERT INTO ksiegowosc.godziny VALUES (157, '2023-04-20', 165, 1)
INSERT INTO ksiegowosc.godziny VALUES (158, '2023-04-20', 160, 7)
INSERT INTO ksiegowosc.godziny VALUES (159, '2023-04-20', 160, 8)
INSERT INTO ksiegowosc.godziny VALUES (160, '2023-04-20', 180, 9)
INSERT INTO ksiegowosc.godziny VALUES (161, '2023-04-20', 160, 5)
INSERT INTO ksiegowosc.godziny VALUES (162, '2023-04-20', 170, 6)
INSERT INTO ksiegowosc.godziny VALUES (163, '2023-04-20', 160, 4)

INSERT INTO ksiegowosc.pensje VALUES (1,'dyrektor', 20500.15)
INSERT INTO ksiegowosc.pensje VALUES (2,'inżynier', 8200.45)
INSERT INTO ksiegowosc.pensje VALUES (3,'programista', 8500.23)
INSERT INTO ksiegowosc.pensje VALUES (4,'manager', 10400.67)
INSERT INTO ksiegowosc.pensje VALUES (5,'asystent', 5600.78)
INSERT INTO ksiegowosc.pensje VALUES (6,'stażysta', 950.11)
INSERT INTO ksiegowosc.pensje VALUES (7,'inżynier', 8200.45)
INSERT INTO ksiegowosc.pensje VALUES (8,'stażysta', 2500.11)
INSERT INTO ksiegowosc.pensje VALUES (9,'programista', 8500.45)
INSERT INTO ksiegowosc.pensje VALUES (10,'stażysta', 1150.00)

INSERT INTO ksiegowosc.premie VALUES (44, 'świąteczna', 1500)
INSERT INTO ksiegowosc.premie VALUES (45, 'uznaniowa', 500)
INSERT INTO ksiegowosc.premie VALUES (46, 'indywidualna', 350)
INSERT INTO ksiegowosc.premie VALUES (47, 'świąteczna', 1000)
INSERT INTO ksiegowosc.premie VALUES (48, 'kwartalna', 300)
INSERT INTO ksiegowosc.premie VALUES (49, 'motywacyjna', 250)
INSERT INTO ksiegowosc.premie VALUES (50, 'świąteczna', 500)
INSERT INTO ksiegowosc.premie VALUES (51, 'motywacyjna', 250)
INSERT INTO ksiegowosc.premie VALUES (52, 'świąteczna', 500)
INSERT INTO ksiegowosc.premie VALUES (53, 'motywacyjna', 250)

INSERT INTO ksiegowosc.wynagrodzenia VALUES (10,'2023-04-30',1,157,2,NULL)
INSERT INTO ksiegowosc.wynagrodzenia VALUES (11,'2023-04-30',2,155,4,46)
INSERT INTO ksiegowosc.wynagrodzenia VALUES (12,'2023-04-30',3,156,6,NULL)
INSERT INTO ksiegowosc.wynagrodzenia VALUES (13,'2023-04-30',4,163,5,45)
INSERT INTO ksiegowosc.wynagrodzenia VALUES (14,'2023-04-30',5,162,3,50)
INSERT INTO ksiegowosc.wynagrodzenia VALUES (15,'2023-04-30',6,154,10,53)
INSERT INTO ksiegowosc.wynagrodzenia VALUES (16,'2023-04-30',7,159,9,NULL)
INSERT INTO ksiegowosc.wynagrodzenia VALUES (17,'2023-04-30',8,158,7,51)
INSERT INTO ksiegowosc.wynagrodzenia VALUES (18,'2023-04-30',9,161,1,48)
INSERT INTO ksiegowosc.wynagrodzenia VALUES (19,'2023-04-30',10,160,8,NULL)

--5a Wyświetl tylko id pracownika oraz jego nazwisko
SELECT id_pracownika, nazwisko 
FROM ksiegowosc.pracownicy;

--5b  Wyświetl id pracowników, których płaca jest większa niż 1000
SELECT id_pracownika 
FROM ksiegowosc.wynagrodzenia
INNER JOIN ksiegowosc.pensje ON ksiegowosc.pensje.[id_pensji] = ksiegowosc.wynagrodzenia.[id_pensji]
LEFT OUTER JOIN ksiegowosc.premie ON ksiegowosc.premie.[id_premii] = ksiegowosc.wynagrodzenia.[id_premii]
WHERE (pensje.[kwota]+ ISNULL(premie.[kwota], 0)) > 1000;

--5c  Wyświetl id pracowników nieposiadających premii, których płaca jest większa niż 2000
SELECT id_pracownika
FROM ksiegowosc.wynagrodzenia
INNER JOIN ksiegowosc.pensje ON ksiegowosc.pensje.[id_pensji] = ksiegowosc.wynagrodzenia.[id_pensji]
LEFT OUTER JOIN ksiegowosc.premie ON ksiegowosc.premie.[id_premii] = ksiegowosc.wynagrodzenia.[id_premii]
WHERE wynagrodzenia.[id_premii] IS NULL AND (pensje.[kwota]+ ISNULL(premie.[kwota], 0)) > 2000;

--5d Wyświetl pracowników, których pierwsza litera imienia zaczyna się na literę ‘J’
SELECT *
FROM ksiegowosc.pracownicy
WHERE imie LIKE 'J%';

--5e Wyświetl pracowników, których nazwisko zawiera literę ‘n’ oraz imię kończy się na literę ‘a’.
SELECT *
FROM ksiegowosc.pracownicy
WHERE nazwisko LIKE '%n%' AND imie LIKE '%a';

--5f Wyświetl imię i nazwisko pracowników oraz liczbę ich nadgodzin, przyjmując, iż standardowy czas pracy to 160 h miesięcznie. 
SELECT imie, nazwisko, godziny.[liczba_godzin]-160 as liczba_nadgodzin
FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.godziny ON ksiegowosc.godziny.[id_pracownika] = ksiegowosc.pracownicy.[id_pracownika]
WHERE (liczba_godzin-160)>0;

--5g Wyświetl imię i nazwisko pracowników, których pensja zawiera się w przedziale 1500 – 3000 PLN.
SELECT imie, nazwisko
FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.wynagrodzenia ON ksiegowosc.wynagrodzenia.[id_pracownika] = ksiegowosc.pracownicy.[id_pracownika]
INNER JOIN ksiegowosc.pensje ON ksiegowosc.pensje.[id_pensji] = ksiegowosc.wynagrodzenia.[id_pensji]
LEFT OUTER JOIN ksiegowosc.premie ON ksiegowosc.premie.[id_premii] = ksiegowosc.wynagrodzenia.[id_premii]
WHERE (pensje.[kwota]+ ISNULL(premie.[kwota], 0)) BETWEEN 1500 AND 3200;

--5h Wyświetl imię i nazwisko pracowników, którzy pracowali w nadgodzinachi nie otrzymali premii
SELECT imie, nazwisko
FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.godziny ON ksiegowosc.godziny.[id_pracownika] = ksiegowosc.pracownicy.[id_pracownika]
INNER JOIN ksiegowosc.wynagrodzenia ON ksiegowosc.wynagrodzenia.[id_pracownika] = ksiegowosc.godziny.[id_pracownika]
LEFT OUTER JOIN ksiegowosc.premie ON ksiegowosc.premie.[id_premii] = ksiegowosc.wynagrodzenia.[id_premii]
WHERE (liczba_godzin-160) > 0 AND wynagrodzenia.[id_premii] IS NULL;

--5i Uszereguj pracowników według pensji
SELECT pracownicy.[id_pracownika], imie, nazwisko, kwota
FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.wynagrodzenia ON ksiegowosc.wynagrodzenia.[id_pracownika] = ksiegowosc.pracownicy.[id_pracownika]
INNER JOIN ksiegowosc.pensje ON ksiegowosc.pensje.[id_pensji] = ksiegowosc.wynagrodzenia.[id_pensji]
ORDER BY pensje.[kwota];

--5j Uszereguj pracowników według pensji i premii malejąco
SELECT pracownicy.[id_pracownika], imie, nazwisko, pensje.[kwota] as pensja, premie.[kwota] as premia
FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.wynagrodzenia ON ksiegowosc.wynagrodzenia.[id_pracownika] = ksiegowosc.pracownicy.[id_pracownika]
INNER JOIN ksiegowosc.pensje ON ksiegowosc.pensje.[id_pensji] = ksiegowosc.wynagrodzenia.[id_pensji]
LEFT OUTER JOIN ksiegowosc.premie ON ksiegowosc.premie.[id_premii] = ksiegowosc.wynagrodzenia.[id_premii]
ORDER BY pensje.[kwota] desc, premie.[kwota] desc; 

--5k Zlicz i pogrupuj pracowników według pola ‘stanowisko'
SELECT pensje.stanowisko, count(pracownicy.id_pracownika) AS ilość_pracowników  
FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.wynagrodzenia ON ksiegowosc.wynagrodzenia.[id_pracownika] = ksiegowosc.pracownicy.[id_pracownika]
INNER JOIN ksiegowosc.pensje ON ksiegowosc.pensje.[id_pensji] = ksiegowosc.wynagrodzenia.[id_pensji]
GROUP BY pensje.[stanowisko];

--5l Policz średnią, minimalną i maksymalną płacę dla stanowiska ‘stażysta’ 
SELECT stanowisko, MIN(pensje.[kwota]+ISNULL(premie.[kwota],0)) AS "minimalna", MAX(pensje.[kwota]+ISNULL(premie.[kwota],0)) AS "maksymalna", AVG(pensje.[kwota]+ISNULL(premie.[kwota],0)) AS "średnia"
FROM ksiegowosc.wynagrodzenia
INNER JOIN ksiegowosc.pensje ON ksiegowosc.pensje.[id_pensji] = ksiegowosc.wynagrodzenia.[id_pensji]
LEFT OUTER JOIN ksiegowosc.premie ON ksiegowosc.premie.[id_premii] = ksiegowosc.wynagrodzenia.[id_premii]
WHERE stanowisko = 'stażysta'
GROUP BY stanowisko;

--5m Policz sumę wszystkich wynagrodzeń
SELECT (SUM(pensje.[kwota])) + SUM(ISNULL(premie.[kwota],0)) AS suma_wynagrodzeń
FROM ksiegowosc.wynagrodzenia
INNER JOIN ksiegowosc.pensje ON ksiegowosc.pensje.[id_pensji] = ksiegowosc.wynagrodzenia.[id_pensji]
LEFT OUTER JOIN ksiegowosc.premie ON ksiegowosc.premie.[id_premii] = ksiegowosc.wynagrodzenia.[id_premii]
;

--5n Policz sumę wynagrodzeń w ramach danego stanowiska
SELECT pensje.[stanowisko], (SUM(pensje.[kwota])) + SUM(ISNULL(premie.[kwota],0)) AS suma_wynagrodzeń
FROM ksiegowosc.wynagrodzenia
INNER JOIN ksiegowosc.pensje ON ksiegowosc.pensje.[id_pensji] = ksiegowosc.wynagrodzenia.[id_pensji]
LEFT OUTER JOIN ksiegowosc.premie ON ksiegowosc.premie.[id_premii] = ksiegowosc.wynagrodzenia.[id_premii]
GROUP BY pensje.stanowisko 
;

--5o Wyznacz liczbę premii przyznanych dla pracowników danego stanowiska.
SELECT pensje.[stanowisko], COUNT(premie.id_premii) AS liczba_premii
FROM ksiegowosc.wynagrodzenia
INNER JOIN ksiegowosc.pensje ON ksiegowosc.pensje.[id_pensji] = ksiegowosc.wynagrodzenia.[id_pensji]
LEFT OUTER JOIN ksiegowosc.premie ON ksiegowosc.premie.[id_premii] = ksiegowosc.wynagrodzenia.[id_premii]
GROUP BY pensje.[stanowisko];

--5p Usuń wszystkich pracowników mających pensję mniejszą niż 1200 zł.
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
GO
DELETE pracownicy
FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.wynagrodzenia ON ksiegowosc.wynagrodzenia.[id_pracownika] = ksiegowosc.pracownicy.[id_pracownika]
INNER JOIN ksiegowosc.pensje ON ksiegowosc.pensje.[id_pensji] = ksiegowosc.wynagrodzenia.[id_pensji]
	WHERE pensje.[kwota] < 1200;
GO

SELECT * FROM ksiegowosc.pracownicy;
