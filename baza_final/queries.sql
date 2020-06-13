-------------------------PROJEKCJE--------------------------

--wyswietl liste wszytskich pracownikow (imie i nazwisko)
SELECT CONCAT(CONCAT(imie,' '),nazwisko) AS pracownik
FROM pracownicy;

--wyswietl wszytskie nardzedzia i ich kody seryjne
SELECT rodzaj_narzedzia, kod_seryjny
FROM narzedzia;

--wyswietl najbardziej kosztowne zamowienia
SELECT id_zam_materialu, koszt_calkowity, data_zamowienia
FROM zamowienia_materialow
ORDER BY koszt_calkowity DESC;

--wyswietl wszytskie materialy i ich stan
SELECT opis_materialu, stan 
FROM materialy;

--dla zlecen budowy: wyswietl id budynku, date rozpoczenia i liczbe dni, które minely do ukonczenia
SELECT id_budynku, data_zlecenia, (data_ukonczenia - data_zlecenia) AS liczba_dni
FROM zlecenia_budowy;

--wyswietl adresy budynkow
SELECT adres
FROM budynki;

--wyswietl pracownikow - pogrupowanych na brygady
SELECT imie, nazwisko, brygada
FROM pracownicy
ORDER BY brygada;

--wyswietl, ile pracownikow ma kazda brygada
SELECT brygada, COUNT(id_pracownika) as liczba_pracownikow
FROM pracownicy
GROUP BY brygada;

--wyswietl 3 najczesciej reklamowane budynki
SELECT reklamacje.id_budynku, COUNT(data_reklamacji) AS liczba_reklamacji
FROM reklamacje
GROUP BY reklamacje.id_budynku
ORDER BY liczba_reklamacji DESC
FETCH NEXT 3 ROWS ONLY;

--dla kazdego zamowienia oblicz koszt pojedynczej jednostki zamawianego produktu
SELECT id_zam_materialu, (koszt_calkowity / ilosc) as koszt_jednostkowy
FROM zamowienia_materialow;

------------------------SELEKCJE-------------------------------

--wyswietl, ile jest wszytsktkich steropianow 
SELECT opis_materialu, stan 
FROM materialy 
WHERE opis_materialu LIKE 'steropian%'
ORDER BY stan DESC;

--wyswietl wszytstkich pracownikow zatrudnionych w 2016 roku
SELECT * 
FROM pracownicy
WHERE data_zatrudnienia > to_date('16-01-01') AND data_zatrudnienia < to_date('16-12-31');

--wyswietl wszytskie wkretarki, wiedzac, ze kod seryjny wkretarki zaczyna sie od JLP
SELECT id_narzedzia, data_zakupu, cena
FROM narzedzia
WHERE kod_seryjny LIKE 'JLP%';

--wyswietl kobiety pracujace w firmie
SELECT CONCAT(CONCAT(imie,' '),nazwisko) AS pracownik
FROM pracownicy
WHERE imie LIKE '%a';


--wyswietl calkowity koszt zamowien materialow w 2016 roku
SELECT SUM(koszt_calkowity) AS koszt_materialow_2016
FROM zamowienia_materialow
WHERE data_zamowienia > to_date('16-01-01') AND data_zamowienia < to_date('16-12-31');

--wyswietl wszytskich pracownikow 7 brygady
SELECT * 
FROM pracownicy
WHERE brygada = 7;

--wyswietl, ktorych materialow brakuje
SELECT id_materialu, opis_materialu
FROM materialy
WHERE stan = 0;

--wyswietl wszytskie zlecenia budowy sprzed 2014 roku
SELECT * 
FROM zlecenia_budowy
WHERE data_zlecenia < to_date('14-01-01');

--ktore zamowienia czekaly na dostawe ponad tydzien?
CREATE TABLE dl_zam AS  --pomocnicza tabelka z czasem realizacji zamowienia
SELECT id_zam_materialu, data_zamowienia, data_dostarczenia, (data_dostarczenia - data_zamowienia) AS czas_realizacji
FROM zamowienia_materialow;
SELECT *
FROM dl_zam
WHERE czas_realizacji > 7;

--wyswietl budynki z metrazem wiekszym niz 200m
SELECT adres, metraz
FROM budynki
WHERE metraz > 200;

-------------------ZLACZENIA DWOCH TABEL-------------------

--wyswietl wszytstkich brygadzistow
SELECT imie, nazwisko, brygada
FROM pracownicy JOIN brygady
    ON pracownicy.brygada = brygady.id_brygady
WHERE id_brygadzisty = id_pracownika
ORDER BY pracownicy.brygada ASC;

