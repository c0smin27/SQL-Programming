USE FIRMA
GO

-- Scrieți și testați o funcție ce permite validarea unui nou câmp CNP scurt (din tabela Angajati), avand următoarea structură: G AA LL ZZ.
CREATE FUNCTION dbo.udfValidCNP(@CNP char(7))
RETURNS BIT
AS
BEGIN
	DECLARE @bValid bit
	SET @bValid = 0
	IF SUBSTRING(@CNP,1,3) LIKE '[56]0[0-9]'
	AND (SUBSTRING(@CNP,4,2) LIKE '0[1-9]'
		OR SUBSTRING(@CNP,4,2) LIKE '1[0-2]')
	AND (SUBSTRING(@CNP,6,2) LIKE '0[1-9]'
		OR SUBSTRING(@CNP,6,2) LIKE '1[0-9]'
		OR SUBSTRING(@CNP,6,2) LIKE '2[0-9]'
		OR SUBSTRING(@CNP,6,2) LIKE '3[01]')
	BEGIN
	SET @bValid = 1
	END
	RETURN (@bValid)
END
PRINT dbo.udfValidCNP('5020327')

-- Scrieți și testați o funcție ce permite verificarea faptului că un vânzător face parte din departamentul VANZARI.
CREATE FUNCTION udf_VanzatorValid(@departament varchar(20))
RETURNS INT
AS
BEGIN
DECLARE @vm INT
SELECT @vm = COUNT(*)
FROM ANGAJATI A JOIN DEPARTAMENTE D ON A.IdDept = D.IdDept
WHERE D.Denumire = @departament
RETURN @vm
END
SELECT dbo.udf_VanzatorValid('VANZARI') NrVanzatoriValizi

-- Scrieți și testați o funcție care verifică dacă vârsta la angajare este de minim 18 ani.
CREATE FUNCTION udf_VarstaMinima(@IdAngajat INT)
RETURNS VARCHAR(2)
AS
BEGIN
DECLARE @varsta INT;
SELECT @varsta = DATEDIFF(YEAR,DataNasterii,DataAngajarii)
FROM ANGAJATI A
WHERE A.IdAngajat = @IdAngajat;
IF @varsta >= 18
	RETURN 'DA';
	ELSE
	RETURN 'NU';
RETURN 0;
END
SELECT dbo.udf_VarstaMinima(1) AS VarstaMinima;

-- Scrieți și testați o funcție ce determină suma vânzărilor pentru o categorie de produse dată ca parametru.
CREATE FUNCTION udf_SumaVanzarilor(@categ_produs varchar(20))
RETURNS decimal
AS
BEGIN
DECLARE @suma decimal;
SELECT @suma = SUM(V.NrProduse * V.PretVanz)
FROM VANZARI V 
JOIN PRODUSE P ON V.IDProdus = P.IdProdus
JOIN CATEGORII_PROD C ON P.IdCateg = C.IdCateg
WHERE C.Denumire = @categ_produs
RETURN @suma
END
SELECT dbo.udf_SumaVanzarilor('Adaptoare') SumaVanzarilor

-- Scrieți și testați o funcție ce determină valoarea medie a vânzărilor pe un interval de timp transmis prin parametri.
CREATE FUNCTION udf_ValMedie(@data1 DATE, @data2 DATE)
RETURNS decimal
AS
BEGIN
DECLARE @vm decimal;
SELECT @vm = AVG(V.NrProduse * V.PretVanz)
FROM VANZARI V
WHERE V.DataVanz BETWEEN @data1 AND @data2
RETURN @vm
END
SELECT dbo.udf_ValMedie('2016-05-01', '2018-06-02') ValMedieVanzari

-- Scrieți și testați o funcție in-line care returnează primii cei mai prost plătiți 3 angajați pentru un departament dat ca parametru.
CREATE FUNCTION dbo.udf_Top3Prosti(@departament char(20))
RETURNS TABLE
AS
RETURN
SELECT TOP 3 A.Nume, A.Prenume, F.Salariu
FROM ANGAJATI A
JOIN DEPARTAMENTE D ON A.IdDept = D.IdDept
JOIN FUNCTII F ON A.IdFunctie = F.IdFunctie
WHERE D.Denumire = @departament
GROUP BY A.Nume, A.Prenume, F.Salariu
ORDER BY F.Salariu ASC
SELECT * FROM dbo.udf_Top3Prosti('PRODUCTIE');

-- Scrieți și testați o funcție care returnează lista angajaților cu vârsta și vechimea în muncă pentru un departament dat ca parametru.
CREATE FUNCTION dbo.udf_ListaAngaj(@departament char(20))
RETURNS TABLE
AS
RETURN
SELECT A.Nume, A.Prenume, DATEDIFF(YEAR,A.DataNasterii,GETDATE()) AS Varsta, DATEDIFF(YEAR,A.DataAngajarii,GETDATE()) AS Vechime
FROM ANGAJATI A
JOIN DEPARTAMENTE D ON A.IdDept = D.IdDept
WHERE D.Denumire = @departament
SELECT * FROM dbo.udf_ListaAngaj('PRODUCTIE');

