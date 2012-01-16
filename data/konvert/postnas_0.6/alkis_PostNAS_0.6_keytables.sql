
-- ALKIS-Datenbank aus dem Konverter PostNAS 0.6

-- Z u s a e t z l i c h e   S c h l u e s s e l t a b e l l e n

-- Dieses Script fuegt der Datenbank einige Schluesseltabellen hinzu, die der 
-- Konverter PostNAS NICHT aufbaut, weil sie nicht in den NAS-Daten enthalten sind.
-- Die Schluessel sind der Dokumentation zu entnehmen.

-- Die Tabellen werden vom Buchwerk-Auskunftsprogramm benoetigt.

-- Dies Script kann nach dem Anlegen der Datenbank mit dem Script 'alkis_PostNAS_0.5_schema.sql'
-- verarbeitet werden.

-- Alternativ kann eine Template-Datenbbank bereits mit diesen Schluesseltabellen angelegt werden.

-- Version
--  2010-09-16  F.J. Buchungsart hinzugefuegt
--  2011-07-25       PostNAS 06, Umbenennung, "grant" raus
--  2011-11-21  F.J. Mehrere neue Schlüsseltabellen zu ax_gebaeude_*, Konstanten aus Tabellen entfernt (Wozu?)
--  2011-12-16  A.E. Mehrere neue Tabellen zum Bereich "Bodenschaetzung"
--  2011-12-19  F.J. Neue Tabelle "ax_datenerhebung"
--  2011-12-20  A.E. ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion
--  2011-12-22  A.E. ax_bauteil_bauart


  SET client_encoding = 'UTF8';


-- G e b a e u d e - B a u w e i s e
-- ---------------------------------

-- Wird z.B. benoetigt in Buchauskunft, Modul 'alkisgebaeudenw.php'

-- Nicht im Grunddatenbestand NRW 
-- Siehe http://www.kreis-euskirchen.de/service/downloads/geoinformation/Kreis_EU_Gebaeudeerfassung.pdf

CREATE TABLE ax_gebaeude_bauweise (
    bauweise_id            integer, 
    bauweise_beschreibung  character varying,
    CONSTRAINT pk_ax_ax_gebaeude_bauweise PRIMARY KEY (bauweise_id)
  );

COMMENT ON TABLE ax_gebaeude_bauweise 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

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

-- Tabelle wird z.B. benoetigt in Buchauskunft, Modul 'alkisgebaeudenw.php'

-- Kennung   = 31001
-- Objektart = 'ax_gebaeude'

--DROP TABLE ax_gebaeude_gebaeudefunktion; -- alter Name

CREATE TABLE ax_gebaeude_funktion (
    wert        integer, 
    bezeichner  character varying,
    CONSTRAINT pk_ax_gebaeude_funktion_wert PRIMARY KEY (wert)
   );