--na podstawie zamowien oblicz sredni koszt jednostowy dla kazdego materialu:
SELECT opis_materialu, materialy.id_materialu, AVG((koszt_calkowity / ilosc)) as sr_koszt_jednostkowy
FROM zamowienia_materialow JOIN materialy 
    ON zamowienia_materialow.id_zam_materialu = materialy.id_materialu
GROUP BY opis_materialu, materialy.id_materialu;

--wyswietl najczesciej wypozyczane narzedzia
SELECT narzedzia.id_narzedzia, narzedzia.rodzaj_narzedzia, COUNT (narzedzia_wypozyczenia.data_wyp) AS liczba_wypozyczen
FROM narzedzia JOIN narzedzia_wypozyczenia
    ON narzedzia.id_narzedzia = narzedzia_wypozyczenia.id_narzedzia
GROUP BY narzedzia.id_narzedzia, narzedzia.rodzaj_narzedzia
ORDER BY liczba_wypozyczen DESC;

--wyswietl dostawcow, od których najczesciej byl zamawiany material
SELECT dostawcy.adres, dostawcy.id_dostawcy, COUNT(zamowienia_materialow.data_zamowienia) AS liczba_zamowien
FROM dostawcy JOIN zamowienia_materialow 
    ON dostawcy.id_dostawcy = zamowienia_materialow.id_dostawcy
GROUP BY dostawcy.adres, dostawcy.id_dostawcy
ORDER BY liczba_zamowien DESC;

--wyswietl najdluzsze wypozyczenia
SELECT narzedzia.id_narzedzia, rodzaj_narzedzia, (narzedzia_wypozyczenia.data_zwr - narzedzia_wypozyczenia.data_wyp) AS dlugosc_wypozyczenia
FROM narzedzia JOIN narzedzia_wypozyczenia ON narzedzia_wypozyczenia.id_narzedzia = narzedzia.id_narzedzia
ORDER BY dlugosc_wypozyczenia DESC;

--wyswietl pracownikow najczesciej wypozyczajacych narzedzia
SELECT imie, nazwisko, COUNT(data_wyp) AS liczba_wypozyczonych_narzedzi
FROM pracownicy JOIN narzedzia_wypozyczenia
    ON pracownicy.id_pracownika = narzedzia_wypozyczenia.id_pracownika
GROUP BY imie, nazwisko
ORDER BY liczba_wypozyczonych_narzedzi DESC;

--wyswietl piec najczesciej zamawianych materialow
SELECT materialy.opis_materialu, COUNT (zamowienia_materialow.data_zamowienia) AS liczba_zamowien
FROM materialy JOIN zamowienia_materialow ON materialy.id_materialu = zamowienia_materialow.id_zam_materialu
GROUP BY materialy.opis_materialu
ORDER BY liczba_zamowien DESC
FETCH NEXT 5 ROWS ONLY;

--wyswietl klientow, ktorzy zlecali wiecej niz jeden budynek
CREATE TABLE temp AS   --tabelka pomocnicza
SELECT imie, nazwisko, COUNT(zlecenia_budowy.data_zlecenia) as liczba_zlecen
FROM zlecenia_budowy JOIN klienci ON zlecenia_budowy.id_klienta = klienci.id_klienta
GROUP BY imie, nazwisko;
SELECT imie, nazwisko 
FROM temp 
WHERE liczba_zlecen > 1;

--wyswietl osoby, ktore wypozyczaly narzedzia w 2017 roku
SELECT imie, nazwisko, COUNT (narzedzia_wypozyczenia.data_wyp) as wyp
FROM pracownicy JOIN narzedzia_wypozyczenia ON pracownicy.id_pracownika = narzedzia_wypozyczenia.id_pracownika
WHERE narzedzia_wypozyczenia.data_wyp > to_date('16-01-01') AND narzedzia_wypozyczenia.data_wyp < to_date('16-12-31')
GROUP BY imie, nazwisko;

--wyswietl wszytskie wypozyczenia mieszadel
SELECT narzedzia_wypozyczenia.id_narzedzia, id_pracownika, data_wyp, data_zwr
FROM narzedzia_wypozyczenia JOIN narzedzia ON narzedzia_wypozyczenia.id_narzedzia = narzedzia.id_narzedzia
WHERE narzedzia.rodzaj_narzedzia = 'mieszadlo';



--------------------ZLACZENIA TRZECH TABEL---------------------

--dla kazdego zlecenia w 2012 roku: wyswietl brygade, id brygadzisty, adres i metraz budynku
SELECT zlecenia_budowy.id_brygady, brygady.id_brygadzisty, budynki.adres, budynki.metraz
FROM (zlecenia_budowy JOIN brygady ON zlecenia_budowy.id_brygady = brygady.id_brygady ) 
    JOIN budynki ON zlecenia_budowy.id_budynku = budynki.id_budynku
