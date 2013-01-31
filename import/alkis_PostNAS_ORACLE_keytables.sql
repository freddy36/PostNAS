-- Automatisch mit pg-to-oci_keytables.pl konvertiert.
---
---

set serveroutput on
set autocommit on
set feedback off
set verify off


DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_GEBAEUDE_BAUWEISE';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_GEBAEUDE_BAUWEISE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_GEBAEUDE_BAUWEISE (
    bauweise_id            integer, 
    bauweise_beschreibung  character varying,
    CONSTRAINT ALKIS_KEY_0 PRIMARY KEY (bauweise_id)
  );
COMMENT ON TABLE ax_gebaeude_bauweise 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_GEBAEUDE_BAUWEISE (bauweise_id, bauweise_beschreibung) VALUES (1100,'Freistehendes Einzelgebäude');
INSERT INTO AX_GEBAEUDE_BAUWEISE (bauweise_id, bauweise_beschreibung) VALUES (1200,'Freistehender Gebäudeblock');
INSERT INTO AX_GEBAEUDE_BAUWEISE (bauweise_id, bauweise_beschreibung) VALUES (1300,'Einzelgarage');
INSERT INTO AX_GEBAEUDE_BAUWEISE (bauweise_id, bauweise_beschreibung) VALUES (1400,'Doppelgarage');
INSERT INTO AX_GEBAEUDE_BAUWEISE (bauweise_id, bauweise_beschreibung) VALUES (1500,'Sammelgarage');
INSERT INTO AX_GEBAEUDE_BAUWEISE (bauweise_id, bauweise_beschreibung) VALUES (2100,'Doppelhaushälfte');
INSERT INTO AX_GEBAEUDE_BAUWEISE (bauweise_id, bauweise_beschreibung) VALUES (2200,'Reihenhaus');
INSERT INTO AX_GEBAEUDE_BAUWEISE (bauweise_id, bauweise_beschreibung) VALUES (2300,'Haus in Reihe');
INSERT INTO AX_GEBAEUDE_BAUWEISE (bauweise_id, bauweise_beschreibung) VALUES (2400,'Gruppenhaus');
INSERT INTO AX_GEBAEUDE_BAUWEISE (bauweise_id, bauweise_beschreibung) VALUES (2500,'Gebäudeblock in geschlossener Bauweise');
INSERT INTO AX_GEBAEUDE_BAUWEISE (bauweise_id, bauweise_beschreibung) VALUES (4000,'Offene Halle');

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_GEBAEUDE_FUNKTION';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_GEBAEUDE_FUNKTION CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_GEBAEUDE_FUNKTION (
    wert        integer, 
    bezeichner  character varying,
    CONSTRAINT ALKIS_KEY_1 PRIMARY KEY (wert)
   );
