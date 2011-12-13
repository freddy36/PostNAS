
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
--  2010-09-16  krz f.j. Buchungsart hinzugefuegt
--  2011-07-25  PostNAS 06, Umbenennung, "grant" raus
--  2011-11-21  Mehrere neue Schlüsseltabellen zu ax_gebaeude_*, Konstanten aus Tabellen entfernt (Wozu?)


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
--  kennung     integer,            entfernt 21.11.2011, ist konstant! "31001"
--  objektart   character varying   entfernt 21.11.2011, ist konstant! "ax_gebaeude"
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
-- kennung integer, -- Konstant 21008, entfernt 21.11.2011
-- objektart character varying, -- Konstant 'ax_buchungsstelle', entfernt 21.11.2011
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

--ax_landwirtschaft_vegetationsmerkmal
-- ---------------------------------

CREATE TABLE ax_landwirtschaft_vegetationsmerkmal (
    wert            integer, 
    bezeichner  character varying,
    CONSTRAINT pk_ax_landwirtschaft_vegetationsmerkmal PRIMARY KEY (wert)
  );
COMMENT ON TABLE ax_landwirtschaft_vegetationsmerkmal 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Wird für Infoabfrage benötigt.';

INSERT INTO ax_landwirtschaft_vegetationsmerkmal (wert,bezeichner) VALUES (1100,'Ackerland');
INSERT INTO ax_landwirtschaft_vegetationsmerkmal (wert,bezeichner) VALUES (1011,'Streuobstacker');
INSERT INTO ax_landwirtschaft_vegetationsmerkmal (wert,bezeichner) VALUES (1012,'Hopfen');
INSERT INTO ax_landwirtschaft_vegetationsmerkmal (wert,bezeichner) VALUES (1013,'Spargel');
INSERT INTO ax_landwirtschaft_vegetationsmerkmal (wert,bezeichner) VALUES (1020,'Grünland');
INSERT INTO ax_landwirtschaft_vegetationsmerkmal (wert,bezeichner) VALUES (1021,'Streuobstwiese');
INSERT INTO ax_landwirtschaft_vegetationsmerkmal (wert,bezeichner) VALUES (1030,'Gartenland');
INSERT INTO ax_landwirtschaft_vegetationsmerkmal (wert,bezeichner) VALUES (1031,'Baumschule');
INSERT INTO ax_landwirtschaft_vegetationsmerkmal (wert,bezeichner) VALUES (1040,'Weingarten');
INSERT INTO ax_landwirtschaft_vegetationsmerkmal (wert,bezeichner) VALUES (1050,'Obstplantage');
INSERT INTO ax_landwirtschaft_vegetationsmerkmal (wert,bezeichner) VALUES (1051,'Obstbaumplantage');
INSERT INTO ax_landwirtschaft_vegetationsmerkmal (wert,bezeichner) VALUES (1052,'Obststrauchplantage');
INSERT INTO ax_landwirtschaft_vegetationsmerkmal (wert,bezeichner) VALUES (1200,'Brachland');


-- ax_wald_vegetationsmerkmal
-- ---------------------------------

CREATE TABLE ax_wald_vegetationsmerkmal (
    wert            integer, 
    bezeichner  character varying,
    CONSTRAINT pk_ax_wald_vegetationsmerkmal PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_wald_vegetationsmerkmal
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Wird für Infoabfrage benötigt.';

INSERT INTO ax_wald_vegetationsmerkmal (wert,bezeichner) VALUES (1100,'Laubholz');
INSERT INTO ax_wald_vegetationsmerkmal (wert,bezeichner) VALUES (1200,'Nadelholz');
INSERT INTO ax_wald_vegetationsmerkmal (wert,bezeichner) VALUES (1300,'Laub- und Nadelholz');
INSERT INTO ax_wald_vegetationsmerkmal (wert,bezeichner) VALUES (1310,'Laubwald mit Nadelholz');
INSERT INTO ax_wald_vegetationsmerkmal (wert,bezeichner) VALUES (1320,'Nadelwald mit Laubholz');
-- ENDE --