COMMENT ON TABLE  ax_gebaeude_funktion 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1000,'Wohngebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1010,'Wohnhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1020,'Wohnheim');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1021,'Kinderheim');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1022,'Seniorenheim');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1023,'Schwesternwohnheim');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1024,'Studenten-, Schülerwohnheim');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1025,'Schullandheim');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1100,'Gemischt genutztes Gebäude mit Wohnen');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1110,'Wohngebäude mit Gemeinbedarf');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1120,'Wohngebäude mit Handel und Dienstleistungen');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1121,'Wohn- und Verwaltungsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1122,'Wohn- und Bürogebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1123,'Wohn- und Geschäftsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1130,'Wohngebäude mit Gewerbe und Industrie');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1131,'Wohn- und Betriebsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1210,'Land- und forstwirtschaftliches Wohngebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1220,'Land- und forstwirtschaftliches Wohn- und Betriebsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1221,'Bauernhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1222,'Wohn- und Wirtschaftsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1223,'Forsthaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1310,'Gebäude zur Freizeitgestaltung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1311,'Ferienhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1312,'Wochenendhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (1313,'Gartenhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2000,'Gebäude für Wirtschaft oder Gewerbe');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2010,'Gebäude für Handel und Dienstleistungen');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2020,'Bürogebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2030,'Kreditinstitut');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2040,'Versicherung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2050,'Geschäftsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2051,'Kaufhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2052,'Einkaufszentrum');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2053,'Markthalle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2054,'Laden');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2055,'Kiosk');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2056,'Apotheke');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2060,'Messehalle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2070,'Gebäude für Beherbergung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2071,'Hotel, Motel, Pension');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2072,'Jugendherberge');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2073,'Hütte (mit Übernachtungsmöglichkeit)');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2074,'Campingplatzgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2080,'Gebäude für Bewirtung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2081,'Gaststätte, Restaurant');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2082,'Hütte (ohne Übernachtungsmöglichkeit)');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2083,'Kantine');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2090,'Freizeit- und Vergnügungsstätte');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2091,'Festsaal');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2092,'Kino');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2093,'Kegel-, Bowlinghalle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2094,'Spielkasino');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2100,'Gebäude für Gewerbe und Industrie');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2110,'Produktionsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2111,'Fabrik');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2112,'Betriebsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2113,'Brauerei');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2114,'Brennerei');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2120,'Werkstatt');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2121,'Sägewerk');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2130,'Tankstelle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2131,'Waschstraße, Waschanlage, Waschhalle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2140,'Gebäude für Vorratshaltung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2141,'Kühlhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2142,'Speichergebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2143,'Lagerhalle, Lagerschuppen, Lagerhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2150,'Speditionsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2160,'Gebäude für Forschungszwecke');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2170,'Gebäude für Grundstoffgewinnung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2171,'Bergwerk');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2172,'Saline');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2180,'Gebäude für betriebliche Sozialeinrichtung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2200,'Sonstiges Gebäude für Gewerbe und Industrie');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2210,'Mühle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2211,'Windmühle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2212,'Wassermühle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2213,'Schöpfwerk');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2220,'Wetterstation');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2310,'Gebäude für Handel und Dienstleistung mit Wohnen');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2320,'Gebäude für Gewerbe und Industrie mit Wohnen');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2400,'Betriebsgebäude zu Verkehrsanlagen (allgemein)');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2410,'Betriebsgebäude für Straßenverkehr');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2411,'Straßenmeisterei');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2412,'Wartehalle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2420,'Betriebsgebäude für Schienenverkehr');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2421,'Bahnwärterhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2422,'Lokschuppen, Wagenhalle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2423,'Stellwerk, Blockstelle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2424,'Betriebsgebäude des Güterbahnhofs');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2430,'Betriebsgebäude für Flugverkehr');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2431,'Flugzeughalle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2440,'Betriebsgebäude für Schiffsverkehr');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2441,'Werft (Halle)');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2442,'Dock (Halle)');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2443,'Betriebsgebäude zur Schleuse');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2444,'Bootshaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2450,'Betriebsgebäude zur Seilbahn');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2451,'Spannwerk zur Drahtseilbahn');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2460,'Gebäude zum Parken');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2461,'Parkhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2462,'Parkdeck');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2463,'Garage');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2464,'Fahrzeughalle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2465,'Tiefgarage');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2500,'Gebäude zur Versorgung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2501,'Gebäude zur Energieversorgung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2510,'Gebäude zur Wasserversorgung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2511,'Wasserwerk');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2512,'Pumpstation');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2513,'Wasserbehälter');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2520,'Gebäude zur Elektrizitätsversorgung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2521,'Elektrizitätswerk');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2522,'Umspannwerk');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2523,'Umformer');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2527,'Reaktorgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2528,'Turbinenhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2529,'Kesselhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2540,'Gebäude für Fernmeldewesen');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2560,'Gebäude an unterirdischen Leitungen');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2570,'Gebäude zur Gasversorgung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2571,'Gaswerk');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2580,'Heizwerk');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2590,'Gebäude zur Versorgungsanlage');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2591,'Pumpwerk (nicht für Wasserversorgung)');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2600,'Gebäude zur Entsorgung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2610,'Gebäude zur Abwasserbeseitigung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2611,'Gebäude der Kläranlage');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2612,'Toilette');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2620,'Gebäude zur Abfallbehandlung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2621,'Müllbunker');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2622,'Gebäude zur Müllverbrennung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2623,'Gebäude der Abfalldeponie');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2700,'Gebäude für Land- und Forstwirtschaft');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2720,'Land- und forstwirtschaftliches Betriebsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2721,'Scheune');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2723,'Schuppen');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2724,'Stall');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2726,'Scheune und Stall');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2727,'Stall für Tiergroßhaltung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2728,'Reithalle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2729,'Wirtschaftsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2732,'Almhütte');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2735,'Jagdhaus, Jagdhütte');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2740,'Treibhaus, Gewächshaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2741,'Treibhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (2742,'Gewächshaus, verschiebbar');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3000,'Gebäude für öffentliche Zwecke');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3010,'Verwaltungsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3011,'Parlament');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3012,'Rathaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3013,'Post');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3014,'Zollamt');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3015,'Gericht');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3016,'Botschaft, Konsulat');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3017,'Kreisverwaltung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3018,'Bezirksregierung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3019,'Finanzamt');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3020,'Gebäude für Bildung und Forschung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3021,'Allgemein bildende Schule');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3022,'Berufsbildende Schule');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3023,'Hochschulgebäude (Fachhochschule, Universität)');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3024,'Forschungsinstitut');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3030,'Gebäude für kulturelle Zwecke');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3031,'Schloss');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3032,'Theater, Oper');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3033,'Konzertgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3034,'Museum');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3035,'Rundfunk, Fernsehen');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3036,'Veranstaltungsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3037,'Bibliothek, Bücherei');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3038,'Burg, Festung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3040,'Gebäude für religiöse Zwecke');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3041,'Kirche');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3042,'Synagoge');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3043,'Kapelle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3044,'Gemeindehaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3045,'Gotteshaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3046,'Moschee');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3047,'Tempel');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3048,'Kloster');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3050,'Gebäude für Gesundheitswesen');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3051,'Krankenhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3052,'Heilanstalt, Pflegeanstalt, Pflegestation');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3053,'Ärztehaus, Poliklinik');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3060,'Gebäude für soziale Zwecke');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3061,'Jugendfreizeitheim');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3062,'Freizeit-, Vereinsheim, Dorfgemeinschafts-, Bürgerhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3063,'Seniorenfreizeitstätte');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3064,'Obdachlosenheim');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3065,'Kinderkrippe, Kindergarten, Kindertagesstätte');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3066,'Asylbewerberheim');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3070,'Gebäude für Sicherheit und Ordnung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3071,'Polizei');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3072,'Feuerwehr');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3073,'Kaserne');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3074,'Schutzbunker');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3075,'Justizvollzugsanstalt');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3080,'Friedhofsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3081,'Trauerhalle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3082,'Krematorium');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3090,'Empfangsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3091,'Bahnhofsgebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3092,'Flughafengebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3094,'Gebäude zum U-Bahnhof');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3095,'Gebäude zum S-Bahnhof');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3097,'Gebäude zum Busbahnhof');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3098,'Empfangsgebäude Schifffahrt');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3100,'Gebäude für öffentliche Zwecke mit Wohnen');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3200,'Gebäude für Erholungszwecke');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3210,'Gebäude für Sportzwecke');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3211,'Sport-, Turnhalle');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3212,'Gebäude zum Sportplatz');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3220,'Badegebäude');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3221,'Hallenbad');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3222,'Gebäude im Freibad');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3230,'Gebäude im Stadion');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3240,'Gebäude für Kurbetrieb');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3241,'Badegebäude für medizinische Zwecke');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3242,'Sanatorium');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3260,'Gebäude im Zoo');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3261,'Empfangsgebäude des Zoos');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3262,'Aquarium, Terrarium, Voliere');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3263,'Tierschauhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3264,'Stall im Zoo');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3270,'Gebäude im botanischen Garten');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3271,'Empfangsgebäude des botanischen Gartens');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3272,'Gewächshaus (Botanik)');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3273,'Pflanzenschauhaus');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3280,'Gebäude für andere Erholungseinrichtung');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3281,'Schutzhütte');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (3290,'Touristisches Informationszentrum');
INSERT INTO ax_gebaeude_funktion (wert, bezeichner) VALUES (9998,'Nach Quellenlage nicht zu spezifizieren');