COMMENT ON TABLE  ax_gebaeude_funktion 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1000,'Wohngebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1010,'Wohnhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1020,'Wohnheim');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1021,'Kinderheim');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1022,'Seniorenheim');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1023,'Schwesternwohnheim');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1024,'Studenten-, Schülerwohnheim');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1025,'Schullandheim');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1100,'Gemischt genutztes Gebäude mit Wohnen');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1110,'Wohngebäude mit Gemeinbedarf');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1120,'Wohngebäude mit Handel und Dienstleistungen');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1121,'Wohn- und Verwaltungsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1122,'Wohn- und Bürogebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1123,'Wohn- und Geschäftsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1130,'Wohngebäude mit Gewerbe und Industrie');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1131,'Wohn- und Betriebsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1210,'Land- und forstwirtschaftliches Wohngebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1220,'Land- und forstwirtschaftliches Wohn- und Betriebsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1221,'Bauernhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1222,'Wohn- und Wirtschaftsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1223,'Forsthaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1310,'Gebäude zur Freizeitgestaltung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1311,'Ferienhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1312,'Wochenendhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (1313,'Gartenhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2000,'Gebäude für Wirtschaft oder Gewerbe');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2010,'Gebäude für Handel und Dienstleistungen');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2020,'Bürogebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2030,'Kreditinstitut');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2040,'Versicherung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2050,'Geschäftsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2051,'Kaufhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2052,'Einkaufszentrum');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2053,'Markthalle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2054,'Laden');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2055,'Kiosk');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2056,'Apotheke');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2060,'Messehalle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2070,'Gebäude für Beherbergung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2071,'Hotel, Motel, Pension');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2072,'Jugendherberge');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2073,'Hütte (mit Übernachtungsmöglichkeit)');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2074,'Campingplatzgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2080,'Gebäude für Bewirtung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2081,'Gaststätte, Restaurant');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2082,'Hütte (ohne Übernachtungsmöglichkeit)');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2083,'Kantine');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2090,'Freizeit- und Vergnügungsstätte');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2091,'Festsaal');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2092,'Kino');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2093,'Kegel-, Bowlinghalle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2094,'Spielkasino');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2100,'Gebäude für Gewerbe und Industrie');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2110,'Produktionsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2111,'Fabrik');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2112,'Betriebsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2113,'Brauerei');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2114,'Brennerei');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2120,'Werkstatt');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2121,'Sägewerk');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2130,'Tankstelle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2131,'Waschstraße, Waschanlage, Waschhalle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2140,'Gebäude für Vorratshaltung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2141,'Kühlhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2142,'Speichergebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2143,'Lagerhalle, Lagerschuppen, Lagerhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2150,'Speditionsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2160,'Gebäude für Forschungszwecke');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2170,'Gebäude für Grundstoffgewinnung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2171,'Bergwerk');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2172,'Saline');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2180,'Gebäude für betriebliche Sozialeinrichtung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2200,'Sonstiges Gebäude für Gewerbe und Industrie');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2210,'Mühle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2211,'Windmühle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2212,'Wassermühle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2213,'Schöpfwerk');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2220,'Wetterstation');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2310,'Gebäude für Handel und Dienstleistung mit Wohnen');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2320,'Gebäude für Gewerbe und Industrie mit Wohnen');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2400,'Betriebsgebäude zu Verkehrsanlagen (allgemein)');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2410,'Betriebsgebäude für Straßenverkehr');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2411,'Straßenmeisterei');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2412,'Wartehalle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2420,'Betriebsgebäude für Schienenverkehr');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2421,'Bahnwärterhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2422,'Lokschuppen, Wagenhalle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2423,'Stellwerk, Blockstelle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2424,'Betriebsgebäude des Güterbahnhofs');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2430,'Betriebsgebäude für Flugverkehr');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2431,'Flugzeughalle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2440,'Betriebsgebäude für Schiffsverkehr');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2441,'Werft (Halle)');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2442,'Dock (Halle)');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2443,'Betriebsgebäude zur Schleuse');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2444,'Bootshaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2450,'Betriebsgebäude zur Seilbahn');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2451,'Spannwerk zur Drahtseilbahn');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2460,'Gebäude zum Parken');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2461,'Parkhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2462,'Parkdeck');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2463,'Garage');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2464,'Fahrzeughalle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2465,'Tiefgarage');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2500,'Gebäude zur Versorgung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2501,'Gebäude zur Energieversorgung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2510,'Gebäude zur Wasserversorgung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2511,'Wasserwerk');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2512,'Pumpstation');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2513,'Wasserbehälter');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2520,'Gebäude zur Elektrizitätsversorgung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2521,'Elektrizitätswerk');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2522,'Umspannwerk');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2523,'Umformer');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2527,'Reaktorgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2528,'Turbinenhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2529,'Kesselhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2540,'Gebäude für Fernmeldewesen');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2560,'Gebäude an unterirdischen Leitungen');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2570,'Gebäude zur Gasversorgung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2571,'Gaswerk');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2580,'Heizwerk');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2590,'Gebäude zur Versorgungsanlage');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2591,'Pumpwerk (nicht für Wasserversorgung)');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2600,'Gebäude zur Entsorgung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2610,'Gebäude zur Abwasserbeseitigung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2611,'Gebäude der Kläranlage');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2612,'Toilette');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2620,'Gebäude zur Abfallbehandlung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2621,'Müllbunker');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2622,'Gebäude zur Müllverbrennung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2623,'Gebäude der Abfalldeponie');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2700,'Gebäude für Land- und Forstwirtschaft');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2720,'Land- und forstwirtschaftliches Betriebsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2721,'Scheune');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2723,'Schuppen');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2724,'Stall');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2726,'Scheune und Stall');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2727,'Stall für Tiergroßhaltung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2728,'Reithalle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2729,'Wirtschaftsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2732,'Almhütte');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2735,'Jagdhaus, Jagdhütte');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2740,'Treibhaus, Gewächshaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2741,'Treibhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (2742,'Gewächshaus, verschiebbar');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3000,'Gebäude für öffentliche Zwecke');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3010,'Verwaltungsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3011,'Parlament');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3012,'Rathaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3013,'Post');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3014,'Zollamt');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3015,'Gericht');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3016,'Botschaft, Konsulat');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3017,'Kreisverwaltung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3018,'Bezirksregierung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3019,'Finanzamt');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3020,'Gebäude für Bildung und Forschung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3021,'Allgemein bildende Schule');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3022,'Berufsbildende Schule');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3023,'Hochschulgebäude (Fachhochschule, Universität)');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3024,'Forschungsinstitut');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3030,'Gebäude für kulturelle Zwecke');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3031,'Schloss');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3032,'Theater, Oper');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3033,'Konzertgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3034,'Museum');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3035,'Rundfunk, Fernsehen');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3036,'Veranstaltungsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3037,'Bibliothek, Bücherei');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3038,'Burg, Festung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3040,'Gebäude für religiöse Zwecke');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3041,'Kirche');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3042,'Synagoge');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3043,'Kapelle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3044,'Gemeindehaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3045,'Gotteshaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3046,'Moschee');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3047,'Tempel');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3048,'Kloster');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3050,'Gebäude für Gesundheitswesen');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3051,'Krankenhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3052,'Heilanstalt, Pflegeanstalt, Pflegestation');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3053,'Ärztehaus, Poliklinik');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3060,'Gebäude für soziale Zwecke');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3061,'Jugendfreizeitheim');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3062,'Freizeit-, Vereinsheim, Dorfgemeinschafts-, Bürgerhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3063,'Seniorenfreizeitstätte');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3064,'Obdachlosenheim');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3065,'Kinderkrippe, Kindergarten, Kindertagesstätte');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3066,'Asylbewerberheim');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3070,'Gebäude für Sicherheit und Ordnung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3071,'Polizei');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3072,'Feuerwehr');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3073,'Kaserne');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3074,'Schutzbunker');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3075,'Justizvollzugsanstalt');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3080,'Friedhofsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3081,'Trauerhalle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3082,'Krematorium');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3090,'Empfangsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3091,'Bahnhofsgebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3092,'Flughafengebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3094,'Gebäude zum U-Bahnhof');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3095,'Gebäude zum S-Bahnhof');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3097,'Gebäude zum Busbahnhof');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3098,'Empfangsgebäude Schifffahrt');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3100,'Gebäude für öffentliche Zwecke mit Wohnen');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3200,'Gebäude für Erholungszwecke');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3210,'Gebäude für Sportzwecke');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3211,'Sport-, Turnhalle');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3212,'Gebäude zum Sportplatz');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3220,'Badegebäude');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3221,'Hallenbad');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3222,'Gebäude im Freibad');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3230,'Gebäude im Stadion');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3240,'Gebäude für Kurbetrieb');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3241,'Badegebäude für medizinische Zwecke');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3242,'Sanatorium');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3260,'Gebäude im Zoo');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3261,'Empfangsgebäude des Zoos');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3262,'Aquarium, Terrarium, Voliere');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3263,'Tierschauhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3264,'Stall im Zoo');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3270,'Gebäude im botanischen Garten');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3271,'Empfangsgebäude des botanischen Gartens');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3272,'Gewächshaus (Botanik)');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3273,'Pflanzenschauhaus');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3280,'Gebäude für andere Erholungseinrichtung');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3281,'Schutzhütte');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (3290,'Touristisches Informationszentrum');
INSERT INTO AX_GEBAEUDE_FUNKTION (wert, bezeichner) VALUES (9998,'Nach Quellenlage nicht zu spezifizieren');

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_GEBAEUDE_WEITEREFUNKTION';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_GEBAEUDE_WEITEREFUNKTION CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_GEBAEUDE_WEITEREFUNKTION (
    wert        integer,
    bezeichner  character varying,
    CONSTRAINT ALKIS_KEY_2 PRIMARY KEY (wert)
   );
COMMENT ON TABLE  ax_gebaeude_weiterefunktion 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1000, 'Bankfiliale');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1010, 'Hotel');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1020, 'Jugendherberge');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1030, 'Gaststätte');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1040, 'Kino');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1050, 'Spielkasino');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1060, 'Tiefgarage');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1070, 'Parkdeck');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1080, 'Toilette');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1090, 'Post');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1100, 'Zoll');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1110, 'Theater');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1120, 'Museum');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1130, 'Bibliothek');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1140, 'Kapelle');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1150, 'Moschee');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1160, 'Tempel');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1170, 'Apotheke');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1180, 'Polizeiwache');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1190, 'Rettungsstelle');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1200, 'Touristisches Informationszentrum');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1210, 'Kindergarten');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1220, 'Arztpraxis');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1230, 'Supermarkt');
INSERT INTO AX_GEBAEUDE_WEITEREFUNKTION (wert, bezeichner) VALUES (1240, 'Geschäft');

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_GEBAEUDE_DACHFORM';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_GEBAEUDE_DACHFORM CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_GEBAEUDE_DACHFORM 
   (wert        integer, 
    bezeichner  character varying,
    CONSTRAINT ALKIS_KEY_3 PRIMARY KEY (wert)
   );
