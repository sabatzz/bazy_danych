--1.Utwórz nową bazę danych o nazwie firma
CREATE DATABASE firma;

USE firma;

--2.Dodaj schemat o nazwie rozliczenia
CREATE SCHEMA rozliczenia;

--3.Dodaj do schematu tabele pracownicy
CREATE TABLE rozliczenia.pracownicy (
id_pracownika INT PRIMARY KEY,
imie VARCHAR(50),
nazwisko VARCHAR(70) NOT NULL,
adres VARCHAR(150),
telefon VARCHAR(12) UNIQUE,
);
--Dodaj do schematu tabele godziny
CREATE TABLE rozliczenia.godziny (
id_godziny INT PRIMARY KEY,
data1 DATE NOT NULL,
liczba_godzin INT NOT NULL,
id_pracownika INT
);
--Dodaj do schematu tabele pensje
CREATE TABLE rozliczenia.pensje (
id_pensji INT PRIMARY KEY,
stanowisko VARCHAR(50) NOT NULL,
kwota DECIMAL NOT NULL,
id_premii INT,
);
--Dodaj do schematu tabele premie
CREATE TABLE rozliczenia.premie (
id_premii INT PRIMARY KEY,
rodzaj VARCHAR(50),
kwota DECIMAL NOT NULL
);
--4. Wprowadzenie danych do tabeli
INSERT INTO rozliczenia.pracownicy VALUES (1, 'Stefan', 'Maj', 'ul. Zwierzyniecka 5, Krakow, 32-890', '+48475839445')
INSERT INTO rozliczenia.pracownicy VALUES (2, 'Weronika', 'Kula', 'ul. Magnoliowa 1b, Katowice, 35-890', '+48775490637')
INSERT INTO rozliczenia.pracownicy VALUES (3, 'Jan', 'Adamczyk', 'ul. Prosta 65/45, Kraków, 30-059', '+48389778565')
INSERT INTO rozliczenia.pracownicy VALUES (4, 'Natalia', 'Drabek', 'ul. Krótka 56, Kraków, 31-098', '+48789676300')
INSERT INTO rozliczenia.pracownicy VALUES (5, 'Adam', 'Koj', 'al.Mickiewicza 15, Kraków, 31-867', '+48664056730')
INSERT INTO rozliczenia.pracownicy VALUES (6, 'Filip', 'Las', 'ul. Zakątek 3/49, Lublin, 70-388', '+48504367590')
INSERT INTO rozliczenia.pracownicy VALUES (7, 'Wojciech', 'Maj', 'ul. Dąbrowskiej 3a, Łódź, 90-001', '+48998034504')
INSERT INTO rozliczenia.pracownicy VALUES (8, 'Katarzyna', 'Nowak', 'ul. Dąbrowskiej 80, Niepołomice, 33-657', '+48202345489')
INSERT INTO rozliczenia.pracownicy VALUES (9, 'Ewa', 'Koc', 'ul. Maki 22/34, Warszawa, 22-005', '+48336948576')
INSERT INTO rozliczenia.pracownicy VALUES (10, 'Mateusz', 'Kowalski', 'ul. Dobczycka 78/1, Wieliczka, 32-768', '+48116748500')

INSERT INTO rozliczenia.godziny VALUES (154, '2023-04-20', 9, 10)
INSERT INTO rozliczenia.godziny VALUES (155, '2023-04-20', 8, 2)
INSERT INTO rozliczenia.godziny VALUES (156, '2023-04-20', 8, 3)
INSERT INTO rozliczenia.godziny VALUES (157, '2023-04-20', 10, 1)
INSERT INTO rozliczenia.godziny VALUES (158, '2023-04-20', 8, 7)
INSERT INTO rozliczenia.godziny VALUES (159, '2023-04-20', 8, 8)
INSERT INTO rozliczenia.godziny VALUES (160, '2023-04-20', 9, 9)
INSERT INTO rozliczenia.godziny VALUES (161, '2023-04-20', 8, 5)
INSERT INTO rozliczenia.godziny VALUES (162, '2023-04-20', 8, 6)
INSERT INTO rozliczenia.godziny VALUES (163, '2023-04-20', 8.5, 4)

INSERT INTO rozliczenia.pensje VALUES (1,'dyrektor', 20500.15,44)
INSERT INTO rozliczenia.pensje VALUES (2,'inżynier', 8200.45,45)
INSERT INTO rozliczenia.pensje VALUES (3,'programista', 8500.23,46)
INSERT INTO rozliczenia.pensje VALUES (4,'manager', 10400.67,47)
INSERT INTO rozliczenia.pensje VALUES (5,'asystent', 5600.78,48)
INSERT INTO rozliczenia.pensje VALUES (6,'stażysta', 3200.11,49)
INSERT INTO rozliczenia.pensje VALUES (7,'inżynier', 8200.45,50)
INSERT INTO rozliczenia.pensje VALUES (8,'stażysta', 3200.11,51)
INSERT INTO rozliczenia.pensje VALUES (9,'programista', 8500.45,52)
INSERT INTO rozliczenia.pensje VALUES (10,'stażysta', 3200.11,53)

INSERT INTO rozliczenia.premie VALUES (44, 'świąteczna', 1500)
INSERT INTO rozliczenia.premie VALUES (45, 'uznaniowa', 500)
INSERT INTO rozliczenia.premie VALUES (46, 'indywidualna', 350)
INSERT INTO rozliczenia.premie VALUES (47, 'świąteczna', 1000)
INSERT INTO rozliczenia.premie VALUES (48, 'kwartalna', 300)
INSERT INTO rozliczenia.premie VALUES (49, 'motywacyjna', 250)
INSERT INTO rozliczenia.premie VALUES (50, 'świąteczna', 500)
INSERT INTO rozliczenia.premie VALUES (51, 'motywacyjna', 250)
INSERT INTO rozliczenia.premie VALUES (52, 'świąteczna', 500)
INSERT INTO rozliczenia.premie VALUES (53, 'motywacyjna', 250)

--Dodawanie kluczy obcych

ALTER TABLE rozliczenia.godziny
ADD FOREIGN KEY (id_pracownika) REFERENCES rozliczenia.pracownicy(id_pracownika);

ALTER TABLE rozliczenia.pensje
ADD FOREIGN KEY (id_premii) REFERENCES rozliczenia.premie(id_premii);

--5.Wyświetlanie kolumn: nazwisko i adres pracowników
SELECT nazwisko, adres  FROM rozliczenia.pracownicy

--6. Konwersja daty
SELECT DATEPART ( w , data1 ) as 'dzien_tygodnia ', DATEPART ( m , data1 ) as 'miesiac' FROM rozliczenia.godziny;

--7. Zmiana kwoty na kwotę brutto, utworzenie nowego atrybutu oraz wyliczenie kwoty netto 
EXEC sp_rename 'rozliczenia.pensje.kwota', 'kwota_brutto', 'COLUMN';
ALTER TABLE rozliczenia.pensje ADD kwota_netto decimal(7,2);
UPDATE rozliczenia.pensje set kwota_netto=kwota_brutto*0.81;

SELECT kwota_brutto, kwota_netto from rozliczenia.pensje
