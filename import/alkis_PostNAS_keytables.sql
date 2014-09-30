
-- ALKIS-Datenbank aus dem Konverter PostNAS

-- Z u s a e t z l i c h e   S c h l u e s s e l t a b e l l e n

-- Dieses Script fuegt der Datenbank einige Schluesseltabellen hinzu, die der 
-- Konverter PostNAS NICHT aufbaut, weil sie nicht in den NAS-Daten enthalten sind.
-- Die Schluessel sind der Dokumentation zu entnehmen.

-- Die Tabellen werden vom Buchwerk-Auskunftsprogramm benoetigt.

-- Dies Script kann nach dem Anlegen der Datenbank mit dem Script 'alkis_PostNAS_schema.sql' verarbeitet werden.

-- Version
--  2014-09-30  F.J. Umbenennung Schlüsseltabellen (Prefix) von "ax_*" nach "v_*"
--                   Der Prefix "ax_" sollte Objekt-Tabellen des ALKIS-Namenschemas vorbehalten sein.
--                   Vorgehen bei Umstellung: neue Tabellen anlegen, Programme und Views umstellen, alte Tab. löschen

  SET client_encoding = 'UTF8';

-- G e b ä u d e - B a u w e i s e
-- -------------------------------
-- Wird z.B. benoetigt in Buchauskunft, Modul 'alkisgebaeudenw.php'
-- Nicht im Grunddatenbestand NRW 
-- Siehe http://www.kreis-euskirchen.de/service/downloads/geoinformation/Kreis_EU_Gebaeudeerfassung.pdf
-- alter Name: ax_gebaeude_bauweise
DROP TABLE v_geb_bauweise;
CREATE TABLE v_geb_bauweise (
    bauweise_id            integer, 
    bauweise_beschreibung  character varying,
    CONSTRAINT pk_v_geb_bauweise PRIMARY KEY (bauweise_id)
  );

COMMENT ON TABLE v_geb_bauweise 
 IS 'Gebäude, Spalte: Bauweise - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_gebaeude", Feld "bauweise".';

COMMENT ON COLUMN v_geb_bauweise.bauweise_id           IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_geb_bauweise.bauweise_beschreibung IS 'Bezeichnung, Bedeutung';

INSERT INTO v_geb_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1100,'Freistehendes Einzelgebäude');
INSERT INTO v_geb_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1200,'Freistehender Gebäudeblock');
INSERT INTO v_geb_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1300,'Einzelgarage');
INSERT INTO v_geb_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1400,'Doppelgarage');
INSERT INTO v_geb_bauweise (bauweise_id, bauweise_beschreibung) VALUES (1500,'Sammelgarage');
INSERT INTO v_geb_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2100,'Doppelhaushälfte');
INSERT INTO v_geb_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2200,'Reihenhaus');
INSERT INTO v_geb_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2300,'Haus in Reihe');
INSERT INTO v_geb_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2400,'Gruppenhaus');
INSERT INTO v_geb_bauweise (bauweise_id, bauweise_beschreibung) VALUES (2500,'Gebäudeblock in geschlossener Bauweise');
INSERT INTO v_geb_bauweise (bauweise_id, bauweise_beschreibung) VALUES (4000,'Offene Halle');


-- G e b a e u d e - F u n k t i o n
-- ---------------------------------
-- Objektart = 'ax_gebaeude'
-- alter Name: ax_gebaeude_funktion
DROP TABLE v_geb_funktion; 
CREATE TABLE v_geb_funktion (
    wert        integer, 
    bezeichner  character varying,
    CONSTRAINT pk_v_geb_funktion_w PRIMARY KEY (wert)
   );

COMMENT ON TABLE  v_geb_funktion 
 IS 'Gebäude, Spalte: Funktion - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_gebaeude", Feld "funktion".';

COMMENT ON COLUMN v_geb_funktion.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_geb_funktion.bezeichner IS 'Bezeichnung, Bedeutung';

INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1000,'Wohngebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1010,'Wohnhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1020,'Wohnheim');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1021,'Kinderheim');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1022,'Seniorenheim');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1023,'Schwesternwohnheim');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1024,'Studenten-, Schülerwohnheim');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1025,'Schullandheim');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1100,'Gemischt genutztes Gebäude mit Wohnen');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1110,'Wohngebäude mit Gemeinbedarf');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1120,'Wohngebäude mit Handel und Dienstleistungen');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1121,'Wohn- und Verwaltungsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1122,'Wohn- und Bürogebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1123,'Wohn- und Geschäftsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1130,'Wohngebäude mit Gewerbe und Industrie');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1131,'Wohn- und Betriebsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1210,'Land- und forstwirtschaftliches Wohngebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1220,'Land- und forstwirtschaftliches Wohn- und Betriebsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1221,'Bauernhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1222,'Wohn- und Wirtschaftsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1223,'Forsthaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1310,'Gebäude zur Freizeitgestaltung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1311,'Ferienhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1312,'Wochenendhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (1313,'Gartenhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2000,'Gebäude für Wirtschaft oder Gewerbe');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2010,'Gebäude für Handel und Dienstleistungen');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2020,'Bürogebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2030,'Kreditinstitut');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2040,'Versicherung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2050,'Geschäftsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2051,'Kaufhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2052,'Einkaufszentrum');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2053,'Markthalle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2054,'Laden');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2055,'Kiosk');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2056,'Apotheke');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2060,'Messehalle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2070,'Gebäude für Beherbergung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2071,'Hotel, Motel, Pension');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2072,'Jugendherberge');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2073,'Hütte (mit Übernachtungsmöglichkeit)');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2074,'Campingplatzgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2080,'Gebäude für Bewirtung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2081,'Gaststätte, Restaurant');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2082,'Hütte (ohne Übernachtungsmöglichkeit)');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2083,'Kantine');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2090,'Freizeit- und Vergnügungsstätte');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2091,'Festsaal');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2092,'Kino');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2093,'Kegel-, Bowlinghalle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2094,'Spielkasino');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2100,'Gebäude für Gewerbe und Industrie');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2110,'Produktionsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2111,'Fabrik');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2112,'Betriebsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2113,'Brauerei');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2114,'Brennerei');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2120,'Werkstatt');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2121,'Sägewerk');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2130,'Tankstelle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2131,'Waschstraße, Waschanlage, Waschhalle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2140,'Gebäude für Vorratshaltung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2141,'Kühlhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2142,'Speichergebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2143,'Lagerhalle, Lagerschuppen, Lagerhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2150,'Speditionsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2160,'Gebäude für Forschungszwecke');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2170,'Gebäude für Grundstoffgewinnung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2171,'Bergwerk');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2172,'Saline');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2180,'Gebäude für betriebliche Sozialeinrichtung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2200,'Sonstiges Gebäude für Gewerbe und Industrie');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2210,'Mühle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2211,'Windmühle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2212,'Wassermühle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2213,'Schöpfwerk');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2220,'Wetterstation');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2310,'Gebäude für Handel und Dienstleistung mit Wohnen');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2320,'Gebäude für Gewerbe und Industrie mit Wohnen');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2400,'Betriebsgebäude zu Verkehrsanlagen (allgemein)');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2410,'Betriebsgebäude für Straßenverkehr');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2411,'Straßenmeisterei');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2412,'Wartehalle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2420,'Betriebsgebäude für Schienenverkehr');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2421,'Bahnwärterhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2422,'Lokschuppen, Wagenhalle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2423,'Stellwerk, Blockstelle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2424,'Betriebsgebäude des Güterbahnhofs');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2430,'Betriebsgebäude für Flugverkehr');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2431,'Flugzeughalle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2440,'Betriebsgebäude für Schiffsverkehr');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2441,'Werft (Halle)');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2442,'Dock (Halle)');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2443,'Betriebsgebäude zur Schleuse');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2444,'Bootshaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2450,'Betriebsgebäude zur Seilbahn');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2451,'Spannwerk zur Drahtseilbahn');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2460,'Gebäude zum Parken');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2461,'Parkhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2462,'Parkdeck');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2463,'Garage');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2464,'Fahrzeughalle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2465,'Tiefgarage');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2500,'Gebäude zur Versorgung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2501,'Gebäude zur Energieversorgung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2510,'Gebäude zur Wasserversorgung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2511,'Wasserwerk');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2512,'Pumpstation');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2513,'Wasserbehälter');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2520,'Gebäude zur Elektrizitätsversorgung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2521,'Elektrizitätswerk');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2522,'Umspannwerk');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2523,'Umformer');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2527,'Reaktorgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2528,'Turbinenhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2529,'Kesselhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2540,'Gebäude für Fernmeldewesen');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2560,'Gebäude an unterirdischen Leitungen');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2570,'Gebäude zur Gasversorgung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2571,'Gaswerk');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2580,'Heizwerk');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2590,'Gebäude zur Versorgungsanlage');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2591,'Pumpwerk (nicht für Wasserversorgung)');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2600,'Gebäude zur Entsorgung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2610,'Gebäude zur Abwasserbeseitigung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2611,'Gebäude der Kläranlage');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2612,'Toilette');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2620,'Gebäude zur Abfallbehandlung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2621,'Müllbunker');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2622,'Gebäude zur Müllverbrennung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2623,'Gebäude der Abfalldeponie');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2700,'Gebäude für Land- und Forstwirtschaft');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2720,'Land- und forstwirtschaftliches Betriebsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2721,'Scheune');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2723,'Schuppen');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2724,'Stall');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2726,'Scheune und Stall');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2727,'Stall für Tiergroßhaltung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2728,'Reithalle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2729,'Wirtschaftsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2732,'Almhütte');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2735,'Jagdhaus, Jagdhütte');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2740,'Treibhaus, Gewächshaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2741,'Treibhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (2742,'Gewächshaus, verschiebbar');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3000,'Gebäude für öffentliche Zwecke');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3010,'Verwaltungsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3011,'Parlament');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3012,'Rathaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3013,'Post');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3014,'Zollamt');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3015,'Gericht');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3016,'Botschaft, Konsulat');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3017,'Kreisverwaltung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3018,'Bezirksregierung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3019,'Finanzamt');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3020,'Gebäude für Bildung und Forschung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3021,'Allgemein bildende Schule');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3022,'Berufsbildende Schule');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3023,'Hochschulgebäude (Fachhochschule, Universität)');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3024,'Forschungsinstitut');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3030,'Gebäude für kulturelle Zwecke');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3031,'Schloss');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3032,'Theater, Oper');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3033,'Konzertgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3034,'Museum');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3035,'Rundfunk, Fernsehen');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3036,'Veranstaltungsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3037,'Bibliothek, Bücherei');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3038,'Burg, Festung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3040,'Gebäude für religiöse Zwecke');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3041,'Kirche');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3042,'Synagoge');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3043,'Kapelle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3044,'Gemeindehaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3045,'Gotteshaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3046,'Moschee');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3047,'Tempel');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3048,'Kloster');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3050,'Gebäude für Gesundheitswesen');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3051,'Krankenhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3052,'Heilanstalt, Pflegeanstalt, Pflegestation');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3053,'Ärztehaus, Poliklinik');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3060,'Gebäude für soziale Zwecke');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3061,'Jugendfreizeitheim');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3062,'Freizeit-, Vereinsheim, Dorfgemeinschafts-, Bürgerhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3063,'Seniorenfreizeitstätte');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3064,'Obdachlosenheim');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3065,'Kinderkrippe, Kindergarten, Kindertagesstätte');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3066,'Asylbewerberheim');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3070,'Gebäude für Sicherheit und Ordnung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3071,'Polizei');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3072,'Feuerwehr');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3073,'Kaserne');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3074,'Schutzbunker');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3075,'Justizvollzugsanstalt');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3080,'Friedhofsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3081,'Trauerhalle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3082,'Krematorium');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3090,'Empfangsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3091,'Bahnhofsgebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3092,'Flughafengebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3094,'Gebäude zum U-Bahnhof');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3095,'Gebäude zum S-Bahnhof');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3097,'Gebäude zum Busbahnhof');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3098,'Empfangsgebäude Schifffahrt');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3100,'Gebäude für öffentliche Zwecke mit Wohnen');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3200,'Gebäude für Erholungszwecke');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3210,'Gebäude für Sportzwecke');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3211,'Sport-, Turnhalle');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3212,'Gebäude zum Sportplatz');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3220,'Badegebäude');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3221,'Hallenbad');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3222,'Gebäude im Freibad');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3230,'Gebäude im Stadion');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3240,'Gebäude für Kurbetrieb');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3241,'Badegebäude für medizinische Zwecke');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3242,'Sanatorium');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3260,'Gebäude im Zoo');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3261,'Empfangsgebäude des Zoos');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3262,'Aquarium, Terrarium, Voliere');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3263,'Tierschauhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3264,'Stall im Zoo');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3270,'Gebäude im botanischen Garten');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3271,'Empfangsgebäude des botanischen Gartens');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3272,'Gewächshaus (Botanik)');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3273,'Pflanzenschauhaus');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3280,'Gebäude für andere Erholungseinrichtung');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3281,'Schutzhütte');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (3290,'Touristisches Informationszentrum');
INSERT INTO v_geb_funktion (wert, bezeichner) VALUES (9998,'Nach Quellenlage nicht zu spezifizieren');