WHERE zlecenia_budowy.data_zlecenia > to_date('12-01-01') AND zlecenia_budowy.data_zlecenia < to_date('12-12-31');

--jakie narzedzia wypozyczal Eligiusz Guzewicz?
SELECT imie, nazwisko, narzedzia.rodzaj_narzedzia, narzedzia_wypozyczenia.data_wyp
FROM (pracownicy JOIN narzedzia_wypozyczenia ON pracownicy.id_pracownika = narzedzia_wypozyczenia.id_pracownika)
    JOIN narzedzia ON narzedzia_wypozyczenia.id_narzedzia = narzedzia.id_narzedzia
WHERE (imie LIKE 'Eligiusz') AND (nazwisko LIKE 'Guzewicz');

--jaki metraz "wykonala" brygada 10?
SELECT brygady.id_brygady, SUM(budynki.metraz) AS metraz_brygady
FROM (brygady JOIN zlecenia_budowy ON zlecenia_budowy.id_brygady = brygady.id_brygady)
    JOIN budynki ON zlecenia_budowy.id_budynku = budynki.id_budynku
WHERE brygady.id_brygady = 10
GROUP BY brygady.id_brygady;

--wyswietl klientow skladajacych reklamacje i tresc reklamacji
SELECT CONCAT(CONCAT(klienci.imie,' '),klienci.nazwisko) AS klient, reklamacje.opis AS tresc_reklamacji
FROM (klienci JOIN zlecenia_budowy ON zlecenia_budowy.id_klienta = klienci.id_klienta)
    JOIN reklamacje ON zlecenia_budowy.id_budynku = reklamacje.id_budynku;
    
--wyswietl zlecenia budowy, ktore byly reklamowane
SELECT budynki.id_budynku, data_zlecenia, data_ukonczenia, data_reklamacji, adres, opis
FROM (reklamacje JOIN budynki ON reklamacje.id_budynku = budynki.id_budynku)
    JOIN zlecenia_budowy ON zlecenia_budowy.id_budynku = reklamacje.id_budynku;
    
--wyswietl, ile kazdego materialu dostarczyl kazdy dostawca
SELECT materialy.id_materialu, dostawcy.id_dostawcy, SUM(ilosc) AS ilosc_dostarczonego_materialu
FROM (materialy JOIN zamowienia_materialow ON materialy.id_materialu = zamowienia_materialow.id_zam_materialu)
    JOIN dostawcy ON zamowienia_materialow.id_dostawcy = dostawcy.id_dostawcy
GROUP BY materialy.id_materialu, dostawcy.id_dostawcy
ORDER BY materialy.id_materialu;

--wyswietl wypozyczenia narzedzi przez brygadzistow
SELECT narzedzia_wypozyczenia.id_narzedzia, id_brygadzisty, data_wyp, data_zwr, imie, nazwisko, brygady.id_brygady
FROM (narzedzia_wypozyczenia JOIN pracownicy ON pracownicy.id_pracownika = narzedzia_wypozyczenia.id_pracownika)
    JOIN brygady ON pracownicy.brygada = brygady.id_brygady
WHERE (pracownicy.id_pracownika = narzedzia_wypozyczenia.id_pracownika) AND (pracownicy.id_pracownika = brygady.id_brygadzisty);

--dla kazdego zlecenia wyswietl klienta i brygadziste danego zlecenia
SELECT id_budynku,CONCAT(CONCAT(imie,' '),nazwisko) AS Klient, brygady.id_brygadzisty AS Brygadzista
FROM (klienci JOIN zlecenia_budowy ON zlecenia_budowy.id_klienta = klienci.id_klienta)
    JOIN brygady ON brygady.id_brygady = zlecenia_budowy.id_brygady;
    
--posortuj brygady wg wykonanego metrazu w 2012 roku
SELECT brygady.id_brygady, SUM(budynki.metraz) AS metraz_brygady
FROM (brygady JOIN zlecenia_budowy ON zlecenia_budowy.id_brygady = brygady.id_brygady)
    JOIN budynki ON zlecenia_budowy.id_budynku = budynki.id_budynku
WHERE zlecenia_budowy.data_zlecenia > to_date('12-01-01') AND zlecenia_budowy.data_zlecenia < to_date('12-12-31')
GROUP BY brygady.id_brygady
ORDER BY metraz_brygady DESC;

--pogrupuj brygady wedlug sredniego czasu realizacji zlecenia.
SELECT brygada, AVG(data_ukonczenia - data_zlecenia) AS sredni_czas_realizacji
FROM (zlecenia_budowy JOIN brygady ON zlecenia_budowy.id_brygady = brygady.id_brygady)
    JOIN pracownicy ON pracownicy.id_pracownika = brygady.id_brygadzisty
GROUP BY brygada;
    

    