-- W e i t e r e   G e b a e u d e - F u n k t i o n
-- -------------------------------------------------

--DROP TABLE ax_gebaeude_weiterefunktion;

CREATE TABLE ax_gebaeude_weiterefunktion (
    wert        integer,
    bezeichner  character varying,
    CONSTRAINT pk_ax_gebaeude_weitfunktion_wert PRIMARY KEY (wert)
   );

COMMENT ON TABLE  ax_gebaeude_weiterefunktion 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1000, 'Bankfiliale');	-- , 'Bankfiliale' ist eine Einrichtung in der Geldgeschäfte getätigt werden.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1010, 'Hotel');		-- , 'Hotel' ist ein Beherbergungs- und/oder Verpflegungsbetrieb.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1020, 'Jugendherberge');	-- , 'Jugendherberge' ist eine zur Förderung von Jugendreisen dienende Aufenthalts- und Übernachtungsstätte.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1030, 'Gaststätte');		-- , 'Gaststätte' ist eine Einrichtung, in der gegen Entgelt Mahlzeiten und Getränke zum sofortigen Verzehr angeboten werden.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1040, 'Kino');		-- , 'Kino' ist eine Einrichtung, in der alle Arten von Filmen bzw. Lichtspielen für ein Publikum abgespielt werden.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1050, 'Spielkasino');	-- , 'Spielkasino' ist eine Einrichtung, in der öffentlich zugänglich staatlich konzessioniertes Glücksspiel betrieben wird.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1060, 'Tiefgarage');		-- , 'Tiefgarage' ist ein Bauwerk unterhalb der Erdoberfläche, in dem Fahrzeuge abgestellt werden.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1070, 'Parkdeck');		-- , 'Parkdeck' ist eine Fläche auf einem Gebäude, auf der Fahrzeuge abgestellt werden.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1080, 'Toilette');		-- , 'Toilette' ist eine Einrichtung mit sanitären Vorrichtungen zum Verrichtung der Notdurft.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1090, 'Post');		-- , 'Post' ist eine Einrichtung, von der aus Briefe, Pakete befördert und weitere Dienstleistungen angeboten werden.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1100, 'Zoll');		-- , 'Zoll' ist eine Einrichtung der Zollabfertigung.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1110, 'Theater');		-- , 'Theater' ist eine Einrichtung, in der Bühnenstücke aufgeführt werden.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1120, 'Museum');		-- , 'Museum' ist eine Einrichtung in der Sammlungen von (historischen) Objekten oder Reproduktionen davon ausgestellt werden.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1130, 'Bibliothek');		-- , 'Bibliothek' ist eine Einrichtung, in der Bücher und Zeitschriften gesammelt, aufbewahrt und ausgeliehen werden.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1140, 'Kapelle');		-- , 'Kapelle' ist eine Einrichtung für (christliche) gottesdienstliche Zwecke .
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1150, 'Moschee');		-- , 'Moschee' ist ein Einrichtung, in der sich Muslime zu Gottesdiensten versammeln oder zu anderen Zwecken treffen.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1160, 'Tempel');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1170, 'Apotheke');		-- ,'Apotheke' ist ein Geschäft, in dem Arzneimittel hergestellt und verkauft werden.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1180, 'Polizeiwache');	-- , 'Polizeiwache' ist eine Dienststelle der Polizei.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1190, 'Rettungsstelle');	-- , 'Rettungsstelle' ist eine Einrichtung zur Aufnahme, Erstbehandlung und gezielten Weiterverlegung von Patienten mit Erkrankungen und Unfällen aller Art.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1200, 'Touristisches Informationszentrum'); -- , 'Touristisches Informationszentrum' ist eine Auskunftsstelle für Touristen.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1210, 'Kindergarten');	-- , 'Kindergarten' ist eine Einrichtung, in der Kinder im Vorschulalter betreut werden.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1220, 'Arztpraxis');		-- , 'Arztpraxis' ist die Arbeitsstätte eines Arztes.
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1230, 'Supermarkt');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner) VALUES (1240, 'Geschäft');


-- G e b ä u d e   D a c h f o r m
-- -------------------------------

--DROP TABLE ax_gebaeude_dachform;

CREATE TABLE ax_gebaeude_dachform 
   (wert        integer, 
    bezeichner  character varying,
    CONSTRAINT pk_ax_gebaeude_dach_wert PRIMARY KEY (wert)
   );

COMMENT ON TABLE  ax_gebaeude_dachform 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (1000, 'Flachdach');
INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (2100, 'Pultdach');
INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (2200, 'Versetztes Pultdach');
INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (3100, 'Satteldach');
INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (3200, 'Walmdach');
INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (3300, 'Krüppelwalmdach');
INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (3400, 'Mansardendach');
INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (3500, 'Zeltdach');
INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (3600, 'Kegeldach');
INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (3700, 'Kuppeldach');
INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (3800, 'Sheddach');
INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (3900, 'Bogendach');
INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (4000, 'Turmdach');
INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (5000, 'Mischform');
INSERT INTO ax_gebaeude_dachform (wert, bezeichner) VALUES (9999, 'Sonstiges');



-- G e b ä u d e   Z u s t a n d
-- -----------------------------

