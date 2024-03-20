USE FIRMA
GO

-- 1. Care sunt angajații dintr-un anumit departament (dat prin denumire) a căror nume începe cu caracterele ‘N1’?
SELECT A.Nume, A.Prenume, D.Denumire Departament
FROM Angajati A JOIN Departamente D
ON (A.IdDept = D.IdDept)
WHERE (D.Denumire = 'PROIECTARE' AND A.Nume LIKE 'N1%')
ORDER BY Nume, Prenume

-- 2. Care sunt angajații dintr-un anumit departament (dat prin denumire) ordonați după salariu crescător/descrescător?
SELECT A.Nume, A.Prenume, F.Salariu
FROM Angajati A
JOIN Departamente D ON A.IdDept = D.IdDept
JOIN Functii F ON A.IdFunctie = F.IdFunctie
WHERE D.Denumire = 'PRODUCTIE'
ORDER BY F.salariu DESC, A.nume, A.prenume

-- 3. Câți angajați sunt într-un anumit departament dat prin denumire?
SELECT COUNT(*) NrAngajati
FROM Angajati A JOIN Departamente D
ON (A.IdDept = D.IdDept)
WHERE (D.Denumire = 'PROIECTARE')
GROUP BY D.IdDept

-- 4. Care este suma salariilor angajaților din companie?
SELECT Sum(F.Salariu) Total_Salarii_Companie
FROM Angajati A JOIN Functii F
ON (A.IdFunctie = F.IdFunctie)

-- 1. Care sunt angajații a căror funcții conține secvența de caractere 'ngi'?
SELECT A.Nume, A.Prenume, F.Denumire Functie
FROM Angajati A JOIN Functii F
ON (A.IdDept = F.IdFunctie)
WHERE (F.Denumire LIKE '%NGI%')

-- 2. Care sunt salariile din departamentul 'PRODUCTIE' și câți angajați au aceste salarii?
SELECT F.Salariu, COUNT(A.IdAngajat) AS NumarAngajati
FROM Angajati A
JOIN Functii F ON A.IdFunctie = F.IdFunctie
JOIN Departamente D ON A.IdDept = D.IdDept
WHERE D.Denumire = 'PRODUCTIE'
GROUP BY F.Salariu

-- 3. Care sunt cele mai mici/mari salarii din departamente?
SELECT D.Denumire, MIN(F.Salariu) AS SalariuMin
FROM Angajati A
JOIN Functii F ON A.IdFunctie = F.IdFunctie
JOIN Departamente D ON A.IdDept = D.IdDept
GROUP BY D.Denumire

SELECT D.Denumire, MAX(F.Salariu) AS SalariuMax
FROM Angajati A
JOIN Functii F ON A.IdFunctie = F.IdFunctie
JOIN Departamente D ON A.IdDept = D.IdDept
GROUP BY D.Denumire

-- 4.Care sunt produsele vândute într-o anumită perioadă de timp?
SELECT P.Denumire, V.DataVanz
FROM VANZARI V JOIN PRODUSE P ON V.IdProdus = P.IdProdus
WHERE DataVanz BETWEEN '2016-05-01' AND '2016-06-02'

-- 5. Care sunt clienții ce au cumpărat produse prin intermediul unui vânzător anume?
SELECT DISTINCT C.Denumire AS NumeClient, CONCAT(A.Nume,' ',A.Prenume) AS Vanzator
FROM Clienti C
JOIN Vanzari V ON C.IdClient = V.IDClient
JOIN Angajati A ON V.IDVanzator = A.IdAngajat
--WHERE A.Nume = 'N12' AND A.Prenume = 'P13'
WHERE A.IdAngajat = 14

-- 6. Care sunt clienții ce au cumpărat două produse?
SELECT C.IdClient, C.Denumire AS NumeClient
FROM Clienti C JOIN Vanzari V ON C.IdClient = V.IDClient
WHERE V.NrProduse = 2

-- 7. Care sunt clienții ce au cumpărat cel puțin două produse?
SELECT C.IdClient, C.Denumire AS NumeClient
FROM Clienti C JOIN Vanzari V ON C.IdClient = V.IDClient
GROUP BY C.IdClient, C.Denumire
HAVING COUNT(V.NrProduse) >= 2

-- 8. Câți clienți au cumpărat (la o singură cumpărare) produse în valoare mai mare decât o sumă dată (de ex. 30)?
SELECT COUNT(DISTINCT V.IDClient) AS NrClienti
FROM Vanzari V
WHERE V.PretVanz > 30

-- 9. Care sunt clienții din CLUJ care au cumpărat produse în valoare mai mare de 30?
SELECT C.IdClient, C.Denumire, C.Adresa_jud
FROM Clienti C JOIN Vanzari V ON C.IdClient = V.IDClient
WHERE C.Adresa_jud = 'CLUJ' AND V.PretVanz > 30;

-- 10. Care sunt mediile vânzărilor pe o anumită perioadă de timp, grupate pe produse?
SELECT V.IDProdus, AVG(V.NrProduse) AS MedProdVandute, V.DataVanz
FROM Vanzari V JOIN Produse P ON V.IDProdus = P.IdProdus
WHERE V.DataVanz BETWEEN '2016-05-01' AND '2016-06-02'
GROUP BY V.IDProdus, V.DataVanz

-- 11. Care este numărul total de produse vândute pe o anumită perioadă de timp ?
SELECT V.IDProdus, SUM(V.NrProduse) AS TotalProduseVandute
FROM Vanzari V JOIN Produse P ON V.IDProdus = P.IdProdus
WHERE V.DataVanz BETWEEN '2016-05-01' AND '2016-06-02'
GROUP BY V.IDProdus

-- 12. Care este numărul de total de produse vândute de un vânzător precizat prin nume?
SELECT A.Nume AS Vanzator, SUM(V.NrProduse) AS TotalProdVandute
FROM ANGAJATI A JOIN VANZARI V ON A.IdAngajat = V.IDVanzator
WHERE A.Nume = 'N12'
GROUP BY A.Nume

-- 13. Care sunt clienții ce au cumpărat produse în valoare mai mare decât media vânzărilor din luna august 2016?
SELECT C.Denumire AS Client
FROM CLIENTI C JOIN VANZARI V ON C.IdClient = V.IDClient
WHERE V.DataVanz BETWEEN '2016-08-01' AND '2016-08-30'
GROUP BY C.Denumire
HAVING SUM(V.NrProduse) > (SELECT AVG(V2.NrProduse) 
                          FROM VANZARI V2 
                          WHERE V2.DataVanz BETWEEN '2016-08-01' AND '2016-08-30')

-- 14. Care sunt produsele care s-au vândut la mai mult de un client?
SELECT P.IdProdus, P.Denumire
FROM PRODUSE P JOIN VANZARI V ON P.IdProdus = V.IdProdus
GROUP BY P.IdProdus, P.Denumire
HAVING COUNT(DISTINCT V.IDClient) > 1;

-- 15. Care sunt vânzările valorice realizate de fiecare vânzător, grupate pe produse și clienți, cu subtotaluri?
SELECT A.Nume AS Vanzator, P.Denumire AS Produs, C.Denumire AS Client, SUM(V.NrProduse) AS TotalProduse, SUM(V.PretVanz*V.NrProduse) AS TotalVanzari
FROM VANZARI V
JOIN ANGAJATI A ON V.IDVanzator = A.IdAngajat
JOIN PRODUSE P ON V.IDProdus = P.IdProdus
JOIN CLIENTI C ON V.IDClient = C.IdClient
GROUP BY A.Nume, P.Denumire, C.Denumire
