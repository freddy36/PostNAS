
-- ALKIS-Datenbank aus dem Konverter PostNAS 0.5

-- Z u s a e t z l i c h e   S c h l u e s s e l t a b e l l e n

-- Dieses Script fuegt der Datenbank einige Schluesseltabellen hinzu, die der 
-- Konverter PostNAS NICHT aufbaut, weil sie nicht in den NAS-Daten enthalten sind.
-- Die Schluessel sind der Dokumentation zu entnehmen.

-- Die Tabellen werden vom Buchwerk-Auskunftsprogramm benoetigt.

-- Dies Script kann nach dem Anlegen der Datenbank mit dem Script 'alkis_PostNAS_0.5_schema.sql'
-- verarbeitet werden.

-- Alternativ kann eine Template-Datenbbank bereits mit diesen Schluesseltabellen angelegt werden.

-- Version

-- krz f.j. 2010-09-16   Buchungsart hinzugefuegt
--                       recht 

  SET client_encoding = 'UTF8';


-- G e b a e u d e - B a u w e i s e
-- ---------------------------------

-- Wird benoetigt in alkisgebaeudenw.php

-- Nicht im Grunddatenbestand NRW 
-- Siehe http://www.kreis-euskirchen.de/service/downloads/geoinformation/Kreis_EU_Gebaeudeerfassung.pdf

--DROP TABLE ax_bauweise_gebaeude;  -- alter Name

CREATE TABLE ax_gebaeude_bauweise
  (
--  wert                   integer, 
    bauweise_id            integer, 
    bauweise_beschreibung  character varying
  );


ALTER TABLE ax_gebaeude_bauweise 
ADD CONSTRAINT pk_ax_ax_gebaeude_bauweise 
PRIMARY KEY (bauweise_id);


INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1100,'Freistehendes Einzelgebäude');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1200,'Freistehender Gebäudeblock');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1300,'Einzelgarage');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1400,'Doppelgarage');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1500,'Sammelgarage');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2100,'Doppelhaushälfte');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2200,'Reihenhaus');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2300,'Haus in Reihe');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2400,'Gruppenhaus');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2500,'Gebäudeblock in geschlossener Bauweise');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (4000,'Offene Halle');



-- G e b a e u d e - F u n k t i o n
-- ---------------------------------

--   wird benoetigt in alkisgebaeudenw.php

--DROP TABLE ax_gebaeude_gebaeudefunktion; -- alter Name

CREATE TABLE ax_gebaeude_funktion 
   (wert        integer, 
    bezeichner  character varying,
    kennung     integer, 
    objektart   character varying
   );


ALTER TABLE ax_gebaeude_funktion 
ADD CONSTRAINT pk_ax_gebaeude_funktion_wert 
PRIMARY KEY (wert);


INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1000,'Wohngebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1010,'Wohnhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1020,'Wohnheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1021,'Kinderheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1022,'Seniorenheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1023,'Schwesternwohnheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1024,'Studenten-, Schülerwohnheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1025,'Schullandheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1100,'Gemischt genutztes Gebäude mit Wohnen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1110,'Wohngebäude mit Gemeinbedarf',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1120,'Wohngebäude mit Handel und Dienstleistungen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1121,'Wohn- und Verwaltungsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1122,'Wohn- und Bürogebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1123,'Wohn- und Geschäftsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1130,'Wohngebäude mit Gewerbe und Industrie',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1131,'Wohn- und Betriebsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1210,'Land- und forstwirtschaftliches Wohngebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1220,'Land- und forstwirtschaftliches Wohn- und Betriebsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1221,'Bauernhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1222,'Wohn- und Wirtschaftsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1223,'Forsthaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1310,'Gebäude zur Freizeitgestaltung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1311,'Ferienhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1312,'Wochenendhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1313,'Gartenhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2000,'Gebäude für Wirtschaft oder Gewerbe',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2010,'Gebäude für Handel und Dienstleistungen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2020,'Bürogebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2030,'Kreditinstitut',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2040,'Versicherung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2050,'Geschäftsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2051,'Kaufhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2052,'Einkaufszentrum',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2053,'Markthalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2054,'Laden',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2055,'Kiosk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2056,'Apotheke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2060,'Messehalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2070,'Gebäude für Beherbergung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2071,'Hotel, Motel, Pension',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2072,'Jugendherberge',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2073,'Hütte (mit Übernachtungsmöglichkeit)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2074,'Campingplatzgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2080,'Gebäude für Bewirtung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2081,'Gaststätte, Restaurant',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2082,'Hütte (ohne Übernachtungsmöglichkeit)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2083,'Kantine',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2090,'Freizeit- und Vergnügungsstätte',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2091,'Festsaal',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2092,'Kino',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2093,'Kegel-, Bowlinghalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2094,'Spielkasino',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2100,'Gebäude für Gewerbe und Industrie',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2110,'Produktionsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2111,'Fabrik',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2112,'Betriebsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2113,'Brauerei',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2114,'Brennerei',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2120,'Werkstatt',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2121,'Sägewerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2130,'Tankstelle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2131,'Waschstraße, Waschanlage, Waschhalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2140,'Gebäude für Vorratshaltung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2141,'Kühlhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2142,'Speichergebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2143,'Lagerhalle, Lagerschuppen, Lagerhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2150,'Speditionsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2160,'Gebäude für Forschungszwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2170,'Gebäude für Grundstoffgewinnung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2171,'Bergwerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2172,'Saline',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2180,'Gebäude für betriebliche Sozialeinrichtung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2200,'Sonstiges Gebäude für Gewerbe und Industrie',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2210,'Mühle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2211,'Windmühle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2212,'Wassermühle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2213,'Schöpfwerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2220,'Wetterstation',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2310,'Gebäude für Handel und Dienstleistung mit Wohnen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2320,'Gebäude für Gewerbe und Industrie mit Wohnen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2400,'Betriebsgebäude zu Verkehrsanlagen (allgemein)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2410,'Betriebsgebäude für Straßenverkehr',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2411,'Straßenmeisterei',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2412,'Wartehalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2420,'Betriebsgebäude für Schienenverkehr',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2421,'Bahnwärterhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2422,'Lokschuppen, Wagenhalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2423,'Stellwerk, Blockstelle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2424,'Betriebsgebäude des Güterbahnhofs',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2430,'Betriebsgebäude für Flugverkehr',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2431,'Flugzeughalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2440,'Betriebsgebäude für Schiffsverkehr',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2441,'Werft (Halle)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2442,'Dock (Halle)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2443,'Betriebsgebäude zur Schleuse',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2444,'Bootshaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2450,'Betriebsgebäude zur Seilbahn',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2451,'Spannwerk zur Drahtseilbahn',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2460,'Gebäude zum Parken',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2461,'Parkhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2462,'Parkdeck',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2463,'Garage',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2464,'Fahrzeughalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2465,'Tiefgarage',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2500,'Gebäude zur Versorgung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2501,'Gebäude zur Energieversorgung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2510,'Gebäude zur Wasserversorgung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2511,'Wasserwerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2512,'Pumpstation',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2513,'Wasserbehälter',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2520,'Gebäude zur Elektrizitätsversorgung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2521,'Elektrizitätswerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2522,'Umspannwerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2523,'Umformer',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2527,'Reaktorgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2528,'Turbinenhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2529,'Kesselhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2540,'Gebäude für Fernmeldewesen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2560,'Gebäude an unterirdischen Leitungen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2570,'Gebäude zur Gasversorgung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2571,'Gaswerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2580,'Heizwerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2590,'Gebäude zur Versorgungsanlage',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2591,'Pumpwerk (nicht für Wasserversorgung)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2600,'Gebäude zur Entsorgung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2610,'Gebäude zur Abwasserbeseitigung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2611,'Gebäude der Kläranlage',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2612,'Toilette',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2620,'Gebäude zur Abfallbehandlung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2621,'Müllbunker',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2622,'Gebäude zur Müllverbrennung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2623,'Gebäude der Abfalldeponie',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2700,'Gebäude für Land- und Forstwirtschaft',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2720,'Land- und forstwirtschaftliches Betriebsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2721,'Scheune',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2723,'Schuppen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2724,'Stall',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2726,'Scheune und Stall',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2727,'Stall für Tiergroßhaltung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2728,'Reithalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2729,'Wirtschaftsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2732,'Almhütte',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2735,'Jagdhaus, Jagdhütte',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2740,'Treibhaus, Gewächshaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2741,'Treibhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2742,'Gewächshaus, verschiebbar',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3000,'Gebäude für öffentliche Zwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3010,'Verwaltungsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3011,'Parlament',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3012,'Rathaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3013,'Post',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3014,'Zollamt',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3015,'Gericht',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3016,'Botschaft, Konsulat',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3017,'Kreisverwaltung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3018,'Bezirksregierung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3019,'Finanzamt',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3020,'Gebäude für Bildung und Forschung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3021,'Allgemein bildende Schule',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3022,'Berufsbildende Schule',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3023,'Hochschulgebäude (Fachhochschule, Universität)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3024,'Forschungsinstitut',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3030,'Gebäude für kulturelle Zwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3031,'Schloss',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3032,'Theater, Oper',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3033,'Konzertgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3034,'Museum',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3035,'Rundfunk, Fernsehen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3036,'Veranstaltungsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3037,'Bibliothek, Bücherei',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3038,'Burg, Festung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3040,'Gebäude für religiöse Zwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3041,'Kirche',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3042,'Synagoge',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3043,'Kapelle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3044,'Gemeindehaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3045,'Gotteshaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3046,'Moschee',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3047,'Tempel',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3048,'Kloster',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3050,'Gebäude für Gesundheitswesen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3051,'Krankenhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3052,'Heilanstalt, Pflegeanstalt, Pflegestation',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3053,'Ärztehaus, Poliklinik',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3060,'Gebäude für soziale Zwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3061,'Jugendfreizeitheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3062,'Freizeit-, Vereinsheim, Dorfgemeinschafts-, Bürgerhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3063,'Seniorenfreizeitstätte',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3064,'Obdachlosenheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3065,'Kinderkrippe, Kindergarten, Kindertagesstätte',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3066,'Asylbewerberheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3070,'Gebäude für Sicherheit und Ordnung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3071,'Polizei',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3072,'Feuerwehr',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3073,'Kaserne',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3074,'Schutzbunker',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3075,'Justizvollzugsanstalt',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3080,'Friedhofsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3081,'Trauerhalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3082,'Krematorium',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3090,'Empfangsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3091,'Bahnhofsgebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3092,'Flughafengebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3094,'Gebäude zum U-Bahnhof',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3095,'Gebäude zum S-Bahnhof',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3097,'Gebäude zum Busbahnhof',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3098,'Empfangsgebäude Schifffahrt',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3100,'Gebäude für öffentliche Zwecke mit Wohnen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3200,'Gebäude für Erholungszwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3210,'Gebäude für Sportzwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3211,'Sport-, Turnhalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3212,'Gebäude zum Sportplatz',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3220,'Badegebäude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3221,'Hallenbad',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3222,'Gebäude im Freibad',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3230,'Gebäude im Stadion',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3240,'Gebäude für Kurbetrieb',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3241,'Badegebäude für medizinische Zwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3242,'Sanatorium',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3260,'Gebäude im Zoo',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3261,'Empfangsgebäude des Zoos',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3262,'Aquarium, Terrarium, Voliere',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3263,'Tierschauhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3264,'Stall im Zoo',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3270,'Gebäude im botanischen Garten',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3271,'Empfangsgebäude des botanischen Gartens',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3272,'Gewächshaus (Botanik)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3273,'Pflanzenschauhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3280,'Gebäude für andere Erholungseinrichtung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3281,'Schutzhütte',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3290,'Touristisches Informationszentrum',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (9998,'Nach Quellenlage nicht zu spezifizieren',31001,'ax_gebaeude');