CREATE TABLE ax_gebaeude_zustand 
   (wert        integer, 
    bezeichner  character varying,
    CONSTRAINT pk_ax_gebaeude_zustand_wert PRIMARY KEY (wert)
   );

COMMENT ON TABLE  ax_gebaeude_zustand 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_gebaeude_zustand (wert, bezeichner) VALUES (1000, 'In behelfsmäßigem Zustand');
INSERT INTO ax_gebaeude_zustand (wert, bezeichner) VALUES (2000, 'In ungenutztem Zustand');
INSERT INTO ax_gebaeude_zustand (wert, bezeichner) VALUES (2100, 'Außer Betrieb, stillgelegt, verlassen');
--'Außer Betrieb, stillgelegt, verlassen' bedeutet, dass das Gebäude auf Dauer nicht mehr bewohnt oder genutzt wird.
INSERT INTO ax_gebaeude_zustand (wert, bezeichner) VALUES (2200, 'Verfallen, zerstört');
-- 'Verfallen, zerstört' bedeutet, dass sich der ursprüngliche Zustand des Gebäudes durch menschliche oder zeitliche Einwirkungen so verändert hat, dass eine Nutzung nicht mehr möglich ist.
INSERT INTO ax_gebaeude_zustand (wert, bezeichner) VALUES (2300, 'Teilweise zerstört');
INSERT INTO ax_gebaeude_zustand (wert, bezeichner) VALUES (3000, 'Geplant und beantragt');
INSERT INTO ax_gebaeude_zustand (wert, bezeichner) VALUES (4000, 'Im Bau');


-- LageZurErdoberflaeche
-- ---------------------
-- nur 2 Werte

-- 1200, Unter der Erdoberfläche
--	"Unter der Erdoberfläche" bedeutet, dass sich das Gebäude unter der Erdoberfläche befindet.

-- 1400, Aufgeständert
--	"Aufgeständert" bedeutet, dass ein Gebäude auf Stützen steht.


-- Dachgeschossausbau
-- ------------------
-- nur 4 Werte

-- 1000 Nicht ausbaufähig
-- 2000 Ausbaufähig
-- 3000 Ausgebaut
-- 4000 Ausbaufähigkeit unklar


-- B u c h u n g s t s t e l l e  -  B u c h u n g s a r t
-- -------------------------------------------------------

-- Kennung   = 21008,
-- Objektart = 'ax_buchungsstelle'

CREATE TABLE ax_buchungsstelle_buchungsart (
   wert integer,
   bezeichner character varying,
   CONSTRAINT pk_ax_bsba_wert PRIMARY KEY (wert)
  );

COMMENT ON TABLE  ax_buchungsstelle_buchungsart 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

-- 51 Werte
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (1100,'Grundstück');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (1101,'Aufgeteiltes Grundstück WEG');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (1102,'Aufgeteiltes Grundstück Par. 3 Abs. 4 GBO');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (1200,'Ungetrennter Hofraum');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (1301,'Wohnungs-/Teileigentum');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (1302,'Miteigentum Par. 3 Abs. 4 GBO');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (1303,'Anteil am ungetrennten Hofraum');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (1401,'Aufgeteilter Anteil Wohnungs-/Teileigentum');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (1402,'Aufgeteilter Anteil Miteigentum Par. 3 Abs. 4 GBO');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (1403,'Aufgeteilter Anteil am ungetrennten Hofraum');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (1501,'Anteil an Wohnungs-/Teileigentumsanteil');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (1502,'Anteil an Miteigentumsanteil Par. 3 Abs. 4 GBO');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (1503,'Anteil am Anteil zum ungetrennten Hofraum');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2101,'Erbbaurecht');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2102,'Untererbbaurecht');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2103,'Gebäudeeigentum');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2104,'Fischereirecht');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2105,'Bergwerksrecht');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2106,'Nutzungsrecht');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2107,'Realgewerberecht');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2108,'Gemeinderecht');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2109,'Stavenrecht');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2110,'Hauberge');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2201,'Aufgeteiltes Erbbaurecht WEG');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2202,'Aufgeteiltes Untererbbaurecht WEG');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2203,'Aufgeteiltes Recht Par. 3 Abs. 4 GBO');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2204,'Aufgeteiltes Recht, Körperschaft');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2205,'Aufgeteiltes Gebäudeeigentum');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2301,'Wohnungs-/Teilerbbaurecht');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2302,'Wohnungs-/Teiluntererbbaurecht');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2303,'Erbbaurechtsanteil Par. 3 Abs. 4 GBO');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2304,'Anteiliges Recht, Körperschaft');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2305,'Anteil am Gebäudeeigentum');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2401,'Aufgeteilter Anteil Wohnungs-/Teilerbbaurecht');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2402,'Aufgeteilter Anteil Wohnungs-/Teiluntererbbaurecht');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2403,'Aufgeteilter Erbbaurechtsanteil Par. 3 Abs. 4 GBO');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2404,'Aufgeteiltes anteiliges Recht, Körperschaft');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2405,'Aufgeteilter Anteil am Gebäudeeigentum');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2501,'Anteil am Wohnungs-/Teilerbbaurechtsanteil');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2502,'Anteil am Wohnungs-/Teiluntererbbaurechtsanteil');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2503,'Anteil am Erbbaurechtsanteil Par. 3 Abs. 4 GBO');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2504,'Anteil am anteiligen Recht, Körperschaft');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (2505,'Anteil am Anteil zum Gebäudeeigentum');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (3100,'Vermerk subjektiv dinglicher Rechte (Par. 9 GBO)');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (4100,'Stockwerkseigentum');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (5101,'Von Buchungspflicht befreit Par. 3 Abs. 2 GBO');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (5200,'Anliegerflurstück');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (5201,'Anliegerweg');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (5202,'Anliegergraben');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (5203,'Anliegerwasserlauf, Anliegergewässer');
INSERT INTO ax_buchungsstelle_buchungsart (wert, bezeichner) VALUES (6101,'Nicht gebuchtes Fischereirecht');


