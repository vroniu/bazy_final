--MODYFIKACJE--

--1. modyfikacja istniejacyh tabel
ALTER TABLE pracownicy 
    ADD (data_urodzenia DATE,
        data_zwolnienia DATE NULL);   --dla aktualnych prawcownikow wartosc tego pola wynosi null

ALTER TABLE klienci 
    ADD (data_urodzenia DATE);
    
ALTER TABLE dostawcy  
    MODIFY adres VARCHAR(200) --zwiekszenie pola na adresy dostawcow
    ADD nazwa_dostawcy VARCHAR(50);
    
--2. tworzenie nowych tabel "od zera"

CREATE TABLE pojazdy_sluzbowe (
    nr_rejestracyjny VARCHAR(8),
    marka VARCHAR(20) NOT NULL,
    mdel VARCHAR(20) NOT NULL,
    rodzaj VARCHAR(10) NOT NULL,
    CONSTRAINT ps_prim_key PRIMARY KEY (nr_rejestracyjny)
    );
    
CREATE TABLE wypozyczenia_pojazdow (
    nr_rejestracyjny VARCHAR(8),
    id_pracownika INT,
    data_wyp DATE,
    data_zwr DATE,
    CONSTRAINT wp_prim_key PRIMARY KEY (nr_rejestracyjny, id_pracownika, data_wyp),
    CONSTRAINT nr_fk FOREIGN KEY (nr_rejestracyjny) REFERENCES pojazdy_sluzbowe(nr_rejestracyjny),
    CONSTRAINT pr_fk FOREIGN KEY (id_pracownika) REFERENCES pracownicy(id_pracownika),
    CONSTRAINT popr_data CHECK (data_zwr > data_wyp)
    );
    
    
--3. tworzenie nowych tabel na podstawie istniejacych danych

CREATE TABLE brygadzisci (   --tworzenie tabeli
    imie VARCHAR(20) NOT NULL,
    nazwisko VARCHAR (40) NOT NULL,
    id_podporzadkowanej_brygady INT
    );
    
INSERT INTO brygadzisci  --skopiowanie danych
SELECT imie, nazwisko, brygada
FROM pracownicy JOIN brygady
    ON pracownicy.brygada = brygady.id_brygady
WHERE id_brygadzisty = id_pracownika;


ALTER TABLE brygadzisci  --dodatnie odpowiedniego pola
    ADD data_objecia_stanowiska DATE;
    

    





    

    

