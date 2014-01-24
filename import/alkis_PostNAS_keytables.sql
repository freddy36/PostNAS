
-- ALKIS-Datenbank aus dem Konverter PostNAS

-- Z u s a e t z l i c h e   S c h l u e s s e l t a b e l l e n

-- Dieses Script fuegt der Datenbank einige Schluesseltabellen hinzu, die der 
-- Konverter PostNAS NICHT aufbaut, weil sie nicht in den NAS-Daten enthalten sind.
-- Die Schluessel sind der Dokumentation zu entnehmen.

-- Die Tabellen werden vom Buchwerk-Auskunftsprogramm benoetigt.

-- Dies Script kann nach dem Anlegen der Datenbank mit dem Script 'alkis_PostNAS_schema.sql' verarbeitet werden.

-- Version
--  2010-09-16  F.J. Buchungsart hinzugefuegt
--  2011-07-25       PostNAS 06, Umbenennung, "grant" raus
--  2011-11-21  F.J. Mehrere neue Schlüsseltabellen zu ax_gebaeude_*, Konstanten aus Tabellen entfernt (Wozu?)
--  2011-12-16  A.E. Mehrere neue Tabellen zum Bereich "Bodenschaetzung"
--  2011-12-19  F.J. Neue Tabelle "ax_datenerhebung"
--  2011-12-20  A.E. ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion
--  2011-12-22  A.E. ax_bauteil_bauart
--  2012-03-12  A.E. ax_anderefestlegungnachstrassenrecht_artdf, ax_klassifizierungnachwasserrecht_artdf, 
--                   ax_klassifizierungnachstrassenrecht_artdf, ax_naturumweltoderbodenschutzrecht_artdf, 
--                   ax_sonstigesrecht_artdf, ax_anderefestlegungnachwasserrecht_artdf
--  2013-04-17  F.J. Kurzbezeichnungen der Bodenschättung für die Kartendarstellung

--	2014-01-24	F.J. "Eigentuemerart" entschchlüsseln

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
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_gebaeude", Feld "bauweise".';

COMMENT ON COLUMN ax_gebaeude_bauweise.bauweise_id           IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_gebaeude_bauweise.bauweise_beschreibung IS 'Bezeichnung, Bedeutung';

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
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_gebaeude", Feld "funktion".';

COMMENT ON COLUMN ax_gebaeude_funktion.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_gebaeude_funktion.bezeichner IS 'Bezeichnung, Bedeutung';

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
	erklaer		character varying,
    CONSTRAINT pk_ax_gebaeude_weitfunktion_wert PRIMARY KEY (wert)
   );

COMMENT ON TABLE  ax_gebaeude_weiterefunktion 
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_gebaeude", Feld "weiterefunktion".';

COMMENT ON COLUMN ax_gebaeude_weiterefunktion.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_gebaeude_weiterefunktion.bezeichner IS 'Lange Bezeichnung';
COMMENT ON COLUMN ax_gebaeude_weiterefunktion.erklaer    IS 'ALKIS erklärt uns die Welt';

INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1000, 'Bankfiliale',    '"Bankfiliale" ist eine Einrichtung in der Geldgeschäfte getätigt werden.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1010, 'Hotel',          '"Hotel" ist ein Beherbergungs- und/oder Verpflegungsbetrieb.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1020, 'Jugendherberge', '"Jugendherberge" ist eine zur Förderung von Jugendreisen dienende Aufenthalts- und Übernachtungsstätte.');	
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1030, 'Gaststätte',     '"Gaststätte" ist eine Einrichtung, in der gegen Entgelt Mahlzeiten und Getränke zum sofortigen Verzehr angeboten werden.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1040, 'Kino',           '"Kino" ist eine Einrichtung, in der alle Arten von Filmen bzw. Lichtspielen für ein Publikum abgespielt werden.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1050, 'Spielkasino',    '"Spielkasino" ist eine Einrichtung, in der öffentlich zugänglich staatlich konzessioniertes Glücksspiel betrieben wird.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1060, 'Tiefgarage',     '"Tiefgarage" ist ein Bauwerk unterhalb der Erdoberfläche, in dem Fahrzeuge abgestellt werden.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1070, 'Parkdeck',       '"Parkdeck" ist eine Fläche auf einem Gebäude, auf der Fahrzeuge abgestellt werden.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1080, 'Toilette',       '"Toilette" ist eine Einrichtung mit sanitären Vorrichtungen zum Verrichtung der Notdurft.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1090, 'Post',           '"Post" ist eine Einrichtung, von der aus Briefe, Pakete befördert und weitere Dienstleistungen angeboten werden.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1100, 'Zoll',           '"Zoll" ist eine Einrichtung der Zollabfertigung.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1110, 'Theater',        '"Theater" ist eine Einrichtung, in der Bühnenstücke aufgeführt werden.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1120, 'Museum',         '"Museum" ist eine Einrichtung in der Sammlungen von (historischen) Objekten oder Reproduktionen davon ausgestellt werden.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1130, 'Bibliothek',     '"Bibliothek" ist eine Einrichtung, in der Bücher und Zeitschriften gesammelt, aufbewahrt und ausgeliehen werden.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1140, 'Kapelle',        '"Kapelle" ist eine Einrichtung für (christliche) gottesdienstliche Zwecke.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1150, 'Moschee',        '"Moschee" ist ein Einrichtung, in der sich Muslime zu Gottesdiensten versammeln oder zu anderen Zwecken treffen.');	
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1160, 'Tempel',         '');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1170, 'Apotheke',       '"Apotheke" ist ein Geschäft, in dem Arzneimittel hergestellt und verkauft werden.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1180, 'Polizeiwache',   '"Polizeiwache" ist eine Dienststelle der Polizei.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1190, 'Rettungsstelle', '"Rettungsstelle" ist eine Einrichtung zur Aufnahme, Erstbehandlung und gezielten Weiterverlegung von Patienten mit Erkrankungen und Unfällen aller Art.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1200, 'Touristisches Informationszentrum', '"Touristisches Informationszentrum" ist eine Auskunftsstelle für Touristen.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1210, 'Kindergarten',    '"Kindergarten" ist eine Einrichtung, in der Kinder im Vorschulalter betreut werden.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1220, 'Arztpraxis',      '"Arztpraxis" ist die Arbeitsstätte eines Arztes.');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1230, 'Supermarkt',      '');
INSERT INTO ax_gebaeude_weiterefunktion (wert, bezeichner, erklaer) VALUES (1240, 'Geschäft',        '');