-- E i g e n t u e m e r a r t

-- Laut GeoInfoDok nur 3 Werte.
-- In RLP-Mustersdaten aber viele verschiedene Werte.

-- Fuer "viele Werte" wuerde sich eine Tabelle lohnen.
-- 3 Werte koennen ueber Function (case) entschluesselt werden.


-- B a u - , R a u m -  oder  B o d e n - O r d n u n g s r e c h t  -  A r t  d e r  F e s t l e g u n g
-- ------------------------------------------------------------------------------------------------------

-- Kennung = 71008,
-- Objektart = 'ax_bauraumoderbodenordnungsrecht'

-- für: Entschluesseln der Rechte im Template

CREATE TABLE ax_bauraumoderbodenordnungsrecht_artderfestlegung 
  (wert        integer, 
   bezeichner  character varying,
 --kennung     integer,   -- konstant 71008, entfernt 21.11.2011
 --objektart   character varying,  -- konstant ax_bauraumoderbodenordnungsrecht, entfernt 21.11.2011
   CONSTRAINT pk_ax_brecht_artfest_wert PRIMARY KEY (wert)
  );

COMMENT ON TABLE  ax_bauraumoderbodenordnungsrecht_artderfestlegung 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1700,'Festlegung nach Baugesetzbuch - Allgemeines Städtebaurecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1710,'Bebauungsplan');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1720,'Veränderungssperre nach Baugesetzbuch');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1730,'Vorkaufrechtssatzung');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1740,'Enteignungsverfahren');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1750,'Umlegung nach dem BauGB');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1760,'Bauland');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1770,'Vereinfachte Umlegung');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1780,'Vorhaben- und Erschließungsplan');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1790,'Flächennutzungsplan');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1800,'Festlegung nach Baugesetzbuch - Besonderes Städtebaurecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1810,'Städtebauliche Entwicklungsmaßnahme');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1811,'Städtebauliche Entwicklungsmaßnahme (Beschluss zu vorbereitenden Untersuchungen gefasst)');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1820,'Erhaltungssatzung');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1821,'Städtebauliches Erhaltungsgebiet');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1822,'Soziales Erhaltungsgebiet');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1823,'Erhaltungsgebiet zur städtebaulichen Umstrukturierung');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1824,'Soziales Erhaltungsgebiet (Aufstellungsbeschluss gefasst)');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1830,'Städtebauliche Gebote');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1840,'Sanierung');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1841,'Sanierung (Beschluss zu vorbereitenden Untersuchungen gefasst)');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (1900,'Wohnungsbauerleichterungsgesetz');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2100,'Flurbereinigungsgesetz');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2110,'Flurbereinigung (Par. 1, 37 FlurbG)');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2120,'Vereinfachtes Flurbereinigungsverfahren (Par. 86 FlurbG)');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2130,'Unternehmensflurbereinigung (nach Par. 87 oder 90 FlurbG)');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2140,'Beschleunigtes Zusammenlegungsverfahren (Par. 91 FlurbG)');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2150,'Freiwilliger Landtausch (Par. 103a FlurbG)');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2160,'Verfahren nach dem Gemeinheitsteilungsgesetz');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2170,'Verfahren nach dem Gemeinschaftswaldgesetz');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2180,'Freiwilliger Nutzungstausch');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2200,'Verfahren nach dem Landwirtschaftsanpassungsgesetz');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2210,'Flurneuordnung');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2220,'Freiwilliger Landtausch (Par. 54 LwAnpG)');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2230,'Bodenordnungsverfahren (Par. 56 LwAnpG)');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2240,'Zusammenführung von Boden- und Gebäudeeigentum (Par. 64 LwAnpG)');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2300,'Bodensonderungsgesetz');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2310,'Unvermessenes Eigentum');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2320,'Unvermessenes Nutzungsrecht');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2330,'Ergänzende Bodenneuordnung');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2340,'Komplexe Bodenneuordnung');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2400,'Vermögenszuordnungsgesetz');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2410,'Vermögenszuordnung nach Plan');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2411,'Vermögenszuordnung nach dem Aufteilungsplan');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2412,'Vermögenszuordnung nach dem Zuordnungsplan');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2500,'Landesraumordnungsgesetz');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2510,'Wasservorranggebiete');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2600,'Bauordnung');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2610,'Baulast');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2611,'Begünstigende Baulast');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2612,'Belastende Baulast');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2700,'Grenzfeststellungsverfahren nach Hamb. Wassergesetz');
INSERT INTO ax_bauraumoderbodenordnungsrecht_artderfestlegung (wert, bezeichner) VALUES (2800,'Verkehrsflächenbereinigung');


-- B o d e n s c h a e t z u n g -  K u l t u r a r t
-- --------------------------------------------------

CREATE TABLE ax_bodenschaetzung_kulturart (
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_ax_bodenschaetzung_kulturart  PRIMARY KEY (wert)
  );


COMMENT ON TABLE ax_bodenschaetzung_kulturart 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';


INSERT INTO ax_bodenschaetzung_kulturart (wert, bezeichner) VALUES (1000,'Ackerland (A)');
INSERT INTO ax_bodenschaetzung_kulturart (wert, bezeichner) VALUES (2000,'Acker-Grünland (AGr)');
INSERT INTO ax_bodenschaetzung_kulturart (wert, bezeichner) VALUES (3000,'Grünland (Gr)');
INSERT INTO ax_bodenschaetzung_kulturart (wert, bezeichner) VALUES (4000,'Grünland-Acker (GrA)');


-- B o d e n s c h a e t z u n g  -  B o d e n a r t
-- -------------------------------------------------