COMMENT ON TABLE  ax_gebaeude_dachform 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (1000, 'Flachdach');
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (2100, 'Pultdach');
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (2200, 'Versetztes Pultdach');
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (3100, 'Satteldach');
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (3200, 'Walmdach');
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (3300, 'Krüppelwalmdach');
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (3400, 'Mansardendach');
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (3500, 'Zeltdach');
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (3600, 'Kegeldach');
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (3700, 'Kuppeldach');
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (3800, 'Sheddach');
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (3900, 'Bogendach');
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (4000, 'Turmdach');
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (5000, 'Mischform');
INSERT INTO AX_GEBAEUDE_DACHFORM (wert, bezeichner) VALUES (9999, 'Sonstiges');

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_GEBAEUDE_ZUSTAND';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_GEBAEUDE_ZUSTAND CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_GEBAEUDE_ZUSTAND 
   (wert        integer, 
    bezeichner  character varying,
    CONSTRAINT ALKIS_KEY_4 PRIMARY KEY (wert)
   );
COMMENT ON TABLE  ax_gebaeude_zustand 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_GEBAEUDE_ZUSTAND (wert, bezeichner) VALUES (1000, 'In behelfsmäßigem Zustand');
INSERT INTO AX_GEBAEUDE_ZUSTAND (wert, bezeichner) VALUES (2000, 'In ungenutztem Zustand');
INSERT INTO AX_GEBAEUDE_ZUSTAND (wert, bezeichner) VALUES (2100, 'Außer Betrieb, stillgelegt, verlassen');
INSERT INTO AX_GEBAEUDE_ZUSTAND (wert, bezeichner) VALUES (2200, 'Verfallen, zerstört');
INSERT INTO AX_GEBAEUDE_ZUSTAND (wert, bezeichner) VALUES (2300, 'Teilweise zerstört');
INSERT INTO AX_GEBAEUDE_ZUSTAND (wert, bezeichner) VALUES (3000, 'Geplant und beantragt');
INSERT INTO AX_GEBAEUDE_ZUSTAND (wert, bezeichner) VALUES (4000, 'Im Bau');

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_BUCHUNGSSTELLE_BUCHUNGSART';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_BUCHUNGSSTELLE_BUCHUNGSART CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_BUCHUNGSSTELLE_BUCHUNGSART (
   wert integer,
   bezeichner character varying,
   CONSTRAINT ALKIS_KEY_5 PRIMARY KEY (wert)
  );
COMMENT ON TABLE  ax_buchungsstelle_buchungsart 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (1100,'Grundstück');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (1101,'Aufgeteiltes Grundstück WEG');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (1102,'Aufgeteiltes Grundstück Par. 3 Abs. 4 GBO');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (1200,'Ungetrennter Hofraum');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (1301,'Wohnungs-/Teileigentum');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (1302,'Miteigentum Par. 3 Abs. 4 GBO');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (1303,'Anteil am ungetrennten Hofraum');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (1401,'Aufgeteilter Anteil Wohnungs-/Teileigentum');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (1402,'Aufgeteilter Anteil Miteigentum Par. 3 Abs. 4 GBO');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (1403,'Aufgeteilter Anteil am ungetrennten Hofraum');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (1501,'Anteil an Wohnungs-/Teileigentumsanteil');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (1502,'Anteil an Miteigentumsanteil Par. 3 Abs. 4 GBO');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (1503,'Anteil am Anteil zum ungetrennten Hofraum');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2101,'Erbbaurecht');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2102,'Untererbbaurecht');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2103,'Gebäudeeigentum');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2104,'Fischereirecht');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2105,'Bergwerksrecht');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2106,'Nutzungsrecht');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2107,'Realgewerberecht');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2108,'Gemeinderecht');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2109,'Stavenrecht');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2110,'Hauberge');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2201,'Aufgeteiltes Erbbaurecht WEG');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2202,'Aufgeteiltes Untererbbaurecht WEG');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2203,'Aufgeteiltes Recht Par. 3 Abs. 4 GBO');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2204,'Aufgeteiltes Recht, Körperschaft');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2205,'Aufgeteiltes Gebäudeeigentum');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2301,'Wohnungs-/Teilerbbaurecht');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2302,'Wohnungs-/Teiluntererbbaurecht');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2303,'Erbbaurechtsanteil Par. 3 Abs. 4 GBO');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2304,'Anteiliges Recht, Körperschaft');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2305,'Anteil am Gebäudeeigentum');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2401,'Aufgeteilter Anteil Wohnungs-/Teilerbbaurecht');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2402,'Aufgeteilter Anteil Wohnungs-/Teiluntererbbaurecht');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2403,'Aufgeteilter Erbbaurechtsanteil Par. 3 Abs. 4 GBO');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2404,'Aufgeteiltes anteiliges Recht, Körperschaft');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2405,'Aufgeteilter Anteil am Gebäudeeigentum');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2501,'Anteil am Wohnungs-/Teilerbbaurechtsanteil');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2502,'Anteil am Wohnungs-/Teiluntererbbaurechtsanteil');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2503,'Anteil am Erbbaurechtsanteil Par. 3 Abs. 4 GBO');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2504,'Anteil am anteiligen Recht, Körperschaft');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (2505,'Anteil am Anteil zum Gebäudeeigentum');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (3100,'Vermerk subjektiv dinglicher Rechte (Par. 9 GBO)');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (4100,'Stockwerkseigentum');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (5101,'Von Buchungspflicht befreit Par. 3 Abs. 2 GBO');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (5200,'Anliegerflurstück');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (5201,'Anliegerweg');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (5202,'Anliegergraben');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (5203,'Anliegerwasserlauf, Anliegergewässer');
INSERT INTO AX_BUCHUNGSSTELLE_BUCHUNGSART (wert, bezeichner) VALUES (6101,'Nicht gebuchtes Fischereirecht');

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_BAURAUMODERBODENORDNUNGSREC';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_BAURAUMODERBODENORDNUNGSREC CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_BAURAUMODERBODENORDNUNGSREC 
  (wert        integer, 
   bezeichner  character varying,
   CONSTRAINT ALKIS_KEY_6 PRIMARY KEY (wert)
  );