-- G e b ä u d e   D a c h f o r m
-- -------------------------------

--DROP TABLE ax_gebaeude_dachform;
CREATE TABLE ax_gebaeude_dachform 
   (wert        integer, 
    bezeichner  character varying,
    CONSTRAINT pk_ax_gebaeude_dach_wert PRIMARY KEY (wert)
   );

COMMENT ON TABLE  ax_gebaeude_dachform 
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_gebaeude", Feld "dachform".';

COMMENT ON COLUMN ax_gebaeude_dachform.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_gebaeude_dachform.bezeichner IS 'Lange Bezeichnung';

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
	erklaer		character varying,
    CONSTRAINT pk_ax_gebaeude_zustand_wert PRIMARY KEY (wert)
   );

COMMENT ON TABLE  ax_gebaeude_zustand 
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "___", Feld "___".';

COMMENT ON COLUMN ax_gebaeude_zustand.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_gebaeude_zustand.erklaer    IS 'ggf. zusätzliche Erklärung';
COMMENT ON COLUMN ax_gebaeude_zustand.bezeichner IS 'Lange Bezeichnung';

INSERT INTO ax_gebaeude_zustand (wert, bezeichner) VALUES (1000, 'In behelfsmäßigem Zustand');
INSERT INTO ax_gebaeude_zustand (wert, bezeichner) VALUES (2000, 'In ungenutztem Zustand');
INSERT INTO ax_gebaeude_zustand (wert, bezeichner, erklaer) VALUES (2100, 'Außer Betrieb, stillgelegt, verlassen', '"Außer Betrieb, stillgelegt, verlassen" bedeutet, dass das Gebäude auf Dauer nicht mehr bewohnt oder genutzt wird');
INSERT INTO ax_gebaeude_zustand (wert, bezeichner, erklaer) VALUES (2200, 'Verfallen, zerstört', '"Verfallen, zerstört" bedeutet, dass sich der ursprüngliche Zustand des Gebäudes durch menschliche oder zeitliche Einwirkungen so verändert hat, dass eine Nutzung nicht mehr möglich ist.');
INSERT INTO ax_gebaeude_zustand (wert, bezeichner) VALUES (2300, 'Teilweise zerstört');
INSERT INTO ax_gebaeude_zustand (wert, bezeichner) VALUES (3000, 'Geplant und beantragt');
INSERT INTO ax_gebaeude_zustand (wert, bezeichner) VALUES (4000, 'Im Bau');


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
-- Kennung   = 21008,
-- Objektart = 'ax_buchungsstelle'

CREATE TABLE ax_buchungsstelle_buchungsart (
   wert integer,
   bezeichner character varying,
   CONSTRAINT pk_ax_bsba_wert PRIMARY KEY (wert)
  );

COMMENT ON TABLE  ax_buchungsstelle_buchungsart 
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_buchungsstelle", Feld "buchungsart".';

COMMENT ON COLUMN ax_buchungsstelle_buchungsart.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_buchungsstelle_buchungsart.bezeichner IS 'Lange Bezeichnung';

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


-- N a m e n s n u m m e r  -  E i g e n t u e m e r a r t
-- -------------------------------------------------------
-- Kennung   = 21006,
-- Objektart = 'AX_Namensnummer'
-- 2014-01-24 NEU. Bisher nur 3 Werte ueber Function (case) entschluesselt.

CREATE TABLE ax_namensnummer_eigentuemerart (
   wert integer,
   bezeichner character varying,
   CONSTRAINT pk_ax_nnea_wert PRIMARY KEY (wert)
  );

COMMENT ON TABLE  ax_namensnummer_eigentuemerart 
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_namensnummer", Feld "eigentuemerart".';

COMMENT ON COLUMN ax_namensnummer_eigentuemerart.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_namensnummer_eigentuemerart.bezeichner IS 'Lange Bezeichnung';

INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (1000,'Natürliche Personen');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (1100,'Natürliche Person - Alleineigentum oder Ehepartner');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (1200,'Natürliche Person - Wohnsitz im Land');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (1300,'Natürliche Person - Wohnsitz außerhalb des Landes');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (1500,'Natürliche Person - Gemeinschaftseigentum');

INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (2000,'Juristische Personen');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (2100,'Gemeinnützige Bau-, Wohnungs- oder Siedlungsgesellschaft oder -genossenschaft einschließlich Heimstätte');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (2200,'Sonstige gemeinnützige Institution (Träger von Krankenhäusern, Altenheimen usw.) ');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (2300,'Privates Wohnungsunternehmen, private Baugesellschaft u.ä.');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (2400,'Kreditinstitut');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (2500,'Versicherungsunternehmen');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (2900,'Andere Unternehmen, Gesellschaften usw.');

INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (3000,'Körperschaften');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (3100,'Stiftung');

INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (4000,'Kirchliches Eigentum');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (4100,'Evangelische Kirche');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (4200,'Katholische Kirche ');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (4900,'Andere Kirchen, Religionsgemeinschaften usw.');

INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5100,'Bundesrepublik Deutschland');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5101,'Bundesrepublik Deutschland, Bundesstraßenverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5102,'Bundesrepublik Deutschland, Bundeswehrverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5103,'Bundesrepublik Deutschland, Forstverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5104,'Bundesrepublik Deutschland, Finanzverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5105,'Bundesrepublik Deutschland, Zivilschutz');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5106,'Bundesrepublik Deutschland, Wasserstraßenverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5107,'Bundesrepublik Deutschland, Bundeseisenbahnvermögen');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5210,'Eigentum des Volkes nach DDR-Recht');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5220,'Eigentum der Genossenschaften und deren Einrichtungen');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5230,'Eigentum der gesellschaftlichen Organisationen und deren Einrichtungen ');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5240,'Kommunale Gebietskörperschaften nach DDR-Recht');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5300,'Ausländischer Staat');

INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5400,'Kreis');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5500,'Gemeinde');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5600,'Kommunale Gebietskörperschaften ');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5700,'Andere Gebietskörperschaften, Regionalverbände usw.');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5800,'Zweckverbände, Kommunale Betriebe');

INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5920,'Eigenes Bundesland');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5921,'Eigenes Bundesland, Denkmalpflege');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5922,'Eigenes Bundesland, Domänenverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5923,'Eigenes Bundesland, Eichverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5924,'Eigenes Bundesland, Finanzverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5925,'Eigenes Bundesland, Forstverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5926,'Eigenes Bundesland, Gesundheitswesen');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5927,'Eigenes Bundesland, Polizeiverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5928,'Eigenes Bundesland, innere Verwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5929,'Eigenes Bundesland, Justizverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5930,'Eigenes Bundesland, Kultusverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5931,'Eigenes Bundesland, Landespflanzenschutzverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5932,'Eigenes Bundesland, Arbeitsverwaltung ');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5933,'Eigenes Bundesland, Sozialwesen');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5934,'Eigenes Bundesland, Landesbetrieb Straßen und Verkehr');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5935,'Eigenes Bundesland, Umweltverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5936,'Eigenes Bundesland, Vermessungs- und Katasterverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5937,'Eigenes Bundesland, Wasserwirtschaftsverwaltung ');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5938,'Eigenes Bundesland, Wirtschaftsverwaltung');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (5939,'Eigenes Bundesland, Liegenschafts- und Baubetreuung (LBB)');

INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6000,'Anderes Bundesland (allg.)');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6001,'Schleswig-Holstein');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6002,'Hamburg');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6003,'Niedersachsen');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6004,'Bremen');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6005,'Nordrhein-Westfalen');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6006,'Hessen');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6007,'Rheinland-Pfalz');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6008,'Baden-Württemberg');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6009,'Bayern');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6010,'Saarland');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6012,'Brandenburg');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6011,'Berlin');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6013,'Mecklenburg-Vorpommern');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6014,'Sachsen');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6015,'Sachsen-Anhalt');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (6016,'Thüringen');

INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (7100,'Deutsche Bahn AG');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (8000,'Herrenlos');
INSERT INTO ax_namensnummer_eigentuemerart (wert, bezeichner) VALUES (9000,'Eigentümer unbekannt');

-- In der Praxis kommt vor:
--   SELECT DISTINCT eigentuemerart FROM ax_namensnummer ORDER BY eigentuemerart;


-- B a u - , R a u m -  oder  B o d e n - O r d n u n g s r e c h t  -  A r t  d e r  F e s t l e g u n g
-- ------------------------------------------------------------------------------------------------------
-- Kennung = 71008,
-- Objektart = 'ax_bauraumoderbodenordnungsrecht'
-- für: Entschluesseln der Rechte im Template

CREATE TABLE ax_bauraumoderbodenordnungsrecht_artderfestlegung (
	wert        integer, 
	bezeichner  character varying,
	CONSTRAINT pk_ax_brecht_artfest_wert PRIMARY KEY (wert)
  );

COMMENT ON TABLE  ax_bauraumoderbodenordnungsrecht_artderfestlegung 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bauraumoderbodenordnungsrecht", Feld "artderfestlegung".';

