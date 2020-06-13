--TWORZENIE TABELI--
CREATE TABLE Pracownicy (
    id_pracownika INT,
    imie VARCHAR(20) NOT NULL,
    nazwisko VARCHAR(40) NOT NULL,
    data_zatrudnienia DATE NOT NULL,
    brygada INT NOT NULL,
    CONSTRAINT pracownicy_prim_key PRIMARY KEY (id_pracownika)
    );
    
CREATE TABLE Brygady (
    id_brygady INT,
    id_brygadzisty INT,
    CONSTRAINT brygady_prim_key PRIMARY KEY (id_brygady),
    CONSTRAINT fk_brygadzista FOREIGN KEY (id_brygadzisty) REFERENCES Pracownicy(id_pracownika)
    );

CREATE TABLE Klienci (
    id_klienta INT,
    imie VARCHAR(20) NOT NULL,
    nazwisko VARCHAR(20) NOT NULL,
    CONSTRAINT klienci_prim_key PRIMARY KEY (id_klienta)
    );

CREATE TABLE Dostawcy (
    id_dostawcy INT,
    adres VARCHAR(100),
    CONSTRAINT dostawcy_prim_key PRIMARY KEY (id_dostawcy)
    );

CREATE TABLE Narzedzia (
    id_narzedzia INT,
    kod_seryjny VARCHAR(10) NOT NULL,
    rodzaj_narzedzia VARCHAR(45) NOT NULL,
    data_zakupu DATE NOT NULL,
    cena INT NOT NULL,
    CONSTRAINT narzedzia_prim_key PRIMARY KEY (id_narzedzia),
    CONSTRAINT popr_cena CHECK (cena>0)  --sprawdza, czy cena jest liczba naturalna
    );
    
CREATE TABLE Narzedzia_wypozyczenia (
    id_narzedzia INT NOT NULL,
    id_pracownika INT NOT NULL,
    data_wyp DATE NOT NULL,
    data_zwr DATE,
    CONSTRAINT nwyp_prim_key PRIMARY KEY (id_narzedzia, id_pracownika, data_wyp),
    CONSTRAINT popr_data_zwrotu CHECK (data_wyp<=data_zwr)  --sprawdzanie, czy data zwrotu jest po dacie wypozyczenia
    );
    
CREATE TABLE Materialy (
    id_materialu INT,
    stan INT NOT NULL,
    opis_materialu VARCHAR(50) NOT NULL,
    CONSTRAINT mat_prim_key PRIMARY KEY (id_materialu),
    CONSTRAINT popr_stan CHECK(stan>=0)  --sprawdzenie, czy stan jest liczba naturalna
    );

CREATE TABLE Zamowienia_materialow (
    id_zam_materialu INT NOT NULL,
    id_dostawcy INT NOT NULL,
    ilosc INT NOT NULL,
    koszt_calkowity INT NOT NULL,
    data_zamowienia DATE NOT NULL,
    data_dostarczenia DATE,
    CONSTRAINT zm_prim_key PRIMARY KEY (id_zam_materialu, id_dostawcy, data_zamowienia),
    CONSTRAINT popr_ilosc CHECK (ilosc>0),  --sprawdzenie, czy ilosc zamawianego materialu jest wieksza od zera
    CONSTRAINT popr_koszt CHECK (koszt_calkowity>0),   --sprawdzanie, czy koszt jest wiekszy od zera
    CONSTRAINT popr_data_dostawy CHECK (data_zamowienia<=data_dostarczenia)  --sprawdzanie, czy data dostarczenia jest po dacie zamowienia
    );
    
CREATE TABLE Budynki (
    id_budynku INT,
    metraz INT NOT NULL,
    adres VARCHAR(100) NOT NULL,
    CONSTRAINT budynki_prim_key PRIMARY KEY (id_budynku),
    CONSTRAINT popr_metraz CHECK (metraz>0)  --sprawdzenie, czy liczba metrow jest liczba naturalna
);
    
CREATE TABLE Zlecenia_budowy (
    data_zlecenia DATE NOT NULL,
    data_ukonczenia DATE,
    id_brygady INT NOT NULL,
    id_klienta INT NOT NULL,
    id_budynku INT NOT NULL,
    CONSTRAINT zb_prim_key PRIMARY KEY (id_budynku, data_zlecenia),
    CONSTRAINT fk_brygada FOREIGN KEY (id_brygady) REFERENCES Brygady(id_brygady),
    CONSTRAINT fk_klient FOREIGN KEY (id_klienta) REFERENCES Klienci(id_klienta),
    CONSTRAINT fk_budynek FOREIGN KEY (id_budynku) REFERENCES Budynki(id_budynku),
    CONSTRAINT popr_daty_ukon CHECK (data_zlecenia<=data_ukonczenia)   --sprawdza, czy data ukonczenia jest po dacie zlecenia
);

CREATE TABLE Reklamacje (
    id_budynku INT NOT NULL,
    data_reklamacji DATE NOT NULL,
    opis VARCHAR(200) NOT NULL,
    CONSTRAINT reklam_prim_key PRIMARY KEY (id_budynku, data_reklamacji),
    CONSTRAINT fk_r_budynek FOREIGN KEY (id_budynku) REFERENCES Budynki(id_budynku)
);

    
    




    


    
    
    


    