-- W e i t e r e   G e b a e u d e - F u n k t i o n
-- -------------------------------------------------
-- alter Name: ax_gebaeude_weiterefunktion
DROP TABLE v_geb_weiterefkt;
CREATE TABLE v_geb_weiterefkt (
    wert        integer,
    bezeichner  character varying,
    erklaer     character varying,
    CONSTRAINT pk_v_geb_weitfkt_w PRIMARY KEY (wert)
   );

COMMENT ON TABLE  v_geb_weiterefkt 
 IS 'Gebäude, Spalte: Weitere Funktion - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_gebaeude", Feld "weiterefunktion".';

COMMENT ON COLUMN v_geb_weiterefkt.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_geb_weiterefkt.bezeichner IS 'Lange Bezeichnung';
COMMENT ON COLUMN v_geb_weiterefkt.erklaer    IS 'ALKIS erklärt uns die Welt';

INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1000, 'Bankfiliale',    '"Bankfiliale" ist eine Einrichtung in der Geldgeschäfte getätigt werden.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1010, 'Hotel',          '"Hotel" ist ein Beherbergungs- und/oder Verpflegungsbetrieb.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1020, 'Jugendherberge', '"Jugendherberge" ist eine zur Förderung von Jugendreisen dienende Aufenthalts- und Übernachtungsstätte.');	
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1030, 'Gaststätte',     '"Gaststätte" ist eine Einrichtung, in der gegen Entgelt Mahlzeiten und Getränke zum sofortigen Verzehr angeboten werden.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1040, 'Kino',           '"Kino" ist eine Einrichtung, in der alle Arten von Filmen bzw. Lichtspielen für ein Publikum abgespielt werden.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1050, 'Spielkasino',    '"Spielkasino" ist eine Einrichtung, in der öffentlich zugänglich staatlich konzessioniertes Glücksspiel betrieben wird.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1060, 'Tiefgarage',     '"Tiefgarage" ist ein Bauwerk unterhalb der Erdoberfläche, in dem Fahrzeuge abgestellt werden.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1070, 'Parkdeck',       '"Parkdeck" ist eine Fläche auf einem Gebäude, auf der Fahrzeuge abgestellt werden.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1080, 'Toilette',       '"Toilette" ist eine Einrichtung mit sanitären Vorrichtungen zum Verrichtung der Notdurft.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1090, 'Post',           '"Post" ist eine Einrichtung, von der aus Briefe, Pakete befördert und weitere Dienstleistungen angeboten werden.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1100, 'Zoll',           '"Zoll" ist eine Einrichtung der Zollabfertigung.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1110, 'Theater',        '"Theater" ist eine Einrichtung, in der Bühnenstücke aufgeführt werden.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1120, 'Museum',         '"Museum" ist eine Einrichtung in der Sammlungen von (historischen) Objekten oder Reproduktionen davon ausgestellt werden.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1130, 'Bibliothek',     '"Bibliothek" ist eine Einrichtung, in der Bücher und Zeitschriften gesammelt, aufbewahrt und ausgeliehen werden.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1140, 'Kapelle',        '"Kapelle" ist eine Einrichtung für (christliche) gottesdienstliche Zwecke.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1150, 'Moschee',        '"Moschee" ist ein Einrichtung, in der sich Muslime zu Gottesdiensten versammeln oder zu anderen Zwecken treffen.');	
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1160, 'Tempel',         '');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1170, 'Apotheke',       '"Apotheke" ist ein Geschäft, in dem Arzneimittel hergestellt und verkauft werden.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1180, 'Polizeiwache',   '"Polizeiwache" ist eine Dienststelle der Polizei.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1190, 'Rettungsstelle', '"Rettungsstelle" ist eine Einrichtung zur Aufnahme, Erstbehandlung und gezielten Weiterverlegung von Patienten mit Erkrankungen und Unfällen aller Art.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1200, 'Touristisches Informationszentrum', '"Touristisches Informationszentrum" ist eine Auskunftsstelle für Touristen.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1210, 'Kindergarten',    '"Kindergarten" ist eine Einrichtung, in der Kinder im Vorschulalter betreut werden.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1220, 'Arztpraxis',      '"Arztpraxis" ist die Arbeitsstätte eines Arztes.');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1230, 'Supermarkt',      '');
INSERT INTO v_geb_weiterefkt (wert, bezeichner, erklaer) VALUES (1240, 'Geschäft',        '');


-- G e b ä u d e   D a c h f o r m
-- -------------------------------
-- alter Name: ax_gebaeude_dachform
DROP TABLE v_geb_dachform;
CREATE TABLE v_geb_dachform 
   (wert        integer, 
    bezeichner  character varying,
    CONSTRAINT pk_v_geb_dach_w PRIMARY KEY (wert)
   );

COMMENT ON TABLE  v_geb_dachform 
 IS 'Gebäude, Spalte: Dachform - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_gebaeude", Feld "dachform".';

COMMENT ON COLUMN v_geb_dachform.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_geb_dachform.bezeichner IS 'Lange Bezeichnung';

INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (1000, 'Flachdach');
INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (2100, 'Pultdach');
INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (2200, 'Versetztes Pultdach');
INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (3100, 'Satteldach');
INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (3200, 'Walmdach');
INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (3300, 'Krüppelwalmdach');
INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (3400, 'Mansardendach');
INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (3500, 'Zeltdach');
INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (3600, 'Kegeldach');
INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (3700, 'Kuppeldach');
INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (3800, 'Sheddach');
INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (3900, 'Bogendach');
INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (4000, 'Turmdach');
INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (5000, 'Mischform');
INSERT INTO v_geb_dachform (wert, bezeichner) VALUES (9999, 'Sonstiges');


-- G e b ä u d e   Z u s t a n d
-- -----------------------------
-- alter Name: ax_gebaeude_zustand
DROP TABLE v_geb_zustand; 
CREATE TABLE v_geb_zustand 
   (wert        integer, 
    bezeichner  character varying,
    erklaer     character varying,
    CONSTRAINT pk_v_geb_zustand_w PRIMARY KEY (wert)
   );

COMMENT ON TABLE  v_geb_zustand 
 IS 'Gebäude, Spalte: Zustand - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "___", Feld "___".';

COMMENT ON COLUMN v_geb_zustand.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_geb_zustand.erklaer    IS 'ggf. zusätzliche Erklärung';
COMMENT ON COLUMN v_geb_zustand.bezeichner IS 'Lange Bezeichnung';