COMMENT ON TABLE  AX_BAURAUMODERBODENORDNUNGSREC 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1700,'Festlegung nach Baugesetzbuch - Allgemeines Städtebaurecht');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1710,'Bebauungsplan');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1720,'Veränderungssperre nach Baugesetzbuch');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1730,'Vorkaufrechtssatzung');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1740,'Enteignungsverfahren');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1750,'Umlegung nach dem BauGB');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1760,'Bauland');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1770,'Vereinfachte Umlegung');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1780,'Vorhaben- und Erschließungsplan');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1790,'Flächennutzungsplan');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1800,'Festlegung nach Baugesetzbuch - Besonderes Städtebaurecht');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1810,'Städtebauliche Entwicklungsmaßnahme');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1811,'Städtebauliche Entwicklungsmaßnahme (Beschluss zu vorbereitenden Untersuchungen gefasst)');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1820,'Erhaltungssatzung');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1821,'Städtebauliches Erhaltungsgebiet');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1822,'Soziales Erhaltungsgebiet');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1823,'Erhaltungsgebiet zur städtebaulichen Umstrukturierung');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1824,'Soziales Erhaltungsgebiet (Aufstellungsbeschluss gefasst)');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1830,'Städtebauliche Gebote');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1840,'Sanierung');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1841,'Sanierung (Beschluss zu vorbereitenden Untersuchungen gefasst)');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (1900,'WOHNUNGSBAUERLEICHTERUNGSGESET');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2100,'Flurbereinigungsgesetz');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2110,'Flurbereinigung (Par. 1, 37 FlurbG)');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2120,'Vereinfachtes Flurbereinigungsverfahren (Par. 86 FlurbG)');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2130,'Unternehmensflurbereinigung (nach Par. 87 oder 90 FlurbG)');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2140,'Beschleunigtes Zusammenlegungsverfahren (Par. 91 FlurbG)');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2150,'Freiwilliger Landtausch (Par. 103a FlurbG)');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2160,'Verfahren nach dem Gemeinheitsteilungsgesetz');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2170,'Verfahren nach dem Gemeinschaftswaldgesetz');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2180,'Freiwilliger Nutzungstausch');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2200,'Verfahren nach dem LANDWIRTSCHAFTSANPASSUNGSGESET');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2210,'Flurneuordnung');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2220,'Freiwilliger Landtausch (Par. 54 LwAnpG)');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2230,'Bodenordnungsverfahren (Par. 56 LwAnpG)');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2240,'Zusammenführung von Boden- und Gebäudeeigentum (Par. 64 LwAnpG)');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2300,'Bodensonderungsgesetz');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2310,'Unvermessenes Eigentum');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2320,'Unvermessenes Nutzungsrecht');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2330,'Ergänzende Bodenneuordnung');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2340,'Komplexe Bodenneuordnung');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2400,'Vermögenszuordnungsgesetz');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2410,'Vermögenszuordnung nach Plan');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2411,'Vermögenszuordnung nach dem Aufteilungsplan');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2412,'Vermögenszuordnung nach dem Zuordnungsplan');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2500,'Landesraumordnungsgesetz');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2510,'Wasservorranggebiete');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2600,'Bauordnung');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2610,'Baulast');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2611,'Begünstigende Baulast');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2612,'Belastende Baulast');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2700,'Grenzfeststellungsverfahren nach Hamb. Wassergesetz');
INSERT INTO AX_BAURAUMODERBODENORDNUNGSREC (wert, bezeichner) VALUES (2800,'Verkehrsflächenbereinigung');

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_BODENSCHAETZUNG_KULTURART';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_BODENSCHAETZUNG_KULTURART CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_BODENSCHAETZUNG_KULTURART (
    wert integer,
    bezeichner character varying,
    CONSTRAINT ALKIS_KEY_7  PRIMARY KEY (wert)
  );
COMMENT ON TABLE ax_bodenschaetzung_kulturart 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_BODENSCHAETZUNG_KULTURART (wert, bezeichner) VALUES (1000,'Ackerland (A)');
INSERT INTO AX_BODENSCHAETZUNG_KULTURART (wert, bezeichner) VALUES (2000,'Acker-Grünland (AGr)');
INSERT INTO AX_BODENSCHAETZUNG_KULTURART (wert, bezeichner) VALUES (3000,'Grünland (Gr)');
INSERT INTO AX_BODENSCHAETZUNG_KULTURART (wert, bezeichner) VALUES (4000,'Grünland-Acker (GrA)');

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_BODENSCHAETZUNG_BODENART';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_BODENSCHAETZUNG_BODENART CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_BODENSCHAETZUNG_BODENART (
    wert integer,
    bezeichner character varying,
    CONSTRAINT ALKIS_KEY_8  PRIMARY KEY (wert)
  );
