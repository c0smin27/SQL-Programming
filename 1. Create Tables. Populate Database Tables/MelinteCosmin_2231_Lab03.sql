
CREATE DATABASE FIRMA

USE FIRMA

CREATE TABLE DEPARTAMENTE (
IdDept int PRIMARY KEY IDENTITY,
Denumire varchar(20) NOT NULL
)

CREATE TABLE FUNCTII (
IdFunctie int PRIMARY KEY IDENTITY,
Denumire varchar(20) NOT NULL,
Salariu decimal
)

CREATE TABLE ANGAJATI (
IdAngajat int PRIMARY KEY IDENTITY,
Nume varchar(20) NOT NULL,
Prenume varchar(20) NOT NULL,
Marca int NOT NULL UNIQUE,
DataNasterii date,
DataAngajarii date,
Adresa_jud varchar(20),
IdFunctie int NOT NULL,
IdDept int NOT NULL
)

ALTER TABLE ANGAJATI
ADD CONSTRAINT FK_ANGAJATI_FUNCTII FOREIGN KEY (IdFunctie)
REFERENCES FUNCTII(IdFunctie)

ALTER TABLE ANGAJATI
ADD CONSTRAINT FK_ANGAJATI_DEPT FOREIGN KEY (IdDept)
REFERENCES DEPARTAMENTE(IdDept)

INSERT INTO Departamente (Denumire) VALUES ('MANAGEMENT')
INSERT INTO Departamente (Denumire) VALUES ('VANZARI')

select * from DEPARTAMENTE

INSERT INTO Functii (Denumire, Salariu) VALUES ('MANAGER', 5000)
INSERT INTO Functii (Denumire, Salariu) VALUES ('INGINER', 4000)

select * from Functii

INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii,
Adresa_jud, IdFunctie, IdDept)
VALUES ('Ion', 'Neculce', 213, '2002-10-18', '12/31/2002', 'Bucuresti', 1, 1);

select * from angajati

CREATE TABLE CLIENTI (
IdClient int PRIMARY KEY IDENTITY,
Denumire varchar(20) NOT NULL,
Tip_cl varchar(20) NOT NULL,
Adresa_jud varchar(20) NOT NULL
)

CREATE TABLE CATEGORII_PROD (
IdCateg int PRIMARY KEY IDENTITY,
Denumire varchar(20) NOT NULL,
)

CREATE TABLE PRODUSE (
IdProdus int PRIMARY KEY IDENTITY,
Denumire varchar(20) NOT NULL,
IdCateg int NOT NULL
)

CREATE TABLE VANZARI (
IdVanzare int PRIMARY KEY IDENTITY,
IDProdus int NOT NULL,
IDClient int NOT NULL,
IDVanzator int NOT NULL,
DataVanz date NOT NULL,
NrProduse int NOT NULL,
PretVanz int NOT NULL
)

ALTER TABLE PRODUSE
ADD CONSTRAINT FK_PRODUSE_CATEGORIIPROD FOREIGN KEY (IdCateg)
REFERENCES CATEGORII_PROD(IdCateg)

ALTER TABLE VANZARI
ADD CONSTRAINT FK_VANZARI_PRODUSE FOREIGN KEY (IdProdus)
REFERENCES PRODUSE(IdProdus)

ALTER TABLE VANZARI
ADD CONSTRAINT FK_VANZARI_CLIENTI FOREIGN KEY (IdClient)
REFERENCES CLIENTI(IdClient)

ALTER TABLE VANZARI
ADD CONSTRAINT FK_VANZARI_ANGAJATI FOREIGN KEY (IDVanzator)
REFERENCES ANGAJATI(IdAngajat)

select * from FUNCTII
select * from DEPARTAMENTE
select * from ANGAJATI
select * from CATEGORII_PROD
select * from PRODUSE
select * from CLIENTI
select * from VANZARI

INSERT INTO Departamente (Denumire) VALUES ('HR')

INSERT INTO Functii (Denumire, Salariu) VALUES ('PROGRAMATOR', 3000)

INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii,
Adresa_jud, IdFunctie, IdDept)
VALUES ('Melinte', 'Cosmin', 27, '2002-03-27', '2023-10-24', 'Cluj-Napoca', 2, 2);

INSERT INTO CATEGORII_PROD(Denumire) VALUES ('Licente Software')
INSERT INTO CATEGORII_PROD(Denumire) VALUES ('Social Mdia Apps')

INSERT INTO PRODUSE(Denumire, IdCateg) VALUES ('Office 2019', 1)
INSERT INTO PRODUSE(Denumire, IdCateg) VALUES ('Visual Studio', 1)
INSERT INTO PRODUSE(Denumire, IdCateg) VALUES ('SSMS', 1)
INSERT INTO PRODUSE(Denumire, IdCateg) VALUES ('Facebook', 2)
INSERT INTO PRODUSE(Denumire, IdCateg) VALUES ('Instagram', 2)
INSERT INTO PRODUSE(Denumire, IdCateg) VALUES ('X', 2)

INSERT INTO CLIENTI(Denumire, Tip_cl, Adresa_jud) VALUES ('MedicalCM', 'Firma', 'Vatra Dornei')
INSERT INTO CLIENTI(Denumire, Tip_cl, Adresa_jud) VALUES ('M-Electronics', 'Firma', 'Cluj-Napoca')
INSERT INTO CLIENTI(Denumire, Tip_cl, Adresa_jud) VALUES ('Melinte Cosmin', 'Persoana fizica', 'Cluj-Napoca')

INSERT INTO VANZARI (IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz) VALUES (2, 1, 1, '2023-10-24', 50, 150)
INSERT INTO VANZARI (IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz) VALUES (4, 1, 2, '2023-10-24', 50, 150)
INSERT INTO VANZARI (IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz) VALUES (5, 2, 1, '2022-09-15', 100, 100)
INSERT INTO VANZARI (IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz) VALUES (5, 1, 1, '2022-12-10', 200, 200)
INSERT INTO VANZARI (IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz) VALUES (3, 2, 2, '2019-05-05', 600, 1200)
INSERT INTO VANZARI (IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz) VALUES (2, 3, 1, '2023-03-27', 1, 30)
INSERT INTO VANZARI (IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz) VALUES (3, 3, 1, '2023-03-27', 1, 120)
INSERT INTO VANZARI (IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz) VALUES (4, 3, 1, '2023-03-27', 1, 400)
INSERT INTO VANZARI (IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz) VALUES (7, 2, 2, '2021-06-26', 300, 300)
INSERT INTO VANZARI (IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz) VALUES (6, 2, 2, '2020-06-21', 300, 300)