INSERT INTO v_geb_zustand (wert, bezeichner) VALUES (1000, 'In behelfsmäßigem Zustand');
INSERT INTO v_geb_zustand (wert, bezeichner) VALUES (2000, 'In ungenutztem Zustand');
INSERT INTO v_geb_zustand (wert, bezeichner, erklaer) VALUES (2100, 'Außer Betrieb, stillgelegt, verlassen', '"Außer Betrieb, stillgelegt, verlassen" bedeutet, dass das Gebäude auf Dauer nicht mehr bewohnt oder genutzt wird');
INSERT INTO v_geb_zustand (wert, bezeichner, erklaer) VALUES (2200, 'Verfallen, zerstört', '"Verfallen, zerstört" bedeutet, dass sich der ursprüngliche Zustand des Gebäudes durch menschliche oder zeitliche Einwirkungen so verändert hat, dass eine Nutzung nicht mehr möglich ist.');
INSERT INTO v_geb_zustand (wert, bezeichner) VALUES (2300, 'Teilweise zerstört');
INSERT INTO v_geb_zustand (wert, bezeichner) VALUES (3000, 'Geplant und beantragt');
INSERT INTO v_geb_zustand (wert, bezeichner) VALUES (4000, 'Im Bau');


-- LageZurErdoberflaeche
-- ---------------------
-- nur 2 Werte:
-- 1200, Unter der Erdoberfläche
--	    "Unter der Erdoberfläche" bedeutet, dass sich das Gebäude unter der Erdoberfläche befindet.
-- 1400, Aufgeständert
--	    "Aufgeständert" bedeutet, dass ein Gebäude auf Stützen steht.


-- Dachgeschossausbau
-- ------------------
-- nur 4 Werte:
-- 1000 Nicht ausbaufähig
-- 2000 Ausbaufähig
-- 3000 Ausgebaut
-- 4000 Ausbaufähigkeit unklar


-- B u c h u n g s t s t e l l e  -  B u c h u n g s a r t
-- -------------------------------------------------------
-- Objektart = 'ax_buchungsstelle'
-- alter Name: ax_buchungsstelle_buchungsart
DROP TABLE v_bs_buchungsart; 
CREATE TABLE v_bs_buchungsart (
   wert integer,
   bezeichner character varying,
   CONSTRAINT pk_v_bsba_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE  v_bs_buchungsart 
 IS 'Buchungsstelle (Grundstück), Spalte: Buchungsart - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_buchungsstelle", Feld "buchungsart".';

COMMENT ON COLUMN v_bs_buchungsart.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_bs_buchungsart.bezeichner IS 'Lange Bezeichnung';

-- 51 Werte
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (1100,'Grundstück');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (1101,'Aufgeteiltes Grundstück WEG');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (1102,'Aufgeteiltes Grundstück Par. 3 Abs. 4 GBO');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (1200,'Ungetrennter Hofraum');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (1301,'Wohnungs-/Teileigentum');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (1302,'Miteigentum Par. 3 Abs. 4 GBO');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (1303,'Anteil am ungetrennten Hofraum');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (1401,'Aufgeteilter Anteil Wohnungs-/Teileigentum');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (1402,'Aufgeteilter Anteil Miteigentum Par. 3 Abs. 4 GBO');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (1403,'Aufgeteilter Anteil am ungetrennten Hofraum');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (1501,'Anteil an Wohnungs-/Teileigentumsanteil');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (1502,'Anteil an Miteigentumsanteil Par. 3 Abs. 4 GBO');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (1503,'Anteil am Anteil zum ungetrennten Hofraum');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2101,'Erbbaurecht');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2102,'Untererbbaurecht');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2103,'Gebäudeeigentum');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2104,'Fischereirecht');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2105,'Bergwerksrecht');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2106,'Nutzungsrecht');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2107,'Realgewerberecht');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2108,'Gemeinderecht');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2109,'Stavenrecht');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2110,'Hauberge');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2201,'Aufgeteiltes Erbbaurecht WEG');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2202,'Aufgeteiltes Untererbbaurecht WEG');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2203,'Aufgeteiltes Recht Par. 3 Abs. 4 GBO');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2204,'Aufgeteiltes Recht, Körperschaft');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2205,'Aufgeteiltes Gebäudeeigentum');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2301,'Wohnungs-/Teilerbbaurecht');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2302,'Wohnungs-/Teiluntererbbaurecht');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2303,'Erbbaurechtsanteil Par. 3 Abs. 4 GBO');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2304,'Anteiliges Recht, Körperschaft');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2305,'Anteil am Gebäudeeigentum');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2401,'Aufgeteilter Anteil Wohnungs-/Teilerbbaurecht');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2402,'Aufgeteilter Anteil Wohnungs-/Teiluntererbbaurecht');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2403,'Aufgeteilter Erbbaurechtsanteil Par. 3 Abs. 4 GBO');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2404,'Aufgeteiltes anteiliges Recht, Körperschaft');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2405,'Aufgeteilter Anteil am Gebäudeeigentum');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2501,'Anteil am Wohnungs-/Teilerbbaurechtsanteil');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2502,'Anteil am Wohnungs-/Teiluntererbbaurechtsanteil');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2503,'Anteil am Erbbaurechtsanteil Par. 3 Abs. 4 GBO');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2504,'Anteil am anteiligen Recht, Körperschaft');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (2505,'Anteil am Anteil zum Gebäudeeigentum');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (3100,'Vermerk subjektiv dinglicher Rechte (Par. 9 GBO)');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (4100,'Stockwerkseigentum');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (5101,'Von Buchungspflicht befreit Par. 3 Abs. 2 GBO');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (5200,'Anliegerflurstück');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (5201,'Anliegerweg');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (5202,'Anliegergraben');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (5203,'Anliegerwasserlauf, Anliegergewässer');
INSERT INTO v_bs_buchungsart (wert, bezeichner) VALUES (6101,'Nicht gebuchtes Fischereirecht');


-- N a m e n s n u m m e r  -  E i g e n t u e m e r a r t
-- -------------------------------------------------------
-- Objektart = 'AX_Namensnummer'
-- alter Name: ax_namensnummer_eigentuemerart
DROP TABLE v_namnum_eigart; 
CREATE TABLE v_namnum_eigart (
   wert integer,
   bezeichner character varying,
   CONSTRAINT pk_v_nnea_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE  v_namnum_eigart 
 IS 'Namensnummer, Spalte: Eigentümerart - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_namensnummer", Feld "eigentuemerart".';

COMMENT ON COLUMN v_namnum_eigart.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_namnum_eigart.bezeichner IS 'Lange Bezeichnung';

INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (1000,'Natürliche Personen');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (1100,'Natürliche Person - Alleineigentum oder Ehepartner');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (1200,'Natürliche Person - Wohnsitz im Land');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (1300,'Natürliche Person - Wohnsitz außerhalb des Landes');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (1500,'Natürliche Person - Gemeinschaftseigentum');

INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (2000,'Juristische Personen');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (2100,'Gemeinnützige Bau-, Wohnungs- oder Siedlungsgesellschaft oder -genossenschaft einschließlich Heimstätte');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (2200,'Sonstige gemeinnützige Institution (Träger von Krankenhäusern, Altenheimen usw.) ');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (2300,'Privates Wohnungsunternehmen, private Baugesellschaft u.ä.');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (2400,'Kreditinstitut');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (2500,'Versicherungsunternehmen');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (2900,'Andere Unternehmen, Gesellschaften usw.');

INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (3000,'Körperschaften');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (3100,'Stiftung');

INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (4000,'Kirchliches Eigentum');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (4100,'Evangelische Kirche');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (4200,'Katholische Kirche ');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (4900,'Andere Kirchen, Religionsgemeinschaften usw.');

INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5100,'Bundesrepublik Deutschland');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5101,'Bundesrepublik Deutschland, Bundesstraßenverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5102,'Bundesrepublik Deutschland, Bundeswehrverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5103,'Bundesrepublik Deutschland, Forstverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5104,'Bundesrepublik Deutschland, Finanzverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5105,'Bundesrepublik Deutschland, Zivilschutz');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5106,'Bundesrepublik Deutschland, Wasserstraßenverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5107,'Bundesrepublik Deutschland, Bundeseisenbahnvermögen');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5210,'Eigentum des Volkes nach DDR-Recht');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5220,'Eigentum der Genossenschaften und deren Einrichtungen');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5230,'Eigentum der gesellschaftlichen Organisationen und deren Einrichtungen ');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5240,'Kommunale Gebietskörperschaften nach DDR-Recht');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5300,'Ausländischer Staat');

INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5400,'Kreis');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5500,'Gemeinde');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5600,'Kommunale Gebietskörperschaften ');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5700,'Andere Gebietskörperschaften, Regionalverbände usw.');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5800,'Zweckverbände, Kommunale Betriebe');

INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5920,'Eigenes Bundesland');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5921,'Eigenes Bundesland, Denkmalpflege');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5922,'Eigenes Bundesland, Domänenverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5923,'Eigenes Bundesland, Eichverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5924,'Eigenes Bundesland, Finanzverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5925,'Eigenes Bundesland, Forstverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5926,'Eigenes Bundesland, Gesundheitswesen');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5927,'Eigenes Bundesland, Polizeiverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5928,'Eigenes Bundesland, innere Verwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5929,'Eigenes Bundesland, Justizverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5930,'Eigenes Bundesland, Kultusverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5931,'Eigenes Bundesland, Landespflanzenschutzverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5932,'Eigenes Bundesland, Arbeitsverwaltung ');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5933,'Eigenes Bundesland, Sozialwesen');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5934,'Eigenes Bundesland, Landesbetrieb Straßen und Verkehr');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5935,'Eigenes Bundesland, Umweltverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5936,'Eigenes Bundesland, Vermessungs- und Katasterverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5937,'Eigenes Bundesland, Wasserwirtschaftsverwaltung ');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5938,'Eigenes Bundesland, Wirtschaftsverwaltung');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (5939,'Eigenes Bundesland, Liegenschafts- und Baubetreuung (LBB)');

INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6000,'Anderes Bundesland (allg.)');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6001,'Schleswig-Holstein');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6002,'Hamburg');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6003,'Niedersachsen');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6004,'Bremen');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6005,'Nordrhein-Westfalen');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6006,'Hessen');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6007,'Rheinland-Pfalz');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6008,'Baden-Württemberg');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6009,'Bayern');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6010,'Saarland');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6012,'Brandenburg');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6011,'Berlin');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6013,'Mecklenburg-Vorpommern');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6014,'Sachsen');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6015,'Sachsen-Anhalt');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (6016,'Thüringen');

INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (7100,'Deutsche Bahn AG');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (8000,'Herrenlos');
INSERT INTO v_namnum_eigart (wert, bezeichner) VALUES (9000,'Eigentümer unbekannt');

-- In der Praxis kommt vor:
--   SELECT DISTINCT eigentuemerart FROM ax_namensnummer ORDER BY eigentuemerart;


-- B a u - , R a u m -  oder  B o d e n - O r d n u n g s r e c h t  -  A r t  d e r  F e s t l e g u n g
-- ------------------------------------------------------------------------------------------------------
-- Objektart = 'ax_bauraumoderbodenordnungsrecht'
-- alter Name: ax_bauraumoderbodenordnungsrecht_artderfestlegung
DROP TABLE v_baurecht_adf; 
CREATE TABLE v_baurecht_adf (
	wert        integer, 
	bezeichner  character varying,
	CONSTRAINT pk_v_brecht_artfest_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE  v_baurecht_adf 
IS 'Bau-, Raum- oder Bodenordnungsrecht, Spalte: Art der Festlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bauraumoderbodenordnungsrecht", Feld "artderfestlegung".';

COMMENT ON COLUMN v_baurecht_adf.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_baurecht_adf.bezeichner IS 'Lange Bezeichnung';

INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1700,'Festlegung nach Baugesetzbuch - Allgemeines Städtebaurecht');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1710,'Bebauungsplan');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1720,'Veränderungssperre nach Baugesetzbuch');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1730,'Vorkaufrechtssatzung');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1740,'Enteignungsverfahren');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1750,'Umlegung nach dem BauGB');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1760,'Bauland');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1770,'Vereinfachte Umlegung');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1780,'Vorhaben- und Erschließungsplan');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1790,'Flächennutzungsplan');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1800,'Festlegung nach Baugesetzbuch - Besonderes Städtebaurecht');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1810,'Städtebauliche Entwicklungsmaßnahme');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1811,'Städtebauliche Entwicklungsmaßnahme (Beschluss zu vorbereitenden Untersuchungen gefasst)');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1820,'Erhaltungssatzung');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1821,'Städtebauliches Erhaltungsgebiet');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1822,'Soziales Erhaltungsgebiet');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1823,'Erhaltungsgebiet zur städtebaulichen Umstrukturierung');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1824,'Soziales Erhaltungsgebiet (Aufstellungsbeschluss gefasst)');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1830,'Städtebauliche Gebote');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1840,'Sanierung');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1841,'Sanierung (Beschluss zu vorbereitenden Untersuchungen gefasst)');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (1900,'Wohnungsbauerleichterungsgesetz');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2100,'Flurbereinigungsgesetz');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2110,'Flurbereinigung (Par. 1, 37 FlurbG)');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2120,'Vereinfachtes Flurbereinigungsverfahren (Par. 86 FlurbG)');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2130,'Unternehmensflurbereinigung (nach Par. 87 oder 90 FlurbG)');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2140,'Beschleunigtes Zusammenlegungsverfahren (Par. 91 FlurbG)');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2150,'Freiwilliger Landtausch (Par. 103a FlurbG)');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2160,'Verfahren nach dem Gemeinheitsteilungsgesetz');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2170,'Verfahren nach dem Gemeinschaftswaldgesetz');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2180,'Freiwilliger Nutzungstausch');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2200,'Verfahren nach dem Landwirtschaftsanpassungsgesetz');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2210,'Flurneuordnung');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2220,'Freiwilliger Landtausch (Par. 54 LwAnpG)');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2230,'Bodenordnungsverfahren (Par. 56 LwAnpG)');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2240,'Zusammenführung von Boden- und Gebäudeeigentum (Par. 64 LwAnpG)');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2300,'Bodensonderungsgesetz');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2310,'Unvermessenes Eigentum');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2320,'Unvermessenes Nutzungsrecht');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2330,'Ergänzende Bodenneuordnung');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2340,'Komplexe Bodenneuordnung');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2400,'Vermögenszuordnungsgesetz');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2410,'Vermögenszuordnung nach Plan');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2411,'Vermögenszuordnung nach dem Aufteilungsplan');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2412,'Vermögenszuordnung nach dem Zuordnungsplan');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2500,'Landesraumordnungsgesetz');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2510,'Wasservorranggebiete');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2600,'Bauordnung');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2610,'Baulast');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2611,'Begünstigende Baulast');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2612,'Belastende Baulast');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2700,'Grenzfeststellungsverfahren nach Hamb. Wassergesetz');
INSERT INTO v_baurecht_adf (wert, bezeichner) VALUES (2800,'Verkehrsflächenbereinigung');


