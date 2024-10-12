create database DEPOZIT;
use DEPOZIT;

DROP TABLE IF EXISTS Furnizor;
DROP TABLE IF EXISTS Categorie;
DROP TABLE IF EXISTS Producator;
DROP TABLE IF EXISTS Marfa;
DROP TABLE IF EXISTS Livrare;
 

CREATE TABLE Furnizor (
    FurnId INT PRIMARY KEY,
    FurnName VARCHAR(255),
    FurnHeader VARCHAR(255),
    FurnPhone VARCHAR(50),
    FurnCity VARCHAR(100),
    FurnAddress TEXT,
    FurnAbout TEXT
);


CREATE TABLE Categorie (
    CatId INT PRIMARY KEY,
    CatName VARCHAR(255),
    CatAbout TEXT
);


CREATE TABLE Producator (
    ProdId INT PRIMARY KEY,
    ProdName VARCHAR(255),
    ProdCountry VARCHAR(100),
    ProdAbout TEXT
);


CREATE TABLE Marfa (
    MarfaId INT PRIMARY KEY,
    MarfaName VARCHAR(255),
    MarfaCateg INT,
    MarfaUnitMeas VARCHAR(50),
    MarfaProduc INT,
    MarfaAbout TEXT,
    FOREIGN KEY (MarfaCateg) REFERENCES Categorie(CatId),
    FOREIGN KEY (MarfaProduc) REFERENCES Producator(ProdId)
);

CREATE TABLE Livrare (
    OrdNum INT PRIMARY KEY,
    LivrareDate DATE,
    FurnizorId INT,
    MarfaId INT,
    MarfaQuantity INT,
    MarfaPrice DECIMAL(10, 2),
    FOREIGN KEY (FurnizorId) REFERENCES Furnizor(FurnId),
    FOREIGN KEY (MarfaId) REFERENCES Marfa(MarfaId)
);


 
INSERT INTO Furnizor (FurnId, FurnName, FurnHeader, FurnPhone, FurnCity, FurnAddress, FurnAbout)
VALUES 
(1, 'Furnizor SRL', 'Director Furnizor', '0751234567', 'Bucuresti', 'Strada Exemplu 10', 'Furnizor de electronice'),
(2, 'Distribuitor Global', 'Manager Vanzari', '0760987654', 'Cluj-Napoca', 'Strada Unirii 25', 'Furnizor de produse alimentare');



INSERT INTO Categorie (CatId, CatName, CatAbout)
VALUES 
(1, 'Electronice', 'Produse electronice de consum'),
(2, 'Alimentare', 'Produse alimentare și băuturi');



INSERT INTO Producator (ProdId, ProdName, ProdCountry, ProdAbout)
VALUES 
(1, 'Samsung', 'Coreea de Sud', 'Producător de electronice și electrocasnice'),
(2, 'Nestle', 'Elveția', 'Producător de produse alimentare și băuturi');



INSERT INTO Marfa (MarfaId, MarfaName, MarfaCateg, MarfaUnitMeas, MarfaProduc, MarfaAbout)
VALUES 
(1, 'Televizor LED', 1, 'buc', 1, 'Televizor LED 4K 43 inch'),
(2, 'Ciocolata', 2, 'buc', 2, 'Ciocolata cu lapte de 100g');


INSERT INTO Livrare (OrdNum, LivrareDate, FurnizorId, MarfaId, MarfaQuantity, MarfaPrice)
VALUES 
(1, '2024-10-01', 1, 1, 50, 1500.00),
(2, '2024-10-02', 2, 2, 200, 300.00),
(3, '2024-10-02', 2, 2, 200, 340.00);








-- Interogari unitabelare

-- Lista furnizorilor cu indicatia conducatorului si numarul de telefon
SELECT FurnName, FurnHeader, FurnPhone 
FROM Furnizor;

-- Lista furnizorilor din orasul dat cu indicatia conducatorului si numarul de telefon
SELECT FurnName, FurnHeader, FurnPhone 
FROM Furnizor 
WHERE FurnCity = 'Bucuresti';  -- Schimba orasul dupa nevoie

-- Lista marfurilor cu indicatia categoriei
SELECT MarfaName, Categorie.CatName 
FROM Marfa 
JOIN Categorie ON Marfa.MarfaCateg = Categorie.CatId;

-- Lista marfurilor cu indicatia categoriei si unitatilor de masura
SELECT MarfaName, Categorie.CatName, MarfaUnitMeas 
FROM Marfa 
JOIN Categorie ON Marfa.MarfaCateg = Categorie.CatId;

-- Lista producatorilor din fiecare tara
SELECT ProdName, ProdCountry 
FROM Producator;

-- Interogari multitable