COMMENT ON TABLE ax_bodenschaetzung_bodenart 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (1100,'Sand (S)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (2100,'Lehmiger Sand (lS)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (3100,'Lehm (L)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (4100,'Ton (T)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (5000,'Moor (Mo)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (1200,'Anlehmiger Sand (Sl)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (2200,'Stark lehmiger Sand (SL)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (3200,'Sandiger Lehm (sL)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (4200,'Schwerer Lehm (LT)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (6110,'Sand, Moor (SMo)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (6120,'Lehmiger Sand, Moor (lSMo)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (6130,'Lehm, Moor (LMo)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (6140,'Ton, Moor (TMo)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (6210,'Moor,Sand (MoS)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (6220,'Moor, Lehmiger Sand (MolS)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (6230,'Moor, Lehm (MoL)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (6240,'Moor, Ton (MoT)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7110,'Sand auf sandigem Lehm (S/sL)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7130,'Sand auf schwerem Lehm (S/LT)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7210,'Anlehmiger Sand auf Lehm (Sl/L)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7220,'Anlehmiger Sand auf schwerem Lehm (Sl/LT)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7230,'Anlehmiger Sand auf Ton (Sl/T)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7310,'Lehmiger Sand auf schwerem Lehm (lS/LT)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7320,'Lehmiger Sand auf Sand (lS/S)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7400,'Stark lehmiger Sand auf Ton (SL/T)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7510,'Ton auf stark lehmigen Sand (T/SL)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7530,'Ton auf anlehmigen Sand (T/Sl)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7610,'Schwerer Lehm auf lehmigen Sand (LT/lS)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7620,'Schwerer Lehm auf anlehmigen Sand (LT/Sl)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7630,'Schwerer Lehm auf Sand (LT/S)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7710,'Lehm auf anlehmigen Sand (L/Sl)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7800,'Sandiger Lehm auf Sand (sL/S)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7120,'Sand auf Lehm (S/L)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7140,'Sand auf Ton (S/T)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7330,'Lehmiger Sand auf Ton (lS/T)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7520,'Ton auf lehmigen Sand (T/lS)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7540,'Ton auf Sand (T/S)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (7720,'Lehm auf Sand (L/S)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (8110,'Sand auf Moor (S/Mo)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (8120,'Lehmiger Sand auf Moor (lS/Mo)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (8130,'Lehm auf Moor (L/Mo)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (8140,'Ton auf Moor (T/Mo)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (8210,'Moor auf Sand (Mo/S)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (8220,'Moor auf lehmigen Sand (Mo/lS)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (8230,'Moor auf Lehm (Mo/L)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (8240,'Moor auf Ton (Mo/T)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9120,'Bodenwechsel vom Lehm zu Moor (L+Mo)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9130,'Lehmiger Sand mit starkem Steingehalt (lSg)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9140,'Lehm mit starkem Steingehalt (Lg)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9150,'lehmiger Sand mit Steinen und Blöcken (lS+St)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9160,'Lehm mit Steinen und Blöcken L+St)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9170,'Steine und Blöcke mit  lehmigem Sand (St+lS)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9180,'Steine und Blöcke mit  Lehm (St+L)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9190,'lehmiger Sand mit Felsen (lS+Fe)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9200,'Lehm mit Felsen (L+Fe)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9210,'Felsen mit lehmigem Sand (Fe+lS)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9220,'Felsen mit Lehm (Fe+L)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9310,'Sand auf lehmigen Sand (S/lS)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9320,'Anlehmiger Sand auf Mergel (Sl/Me)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9330,'Anlehmiger Sand auf sandigem Lehm (Sl/sL)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9340,'Lehmiger Sand auf Lehm (lS/L)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9350,'Lehmiger Sand auf Mergel (lS/Me)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9360,'Lehmiger Sand auf sandigem Lehm (lS/sL)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9370,'Lehmiger Sand, Mergel (lSMe)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9380,'Lehmiger Sand, Moor auf Mergel (lSMo/Me)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9390,'Anlehmiger Sand, Moor (SlMo)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9410,'Lehm auf Mergel (L/Me)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9420,'Lehm, Moor auf Mergel (LMo/Me)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9430,'Schwerer Lehm auf Moor (LT/Mo)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9440,'Ton auf Mergel (T/Me)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9450,'Moor auf Mergel (Mo/Me)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9460,'Moor, Lehm auf Mergel (MoL/Me)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9470,'Moor, Mergel (MoMe)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9480,'LößDiluvium(LöD)');
INSERT INTO AX_BODENSCHAETZUNG_BODENART (wert, bezeichner) VALUES (9490,'AlluviumDiluvium(AlD)');

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_BODENSCHAETZUNG_ZUSTANDSSTU';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_BODENSCHAETZUNG_ZUSTANDSSTU CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_BODENSCHAETZUNG_ZUSTANDSSTU (
    wert integer,
    bezeichner character varying,
    CONSTRAINT ALKIS_KEY_9  PRIMARY KEY (wert)
  );
COMMENT ON TABLE AX_BODENSCHAETZUNG_ZUSTANDSSTU 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Zustandsstufe (1)',1100);
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Zustandsstufe (2)',1200);
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Zustandsstufe (3)',1300);
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Zustandsstufe (4)',1400);
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Zustandsstufe (5)',1500);
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Zustandsstufe (6)',1600);
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Zustandsstufe (7)',1700);
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Zustandsstufe Misch- und Schichtböden sowie künstlichveränderte Böden (-)',1800);
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Bodenstufe (I)',2100);
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Bodenstufe (II)',2200);
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Bodenstufe (III)',2300);
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Bodenstufe Misch- und Schichtböden sowie künstlich veränderte Böden (-)',2400);
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Bodenstufe (II+III)',3100);
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Bodenstufe ("(III)")',3200);
INSERT INTO AX_BODENSCHAETZUNG_ZUSTANDSSTU (bezeichner,wert) VALUES ('Bodenstufe (IV)',3300);

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_MUSTERLANDESMUSTERUNDVERGLE';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_MUSTERLANDESMUSTERUNDVERGLE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_MUSTERLANDESMUSTERUNDVERGLE (
    wert integer,
    bezeichner character varying,
    CONSTRAINT ALKIS_KEY_10  PRIMARY KEY (wert)
  );
COMMENT ON TABLE AX_MUSTERLANDESMUSTERUNDVERGLE 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_MUSTERLANDESMUSTERUNDVERGLE (wert,bezeichner) VALUES (1000,'Musterstück (M)');
INSERT INTO AX_MUSTERLANDESMUSTERUNDVERGLE (wert,bezeichner) VALUES (2000,'Landesmusterstück (L)');
INSERT INTO AX_MUSTERLANDESMUSTERUNDVERGLE (wert,bezeichner) VALUES (3000,'Vergleichsstück (V)');

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_GRABLOCHDERBODENSCHAETZUNG_';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_GRABLOCHDERBODENSCHAETZUNG_ CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_GRABLOCHDERBODENSCHAETZUNG_ (
    wert integer,
    bezeichner character varying,
    CONSTRAINT ALKIS_KEY_11  PRIMARY KEY (wert)
  );
COMMENT ON TABLE AX_GRABLOCHDERBODENSCHAETZUNG_
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_GRABLOCHDERBODENSCHAETZUNG_ (wert,bezeichner) VALUES (1100,'Grabloch, bestimmend, lagerichtig (innerhalb der Fläche)');
INSERT INTO AX_GRABLOCHDERBODENSCHAETZUNG_ (wert,bezeichner) VALUES (1200,'Grabloch, bestimmend, lagerichtig (außerhalb des Abschnitts)');
INSERT INTO AX_GRABLOCHDERBODENSCHAETZUNG_ (wert,bezeichner) VALUES (1300,'Grabloch, nicht lagerichtig, im Abschnitt nicht vorhanden');
INSERT INTO AX_GRABLOCHDERBODENSCHAETZUNG_ (wert,bezeichner) VALUES (2000,'Grabloch für Muster-, Landesmuster-, Vergleichsstück');
INSERT INTO AX_GRABLOCHDERBODENSCHAETZUNG_ (wert,bezeichner) VALUES (3000,'Grabloch, nicht bestimmend');

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_FORSTRECHT_ARTDERFESTLEGUNG(';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_FORSTRECHT_ARTDERFESTLEGUNG( CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_FORSTRECHT_ARTDERFESTLEGUNG(
    wert integer,
    bezeichner character varying,
    CONSTRAINT ALKIS_KEY_12  PRIMARY KEY (wert)
  );
COMMENT ON TABLE ax_forstrecht_artderfestlegung
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_FORSTRECHT_ARTDERFESTLEGUNG (bezeichner, wert) VALUES('Klassifizierung nach Bundes- oder Landeswaldgesetz',3900);
INSERT INTO AX_FORSTRECHT_ARTDERFESTLEGUNG (bezeichner, wert) VALUES('Staatswald Bund',3910);
INSERT INTO AX_FORSTRECHT_ARTDERFESTLEGUNG (bezeichner, wert) VALUES('Staatswald Land',3920);
INSERT INTO AX_FORSTRECHT_ARTDERFESTLEGUNG (bezeichner, wert) VALUES('Kommunalwald',3930);
INSERT INTO AX_FORSTRECHT_ARTDERFESTLEGUNG (bezeichner, wert) VALUES('Anstalts- und Stiftungswald',3940);
INSERT INTO AX_FORSTRECHT_ARTDERFESTLEGUNG (bezeichner, wert) VALUES('Anderer öffentlicher Wald',3950);
INSERT INTO AX_FORSTRECHT_ARTDERFESTLEGUNG (bezeichner, wert) VALUES('Privater Gemeinschaftswald',3960);
INSERT INTO AX_FORSTRECHT_ARTDERFESTLEGUNG (bezeichner, wert) VALUES('Großprivatwald',3970);
INSERT INTO AX_FORSTRECHT_ARTDERFESTLEGUNG (bezeichner, wert) VALUES('Kleinprivatwald',3980);
INSERT INTO AX_FORSTRECHT_ARTDERFESTLEGUNG (bezeichner, wert) VALUES('Anderer Privatwald',3990);

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_FORSTRECHT_BESONDEREFUNKTIO(';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_FORSTRECHT_BESONDEREFUNKTIO( CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_FORSTRECHT_BESONDEREFUNKTIO(
    wert integer,
    bezeichner character varying,
    CONSTRAINT ALKIS_KEY_13  PRIMARY KEY (wert)
  );
COMMENT ON TABLE AX_FORSTRECHT_BESONDEREFUNKTIO
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Ohne besondere gesetzliche Bindung',1000);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Ohne besondere gesetzliche Bindung nach LWaldG- Holzboden',1010);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Schutzwald',2000);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Schutzwald - Holzboden',2010);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Erholungswald',3000);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Erholungswald - Holzboden',3010);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Bannwald',4000);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Nationalpark - Holzboden',4010);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Naturschutzgebiet - Holzboden',5010);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Schutz- und Erholungswald',6000);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Schutz- und Erholungswald - Holzboden',6010);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Nationalpark - Nichtholzboden',7010);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Naturschutzgebiet - Nichtholzboden',8010);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Andere Forstbetriebsfläche',9000);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Nichtholzboden',9010);
INSERT INTO AX_FORSTRECHT_BESONDEREFUNKTIO (bezeichner, wert) VALUES('Sonstiges',9999);

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_BODENSCHAETZUNG_ENTSTEHUNGS(';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_BODENSCHAETZUNG_ENTSTEHUNGS( CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_BODENSCHAETZUNG_ENTSTEHUNGS(
    wert integer,
    bezeichner character varying,
    CONSTRAINT ALKIS_KEY_14 PRIMARY KEY (wert)
  );
COMMENT ON TABLE AX_BODENSCHAETZUNG_ENTSTEHUNGS
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Diluvium (D)',1000);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Diluvium über Alluvium (DAl)',1100);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Diluvium über Löß (DLö)',1200);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Diluvium über Verwitterung (DV)',1300);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Diluvium, gesteinig (Dg)',1400);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Diluvium, gesteinig über Alluvium (DgAl)',1410);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Diluvium, gesteinig über Löß (DgLö)',1420);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Diluvium, gesteinig über Verwitterung (DgV)',1430);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Löß (Lö)',2000);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Löß über Diluvium (LöD)',2100);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Löß, Diluvium, Gesteinsböden (LöDg)',2110);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Löß, Diluvium, Verwitterung (LöDV)',2120);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Löß über Alluvium (LöAl)',2200);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Löß über Verwitterung (LöV)',2300);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Löß, Verwitterung, Gesteinsböden (LöVg)',2310);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Löß über Verwitterung, gesteinig (LöVg)',2400);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Alluvium (Al)',3000);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Alluvium über Diluvium (AlD)',3100);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Alluvium über Löß (AlLö)',3200);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Alluvium über Verwitterung (AlV)',3300);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Alluvium, gesteinig (Alg)',3400);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Alluvium, gesteinig über Diluvium (AlgD)',3410);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Alluvium, gesteinig über Löß (AlgLö)',3420);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Alluvium, gesteinig über Verwitterung (AlgV)',3430);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Alluvium, Marsch (AlMa)',3500);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Alluvium, Moor (AlMo)',3610);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Moor, Alluvium (MoAI)',3620);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Mergel (Me)',3700);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Verwitterung (V)',4000);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Verwitterung über Diluvium (VD)',4100);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Verwitterung über Alluvium (VAl)',4200);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Verwitterung über Löß (VLö)',4300);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Verwitterung, Gesteinsböden (Vg)',4400);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Verwitterung, Gesteinsböden über Diluvium (VgD)',4410);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Entstehungsart nicht erkennbar (-)',5000);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Klimastufe 8° C und darüber (a)',6100);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Klimastufe 7,9° - 7,0° C (b)',6200);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Klimastufe 6,9° - 5,7° C (c)',6300);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Klimastufe 5,6° C und darunter (d)',6400);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Wasserstufe (1)',7100);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Wasserstufe (2)',7200);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Wasserstufe (3)',7300);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Wasserstufe (4)',7400);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Wasserstufe (4-)',7410);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Wasserstufe (5)',7500);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Wasserstufe (5-)',7510);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Wasserstufe (3-)',7520);
INSERT INTO AX_BODENSCHAETZUNG_ENTSTEHUNGS (bezeichner, wert) VALUES('Wasserstufe (3+4)',7530);

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_DATENERHEBUNG';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_DATENERHEBUNG CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_DATENERHEBUNG (
    wert integer,
    bezeichner character varying,
    CONSTRAINT ALKIS_KEY_15 PRIMARY KEY (wert)
  );