CREATE TABLE ax_bodenschaetzung_bodenart (
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_ax_bodenschaetzung_bodenart  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bodenschaetzung_bodenart 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (1100,'Sand (S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (2100,'Lehmiger Sand (lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (3100,'Lehm (L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (4100,'Ton (T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (5000,'Moor (Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (1200,'Anlehmiger Sand (Sl)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (2200,'Stark lehmiger Sand (SL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (3200,'Sandiger Lehm (sL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (4200,'Schwerer Lehm (LT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (6110,'Sand, Moor (SMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (6120,'Lehmiger Sand, Moor (lSMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (6130,'Lehm, Moor (LMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (6140,'Ton, Moor (TMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (6210,'Moor,Sand (MoS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (6220,'Moor, Lehmiger Sand (MolS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (6230,'Moor, Lehm (MoL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (6240,'Moor, Ton (MoT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7110,'Sand auf sandigem Lehm (S/sL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7130,'Sand auf schwerem Lehm (S/LT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7210,'Anlehmiger Sand auf Lehm (Sl/L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7220,'Anlehmiger Sand auf schwerem Lehm (Sl/LT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7230,'Anlehmiger Sand auf Ton (Sl/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7310,'Lehmiger Sand auf schwerem Lehm (lS/LT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7320,'Lehmiger Sand auf Sand (lS/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7400,'Stark lehmiger Sand auf Ton (SL/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7510,'Ton auf stark lehmigen Sand (T/SL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7530,'Ton auf anlehmigen Sand (T/Sl)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7610,'Schwerer Lehm auf lehmigen Sand (LT/lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7620,'Schwerer Lehm auf anlehmigen Sand (LT/Sl)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7630,'Schwerer Lehm auf Sand (LT/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7710,'Lehm auf anlehmigen Sand (L/Sl)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7800,'Sandiger Lehm auf Sand (sL/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7120,'Sand auf Lehm (S/L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7140,'Sand auf Ton (S/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7330,'Lehmiger Sand auf Ton (lS/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7520,'Ton auf lehmigen Sand (T/lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7540,'Ton auf Sand (T/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (7720,'Lehm auf Sand (L/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (8110,'Sand auf Moor (S/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (8120,'Lehmiger Sand auf Moor (lS/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (8130,'Lehm auf Moor (L/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (8140,'Ton auf Moor (T/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (8210,'Moor auf Sand (Mo/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (8220,'Moor auf lehmigen Sand (Mo/lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (8230,'Moor auf Lehm (Mo/L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (8240,'Moor auf Ton (Mo/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9120,'Bodenwechsel vom Lehm zu Moor (L+Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9130,'Lehmiger Sand mit starkem Steingehalt (lSg)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9140,'Lehm mit starkem Steingehalt (Lg)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9150,'lehmiger Sand mit Steinen und Blöcken (lS+St)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9160,'Lehm mit Steinen und Blöcken L+St)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9170,'Steine und Blöcke mit  lehmigem Sand (St+lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9180,'Steine und Blöcke mit  Lehm (St+L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9190,'lehmiger Sand mit Felsen (lS+Fe)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9200,'Lehm mit Felsen (L+Fe)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9210,'Felsen mit lehmigem Sand (Fe+lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9220,'Felsen mit Lehm (Fe+L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9310,'Sand auf lehmigen Sand (S/lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9320,'Anlehmiger Sand auf Mergel (Sl/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9330,'Anlehmiger Sand auf sandigem Lehm (Sl/sL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9340,'Lehmiger Sand auf Lehm (lS/L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9350,'Lehmiger Sand auf Mergel (lS/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9360,'Lehmiger Sand auf sandigem Lehm (lS/sL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9370,'Lehmiger Sand, Mergel (lSMe)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9380,'Lehmiger Sand, Moor auf Mergel (lSMo/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9390,'Anlehmiger Sand, Moor (SlMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9410,'Lehm auf Mergel (L/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9420,'Lehm, Moor auf Mergel (LMo/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9430,'Schwerer Lehm auf Moor (LT/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9440,'Ton auf Mergel (T/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9450,'Moor auf Mergel (Mo/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9460,'Moor, Lehm auf Mergel (MoL/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9470,'Moor, Mergel (MoMe)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9480,'LößDiluvium(LöD)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, bezeichner) VALUES (9490,'AlluviumDiluvium(AlD)');


-- B o d e n s c h a e t z u n g  -  Z u s t a n d s s t u f e
-- ------------------------------------------------------------

CREATE TABLE ax_bodenschaetzung_zustandsstufe (
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_ax_bodenschaetzung_zustandsstufe  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bodenschaetzung_zustandsstufe 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';


INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Zustandsstufe (1)',1100);
INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Zustandsstufe (2)',1200);
INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Zustandsstufe (3)',1300);
INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Zustandsstufe (4)',1400);
INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Zustandsstufe (5)',1500);
INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Zustandsstufe (6)',1600);
INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Zustandsstufe (7)',1700);
INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Zustandsstufe Misch- und Schichtböden sowie künstlichveränderte Böden (-)',1800);
INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Bodenstufe (I)',2100);
INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Bodenstufe (II)',2200);
INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Bodenstufe (III)',2300);
INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Bodenstufe Misch- und Schichtböden sowie künstlich veränderte Böden (-)',2400);
INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Bodenstufe (II+III)',3100);
INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Bodenstufe ("(III)")',3200);
INSERT INTO ax_bodenschaetzung_zustandsstufe (bezeichner,wert) VALUES ('Bodenstufe (IV)',3300);


-- B o d e n s c h a e t z u n g   -  Muster-, Landesmuster- und Vergleichsstueck
-- ------------------------------------------------------------------------------
CREATE TABLE ax_musterlandesmusterundvergleichsstueck_merkmal (
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_ax_musterlandesmusterundvergleichsstueck_merkmal  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_musterlandesmusterundvergleichsstueck_merkmal 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_musterlandesmusterundvergleichsstueck_merkmal (wert,bezeichner) VALUES (1000,'Musterstück (M)');
INSERT INTO ax_musterlandesmusterundvergleichsstueck_merkmal (wert,bezeichner) VALUES (2000,'Landesmusterstück (L)');
INSERT INTO ax_musterlandesmusterundvergleichsstueck_merkmal (wert,bezeichner) VALUES (3000,'Vergleichsstück (V)');


-- B o d e n s c h a e t z u n g  -  Grabloch der Bodenschaetzung
-- --------------------------------------------------------------

CREATE TABLE ax_grablochderbodenschaetzung_bedeutung (
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_ax_grablochderbodenschaetzung_bedeutung  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_grablochderbodenschaetzung_bedeutung
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';


INSERT INTO ax_grablochderbodenschaetzung_bedeutung (wert,bezeichner) VALUES (1100,'Grabloch, bestimmend, lagerichtig (innerhalb der Fläche)');
INSERT INTO ax_grablochderbodenschaetzung_bedeutung (wert,bezeichner) VALUES (1200,'Grabloch, bestimmend, lagerichtig (außerhalb des Abschnitts)');
INSERT INTO ax_grablochderbodenschaetzung_bedeutung (wert,bezeichner) VALUES (1300,'Grabloch, nicht lagerichtig, im Abschnitt nicht vorhanden');
INSERT INTO ax_grablochderbodenschaetzung_bedeutung (wert,bezeichner) VALUES (2000,'Grabloch für Muster-, Landesmuster-, Vergleichsstück');
INSERT INTO ax_grablochderbodenschaetzung_bedeutung (wert,bezeichner) VALUES (3000,'Grabloch, nicht bestimmend');


-- F o r s t r e c h t  -  A r t   d e r   F e s t l e g u n g
-- -----------------------------------------------------------

CREATE TABLE ax_forstrecht_artderfestlegung(
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_ax_forstrecht_artderfestlegung  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_forstrecht_artderfestlegung
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_forstrecht_artderfestlegung (bezeichner, wert) VALUES('Klassifizierung nach Bundes- oder Landeswaldgesetz',3900);
INSERT INTO ax_forstrecht_artderfestlegung (bezeichner, wert) VALUES('Staatswald Bund',3910);
INSERT INTO ax_forstrecht_artderfestlegung (bezeichner, wert) VALUES('Staatswald Land',3920);
INSERT INTO ax_forstrecht_artderfestlegung (bezeichner, wert) VALUES('Kommunalwald',3930);
INSERT INTO ax_forstrecht_artderfestlegung (bezeichner, wert) VALUES('Anstalts- und Stiftungswald',3940);
INSERT INTO ax_forstrecht_artderfestlegung (bezeichner, wert) VALUES('Anderer öffentlicher Wald',3950);
INSERT INTO ax_forstrecht_artderfestlegung (bezeichner, wert) VALUES('Privater Gemeinschaftswald',3960);
INSERT INTO ax_forstrecht_artderfestlegung (bezeichner, wert) VALUES('Großprivatwald',3970);
INSERT INTO ax_forstrecht_artderfestlegung (bezeichner, wert) VALUES('Kleinprivatwald',3980);
INSERT INTO ax_forstrecht_artderfestlegung (bezeichner, wert) VALUES('Anderer Privatwald',3990);


-- F o r s t r e c h t - B e s o n d e r e   F u n k t i o n
-- ---------------------------------------------------------
CREATE TABLE ax_forstrecht_besonderefunktion(
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_ax_forstrecht_besonderefunktion  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_forstrecht_besonderefunktion
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Ohne besondere gesetzliche Bindung',1000);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Ohne besondere gesetzliche Bindung nach LWaldG- Holzboden',1010);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Schutzwald',2000);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Schutzwald - Holzboden',2010);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Erholungswald',3000);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Erholungswald - Holzboden',3010);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Bannwald',4000);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Nationalpark - Holzboden',4010);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Naturschutzgebiet - Holzboden',5010);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Schutz- und Erholungswald',6000);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Schutz- und Erholungswald - Holzboden',6010);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Nationalpark - Nichtholzboden',7010);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Naturschutzgebiet - Nichtholzboden',8010);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Andere Forstbetriebsfläche',9000);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Nichtholzboden',9010);
INSERT INTO ax_forstrecht_besonderefunktion (bezeichner, wert) VALUES('Sonstiges',9999);



-- B o d e n s c h a e t z u n g   -  Entstehungsart oder Klimastufe / Wasserverhaeltnisse
-- ----------------------------------------------------------------------------------------

CREATE TABLE ax_bodenschaetzung_entstehungsartoderklimastufe(
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_ax_bodenschaetzung_entstehungsartoderklimastufe PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bodenschaetzung_entstehungsartoderklimastufe
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';


INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Diluvium (D)',1000);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Diluvium über Alluvium (DAl)',1100);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Diluvium über Löß (DLö)',1200);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Diluvium über Verwitterung (DV)',1300);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Diluvium, gesteinig (Dg)',1400);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Diluvium, gesteinig über Alluvium (DgAl)',1410);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Diluvium, gesteinig über Löß (DgLö)',1420);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Diluvium, gesteinig über Verwitterung (DgV)',1430);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Löß (Lö)',2000);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Löß über Diluvium (LöD)',2100);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Löß, Diluvium, Gesteinsböden (LöDg)',2110);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Löß, Diluvium, Verwitterung (LöDV)',2120);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Löß über Alluvium (LöAl)',2200);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Löß über Verwitterung (LöV)',2300);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Löß, Verwitterung, Gesteinsböden (LöVg)',2310);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Löß über Verwitterung, gesteinig (LöVg)',2400);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Alluvium (Al)',3000);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Alluvium über Diluvium (AlD)',3100);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Alluvium über Löß (AlLö)',3200);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Alluvium über Verwitterung (AlV)',3300);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Alluvium, gesteinig (Alg)',3400);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Alluvium, gesteinig über Diluvium (AlgD)',3410);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Alluvium, gesteinig über Löß (AlgLö)',3420);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Alluvium, gesteinig über Verwitterung (AlgV)',3430);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Alluvium, Marsch (AlMa)',3500);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Alluvium, Moor (AlMo)',3610);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Moor, Alluvium (MoAI)',3620);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Mergel (Me)',3700);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Verwitterung (V)',4000);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Verwitterung über Diluvium (VD)',4100);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Verwitterung über Alluvium (VAl)',4200);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Verwitterung über Löß (VLö)',4300);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Verwitterung, Gesteinsböden (Vg)',4400);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Verwitterung, Gesteinsböden über Diluvium (VgD)',4410);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Entstehungsart nicht erkennbar (-)',5000);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Klimastufe 8° C und darüber (a)',6100);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Klimastufe 7,9° - 7,0° C (b)',6200);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Klimastufe 6,9° - 5,7° C (c)',6300);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Klimastufe 5,6° C und darunter (d)',6400);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Wasserstufe (1)',7100);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Wasserstufe (2)',7200);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Wasserstufe (3)',7300);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Wasserstufe (4)',7400);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Wasserstufe (4-)',7410);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Wasserstufe (5)',7500);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Wasserstufe (5-)',7510);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Wasserstufe (3-)',7520);
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (bezeichner, wert) VALUES('Wasserstufe (3+4)',7530);


-- D a t e n e r h e b u n g
-- -------------------------
-- Datentyp: AX_LI_Source_MitDatenerhebung

CREATE TABLE ax_datenerhebung (
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_ax_Datenerhebung PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_datenerhebung
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus Katastervermessung ermittelt', 1000); -- (G)
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aufgrund Anforderungen mit Netzanschluss ermittelt', 1100);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aufgrund Anforderungen mit Bezug zur Flurstücksgrenze ermittelt', 1200);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus sonstiger Vermessung ermittelt', 1900);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus Luftbildmessung oder Fernerkundungsdaten ermittelt', 2000);-- 	
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus Katasterunterlagen und Karten für graphische Zwecke ermittelt', 4000);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus Katasterzahlen für graphische Zwecke ermittelt', 4100);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert', 4200);-- (G)
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab M größer gleich 1 zu 1000', 4210);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab 1 zu 1000 größer M größer gleich 1 zu 2000', 4220);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab 1 zu 2000 größer M größer gleich 1 zu 3000', 4230);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab 1 zu 3000 größer M größer gleich 1 zu 5000', 4240);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab 1 zu 5000 größer M', 4250);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert', 4300);-- (G)
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab M größer gleich 1 zu 1000', 4310);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab 1 zu 1000 größer M größer gleich 1 zu 2000', 4320);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab 1 zu 2000 größer M größer gleich 1 zu 3000', 4330);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab 1 zu 3000 größer M größer gleich 1 zu 5000', 4340);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab 1 zu 5000 größer M', 4350);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, mit sonstigen geometrischen Bedingungen und bzw. oder Homogenisierung (M größer gleich 1 zu 1000)', 4360);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, mit Berechnung oder Abstandsbedingung (M größer gleich 1 zu 1000)', 4370);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, mit sonstigen geometrischen Bedingungen und bzw. oder Homogenisierung (M kleiner 1 zu 1000)', 4380);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, mit Berechnung oder Abstandsbedingungen (M kleiner 1 zu 1000)', 4390);
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Nach Quellenlage nicht zu spezifizieren', 9998);--  (G)
INSERT INTO ax_datenerhebung (bezeichner, wert) VALUES('Sonstiges', 9999);


-- Sonstiges Bauwerk oder sonstige Einrichtung
-- -------------------------
-- Datentyp: ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion
CREATE TABLE ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion(
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';


INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Überdachung',1610);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Carport',1611);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Treppe',1620);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Freitreppe',1621);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Rolltreppe',1622);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Treppenunterkante',1630);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Kellereingang',1640);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Rampe',1650);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Terrasse',1670);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Mauer',1700);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Mauerkante, rechts',1701);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Mauerkante, links',1702);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Mauermitte',1703);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Stützmauer',1720);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Stützmauer, rechts',1721);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Stützmauer, links',1722);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Stützmauermitte',1723);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Zaun',1740);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Denkmal, Denkstein, Standbild',1750);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Bildstock, Wegekreuz, Gipfelkreuz',1760);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Bildstock',1761);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Wegekreuz',1762);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Gipfelkreuz',1763);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Meilenstein, historischer Grenzstein',1770);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Brunnen',1780);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Brunnen (Trinkwasserversorgung)',1781);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Springbrunnen, Zierbrunnen',1782);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Ziehbrunnen',1783);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Spundwand',1790);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Höckerlinie',1791);
INSERT INTO ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion (bezeichner, wert) VALUES ('Sonstiges',9999);

-- ax_bauteil_bauart
-- -------------------------
-- Datentyp:
CREATE TABLE ax_bauteil_bauart (
wert integer, 
bezeichner character varying,  
kennung integer, objektart character varying);

COMMENT ON TABLE ax_bauteil_bauart
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (1100,'Geringergeschossiger Gebäudeteil',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (1200,'Höhergeschossiger Gebäudeteil (nicht Hochhaus)',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (1300,'Hochhausgebäudeteil',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (1400,'Abweichende Geschosshöhe',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2000,'Keller',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2100,'Tiefgarage',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2300,'Loggia',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2350,'Wintergarten',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2400,'Arkade',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2500,'Auskragende/zurückspringende Geschosse',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2510,'Auskragende Geschosse',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2520,'Zurückspringende Geschosse',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2610,'Durchfahrt im Gebäude',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2620,'Durchfahrt an überbauter Verkehrsstraße',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2710,'Schornstein im Gebäude',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2720,'Turm im Gebäude',31002,'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (9999,'Sonstiges',31002,'ax_bauteil');



-- ENDE --