-- B u c h u n g s t s t e l l e  -  B u c h u n g s a r t

-- 

-- DROP TABLE ax_buchungsstelle_buchungsart;

CREATE TABLE ax_buchungsstelle_buchungsart
  (
   wert integer, 
   bezeichner character varying,  
   kennung integer, 
   objektart character varying
  );


ALTER TABLE ax_buchungsstelle_buchungsart 
ADD CONSTRAINT pk_ax_buchungsstelle_buchungsart_wert 
PRIMARY KEY (wert);

-- 51 Werte

INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1100,'Grundstück',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1101,'Aufgeteiltes Grundstück WEG',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1102,'Aufgeteiltes Grundstück Par. 3 Abs. 4 GBO',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1200,'Ungetrennter Hofraum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1301,'Wohnungs-/Teileigentum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1302,'Miteigentum Par. 3 Abs. 4 GBO',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1303,'Anteil am ungetrennten Hofraum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1401,'Aufgeteilter Anteil Wohnungs-/Teileigentum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1402,'Aufgeteilter Anteil Miteigentum Par. 3 Abs. 4 GBO',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1403,'Aufgeteilter Anteil am ungetrennten Hofraum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1501,'Anteil an Wohnungs-/Teileigentumsanteil',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1502,'Anteil an Miteigentumsanteil Par. 3 Abs. 4 GBO',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1503,'Anteil am Anteil zum ungetrennten Hofraum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2101,'Erbbaurecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2102,'Untererbbaurecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2103,'Gebäudeeigentum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2104,'Fischereirecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2105,'Bergwerksrecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2106,'Nutzungsrecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2107,'Realgewerberecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2108,'Gemeinderecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2109,'Stavenrecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2110,'Hauberge',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2201,'Aufgeteiltes Erbbaurecht WEG',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2202,'Aufgeteiltes Untererbbaurecht WEG',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2203,'Aufgeteiltes Recht Par. 3 Abs. 4 GBO',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2204,'Aufgeteiltes Recht, Körperschaft',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2205,'Aufgeteiltes Gebäudeeigentum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2301,'Wohnungs-/Teilerbbaurecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2302,'Wohnungs-/Teiluntererbbaurecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2303,'Erbbaurechtsanteil Par. 3 Abs. 4 GBO',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2304,'Anteiliges Recht, Körperschaft',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2305,'Anteil am Gebäudeeigentum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2401,'Aufgeteilter Anteil Wohnungs-/Teilerbbaurecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2402,'Aufgeteilter Anteil Wohnungs-/Teiluntererbbaurecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2403,'Aufgeteilter Erbbaurechtsanteil Par. 3 Abs. 4 GBO',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2404,'Aufgeteiltes anteiliges Recht, Körperschaft',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2405,'Aufgeteilter Anteil am Gebäudeeigentum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2501,'Anteil am Wohnungs-/Teilerbbaurechtsanteil',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2502,'Anteil am Wohnungs-/Teiluntererbbaurechtsanteil',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2503,'Anteil am Erbbaurechtsanteil Par. 3 Abs. 4 GBO',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2504,'Anteil am anteiligen Recht, Körperschaft',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2505,'Anteil am Anteil zum Gebäudeeigentum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (3100,'Vermerk subjektiv dinglicher Rechte (Par. 9 GBO)',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (4100,'Stockwerkseigentum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (5101,'Von Buchungspflicht befreit Par. 3 Abs. 2 GBO',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (5200,'Anliegerflurstück',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (5201,'Anliegerweg',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (5202,'Anliegergraben',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (5203,'Anliegerwasserlauf, Anliegergewässer',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (6101,'Nicht gebuchtes Fischereirecht',21008,'ax_buchungsstelle');



-- E i g e n t u e m e r a r t

-- Laut GeoInfoDok nur 3 Werte.
-- In RLP-Mustersdaten aber viele verschiedene Werte-

-- Fuer "viele Werte" wuerde sich eine Tabelle lohnen.
-- 3 Werte koennen ueber Function (case) entschluesselt werden.


-- ax_bauraumoderbodenordnungsrecht_artderfestlegung


-- Entschluesseln der Rechte im Template

CREATE TABLE ax_bauraumoderbodenordnungsrecht_artderfestlegung 
  (wert        integer, 
   bezeichner  character varying,
   kennung     integer,
   objektart   character varying
  );

ALTER TABLE ax_bauraumoderbodenordnungsrecht_artderfestlegung 
ADD CONSTRAINT pk_ax_bauraumoderbodenordnungsrecht_artderfestlegung_wert 
PRIMARY KEY (wert);


INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1700,'Festlegung nach Baugesetzbuch - Allgemeines Städtebaurecht',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1710,'Bebauungsplan',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1720,'Veränderungssperre nach Baugesetzbuch',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1730,'Vorkaufrechtssatzung',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1740,'Enteignungsverfahren',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1750,'Umlegung nach dem BauGB',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1760,'Bauland',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1770,'Vereinfachte Umlegung',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1780,'Vorhaben- und Erschließungsplan',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1790,'Flächennutzungsplan',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1800,'Festlegung nach Baugesetzbuch - Besonderes Städtebaurecht',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1810,'Städtebauliche Entwicklungsmaßnahme',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1811,'Städtebauliche Entwicklungsmaßnahme (Beschluss zu vorbereitenden Untersuchungen gefasst)',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1820,'Erhaltungssatzung',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1821,'Städtebauliches Erhaltungsgebiet',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1822,'Soziales Erhaltungsgebiet',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1823,'Erhaltungsgebiet zur städtebaulichen Umstrukturierung',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1824,'Soziales Erhaltungsgebiet (Aufstellungsbeschluss gefasst)',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1830,'Städtebauliche Gebote',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1840,'Sanierung',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1841,'Sanierung (Beschluss zu vorbereitenden Untersuchungen gefasst)',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (1900,'Wohnungsbauerleichterungsgesetz',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2100,'Flurbereinigungsgesetz',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2110,'Flurbereinigung (Par. 1, 37 FlurbG)',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2120,'Vereinfachtes Flurbereinigungsverfahren (Par. 86 FlurbG)',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2130,'Unternehmensflurbereinigung (nach Par. 87 oder 90 FlurbG)',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2140,'Beschleunigtes Zusammenlegungsverfahren (Par. 91 FlurbG)',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2150,'Freiwilliger Landtausch (Par. 103a FlurbG)',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2160,'Verfahren nach dem Gemeinheitsteilungsgesetz',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2170,'Verfahren nach dem Gemeinschaftswaldgesetz',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2180,'Freiwilliger Nutzungstausch',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2200,'Verfahren nach dem Landwirtschaftsanpassungsgesetz',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2210,'Flurneuordnung',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2220,'Freiwilliger Landtausch (Par. 54 LwAnpG)',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2230,'Bodenordnungsverfahren (Par. 56 LwAnpG)',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2240,'Zusammenführung von Boden- und Gebäudeeigentum (Par. 64 LwAnpG)',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2300,'Bodensonderungsgesetz',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2310,'Unvermessenes Eigentum',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2320,'Unvermessenes Nutzungsrecht',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2330,'Ergänzende Bodenneuordnung',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2340,'Komplexe Bodenneuordnung',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2400,'Vermögenszuordnungsgesetz',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2410,'Vermögenszuordnung nach Plan',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2411,'Vermögenszuordnung nach dem Aufteilungsplan',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2412,'Vermögenszuordnung nach dem Zuordnungsplan',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2500,'Landesraumordnungsgesetz',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2510,'Wasservorranggebiete',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2600,'Bauordnung',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2610,'Baulast',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2611,'Begünstigende Baulast',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2612,'Belastende Baulast',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2700,'Grenzfeststellungsverfahren nach Hamb. Wassergesetz',71008,'ax_bauraumoderbodenordnungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner,kennung,objektart) VALUES (2800,'Verkehrsflächenbereinigung',71008,'ax_bauraumoderbodenordnungsrecht');

-- Bauteil Bauart

CREATE TABLE ax_bauteil_bauart (
    wert integer NOT NULL,
    bezeichner character varying,
    kennung integer,
    objektart character varying
);


ALTER TABLE ax_bauteil_bauart 
ADD CONSTRAINT pk_ax_bauteil_bauart_wert 
PRIMARY KEY (wert);

INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (1100, 'Geringergeschossiger Gebäudeteil', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (1200, 'Höhergeschossiger Gebäudeteil (nicht Hochhaus)', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (1300, 'Hochhausgebäudeteil', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (1400, 'Abweichende Geschosshöhe', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2000, 'Keller', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2100, 'Tiefgarage', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2300, 'Loggia', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2350, 'Wintergarten', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2400, 'Arkade', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2500, 'Auskragende/zurückspringende Geschosse', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2510, 'Auskragende Geschosse', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2520, 'Zurückspringende Geschosse', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2610, 'Durchfahrt im Gebäude', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2620, 'Durchfahrt an überbauter Verkehrsstraße', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2710, 'Schornstein im Gebäude', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2720, 'Turm im Gebäude', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (9999, 'Sonstiges', 31002, 'ax_bauteil');


-- Entschlüsseln von Nutzungsarten
--




-- B e r e c h t i g u n g e n
-- ---------------------------

-- Interne Version:
GRANT SELECT ON TABLE ax_gebaeude_bauweise          TO ms5;
GRANT SELECT ON TABLE ax_gebaeude_funktion          TO ms5;
GRANT SELECT ON TABLE ax_buchungsstelle_buchungsart TO ms5;

-- Auskunft in WWW-Version:
GRANT SELECT ON TABLE ax_gebaeude_bauweise          TO alkisbuch;
GRANT SELECT ON TABLE ax_gebaeude_funktion          TO alkisbuch;
GRANT SELECT ON TABLE ax_buchungsstelle_buchungsart TO alkisbuch;

-- ENDE --