COMMENT ON TABLE ax_datenerhebung
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus Katastervermessung ermittelt', 1000);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aufgrund Anforderungen mit Netzanschluss ermittelt', 1100);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aufgrund Anforderungen mit Bezug zur Flurstücksgrenze ermittelt', 1200);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus sonstiger Vermessung ermittelt', 1900);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus Luftbildmessung oder Fernerkundungsdaten ermittelt', 2000);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus Katasterunterlagen und Karten für graphische Zwecke ermittelt', 4000);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus Katasterzahlen für graphische Zwecke ermittelt', 4100);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert', 4200);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab M größer gleich 1 zu 1000', 4210);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab 1 zu 1000 größer M größer gleich 1 zu 2000', 4220);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab 1 zu 2000 größer M größer gleich 1 zu 3000', 4230);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab 1 zu 3000 größer M größer gleich 1 zu 5000', 4240);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus Katasterkarten digitalisiert, Kartenmaßstab 1 zu 5000 größer M', 4250);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert', 4300);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab M größer gleich 1 zu 1000', 4310);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab 1 zu 1000 größer M größer gleich 1 zu 2000', 4320);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab 1 zu 2000 größer M größer gleich 1 zu 3000', 4330);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab 1 zu 3000 größer M größer gleich 1 zu 5000', 4340);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, Kartenmaßstab 1 zu 5000 größer M', 4350);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, mit sonstigen geometrischen Bedingungen und bzw. oder Homogenisierung (M größer gleich 1 zu 1000)', 4360);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, mit Berechnung oder Abstandsbedingung (M größer gleich 1 zu 1000)', 4370);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, mit sonstigen geometrischen Bedingungen und bzw. oder Homogenisierung (M kleiner 1 zu 1000)', 4380);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Aus sonstigen Unterlagen digitalisiert, mit Berechnung oder Abstandsbedingungen (M kleiner 1 zu 1000)', 4390);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Nach Quellenlage nicht zu spezifizieren', 9998);
INSERT INTO AX_DATENERHEBUNG (bezeichner, wert) VALUES('Sonstiges', 9999);

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_SONSTIGESBAUWERKODERSONSTIG(';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_SONSTIGESBAUWERKODERSONSTIG( CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_SONSTIGESBAUWERKODERSONSTIG(
    wert integer,
    bezeichner character varying,
    CONSTRAINT ALKIS_KEY_16 PRIMARY KEY (wert)
  );