-- B o d e n s c h a e t z u n g -  K u l t u r a r t
-- --------------------------------------------------
-- alter Name: ax_bodenschaetzung_kulturart
DROP TABLE v_bschaetz_kulturart;
CREATE TABLE v_bschaetz_kulturart (
    wert integer,
	kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_v_bschaetz_kulturart_w  PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_bschaetz_kulturart 
 IS 'Bodenschätzung, Spalte: Kulturart - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bodenschaetzung", Feld "kulturart".';

COMMENT ON COLUMN v_bschaetz_kulturart.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_bschaetz_kulturart.kurz       IS 'Kürzel';
COMMENT ON COLUMN v_bschaetz_kulturart.bezeichner IS 'Lange Bezeichnung';

INSERT INTO v_bschaetz_kulturart (wert, kurz, bezeichner) VALUES (1000,'A'  , 'Ackerland (A)');
INSERT INTO v_bschaetz_kulturart (wert, kurz, bezeichner) VALUES (2000,'AGr', 'Acker-Grünland (AGr)');
INSERT INTO v_bschaetz_kulturart (wert, kurz, bezeichner) VALUES (3000,'Gr' , 'Grünland (Gr)');
INSERT INTO v_bschaetz_kulturart (wert, kurz, bezeichner) VALUES (4000,'GrA', 'Grünland-Acker (GrA)');


-- B o d e n s c h a e t z u n g  -  B o d e n a r t
-- -------------------------------------------------
-- alter Name: ax_bodenschaetzung_bodenart
DROP TABLE v_bschaetz_bodenart;
CREATE TABLE v_bschaetz_bodenart (
    wert integer,
    kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_v_bschaetz_bodenart_w  PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_bschaetz_bodenart 
 IS 'Bodenschätzung, Spalte: Bodenart - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bodenschaetzung", Feld "bodenart".';

COMMENT ON COLUMN v_bschaetz_bodenart.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_bschaetz_bodenart.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN v_bschaetz_bodenart.bezeichner IS 'Lange Bezeichnung';

INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (1100,'S',     'Sand (S)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (2100,'lS',    'Lehmiger Sand (lS)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (3100,'L',     'Lehm (L)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (4100,'T',     'Ton (T)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (5000,'Mo',    'Moor (Mo)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (1200,'Sl',    'Anlehmiger Sand (Sl)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (2200,'SL',    'Stark lehmiger Sand (SL)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (3200,'sL',    'Sandiger Lehm (sL)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (4200,'LT',    'Schwerer Lehm (LT)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (6110,'SMo',   'Sand, Moor (SMo)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (6120,'lSMo',  'Lehmiger Sand, Moor (lSMo)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (6130,'LMo',   'Lehm, Moor (LMo)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (6140,'TMo',   'Ton, Moor (TMo)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (6210,'MoS',   'Moor,Sand (MoS)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (6220,'MolS',  'Moor, Lehmiger Sand (MolS)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (6230,'MoL',   'Moor, Lehm (MoL)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (6240,'MoT',   'Moor, Ton (MoT)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7110,'S/sL',  'Sand auf sandigem Lehm (S/sL)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7130,'S/LT',  'Sand auf schwerem Lehm (S/LT)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7210,'Sl/L',  'Anlehmiger Sand auf Lehm (Sl/L)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7220,'Sl/LT', 'Anlehmiger Sand auf schwerem Lehm (Sl/LT)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7230,'Sl/T',  'Anlehmiger Sand auf Ton (Sl/T)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7310,'lS/LT', 'Lehmiger Sand auf schwerem Lehm (lS/LT)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7320,'lS/S',  'Lehmiger Sand auf Sand (lS/S)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7400,'SL/T)', 'Stark lehmiger Sand auf Ton (SL/T)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7510,'T/SL',  'Ton auf stark lehmigen Sand (T/SL)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7530,'T/Sl',  'Ton auf anlehmigen Sand (T/Sl)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7610,'LT/lS', 'Schwerer Lehm auf lehmigen Sand (LT/lS)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7620,'LT/Sl', 'Schwerer Lehm auf anlehmigen Sand (LT/Sl)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7630,'LT/S',  'Schwerer Lehm auf Sand (LT/S)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7710,'L/Sl',  'Lehm auf anlehmigen Sand (L/Sl)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7800,'sL/S',  'Sandiger Lehm auf Sand (sL/S)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7120,'S/L',   'Sand auf Lehm (S/L)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7140,'S/T',   'Sand auf Ton (S/T)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7330,'lS/T',  'Lehmiger Sand auf Ton (lS/T)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7520,'T/lS',  'Ton auf lehmigen Sand (T/lS)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7540,'T/S',   'Ton auf Sand (T/S)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (7720,'L/S',   'Lehm auf Sand (L/S)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (8110,'S/Mo',  'Sand auf Moor (S/Mo)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (8120,'lS/Mo', 'Lehmiger Sand auf Moor (lS/Mo)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (8130,'L/Mo',  'Lehm auf Moor (L/Mo)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (8140,'T/Mo',  'Ton auf Moor (T/Mo)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (8210,'Mo/S',  'Moor auf Sand (Mo/S)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (8220,'Mo/lS', 'Moor auf lehmigen Sand (Mo/lS)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (8230,'Mo/L',  'Moor auf Lehm (Mo/L)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (8240,'Mo/T',  'Moor auf Ton (Mo/T)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9120,'L+Mo',  'Bodenwechsel vom Lehm zu Moor (L+Mo)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9130,'lSg',   'Lehmiger Sand mit starkem Steingehalt (lSg)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9140,'Lg',    'Lehm mit starkem Steingehalt (Lg)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9150,'lS+St', 'lehmiger Sand mit Steinen und Blöcken (lS+St)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9160,'L+St',  'Lehm mit Steinen und Blöcken (L+St)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9170,'St+lS', 'Steine und Blöcke mit lehmigem Sand (St+lS)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9180,'St+L',  'Steine und Blöcke mit Lehm (St+L)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9190,'lS+Fe', 'lehmiger Sand mit Felsen (lS+Fe)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9200,'L+Fe',  'Lehm mit Felsen (L+Fe)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9210,'Fe+lS', 'Felsen mit lehmigem Sand (Fe+lS)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9220,'Fe+L',  'Felsen mit Lehm (Fe+L)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9310,'S/lS',  'Sand auf lehmigen Sand (S/lS)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9320,'Sl/Me', 'Anlehmiger Sand auf Mergel (Sl/Me)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9330,'Sl/sL', 'Anlehmiger Sand auf sandigem Lehm (Sl/sL)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9340,'lS/L',  'Lehmiger Sand auf Lehm (lS/L)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9350,'lS/Me', 'Lehmiger Sand auf Mergel (lS/Me)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9360,'lS/sL', 'Lehmiger Sand auf sandigem Lehm (lS/sL)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9370,'lSMe',  'Lehmiger Sand, Mergel (lSMe)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9380,'lSMo/Me','Lehmiger Sand, Moor auf Mergel (lSMo/Me)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9390,'SlMo',  'Anlehmiger Sand, Moor (SlMo)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9410,'L/Me',  'Lehm auf Mergel (L/Me)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9420,'LMo/Me','Lehm, Moor auf Mergel (LMo/Me)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9430,'LT/Mo', 'Schwerer Lehm auf Moor (LT/Mo)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9440,'T/Me',  'Ton auf Mergel (T/Me)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9450,'Mo/Me', 'Moor auf Mergel (Mo/Me)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9460,'MoL/Me','Moor, Lehm auf Mergel (MoL/Me)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9470,'MoMe',  'Moor, Mergel (MoMe)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9480,'LöD',   'LößDiluvium (LöD)');
INSERT INTO v_bschaetz_bodenart (wert, kurz, bezeichner) VALUES (9490,'AlD',   'AlluviumDiluvium (AlD)');


-- B o d e n s c h a e t z u n g  -  Z u s t a n d s s t u f e
-- ------------------------------------------------------------
-- alter Name: ax_bodenschaetzung_zustandsstufe
DROP TABLE v_bschaetz_zustandsstufe; 
CREATE TABLE v_bschaetz_zustandsstufe (
    wert integer,
    kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_v_bschaetz_zustuf_w  PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_bschaetz_zustandsstufe 
 IS 'Bodenschätzung, Spalte: Zustandsstufe - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bodenschaetzung", Feld "zustandsstufe".';

COMMENT ON COLUMN v_bschaetz_zustandsstufe.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_bschaetz_zustandsstufe.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN v_bschaetz_zustandsstufe.bezeichner IS 'Lange Bezeichnung';

INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (1100,'1','Zustandsstufe (1)');
INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (1200,'2','Zustandsstufe (2)');
INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (1300,'3','Zustandsstufe (3)');
INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (1400,'4','Zustandsstufe (4)');
INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (1500,'5','Zustandsstufe (5)');
INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (1600,'6','Zustandsstufe (6)');
INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (1700,'7','Zustandsstufe (7)');
INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (1800,'-','Zustandsstufe Misch- und Schichtböden sowie künstlichveränderte Böden (-)');

INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (2100,'I','Bodenstufe (I)');
INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (2200,'II','Bodenstufe (II)');
INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (2300,'III','Bodenstufe (III)');
INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (2400,'-','Bodenstufe Misch- und Schichtböden sowie künstlich veränderte Böden (-)');
INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (3100,'II+III','Bodenstufe (II+III)');
INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (3200,'(III)','Bodenstufe ("(III)")');
INSERT INTO v_bschaetz_zustandsstufe (wert, kurz, bezeichner) VALUES (3300,'IV','Bodenstufe (IV)');


-- B o d e n s c h a e t z u n g   -  Muster-, Landesmuster- und Vergleichsstueck
-- ------------------------------------------------------------------------------
-- alter Name: ax_musterlandesmusterundvergleichsstueck_merkmal
DROP TABLE v_muster_merkmal; 
CREATE TABLE v_muster_merkmal (
    wert integer,
    kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_v_muster_merkmal_w  PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_muster_merkmal 
 IS 'Muster-, Landesmuster- und Vergleichsstück, Spalte: Merkmal - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_musterlandesmusterundvergleichsstueck", Feld "merkmal".';

COMMENT ON COLUMN v_muster_merkmal.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_muster_merkmal.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN v_muster_merkmal.bezeichner IS 'Lange Bezeichnung';

INSERT INTO v_muster_merkmal (wert, kurz, bezeichner) VALUES (1000,'M','Musterstück (M)');
INSERT INTO v_muster_merkmal (wert, kurz, bezeichner) VALUES (2000,'L','Landesmusterstück (L)');
INSERT INTO v_muster_merkmal (wert, kurz, bezeichner) VALUES (3000,'V','Vergleichsstück (V)');


-- B o d e n s c h a e t z u n g  -  Grabloch der Bodenschaetzung
-- --------------------------------------------------------------
-- alter Name: ax_grablochderbodenschaetzung_bedeutung
DROP TABLE v_grabloch_bedeutg; 
CREATE TABLE v_grabloch_bedeutg (
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_ax_grabloch_bedeutung  PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_grabloch_bedeutg
 IS 'Grabloch der Bodenschätzung, Spalte: Bedeutung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_grablochderbodenschaetzung", Feld "bedeutung".';

COMMENT ON COLUMN v_grabloch_bedeutg.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_grabloch_bedeutg.bezeichner IS 'Lange Bezeichnung';

INSERT INTO v_grabloch_bedeutg (wert, bezeichner) VALUES (1100, 'Grabloch, bestimmend, lagerichtig (innerhalb der Fläche)');
INSERT INTO v_grabloch_bedeutg (wert, bezeichner) VALUES (1200, 'Grabloch, bestimmend, lagerichtig (außerhalb des Abschnitts)');
INSERT INTO v_grabloch_bedeutg (wert, bezeichner) VALUES (1300, 'Grabloch, nicht lagerichtig, im Abschnitt nicht vorhanden');
INSERT INTO v_grabloch_bedeutg (wert, bezeichner) VALUES (2000, 'Grabloch für Muster-, Landesmuster-, Vergleichsstück');
INSERT INTO v_grabloch_bedeutg (wert, bezeichner) VALUES (3000, 'Grabloch, nicht bestimmend');


-- B o d e n s c h a e t z u n g   -  Entstehungsart oder Klimastufe / Wasserverhaeltnisse
-- ----------------------------------------------------------------------------------------
-- alter Name: ax_bodenschaetzung_entstehungsartoderklimastufe
DROP TABLE v_bschaetz_entsteh_klima;
CREATE TABLE v_bschaetz_entsteh_klima (
    wert integer,
    kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_v_bschaetz_entsteh_klima_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_bschaetz_entsteh_klima
 IS 'Bodenschätzung, Spalte: Entstehungsart oder Klimastufe - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bodenschaetzung", Feld "entstehungsartoderklimastufe".';

COMMENT ON COLUMN v_bschaetz_entsteh_klima.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_bschaetz_entsteh_klima.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN v_bschaetz_entsteh_klima.bezeichner IS 'Lange Bezeichnung';


INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(1000,'D',   'Diluvium (D)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(1100,'DAl', 'Diluvium über Alluvium (DAl)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(1200,'DLö', 'Diluvium über Löß (DLö)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(1300,'DV',  'Diluvium über Verwitterung (DV)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(1400,'Dg',  'Diluvium, gesteinig (Dg)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(1410,'DgAl','Diluvium, gesteinig über Alluvium (DgAl)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(1420,'DgLö','Diluvium, gesteinig über Löß (DgLö)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(1430,'DgV', 'Diluvium, gesteinig über Verwitterung (DgV)');

INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(2000,'Lö',  'Löß (Lö)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(2100,'LöD', 'Löß über Diluvium (LöD)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(2110,'LöDg','Löß, Diluvium, Gesteinsböden (LöDg)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(2120,'LöDV','Löß, Diluvium, Verwitterung (LöDV)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(2200,'LöAl','Löß über Alluvium (LöAl)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(2300,'LöV', 'Löß über Verwitterung (LöV)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(2310,'LöVg','Löß, Verwitterung, Gesteinsböden (LöVg)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(2400,'LöVg','Löß über Verwitterung, gesteinig (LöVg)');

INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(3000,'Al',  'Alluvium (Al)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(3100,'AlD', 'Alluvium über Diluvium (AlD)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(3200,'AlLö','Alluvium über Löß (AlLö)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(3300,'AlV', 'Alluvium über Verwitterung (AlV)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(3400,'Alg', 'Alluvium, gesteinig (Alg)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(3410,'AlgD','Alluvium, gesteinig über Diluvium (AlgD)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(3420,'AlgLö','Alluvium, gesteinig über Löß (AlgLö)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(3430,'AlgV','Alluvium, gesteinig über Verwitterung (AlgV)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(3500,'AlMa','Alluvium, Marsch (AlMa)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(3610,'AlMo','Alluvium, Moor (AlMo)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(3620,'MoAI','Moor, Alluvium (MoAI)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(3700,'Me',  'Mergel (Me)');

INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(4000,'V',   'Verwitterung (V)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(4100,'VD',  'Verwitterung über Diluvium (VD)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(4200,'VAl', 'Verwitterung über Alluvium (VAl)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(4300,'VLö', 'Verwitterung über Löß (VLö)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(4400,'Vg',  'Verwitterung, Gesteinsböden (Vg)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(4410,'VgD', 'Verwitterung, Gesteinsböden über Diluvium (VgD)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(5000,'-',   'Entstehungsart nicht erkennbar (-)');

INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(6100,'a',   'Klimastufe 8° C und darüber (a)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(6200,'b',   'Klimastufe 7,9° - 7,0° C (b)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(6300,'c',   'Klimastufe 6,9° - 5,7° C (c)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(6400,'d',   'Klimastufe 5,6° C und darunter (d)');

INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(7100,'1',   'Wasserstufe (1)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(7200,'2',   'Wasserstufe (2)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(7300,'3',   'Wasserstufe (3)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(7400,'4',   'Wasserstufe (4)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(7410,'4-',  'Wasserstufe (4-)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(7500,'5',   'Wasserstufe (5)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(7510,'5-',  'Wasserstufe (5-)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(7520,'3-',  'Wasserstufe (3-)');
INSERT INTO v_bschaetz_entsteh_klima (wert, kurz, bezeichner) VALUES(7530,'3+4', 'Wasserstufe (3+4)');


-- B o d e n s c h a e t z u n g   -  sonstige Angaben
-- ---------------------------------------------------
-- alter Name: ax_bodenschaetzung_sonstigeangaben
DROP TABLE v_bschaetz_sonst;
CREATE TABLE v_bschaetz_sonst (
    wert integer,
    kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_v_bschaetz_sonst_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_bschaetz_sonst
 IS 'Bodenschätzung, Spalte: sonstige Angaben - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bodenschaetzung", Feld "sonstigeangaben".';

COMMENT ON COLUMN v_bschaetz_sonst.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_bschaetz_sonst.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN v_bschaetz_sonst.bezeichner IS 'Lange Bezeichnung';

INSERT INTO v_bschaetz_sonst (wert, kurz, bezeichner) VALUES(1100,'Wa+',   'Nass, zu viel Wasser (Wa+)');
INSERT INTO v_bschaetz_sonst (wert, kurz, bezeichner) VALUES(1200,'Wa-',   'Trocken, zu wenig Wasser (Wa-)');
INSERT INTO v_bschaetz_sonst (wert, kurz, bezeichner) VALUES(1300,'Wa gt', 'Besonders günstige Wasserverhältnisse (Wa gt)');
INSERT INTO v_bschaetz_sonst (wert, kurz, bezeichner) VALUES(1400,'RiWa',  'Rieselwasser, künstliche Bewässerung (RiWa)');
INSERT INTO v_bschaetz_sonst (wert, kurz, bezeichner) VALUES(2100,'W',     'Unbedingtes Wiesenland (W)');
INSERT INTO v_bschaetz_sonst (wert, kurz, bezeichner) VALUES(2200,'Str',   'Streuwiese (Str) ');
INSERT INTO v_bschaetz_sonst (wert, kurz, bezeichner) VALUES(2300,'Hu',    'Hutung (Hu)');
INSERT INTO v_bschaetz_sonst (wert, kurz, bezeichner) VALUES(2400,'A-Hack','Acker-Hackrain (A-Hack)');
INSERT INTO v_bschaetz_sonst (wert, kurz, bezeichner) VALUES(2500,'Gr-Hack','Grünland-Hackrain (Gr-Hack)');
INSERT INTO v_bschaetz_sonst (wert, kurz, bezeichner) VALUES(2600,'G',     'Garten (G)');
INSERT INTO v_bschaetz_sonst (wert, kurz, bezeichner) VALUES(3000,'N',     'Neukultur (N)');
INSERT INTO v_bschaetz_sonst (wert, kurz, bezeichner) VALUES(4000,'T',     'Tiefkultur (T) ');
INSERT INTO v_bschaetz_sonst (wert, kurz, bezeichner) VALUES(5000,'Ger',   'Geringstland (Ger)');
INSERT INTO v_bschaetz_sonst (wert, kurz, bezeichner) VALUES(9000,'',      'Nachschätzung erforderlich ');

-- Testfall dazu finden:
-- SELECT gml_id, sonstigeangaben, x(st_Centroid(wkb_geometry)) AS x, y(st_Centroid(wkb_geometry)) AS y 
--  FROM ax_bodenschaetzung WHERE NOT sonstigeangaben[1] IS NULL LIMIT 10; -- NOT sonstigeangaben[2] IS NULL


-- B e w e r t u n g  - Klassifizierung
-- ------------------------------------
-- alter Name: ax_bewertung_klassifizierung
DROP TABLE v_bewertg_klass;
CREATE TABLE v_bewertg_klass (
    wert integer,
    bezeichner character varying,
    erklaer character varying,
    CONSTRAINT pk_v_bewertg_klass_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_bewertg_klass
IS 'Bewertung, Spalte: Klassifizierung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bewertung", Feld "klassifizierung".';

COMMENT ON COLUMN v_bewertg_klass.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN v_bewertg_klass.bezeichner IS 'Lange Bezeichnung';
COMMENT ON COLUMN v_bewertg_klass.erklaer    IS 'ggf. weitere Erlärung';

INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1100, 'Unbebautes Grundstück', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1120, 'Unbebautes Grundstück mit Gebäude von untergeordneter Bedeutung ', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1130, 'Unbebautes Grundstück mit einem dem Verfall preisgegebenen Gebäude', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1140, 'Unbebautes Grundstück für Erholungs- und Freizeitzwecke', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1210, 'Einfamilienhausgrundstück', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1220, 'Zweifamilienhausgrundstück', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1230, 'Mietwohngrundstück', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1240, 'Gemischtgenutztes Grundstück', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1250, 'Geschäftsgrundstück', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1260, 'Sonstiges bebautes Grundstück', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1310, 'Einfamilienhaus auf fremdem Grund und Boden', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1320, 'Zweifamilienhaus auf fremdem Grund und Boden', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1330, 'Mietwohngrundstück, Mietwohngebäude auf fremdem Grund und Boden', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1340, 'Gemischtgenutztes Grundstück, gemischtgenutztes Gebäude auf fremdem Grund und Boden ', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1350, 'Geschäftsgrundstück, Geschäftsgebäude auf fremdem Grund und Boden', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(1360, 'Sonstige bebaute Grundstücke, sonstige Gebäude auf fremdem Grund und Boden', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2110, 'Landwirtschaftliche Nutzung', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2120, 'Hopfen', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2130, 'Spargel', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2190, 'Sonstige Sonderkulturen', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2200, 'Holzung', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2300, 'Weingarten (allgemein)', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2310, 'Weingarten 1', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2320, 'Weingarten 2', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2330, 'Weingarten 3', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2340, 'Weingarten 4', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2350, 'Weingarten 5', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2360, 'Weingarten 6', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2370, 'Weingarten 7', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2380, 'Weingarten 8', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2390, 'Weingarten 9', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2410, 'Gartenland', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2420, 'Obstplantage', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2430, 'Baumschule', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2440, 'Anbaufläche unter Glas ', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2450, 'Kleingarten', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2510, 'Weihnachtsbaumkultur', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2520, 'Saatzucht', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2530, 'Teichwirtschaft', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2610, 'Abbauland der Land- und Forstwirtschaft ', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2620, 'Geringstland', '"Geringstland" sind Flächen geringster Ertragsfähigkeit ohne Wertzahlen nach dem Bodenschätzungsgesetz, das sind unkultivierte Moor- und Heideflächen (sofern nicht gesondert geführt), ehemals bodengeschätzte Flächen und ehemalige Weinbauflächen, die ihren Kulturzustand verloren haben.');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2630, 'Unland',   '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2640, 'Moor',     '"Moor" ist eine unkultivierte Fläche mit einer (mindestens 20 cm starken) Auflage aus vertorften und vermoorten Pflanzenresten, soweit sie nicht als Torfstich benutzt wird.');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2650, 'Heide',    '"Heide" ist eine unkultivierte, sandige, überwiegend mit Heidekraut oder Ginster bewachsene Fläche.');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2700, 'Reet',     '"Reet" ist eine ständig oder zeitweise unter Wasser stehende und mit Reet bewachsene Fläche.');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2710, 'Reet I',   'Reetfläche, deren Nutzung eingestuft ist in Güteklasse I (gut).');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2720, 'Reet II',  'Reetfläche, deren Nutzung eingestuft ist in Güteklasse II (mittel).');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2730, 'Reet III', 'Reetfläche, deren Nutzung eingestuft ist in Güteklasse III (gering).');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2800, 'Nebenfläche des Betriebs der Land- und Forstwirtschaft', '');
INSERT INTO v_bewertg_klass (wert, bezeichner, erklaer) VALUES(2899, 'Noch nicht klassifiziert', '');


-- F o r s t r e c h t  -  A r t   d e r   F e s t l e g u n g
-- -----------------------------------------------------------
-- alter Name: ax_forstrecht_artderfestlegung
DROP TABLE v_forstrecht_adf; 
CREATE TABLE v_forstrecht_adf (
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_v_forst_adf_w  PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_forstrecht_adf
IS 'Forstrecht, Spalte: Art der Festlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO v_forstrecht_adf (bezeichner, wert) VALUES('Klassifizierung nach Bundes- oder Landeswaldgesetz',3900);
INSERT INTO v_forstrecht_adf (bezeichner, wert) VALUES('Staatswald Bund',3910);
INSERT INTO v_forstrecht_adf (bezeichner, wert) VALUES('Staatswald Land',3920);
INSERT INTO v_forstrecht_adf (bezeichner, wert) VALUES('Kommunalwald',3930);
INSERT INTO v_forstrecht_adf (bezeichner, wert) VALUES('Anstalts- und Stiftungswald',3940);
INSERT INTO v_forstrecht_adf (bezeichner, wert) VALUES('Anderer öffentlicher Wald',3950);
INSERT INTO v_forstrecht_adf (bezeichner, wert) VALUES('Privater Gemeinschaftswald',3960);
INSERT INTO v_forstrecht_adf (bezeichner, wert) VALUES('Großprivatwald',3970);
INSERT INTO v_forstrecht_adf (bezeichner, wert) VALUES('Kleinprivatwald',3980);
INSERT INTO v_forstrecht_adf (bezeichner, wert) VALUES('Anderer Privatwald',3990);


-- F o r s t r e c h t - B e s o n d e r e   F u n k t i o n
-- ---------------------------------------------------------
-- alter Name: ax_forstrecht_besonderefunktion
DROP TABLE v_forstrecht_besfkt; 
CREATE TABLE v_forstrecht_besfkt(
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_v_forst_besfkt_w  PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_forstrecht_besfkt
IS 'Forstrecht, Spalte: besondere Funktion - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Ohne besondere gesetzliche Bindung',1000);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Ohne besondere gesetzliche Bindung nach LWaldG- Holzboden',1010);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Schutzwald',2000);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Schutzwald - Holzboden',2010);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Erholungswald',3000);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Erholungswald - Holzboden',3010);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Bannwald',4000);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Nationalpark - Holzboden',4010);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Naturschutzgebiet - Holzboden',5010);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Schutz- und Erholungswald',6000);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Schutz- und Erholungswald - Holzboden',6010);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Nationalpark - Nichtholzboden',7010);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Naturschutzgebiet - Nichtholzboden',8010);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Andere Forstbetriebsfläche',9000);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Nichtholzboden',9010);
INSERT INTO v_forstrecht_besfkt (bezeichner, wert) VALUES('Sonstiges',9999);


-- D a t e n e r h e b u n g
-- -------------------------
-- Datentyp: AX_LI_Source_MitDatenerhebung
-- alter Name: ax_datenerhebung
DROP TABLE v_datenerhebung; 
CREATE TABLE v_datenerhebung (
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_v_derhebung_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_datenerhebung
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus Katastervermessung ermittelt', 1000); -- (G)
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aufgrund Anforderungen mit Netzanschluss ermittelt', 1100);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aufgrund Anforderungen mit Bezug zur Flurstücksgrenze ermittelt', 1200);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus sonstiger Vermessung ermittelt', 1900);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus Luftbildmessung oder Fernerkundungsdaten ermittelt', 2000);-- 	
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus Katasterunterlagen und Karten für graphische Zwecke ermittelt', 4000);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus Katasterzahlen für graphische Zwecke ermittelt', 4100);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert', 4200);-- (G)
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab M größer gleich 1 zu 1000', 4210);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab 1 zu 1000 größer M größer gleich 1 zu 2000', 4220);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab 1 zu 2000 größer M größer gleich 1 zu 3000', 4230);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab 1 zu 3000 größer M größer gleich 1 zu 5000', 4240);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab 1 zu 5000 größer M', 4250);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert', 4300);-- (G)
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab M größer gleich 1 zu 1000', 4310);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab 1 zu 1000 größer M größer gleich 1 zu 2000', 4320);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab 1 zu 2000 größer M größer gleich 1 zu 3000', 4330);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab 1 zu 3000 größer M größer gleich 1 zu 5000', 4340);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab 1 zu 5000 größer M', 4350);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, mit sonstigen geometrischen Bedingungen und bzw. oder Homogenisierung (M größer gleich 1 zu 1000)', 4360);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, mit Berechnung oder Abstandsbedingung (M größer gleich 1 zu 1000)', 4370);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, mit sonstigen geometrischen Bedingungen und bzw. oder Homogenisierung (M kleiner 1 zu 1000)', 4380);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, mit Berechnung oder Abstandsbedingungen (M kleiner 1 zu 1000)', 4390);
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Nach Quellenlage nicht zu spezifizieren', 9998);--  (G)
INSERT INTO v_datenerhebung (bezeichner, wert) VALUES('Sonstiges', 9999);


-- Sonstiges Bauwerk oder sonstige Einrichtung - Bauwerksfunktion
-- --------------------------------------------------------------
-- alter Name: ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion
DROP TABLE v_sbauwerk_bwfkt; 
CREATE TABLE v_sbauwerk_bwfkt (
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_v_sbauwerk_bwfkt_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_sbauwerk_bwfkt
IS 'Sonstiges Bauwerk oder sonstige Einrichtung, Spalte: Bauwerksfunktion - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Überdachung',1610);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Carport',1611);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Treppe',1620);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Freitreppe',1621);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Rolltreppe',1622);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Treppenunterkante',1630);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Kellereingang',1640);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Rampe',1650);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Terrasse',1670);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Mauer',1700);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Mauerkante, rechts',1701);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Mauerkante, links',1702);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Mauermitte',1703);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Stützmauer',1720);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Stützmauer, rechts',1721);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Stützmauer, links',1722);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Stützmauermitte',1723);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Zaun',1740);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Denkmal, Denkstein, Standbild',1750);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Bildstock, Wegekreuz, Gipfelkreuz',1760);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Bildstock',1761);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Wegekreuz',1762);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Gipfelkreuz',1763);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Meilenstein, historischer Grenzstein',1770);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Brunnen',1780);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Brunnen (Trinkwasserversorgung)',1781);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Springbrunnen, Zierbrunnen',1782);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Ziehbrunnen',1783);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Spundwand',1790);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Höckerlinie',1791);
INSERT INTO v_sbauwerk_bwfkt (bezeichner, wert) VALUES ('Sonstiges',9999);


-- Bauteil - Bauart
-- -------------------------
-- alter Name: ax_bauteil_bauart
DROP TABLE v_bauteil_bauart; 
CREATE TABLE v_bauteil_bauart (
    wert integer, 
    bezeichner character varying,  
    kennung integer,
    objektart character varying,
    CONSTRAINT pk_v_bauteil_bauart_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_bauteil_bauart
IS 'Bauteil, Spalte: Bauart - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (1100,'Geringergeschossiger Gebäudeteil',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (1200,'Höhergeschossiger Gebäudeteil (nicht Hochhaus)',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (1300,'Hochhausgebäudeteil',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (1400,'Abweichende Geschosshöhe',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2000,'Keller',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2100,'Tiefgarage',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2300,'Loggia',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2350,'Wintergarten',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2400,'Arkade',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2500,'Auskragende/zurückspringende Geschosse',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2510,'Auskragende Geschosse',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2520,'Zurückspringende Geschosse',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2610,'Durchfahrt im Gebäude',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2620,'Durchfahrt an überbauter Verkehrsstraße',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2710,'Schornstein im Gebäude',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (2720,'Turm im Gebäude',31002,'ax_bauteil');
INSERT INTO v_bauteil_bauart (wert, bezeichner,kennung,objektart) VALUES (9999,'Sonstiges',31002,'ax_bauteil');


-- Klassifizierung nach Straßenrecht - Art der Festlegung 
-- ------------------------------------------------------
-- alter Name: ax_klassifizierungnachstrassenrecht_artdf
DROP TABLE v_klass_strass_adf; 
CREATE TABLE v_klass_strass_adf (
    wert integer, 
    bezeichner character varying,  
    kennung integer, 
    objektart character varying,
    CONSTRAINT pk_v_klass_strass_adf_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_klass_strass_adf
IS 'Klassifizierung nach Straßenrecht, Spalte: Art der Festlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO v_klass_strass_adf (bezeichner, wert) VALUES ('Klassifizierung nach Bundes- oder Landesstraßengesetz',1100);
INSERT INTO v_klass_strass_adf (bezeichner, wert) VALUES ('Bundesautobahn',1110);
INSERT INTO v_klass_strass_adf (bezeichner, wert) VALUES ('Bundesstraße',1120);
INSERT INTO v_klass_strass_adf (bezeichner, wert) VALUES ('Landes- oder Staatsstraße',1130);
INSERT INTO v_klass_strass_adf (bezeichner, wert) VALUES ('Kreisstraße',1140);
INSERT INTO v_klass_strass_adf (bezeichner, wert) VALUES ('Gemeindestraße',1150);
INSERT INTO v_klass_strass_adf (bezeichner, wert) VALUES ('Ortsstraße',1160);
INSERT INTO v_klass_strass_adf (bezeichner, wert) VALUES ('Gemeindeverbindungsstraße',1170);
INSERT INTO v_klass_strass_adf (bezeichner, wert) VALUES ('Sonstige öffentliche Straße',1180);
INSERT INTO v_klass_strass_adf (bezeichner, wert) VALUES ('Privatstraße',1190);


-- Klassifizierung nach Wasserrecht - Art der Festlegung
-- ----------------------------------------------------
-- alter Name: ax_klassifizierungnachwasserrecht_artdf
DROP TABLE v_klass_wasser_adf; 
CREATE TABLE v_klass_wasser_adf (
    wert integer, 
    bezeichner character varying,  
    kennung integer,
    objektart character varying,
    CONSTRAINT pk_v_klass_wasser_adf_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_klass_wasser_adf
IS 'Klassifizierung nach Wasserrecht, Spalte: Art der Festlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO v_klass_wasser_adf (bezeichner, wert) VALUES ('Klassifizierung nach Bundes- oder Landeswassergesetz',1300);
INSERT INTO v_klass_wasser_adf (bezeichner, wert) VALUES ('Gewässer I. Ordnung - Bundeswasserstraße',1310);
INSERT INTO v_klass_wasser_adf (bezeichner, wert) VALUES ('Gewässer I. Ordnung - nach Landesrecht',1320);
INSERT INTO v_klass_wasser_adf (bezeichner, wert) VALUES ('Gewässer II. Ordnung',1330);
INSERT INTO v_klass_wasser_adf (bezeichner, wert) VALUES ('Gewässer III. Ordnung',1340);


-- Andere Festlegung nach Strassenrecht - Art der Festlegung
-- ---------------------------------------------------------
-- alter Name: ax_anderefestlegungnachstrassenrecht_artdf
DROP TABLE v_andstrass_adf; 
CREATE TABLE v_andstrass_adf (
    wert integer, 
    bezeichner character varying,  
    kennung integer,
    objektart character varying,
    CONSTRAINT pk_v_andstrass_adf_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_andstrass_adf
IS 'Andere Festlegung nach Strassenrecht, Spalte: Art der Festlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO v_andstrass_adf (bezeichner, wert) VALUES ('Bundesfernstraßengesetz',1210);
INSERT INTO v_andstrass_adf (bezeichner, wert) VALUES ('Anbauverbot',1220);
INSERT INTO v_andstrass_adf (bezeichner, wert) VALUES ('Anbauverbot nach Bundesfernstraßengesetz',1230);
INSERT INTO v_andstrass_adf (bezeichner, wert) VALUES ('Anbauverbot (40m)',1231);
INSERT INTO v_andstrass_adf (bezeichner, wert) VALUES ('Anbauverbot (20m)',1232);
INSERT INTO v_andstrass_adf (bezeichner, wert) VALUES ('Anbaubeschränkung',1240);
INSERT INTO v_andstrass_adf (bezeichner, wert) VALUES ('Anbaubeschränkung (100m)',1241);
INSERT INTO v_andstrass_adf (bezeichner, wert) VALUES ('Anbaubeschränkung (40m)',1242);
INSERT INTO v_andstrass_adf (bezeichner, wert) VALUES ('Veränderungssperre nach Bundesfernstraßengesetz',1250);
INSERT INTO v_andstrass_adf (bezeichner, wert) VALUES ('Landesstraßengesetz',1260);
INSERT INTO v_andstrass_adf (bezeichner, wert) VALUES ('Veränderungssperre',1280);


-- Natur-, Umwelt- oder Bodenschutzrecht - Art der Festlegung
-- ----------------------------------------------------------
-- alter Name: ax_naturumweltoderbodenschutzrecht_artdf
DROP TABLE v_umweltrecht_adf; 
CREATE TABLE v_umweltrecht_adf (
    wert integer, 
    bezeichner character varying,  
    kennung integer, 
    objektart character varying,
    CONSTRAINT pk_v_umweltrecht_adf_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_umweltrecht_adf
IS 'Natur-, Umwelt- oder Bodenschutzrecht, Spalte: Art der Festlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Schutzfläche nach Europarecht',610);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Flora-Fauna-Habitat-Gebiet',611);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Vogelschutzgebiet',612);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Schutzflächen nach Landesnaturschutzgesetz',620);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Naturschutzgebiet',621);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Geschützter Landschaftsbestandteil',622);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Landschaftsschutzgebiet',623);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Naturpark',624);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Bundesbodenschutzgesetz',630);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Verdachtsfläche auf schädliche Bodenveränderung',631);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Schädliche Bodenveränderung',632);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Altlastenverdächtige Fläche',633);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Altlast',634);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Bundesimmisionsschutzgesetz',640);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Belastungsgebiet',641);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Schutzbedürftiges Gebiet',642);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Gefährdetes Gebiet',643);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Naturschutzgesetz',650);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Besonders geschütztes Biotop',651);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Besonders geschütztes Feuchtgrünland',652);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Naturdenkmal',653);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Einstweilige Sicherstellung, Veränderungssperre',654);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Vorkaufsrecht',655);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Ausgleichs- oder Kompensationsfläche',656);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Bodenschutzgesetz',660);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Dauerbeobachtungsflächen',661);
INSERT INTO v_umweltrecht_adf (bezeichner, wert) VALUES ('Bodenschutzgebiet',662);


-- Denkmalschutzrecht - Art der Festlegung
-- ---------------------------------------
-- alter Name: ax_denkmalschutzrecht_artdf
DROP TABLE v_denkmal_adf; 
CREATE TABLE v_denkmal_adf (
    wert integer, 
    bezeichner character varying,  
    kennung integer,
    objektart character varying,
    CONSTRAINT pk_v_denkmal_adf_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_denkmal_adf
IS 'Denkmalschutzrecht, Spalte: Art der Festlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Kulturdenkmal',2700);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Bau- und Kunstdenkmal nach Landesdenkmalschutzgesetz',2710);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Baudenkmal',2711);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Kunstdenkmal',2712);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Gartendenkmal',2713);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Archäologisches Denkmal (auch Bodendenkmal) nach Landesdenkmalschutzgesetz',2800);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Archäologisches Denkmal',2810);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Bodendenkmal',2820);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Schutzgebiet oder -bereiche nach Landesdenkmalschutzgesetz',2900);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Denkmalzone oder -bereich',2910);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Geschützter Baubereich',2920);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Grabungsschutzgebiet',2930);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Befestigungen',3100);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Befestigung (Burg)',3110);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Burg (Fliehburg, Ringwall)',3111);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Erdwerk',3112);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Ringwall',3113);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Steinwerk',3114);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Festung',3115);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Gräftenanlage',3116);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Schanze',3117);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Lager',3118);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Wachturm (römisch), Warte',3120);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Wachturm',3121);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Warte',3122);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Befestigung (Wall, Graben)',3130);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Grenzwall, Schutzwall',3131);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Limes',3132);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Landwehr',3133);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Stadtwall',3134);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historischer Wall',3135);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historische Siedlung',3200);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Pfahlbau',3210);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Wüstung',3220);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Wurt',3230);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Abri',3240);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Höhle',3250);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historische Bestattung',3300);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Großsteingrab (Dolmen, Hünenbett)',3310);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Grabhügel',3320);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Grabhügelfeld',3330);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Urnenfriedhof',3340);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Körpergräberfeld',3350);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Reihengräberfriedhof',3360);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historisches land- oder forstwirtschaftliches Objekt',3400);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historischer Pflanzkamp',3410);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historisches Viehgehege',3420);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Sandfang',3430);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historisches Ackersystem',3440);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historische Bergbau-, Verhüttungs- oder sonstige Produktionsstätte',3500);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historisches Bergbaurelikt',3510);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historischer Meiler',3520);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historischer Ofen',3530);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historischer Verhüttungsplatz',3540);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historische Straße oder Weg',3600);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Heerstraße',3610);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Hohlweg',3620);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Moorweg',3630);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Wegespur',3640);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historisches wasserwirtschaftliches Objekt',3700);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historische Wasserleitung',3710);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Aquädukt',3720);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historischer Deich',3730);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historischer Damm',3740);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historischer Graben',3750);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Steinmal',3800);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Schalenstein',3810);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Rillenstein',3820);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Wetzrillen',3830);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Kreuzstein',3840);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Historischer Grenzstein',3850);
INSERT INTO v_denkmal_adf (bezeichner, wert) VALUES ('Menhir',3860);


