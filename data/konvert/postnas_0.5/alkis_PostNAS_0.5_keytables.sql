
-- ALKIS-Datenbank aus dem Konverter PostNAS 0.5

-- Z u s a e t z l i c h e   S c h l u e s s e l t a b e l l e n

-- Dieses Script fuegt der Datenbank einige Schluesseltabellen hinzu, die der 
-- Konverter PostNAS NICHT aufbaut, weil sie nicht in den NAS-daten enthalten sind.
-- Die Schluessel sind der Dokumantation zu entnehmen.

-- Die Tabellen werden vom Buchwerk-Auskunftsprogramm benoetigt.

-- Dies Script kann nach dem Anlegen der Datenbank mit dem Script 'alkis_PostNAS_0.5_schema.sql'
-- verarbeitet werden.

-- Alternativ kann eine Template-Datenbbank bereits mit diesen Schluesseltabellen angelegt werden.

-- Version

-- krz f.j. 2010-09-15   Buchungsart hinzugefuegt



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


INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1100,'Freistehendes Einzelgeb�ude');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1200,'Freistehender Geb�udeblock');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1300,'Einzelgarage');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1400,'Doppelgarage');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1500,'Sammelgarage');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2100,'Doppelhaush�lfte');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2200,'Reihenhaus');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2300,'Haus in Reihe');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2400,'Gruppenhaus');
INSERT INTO ax_gebaeude_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2500,'Geb�udeblock in geschlossener Bauweise');
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


INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1000,'Wohngeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1010,'Wohnhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1020,'Wohnheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1021,'Kinderheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1022,'Seniorenheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1023,'Schwesternwohnheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1024,'Studenten-, Sch�lerwohnheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1025,'Schullandheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1100,'Gemischt genutztes Geb�ude mit Wohnen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1110,'Wohngeb�ude mit Gemeinbedarf',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1120,'Wohngeb�ude mit Handel und Dienstleistungen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1121,'Wohn- und Verwaltungsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1122,'Wohn- und B�rogeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1123,'Wohn- und Gesch�ftsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1130,'Wohngeb�ude mit Gewerbe und Industrie',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1131,'Wohn- und Betriebsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1210,'Land- und forstwirtschaftliches Wohngeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1220,'Land- und forstwirtschaftliches Wohn- und Betriebsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1221,'Bauernhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1222,'Wohn- und Wirtschaftsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1223,'Forsthaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1310,'Geb�ude zur Freizeitgestaltung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1311,'Ferienhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1312,'Wochenendhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (1313,'Gartenhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2000,'Geb�ude f�r Wirtschaft oder Gewerbe',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2010,'Geb�ude f�r Handel und Dienstleistungen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2020,'B�rogeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2030,'Kreditinstitut',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2040,'Versicherung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2050,'Gesch�ftsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2051,'Kaufhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2052,'Einkaufszentrum',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2053,'Markthalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2054,'Laden',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2055,'Kiosk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2056,'Apotheke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2060,'Messehalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2070,'Geb�ude f�r Beherbergung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2071,'Hotel, Motel, Pension',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2072,'Jugendherberge',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2073,'H�tte (mit �bernachtungsm�glichkeit)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2074,'Campingplatzgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2080,'Geb�ude f�r Bewirtung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2081,'Gastst�tte, Restaurant',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2082,'H�tte (ohne �bernachtungsm�glichkeit)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2083,'Kantine',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2090,'Freizeit- und Vergn�gungsst�tte',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2091,'Festsaal',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2092,'Kino',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2093,'Kegel-, Bowlinghalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2094,'Spielkasino',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2100,'Geb�ude f�r Gewerbe und Industrie',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2110,'Produktionsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2111,'Fabrik',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2112,'Betriebsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2113,'Brauerei',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2114,'Brennerei',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2120,'Werkstatt',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2121,'S�gewerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2130,'Tankstelle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2131,'Waschstra�e, Waschanlage, Waschhalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2140,'Geb�ude f�r Vorratshaltung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2141,'K�hlhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2142,'Speichergeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2143,'Lagerhalle, Lagerschuppen, Lagerhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2150,'Speditionsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2160,'Geb�ude f�r Forschungszwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2170,'Geb�ude f�r Grundstoffgewinnung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2171,'Bergwerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2172,'Saline',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2180,'Geb�ude f�r betriebliche Sozialeinrichtung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2200,'Sonstiges Geb�ude f�r Gewerbe und Industrie',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2210,'M�hle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2211,'Windm�hle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2212,'Wasserm�hle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2213,'Sch�pfwerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2220,'Wetterstation',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2310,'Geb�ude f�r Handel und Dienstleistung mit Wohnen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2320,'Geb�ude f�r Gewerbe und Industrie mit Wohnen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2400,'Betriebsgeb�ude zu Verkehrsanlagen (allgemein)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2410,'Betriebsgeb�ude f�r Stra�enverkehr',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2411,'Stra�enmeisterei',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2412,'Wartehalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2420,'Betriebsgeb�ude f�r Schienenverkehr',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2421,'Bahnw�rterhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2422,'Lokschuppen, Wagenhalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2423,'Stellwerk, Blockstelle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2424,'Betriebsgeb�ude des G�terbahnhofs',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2430,'Betriebsgeb�ude f�r Flugverkehr',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2431,'Flugzeughalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2440,'Betriebsgeb�ude f�r Schiffsverkehr',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2441,'Werft (Halle)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2442,'Dock (Halle)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2443,'Betriebsgeb�ude zur Schleuse',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2444,'Bootshaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2450,'Betriebsgeb�ude zur Seilbahn',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2451,'Spannwerk zur Drahtseilbahn',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2460,'Geb�ude zum Parken',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2461,'Parkhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2462,'Parkdeck',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2463,'Garage',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2464,'Fahrzeughalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2465,'Tiefgarage',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2500,'Geb�ude zur Versorgung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2501,'Geb�ude zur Energieversorgung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2510,'Geb�ude zur Wasserversorgung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2511,'Wasserwerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2512,'Pumpstation',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2513,'Wasserbeh�lter',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2520,'Geb�ude zur Elektrizit�tsversorgung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2521,'Elektrizit�tswerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2522,'Umspannwerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2523,'Umformer',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2527,'Reaktorgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2528,'Turbinenhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2529,'Kesselhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2540,'Geb�ude f�r Fernmeldewesen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2560,'Geb�ude an unterirdischen Leitungen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2570,'Geb�ude zur Gasversorgung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2571,'Gaswerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2580,'Heizwerk',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2590,'Geb�ude zur Versorgungsanlage',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2591,'Pumpwerk (nicht f�r Wasserversorgung)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2600,'Geb�ude zur Entsorgung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2610,'Geb�ude zur Abwasserbeseitigung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2611,'Geb�ude der Kl�ranlage',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2612,'Toilette',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2620,'Geb�ude zur Abfallbehandlung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2621,'M�llbunker',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2622,'Geb�ude zur M�llverbrennung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2623,'Geb�ude der Abfalldeponie',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2700,'Geb�ude f�r Land- und Forstwirtschaft',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2720,'Land- und forstwirtschaftliches Betriebsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2721,'Scheune',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2723,'Schuppen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2724,'Stall',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2726,'Scheune und Stall',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2727,'Stall f�r Tiergro�haltung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2728,'Reithalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2729,'Wirtschaftsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2732,'Almh�tte',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2735,'Jagdhaus, Jagdh�tte',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2740,'Treibhaus, Gew�chshaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2741,'Treibhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (2742,'Gew�chshaus, verschiebbar',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3000,'Geb�ude f�r �ffentliche Zwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3010,'Verwaltungsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3011,'Parlament',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3012,'Rathaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3013,'Post',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3014,'Zollamt',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3015,'Gericht',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3016,'Botschaft, Konsulat',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3017,'Kreisverwaltung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3018,'Bezirksregierung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3019,'Finanzamt',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3020,'Geb�ude f�r Bildung und Forschung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3021,'Allgemein bildende Schule',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3022,'Berufsbildende Schule',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3023,'Hochschulgeb�ude (Fachhochschule, Universit�t)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3024,'Forschungsinstitut',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3030,'Geb�ude f�r kulturelle Zwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3031,'Schloss',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3032,'Theater, Oper',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3033,'Konzertgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3034,'Museum',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3035,'Rundfunk, Fernsehen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3036,'Veranstaltungsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3037,'Bibliothek, B�cherei',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3038,'Burg, Festung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3040,'Geb�ude f�r religi�se Zwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3041,'Kirche',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3042,'Synagoge',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3043,'Kapelle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3044,'Gemeindehaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3045,'Gotteshaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3046,'Moschee',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3047,'Tempel',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3048,'Kloster',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3050,'Geb�ude f�r Gesundheitswesen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3051,'Krankenhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3052,'Heilanstalt, Pflegeanstalt, Pflegestation',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3053,'�rztehaus, Poliklinik',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3060,'Geb�ude f�r soziale Zwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3061,'Jugendfreizeitheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3062,'Freizeit-, Vereinsheim, Dorfgemeinschafts-, B�rgerhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3063,'Seniorenfreizeitst�tte',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3064,'Obdachlosenheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3065,'Kinderkrippe, Kindergarten, Kindertagesst�tte',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3066,'Asylbewerberheim',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3070,'Geb�ude f�r Sicherheit und Ordnung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3071,'Polizei',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3072,'Feuerwehr',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3073,'Kaserne',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3074,'Schutzbunker',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3075,'Justizvollzugsanstalt',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3080,'Friedhofsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3081,'Trauerhalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3082,'Krematorium',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3090,'Empfangsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3091,'Bahnhofsgeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3092,'Flughafengeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3094,'Geb�ude zum U-Bahnhof',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3095,'Geb�ude zum S-Bahnhof',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3097,'Geb�ude zum Busbahnhof',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3098,'Empfangsgeb�ude Schifffahrt',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3100,'Geb�ude f�r �ffentliche Zwecke mit Wohnen',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3200,'Geb�ude f�r Erholungszwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3210,'Geb�ude f�r Sportzwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3211,'Sport-, Turnhalle',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3212,'Geb�ude zum Sportplatz',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3220,'Badegeb�ude',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3221,'Hallenbad',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3222,'Geb�ude im Freibad',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3230,'Geb�ude im Stadion',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3240,'Geb�ude f�r Kurbetrieb',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3241,'Badegeb�ude f�r medizinische Zwecke',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3242,'Sanatorium',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3260,'Geb�ude im Zoo',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3261,'Empfangsgeb�ude des Zoos',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3262,'Aquarium, Terrarium, Voliere',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3263,'Tierschauhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3264,'Stall im Zoo',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3270,'Geb�ude im botanischen Garten',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3271,'Empfangsgeb�ude des botanischen Gartens',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3272,'Gew�chshaus (Botanik)',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3273,'Pflanzenschauhaus',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3280,'Geb�ude f�r andere Erholungseinrichtung',31001,'ax_gebaeude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner,kennung,objektart) VALUES (3281,'Schutzh�tte',31001,'ax_gebaeude');
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

INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1100,'Grundst�ck',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1101,'Aufgeteiltes Grundst�ck WEG',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (1102,'Aufgeteiltes Grundst�ck Par. 3 Abs. 4 GBO',21008,'ax_buchungsstelle');
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
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2103,'Geb�udeeigentum',21008,'ax_buchungsstelle');
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
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2204,'Aufgeteiltes Recht, K�rperschaft',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2205,'Aufgeteiltes Geb�udeeigentum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2301,'Wohnungs-/Teilerbbaurecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2302,'Wohnungs-/Teiluntererbbaurecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2303,'Erbbaurechtsanteil Par. 3 Abs. 4 GBO',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2304,'Anteiliges Recht, K�rperschaft',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2305,'Anteil am Geb�udeeigentum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2401,'Aufgeteilter Anteil Wohnungs-/Teilerbbaurecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2402,'Aufgeteilter Anteil Wohnungs-/Teiluntererbbaurecht',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2403,'Aufgeteilter Erbbaurechtsanteil Par. 3 Abs. 4 GBO',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2404,'Aufgeteiltes anteiliges Recht, K�rperschaft',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2405,'Aufgeteilter Anteil am Geb�udeeigentum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2501,'Anteil am Wohnungs-/Teilerbbaurechtsanteil',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2502,'Anteil am Wohnungs-/Teiluntererbbaurechtsanteil',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2503,'Anteil am Erbbaurechtsanteil Par. 3 Abs. 4 GBO',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2504,'Anteil am anteiligen Recht, K�rperschaft',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (2505,'Anteil am Anteil zum Geb�udeeigentum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (3100,'Vermerk subjektiv dinglicher Rechte (Par. 9 GBO)',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (4100,'Stockwerkseigentum',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (5101,'Von Buchungspflicht befreit Par. 3 Abs. 2 GBO',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (5200,'Anliegerflurst�ck',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (5201,'Anliegerweg',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (5202,'Anliegergraben',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (5203,'Anliegerwasserlauf, Anliegergew�sser',21008,'ax_buchungsstelle');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner,kennung,objektart) VALUES (6101,'Nicht gebuchtes Fischereirecht',21008,'ax_buchungsstelle');



-- E i g e n t u e m e r a r t

-- Laut GeoInfoDok nur 3 Werte.
-- In RLP-Mustersdaten aber viele verschiedene Werte-

-- Fuer "viele Werte" wuerde sich eine Tabelle lohnen.
-- 3 Werte koennen ueber Function (case) entschluesselt werden.


-- B e r e c h t i g u n g e n


-- Interne Version:
GRANT SELECT ON TABLE ax_gebaeude_bauweise          TO ms5;
GRANT SELECT ON TABLE ax_gebaeude_funktion          TO ms5;
GRANT SELECT ON TABLE ax_buchungsstelle_buchungsart TO ms5;

-- Auskunft in WWW-Version:
GRANT SELECT ON TABLE ax_gebaeude_bauweise          TO alkisbuch;
GRANT SELECT ON TABLE ax_gebaeude_funktion          TO alkisbuch;
GRANT SELECT ON TABLE ax_buchungsstelle_buchungsart TO alkisbuch;

-- ENDE --