USE firma2;
SELECT telefon FROM ksiegowosc.pracownicy

--a) Zmodyfikuj numer telefonu w tabeli pracownicy, dodaj¹c do niego kierunkowy dla Polski w nawiasie (+48)
ALTER TABLE ksiegowosc.pracownicy
ADD telefon1 VARCHAR(14);

UPDATE ksiegowosc.pracownicy
SET telefon1 = CONCAT('(', SUBSTRING(telefon, 1, 3), ')', SUBSTRING(telefon, 4,9))
SELECT telefon1 FROM ksiegowosc.pracownicy

--b) Zmodyfikuj atrybut telefon w tabeli pracownicy tak, aby numer oddzielony by³ myœlnikami wg wzoru: ‘555-222-333’
ALTER TABLE ksiegowosc.pracownicy
ADD telefon2 VARCHAR(11);

UPDATE ksiegowosc.pracownicy
SET telefon2 = CONCAT(SUBSTRING(REPLACE(telefon, '+48', ''), 1, 3), '-', SUBSTRING(REPLACE(telefon, '+48', ''), 4, 3), '-', SUBSTRING(REPLACE(telefon, '+48', ''), 7, 3));
SELECT telefon2 FROM ksiegowosc.pracownicy

--c) Wyœwietl dane pracownika, którego nazwisko jest najd³u¿sze, u¿ywaj¹c du¿ych liter
SELECT UPPER(nazwisko) as naj_nazwisko
FROM ksiegowosc.pracownicy
WHERE LEN(nazwisko) = (SELECT MAX(LEN(nazwisko)) FROM ksiegowosc.pracownicy)

--d) Wyœwietl dane pracowników i ich pensje zakodowane przy pomocy algorytmu md5 
SELECT
	HASHBYTES('MD5', CAST(pracownicy.id_pracownika AS CHAR)) AS id_pracownika_md5,
	HASHBYTES('MD5', pracownicy.imie) AS imie_md5,
	HASHBYTES('MD5', pracownicy.nazwisko) AS nazwisko_md5,
	HASHBYTES('MD5', pracownicy.adres) AS adres_md5,
	HASHBYTES('MD5', pracownicy.telefon) AS telefon_md5,
	HASHBYTES('MD5', CAST(pensje.kwota AS CHAR)) AS pensja_md5
FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.wynagrodzenia ON ksiegowosc.wynagrodzenia.[id_pracownika] = ksiegowosc.pracownicy.[id_pracownika]
INNER JOIN ksiegowosc.pensje ON ksiegowosc.pensje.[id_pensji] = ksiegowosc.wynagrodzenia.[id_pensji];


--f) Wyœwietl pracowników, ich pensje oraz premie. Wykorzystaj z³¹czenie lewostronne

SELECT pracownicy.id_pracownika, pracownicy.imie, pracownicy.nazwisko, pensje.kwota AS pensja, ISNULL(premie.kwota,0) AS premia
FROM ksiegowosc.pracownicy 
LEFT OUTER JOIN ksiegowosc.wynagrodzenia ON ksiegowosc.wynagrodzenia.[id_pracownika] = ksiegowosc.pracownicy.[id_pracownika]
LEFT OUTER JOIN ksiegowosc.pensje ON ksiegowosc.pensje.[id_pensji] = ksiegowosc.wynagrodzenia.[id_pensji]
LEFT OUTER JOIN ksiegowosc.premie ON ksiegowosc.premie.[id_premii] = ksiegowosc.wynagrodzenia.[id_premii];

--g) wygeneruj raport (zapytanie), które zwróci w wyniki treœæ wg poni¿szego szablonu:
--Pracownik Jan Nowak, w dniu 7.08.2017 otrzyma³ pensjê ca³kowit¹ na kwotê 7540 z³, 
--gdzie wynagrodzenie zasadnicze wynosi³o: 5000 z³, premia: 2000 z³, nadgodziny: 540 z³

-- utworzenie zmiennej nadgodziny
ALTER TABLE ksiegowosc.pracownicy
ADD nadgodziny_kwota int;

UPDATE ksiegowosc.pracownicy 
SET nadgodziny_kwota = (liczba_godzin-160)*50
FROM ksiegowosc.pracownicy
INNER JOIN ksiegowosc.godziny ON ksiegowosc.godziny.[id_pracownika] = ksiegowosc.pracownicy.[id_pracownika]
WHERE liczba_godzin > 160;
--wyœwietlenie
SELECT nadgodziny_kwota
FROM ksiegowosc.pracownicy


SELECT CONCAT(
   'Pracownik ', pracownicy.imie, ' ', pracownicy.nazwisko,
   ', w dniu ', godziny.data1,
   ' otrzyma³ pensjê ca³kowit¹ na kwotê ', 
	pensje.kwota +ISNULL(premie.kwota, 0) +ISNULL(pracownicy.nadgodziny_kwota, 0),
	' z³, gdzie wynagrodzenie zasadnicze wynosi³o: ', pensje.kwota, ' z³, premia: ', ISNULL(premie.kwota, 0), ' z³, nadgodziny: ', ISNULL(pracownicy.nadgodziny_kwota, 0), ' z³'
	) AS raport
FROM ksiegowosc.pracownicy 
LEFT OUTER JOIN ksiegowosc.wynagrodzenia ON ksiegowosc.wynagrodzenia.[id_pracownika] = ksiegowosc.pracownicy.[id_pracownika] 
LEFT OUTER JOIN ksiegowosc.pensje ON ksiegowosc.pensje.[id_pensji] = ksiegowosc.wynagrodzenia.[id_pensji]
LEFT OUTER JOIN ksiegowosc.premie ON ksiegowosc.premie.[id_premii] = ksiegowosc.wynagrodzenia.[id_premii]
LEFT OUTER JOIN ksiegowosc.godziny ON ksiegowosc.godziny.[id_pracownika] = ksiegowosc.pracownicy.[id_pracownika];