-- 1. Scrieți și testați o funcție care returnează angajații a căror funcții conține o secvență de caractere primită ca parametru?
CREATE FUNCTION dbo.udf_ListaAngajati(@secventa varchar(20))
RETURNS TABLE
AS
RETURN
SELECT A.Nume, A.Prenume, F.Denumire
FROM ANGAJATI A
JOIN FUNCTII F ON A.IdAngajat = F.IdFunctie
WHERE F.Denumire LIKE '%' + @secventa + '%'
SELECT * FROM dbo.udf_ListaAngajati('MAN');

-- 2. Scrieți și testați o funcție care returnează salariile dintr-un departament primit ca parametru? Câți angajați beneficiază de fiecare salariu?
CREATE FUNCTION dbo.udf_SalariiDepartament(@departament char(20))
RETURNS TABLE
AS
RETURN
SELECT F.Salariu, COUNT(*) AS NrAngajati
FROM ANGAJATI A
JOIN DEPARTAMENTE D ON A.IdDept = D.IdDept
JOIN FUNCTII F ON A.IdFunctie = F.IdFunctie
WHERE D.Denumire = @departament
GROUP BY F.Salariu
SELECT * FROM dbo.udf_SalariiDepartament('PRODUCTIE');

-- 3. Scrieți și testați o funcție care returnează salariul minim și maxim dintr-un departament primit ca parametru?
CREATE FUNCTION dbo.udf_SalariuMinMax(@departament char(20))
RETURNS TABLE
AS
RETURN
SELECT MAX(F.Salariu) AS SalariuMin, MIN(F.Salariu) AS SalariuMax
FROM ANGAJATI A
JOIN DEPARTAMENTE D ON A.IdDept = D.IdDept
JOIN FUNCTII F ON A.IdFunctie = F.IdFunctie
WHERE D.Denumire = @departament
SELECT * FROM dbo.udf_SalariuMinMax('PRODUCTIE');

-- 4. Scrieți și testați o funcție care returnează produsele vândute într-o anumită perioadă de timp? Limitele perioadei de timp sunt trimise ca parametri către funcție.
CREATE FUNCTION udf_ProdVandute(@data1 DATE, @data2 DATE)
RETURNS decimal
AS
BEGIN
DECLARE @nr decimal;
SELECT @nr = SUM(V.NrProduse)
FROM VANZARI V
WHERE V.DataVanz BETWEEN @data1 AND @data2
RETURN @nr
END
SELECT dbo.udf_ProdVandute('2016-05-01', '2018-06-02') NrProduseVandute

-- 5. Scrieți și testați o funcție care returnează suma totală încasată de un vânzător al cărui nume este trimis ca parametru. Scrieți si testați o funcție care se bazează pe prima și care verifică dacă suma depășește un anumit prag minim trimis ca parametru. Afișați angajații care au vândut produse în valoare mai mare decât 100 RON.
CREATE FUNCTION dbo.udf_STotalIncasat(@nume char(20))
RETURNS TABLE
AS
RETURN
SELECT A.Nume, SUM(V.NrProduse*V.PretVanz) AS SumaTotalaIncasata
FROM ANGAJATI A
JOIN VANZARI V ON A.IdAngajat = V.IDVanzator
WHERE A.Nume = @nume
GROUP BY A.Nume
SELECT * FROM dbo.udf_STotalIncasat('N8');

CREATE FUNCTION dbo.udf_PragMinim(@prag int)
RETURNS TABLE
AS
RETURN
SELECT A.Nume, SUM(V.NrProduse*V.PretVanz) AS SumaTotalaIncasata
FROM ANGAJATI A
JOIN VANZARI V ON A.IdAngajat = V.IDVanzator
GROUP BY A.Nume
HAVING SUM(V.NrProduse*V.PretVanz) >= @prag
SELECT * FROM dbo.udf_PragMinim(100);

-- 6. Scrieți și testați o funcție care returnează cele mai vândute N produse, într-o anumită perioadă de timp. Valoarea lui N și limitele perioadei de timp sunt trimise ca parametri către funcție.
CREATE FUNCTION dbo.udf_CeleMaiVanduteProd(@N INT, @data1 DATE, @data2 DATE)
RETURNS TABLE
AS
RETURN
SELECT TOP (@N) V.IdProdus, P.Denumire, SUM(V.NrProduse) AS ProdVandute
FROM VANZARI V
JOIN PRODUSE P ON V.IDProdus = P.IdProdus
WHERE V.DataVanz BETWEEN @data1 AND @data2
GROUP BY V.IdProdus, P.Denumire
ORDER BY ProdVandute DESC
SELECT * FROM dbo.udf_CeleMaiVanduteProd(5, '2016-05-01', '2016-06-02');

-- 7. Scrieți și testați o funcție care returnează clienții ordonați descrescător după sumele cheltuite, într-o anumită perioadă de timp ale cărei limite sunt trimise ca parametri.
CREATE FUNCTION dbo.udf_Clienti(@data1 DATE, @data2 DATE)
RETURNS TABLE
AS
RETURN
SELECT TOP 50 C.Denumire, SUM(V.NrProduse*PretVanz) AS SumaCheltuita
FROM VANZARI V
JOIN CLIENTI C ON V.IDClient = C.IdClient
WHERE V.DataVanz BETWEEN @data1 AND @data2
GROUP BY C.Denumire
ORDER BY SumaCheltuita DESC
SELECT * FROM dbo.udf_Clienti('2016-05-01', '2016-06-02');