COMMENT ON TABLE AX_SONSTIGESBAUWERKODERSONSTIG
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Überdachung',1610);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Carport',1611);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Treppe',1620);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Freitreppe',1621);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Rolltreppe',1622);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Treppenunterkante',1630);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Kellereingang',1640);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Rampe',1650);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Terrasse',1670);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Mauer',1700);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Mauerkante, rechts',1701);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Mauerkante, links',1702);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Mauermitte',1703);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Stützmauer',1720);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Stützmauer, rechts',1721);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Stützmauer, links',1722);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Stützmauermitte',1723);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Zaun',1740);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Denkmal, Denkstein, Standbild',1750);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Bildstock, Wegekreuz, Gipfelkreuz',1760);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Bildstock',1761);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Wegekreuz',1762);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Gipfelkreuz',1763);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Meilenstein, historischer Grenzstein',1770);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Brunnen',1780);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Brunnen (Trinkwasserversorgung)',1781);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Springbrunnen, Zierbrunnen',1782);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Ziehbrunnen',1783);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Spundwand',1790);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Höckerlinie',1791);
INSERT INTO AX_SONSTIGESBAUWERKODERSONSTIG (bezeichner, wert) VALUES ('Sonstiges',9999);

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_BAUTEIL_BAUART';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_BAUTEIL_BAUART CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_BAUTEIL_BAUART (
wert integer, 
bezeichner character varying,  
kennung integer, objektart character varying);
COMMENT ON TABLE ax_bauteil_bauart
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (1100,'Geringergeschossiger Gebäudeteil',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (1200,'Höhergeschossiger Gebäudeteil (nicht Hochhaus)',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (1300,'Hochhausgebäudeteil',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (1400,'Abweichende Geschosshöhe',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (2000,'Keller',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (2100,'Tiefgarage',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (2300,'Loggia',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (2350,'Wintergarten',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (2400,'Arkade',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (2500,'Auskragende/zurückspringende Geschosse',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (2510,'Auskragende Geschosse',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (2520,'Zurückspringende Geschosse',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (2610,'Durchfahrt im Gebäude',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (2620,'Durchfahrt an überbauter Verkehrsstraße',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (2710,'Schornstein im Gebäude',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (2720,'Turm im Gebäude',31002,'ax_bauteil');
INSERT INTO AX_BAUTEIL_BAUART (wert, bezeichner,kennung,objektart) VALUES (9999,'Sonstiges',31002,'ax_bauteil');

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_KLASSIFIZIERUNGNACHSTRASSEN';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_KLASSIFIZIERUNGNACHSTRASSEN CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_KLASSIFIZIERUNGNACHSTRASSEN (
wert integer, 
bezeichner character varying,  
kennung integer, objektart character varying);
COMMENT ON TABLE AX_KLASSIFIZIERUNGNACHSTRASSEN
IS 'artderfestlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_KLASSIFIZIERUNGNACHSTRASSEN (bezeichner, wert) VALUES ('Klassifizierung nach Bundes- oder Landesstraßengesetz',1100);
INSERT INTO AX_KLASSIFIZIERUNGNACHSTRASSEN (bezeichner, wert) VALUES ('Bundesautobahn',1110);
INSERT INTO AX_KLASSIFIZIERUNGNACHSTRASSEN (bezeichner, wert) VALUES ('Bundesstraße',1120);
INSERT INTO AX_KLASSIFIZIERUNGNACHSTRASSEN (bezeichner, wert) VALUES ('Landes- oder Staatsstraße',1130);
INSERT INTO AX_KLASSIFIZIERUNGNACHSTRASSEN (bezeichner, wert) VALUES ('Kreisstraße',1140);
INSERT INTO AX_KLASSIFIZIERUNGNACHSTRASSEN (bezeichner, wert) VALUES ('Gemeindestraße',1150);
INSERT INTO AX_KLASSIFIZIERUNGNACHSTRASSEN (bezeichner, wert) VALUES ('Ortsstraße',1160);
INSERT INTO AX_KLASSIFIZIERUNGNACHSTRASSEN (bezeichner, wert) VALUES ('Gemeindeverbindungsstraße',1170);
INSERT INTO AX_KLASSIFIZIERUNGNACHSTRASSEN (bezeichner, wert) VALUES ('Sonstige öffentliche Straße',1180);
INSERT INTO AX_KLASSIFIZIERUNGNACHSTRASSEN (bezeichner, wert) VALUES ('Privatstraße',1190);

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_KLASSIFIZIERUNGNACHWASSERRE';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_KLASSIFIZIERUNGNACHWASSERRE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_KLASSIFIZIERUNGNACHWASSERRE (
wert integer, 
bezeichner character varying,  
kennung integer, objektart character varying);
COMMENT ON TABLE AX_KLASSIFIZIERUNGNACHWASSERRE
IS 'artderfestlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_KLASSIFIZIERUNGNACHWASSERRE (bezeichner, wert) VALUES ('Klassifizierung nach Bundes- oder Landeswassergesetz',1300);
INSERT INTO AX_KLASSIFIZIERUNGNACHWASSERRE (bezeichner, wert) VALUES ('Gewässer I. Ordnung - Bundeswasserstraße',1310);
INSERT INTO AX_KLASSIFIZIERUNGNACHWASSERRE (bezeichner, wert) VALUES ('Gewässer I. Ordnung - nach Landesrecht',1320);
INSERT INTO AX_KLASSIFIZIERUNGNACHWASSERRE (bezeichner, wert) VALUES ('Gewässer II. Ordnung',1330);
INSERT INTO AX_KLASSIFIZIERUNGNACHWASSERRE (bezeichner, wert) VALUES ('Gewässer III. Ordnung',1340);

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_ANDEREFESTLEGUNGNACHSTRASSE';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_ANDEREFESTLEGUNGNACHSTRASSE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_ANDEREFESTLEGUNGNACHSTRASSE (
wert integer, 
bezeichner character varying,  
kennung integer, objektart character varying);
COMMENT ON TABLE AX_ANDEREFESTLEGUNGNACHSTRASSE
IS 'artderfestlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_ANDEREFESTLEGUNGNACHSTRASSE (bezeichner, wert) VALUES ('Bundesfernstraßengesetz',1210);
INSERT INTO AX_ANDEREFESTLEGUNGNACHSTRASSE (bezeichner, wert) VALUES ('Anbauverbot',1220);
INSERT INTO AX_ANDEREFESTLEGUNGNACHSTRASSE (bezeichner, wert) VALUES ('Anbauverbot nach Bundesfernstraßengesetz',1230);
INSERT INTO AX_ANDEREFESTLEGUNGNACHSTRASSE (bezeichner, wert) VALUES ('Anbauverbot (40m)',1231);
INSERT INTO AX_ANDEREFESTLEGUNGNACHSTRASSE (bezeichner, wert) VALUES ('Anbauverbot (20m)',1232);
INSERT INTO AX_ANDEREFESTLEGUNGNACHSTRASSE (bezeichner, wert) VALUES ('Anbaubeschränkung',1240);
INSERT INTO AX_ANDEREFESTLEGUNGNACHSTRASSE (bezeichner, wert) VALUES ('Anbaubeschränkung (100m)',1241);
INSERT INTO AX_ANDEREFESTLEGUNGNACHSTRASSE (bezeichner, wert) VALUES ('Anbaubeschränkung (40m)',1242);
INSERT INTO AX_ANDEREFESTLEGUNGNACHSTRASSE (bezeichner, wert) VALUES ('Veränderungssperre nach Bundesfernstraßengesetz',1250);
INSERT INTO AX_ANDEREFESTLEGUNGNACHSTRASSE (bezeichner, wert) VALUES ('Landesstraßengesetz',1260);
INSERT INTO AX_ANDEREFESTLEGUNGNACHSTRASSE (bezeichner, wert) VALUES ('Veränderungssperre',1280);

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_NATURUMWELTODERBODENSCHUTZR';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_NATURUMWELTODERBODENSCHUTZR CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_NATURUMWELTODERBODENSCHUTZR (
wert integer, 
bezeichner character varying,  
kennung integer, objektart character varying);
COMMENT ON TABLE AX_NATURUMWELTODERBODENSCHUTZR
IS 'artderfestlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Schutzfläche nach Europarecht',610);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Flora-Fauna-Habitat-Gebiet',611);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Vogelschutzgebiet',612);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Schutzflächen nach Landesnaturschutzgesetz',620);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Naturschutzgebiet',621);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Geschützter Landschaftsbestandteil',622);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Landschaftsschutzgebiet',623);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Naturpark',624);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Bundesbodenschutzgesetz',630);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Verdachtsfläche auf schädliche Bodenveränderung',631);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Schädliche Bodenveränderung',632);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Altlastenverdächtige Fläche',633);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Altlast',634);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Bundesimmisionsschutzgesetz',640);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Belastungsgebiet',641);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Schutzbedürftiges Gebiet',642);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Gefährdetes Gebiet',643);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Naturschutzgesetz',650);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Besonders geschütztes Biotop',651);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Besonders geschütztes Feuchtgrünland',652);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Naturdenkmal',653);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Einstweilige Sicherstellung, Veränderungssperre',654);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Vorkaufsrecht',655);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Ausgleichs- oder Kompensationsfläche',656);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Bodenschutzgesetz',660);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Dauerbeobachtungsflächen',661);
INSERT INTO AX_NATURUMWELTODERBODENSCHUTZR (bezeichner, wert) VALUES ('Bodenschutzgebiet',662);

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_DENKMALSCHUTZRECHT_ARTDF';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_DENKMALSCHUTZRECHT_ARTDF CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_DENKMALSCHUTZRECHT_ARTDF (
wert integer, 
bezeichner character varying,  
kennung integer, objektart character varying);
COMMENT ON TABLE ax_denkmalschutzrecht_artdf
IS 'artderfestlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Kulturdenkmal',2700);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Bau- und Kunstdenkmal nach Landesdenkmalschutzgesetz',2710);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Baudenkmal',2711);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Kunstdenkmal',2712);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Gartendenkmal',2713);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Archäologisches Denkmal (auch Bodendenkmal) nach Landesdenkmalschutzgesetz',2800);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Archäologisches Denkmal',2810);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Bodendenkmal',2820);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Schutzgebiet oder -bereiche nach Landesdenkmalschutzgesetz',2900);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Denkmalzone oder -bereich',2910);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Geschützter Baubereich',2920);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Grabungsschutzgebiet',2930);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Befestigungen',3100);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Befestigung (Burg)',3110);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Burg (Fliehburg, Ringwall)',3111);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Erdwerk',3112);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Ringwall',3113);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Steinwerk',3114);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Festung',3115);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Gräftenanlage',3116);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Schanze',3117);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Lager',3118);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Wachturm (römisch), Warte',3120);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Wachturm',3121);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Warte',3122);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Befestigung (Wall, Graben)',3130);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Grenzwall, Schutzwall',3131);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Limes',3132);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Landwehr',3133);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Stadtwall',3134);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historischer Wall',3135);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historische Siedlung',3200);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Pfahlbau',3210);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Wüstung',3220);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Wurt',3230);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Abri',3240);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Höhle',3250);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historische Bestattung',3300);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Großsteingrab (Dolmen, Hünenbett)',3310);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Grabhügel',3320);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Grabhügelfeld',3330);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Urnenfriedhof',3340);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Körpergräberfeld',3350);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Reihengräberfriedhof',3360);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historisches land- oder forstwirtschaftliches Objekt',3400);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historischer Pflanzkamp',3410);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historisches Viehgehege',3420);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Sandfang',3430);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historisches Ackersystem',3440);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historische Bergbau-, Verhüttungs- oder sonstige Produktionsstätte',3500);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historisches Bergbaurelikt',3510);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historischer Meiler',3520);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historischer Ofen',3530);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historischer Verhüttungsplatz',3540);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historische Straße oder Weg',3600);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Heerstraße',3610);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Hohlweg',3620);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Moorweg',3630);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Wegespur',3640);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historisches wasserwirtschaftliches Objekt',3700);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historische Wasserleitung',3710);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Aquädukt',3720);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historischer Deich',3730);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historischer Damm',3740);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historischer Graben',3750);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Steinmal',3800);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Schalenstein',3810);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Rillenstein',3820);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Wetzrillen',3830);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Kreuzstein',3840);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Historischer Grenzstein',3850);
INSERT INTO AX_DENKMALSCHUTZRECHT_ARTDF (bezeichner, wert) VALUES ('Menhir',3860);

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='AX_SONSTIGESRECHT_ARTDF';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AX_SONSTIGESRECHT_ARTDF CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE AX_SONSTIGESRECHT_ARTDF (
wert integer, 
bezeichner character varying,  
kennung integer, objektart character varying);
COMMENT ON TABLE ax_sonstigesrecht_artdf
IS 'artderfestlegung - Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Luftverkehrsgesetz',4100);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Bauschutzbereich',4110);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Beschränkter Bauschutzbereich',4120);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Bundeskleingartengesetz',4200);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Dauerkleingarten',4210);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Berggesetz',4300);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Bodenbewegungsgebiet',4301);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Bruchfeld',4302);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Baubeschränkung',4310);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Reichsheimstättengesetz',4400);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Reichsheimstätte',4410);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Schutzbereichsgesetz',4500);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Schutzbereich',4510);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Eisenbahnneuordnungsgesetz',4600);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Übergabebescheidverfahren',4610);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Baubeschränkungen durch Richtfunkverbindungen',4710);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Truppenübungsplatz, Standortübungsplatz',4720);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Vermessungs- und Katasterrecht',4800);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Schutzfläche Festpunkt',4810);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 1 m Radius',4811);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 2 m Radius',4812);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 5 m Radius',4813);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 10 m Radius',4814);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Schutzfläche Festpunkt, 30 m Radius',4815);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Marksteinschutzfläche',4820);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Liegenschaftskatastererneuerung',4830);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Fischereirecht',4900);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Jagdkataster',5100);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Landesgrundbesitzkataster',5200);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Bombenblindgängerverdacht',5300);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Rieselfeld',5400);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Sicherungsstreifen',5500);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Grenzbereinigung',5600);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Hochwasserdeich',5700);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Hauptdeich, 1. Deichlinie',5710);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('2. Deichlinie',5720);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Beregnungsverband',6000);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Weinlage',7000);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Weinbausteillage',7100);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Weinbergsrolle',7200);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Weinbausteilstlage',7300);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Benachteiligtes landwirtschaftliches Gebiet',8000);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Mitverwendung Hochwasserschutz, Oberirdische Anlagen',9100);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Mitverwendung Hochwasserschutz, Unterirdische Anlagen',9200);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Hafennutzungsgebiet',9300);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Hafenerweiterungsgebiet',9400);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Bohrung verfüllt',9500);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Zollgrenze',9600);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Belastung nach §7 Abs. 2 GBO',9700);
INSERT INTO AX_SONSTIGESRECHT_ARTDF (bezeichner, wert) VALUES ('Sonstiges',9999);
purge recyclebin;
QUIT;
