CREATE DATABASE Firma

USE FIRMA

--Tabela Departamente
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DEPARTAMENTE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DEPARTAMENTE]

CREATE TABLE DEPARTAMENTE (
 IdDept int PRIMARY KEY IDENTITY,
 Denumire varchar(30) NOT NULL
)

-- Tabela Functii
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FUNCTII]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[FUNCTII]

CREATE TABLE FUNCTII (
 IdFunctie int PRIMARY KEY IDENTITY,
 Denumire varchar(30) NOT NULL,
 Salariu int CHECK (Salariu > 0)
)

-- Tabela Angajati
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANGAJATI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANGAJATI]

CREATE TABLE ANGAJATI (
 IdAngajat int PRIMARY KEY IDENTITY,
 Nume varchar(20) NOT NULL,
 Prenume varchar(20) NOT NULL,
 Marca int NOT NULL UNIQUE,
 DataNasterii date,
 DataAngajarii date,
 Adresa_jud varchar(20) NOT NULL,
 IdFunctie int NOT NULL,
 IdDept int NOT NULL
)

-- Tabela Clienti
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CLIENTI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CLIENTI]

CREATE TABLE CLIENTI (
 IdClient int PRIMARY KEY IDENTITY,
 Denumire varchar(20) NOT NULL,
 Tip_cl varchar(10) NOT NULL, -- PF, PFA, SRL, SA, RA
 Adresa_jud varchar(20) NOT NULL
)

-- Tabela Categorii_prod
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CATEGORII_PROD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CATEGORII_PROD]

CREATE TABLE CATEGORII_PROD (
 IdCateg int PRIMARY KEY IDENTITY,
 Denumire varchar(20) NOT NULL
)

-- Tabela Produse
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PRODUSE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PRODUSE]

CREATE TABLE PRODUSE (
 IdProdus int PRIMARY KEY IDENTITY,
 Denumire varchar(36) NOT NULL,
 IdCateg int NOT NULL
)

-- Tabela Vanzari
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VANZARI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[VANZARI]

CREATE TABLE VANZARI (
 IdVanzare int PRIMARY KEY IDENTITY,
 IDProdus int NOT NULL,
 IDClient int NOT NULL,
 IDVanzator int NOT NULL,
 DataVanz date DEFAULT GetDate(),
 NrProduse int DEFAULT 1 CHECK (NrProduse > 0),
 PretVanz int CHECK (PretVanz > 0)
)

-----------------------------------------------------------------------------
USE FIRMA

-- Chei straine in tabela Angajati
ALTER TABLE ANGAJATI 
 ADD CONSTRAINT FK_ANGAJATI_DEPARTAMENTE FOREIGN KEY (IdDept) 
REFERENCES DEPARTAMENTE(IdDept);

ALTER TABLE ANGAJATI 
 ADD CONSTRAINT FK_ANGAJATI_FUNCTII FOREIGN KEY (IdFunctie) 
REFERENCES FUNCTII(IdFunctie);

-- Chei straine in tabela Vanzari
ALTER TABLE VANZARI 
 ADD CONSTRAINT FK_VANZARI_ANGAJATI FOREIGN KEY (IdVanzator) 
REFERENCES ANGAJATI(IdAngajat);

ALTER TABLE VANZARI 
 ADD CONSTRAINT FK_VANZARI_CLIENTI FOREIGN KEY (IdClient) 
REFERENCES CLIENTI(IdClient);

ALTER TABLE VANZARI 
 ADD CONSTRAINT FK_VANZARI_PRODUSE FOREIGN KEY (IdProdus) 
REFERENCES PRODUSE(IdProdus);

ALTER TABLE PRODUSE 
 ADD CONSTRAINT FK_PRODUSE_CATEGORII_PROD FOREIGN KEY(IdCateg)
REFERENCES CATEGORII_PROD(IdCateg)

-----------------------------------------------------------------------------
Use Firma

-- Populare tabela Departamente
INSERT INTO Departamente (Denumire) VALUES ('MANAGEMENT');
INSERT INTO Departamente (Denumire) VALUES ('PRODUCTIE');
INSERT INTO Departamente (Denumire) VALUES ('PROIECTARE');
INSERT INTO Departamente (Denumire) VALUES ('VANZARI');
INSERT INTO Departamente (Denumire) VALUES ('FINANCIAR-CONTAB');
INSERT INTO Departamente (Denumire) VALUES ('PERSONAL-SALARIZARE');