COMMENT ON COLUMN ax_bauraumoderbodenordnungsrecht_artderfestlegung.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_bauraumoderbodenordnungsrecht_artderfestlegung.bezeichner IS 'Lange Bezeichnung';

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
--DROP TABLE ax_bodenschaetzung_kulturart;
CREATE TABLE ax_bodenschaetzung_kulturart (
    wert integer,
	kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_ax_bodenschaetzung_kulturart  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bodenschaetzung_kulturart 
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bodenschaetzung", Feld "kulturart".';

COMMENT ON COLUMN ax_bodenschaetzung_kulturart.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_bodenschaetzung_kulturart.kurz       IS 'Kürzel';
COMMENT ON COLUMN ax_bodenschaetzung_kulturart.bezeichner IS 'Lange Bezeichnung';

INSERT INTO ax_bodenschaetzung_kulturart (wert, kurz, bezeichner) VALUES (1000,'A'  , 'Ackerland (A)');
INSERT INTO ax_bodenschaetzung_kulturart (wert, kurz, bezeichner) VALUES (2000,'AGr', 'Acker-Grünland (AGr)');
INSERT INTO ax_bodenschaetzung_kulturart (wert, kurz, bezeichner) VALUES (3000,'Gr' , 'Grünland (Gr)');
INSERT INTO ax_bodenschaetzung_kulturart (wert, kurz, bezeichner) VALUES (4000,'GrA', 'Grünland-Acker (GrA)');


-- B o d e n s c h a e t z u n g  -  B o d e n a r t
-- -------------------------------------------------
--DROP TABLE ax_bodenschaetzung_bodenart;
CREATE TABLE ax_bodenschaetzung_bodenart (
    wert integer,
	kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_ax_bodenschaetzung_bodenart  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bodenschaetzung_bodenart 
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bodenschaetzung", Feld "bodenart".';

COMMENT ON COLUMN ax_bodenschaetzung_bodenart.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_bodenschaetzung_bodenart.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN ax_bodenschaetzung_bodenart.bezeichner IS 'Lange Bezeichnung';

INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (1100,'S',     'Sand (S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (2100,'lS',    'Lehmiger Sand (lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (3100,'L',     'Lehm (L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (4100,'T',     'Ton (T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (5000,'Mo',    'Moor (Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (1200,'Sl',    'Anlehmiger Sand (Sl)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (2200,'SL',    'Stark lehmiger Sand (SL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (3200,'sL',    'Sandiger Lehm (sL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (4200,'LT',    'Schwerer Lehm (LT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6110,'SMo',   'Sand, Moor (SMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6120,'lSMo',  'Lehmiger Sand, Moor (lSMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6130,'LMo',   'Lehm, Moor (LMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6140,'TMo',   'Ton, Moor (TMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6210,'MoS',   'Moor,Sand (MoS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6220,'MolS',  'Moor, Lehmiger Sand (MolS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6230,'MoL',   'Moor, Lehm (MoL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6240,'MoT',   'Moor, Ton (MoT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7110,'S/sL',  'Sand auf sandigem Lehm (S/sL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7130,'S/LT',  'Sand auf schwerem Lehm (S/LT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7210,'Sl/L',  'Anlehmiger Sand auf Lehm (Sl/L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7220,'Sl/LT', 'Anlehmiger Sand auf schwerem Lehm (Sl/LT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7230,'Sl/T',  'Anlehmiger Sand auf Ton (Sl/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7310,'lS/LT', 'Lehmiger Sand auf schwerem Lehm (lS/LT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7320,'lS/S',  'Lehmiger Sand auf Sand (lS/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7400,'SL/T)', 'Stark lehmiger Sand auf Ton (SL/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7510,'T/SL',  'Ton auf stark lehmigen Sand (T/SL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7530,'T/Sl',  'Ton auf anlehmigen Sand (T/Sl)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7610,'LT/lS', 'Schwerer Lehm auf lehmigen Sand (LT/lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7620,'LT/Sl', 'Schwerer Lehm auf anlehmigen Sand (LT/Sl)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7630,'LT/S',  'Schwerer Lehm auf Sand (LT/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7710,'L/Sl',  'Lehm auf anlehmigen Sand (L/Sl)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7800,'sL/S',  'Sandiger Lehm auf Sand (sL/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7120,'S/L',   'Sand auf Lehm (S/L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7140,'S/T',   'Sand auf Ton (S/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7330,'lS/T',  'Lehmiger Sand auf Ton (lS/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7520,'T/lS',  'Ton auf lehmigen Sand (T/lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7540,'T/S',   'Ton auf Sand (T/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7720,'L/S',   'Lehm auf Sand (L/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8110,'S/Mo',  'Sand auf Moor (S/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8120,'lS/Mo', 'Lehmiger Sand auf Moor (lS/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8130,'L/Mo',  'Lehm auf Moor (L/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8140,'T/Mo',  'Ton auf Moor (T/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8210,'Mo/S',  'Moor auf Sand (Mo/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8220,'Mo/lS', 'Moor auf lehmigen Sand (Mo/lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8230,'Mo/L',  'Moor auf Lehm (Mo/L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8240,'Mo/T',  'Moor auf Ton (Mo/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9120,'L+Mo',  'Bodenwechsel vom Lehm zu Moor (L+Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9130,'lSg',   'Lehmiger Sand mit starkem Steingehalt (lSg)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9140,'Lg',    'Lehm mit starkem Steingehalt (Lg)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9150,'lS+St', 'lehmiger Sand mit Steinen und Blöcken (lS+St)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9160,'L+St',  'Lehm mit Steinen und Blöcken (L+St)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9170,'St+lS', 'Steine und Blöcke mit lehmigem Sand (St+lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9180,'St+L',  'Steine und Blöcke mit Lehm (St+L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9190,'lS+Fe', 'lehmiger Sand mit Felsen (lS+Fe)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9200,'L+Fe',  'Lehm mit Felsen (L+Fe)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9210,'Fe+lS', 'Felsen mit lehmigem Sand (Fe+lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9220,'Fe+L',  'Felsen mit Lehm (Fe+L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9310,'S/lS',  'Sand auf lehmigen Sand (S/lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9320,'Sl/Me', 'Anlehmiger Sand auf Mergel (Sl/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9330,'Sl/sL', 'Anlehmiger Sand auf sandigem Lehm (Sl/sL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9340,'lS/L',  'Lehmiger Sand auf Lehm (lS/L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9350,'lS/Me', 'Lehmiger Sand auf Mergel (lS/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9360,'lS/sL', 'Lehmiger Sand auf sandigem Lehm (lS/sL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9370,'lSMe',  'Lehmiger Sand, Mergel (lSMe)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9380,'lSMo/Me','Lehmiger Sand, Moor auf Mergel (lSMo/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9390,'SlMo',  'Anlehmiger Sand, Moor (SlMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9410,'L/Me',  'Lehm auf Mergel (L/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9420,'LMo/Me','Lehm, Moor auf Mergel (LMo/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9430,'LT/Mo', 'Schwerer Lehm auf Moor (LT/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9440,'T/Me',  'Ton auf Mergel (T/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9450,'Mo/Me', 'Moor auf Mergel (Mo/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9460,'MoL/Me','Moor, Lehm auf Mergel (MoL/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9470,'MoMe',  'Moor, Mergel (MoMe)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9480,'LöD',   'LößDiluvium (LöD)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9490,'AlD',   'AlluviumDiluvium (AlD)');


-- B o d e n s c h a e t z u n g  -  Z u s t a n d s s t u f e
-- ------------------------------------------------------------

CREATE TABLE ax_bodenschaetzung_zustandsstufe (
    wert integer,
    kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_ax_bodenschaetzung_zustandsstufe  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bodenschaetzung_zustandsstufe 
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bodenschaetzung", Feld "zustandsstufe".';

COMMENT ON COLUMN ax_bodenschaetzung_zustandsstufe.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_bodenschaetzung_zustandsstufe.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN ax_bodenschaetzung_zustandsstufe.bezeichner IS 'Lange Bezeichnung';

INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1100,'1','Zustandsstufe (1)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1200,'2','Zustandsstufe (2)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1300,'3','Zustandsstufe (3)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1400,'4','Zustandsstufe (4)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1500,'5','Zustandsstufe (5)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1600,'6','Zustandsstufe (6)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1700,'7','Zustandsstufe (7)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1800,'-','Zustandsstufe Misch- und Schichtböden sowie künstlichveränderte Böden (-)');

INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (2100,'I','Bodenstufe (I)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (2200,'II','Bodenstufe (II)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (2300,'III','Bodenstufe (III)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (2400,'-','Bodenstufe Misch- und Schichtböden sowie künstlich veränderte Böden (-)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (3100,'II+III','Bodenstufe (II+III)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (3200,'(III)','Bodenstufe ("(III)")');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (3300,'IV','Bodenstufe (IV)');


-- B o d e n s c h a e t z u n g   -  Muster-, Landesmuster- und Vergleichsstueck
-- ------------------------------------------------------------------------------
CREATE TABLE ax_musterlandesmusterundvergleichsstueck_merkmal (
    wert integer,
    kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_ax_musterstueck_merkmal  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_musterlandesmusterundvergleichsstueck_merkmal 
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_musterlandesmusterundvergleichsstueck", Feld "merkmal".';

COMMENT ON COLUMN ax_musterlandesmusterundvergleichsstueck_merkmal.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_musterlandesmusterundvergleichsstueck_merkmal.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN ax_musterlandesmusterundvergleichsstueck_merkmal.bezeichner IS 'Lange Bezeichnung';

INSERT INTO ax_musterlandesmusterundvergleichsstueck_merkmal (wert, kurz, bezeichner) VALUES (1000,'M','Musterstück (M)');
INSERT INTO ax_musterlandesmusterundvergleichsstueck_merkmal (wert, kurz, bezeichner) VALUES (2000,'L','Landesmusterstück (L)');
INSERT INTO ax_musterlandesmusterundvergleichsstueck_merkmal (wert, kurz, bezeichner) VALUES (3000,'V','Vergleichsstück (V)');


-- B o d e n s c h a e t z u n g  -  Grabloch der Bodenschaetzung
-- --------------------------------------------------------------

CREATE TABLE ax_grablochderbodenschaetzung_bedeutung (
    wert integer,
    bezeichner character varying,
    CONSTRAINT pk_ax_grabloch_bedeutung  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_grablochderbodenschaetzung_bedeutung
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_grablochderbodenschaetzung", Feld "bedeutung".';

COMMENT ON COLUMN ax_grablochderbodenschaetzung_bedeutung.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_grablochderbodenschaetzung_bedeutung.bezeichner IS 'Lange Bezeichnung';

INSERT INTO ax_grablochderbodenschaetzung_bedeutung (wert, bezeichner) VALUES (1100, 'Grabloch, bestimmend, lagerichtig (innerhalb der Fläche)');
INSERT INTO ax_grablochderbodenschaetzung_bedeutung (wert, bezeichner) VALUES (1200, 'Grabloch, bestimmend, lagerichtig (außerhalb des Abschnitts)');
INSERT INTO ax_grablochderbodenschaetzung_bedeutung (wert, bezeichner) VALUES (1300, 'Grabloch, nicht lagerichtig, im Abschnitt nicht vorhanden');
INSERT INTO ax_grablochderbodenschaetzung_bedeutung (wert, bezeichner) VALUES (2000, 'Grabloch für Muster-, Landesmuster-, Vergleichsstück');
INSERT INTO ax_grablochderbodenschaetzung_bedeutung (wert, bezeichner) VALUES (3000, 'Grabloch, nicht bestimmend');


-- B o d e n s c h a e t z u n g   -  Entstehungsart oder Klimastufe / Wasserverhaeltnisse
-- ----------------------------------------------------------------------------------------
--DROP TABLE ax_bodenschaetzung_entstehungsartoderklimastufe;
CREATE TABLE ax_bodenschaetzung_entstehungsartoderklimastufe (
    wert integer,
    kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_ax_bodenschaetzung_entstehung PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bodenschaetzung_entstehungsartoderklimastufe
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bodenschaetzung", Feld "entstehungsartoderklimastufe".';

COMMENT ON COLUMN ax_bodenschaetzung_entstehungsartoderklimastufe.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_bodenschaetzung_entstehungsartoderklimastufe.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN ax_bodenschaetzung_entstehungsartoderklimastufe.bezeichner IS 'Lange Bezeichnung';


INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1000,'D',   'Diluvium (D)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1100,'DAl', 'Diluvium über Alluvium (DAl)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1200,'DLö', 'Diluvium über Löß (DLö)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1300,'DV',  'Diluvium über Verwitterung (DV)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1400,'Dg',  'Diluvium, gesteinig (Dg)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1410,'DgAl','Diluvium, gesteinig über Alluvium (DgAl)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1420,'DgLö','Diluvium, gesteinig über Löß (DgLö)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1430,'DgV', 'Diluvium, gesteinig über Verwitterung (DgV)');

INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2000,'Lö',  'Löß (Lö)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2100,'LöD', 'Löß über Diluvium (LöD)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2110,'LöDg','Löß, Diluvium, Gesteinsböden (LöDg)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2120,'LöDV','Löß, Diluvium, Verwitterung (LöDV)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2200,'LöAl','Löß über Alluvium (LöAl)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2300,'LöV', 'Löß über Verwitterung (LöV)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2310,'LöVg','Löß, Verwitterung, Gesteinsböden (LöVg)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2400,'LöVg','Löß über Verwitterung, gesteinig (LöVg)');

INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3000,'Al',  'Alluvium (Al)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3100,'AlD', 'Alluvium über Diluvium (AlD)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3200,'AlLö','Alluvium über Löß (AlLö)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3300,'AlV', 'Alluvium über Verwitterung (AlV)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3400,'Alg', 'Alluvium, gesteinig (Alg)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3410,'AlgD','Alluvium, gesteinig über Diluvium (AlgD)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3420,'AlgLö','Alluvium, gesteinig über Löß (AlgLö)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3430,'AlgV','Alluvium, gesteinig über Verwitterung (AlgV)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3500,'AlMa','Alluvium, Marsch (AlMa)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3610,'AlMo','Alluvium, Moor (AlMo)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3620,'MoAI','Moor, Alluvium (MoAI)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3700,'Me',  'Mergel (Me)');

INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(4000,'V',   'Verwitterung (V)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(4100,'VD',  'Verwitterung über Diluvium (VD)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(4200,'VAl', 'Verwitterung über Alluvium (VAl)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(4300,'VLö', 'Verwitterung über Löß (VLö)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(4400,'Vg',  'Verwitterung, Gesteinsböden (Vg)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(4410,'VgD', 'Verwitterung, Gesteinsböden über Diluvium (VgD)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(5000,'-',   'Entstehungsart nicht erkennbar (-)');

INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(6100,'a',   'Klimastufe 8° C und darüber (a)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(6200,'b',   'Klimastufe 7,9° - 7,0° C (b)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(6300,'c',   'Klimastufe 6,9° - 5,7° C (c)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(6400,'d',   'Klimastufe 5,6° C und darunter (d)');

INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7100,'1',   'Wasserstufe (1)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7200,'2',   'Wasserstufe (2)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7300,'3',   'Wasserstufe (3)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7400,'4',   'Wasserstufe (4)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7410,'4-',  'Wasserstufe (4-)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7500,'5',   'Wasserstufe (5)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7510,'5-',  'Wasserstufe (5-)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7520,'3-',  'Wasserstufe (3-)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7530,'3+4', 'Wasserstufe (3+4)');


-- B o d e n s c h a e t z u n g   -  sonstige Angaben
-- ----------------------------------------------------------------------------------------
--DROP TABLE ax_bodenschaetzung_sonstigeangaben;
CREATE TABLE ax_bodenschaetzung_sonstigeangaben (
    wert integer,
    kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_ax_bodenschaetzung_sonst PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bodenschaetzung_sonstigeangaben
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bodenschaetzung", Feld "sonstigeangaben".';

COMMENT ON COLUMN ax_bodenschaetzung_sonstigeangaben.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_bodenschaetzung_sonstigeangaben.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN ax_bodenschaetzung_sonstigeangaben.bezeichner IS 'Lange Bezeichnung';

INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(1100,'Wa+',   'Nass, zu viel Wasser (Wa+)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(1200,'Wa-',   'Trocken, zu wenig Wasser (Wa-)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(1300,'Wa gt', 'Besonders günstige Wasserverhältnisse (Wa gt)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(1400,'RiWa',  'Rieselwasser, künstliche Bewässerung (RiWa)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(2100,'W',     'Unbedingtes Wiesenland (W)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(2200,'Str',   'Streuwiese (Str) ');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(2300,'Hu',    'Hutung (Hu)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(2400,'A-Hack','Acker-Hackrain (A-Hack)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(2500,'Gr-Hack','Grünland-Hackrain (Gr-Hack)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(2600,'G',     'Garten (G)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(3000,'N',     'Neukultur (N)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(4000,'T',     'Tiefkultur (T) ');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(5000,'Ger',   'Geringstland (Ger)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(9000,'',      'Nachschätzung erforderlich ');

-- Testfall dazu finden:
-- SELECT gml_id, sonstigeangaben, x(st_Centroid(wkb_geometry)) AS x, y(st_Centroid(wkb_geometry)) AS y 
--  FROM ax_bodenschaetzung WHERE NOT sonstigeangaben[1] IS NULL LIMIT 10; -- NOT sonstigeangaben[2] IS NULL


-- B e w e r t u n g  - Klassifizierung
-- ----------------------------------------------------------------------------------------
--DROP TABLE ax_bewertung_klassifizierung;
CREATE TABLE ax_bewertung_klassifizierung (
    wert integer,
    bezeichner character varying,
	erklaer character varying,
    CONSTRAINT pk_ax_bewertung_klass PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bewertung_klassifizierung
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bewertung", Feld "klassifizierung".';

COMMENT ON COLUMN ax_bewertung_klassifizierung.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_bewertung_klassifizierung.bezeichner IS 'Lange Bezeichnung';
COMMENT ON COLUMN ax_bewertung_klassifizierung.erklaer    IS 'ggf. weitere Erlärung';


INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1100, 'Unbebautes Grundstück', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1120, 'Unbebautes Grundstück mit Gebäude von untergeordneter Bedeutung ', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1130, 'Unbebautes Grundstück mit einem dem Verfall preisgegebenen Gebäude', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1140, 'Unbebautes Grundstück für Erholungs- und Freizeitzwecke', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1210, 'Einfamilienhausgrundstück', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1220, 'Zweifamilienhausgrundstück', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1230, 'Mietwohngrundstück', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1240, 'Gemischtgenutztes Grundstück', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1250, 'Geschäftsgrundstück', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1260, 'Sonstiges bebautes Grundstück', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1310, 'Einfamilienhaus auf fremdem Grund und Boden', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1320, 'Zweifamilienhaus auf fremdem Grund und Boden', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1330, 'Mietwohngrundstück, Mietwohngebäude auf fremdem Grund und Boden', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1340, 'Gemischtgenutztes Grundstück, gemischtgenutztes Gebäude auf fremdem Grund und Boden ', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1350, 'Geschäftsgrundstück, Geschäftsgebäude auf fremdem Grund und Boden', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1360, 'Sonstige bebaute Grundstücke, sonstige Gebäude auf fremdem Grund und Boden', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2110, 'Landwirtschaftliche Nutzung', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2120, 'Hopfen', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2130, 'Spargel', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2190, 'Sonstige Sonderkulturen', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2200, 'Holzung', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2300, 'Weingarten (allgemein)', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2310, 'Weingarten 1', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2320, 'Weingarten 2', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2330, 'Weingarten 3', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2340, 'Weingarten 4', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2350, 'Weingarten 5', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2360, 'Weingarten 6', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2370, 'Weingarten 7', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2380, 'Weingarten 8', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2390, 'Weingarten 9', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2410, 'Gartenland', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2420, 'Obstplantage', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2430, 'Baumschule', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2440, 'Anbaufläche unter Glas ', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2450, 'Kleingarten', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2510, 'Weihnachtsbaumkultur', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2520, 'Saatzucht', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2530, 'Teichwirtschaft', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2610, 'Abbauland der Land- und Forstwirtschaft ', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2620, 'Geringstland', '"Geringstland" sind Flächen geringster Ertragsfähigkeit ohne Wertzahlen nach dem Bodenschätzungsgesetz, das sind unkultivierte Moor- und Heideflächen (sofern nicht gesondert geführt), ehemals bodengeschätzte Flächen und ehemalige Weinbauflächen, die ihren Kulturzustand verloren haben.');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2630, 'Unland',   '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2640, 'Moor',     '"Moor" ist eine unkultivierte Fläche mit einer (mindestens 20 cm starken) Auflage aus vertorften und vermoorten Pflanzenresten, soweit sie nicht als Torfstich benutzt wird.');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2650, 'Heide',    '"Heide" ist eine unkultivierte, sandige, überwiegend mit Heidekraut oder Ginster bewachsene Fläche.');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2700, 'Reet',     '"Reet" ist eine ständig oder zeitweise unter Wasser stehende und mit Reet bewachsene Fläche.');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2710, 'Reet I',   'Reetfläche, deren Nutzung eingestuft ist in Güteklasse I (gut).');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2720, 'Reet II',  'Reetfläche, deren Nutzung eingestuft ist in Güteklasse II (mittel).');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2730, 'Reet III', 'Reetfläche, deren Nutzung eingestuft ist in Güteklasse III (gering).');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2800, 'Nebenfläche des Betriebs der Land- und Forstwirtschaft', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2899, 'Noch nicht klassifiziert', '');


-- F o r s t r e c h t  -  A r t   d e r   F e s t l e g u n g
-- -----------------------------------------------------------

CREATE TABLE ax_forstrecht_artderfestlegung (
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


-- ax_klassifizierungnachstrassenrecht_artdf
-- -------------------------
-- Datentyp:
CREATE TABLE ax_klassifizierungnachstrassenrecht_artdf (
wert integer, 
bezeichner character varying,  
kennung integer, objektart character varying);

COMMENT ON TABLE ax_klassifizierungnachstrassenrecht_artdf
IS 'artderfestlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_klassifizierungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Klassifizierung nach Bundes- oder Landesstraßengesetz',1100);
INSERT INTO ax_klassifizierungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Bundesautobahn',1110);
INSERT INTO ax_klassifizierungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Bundesstraße',1120);
INSERT INTO ax_klassifizierungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Landes- oder Staatsstraße',1130);
INSERT INTO ax_klassifizierungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Kreisstraße',1140);
INSERT INTO ax_klassifizierungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Gemeindestraße',1150);
INSERT INTO ax_klassifizierungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Ortsstraße',1160);
INSERT INTO ax_klassifizierungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Gemeindeverbindungsstraße',1170);
INSERT INTO ax_klassifizierungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Sonstige öffentliche Straße',1180);
INSERT INTO ax_klassifizierungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Privatstraße',1190);


-- ax_klassifizierungnachwasserrecht_artdf
-- -------------------------
-- Datentyp:
CREATE TABLE ax_klassifizierungnachwasserrecht_artdf (
wert integer, 
bezeichner character varying,  
kennung integer, objektart character varying);

COMMENT ON TABLE ax_klassifizierungnachwasserrecht_artdf
IS 'artderfestlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_klassifizierungnachwasserrecht_artdf (bezeichner, wert) VALUES ('Klassifizierung nach Bundes- oder Landeswassergesetz',1300);
INSERT INTO ax_klassifizierungnachwasserrecht_artdf (bezeichner, wert) VALUES ('Gewässer I. Ordnung - Bundeswasserstraße',1310);
INSERT INTO ax_klassifizierungnachwasserrecht_artdf (bezeichner, wert) VALUES ('Gewässer I. Ordnung - nach Landesrecht',1320);
INSERT INTO ax_klassifizierungnachwasserrecht_artdf (bezeichner, wert) VALUES ('Gewässer II. Ordnung',1330);
INSERT INTO ax_klassifizierungnachwasserrecht_artdf (bezeichner, wert) VALUES ('Gewässer III. Ordnung',1340);


-- ax_anderefestlegungnachstrassenrecht_artdf
-- -------------------------
-- Datentyp:
CREATE TABLE ax_anderefestlegungnachstrassenrecht_artdf (
wert integer, 
bezeichner character varying,  
kennung integer, objektart character varying);

COMMENT ON TABLE ax_anderefestlegungnachstrassenrecht_artdf
IS 'artderfestlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_anderefestlegungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Bundesfernstraßengesetz',1210);
INSERT INTO ax_anderefestlegungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Anbauverbot',1220);
INSERT INTO ax_anderefestlegungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Anbauverbot nach Bundesfernstraßengesetz',1230);
INSERT INTO ax_anderefestlegungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Anbauverbot (40m)',1231);
INSERT INTO ax_anderefestlegungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Anbauverbot (20m)',1232);
INSERT INTO ax_anderefestlegungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Anbaubeschränkung',1240);
INSERT INTO ax_anderefestlegungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Anbaubeschränkung (100m)',1241);
INSERT INTO ax_anderefestlegungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Anbaubeschränkung (40m)',1242);
INSERT INTO ax_anderefestlegungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Veränderungssperre nach Bundesfernstraßengesetz',1250);
INSERT INTO ax_anderefestlegungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Landesstraßengesetz',1260);
INSERT INTO ax_anderefestlegungnachstrassenrecht_artdf (bezeichner, wert) VALUES ('Veränderungssperre',1280);


-- ax_anderefestlegungnachstrassenrecht_artdf
-- -------------------------
-- Datentyp:
CREATE TABLE ax_naturumweltoderbodenschutzrecht_artdf (
wert integer, 
bezeichner character varying,  
kennung integer, objektart character varying);

COMMENT ON TABLE ax_naturumweltoderbodenschutzrecht_artdf
IS 'artderfestlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Schutzfläche nach Europarecht',610);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Flora-Fauna-Habitat-Gebiet',611);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Vogelschutzgebiet',612);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Schutzflächen nach Landesnaturschutzgesetz',620);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Naturschutzgebiet',621);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Geschützter Landschaftsbestandteil',622);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Landschaftsschutzgebiet',623);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Naturpark',624);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Bundesbodenschutzgesetz',630);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Verdachtsfläche auf schädliche Bodenveränderung',631);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Schädliche Bodenveränderung',632);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Altlastenverdächtige Fläche',633);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Altlast',634);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Bundesimmisionsschutzgesetz',640);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Belastungsgebiet',641);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Schutzbedürftiges Gebiet',642);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Gefährdetes Gebiet',643);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Naturschutzgesetz',650);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Besonders geschütztes Biotop',651);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Besonders geschütztes Feuchtgrünland',652);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Naturdenkmal',653);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Einstweilige Sicherstellung, Veränderungssperre',654);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Vorkaufsrecht',655);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Ausgleichs- oder Kompensationsfläche',656);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Bodenschutzgesetz',660);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Dauerbeobachtungsflächen',661);
INSERT INTO ax_naturumweltoderbodenschutzrecht_artdf (bezeichner, wert) VALUES ('Bodenschutzgebiet',662);


-- ax_denkmalschutzrecht_artdf
-- -------------------------
-- Datentyp:
CREATE TABLE ax_denkmalschutzrecht_artdf (
wert integer, 
bezeichner character varying,  
kennung integer, objektart character varying);

COMMENT ON TABLE ax_denkmalschutzrecht_artdf
IS 'artderfestlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Kulturdenkmal',2700);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Bau- und Kunstdenkmal nach Landesdenkmalschutzgesetz',2710);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Baudenkmal',2711);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Kunstdenkmal',2712);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Gartendenkmal',2713);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Archäologisches Denkmal (auch Bodendenkmal) nach Landesdenkmalschutzgesetz',2800);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Archäologisches Denkmal',2810);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Bodendenkmal',2820);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Schutzgebiet oder -bereiche nach Landesdenkmalschutzgesetz',2900);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Denkmalzone oder -bereich',2910);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Geschützter Baubereich',2920);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Grabungsschutzgebiet',2930);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Befestigungen',3100);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Befestigung (Burg)',3110);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Burg (Fliehburg, Ringwall)',3111);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Erdwerk',3112);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Ringwall',3113);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Steinwerk',3114);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Festung',3115);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Gräftenanlage',3116);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Schanze',3117);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Lager',3118);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Wachturm (römisch), Warte',3120);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Wachturm',3121);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Warte',3122);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Befestigung (Wall, Graben)',3130);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Grenzwall, Schutzwall',3131);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Limes',3132);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Landwehr',3133);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Stadtwall',3134);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historischer Wall',3135);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historische Siedlung',3200);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Pfahlbau',3210);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Wüstung',3220);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Wurt',3230);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Abri',3240);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Höhle',3250);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historische Bestattung',3300);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Großsteingrab (Dolmen, Hünenbett)',3310);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Grabhügel',3320);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Grabhügelfeld',3330);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Urnenfriedhof',3340);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Körpergräberfeld',3350);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Reihengräberfriedhof',3360);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historisches land- oder forstwirtschaftliches Objekt',3400);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historischer Pflanzkamp',3410);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historisches Viehgehege',3420);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Sandfang',3430);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historisches Ackersystem',3440);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historische Bergbau-, Verhüttungs- oder sonstige Produktionsstätte',3500);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historisches Bergbaurelikt',3510);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historischer Meiler',3520);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historischer Ofen',3530);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historischer Verhüttungsplatz',3540);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historische Straße oder Weg',3600);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Heerstraße',3610);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Hohlweg',3620);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Moorweg',3630);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Wegespur',3640);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historisches wasserwirtschaftliches Objekt',3700);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historische Wasserleitung',3710);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Aquädukt',3720);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historischer Deich',3730);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historischer Damm',3740);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historischer Graben',3750);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Steinmal',3800);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Schalenstein',3810);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Rillenstein',3820);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Wetzrillen',3830);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Kreuzstein',3840);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Historischer Grenzstein',3850);
INSERT INTO ax_denkmalschutzrecht_artdf (bezeichner, wert) VALUES ('Menhir',3860);


-- ax_sonstigesrecht_artdf
-- -------------------------
-- Datentyp:
CREATE TABLE ax_sonstigesrecht_artdf (
wert integer, 
bezeichner character varying,  
kennung integer, objektart character varying);

COMMENT ON TABLE ax_sonstigesrecht_artdf
IS 'artderfestlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Luftverkehrsgesetz',4100);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Bauschutzbereich',4110);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Beschränkter Bauschutzbereich',4120);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Bundeskleingartengesetz',4200);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Dauerkleingarten',4210);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Berggesetz',4300);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Bodenbewegungsgebiet',4301);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Bruchfeld',4302);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Baubeschränkung',4310);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Reichsheimstättengesetz',4400);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Reichsheimstätte',4410);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Schutzbereichsgesetz',4500);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Schutzbereich',4510);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Eisenbahnneuordnungsgesetz',4600);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Übergabebescheidverfahren',4610);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Baubeschränkungen durch Richtfunkverbindungen',4710);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Truppenübungsplatz, Standortübungsplatz',4720);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Vermessungs- und Katasterrecht',4800);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Schutzfläche Festpunkt',4810);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 1 m Radius',4811);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 2 m Radius',4812);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 5 m Radius',4813);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 10 m Radius',4814);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 30 m Radius',4815);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Marksteinschutzfläche',4820);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Liegenschaftskatastererneuerung',4830);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Fischereirecht',4900);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Jagdkataster',5100);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Landesgrundbesitzkataster',5200);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Bombenblindgängerverdacht',5300);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Rieselfeld',5400);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Sicherungsstreifen',5500);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Grenzbereinigung',5600);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Hochwasserdeich',5700);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Hauptdeich, 1. Deichlinie',5710);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('2. Deichlinie',5720);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Beregnungsverband',6000);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Weinlage',7000);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Weinbausteillage',7100);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Weinbergsrolle',7200);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Weinbausteilstlage',7300);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Benachteiligtes landwirtschaftliches Gebiet',8000);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Mitverwendung Hochwasserschutz, Oberirdische Anlagen',9100);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Mitverwendung Hochwasserschutz, Unterirdische Anlagen',9200);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Hafennutzungsgebiet',9300);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Hafenerweiterungsgebiet',9400);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Bohrung verfüllt',9500);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Zollgrenze',9600);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Belastung nach §7 Abs. 2 GBO',9700);
INSERT INTO ax_sonstigesrecht_artdf (bezeichner, wert) VALUES ('Sonstiges',9999);

-- ENDE --