-- Lista furnizorilor si marfurilor livrate de ei
SELECT Furnizor.FurnName, Marfa.MarfaName 
FROM Livrare 
JOIN Furnizor ON Livrare.FurnizorId = Furnizor.FurnId
JOIN Marfa ON Livrare.MarfaId = Marfa.MarfaId;

-- Lista furnizorilor si marfurilor livrate de ei cu preturile de livrare
SELECT Furnizor.FurnName, Marfa.MarfaName, Livrare.MarfaPrice 
FROM Livrare 
JOIN Furnizor ON Livrare.FurnizorId = Furnizor.FurnId
JOIN Marfa ON Livrare.MarfaId = Marfa.MarfaId;

-- Lista marfurilor cu indicatia categoriei si producatorului
SELECT Marfa.MarfaName, Categorie.CatName, Producator.ProdName 
FROM Marfa 
JOIN Categorie ON Marfa.MarfaCateg = Categorie.CatId
JOIN Producator ON Marfa.MarfaProduc = Producator.ProdId;

-- Functii de totalizare si interogari cu campuri calculate

-- Costul total al marfurilor livrate
SELECT SUM(MarfaPrice * MarfaQuantity) AS TotalCost 
FROM Livrare;

-- Costul marfurilor livrate in fiecare zi
SELECT LivrareDate, SUM(MarfaPrice * MarfaQuantity) AS DailyCost 
FROM Livrare 
GROUP BY LivrareDate;

-- Costul marfurilor livrate in fiecare zi pentru o perioada de timp
SELECT LivrareDate, SUM(MarfaPrice * MarfaQuantity) AS PeriodCost 
FROM Livrare 
WHERE LivrareDate BETWEEN '2024-10-01' AND '2024-10-10'  -- Schimba perioada dupa nevoie
GROUP BY LivrareDate;

-- Gruparea datelor. Constructor de expresii

-- Costul marfurilor livrate, grupate pe categorii
SELECT Categorie.CatName, SUM(Livrare.MarfaPrice * Livrare.MarfaQuantity) AS TotalCost 
FROM Livrare 
JOIN Marfa ON Livrare.MarfaId = Marfa.MarfaId
JOIN Categorie ON Marfa.MarfaCateg = Categorie.CatId
GROUP BY Categorie.CatName;

-- Costul marfurilor livrate, grupate pe furnizori
SELECT Furnizor.FurnName, SUM(Livrare.MarfaPrice * Livrare.MarfaQuantity) AS TotalCost 
FROM Livrare 
JOIN Furnizor ON Livrare.FurnizorId = Furnizor.FurnId
GROUP BY Furnizor.FurnName;

-- Costul marfurilor livrate, grupate pe furnizori si categorii
SELECT Furnizor.FurnName, Categorie.CatName, SUM(Livrare.MarfaPrice * Livrare.MarfaQuantity) AS TotalCost 
FROM Livrare 
JOIN Furnizor ON Livrare.FurnizorId = Furnizor.FurnId
JOIN Marfa ON Livrare.MarfaId = Marfa.MarfaId
JOIN Categorie ON Marfa.MarfaCateg = Categorie.CatId
GROUP BY Furnizor.FurnName, Categorie.CatName;

-- Costul marfurilor livrate, grupate pe producatori si categorii
SELECT Producator.ProdName, Categorie.CatName, SUM(Livrare.MarfaPrice * Livrare.MarfaQuantity) AS TotalCost 
FROM Livrare 
JOIN Marfa ON Livrare.MarfaId = Marfa.MarfaId
JOIN Producator ON Marfa.MarfaProduc = Producator.ProdId
JOIN Categorie ON Marfa.MarfaCateg = Categorie.CatId
GROUP BY Producator.ProdName, Categorie.CatName;

-- Care din furnizori a livrat mai rar/des marfuri
SELECT Furnizor.FurnName, COUNT(Livrare.OrdNum) AS NumberOfDeliveries 
FROM Livrare 
JOIN Furnizor ON Livrare.FurnizorId = Furnizor.FurnId
GROUP BY Furnizor.FurnName 
ORDER BY NumberOfDeliveries ASC;  -- Pentru cei care au livrat mai rar (DESC pentru cei mai des)

-- Care din furnizori a livrat marfuri de o suma mai mare/mica
SELECT Furnizor.FurnName, SUM(Livrare.MarfaPrice * Livrare.MarfaQuantity) AS TotalCost 
FROM Livrare 
JOIN Furnizor ON Livrare.FurnizorId = Furnizor.FurnId
GROUP BY Furnizor.FurnName 
ORDER BY TotalCost DESC;  -- DESC pentru suma mai mare, ASC pentru suma mai mica