-- Populare tabela Functii
INSERT INTO Functii (Denumire, Salariu) VALUES ('MANAGER', 10000)
INSERT INTO Functii (Denumire, Salariu) VALUES ('DIRECTOR', 8000)
INSERT INTO Functii (Denumire, Salariu) VALUES ('INGINER', 5000)
INSERT INTO Functii (Denumire, Salariu) VALUES ('ANALIST FINANCIAR', 4000)
INSERT INTO Functii (Denumire, Salariu) VALUES ('ECONOMIST', 3500)
INSERT INTO Functii (Denumire, Salariu) VALUES ('TEHNICIAN', 3500)
INSERT INTO Functii (Denumire, Salariu) VALUES ('ASISTENT MANAGER', 3500)
INSERT INTO Functii (Denumire, Salariu) VALUES ('ASISTENT DIRECTOR', 3000)
INSERT INTO Functii (Denumire, Salariu) VALUES ('MUNCITOR CALIFICAT', 2000)
INSERT INTO Functii (Denumire, Salariu) VALUES ('MUNCITOR NECALIFICAT', 1500)
INSERT INTO Functii (Denumire, Salariu) VALUES ('JURIST', 3500)

--INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
-- VALUES ('N8', 'P1', 24, '10/15/1955', '10/15/2005', 'Bucuresti', 
-- (SELECT IdFunctie FROM Functii WHERE Denumire = 'Inginer'), 
-- (SELECT IdDept FROM DEpartamente WHERE Denumire = 'Productie'));

-- Populare tabela Angajati
-- Manager
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N1', 'P1', 1, '10/15/1955', '10/15/2005', 'Bucuresti', 1, 1);
-- Director Productie
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N2', 'P2', 2, '10/20/1981', '10/15/2006', 'Bihor', 2, 2);
-- Director Proiectare
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N3', 'P3', 3, '7/25/1980', '7/17/2009', 'Ilfov', 2, 3);
-- Director Vanzari
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N4', 'P4', 4, '01/01/1998', '12/31/2020', 'Cluj', 2, 4);
-- Director Financiar-Contab
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N5', 'P5', 5, '02/15/1962', '12/12/2019', 'Cluj', 2, 5);
-- Director Personal-Salarizare
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N6', 'P6', 6, '05/05/1964', '05/06/2018', 'Arad', 2, 6);

 -- Personal Management
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept)
 VALUES ('N7', 'P7', 7, '08/12/1975', '09/16/2010', 'Cluj', 3, 2);
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N8', 'P8', 8, '05/10/1977', '08/26/2011', 'Galati', 6, 2);
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N9', 'P9', 9, '07/17/1975', '12/12/2010', 'Vaslui', 9, 2)
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N10', 'P10', 10, '09/09/1985', '05/30/2012', 'Bucuresti', 9, 2);

 -- Personal Proiectare
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N11', 'P9', 11, '07/17/1976', '12/12/2014', 'Cluj', 3, 3)
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N12', 'P2', 12, '09/09/1981', '05/30/2015', 'Cluj', 3, 3);

 -- Personal vanzari
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N13', 'P9', 13, '07/17/1979', '12/12/2014', 'Cluj', 5, 4)
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N12', 'P13', 14, '09/09/1980', '05/30/2015', 'Cluj', 5, 4);
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N8', 'P5', 15, '07/17/1983', '12/12/2016', 'Bihor', 5, 4)

 -- Personal Financiar-Contab
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N16', 'P1', 16, '03/17/1980', '01/12/2013', 'Cluj', 4, 5)
 
-- Personal Personal-Salariz
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N12', 'P15', 17, '03/17/1981', '01/12/2014', 'Cluj', 4, 6)
 
-- Asistent manager
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N22', 'P38', 18, '10/15/1995', '10/15/2016', 'Bucuresti', 7, 1);

 -- Populare tabela Clienti
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Vitacon', 'Cluj', 'SA');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Mediagalacsy', 'Cluj', 'SA');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Franco', 'Bucuresti', 'SA');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Artex', 'Sibiu', 'SA');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Liodl', 'Cluj', 'SA');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Dedemun', 'Bacau', 'SA');

INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Ion', 'Cluj', 'SRL');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Maria', 'Salaj', 'SRL');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Ana', 'Maramures', 'SRL');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Brusli', 'Bihor', 'SRL');

-- Populare tabela Categorii_Prod
INSERT INTO CATEGORII_PROD(Denumire) VALUES ('Cable');
INSERT INTO CATEGORII_PROD(Denumire) VALUES ('Adaptoare');
INSERT INTO CATEGORII_PROD(Denumire) VALUES ('Alimentatoare');
INSERT INTO CATEGORII_PROD(Denumire) VALUES ('Modulatoare FM');

-- Populare tabela Produse
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Cablu USB-USB, 0.5m', 1);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Cablu USB-USB, 1m', 1);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Cablu USB-USB, 2m', 1);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Cablu USB-mini USB, 0.5m', 1);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Cablu USB-micro USB, 0.5m', 1);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Cablu USB-micro USB-C, 0.5m', 1);

INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Adaptor USB-mini USB', 2);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Adaptor USB-micro USB', 2);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Adaptor USB-micro USB-C', 2);

INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Alimentator 220V-5V USB 1o', 3);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Alimentator 220V-5V USB 2o', 3);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Alimentator 220V-5V USB 3o', 3);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Alimentator 12V-5V USB 1o', 3);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Alimentator 12V-5V USB 2o', 3);

INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Modulator FM, USB', 4);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Modulator FM, Bluetooth', 4);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Modulator FM, USB, Bluetooth', 4);

-- Populare tabela Vanzari
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (1, 1, 13, '05/01/2016', 5, 6);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (2, 2, 14, '05/01/2016', 3, 9);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (4, 3, 14, '06/02/2016', 10, 8);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (5, 5, 15, '06/02/2016', 1, 9);

 INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (7, 7, 13, '06/02/2016', 5, 16);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (8, 2, 14, '06/02/2018', 2, 19);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (8, 8, 14, '07/03/2018', 5, 18);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (9, 9, 15, '07/03/2019', 11, 19);

 INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (10, 1, 13, '07/04/2019', 5, 26);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (11, 3, 14, '07/04/2016', 2, 29);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (13, 10, 14, '08/05/2020', 5, 28);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (15, 10, 13, '08/05/2019', 11, 39);

 INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (16, 1, 14, '08/06/2021', 3, 26);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (17, 8, 13, '08/06/2021', 2, 29);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (16, 8, 13, '09/07/2019', 1, 38);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (17, 7, 15, '09/07/2020', 1, 39);

select * from Produse
ALTER TABLE Produse ADD Cod_produs CHAR(6);
UPDATE Produse SET Cod_produs = CONCAT ('abc',IdProdus);
ALTER TABLE Produse ADD CONSTRAINT UC_Produse UNIQUE (Cod_produs);
 
INSERT INTO PRODUSE(Denumire, IDCateg, Cod_produs) VALUES ('Incarcator 20W USB', 4, 'xyz1');
INSERT INTO PRODUSE(Denumire, IDCateg, Cod_produs) VALUES ('Incarcator 25W USB', 4, 'xyz2');
INSERT INTO PRODUSE(Denumire, IDCateg, Cod_produs) VALUES ('Incarcator 30W USB', 4, 'xyz3');
 
select * from Clienti
ALTER TABLE Clienti ADD CHECK (Tip_cl='PF' OR Tip_cl='PFA' OR Tip_cl='SRL' OR Tip_cl='SA');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Cosmin', 'Cluj', 'ONG');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Cosmin', 'Cluj', 'SRL');
 
select * from Vanzari
ALTER TABLE Vanzari ADD CONSTRAINT CheckDataVanz CHECK (DataVanz <= GETDATE());
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (17, 7, 15, '09/07/2024', 1, 39);
 
select * from Clienti
DELETE FROM Clienti WHERE Adresa_jud = 'Cluj';
DELETE FROM Vanzari WHERE IDClient = 1;
DELETE FROM Vanzari WHERE IDClient = 2;
DELETE FROM Vanzari WHERE IDClient = 5;
DELETE FROM Vanzari WHERE IDClient = 7;
DELETE FROM Vanzari WHERE IDClient = 12;
DELETE FROM Clienti WHERE Adresa_jud = 'Cluj';
 
select * from Vanzari
DELETE FROM Vanzari WHERE DataVanz < DATEADD(YEAR, -1, GETDATE());
 
select * from Departamente
select * from Angajati where IdDept = 3;
--DELETE FROM Angajati WHERE IdDept = 3 AND DataAngajarii > '2018-01-01';
DELETE FROM ANGAJATI WHERE IdDept = 3 AND DATEDIFF(DAY, '2018-01-01', DataAngajarii) > 0;


select * from Departamente
select * from Angajati where IdDept = 2;
UPDATE ANGAJATI SET IdDept = 4 WHERE IdDept = 2 AND DATEDIFF(YEAR, DataAngajarii, GETDATE()) >= 5;
select * from Angajati where IdDept = 4;

select * from Produse
UPDATE Produse SET Denumire = CONCAT (Denumire,'-v2') WHERE IdProdus%2=1;

select * from CATEGORII_PROD;
select * from Produse where IdCateg=2;
select * from Vanzari;
UPDATE Vanzari SET PretVanz = PretVanz * 1.1 --crestere de 10% = *1.1
WHERE DataVanz > '2018-12-01' AND (IdProdus = 8 OR IdProdus = 9);
