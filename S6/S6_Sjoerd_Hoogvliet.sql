-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S6: Views
--
-- (c) 2020 Hogeschool Utrecht
-- Tijmen Muller (tijmen.muller@hu.nl)
-- André Donk (andre.donk@hu.nl)
-- ------------------------------------------------------------------------


-- S6.1.
--
-- 1. Maak een view met de naam "deelnemers" waarmee je de volgende gegevens uit de tabellen inschrijvingen en uitvoering combineert:
--    inschrijvingen.cursist, inschrijvingen.cursus, inschrijvingen.begindatum, uitvoeringen.docent, uitvoeringen.locatie

CREATE OR REPLACE VIEW deelnemers AS
SELECT inschrijvingen.cursist, inschrijvingen.cursus, inschrijvingen.begindatum, uitvoeringen.docent, uitvoeringen.locatie
FROM inschrijvingen
JOIN uitvoeringen ON inschrijvingen.cursus = uitvoeringen.cursus AND inschrijvingen.begindatum = uitvoeringen.begindatum

-- 2. Gebruik de view in een query waarbij je de "deelnemers" view combineert met de "personeels" view (behandeld in de les):
--     CREATE OR REPLACE VIEW personeel AS
-- 	     SELECT mnr, voorl, naam as medewerker, afd, functie
--       FROM medewerkers;

SELECT cursist.medewerker AS "cursist", docent.medewerker AS "docent"
FROM deelnemers d 
JOIN personeel cursist ON d.cursist = cursist.mnr
JOIN personeel docent ON d.docent = docent.mnr

-- 3. Is de view "deelnemers" updatable ? Waarom ?

-- Nee, enkel 'eenvoudige' views zijn updatable. Dit geldt dus niet voor views waarbij meerdere tabellen worden gebruikt.

-- S6.2.
--
-- Voor het nalopen van de werking van de views voor 6.2.1 en 6.2.2 zijn ook screenshots bijgevoegd van de gegevens binnen cursussen en uitvoeringen.

-- 1. Maak een view met de naam "dagcursussen". Deze view dient de gegevens op te halen: 
--      code, omschrijving en type uit de tabel curssussen met als voorwaarde dat de lengte = 1. Toon aan dat de view werkt. 

CREATE OR REPLACE VIEW dagcursussen AS
SELECT code, omschrijving, type
FROM cursussen
WHERE lengte = 1

-- Als bewijs is een screenshot bijgevoegd van de gegevens van de view "dagcursussen"

-- 2. Maak een tweede view met de naam "daguitvoeringen". 
--    Deze view dient de uitvoeringsgegevens op te halen voor de "dagcurssussen" (gebruik ook de view "dagcursussen"). Toon aan dat de view werkt

CREATE OR REPLACE view daguitvoeringen AS
SELECT *
FROM uitvoeringen
WHERE cursus IN (
    SELECT code
    FROM dagcursussen
)

-- Als bewijs is een screenshot bijgevoegd van de gegevens van de view "daguitvoeringen"

-- 3. Verwijder de views en laat zien wat de verschillen zijn bij DROP view <viewnaam> CASCADE en bij DROP view <viewnaam> RESTRICT

-- Bijgevoegd zijn twee screenshots waarbij beide manier van verwijderen worden uitgevoerd op dagcursussen. Dit leek mij de beste view om 
-- de verschillen aan te tonen aangezien deze view ook een dependent view heeft in daguitvoeringen.
-- Bij RESTRICT is te zien dat de view niet verwijderd kan worden omdat daguitvoeringen de view nodig heeft.
-- Bij CASCADE is juist te zien dat niet alleen dagcursussen verwijderd wordt maar dat daguitvoeringen wordt meegenomen omdat deze afhankelijk is van dagcursussen.