-- Sonstiges Recht - Art der Festlegung 
-- ------------------------------------
-- alter Name: ax_sonstigesrecht_artdf
DROP TABLE v_sonstrecht_adf; 
CREATE TABLE v_sonstrecht_adf (
    wert integer, 
    bezeichner character varying,  
    kennung integer,
    objektart character varying,
    CONSTRAINT pk_v_sonstrecht_adf_w PRIMARY KEY (wert)
  );

COMMENT ON TABLE v_sonstrecht_adf
IS 'Sonstiges Recht, Spalte: Art der Festlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Luftverkehrsgesetz',4100);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Bauschutzbereich',4110);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Beschränkter Bauschutzbereich',4120);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Bundeskleingartengesetz',4200);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Dauerkleingarten',4210);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Berggesetz',4300);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Bodenbewegungsgebiet',4301);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Bruchfeld',4302);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Baubeschränkung',4310);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Reichsheimstättengesetz',4400);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Reichsheimstätte',4410);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Schutzbereichsgesetz',4500);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Schutzbereich',4510);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Eisenbahnneuordnungsgesetz',4600);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Übergabebescheidverfahren',4610);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Baubeschränkungen durch Richtfunkverbindungen',4710);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Truppenübungsplatz, Standortübungsplatz',4720);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Vermessungs- und Katasterrecht',4800);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Schutzfläche Festpunkt',4810);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 1 m Radius',4811);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 2 m Radius',4812);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 5 m Radius',4813);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 10 m Radius',4814);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 30 m Radius',4815);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Marksteinschutzfläche',4820);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Liegenschaftskatastererneuerung',4830);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Fischereirecht',4900);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Jagdkataster',5100);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Landesgrundbesitzkataster',5200);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Bombenblindgängerverdacht',5300);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Rieselfeld',5400);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Sicherungsstreifen',5500);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Grenzbereinigung',5600);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Hochwasserdeich',5700);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Hauptdeich, 1. Deichlinie',5710);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('2. Deichlinie',5720);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Beregnungsverband',6000);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Weinlage',7000);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Weinbausteillage',7100);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Weinbergsrolle',7200);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Weinbausteilstlage',7300);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Benachteiligtes landwirtschaftliches Gebiet',8000);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Mitverwendung Hochwasserschutz, Oberirdische Anlagen',9100);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Mitverwendung Hochwasserschutz, Unterirdische Anlagen',9200);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Hafennutzungsgebiet',9300);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Hafenerweiterungsgebiet',9400);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Bohrung verfüllt',9500);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Zollgrenze',9600);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Belastung nach §7 Abs. 2 GBO',9700);
INSERT INTO v_sonstrecht_adf (bezeichner, wert) VALUES ('Sonstiges',9999);

-- ENDE --
