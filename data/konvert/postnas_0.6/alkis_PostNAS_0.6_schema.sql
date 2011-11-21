--
-- *****************************
--       A  L   K   I   S       
-- *****************************
--
-- Datenbankstruktur PostNAS 0.6  (GDAL aus aktuellem Trunc)
--
-- Stand
-- -----

--  2010-11-17 Such-Index (fuer Navigation) auf LagebezeichnungOhneHausnummer und LagebezeichnungKatalogEintrag

--  2011-02-02 Neue Tabellen:

--  2011-02-07 "gml_id" in fast allen Tabellen als UNIQUE INDEX

--  2011-05-05 Daten mit historischen Flurstuecken geladen:
--             Neue Tabelle: 'ax_historischesflurstueckohneraumbezug',
--             Tabelle 'ax_historischesflurstueck': Felder vergroessert
--             Nicht benutzte Tabellen auskommentiert (aus einem 'alles ausgeben'-NBA)

--  2011-05-11 AE: "lage" einheitlich in character varying(5), 
--             geändert siehe https://trac.wheregroup.com/PostNAS/ticket/9  
--                            http://trac.osgeo.org/gdal/changeset/22336
--
--  2011-05-30 AE: constraints enforce_geotype_wkb_geometry für ax_klassifizierungnachwasserrecht, 
--             ax_klassifizierungnachstrassenrecht um MULTIPOLYGON erweitert
--
--  2011-07-19 AE: Neue Funktion deleteFeature(typename text, featureid text), 
--             wird nach Import des Layers delete aufgerufen
--
--  2011-08-04 AE: Indizierung der gml_id (fuer NBA Verfahren)
--
--  2011-08-04 AE: Tabelle delete hinzugefügt mit Dummy Geometrie für Tabelle delete

--  2011-09-18 AE: ax_besondereflurstuecksgrenze.ArtDerFlurstuecksgrenze als Array integer[]

--  2011-09-19 FJ: Indizierung (im Block am Dateiende) wieder entfernt.
--               Ein Index auf "gml_id" ist bereits in jeder Tabellendefinition enthalten.
--             Die "constraint enforce_geotype_wkb_geometry" für folgende Tabellen 
--               um MULTIPOLYGON erweitert statt wie bisher die constraint ganz zu löschen:
--             - ax_denkmalschutzrecht
--             - ax_musterlandesmusterundvergleichsstueck
--             - ax_gebaeude
--             - ax_historischesflurstueck
--             - ax_naturumweltoderbodenschutzrecht
--             - ax_schutzzone
--             - ax_vorratsbehaelterspeicherbauwerk

--  2011-10-25 FJ: Syntax-Korrektur,
--                 ax_musterlandesmusterundvergleichsstueck auch POINT-Geometrie?

--  2011-11-02 FJ: Neue Tabellen: ax_fortfuehrungsfall, ax_fortfuehrungsnachweisdeckblatt
--                                ax_reservierung, ax_punktkennunguntergegangen

--  2011-11-04 FJ: Anpassungen fuer Buchauskunft "Historie" 
--                 (z.B. Index auf ax_historischesflurstueck.flurstueckskennzeichen)

--  2011-11-21 FJ
--   a. Abgleich Tabelle "ax_gebaeude" mit ALKIS-OK NRW, Kommentare, Neue Keytables.
--   b. Abgleich Tabelle "ax_flurstueck" mit ALKIS-OK NRW, Kommentare.
--   c. Index auf Vorgänger/Nachfolger-Flurstück (Array!) von ax_historischsflurstueck*
--   d. Spalte "identifier" pauschal auskommentiert. Es scheint sich nur um eine Variante (redundant) von "gml_id" zu handeln.
--   e. Spalten mit mehreren Bezeichnungen, durch Pipe (|) getrennt pauschal auskommentiert. Reste alter fehlerhafter PostNAS-Versionen?
--   f. Einheitliche Definition und Kommentierung von "AX_Flurstueck_Kerndaten"
--   g. Einige Felder umgestellt von "character" auf "character varying" (aber nicht gml_id und beginnt).
--   h. gml_id von ax_adresse von 32 auf 16 umgestellt (wurden bisher nicht korrekt gelöscht?)


--  TEST: gml_id von character(16)  auf  character varying(32) erweitert
--        Bei Daten aus einer Fortführung (NBA-Aktualisierung) wird dort Datum/Zeit angehängt
--        Dies Erweiterung ist für die Fortführungslogik mit Nachprozessierung über die Function 
--        "deletefeature" (siehe unten) aber kontraproduktiv.
--        Die Löschanweisung berücksichtigt nur die ersten 16 Stellen 
--        Siehe Datei 'delete.sql' in diesem Ordner.


--  VERSIONS-NUMMER:

--  Dies Schema kann nicht mehr mit der installierbaren gdal-Version 1.8 verwendet werden.
--  Derzeit muss ogr2ogr (gdal) aus den Quellen compiliert werden, die o.g. Patch enthalten.
--  Weiterführung dieses Zweiges als PostNAS 0.6


-- Zur Datenstruktur siehe Dokument: 
-- http://www.bezreg-koeln.nrw.de/extra/33alkis/dokumente/Profile_NRW/5-1-1_ALKIS-OK-NRW_GDB.html


-- -----------------------------------------------
--
-- Bevor dies Script verarbeitet wird:
--   Datenbank auf Basis 'template_postgis' anlegen.
--   (Tabellen 'spatial_ref_sys' und 'geometry_columns' sollen bereits vorhanden sein)

-- Nach diesem Script:
--   Views eintragen mit 'alkis_sichten.sql'.

-- Versionierung / Lebenszeitintervall:

--  *Sekundärnachweis ohne Historiennachweis*
--  Im primären ALKIS-Bestand werden verschiedene Versionen eines Objekts verwaltet.
--  Objekte werden nicht gelöscht sondern historisiert (Ende-Zeitpunkt).
--  Hier (im Sekundärbestand) findet sich nur das Datenfeld "beginnt" und kein Feld "endet" weil 
--  über das NBA-Verfahren das historisch gewordene Objekt aus dem sekundären Bestand gelöscht wird.

--  *Sekundärnachweis ohne Historiennachweis*
--   Dann wird zusätzlich ein Feld "endet" analog zum Feld "beginnt" benötigt.


  SET client_encoding = 'UTF8';
--SET standard_conforming_strings = off;
--SET check_function_bodies = false;
--SET client_min_messages = warning;
--SET escape_string_warning = off;
  SET default_with_oids = false;


-- T u n i n g :
--   Die Tabelle 'spatial_ref_sys' einer PostGIS-Datenbank auf 
--   die notwendigen Koordinatensysteme reduzieren. Das Loescht >3000 Eintraege.

--  DELETE FROM spatial_ref_sys
--  WHERE srid NOT 
--  IN (2397, 2398, 2399, 4326,    25830, 25831, 25832, 25833, 25834,  31466, 31467, 31468, 31469);
--  --  Krassowski        lat/lon  UTM                                 GK


-- COMMENT ON DATABASE *** IS 'ALKIS - PostNAS 0.6';

-- ===========================================================
--  		A L K I S  -  L a y e r 
-- ===========================================================


-- S o n s t i g e s   B a u w e r k 
-- ----------------------------------
CREATE TABLE ks_sonstigesbauwerk (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character(28),
	beginnt			character(20),
	sonstigesmodell		character varying(9),
	anlass			integer,
	bauwerksfunktion	integer,
	CONSTRAINT ks_sonstigesbauwerk_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ks_sonstigesbauwerk','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ks_sonstigesbauwerk_geom_idx ON ks_sonstigesbauwerk USING gist (wkb_geometry);



-- B e z i e h u n g e n 
-- ----------------------------------------------
-- Zentrale Tabelle fuer alle Relationen im Buchwerk.

-- Statt Relationen und FOREIGN-KEY-CONSTRAINTS zwischen Tabellen direkt zu legen, gehen 
-- in der ALKIS-Datenstruktur alle Beziehungen zwischen zwei Tabellen über diese Verbindungstabelle.

-- Die Konnectoren 'beziehung_von' und 'beziehung_zu' verweisen auf die ID des Objekte (gml_id).
-- Zusätzlich enthält 'beziehungsart' noch ein Verb für die Art der Beziehung.

CREATE TABLE alkis_beziehungen (
	ogc_fid			serial NOT NULL,
	beziehung_von		character(16),         --> gml_id
	beziehungsart		character varying(35),     --  Liste siehe unten
	beziehung_zu		character(16),         --> gml_id
	CONSTRAINT alkis_beziehungen_pk PRIMARY KEY (ogc_fid)
);
CREATE INDEX id_alkis_beziehungen_von ON alkis_beziehungen USING btree (beziehung_von);
CREATE INDEX id_alkis_beziehungen_zu  ON alkis_beziehungen USING btree (beziehung_zu);

-- Dummy-Eintrag in Metatabelle
INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'alkis_beziehungen', 'dummy', 2, 25832, 'POINT');

COMMENT ON TABLE  alkis_beziehungen               IS 'zentrale Multi-Verbindungstabelle';
COMMENT ON COLUMN alkis_beziehungen.beziehung_von IS 'Join auf gml_id';
COMMENT ON COLUMN alkis_beziehungen.beziehung_zu  IS 'Join auf gml_id';
COMMENT ON COLUMN alkis_beziehungen.beziehungsart IS 'Typ der Beziehung';

-- Beziehungsarten:
--
-- "an" "benennt" "bestehtAusRechtsverhaeltnissenZu" "beziehtSichAuchAuf" "dientZurDarstellungVon"
-- "durch" "gehoertAnteiligZu" "gehoertZu" "hat" "hatAuch" "istBestandteilVon"
-- "istGebucht" "istTeilVon" "weistAuf" "zeigtAuf" "zu"

-- Hinweis:
-- Diese Tabelle enthält für ein Kreisgebiet ca. 5 Mio. Zeilen und wird ständig benutzt.
-- Optimierung z.B. über passende Indices ist wichtig.


-- A n d e r e   F e s t l e g u n g   n a c h   W a s s e r r e c h t
-- --------------------------------------------------------------------
CREATE TABLE ax_anderefestlegungnachwasserrecht (
	ogc_fid				serial NOT NULL,
	gml_id				character(16),	-- character varying(32),
--	identifier			character varying(28),
	beginnt				character(20),
	advstandardmodell		character varying(9),
	anlass				integer,
	artderfestlegung		integer,
	CONSTRAINT ax_anderefestlegungnachwasserrecht_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_anderefestlegungnachwasserrecht','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_anderefestlegungnachwasserrecht_geom_idx
  ON ax_anderefestlegungnachwasserrecht USING gist (wkb_geometry);

-- DROP INDEX ax_anderefestlegungnachwasserrecht_gml;
CREATE UNIQUE INDEX ax_anderefestlegungnachwasserrecht_gml 
                 ON ax_anderefestlegungnachwasserrecht USING btree (gml_id);

COMMENT ON TABLE  ax_anderefestlegungnachwasserrecht        IS 'Andere Festlegung nach  W a s s e r r e c h t';
COMMENT ON COLUMN ax_anderefestlegungnachwasserrecht.gml_id IS 'Identifikator, global eindeutig';


-- B a u b l o c k
-- ----------------------------------------------
CREATE TABLE ax_baublock (
	ogc_fid serial NOT NULL,
	gml_id			character(16),
--	identifier		character(28),
	beginnt			character(20),
	advstandardmodell	character(9),
	anlass			integer,
	baublockbezeichnung	integer,
  CONSTRAINT ax_baublock_pk PRIMARY KEY (ogc_fid)
);
SELECT AddGeometryColumn('ax_baublock','wkb_geometry','25832','MULTIPOLYGON',2);

CREATE INDEX ax_baublock_geom_idx ON ax_baublock USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_baublock_gml 
                 ON ax_baublock USING btree (gml_id);

COMMENT ON TABLE  ax_baublock        IS 'B a u b l o c k';
COMMENT ON COLUMN ax_baublock.gml_id IS 'Identifikator, global eindeutig';


-- B e s o n d e r e r   T o p o g r a f i s c h e r   P u n k t
-- -------------------------------------------------------------
CREATE TABLE ax_besonderertopographischerpunkt (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	land			integer,
	stelle			integer,
	punktkennung		character varying(15), -- integer
	--sonstigeeigenschaft character(26),
	CONSTRAINT ax_besonderertopographischerpunkt_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_besonderertopographischerpunkt', 'dummy', 2, 25832, 'POINT');

CREATE UNIQUE INDEX ax_besonderertopographischerpunkt_gml 
                 ON ax_besonderertopographischerpunkt USING btree (gml_id);

COMMENT ON TABLE  ax_besonderertopographischerpunkt        IS 'B e s o n d e r e r   T o p o g r a f i s c h e r   P u n k t';
COMMENT ON COLUMN ax_besonderertopographischerpunkt.gml_id IS 'Identifikator, global eindeutig';


-- B e w e r t u n g
-- ------------------
CREATE TABLE ax_bewertung (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	klassifizierung		integer,
	CONSTRAINT ax_bewertung_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_bewertung','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_bewertung_geom_idx  ON ax_bewertung  USING gist  (wkb_geometry);

CREATE UNIQUE INDEX ax_bewertung_gml 
                 ON ax_bewertung USING btree (gml_id);

COMMENT ON TABLE  ax_bewertung        IS 'B e w e r t u n g';
COMMENT ON COLUMN ax_bewertung.gml_id IS 'Identifikator, global eindeutig';


-- D e n k m a l s c h u t z r e c h t
-- -----------------------------------
CREATE TABLE ax_denkmalschutzrecht (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	artderfestlegung	integer,
	art			character varying(40), -- (15)
	"name"			character varying(25), -- (15)
  CONSTRAINT ax_denkmalschutzrecht_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_denkmalschutzrecht','wkb_geometry','25832','POLYGON',2);

-- auf MULTIPOLYGON erweitern
ALTER TABLE ax_denkmalschutzrecht 
  DROP CONSTRAINT enforce_geotype_wkb_geometry;

ALTER TABLE ax_denkmalschutzrecht
  ADD CONSTRAINT enforce_geotype_wkb_geometry CHECK (geometrytype(wkb_geometry) = 'POLYGON'::text 
                                                  OR geometrytype(wkb_geometry) = 'MULTIPOLYGON'::text 
                                                  OR wkb_geometry IS NULL);

CREATE INDEX ax_denkmalschutzrecht_geom_idx  ON ax_denkmalschutzrecht  USING gist  (wkb_geometry);

CREATE UNIQUE INDEX ax_denkmalschutzrecht_gml 
                 ON ax_denkmalschutzrecht USING btree (gml_id);

COMMENT ON TABLE  ax_denkmalschutzrecht        IS 'D e n k m a l s c h u t z r e c h t';
COMMENT ON COLUMN ax_denkmalschutzrecht.gml_id IS 'Identifikator, global eindeutig';


-- G e b a e u d e a u s g e s t a l t u n g
-- -----------------------------------------
CREATE TABLE ax_gebaeudeausgestaltung (
	ogc_fid serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character(28),
	beginnt			character(20),
	advstandardmodell	character(9),
	anlass			integer,
	darstellung		integer,
--	zeigtauf		character varying,  -- Relation?
	CONSTRAINT ax_gebaeudeausgestaltung_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_gebaeudeausgestaltung','wkb_geometry','25832','LINESTRING',2);

CREATE INDEX ax_gebaeudeausgestaltung_geom_idx ON ax_gebaeudeausgestaltung USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_gebaeudeausgestaltung_gml 
                 ON ax_gebaeudeausgestaltung USING btree (gml_id);

COMMENT ON TABLE  ax_gebaeudeausgestaltung        IS 'G e b a e u d e a u s g e s t a l t u n g';
COMMENT ON COLUMN ax_gebaeudeausgestaltung.gml_id IS 'Identifikator, global eindeutig';


-- Georeferenzierte  G e b ä u d e a d r e s s e
-- ----------------------------------------------
CREATE TABLE ax_georeferenziertegebaeudeadresse (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),
--	identifier		character varying(28),
	beginnt			character(20),		-- Inhalt z.B. "2008-06-10T15:19:17Z"
							-- ISO:waere   "2008-06-10 15:19:17-00"
--	beginnt			timestamp,		-- timestamp-Format wird nicht geladen, bleibt leer
	advstandardmodell	character varying(9),
	anlass			integer,
	qualitaetsangaben	integer,		-- zb: "1000" (= Massstab)
	--			--			-- Gemeindeschluessel, bestehend aus:
	land			integer,		-- 05 = NRW
	regierungsbezirk	integer,		--   7
	kreis			integer,		--    66
	gemeinde		integer,		--      020
	ortsteil		integer,		--         0
	--			--			-- --
	postleitzahl		character varying(5),	-- mit fuehrenden Nullen
	ortsnamepost		character varying(40),	-- 
	zusatzortsname		character varying(30),	-- 
	strassenname		character varying(50),	-- 
	strassenschluessel	integer,		-- max.  5 Stellen
	hausnummer		integer,		-- meist 3 Stellen
	adressierungszusatz	character varying(1),	-- Hausnummernzusatz-Buchstabe
	CONSTRAINT ax_georeferenziertegebaeudeadresse_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_georeferenziertegebaeudeadresse','wkb_geometry','25832','POINT',2);

CREATE INDEX ax_georeferenziertegebaeudeadresse_geom_idx ON ax_georeferenziertegebaeudeadresse USING gist (wkb_geometry);

-- Index für alkis_beziehungen
CREATE INDEX ax_georeferenziertegebaeudeadresse_gml 
          ON ax_georeferenziertegebaeudeadresse USING btree (gml_id);

-- Suchindex Adresse
CREATE INDEX ax_georeferenziertegebaeudeadresse_adr 
          ON ax_georeferenziertegebaeudeadresse 
  USING btree (strassenschluessel, hausnummer, adressierungszusatz);


COMMENT ON TABLE  ax_georeferenziertegebaeudeadresse        IS 'Georeferenzierte  G e b ä u d e a d r e s s e';
COMMENT ON COLUMN ax_georeferenziertegebaeudeadresse.gml_id IS 'Identifikator, global eindeutig';


-- G r a b l o c h   d e r   B o d e n s c h a e t z u n g
-- -------------------------------------------------------
CREATE TABLE ax_grablochderbodenschaetzung (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	art			character varying(40),  --(15)
	"name"			character varying(27),
	bedeutung		integer,
	land			integer,
	nummerierungsbezirk	character varying(10),
	gemarkungsnummer 	integer,
	nummerdesgrablochs	integer,
	CONSTRAINT ax_grablochderbodenschaetzung_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_grablochderbodenschaetzung','wkb_geometry','25832','POINT',2);

CREATE INDEX ax_grablochderbodenschaetzung_geom_idx  
          ON ax_grablochderbodenschaetzung  USING gist  (wkb_geometry);

-- DROP INDEX ax_grablochderbodenschaetzung_gml;
CREATE UNIQUE INDEX ax_grablochderbodenschaetzung_gml 
                 ON ax_grablochderbodenschaetzung USING btree (gml_id);

COMMENT ON TABLE  ax_grablochderbodenschaetzung        IS 'G r a b l o c h   d e r   B o d e n s c h a e t z u n g';
COMMENT ON COLUMN ax_grablochderbodenschaetzung.gml_id IS 'Identifikator, global eindeutig';


-- H i s t o r i s c h e s   F l u r s t ü c k   A L B
-- ---------------------------------------------------
-- Variante A: "Standardhistorie" (statt ax_historischesflurstueckohneraumbezug)

-- Diese Tabelle bleibt beim Laden mit produktiven Daten (Vollhistorie) leer.
-- Wird vorübergehend benötigt für die Demodaten RLP Mustermonzel.

CREATE TABLE ax_historischesflurstueckalb (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),

	-- GID: AX_Flurstueck_Kerndaten
	-- 'Flurstück_Kerndaten' enthält Eigenschaften des Flurstücks, die auch für andere Flurstücksobjektarten gelten (z.B. Historisches Flurstück).

	land 			integer,         --
	gemarkungsnummer 	integer,            --
	flurnummer		integer,               -- Teile des Flurstückskennzeichens 
	zaehler 		integer,            --    (redundant zu flurstueckskennzeichen)
	nenner			integer,         --
	-- daraus abgeleitet:
	flurstueckskennzeichen	character(20),         -- Inhalt rechts mit __ auf 20 aufgefüllt

	amtlicheflaeche		double precision,      -- AFL
	abweichenderrechtszustand character(5),        -- ARZ
	zweifelhafterFlurstuecksnachweis character(5), -- ZFM Boolean
	rechtsbehelfsverfahren	integer,               -- RBV
	zeitpunktderentstehung	character(10),         -- ZDE  Inhalt jjjj-mm-tt  besser Format date ?

	gemeindezugehoerigkeit	integer,
	gemeinde		integer,  -- Welches von den beiden wird dann gefüllt?
	-- GID: ENDE AX_Flurstueck_Kerndaten

	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
--	art			character varying[],
	"name"			character varying[],

	blattart		integer,
	buchungsart		character varying(11),
	buchungsblattkennzeichen	integer,
--	"buchung|ax_buchung_historischesflurstueck|buchungsblattbezirk|a" integer,
	bezirk					integer,
	buchungsblattnummermitbuchstabenerweiterung	character varying(7), --integer,
	laufendenummerderbuchungsstelle			integer,
	zeitpunktderentstehungdesbezugsflurstuecks	character varying(10),

	vorgaengerflurstueckskennzeichen	character varying[],
	nachfolgerflurstueckskennzeichen	character varying[],
	CONSTRAINT ax_historischesflurstueckalb_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_historischesflurstueckalb', 'dummy', 2, 25832, 'POINT');

CREATE UNIQUE INDEX ax_historischesflurstueckalb_gml 
                 ON ax_historischesflurstueckalb USING btree (gml_id);

-- Suche nach Vorgänger / Nachfolger
-- ++ Welche Methode für ein Array? Wirkt das bei der Suche nach einem einzelnen Wert aus dem Array?
CREATE INDEX idx_histfsalb_vor
   ON ax_historischesflurstueckalb (vorgaengerflurstueckskennzeichen ASC);
  COMMENT ON INDEX idx_histfsalb_vor IS 'Suchen nach Vorgänger-Flurstück';

CREATE INDEX idx_histfsalb_nach
   ON ax_historischesflurstueckalb (vorgaengerflurstueckskennzeichen ASC);
  COMMENT ON INDEX idx_histfsalb_vor IS 'Suchen nach Nachfolger-Flurstück';


  COMMENT ON TABLE  ax_historischesflurstueckalb        IS 'Historisches Flurstück ALB';
  COMMENT ON COLUMN ax_historischesflurstueckalb.gml_id IS 'Identifikator, global eindeutig';

  COMMENT ON COLUMN ax_historischesflurstueckalb.flurnummer                IS 'FLN "Flurnummer" ist die von der Katasterbehörde zur eindeutigen Bezeichnung vergebene Nummer einer Flur, die eine Gruppe von zusammenhängenden Flurstücken innerhalb einer Gemarkung umfasst.';
  COMMENT ON COLUMN ax_historischesflurstueckalb.zaehler                   IS 'ZAE  Dieses Attribut enthält den Zähler der Flurstücknummer';
  COMMENT ON COLUMN ax_historischesflurstueckalb.nenner                    IS 'NEN  Dieses Attribut enthält den Nenner der Flurstücknummer';

  COMMENT ON COLUMN ax_historischesflurstueckalb.flurstueckskennzeichen    IS '"Flurstückskennzeichen" ist ein von der Katasterbehörde zur eindeutigen Bezeichnung des Flurstücks vergebenes Ordnungsmerkmal.
Die Attributart setzt sich aus den nachfolgenden expliziten Attributarten in der angegebenen Reihenfolge zusammen:
 1.  Land (2 Stellen)
 2.  Gemarkungsnummer (4 Stellen)
 3.  Flurnummer (3 Stellen)
 4.  Flurstücksnummer
 4.1 Zähler (5 Stellen)
 4.2 Nenner (4 Stellen)
 5.  Flurstücksfolge (2 Stellen)
Die Elemente sind rechtsbündig zu belegen, fehlende Stellen sind mit führenden Nullen zu belegen.
Da die Flurnummer und die Flurstücksfolge optional sind, sind aufgrund der bundeseinheitlichen Definition im Flurstückskennzeichen die entsprechenden Stellen, sofern sie nicht belegt sind, durch Unterstrich "_" ersetzt.
Gleiches gilt für Flurstücksnummern ohne Nenner, hier ist der fehlende Nenner im Flurstückskennzeichen durch Unterstriche zu ersetzen.';

  COMMENT ON COLUMN ax_historischesflurstueckalb.amtlicheflaeche           IS 'AFL "Amtliche Fläche" ist der im Liegenschaftskataster festgelegte Flächeninhalt des Flurstücks in [qm]. Flurstücksflächen kleiner 0,5 qm können mit bis zu zwei Nachkommastellen geführt werden, ansonsten ohne Nachkommastellen.';
  COMMENT ON COLUMN ax_historischesflurstueckalb.abweichenderrechtszustand IS 'ARZ "Abweichender Rechtszustand" ist ein Hinweis darauf, dass außerhalb des Grundbuches in einem durch Gesetz geregelten Verfahren der Bodenordnung (siehe Objektart "Bau-, Raum- oder Bodenordnungsrecht", AA "Art der Festlegung", Werte 1750, 1770, 2100 bis 2340) ein neuer Rechtszustand eingetreten ist und das amtliche Verzeichnis der jeweiligen ausführenden Stelle maßgebend ist.';
  COMMENT ON COLUMN ax_historischesflurstueckalb.zweifelhafterFlurstuecksnachweis IS 'ZFM "Zweifelhafter Flurstücksnachweis" ist eine Kennzeichnung eines Flurstücks, dessen Angaben nicht zweifelsfrei berichtigt werden können.';
  COMMENT ON COLUMN ax_historischesflurstueckalb.rechtsbehelfsverfahren    IS 'RBV "Rechtsbehelfsverfahren" ist der Hinweis darauf, dass bei dem Flurstück ein laufendes Rechtsbehelfsverfahren anhängig ist.';
  COMMENT ON COLUMN ax_historischesflurstueckalb.zeitpunktderentstehung    IS 'ZDE "Zeitpunkt der Entstehung" ist der Zeitpunkt, zu dem das Flurstück fachlich entstanden ist.';

  COMMENT ON COLUMN ax_historischesflurstueckalb.gemeindezugehoerigkeit    IS 'GDZ "Gemeindezugehörigkeit" enthält das Gemeindekennzeichen zur Zuordnung der Flustücksdaten zu einer Gemeinde.';
-- oder gemeinde?



-- Historisches Flurstück (ALKIS)
-- ------------------------------
-- Die "neue" Historie, die durch Fortführungen innerhalb von ALKIS entstanden ist.
CREATE TABLE ax_historischesflurstueck (
	ogc_fid				serial NOT NULL,
	gml_id				character(16),
--	identifier			character(28),

	-- GID: AX_Flurstueck_Kerndaten
	-- 'Flurstück_Kerndaten' enthält Eigenschaften des Flurstücks, die auch für andere Flurstücksobjektarten gelten (z.B. Historisches Flurstück).

	land 				integer,         --
	gemarkungsnummer 		integer,            --
	flurnummer			integer,               -- Teile des Flurstückskennzeichens 
	zaehler 			integer,            --    (redundant zu flurstueckskennzeichen)
	nenner				integer,         --
	-- daraus abgeleitet:
	flurstueckskennzeichen	character(20),         -- Inhalt rechts mit __ auf 20 aufgefüllt

	amtlicheflaeche			double precision,      -- AFL
	abweichenderrechtszustand	character varying(5),        -- ARZ
	zweifelhafterFlurstuecksnachweis character varying(5), -- ZFM Boolean
	rechtsbehelfsverfahren		integer,               -- RBV
	zeitpunktderentstehung		character(10),         -- ZDE  Inhalt jjjj-mm-tt  besser Format date ?

	gemeindezugehoerigkeit		integer,
	gemeinde			integer,  -- Welches von den beiden wird dann gefüllt?
	-- GID: ENDE AX_Flurstueck_Kerndaten

	beginnt				character(20),
	advstandardmodell		character varying(9),
	anlass				integer,
	art				character varying[], -- Array
	"name"				character varying[], -- Array

--	"gemeindezugehoerigkeit|ax_gemeindekennzeichen|land"	integer,
	regierungsbezirk		integer,
	kreis				integer,
	vorgaengerflurstueckskennzeichen	character varying[],  -- array von FS-Kennzeichen
	nachfolgerflurstueckskennzeichen	character varying[],
	blattart			integer,
	buchungsart			integer,
	buchungsblattkennzeichen	double precision,
--	"buchung|ax_buchung_historischesflurstueck|buchungsblattbezirk|a"	integer,
	bezirk				integer,
	buchungsblattnummermitbuchstabenerweiterung	character(20), --integer, -- hier länger als (7)!
	laufendenummerderbuchungsstelle	integer,
	CONSTRAINT ax_historischesflurstueck_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_historischesflurstueck','wkb_geometry','25832','POLYGON',2);

-- auf MULTIPOLYGON erweitern
ALTER TABLE ax_historischesflurstueck 
  DROP CONSTRAINT enforce_geotype_wkb_geometry;

ALTER TABLE ax_historischesflurstueck
  ADD CONSTRAINT enforce_geotype_wkb_geometry CHECK (geometrytype(wkb_geometry) = 'POLYGON'::text 
                                                  OR geometrytype(wkb_geometry) = 'MULTIPOLYGON'::text 
                                                  OR wkb_geometry IS NULL);

CREATE INDEX ax_historischesflurstueck_geom_idx ON ax_historischesflurstueck USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_historischesflurstueck_gml 
                 ON ax_historischesflurstueck USING btree (gml_id);


-- Suche nach Vorgänger / Nachfolger
-- ++ Welche Methode für ein Array? 
-- Wirkt das überhaupt bei der Suche nach einem einzelnen Wert aus dem Array?
CREATE INDEX idx_histfs_vor
   ON ax_historischesflurstueck (vorgaengerflurstueckskennzeichen ASC);
COMMENT ON INDEX idx_histfsalb_vor IS 'Suchen nach Vorgänger-Flurstück';

CREATE INDEX idx_histfs_nach
   ON ax_historischesflurstueck (vorgaengerflurstueckskennzeichen ASC);
COMMENT ON INDEX idx_histfsalb_vor IS 'Suchen nach Nachfolger-Flurstück';

-- Die postgresql-Doku sagt dazu (http://www.postgresql.org/docs/9.1/static/arrays.html):
-- Arrays are not sets; 
-- searching for specific array elements can be a sign of database misdesign.
-- Consider using a separate table with a row for each item that would be an array element.
-- This will be easier to search, and is likely to scale better for a large number of elements. 


  COMMENT ON TABLE  ax_historischesflurstueck        IS 'Historisches Flurstück, ALKIS, MIT Geometrie';
  COMMENT ON COLUMN ax_historischesflurstueck.gml_id IS 'Identifikator, global eindeutig';

  COMMENT ON COLUMN ax_historischesflurstueck.flurnummer                IS 'FLN "Flurnummer" ist die von der Katasterbehörde zur eindeutigen Bezeichnung vergebene Nummer einer Flur, die eine Gruppe von zusammenhängenden Flurstücken innerhalb einer Gemarkung umfasst.';
  COMMENT ON COLUMN ax_historischesflurstueck.zaehler                   IS 'ZAE  Dieses Attribut enthält den Zähler der Flurstücknummer';
  COMMENT ON COLUMN ax_historischesflurstueck.nenner                    IS 'NEN  Dieses Attribut enthält den Nenner der Flurstücknummer';

  COMMENT ON COLUMN ax_historischesflurstueck.flurstueckskennzeichen    IS '"Flurstückskennzeichen" ist ein von der Katasterbehörde zur eindeutigen Bezeichnung des Flurstücks vergebenes Ordnungsmerkmal.
Die Attributart setzt sich aus den nachfolgenden expliziten Attributarten in der angegebenen Reihenfolge zusammen:
 1.  Land (2 Stellen)
 2.  Gemarkungsnummer (4 Stellen)
 3.  Flurnummer (3 Stellen)
 4.  Flurstücksnummer
 4.1 Zähler (5 Stellen)
 4.2 Nenner (4 Stellen)
 5.  Flurstücksfolge (2 Stellen)
Die Elemente sind rechtsbündig zu belegen, fehlende Stellen sind mit führenden Nullen zu belegen.
Da die Flurnummer und die Flurstücksfolge optional sind, sind aufgrund der bundeseinheitlichen Definition im Flurstückskennzeichen die entsprechenden Stellen, sofern sie nicht belegt sind, durch Unterstrich "_" ersetzt.
Gleiches gilt für Flurstücksnummern ohne Nenner, hier ist der fehlende Nenner im Flurstückskennzeichen durch Unterstriche zu ersetzen.';

  COMMENT ON COLUMN ax_historischesflurstueck.amtlicheflaeche           IS 'AFL "Amtliche Fläche" ist der im Liegenschaftskataster festgelegte Flächeninhalt des Flurstücks in [qm]. Flurstücksflächen kleiner 0,5 qm können mit bis zu zwei Nachkommastellen geführt werden, ansonsten ohne Nachkommastellen.';
  COMMENT ON COLUMN ax_historischesflurstueck.abweichenderrechtszustand IS 'ARZ "Abweichender Rechtszustand" ist ein Hinweis darauf, dass außerhalb des Grundbuches in einem durch Gesetz geregelten Verfahren der Bodenordnung (siehe Objektart "Bau-, Raum- oder Bodenordnungsrecht", AA "Art der Festlegung", Werte 1750, 1770, 2100 bis 2340) ein neuer Rechtszustand eingetreten ist und das amtliche Verzeichnis der jeweiligen ausführenden Stelle maßgebend ist.';
  COMMENT ON COLUMN ax_historischesflurstueck.zweifelhafterFlurstuecksnachweis IS 'ZFM "Zweifelhafter Flurstücksnachweis" ist eine Kennzeichnung eines Flurstücks, dessen Angaben nicht zweifelsfrei berichtigt werden können.';
  COMMENT ON COLUMN ax_historischesflurstueck.rechtsbehelfsverfahren    IS 'RBV "Rechtsbehelfsverfahren" ist der Hinweis darauf, dass bei dem Flurstück ein laufendes Rechtsbehelfsverfahren anhängig ist.';
  COMMENT ON COLUMN ax_historischesflurstueck.zeitpunktderentstehung    IS 'ZDE "Zeitpunkt der Entstehung" ist der Zeitpunkt, zu dem das Flurstück fachlich entstanden ist.';

  COMMENT ON COLUMN ax_historischesflurstueck.gemeindezugehoerigkeit    IS 'GDZ "Gemeindezugehörigkeit" enthält das Gemeindekennzeichen zur Zuordnung der Flustücksdaten zu einer Gemeinde.';
-- oder gemeinde?


-- Kennzeichen indizieren, z.B. fuer Suche aus der Historie
CREATE INDEX ax_historischesflurstueck_kennz
   ON ax_historischesflurstueck USING btree (flurstueckskennzeichen ASC NULLS LAST);
COMMENT ON INDEX ax_historischesflurstueck_kennz IS 'Suche nach Flurstückskennzeichen';



-- N  a t u r -,  U m w e l t -   o d e r   B o d e n s c h u t z r e c h t
-- ------------------------------------------------------------------------
CREATE TABLE ax_naturumweltoderbodenschutzrecht (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	artderfestlegung	integer,
	CONSTRAINT ax_naturumweltoderbodenschutzrecht_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_naturumweltoderbodenschutzrecht','wkb_geometry','25832','POLYGON',2);

-- auf MULTIPOLYGON erweitern
ALTER TABLE ax_naturumweltoderbodenschutzrecht 
  DROP CONSTRAINT enforce_geotype_wkb_geometry;

ALTER TABLE ax_naturumweltoderbodenschutzrecht
  ADD CONSTRAINT enforce_geotype_wkb_geometry CHECK (geometrytype(wkb_geometry) = 'POLYGON'::text 
                                                  OR geometrytype(wkb_geometry) = 'MULTIPOLYGON'::text 
                                                  OR wkb_geometry IS NULL);

CREATE INDEX ax_naturumweltoderbodenschutzrecht_geom_idx
          ON ax_naturumweltoderbodenschutzrecht USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_naturumweltoderbodenschutzrecht_gml 
                 ON ax_naturumweltoderbodenschutzrecht USING btree (gml_id);

COMMENT ON TABLE  ax_naturumweltoderbodenschutzrecht        IS 'N  a t u r -,  U m w e l t -   o d e r   B o d e n s c h u t z r e c h t';
COMMENT ON COLUMN ax_naturumweltoderbodenschutzrecht.gml_id IS 'Identifikator, global eindeutig';


-- S c h u t z g e b i e t   n a c h   W a s s s e r r e c h t
-- -----------------------------------------------------------
CREATE TABLE ax_schutzgebietnachwasserrecht (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	artderfestlegung	integer,
	art			character varying(40), --(15)
	"name"			character varying(20),
	nummerdesschutzgebietes	character varying(20),
	CONSTRAINT ax_schutzgebietnachwasserrecht_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_schutzgebietnachwasserrecht', 'dummy', 2, 25832, 'POINT');

CREATE UNIQUE INDEX ax_schutzgebietnachwasserrecht_gml 
                 ON ax_schutzgebietnachwasserrecht USING btree (gml_id);

COMMENT ON TABLE  ax_schutzgebietnachwasserrecht        IS 'S c h u t z g e b i e t   n a c h   W a s s s e r r e c h t';
COMMENT ON COLUMN ax_schutzgebietnachwasserrecht.gml_id IS 'Identifikator, global eindeutig';


-- S c h u t z z o n e
-- ----------------------------------------------
CREATE TABLE ax_schutzzone (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	"zone"			integer,
	art			character varying(40), --(15)
	CONSTRAINT ax_schutzzone_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_schutzzone','wkb_geometry','25832','POLYGON',2);

-- auf MULTIPOLYGON erweitern
ALTER TABLE ax_schutzzone 
  DROP CONSTRAINT enforce_geotype_wkb_geometry;

ALTER TABLE ax_schutzzone
  ADD CONSTRAINT enforce_geotype_wkb_geometry CHECK (geometrytype(wkb_geometry) = 'POLYGON'::text 
                                                  OR geometrytype(wkb_geometry) = 'MULTIPOLYGON'::text 
                                                  OR wkb_geometry IS NULL);

CREATE INDEX ax_schutzzone_geom_idx ON ax_schutzzone USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_schutzzone_gml 
                 ON ax_schutzzone USING btree (gml_id);

COMMENT ON TABLE  ax_schutzzone        IS 'S c h u t z z o n e';
COMMENT ON COLUMN ax_schutzzone.gml_id IS 'Identifikator, global eindeutig';


-- T o p o g r a p h i s c h e   L i n i e 
-- ---------------------------------------------------
CREATE TABLE ax_topographischelinie (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	liniendarstellung	integer,
	sonstigeeigenschaft	character varying(21),
	CONSTRAINT ax_topographischelinie_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_topographischelinie','wkb_geometry','25832','LINESTRING',2);

CREATE INDEX ax_topographischelinie_geom_idx ON ax_topographischelinie USING gist(wkb_geometry);

CREATE UNIQUE INDEX ax_topographischelinie_gml 
                 ON ax_topographischelinie USING btree (gml_id);

COMMENT ON TABLE  ax_topographischelinie        IS 'T o p o g r a p h i s c h e   L i n i e';
COMMENT ON COLUMN ax_topographischelinie.gml_id IS 'Identifikator, global eindeutig';


-- #### Oberhalb dieser Marke stehende Tabellen wurden im "AAA Basisschema" in der verwendeten 
-- #### Dokumentation nicht gefunden.
-- #### Sie wurden von PostNAS aus den vorliegenden NAS-Daten generiert.


--*** ############################################################
--*** Objektbereich: AAA Basisschema
--*** ############################################################

--** Objektartengruppe: AAA_Praesentationsobjekte
--   ===================================================================

--AP_GPO
-- ** Tabelle bisher noch nicht generiert


-- A P   P P O
-- ----------------------------------------------
CREATE TABLE ap_ppo (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying[],
	sonstigesmodell		character varying(9),
	anlass			integer,
	signaturnummer		integer,
	art			character varying(20),
	drehwinkel		double precision,
	CONSTRAINT ap_ppo_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ap_ppo','wkb_geometry','25832','MULTIPOINT',2);  

-- verschiedene Geometrie-Typen (0.5: POINT -> MULTIPOINT)
ALTER TABLE ap_ppo DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ap_ppo_geom_idx ON ap_ppo USING gist (wkb_geometry);

-- Verbindungstabellen indizieren
CREATE INDEX ap_ppo_gml 
          ON ap_ppo     USING btree (gml_id);

COMMENT ON TABLE  ap_ppo        IS 'PPO: Punktförmiges Präsentationsobjekt';
COMMENT ON COLUMN ap_ppo.gml_id IS 'Identifikator, global eindeutig';


-- A P   L P O
-- ----------------------------------------------
CREATE TABLE ap_lpo (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
--	beginnt			timestamp without time zone,	-- Feld bleibt leer, wenn als timestamp angelegt!
	advstandardmodell	character varying[],		-- hier als Array!
	anlass			integer,
	signaturnummer		integer,
	art			character varying(5),
	CONSTRAINT ap_lpo_pk PRIMARY KEY (ogc_fid)
);
SELECT AddGeometryColumn('ap_lpo','wkb_geometry','25832','LINESTRING',2);

CREATE INDEX ap_lpo_geom_idx ON ap_lpo USING gist (wkb_geometry);

--DROP INDEX ap_lpo_gml;
CREATE UNIQUE INDEX ap_lpo_gml 
                 ON ap_lpo USING btree (gml_id);

COMMENT ON TABLE  ap_lpo        IS 'LPO: Linienförmiges Präsentationsobjekt';
COMMENT ON COLUMN ap_lpo.gml_id IS 'Identifikator, global eindeutig';


--AP_FPO
-- ** Tabelle bisher noch nicht generiert


--AP_TPO
-- ** Tabelle bisher noch nicht generiert


-- A P   P T O
-- ----------------------------------------------
CREATE TABLE ap_pto (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),  -- PostNAS 0.5: bleibt leer 
	beginnt			character(20),
	advstandardmodell	character varying[],
	anlass			integer,
	schriftinhalt		character varying(50),  -- (47)
	fontsperrung		double precision,
	skalierung		double precision,
	horizontaleausrichtung	character varying(13),
	vertikaleausrichtung	character varying(5),
	signaturnummer		integer,
	art			character varying(40),  -- (18)
	drehwinkel		double precision,       -- falsche Masseinheit für Mapserver, im View umrechnen
--	"zeigtaufexternes|aa_fachdatenverbindung|art" character varying(40),
	--"name"		character varying(17),          -- leer?
	CONSTRAINT ap_pto_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ap_pto','wkb_geometry','25832','POINT',2);

CREATE INDEX ap_pto_geom_idx ON ap_pto USING gist (wkb_geometry);

-- Verbindungstabellen indizieren
CREATE INDEX ap_pto_gml ON ap_pto USING btree (gml_id);
CREATE INDEX art_idx    ON ap_pto USING btree (art);

COMMENT ON TABLE  ap_pto               IS 'PTO: Textförmiges Präsentationsobjekt mit punktförmiger Textgeometrie ';
COMMENT ON COLUMN ap_pto.gml_id        IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ap_pto.schriftinhalt IS 'Label: anzuzeigender Text';
COMMENT ON INDEX  art_idx              IS 'Suchindex auf häufig benutztem Filterkriterium';


-- A P   L T O
-- ----------------------------------------------
CREATE TABLE ap_lto (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying(9),
	anlass			integer,
	art			character varying(3),
	schriftinhalt		character varying(40),	-- generiert als (11), aber Strassennamen abgeschnitten
	fontsperrung		integer,
	skalierung		integer,
	horizontaleausrichtung	character varying(12),
	vertikaleausrichtung	character varying(5),
	CONSTRAINT ap_lto_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ap_lto','wkb_geometry','25832','LINESTRING',2);

CREATE INDEX ap_lto_geom_idx ON ap_lto USING gist (wkb_geometry);

-- Verbindungstabellen indizieren
CREATE INDEX ap_lto_gml ON ap_lto USING btree (gml_id);

COMMENT ON TABLE  ap_lto        IS 'LTO: Textförmiges Präsentationsobjekt mit linienförmiger Textgeometrie';
COMMENT ON COLUMN ap_lto.gml_id IS 'Identifikator, global eindeutig';


-- A P  D a r s t e l l u n g
-- ----------------------------------------------
CREATE TABLE ap_darstellung (
	ogc_fid			serial NOT NULL, 
	gml_id			character(16),	-- character varying(32), 
--	identifier		character varying(28),		-- leer
	beginnt			character(20),			-- Datumsformat
--	beginnt			timestamp without time zone,	-- dies Format wird nicht gefuellt
	advstandardmodell	character varying(9),
	anlass			integer, 
	art			character varying(40),		-- (37)
	signaturnummer		integer,
	CONSTRAINT ap_darstellung_pk PRIMARY KEY (ogc_fid)
);

-- Die Geometrie bleibt leer
--SELECT AddGeometryColumn('ap_darstellung','wkb_geometry','25832','POINT',2);
--CREATE INDEX ap_darstellung_geom_idx ON ap_darstellung USING gist (wkb_geometry);

-- daher ersatzweise:  Dummy-Eintrag in Metatabelle
INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ap_darstellung', 'dummy', 2, 25832, 'POINT');

--DROP INDEX ap_darstellung_gml;
CREATE UNIQUE INDEX ap_darstellung_gml 
                 ON ap_darstellung USING btree (gml_id);

COMMENT ON TABLE  ap_darstellung        IS 'A P  D a r s t e l l u n g';
COMMENT ON COLUMN ap_darstellung.gml_id IS 'Identifikator, global eindeutig';

-- Feld "beginnt" hat z.B. Format '2008-11-18T15:17:26Z'


--*** ############################################################
--*** Objektbereich: Flurstücke, Lage, Punkte
--*** ############################################################

--** Objektartengruppe: Angaben zum Flurstück
--   ===================================================================

-- F l u r s t u e c k
-- ----------------------------------------------
-- Kennung 11001
CREATE TABLE ax_flurstueck (
	ogc_fid				serial NOT NULL,
	gml_id				character(16),         -- Datenbank-Tabelle interner Schlüssel
--	identifier			character varying(28), -- Kann wech? redundant: gml_id mit prefix
--	zustaendigeStelle		character varying,     -- ZST

	-- GID: AX_Flurstueck_Kerndaten
	-- 'Flurstück_Kerndaten' enthält Eigenschaften des Flurstücks, die auch für andere Flurstücksobjektarten gelten (z.B. Historisches Flurstück).

	land 				integer,         --
	gemarkungsnummer 		integer,            --
	flurnummer			integer,               -- Teile des Flurstückskennzeichens 
	zaehler 			integer,            --    (redundant zu flurstueckskennzeichen)
	nenner				integer,         --
	-- daraus abgeleitet:
	flurstueckskennzeichen		character(20),         -- Inhalt rechts mit __ auf 20 aufgefüllt

	amtlicheflaeche			double precision,      -- AFL
	abweichenderrechtszustand	character varying(5),  -- ARZ
	zweifelhafterFlurstuecksnachweis character varying(5), -- ZFM Boolean
	rechtsbehelfsverfahren		integer,               -- RBV
	zeitpunktderentstehung		character(10),         -- ZDE  Inhalt jjjj-mm-tt  besser Format date ?

	gemeindezugehoerigkeit		integer,
	gemeinde			integer,  -- Welches von den beiden wird dann gefüllt?
	-- GID: ENDE AX_Flurstueck_Kerndaten

	beginnt				character(20),         -- Timestamp der Enststehung
	advstandardmodell 		character varying(9),  -- steuert die Darstellung nach Kartentyp
	anlass				integer,               -- 
--	art				character varying[],   -- Wozu braucht man das? Weglassen?
	"name"				character varying[],   -- 03.11.2011: array, Buchauskunft anpassen!
	regierungsbezirk		integer,
	kreis				integer,
	CONSTRAINT ax_flurstueck_pk PRIMARY KEY (ogc_fid)
);


SELECT AddGeometryColumn('ax_flurstueck','wkb_geometry','25832','MULTIPOLYGON',2);
-- verschiedene Geometrietypen?
ALTER TABLE ax_flurstueck DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_flurstueck_geom_idx   ON ax_flurstueck USING gist (wkb_geometry);

-- Verbindungstabellen indizieren
CREATE UNIQUE INDEX ax_flurstueck_gml
                 ON ax_flurstueck  USING btree (gml_id);

  COMMENT ON TABLE  ax_flurstueck                           IS '"F l u r s t u e c k" ist ein Teil der Erdoberfläche, der von einer im Liegenschaftskataster festgelegten Grenzlinie umschlossen und mit einer Nummer bezeichnet ist. Es ist die Buchungseinheit des Liegenschaftskatasters.';
  COMMENT ON COLUMN ax_flurstueck.gml_id                    IS 'Identifikator, global eindeutig';
--COMMENT ON COLUMN ax_flurstueck.zustaendigeStelle         IS 'ZST "Flurstück" wird verwaltet von "Dienststelle". Diese Attributart wird nur dann belegt, wenn eine fachliche Zuständigkeit über eine Gemarkung bzw. Gemarkungsteil/Flur nicht abgebildet werden kann. Die Attributart enthält den Dienststellenschlüssel der Stelle, die fachlich für ein Flurstück zustandig ist.';
  COMMENT ON COLUMN ax_flurstueck.flurnummer                IS 'FLN "Flurnummer" ist die von der Katasterbehörde zur eindeutigen Bezeichnung vergebene Nummer einer Flur, die eine Gruppe von zusammenhängenden Flurstücken innerhalb einer Gemarkung umfasst.';
  COMMENT ON COLUMN ax_flurstueck.zaehler                   IS 'ZAE  Dieses Attribut enthält den Zähler der Flurstücknummer';
  COMMENT ON COLUMN ax_flurstueck.nenner                    IS 'NEN  Dieses Attribut enthält den Nenner der Flurstücknummer';

  COMMENT ON COLUMN ax_flurstueck.flurstueckskennzeichen    IS '"Flurstückskennzeichen" ist ein von der Katasterbehörde zur eindeutigen Bezeichnung des Flurstücks vergebenes Ordnungsmerkmal.
Die Attributart setzt sich aus den nachfolgenden expliziten Attributarten in der angegebenen Reihenfolge zusammen:
 1.  Land (2 Stellen)
 2.  Gemarkungsnummer (4 Stellen)
 3.  Flurnummer (3 Stellen)
 4.  Flurstücksnummer
 4.1 Zähler (5 Stellen)
 4.2 Nenner (4 Stellen)
 5.  Flurstücksfolge (2 Stellen)
Die Elemente sind rechtsbündig zu belegen, fehlende Stellen sind mit führenden Nullen zu belegen.
Da die Flurnummer und die Flurstücksfolge optional sind, sind aufgrund der bundeseinheitlichen Definition im Flurstückskennzeichen die entsprechenden Stellen, sofern sie nicht belegt sind, durch Unterstrich "_" ersetzt.
Gleiches gilt für Flurstücksnummern ohne Nenner, hier ist der fehlende Nenner im Flurstückskennzeichen durch Unterstriche zu ersetzen.';

  COMMENT ON COLUMN ax_flurstueck.amtlicheflaeche           IS 'AFL "Amtliche Fläche" ist der im Liegenschaftskataster festgelegte Flächeninhalt des Flurstücks in [qm]. Flurstücksflächen kleiner 0,5 qm können mit bis zu zwei Nachkommastellen geführt werden, ansonsten ohne Nachkommastellen.';
  COMMENT ON COLUMN ax_flurstueck.abweichenderrechtszustand IS 'ARZ "Abweichender Rechtszustand" ist ein Hinweis darauf, dass außerhalb des Grundbuches in einem durch Gesetz geregelten Verfahren der Bodenordnung (siehe Objektart "Bau-, Raum- oder Bodenordnungsrecht", AA "Art der Festlegung", Werte 1750, 1770, 2100 bis 2340) ein neuer Rechtszustand eingetreten ist und das amtliche Verzeichnis der jeweiligen ausführenden Stelle maßgebend ist.';
  COMMENT ON COLUMN ax_flurstueck.zweifelhafterFlurstuecksnachweis IS 'ZFM "Zweifelhafter Flurstücksnachweis" ist eine Kennzeichnung eines Flurstücks, dessen Angaben nicht zweifelsfrei berichtigt werden können.';
  COMMENT ON COLUMN ax_flurstueck.rechtsbehelfsverfahren    IS 'RBV "Rechtsbehelfsverfahren" ist der Hinweis darauf, dass bei dem Flurstück ein laufendes Rechtsbehelfsverfahren anhängig ist.';
  COMMENT ON COLUMN ax_flurstueck.zeitpunktderentstehung    IS 'ZDE "Zeitpunkt der Entstehung" ist der Zeitpunkt, zu dem das Flurstück fachlich entstanden ist.';

  COMMENT ON COLUMN ax_flurstueck.gemeindezugehoerigkeit    IS 'GDZ "Gemeindezugehörigkeit" enthält das Gemeindekennzeichen zur Zuordnung der Flustücksdaten zu einer Gemeinde.';
-- oder gemeinde?

  COMMENT ON COLUMN ax_flurstueck.anlass                    IS '?';
  COMMENT ON COLUMN ax_flurstueck.art                       IS '?';
  COMMENT ON COLUMN ax_flurstueck.name                      IS 'Array mit Fortführungsjahr und -Nummer';
  COMMENT ON COLUMN ax_flurstueck.regierungsbezirk          IS 'Regierungsbezirk';
  COMMENT ON COLUMN ax_flurstueck.kreis                     IS 'Kreis';


-- Kennzeichen indizieren, z.B. fuer Suche aus der Historie
CREATE INDEX ax_flurstueck_kennz
   ON ax_flurstueck USING btree (flurstueckskennzeichen ASC NULLS LAST);
COMMENT ON INDEX ax_flurstueck_kennz IS 'Suche nach Flurstückskennzeichen';


-- Relationen:
--  istGebucht                --> AX_Buchungsstelle
--  zeigtAuf                  --> AX_LagebezeichnungOhneHausnummer
--  weistAuf                  --> AX_LagebezeichnungMitHausnummer
--  gehoertAnteiligZu         --> AX_Flurstueck
--  beziehtSichAufFlurstueck  --> AX_Flurstueck



-- B e s o n d e r e   F l u r s t u e c k s g r e n z e
-- -----------------------------------------------------
CREATE TABLE ax_besondereflurstuecksgrenze (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	artderflurstuecksgrenze	integer[],  -- geaendert. 18.09.2011
	CONSTRAINT ax_besondereflurstuecksgrenze_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_besondereflurstuecksgrenze','wkb_geometry','25832','LINESTRING',2);

CREATE INDEX ax_besondereflurstuecksgrenze_geom_idx 
          ON ax_besondereflurstuecksgrenze USING gist (wkb_geometry);
          
CREATE UNIQUE INDEX ax_besondereflurstuecksgrenze_gml 
                 ON ax_besondereflurstuecksgrenze USING btree (gml_id);

COMMENT ON TABLE  ax_besondereflurstuecksgrenze        IS 'B e s o n d e r e   F l u r s t u e c k s g r e n z e';
COMMENT ON COLUMN ax_besondereflurstuecksgrenze.gml_id IS 'Identifikator, global eindeutig';


-- G r e n z p u n k t
-- ----------------------------------------------
CREATE TABLE ax_grenzpunkt (
	ogc_fid				serial NOT NULL,
	gml_id				character(16),	-- character varying(32),
--	identifier			character varying(28),
	beginnt				character(20),
	advstandardmodell		character varying(9),
	anlass				integer,
	punktkennung			character varying(15), -- integer,
	land				integer,
	stelle				integer,
	abmarkung_marke			integer,
	festgestelltergrenzpunkt	character varying(4),
	bemerkungzurabmarkung		integer,
	sonstigeeigenschaft		character varying[],
	art				character varying(40), --(37)
	"name"				character varying[],
	zeitpunktderentstehung		integer,
	--uri				character varying(28)
	CONSTRAINT ax_grenzpunkt_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_grenzpunkt', 'dummy', 2, 25832, 'POINT');

-- DROP INDEX ax_grenzpunkt_gml;
CREATE UNIQUE INDEX ax_grenzpunkt_gml 
                 ON ax_grenzpunkt USING btree (gml_id);

COMMENT ON TABLE  ax_grenzpunkt        IS 'G r e n z p u n k t';
COMMENT ON COLUMN ax_grenzpunkt.gml_id IS 'Identifikator, global eindeutig';


--AX_Flurstueck_Kerndaten
-- ** Tabelle bisher noch nicht generiert

--AX_Flurstuecksnummer
-- ** Tabelle bisher noch nicht generiert

--AX_SonstigeEigenschaften_Flurstueck
-- ** Tabelle bisher noch nicht generiert


--** Objektartengruppe: Angaben zur Lage
--   ===================================================================


-- L a g e b e z e i c h n u n g   o h n e   H a u s n u m m e r
-- -------------------------------------------------------------
CREATE TABLE ax_lagebezeichnungohnehausnummer (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	unverschluesselt	character varying(61), -- Straßenname?
	land			integer,
	regierungsbezirk	integer,
	kreis			integer,
	gemeinde		integer,
	lage			character varying(5),  -- integer?
	CONSTRAINT ax_lagebezeichnungohnehausnummer_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_lagebezeichnungohnehausnummer', 'dummy', 2, 25832, 'POINT');

-- Verbindungstabellen indizieren
CREATE UNIQUE INDEX ax_lagebezeichnungohnehausnummer_gml 
                 ON ax_lagebezeichnungohnehausnummer USING btree (gml_id);

-- Such-Index (z.B. fuer Navigations-Programm)
CREATE INDEX ax_lagebezeichnungohnehausnummer_key ON ax_lagebezeichnungohnehausnummer USING btree (land, regierungsbezirk, kreis, gemeinde,lage);

COMMENT ON TABLE  ax_lagebezeichnungohnehausnummer        IS 'L a g e b e z e i c h n u n g   o h n e   H a u s n u m m e r';
COMMENT ON COLUMN ax_lagebezeichnungohnehausnummer.gml_id IS 'Identifikator, global eindeutig';


-- L a g e b e z e i c h n u n g   m i t   H a u s n u m m e r
-- -----------------------------------------------------------
--   ax_flurstueck  >weistAuf>    AX_LagebezeichnungMitHausnummer
--                  <gehoertZu<
CREATE TABLE ax_lagebezeichnungmithausnummer (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	land			integer,
	regierungsbezirk	integer,
	kreis			integer,
	gemeinde		integer,

--	lage			integer,  -- Strassenschluessel (Alt: PostNAS 0.5)
	-- Hier immer numerisch (Straßenschlüssel), also integer.
	-- Fremdschlüssel 'ax_lagebezeichnungkatalogeintrag' kann aber auch nicht numerische Zeichen
	-- enthalten (z.B. Sonderfall Bahnstrecke)
	-- Dies Char-Feld wird von PostNAS 0.5 *ohne* fuehrende Nullen gefuellt.
	-- Der ForeignKey "ax_lagebezeichnungkatalogeintrag.lage" jedoch *mit* fuehrenden Nullen.

	lage			character varying(5), -- Strassenschluessel --AE 2011-05-11
	-- siehe http://trac.osgeo.org/gdal/changeset/22336

	hausnummer		character varying(6),  --  Nummern (blank) Zusatz
	CONSTRAINT ax_lagebezeichnungmithausnummer_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_lagebezeichnungmithausnummer', 'dummy', 2, 25832, 'POINT');

-- Verbindungstabellen indizieren
CREATE UNIQUE INDEX ax_lagebezeichnungmithausnummer_gml 
                 ON ax_lagebezeichnungmithausnummer USING btree (gml_id);

-- Adressen-Suche nach Strasse
CREATE INDEX ax_lagebezeichnungmithausnummer_lage 
          ON ax_lagebezeichnungmithausnummer USING btree (gemeinde, lage);

COMMENT ON TABLE  ax_lagebezeichnungmithausnummer        IS 'L a g e b e z e i c h n u n g   m i t   H a u s n u m m e r';
COMMENT ON COLUMN ax_lagebezeichnungmithausnummer.gml_id IS 'Identifikator, global eindeutig';


-- L a g e b e z e i c h n u n g   m i t  P s e u d o n u m m e r
-- --------------------------------------------------------------
-- Nebengebäude: lfd-Nummer eines Nebengebäudes zu einer (Pseudo-) Hausnummer
CREATE TABLE ax_lagebezeichnungmitpseudonummer (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	land			integer,
	regierungsbezirk	integer,
	kreis			integer,
	gemeinde		integer,


--	lage			integer,  -- Strassenschluessel (Alt: PostNAS 0.5)
	lage			character varying(5), -- Strassenschluessel -- Änderung zu Ticket 9 AE 2011-05-11

	pseudonummer		character varying(5),
	laufendenummer		character varying(2), -- leer, Zahl, "P2"
	CONSTRAINT ax_lagebezeichnungmitpseudonummer_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_lagebezeichnungmitpseudonummer', 'dummy', 2, 25832, 'POINT');

-- Verbindungstabellen indizieren
CREATE UNIQUE INDEX ax_lagebezeichnungmitpseudonummer_gml 
                 ON ax_lagebezeichnungmitpseudonummer USING btree (gml_id);

COMMENT ON TABLE  ax_lagebezeichnungmitpseudonummer        IS 'L a g e b e z e i c h n u n g   m i t  P s e u d o n u m m e r';
COMMENT ON COLUMN ax_lagebezeichnungmitpseudonummer.gml_id IS 'Identifikator, global eindeutig';


--AX_Lagebezeichnung	Auswahldatentyp
--AX_Lage Geändert (Revisionsnummer: 1750)


--** Objektartengruppe: Angaben zum Netzpunkt
--   ===================================================================


-- A u f n a h m e p u n k t
-- ----------------------------------------------
CREATE TABLE ax_aufnahmepunkt (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	punktkennung		character varying(15),   --integer ist zu klein,
	land			integer,
	stelle			integer,
	sonstigeeigenschaft	character varying[],
	vermarkung_marke	integer,
	CONSTRAINT ax_aufnahmepunkt_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_aufnahmepunkt', 'dummy', 2, 25832, 'POINT');

-- DROP INDEX ax_aufnahmepunkt_gml;
CREATE UNIQUE INDEX ax_aufnahmepunkt_gml 
                 ON ax_aufnahmepunkt USING btree (gml_id);

COMMENT ON TABLE  ax_aufnahmepunkt        IS 'A u f n a h m e p u n k t';
COMMENT ON COLUMN ax_aufnahmepunkt.gml_id IS 'Identifikator, global eindeutig';


--AX_Sicherungspunkt
-- ** Tabelle bisher noch nicht generiert


-- s o n s t i g e r   V e r m e s s u n g s p u n k t
-- ---------------------------------------------------
CREATE TABLE ax_sonstigervermessungspunkt (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	vermarkung_marke	integer,
	punktkennung		character varying(15), -- integer,
	land			integer,
	stelle			integer,
	sonstigeeigenschaft	character varying[],
	CONSTRAINT ax_sonstigervermessungspunkt_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_sonstigervermessungspunkt', 'dummy', 2, 25832, 'POINT');

-- DROP INDEX ax_sonstigervermessungspunkt_gml;
CREATE UNIQUE INDEX ax_sonstigervermessungspunkt_gml 
                 ON ax_sonstigervermessungspunkt USING btree (gml_id);

COMMENT ON TABLE  ax_sonstigervermessungspunkt        IS 's o n s t i g e r   V e r m e s s u n g s p u n k t';
COMMENT ON COLUMN ax_sonstigervermessungspunkt.gml_id IS 'Identifikator, global eindeutig';


--AX_Netzpunkt
-- ** Tabelle bisher noch nicht generiert


--** Objektartengruppe: Angaben zum Punktort
--   ===================================================================


--AX_Punktort


-- P u n k t o r t   AG
-- ----------------------------------------------
CREATE TABLE ax_punktortag (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	art			character varying[],
	"name"			character varying[],
	--kartendarstellung	character varying(5), -- true/false
	kartendarstellung	integer,
--	"qualitaetsangaben|ax_dqpunktort|herkunft|li_lineage|processstep" integer, -- character varying[],
	genauigkeitsstufe	integer,
	vertrauenswuerdigkeit	integer,
	CONSTRAINT ax_punktortag_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_punktortag','wkb_geometry','25832','POINT',2);

CREATE INDEX ax_punktortag_geom_idx ON ax_punktortag USING gist (wkb_geometry);

--DROP INDEX ax_punktortag_gml;
CREATE UNIQUE INDEX ax_punktortag_gml 
                 ON ax_punktortag USING btree (gml_id);

COMMENT ON TABLE  ax_punktortag        IS 'P u n k t o r t   AG';
COMMENT ON COLUMN ax_punktortag.gml_id IS 'Identifikator, global eindeutig';


-- P u n k t o r t   A U
-- ----------------------------------------------
CREATE TABLE ax_punktortau (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
--	kartendarstellung	character varying(5), -- true / false: boolean
	kartendarstellung	integer, 
--	art			character varying(61),  - entbehrlich
	"name"			character varying(26),
--	"qualitaetsangaben|ax_dqpunktort|herkunft|li_lineage|processstep" integer,  --character varying[],
--	datetime		character varying(40),
	individualname		character varying(7),
	vertrauenswuerdigkeit	integer,
	genauigkeitsstufe	integer,
	CONSTRAINT ax_punktortau_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_punktortau','wkb_geometry','25832','POINT',2);

CREATE INDEX ax_punktortau_geom_idx ON ax_punktortau USING gist (wkb_geometry);

--DROP INDEX ax_punktortau_gml;
CREATE UNIQUE INDEX ax_punktortau_gml 
                 ON ax_punktortau USING btree (gml_id);

COMMENT ON TABLE  ax_punktortau        IS 'P u n k t o r t   A U';
COMMENT ON COLUMN ax_punktortau.gml_id IS 'Identifikator, global eindeutig';


-- P u n k t o r t   T A
-- ----------------------------------------------
CREATE TABLE ax_punktortta (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
--	kartendarstellung	character(5), -- true/false
	kartendarstellung	integer,      -- boolean
	description		integer,
	art			character varying[],  -- character(61),
	"name"			character varying[],
--	"qualitaetsangaben|ax_dqpunktort|herkunft|li_lineage|source|li_s"	integer,
--	characterstring		character varying(10), -- merkwuerdig, rlp: Inhalt = "Berechnung"
--	datetime		character varying(20), -- merkwuerdig, rlp: Inhalt = "1900-01-01T00:00:00Z"
	genauigkeitsstufe	integer,
	vertrauenswuerdigkeit	integer,
	CONSTRAINT ax_punktortta_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_punktortta','wkb_geometry','25832','POINT',2);

CREATE INDEX ax_punktortta_geom_idx ON ax_punktortta USING gist (wkb_geometry);

--DROP INDEX ax_punktortta_gml;
CREATE UNIQUE INDEX ax_punktortta_gml 
                 ON ax_punktortta USING btree (gml_id);

COMMENT ON TABLE  ax_punktortta        IS 'P u n k t o r t   T A';
COMMENT ON COLUMN ax_punktortta.gml_id IS 'Identifikator, global eindeutig';


--AX_DQPunktort

--AX_LI_Lineage_Punktort

--AX_LI_ProcessStep_Punktort

--AX_LI_Source_Punktort


--** Objektartengruppe: Fortführungsnachweis
--   ===================================================================


-- F o r t f u e h r u n g s n a c h w e i s / D e c k b l a t t
-- --------------------------------------------------------------
-- neu 02.11.2011

CREATE TABLE ax_fortfuehrungsnachweisdeckblatt (
	ogc_fid				serial NOT NULL,
	gml_id				character(16),
--	identifier			character varying(28),
	beginnt				character varying(20),
	advstandardmodell		character varying(9),
	anlass				integer,
--	art				character varying(43),		-- entbehrlich
	uri				character varying(28),
	fortfuehrungsfallnummernbereich	character varying(7),
	land				integer,
	gemarkungsnummer		integer,
	laufendenummer			integer,
	titel				character varying(40),
--	"ingemarkung|ax_gemarkung_schluessel|land"	integer,	-- land '5'
--	"ingemarkung|ax_gemarkung_schluessel|gemarkungsnummer"	integer,	-- gemarkung (4)
	erstelltam			character varying(10),		-- Datum jjjj-mm-tt
	fortfuehrungsentscheidungam	character varying(10),
	fortfuehrungsentscheidungvon	character varying(40),		-- Bearbeiter-Name und -Titel
	bemerkung			character varying(80),
	beziehtsichauf			character varying,
	CONSTRAINT ax_fortfuehrungsnachweisdeckblatt_pk PRIMARY KEY (ogc_fid)
);

-- Dummy-Eintrag in Metatabelle geometry-columns um PostNAS-Meldungen zu vermeiden:
INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_fortfuehrungsnachweisdeckblatt', 'dummy', 2, 25832, 'POINT');

COMMENT ON TABLE  ax_fortfuehrungsnachweisdeckblatt
IS 'F o r t f u e h r u n g s n a c h w e i s / D e c k b l a t t';


-- F o r t f u e h r u n g s f a l l
-- ---------------------------------
-- neu 02.11.2011

CREATE TABLE ax_fortfuehrungsfall (
	ogc_fid					serial NOT NULL,
	gml_id					character(16),
--	identifier				character varying(28),
	beginnt					character varying(20),
	advstandardmodell			character varying(9),
	anlass					integer,
--	art					character varying(40),  -- entbehrlich
	uri					character varying(28),
	fortfuehrungsfallnummer			integer,
	laufendenummer				integer,
	ueberschriftimfortfuehrungsnachweis	integer[],
	anzahlderfortfuehrungsmitteilungen	integer,
	zeigtaufaltesflurstueck			character varying[], -- Format wie flurstueckskennzeichen (20) als Array
	zeigtaufneuesflurstueck			character varying[], -- Format wie flurstueckskennzeichen (20) als Array
	bemerkung				character varying(14),
	CONSTRAINT ax_fortfuehrungsfall_pk PRIMARY KEY (ogc_fid)
);

-- Dummy-Eintrag in Metatabelle geometry-columns um PostNAS-Meldungen zu vermeiden:
INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_fortfuehrungsfall', 'dummy', 2, 25832, 'POINT');

COMMENT ON TABLE  ax_fortfuehrungsfall IS 'F o r t f u e h r u n g s f a l l';


--
--AX_Fortfuehrungsnummer

--
--AX_Auszug

--
--AX_K_ANSCHRIFT

--
--AX_K_AUSGKOPF_Standard

--
--AX_FGraphik

--
--AX_Landeswappen


--** Objektartengruppe: Angaben zur Reservierung
--   ===================================================================

-- R e s e r v i e r u n g
-- -----------------------
-- Neu: 02.11.2011

CREATE TABLE ax_reservierung (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),
--	identifier		character varying(28),
	beginnt			character varying(20),
	advstandardmodell	character varying(9),
	art			integer,
	nummer			character varying(20),
	land			integer,
	stelle			integer,
	ablaufderreservierung	character varying(10),
	antragsnummer		character varying(13),
	auftragsnummer		character varying(17),
	CONSTRAINT ax_reservierung_pk PRIMARY KEY (ogc_fid)
);

-- Dummy-Eintrag in Metatabelle geometry-columns um PostNAS-Meldungen zu vermeiden:
INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_reservierung', 'dummy', 2, 25832, 'POINT');


-- P u n k t k e n n u n g  U n t e r g e g a n g e n
-- --------------------------------------------------
-- Neu: 02.11.2011

CREATE TABLE ax_punktkennunguntergegangen (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),
--	identifier		character varying(28),
	beginnt			character varying(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying(9),
	anlass			integer,
	punktkennung		character varying(15),
	art			integer,
	CONSTRAINT ax_punktkennunguntergegangen_pk PRIMARY KEY (ogc_fid)
);

-- Dummy-Eintrag in Metatabelle geometry-columns um PostNAS-Meldungen zu vermeiden:
INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_punktkennunguntergegangen', 'dummy', 2, 25832, 'POINT');



--AX_Reservierungsauftrag_Gebietskennung


--** Objektartengruppe: Angaben zur Historie
--   ===================================================================

-- Variante B: "Vollhistorie" ( statt ax_historischesflurstueckalb)

-- AX_HistorischesFlurstueckOhneRaumbezug

CREATE TABLE ax_historischesflurstueckohneraumbezug (
	ogc_fid					serial NOT NULL,
	gml_id					character(16),

	-- GID: AX_Flurstueck_Kerndaten
	-- 'Flurstück_Kerndaten' enthält Eigenschaften des Flurstücks, die auch für andere Flurstücksobjektarten gelten (z.B. Historisches Flurstück).

	land 				integer,         --
	gemarkungsnummer 		integer,            --
	flurnummer			integer,               -- Teile des Flurstückskennzeichens 
	zaehler 			integer,            --    (redundant zu flurstueckskennzeichen)
	nenner				integer,         --
	-- daraus abgeleitet:
	flurstueckskennzeichen		character(20),         -- Inhalt rechts mit __ auf 20 aufgefüllt

	amtlicheflaeche			double precision,      -- AFL
	abweichenderrechtszustand	character varying(5),        -- ARZ
	zweifelhafterFlurstuecksnachweis character varying(5), -- ZFM Boolean
	rechtsbehelfsverfahren		integer,               -- RBV
	zeitpunktderentstehung		character(10),         -- ZDE  Inhalt jjjj-mm-tt  besser Format date ?

	gemeindezugehoerigkeit		integer,
	gemeinde			integer,  -- Welches von den beiden wird dann gefüllt?
	-- GID: ENDE AX_Flurstueck_Kerndaten

--	identifier			character(28),  -- verzichtbar?
	beginnt				character(20),
	advstandardmodell		character varying(9),
	anlass				integer,
--	art				character varying[], -- Array {a,b,c}  -- verzichtbar?
	"name"				character varying[], -- Array {a,b,c}

	nachfolgerflurstueckskennzeichen	character varying[], -- Array {a,b,c}
	vorgaengerflurstueckskennzeichen	character varying[], -- Array {a,b,c}
--	istgebucht			character varying,
	CONSTRAINT ax_historischesflurstueckohneraumbezug_pk PRIMARY KEY (ogc_fid)
);

  COMMENT ON TABLE  ax_historischesflurstueckohneraumbezug        IS '"Historisches Flurstück ohne Raumbezug" ist ein nicht mehr aktuelles Flurstück, das schon im ALB historisch geworden ist, nach ALKIS migriert und im Rahmen der Vollhistorie geführt wird.';
  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.gml_id IS 'Identifikator, global eindeutig';

  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.flurnummer                IS 'FLN "Flurnummer" ist die von der Katasterbehörde zur eindeutigen Bezeichnung vergebene Nummer einer Flur, die eine Gruppe von zusammenhängenden Flurstücken innerhalb einer Gemarkung umfasst.';
  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.zaehler                   IS 'ZAE  Dieses Attribut enthält den Zähler der Flurstücknummer';
  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.nenner                    IS 'NEN  Dieses Attribut enthält den Nenner der Flurstücknummer';

  COMMENT ON COLUMN ax_flurstueck.flurstueckskennzeichen    IS '"Flurstückskennzeichen" ist ein von der Katasterbehörde zur eindeutigen Bezeichnung des Flurstücks vergebenes Ordnungsmerkmal.
Die Attributart setzt sich aus den nachfolgenden expliziten Attributarten in der angegebenen Reihenfolge zusammen:
 1.  Land (2 Stellen)
 2.  Gemarkungsnummer (4 Stellen)
 3.  Flurnummer (3 Stellen)
 4.  Flurstücksnummer
 4.1 Zähler (5 Stellen)
 4.2 Nenner (4 Stellen)
 5.  Flurstücksfolge (2 Stellen)
Die Elemente sind rechtsbündig zu belegen, fehlende Stellen sind mit führenden Nullen zu belegen.
Da die Flurnummer und die Flurstücksfolge optional sind, sind aufgrund der bundeseinheitlichen Definition im Flurstückskennzeichen die entsprechenden Stellen, sofern sie nicht belegt sind, durch Unterstrich "_" ersetzt.
Gleiches gilt für Flurstücksnummern ohne Nenner, hier ist der fehlende Nenner im Flurstückskennzeichen durch Unterstriche zu ersetzen.';

  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.amtlicheflaeche           IS 'AFL "Amtliche Fläche" ist der im Liegenschaftskataster festgelegte Flächeninhalt des Flurstücks in [qm]. Flurstücksflächen kleiner 0,5 qm können mit bis zu zwei Nachkommastellen geführt werden, ansonsten ohne Nachkommastellen.';
  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.abweichenderrechtszustand IS 'ARZ "Abweichender Rechtszustand" ist ein Hinweis darauf, dass außerhalb des Grundbuches in einem durch Gesetz geregelten Verfahren der Bodenordnung (siehe Objektart "Bau-, Raum- oder Bodenordnungsrecht", AA "Art der Festlegung", Werte 1750, 1770, 2100 bis 2340) ein neuer Rechtszustand eingetreten ist und das amtliche Verzeichnis der jeweiligen ausführenden Stelle maßgebend ist.';
  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.zweifelhafterFlurstuecksnachweis IS 'ZFM "Zweifelhafter Flurstücksnachweis" ist eine Kennzeichnung eines Flurstücks, dessen Angaben nicht zweifelsfrei berichtigt werden können.';
  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.rechtsbehelfsverfahren    IS 'RBV "Rechtsbehelfsverfahren" ist der Hinweis darauf, dass bei dem Flurstück ein laufendes Rechtsbehelfsverfahren anhängig ist.';
  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.zeitpunktderentstehung    IS 'ZDE "Zeitpunkt der Entstehung" ist der Zeitpunkt, zu dem das Flurstück fachlich entstanden ist.';

  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.gemeindezugehoerigkeit    IS 'GDZ "Gemeindezugehörigkeit" enthält das Gemeindekennzeichen zur Zuordnung der Flustücksdaten zu einer Gemeinde.';
-- oder gemeinde?

  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.anlass                    IS '?';
--COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.art                       IS '?';
  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.name                      IS 'Array mit Fortführungsjahr und -Nummer';
  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.regierungsbezirk          IS 'Regierungsbezirk';
  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.kreis                     IS 'Kreis';

  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.nachfolgerflurstueckskennzeichen 
  IS '"Nachfolger-Flurstückskennzeichen" ist die Bezeichnung der Flurstücke, die dem Objekt "Historisches Flurstück ohne Raumbezug" direkt nachfolgen.
Array mit Kennzeichen im Format der Spalte "flurstueckskennzeichen"';

  COMMENT ON COLUMN ax_historischesflurstueckohneraumbezug.vorgaengerflurstueckskennzeichen 
  IS '"Vorgänger-Flurstückskennzeichen" ist die Bezeichnung der Flurstücke, die dem Objekt "Historisches Flurstück ohne Raumbezugs" direkt vorangehen.
Array mit Kennzeichen im Format der Spalte "flurstueckskennzeichen"';


-- keine Geometrie, daher ersatzweise: Dummy-Eintrag in Metatabelle
INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_historischesflurstueckohneraumbezug', 'dummy', 2, 25832, 'POINT');

-- Kennzeichen indizieren, z.B. fuer Suche aus der Historie
CREATE INDEX ax_hist_fs_ohne_kennz
   ON ax_historischesflurstueckohneraumbezug USING btree (flurstueckskennzeichen ASC NULLS LAST);
COMMENT ON INDEX ax_hist_fs_ohne_kennz IS 'Suche nach Flurstückskennzeichen';

-- Suche nach Vorgänger / Nachfolger
-- ++ Welche Methode für ein Array? Wirkt das bei der Suche nach einem einzelnen Wert aus dem Array?
CREATE INDEX idx_histfsor_vor
   ON ax_historischesflurstueckohneraumbezug (vorgaengerflurstueckskennzeichen ASC);
COMMENT ON INDEX idx_histfsalb_vor IS 'Suchen nach Vorgänger-Flurstück';

CREATE INDEX idx_histfsor_nach
   ON ax_historischesflurstueckohneraumbezug (vorgaengerflurstueckskennzeichen ASC);
COMMENT ON INDEX idx_histfsalb_vor IS 'Suchen nach Nachfolger-Flurstück';



-- *** ############################################################
-- *** Objektbereich: Eigentümer
-- *** ############################################################


-- ** Objektartengruppe:Personen- und Bestandsdaten
--   ===================================================================


-- 21001 P e r s o n
-- ----------------------------------------------
-- Buchwerk. Keine Geometrie
CREATE TABLE ax_person (
	ogc_fid				serial NOT NULL,
	gml_id				character(16),	-- character varying(32),
--	identifier			character varying(28),
	beginnt				character(20),
	advstandardmodell		character varying(9),
	--sonstigesmodell		character varying(9),
	anlass				integer,
	nachnameoderfirma		character varying(100), --(97),
	anrede				integer,        -- 'Anrede' ist die Anrede der Person. Diese Attributart ist optional, da Körperschaften und juristischen Person auch ohne Anrede angeschrieben werden können.
	-- Bezeichner	Wert
	--       Frau	1000
	--       Herr	2000
	--      Firma	3000
	vorname				character varying(40),  --(31),
	geburtsname			character varying(50),  --(36),
	geburtsdatum			character varying(10),  -- Datumsformat?
	namensbestandteil		character varying(20),
	akademischergrad		character varying(16),  -- 'Akademischer Grad' ist der akademische Grad der Person (z.B. Dipl.-Ing., Dr., Prof. Dr.)
	--art				character varying(40),  -- (37)  Wozu?
	--uri				character varying(28),  -- Wozu ?
	-- hat				character varying,      -- bliebt leer, Beziehung?
	CONSTRAINT ax_person_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_person', 'dummy', 2, 25832, 'POINT');

-- Verbindungstabellen indizieren
CREATE UNIQUE INDEX id_ax_person_gml   
                 ON ax_person  USING btree (gml_id);

COMMENT ON TABLE  ax_person        IS 'NREO "Person" ist eine natürliche oder juristische Person und kann z.B. in den Rollen Eigentümer, Erwerber, Verwalter oder Vertreter in Katasterangelegenheiten geführt werden.';
COMMENT ON COLUMN ax_person.gml_id IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_person.namensbestandteil IS 'enthält z.B. Titel wie "Baron"';

-- Relationen:
-- hat:		Die 'Person' hat 'Anschrift'.
-- weist auf:	Durch die Relation 'Person' weist auf 'Namensnummer' wird ausgedrückt, dass die Person als Eigentümer,
--		Erbbauberechtigter oder künftiger Erwerber unter der Namensnummer eines Buchungsblattes eingetragen ist.


--AX_Personengruppe
-- ** Tabelle bisher noch nicht generiert


-- A n s c h r i f t
-- ----------------------------------------------
-- Buchwerk, keine Geometrie.
-- Konverter versucht Tabelle noch einmal anzulegen, wenn kein (Dummy-) Eintrag in Metatabelle 'geometry_columns'.
CREATE TABLE ax_anschrift (
	ogc_fid				serial NOT NULL,
	gml_id				character(16),
--	identifier			character varying(28),
	beginnt				character(20),
	advstandardmodell		character varying(9),
	--sonstigesmodell		character varying(9),
	anlass				integer,
	--art				character varying[],
	--uri				character varying[],
	ort_post			character varying(30),
	postleitzahlpostzustellung	integer,
	strasse				character varying(40),
	hausnummer			character varying(9), -- integer
	bestimmungsland			character varying(30),
	CONSTRAINT ax_anschrift_pk PRIMARY KEY (ogc_fid)
);

-- Dummy-Eintrag in Metatabelle
INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_anschrift', 'dummy', 2, 25832, 'POINT');

-- Index für alkis_beziehungen
CREATE UNIQUE INDEX ax_anschrift_gml 
                 ON ax_anschrift USING btree (gml_id);

COMMENT ON TABLE  ax_anschrift        IS 'A n s c h r i f t';
COMMENT ON COLUMN ax_anschrift.gml_id IS 'Identifikator, global eindeutig';


-- N a m e n s n u m m e r
-- ----------------------------------------------
-- Buchwerk. Keine Geometrie
CREATE TABLE ax_namensnummer (
	ogc_fid				serial NOT NULL,
	gml_id				character(16),
--	identifier			character varying(28),
	beginnt				character(20),
	advstandardmodell		character varying(9),
	anlass				integer,
	laufendenummernachdin1421	character(16),      -- 0000.00.00.00.00
	zaehler				double precision,   -- Anteil ..
	nenner				double precision,   --    .. als Bruch 
	eigentuemerart			integer,
	nummer				character varying(6), -- immer leer ?
	artderrechtsgemeinschaft	integer,            -- Schlüssel
	beschriebderrechtsgemeinschaft	character varying(1000),  -- (977)
	CONSTRAINT ax_namensnummer_pk PRIMARY KEY (ogc_fid)
);

-- Filter   istbestandteilvon <> '' or benennt <> '' or bestehtausrechtsverhaeltnissenzu <> ''

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_namensnummer', 'dummy', 2, 25832, 'POINT');

-- Verbindungstabellen indizieren
CREATE UNIQUE INDEX ax_namensnummer_gml 
                 ON ax_namensnummer USING btree (gml_id);

COMMENT ON TABLE  ax_namensnummer        IS 'NREO "Namensnummer" ist die laufende Nummer der Eintragung, unter welcher der Eigentümer oder Erbbauberechtigte im Buchungsblatt geführt wird. Rechtsgemeinschaften werden auch unter AX_Namensnummer geführt.';
COMMENT ON COLUMN ax_namensnummer.gml_id IS 'Identifikator, global eindeutig';


-- B u c h u n g s b l a t t
-- -------------------------
CREATE TABLE ax_buchungsblatt (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	buchungsblattkennzeichen	character varying(13), -- integer
	land			integer,
	bezirk			integer,
	buchungsblattnummermitbuchstabenerweiterung	character varying(7),
	blattart		integer,
	art			character varying(15),
	-- "name" character(13),  -- immer leer?
	CONSTRAINT ax_buchungsblatt_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_buchungsblatt', 'dummy', 2, 25832, 'POINT');

-- Index für alkis_beziehungen
CREATE INDEX ax_buchungsblatt_gml ON ax_buchungsblatt USING btree (gml_id);

COMMENT ON TABLE  ax_buchungsblatt        IS 'NREO "Buchungsblatt" enthält die Buchungen (Buchungsstellen und Namensnummern) des Grundbuchs und des Liegenschhaftskatasters (bei buchungsfreien Grundstücken).';
COMMENT ON COLUMN ax_buchungsblatt.gml_id IS 'Identifikator, global eindeutig';


-- B u c h u n g s s t e l l e
-- -----------------------------
CREATE TABLE ax_buchungsstelle (
	ogc_fid				serial NOT NULL,
	gml_id				character(16),	-- character varying(32),
--	identifier			character varying(28),
	beginnt				character(20),
	advstandardmodell		character varying(9),
	anlass				integer,
	buchungsart			integer,
	laufendenummer			integer,
	beschreibungdesumfangsderbuchung	character(1),
	--art				character(37),
	--uri				character(12),
	zaehler				double precision,
	nenner				integer,
	nummerimaufteilungsplan		character varying(40),   -- (32)
	beschreibungdessondereigentums	character varying(400),  -- (291)
	CONSTRAINT ax_buchungsstelle_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_buchungsstelle', 'dummy', 2, 25832, 'POINT');

--Index für alkis_beziehungen
CREATE UNIQUE INDEX ax_buchungsstelle_gml 
                 ON ax_buchungsstelle USING btree (gml_id);

COMMENT ON TABLE  ax_buchungsstelle        IS 'NREO "Buchungsstelle" ist die unter einer laufenden Nummer im Verzeichnis des Buchungsblattes eingetragene Buchung.';
COMMENT ON COLUMN ax_buchungsstelle.gml_id IS 'Identifikator, global eindeutig';


--AX_Anteil
-- ** Tabelle bisher noch nicht generiert

--AX_DQOhneDatenerhebung
-- ** Tabelle bisher noch nicht generiert

--AX_LI_Lineage_OhneDatenerhebung
-- ** Tabelle bisher noch nicht generiert

--AX_LI_ProcessStep_OhneDatenerhebung
-- ** Tabelle bisher noch nicht generiert


--*** ############################################################
--*** Objektbereich: Gebäude
--*** ############################################################

--** Objektartengruppe:Angaben zum Gebäude
--   ===================================================================

--AX_Gebaeude

-- G e b a e u d e
-- ---------------
-- Abgleich 2011-11-15 mit 
--  http://www.bezreg-koeln.nrw.de/extra/33alkis/dokumente/Profile_NRW/ALKIS-OK-NRW_MAX_20090722.html#_3B2A042900B5
CREATE TABLE ax_gebaeude (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),		-- character varying(32),
--	identifier		character varying(28),	-- redundant zu gml_id
	beginnt			character(20),
	advstandardmodell	character varying(9),
--	sonstigesmodell		character(9),
	anlass			integer,
	gebaeudefunktion	integer,		-- Werte siehe Schlüsseltabelle
	weiteregebaeudefunktion	integer,		-- Neu 2011-11-15
	"name"			character varying(25),
--	nutzung			character varying,	-- ???
	bauweise		integer,
	anzahlderoberirdischengeschosse	integer,
	anzahlderunterirdischengeschosse	integer, -- Neu 2011-11-15
	hochhaus		character varying(5),	-- Neu 2011-11-15  Boolean "true"/"false", meist aber leer
	objekthoehe		integer,
	dachform		integer,		-- Neu 2011-11-15
	zustand			integer,
	geschossflaeche		integer,		-- Neu 2011-11-15
	grundflaeche		integer,		-- Neu 2011-11-15
	umbauterraum		integer,		-- Neu 2011-11-15
	baujahr			integer,		-- Neu 2011-11-15
	lagezurerdoberflaeche	integer,
	dachart			character varying(30),	-- Neu 2011-11-15
	dachgeschossausbau	integer,		-- Neu 2011-11-15
	qualitaetsangaben	character varying(8),	-- neu 2011-11-15
--	description		integer,
--	art			character varying(40),
--	individualname		character varying(7),

	CONSTRAINT ax_gebaeude_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_gebaeude','wkb_geometry','25832','MULTIPOLYGON',2);

-- auf MULTIPOLYGON erweitern
ALTER TABLE ax_gebaeude 
  DROP CONSTRAINT enforce_geotype_wkb_geometry;

ALTER TABLE ax_gebaeude
  ADD CONSTRAINT enforce_geotype_wkb_geometry CHECK (geometrytype(wkb_geometry) = 'POLYGON'::text 
                                                  OR geometrytype(wkb_geometry) = 'MULTIPOLYGON'::text 
                                                  OR wkb_geometry IS NULL);

CREATE INDEX ax_gebaeude_geom_idx ON ax_gebaeude USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_gebaeude_gml
                 ON ax_gebaeude  USING btree  (gml_id);

  COMMENT ON TABLE  ax_gebaeude                    IS '"G e b ä u d e" ist ein dauerhaft errichtetes Bauwerk, dessen Nachweis wegen seiner Bedeutung als Liegenschaft erforderlich ist sowie dem Zweck der Basisinformation des Liegenschaftskatasters dient.';
  COMMENT ON COLUMN ax_gebaeude.gml_id             IS 'Identifikator, global eindeutig';
  COMMENT ON COLUMN ax_gebaeude.gebaeudefunktion   IS 'GFK "Gebäudefunktion" ist die zum Zeitpunkt der Erhebung vorherrschend funktionale Bedeutung des Gebäudes (Dominanzprinzip). Werte siehe ax_gebaeude_funktion';
  COMMENT ON COLUMN ax_gebaeude.weiteregebaeudefunktion IS 'WGF "Weitere Gebäudefunktion" ist die Funktion, die ein Gebäude neben der dominierenden Gebäudefunktion hat.';
  COMMENT ON COLUMN ax_gebaeude."name"             IS 'NAM "Name" ist der Eigenname oder die Bezeichnung des Gebäudes.';
--COMMENT ON COLUMN ax_gebaeude.nutzung            IS 'NTZ "Nutzung" ist die Gebäudenutzung und enthält den jeweiligen prozentualen Nutzungsanteil an der Gesamtnutzung.';
  COMMENT ON COLUMN ax_gebaeude.bauweise           IS 'BAW "Bauweise" ist die Beschreibung der Art der Bauweise. Werte siehe ax_gebaeude_bauweise';
  COMMENT ON COLUMN ax_gebaeude.anzahlderoberirdischengeschosse IS 'AOG "Anzahl der oberirdischen Geschosse" ist die Anzahl der oberirdischen Geschosse des Gebäudes.';
  COMMENT ON COLUMN ax_gebaeude.anzahlderunterirdischengeschosse IS 'AUG "Anzahl der unterirdischen Geschosse" ist die Anzahl der unterirdischen Geschosse des Gebäudes.';
  COMMENT ON COLUMN ax_gebaeude.hochhaus           IS 'HOH "Hochhaus" ist ein Gebäude, das nach Gebäudehöhe und Ausprägung als Hochhaus zu bezeichnen ist. Für Gebäude im Geschossbau gilt dieses i.d.R. ab 8 oberirdischen Geschossen, für andere Gebäude ab einer Gebäudehöhe von 22 m. Abweichungen hiervon können sich durch die Festlegungen in den länderspezifischen Bauordnungen ergeben.';
  COMMENT ON COLUMN ax_gebaeude.objekthoehe        IS 'HHO "Objekthöhe" ist die Höhendifferenz in [m] zwischen dem höchsten Punkt der Dachkonstruktion und der festgelegten Geländeoberfläche des Gebäudes.';
  COMMENT ON COLUMN ax_gebaeude.dachform           IS 'DAF "Dachform" beschreibt die charakteristische Form des Daches. Werte siehe ax_gebaeude_dachform';
  COMMENT ON COLUMN ax_gebaeude.zustand            IS 'ZUS "Zustand" beschreibt die Beschaffenheit oder die Betriebsbereitschaft von "Gebäude". Diese Attributart wird nur dann optional geführt, wenn der Zustand des Gebäudes vom nutzungsfähigen Zustand abweicht. Werte siehe ax_gebaeude_zustand';
  COMMENT ON COLUMN ax_gebaeude.geschossflaeche    IS 'GFL "Geschossfläche" ist die Gebäudegeschossfläche in [qm].';
  COMMENT ON COLUMN ax_gebaeude.grundflaeche       IS 'GRF "Grundfläche" ist die Gebäudegrundfläche in [qm].';
  COMMENT ON COLUMN ax_gebaeude.umbauterraum       IS 'URA "Umbauter Raum" ist der umbaute Raum [Kubikmeter] des Gebäudes.';
  COMMENT ON COLUMN ax_gebaeude.baujahr            IS 'BJA "Baujahr" ist das Jahr der Fertigstellung oder der baulichen Veränderung des Gebäudes.';
  COMMENT ON COLUMN ax_gebaeude.lagezurerdoberflaeche IS 'OFL "Lage zur Erdoberfläche" ist die Angabe der relativen Lage des Gebäudes zur Erdoberfläche. Diese Attributart wird nur bei nicht ebenerdigen Gebäuden geführt. 1200=Unter der Erdoberfläche, 1400=Aufgeständert';
  COMMENT ON COLUMN ax_gebaeude.dachart            IS 'DAA "Dachart" gibt die Art der Dacheindeckung (z.B. Reetdach) an.';
  COMMENT ON COLUMN ax_gebaeude.dachgeschossausbau IS 'DGA "Dachgeschossausbau" ist ein Hinweis auf den Ausbau bzw. die Ausbaufähigkeit des Dachgeschosses.';
  COMMENT ON COLUMN ax_gebaeude.qualitaetsangaben  IS 'QAG Angaben zur Herkunft der Informationen (Erhebungsstelle). Die Information ist konform zu den Vorgaben aus ISO 19115 zu repräsentieren.';


-- Wie oft kommt welcher Typ von Gebäude-Geometrie vor?
--
--  CREATE VIEW gebauede_geometrie_arten AS
--    SELECT geometrytype(wkb_geometry) AS geotyp,
--           COUNT(ogc_fid)             AS anzahl
--      FROM ax_gebaeude
--  GROUP BY geometrytype(wkb_geometry);
-- Ergebnis: nur 3 mal MULTIPOLYGON in einer Gemeinde, Rest POLYGON

-- Welche sind das?
--  CREATE VIEW gebauede_geometrie_multipolygone AS
--    SELECT ogc_fid, 
--           astext(wkb_geometry) AS geometrie
--      FROM ax_gebaeude
--     WHERE geometrytype(wkb_geometry) = 'MULTIPOLYGON';

-- GeometryFromText('MULTIPOLYGON((( AUSSEN ), ( INNEN1 ), ( INNEN2 )))', srid)
-- GeometryFromText('MULTIPOLYGON((( AUSSEN1 )),(( AUSSEN2)))', srid)


-- B a u t e i l
-- -------------
CREATE TABLE ax_bauteil (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying[],
	anlass			integer,
	bauart			integer,
	lagezurerdoberflaeche	integer,
	CONSTRAINT ax_bauteil_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_bauteil','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_bauteil_geom_idx ON ax_bauteil USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_bauteil_gml 
                 ON ax_bauteil USING btree (gml_id);

COMMENT ON TABLE  ax_bauteil        IS 'B a u t e i l';
COMMENT ON COLUMN ax_bauteil.gml_id IS 'Identifikator, global eindeutig';


-- B e s o n d e r e   G e b a e u d e l i n i e
-- ----------------------------------------------
CREATE TABLE ax_besonderegebaeudelinie (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	beschaffenheit		integer,
	anlass			integer,
	CONSTRAINT ax_besonderegebaeudelinie_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_besonderegebaeudelinie','wkb_geometry','25832','LINESTRING',2);

CREATE INDEX ax_besonderegebaeudelinie_geom_idx ON ax_besonderegebaeudelinie USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_besonderegebaeudelinie_gml 
                 ON ax_besonderegebaeudelinie USING btree (gml_id);

COMMENT ON TABLE ax_besonderegebaeudelinie IS 'B e s o n d e r e   G e b a e u d e l i n i e';
COMMENT ON COLUMN ax_besonderegebaeudelinie.gml_id IS 'Identifikator, global eindeutig';


-- F i r s t l i n i e
-- -----------------------------------------------------
CREATE TABLE ax_firstlinie (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying(9),
	anlass			integer,
	art			character varying(40),
	uri			character varying(28),
	CONSTRAINT ax_firstlinie_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_firstlinie','wkb_geometry','25832','LINESTRING',2);

CREATE INDEX ax_firstlinie_geom_idx ON ax_firstlinie USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_firstlinie_gml 
                 ON ax_firstlinie USING btree (gml_id);

COMMENT ON TABLE  ax_firstlinie        IS 'F i r s t l i n i e';
COMMENT ON COLUMN ax_firstlinie.gml_id IS 'Identifikator, global eindeutig';


-- B e s o n d e r e r   G e b a e u d e p u n k t
-- -----------------------------------------------
CREATE TABLE ax_besonderergebaeudepunkt (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	land			integer,
	stelle			integer,
	punktkennung		character varying(15), -- integer,
	art			character varying(40), --(37)
	"name"			character varying[],
	CONSTRAINT ax_besonderergebaeudepunkt_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_besonderergebaeudepunkt', 'dummy', 2, 25832, 'POINT');

-- DROP INDEX ax_besonderergebaeudepunkt_gml;  
CREATE UNIQUE INDEX ax_besonderergebaeudepunkt_gml 
                 ON ax_besonderergebaeudepunkt USING btree (gml_id);

COMMENT ON TABLE  ax_besonderergebaeudepunkt        IS 'B e s o n d e r e r   G e b a e u d e p u n k t';
COMMENT ON COLUMN ax_besonderergebaeudepunkt.gml_id IS 'Identifikator, global eindeutig';


--AX_Nutzung_Gebaeude
-- ** Tabelle bisher noch nicht generiert


--*** ############################################################
--*** Objektbereich: Tatsächliche Nutzung (AX_TatsaechlicheNutzung)
--*** ############################################################

-- Gemeinsame Attribute:
--   DLU datumDerLetztenUeberpruefung DateTime
--   DAQ qualitaetsangaben


--** Objektartengruppe: Siedlung (in Objektbereich:Tatsächliche Nutzung)
--   ===================================================================

-- W o h n b a u f l a e c h e
-- ----------------------------------------------
-- 'Wohnbaufläche' ist eine baulich geprägte Fläche einschließlich der mit ihr im Zusammenhang 
-- stehenden Freiflächen (z.B. Vorgärten, Ziergärten, Zufahrten, Stellplätze und Hofraumflächen),
-- die ausschließlich oder vorwiegend dem Wohnen dient.
CREATE TABLE ax_wohnbauflaeche (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	artderbebauung		integer,
	zustand			integer,
	name			character varying(50),
	CONSTRAINT ax_wohnbauflaeche_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_wohnbauflaeche','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_wohnbauflaeche_geom_idx 
          ON ax_wohnbauflaeche USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_wohnbauflaeche_gml 
                 ON ax_wohnbauflaeche USING btree (gml_id);

COMMENT ON TABLE  ax_wohnbauflaeche                 IS 'W o h n b a u f l a e c h e  ist eine baulich geprägte Fläche einschließlich der mit ihr im Zusammenhang stehenden Freiflächen (z.B. Vorgärten, Ziergärten, Zufahrten, Stellplätze und Hofraumflächen), die ausschließlich oder vorwiegend dem Wohnen dient.';
COMMENT ON COLUMN ax_wohnbauflaeche.gml_id          IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_wohnbauflaeche.artderbebauung  IS 'BEB "Art der Bebauung" differenziert nach offener und geschlossener Bauweise aus topographischer Sicht und nicht nach gesetzlichen Vorgaben (z.B. BauGB).';
COMMENT ON COLUMN ax_wohnbauflaeche.zustand         IS 'ZUS "Zustand" beschreibt, ob "Wohnbaufläche" ungenutzt ist oder ob eine Fläche als Wohnbaufläche genutzt werden soll.';
COMMENT ON COLUMN ax_wohnbauflaeche.name            IS 'NAM "Name" ist der Eigenname von "Wohnbaufläche" insbesondere bei Objekten außerhalb von Ortslagen.';


-- Objektart: I n d u s t r i e -   u n d   G e w e r b e f l a e c h e
-- --------------------------------------------------------------------
-- Industrie- und Gewerbefläche' ist eine Fläche, die vorwiegend industriellen oder gewerblichen Zwecken dient.
CREATE TABLE ax_industrieundgewerbeflaeche (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion		integer,
	name			character varying(50),
	zustand			integer,
	foerdergut		integer, -- Die Attributart 'Fördergut' kann nur in Verbindung mit der Attributart 'Funktion' und der Werteart 2510 vorkommen.
	primaerenergie		integer, -- Die Attributart 'Primärenergie' kann nur in Verbindung mit der Attributart 'Funktion' und den Wertearten 2530, 2531, 2532, 2570, 2571 und 2572 vorkommen.
	lagergut		integer, -- Die Attributart 'Lagergut' kann nur in Verbindung mit der Attributart 'Funktion' und der Werteart 1740 vorkommen.
	CONSTRAINT ax_industrieundgewerbeflaeche_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_industrieundgewerbeflaeche','wkb_geometry','25832','POLYGON',2);

-- POLYGON und POINT
ALTER TABLE ax_industrieundgewerbeflaeche DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_industrieundgewerbeflaeche_geom_idx 
          ON ax_industrieundgewerbeflaeche USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_industrieundgewerbeflaeche_gml 
                 ON ax_industrieundgewerbeflaeche USING btree (gml_id);

COMMENT ON TABLE  ax_industrieundgewerbeflaeche            IS 'I n d u s t r i e -   u n d   G e w e r b e f l a e c h e';
COMMENT ON COLUMN ax_industrieundgewerbeflaeche.gml_id     IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_industrieundgewerbeflaeche.name       IS 'NAM "Name" ist der Eigenname von "Industrie- und Gewerbefläche" insbesondere außerhalb von Ortslagen.';
COMMENT ON COLUMN ax_industrieundgewerbeflaeche.zustand    IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Industrie- und Gewerbefläche".';
COMMENT ON COLUMN ax_industrieundgewerbeflaeche.funktion   IS 'FKT "Funktion" ist die zum Zeitpunkt der Erhebung vorherrschende Nutzung von "Industrie- und Gewerbefläche".';
COMMENT ON COLUMN ax_industrieundgewerbeflaeche.foerdergut IS 'FGT "Fördergut" gibt an, welches Produkt gefördert wird.';
COMMENT ON COLUMN ax_industrieundgewerbeflaeche.lagergut   IS 'LGT "Lagergut" gibt an, welches Produkt gelagert wird. Diese Attributart kann nur in Verbindung mit der Attributart "Funktion" und der Werteart 1740 vorkommen.';
COMMENT ON COLUMN ax_industrieundgewerbeflaeche.primaerenergie IS 'PEG "Primärenergie" beschreibt die zur Strom- oder Wärmeerzeugung dienende Energieform oder den Energieträger.';


-- H a l d e
-- ----------------------------------------------
CREATE TABLE ax_halde
(	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	lagergut		integer,
	"name"			character varying(50),
	zustand			integer,
	CONSTRAINT ax_halde_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_halde','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_halde_geom_idx ON ax_halde USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_halde_gml 
                 ON ax_halde USING btree (gml_id);

COMMENT ON TABLE ax_halde             IS 'H a l d e';
COMMENT ON COLUMN ax_halde.gml_id     IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_halde.name       IS 'NAM "Name" ist die einer "Halde" zugehörige Bezeichnung oder deren Eigenname.';
COMMENT ON COLUMN ax_halde.lagergut   IS 'LGT "Lagergut" gibt an, welches Produkt gelagert wird.';
COMMENT ON COLUMN ax_halde.zustand    IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Halde".';


-- B e r b a u b e t r i e b
-- -------------------------
-- 'Bergbaubetrieb' ist eine Fläche, die für die Förderung des Abbaugutes unter Tage genutzt wird.
CREATE TABLE ax_bergbaubetrieb ( 
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	abbaugut		integer,
	"name"			character varying(50),
	bezeichnung		character varying(50),
	zustand			integer,
	CONSTRAINT ax_bergbaubetrieb_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_bergbaubetrieb','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_bergbaubetrieb_geom_idx  
          ON ax_bergbaubetrieb  USING gist  (wkb_geometry);

CREATE UNIQUE INDEX ax_bergbaubetrieb_gml 
                 ON ax_bergbaubetrieb USING btree (gml_id);

COMMENT ON TABLE  ax_bergbaubetrieb             IS '"Bergbaubetrieb" ist eine Fläche, die für die Förderung des Abbaugutes unter Tage genutzt wird.';
COMMENT ON COLUMN ax_bergbaubetrieb.gml_id      IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_bergbaubetrieb.abbaugut    IS 'AGT "Abbaugut" gibt an, welches Material abgebaut wird.';
COMMENT ON COLUMN ax_bergbaubetrieb.name        IS 'NAM "Name" ist der Eigenname von "Bergbaubetrieb".';
COMMENT ON COLUMN ax_bergbaubetrieb.zustand     IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Bergbaubetrieb".';
COMMENT ON COLUMN ax_bergbaubetrieb.bezeichnung IS 'BEZ "Bezeichnung" ist die von einer Fachstelle vergebene Kurzbezeichnung.';


-- T a g e b a u  /  G r u b e  /  S t e i n b r u c h
-- ---------------------------------------------------
CREATE TABLE ax_tagebaugrubesteinbruch (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	abbaugut		integer,
	"name"			character varying(50),
	zustand			integer,
	CONSTRAINT ax_tagebaugrubesteinbruch_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_tagebaugrubesteinbruch','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_tagebaugrubesteinbruch_geom_idx ON ax_tagebaugrubesteinbruch USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_tagebaugrubesteinbruchb_gml 
                 ON ax_tagebaugrubesteinbruch USING btree (gml_id);

COMMENT ON TABLE  ax_tagebaugrubesteinbruch          IS '"T a g e b a u ,  G r u b e ,  S t e i n b r u c h"  ist eine Fläche, auf der oberirdisch Bodenmaterial abgebaut wird. Rekultivierte Tagebaue, Gruben, Steinbrüche werden als Objekte entsprechend der vorhandenen Nutzung erfasst.';
COMMENT ON COLUMN ax_tagebaugrubesteinbruch.gml_id   IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_tagebaugrubesteinbruch.name     IS 'NAM "Name" ist der Eigenname von "Tagebau, Grube, Steinbruch".';
COMMENT ON COLUMN ax_tagebaugrubesteinbruch.abbaugut IS 'AGT "Abbaugut" gibt an, welches Material abgebaut wird.';
COMMENT ON COLUMN ax_tagebaugrubesteinbruch.zustand  IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Tagebau, Grube, Steinbruch".';


-- F l a e c h e n   g e m i s c h t e r   N u t z u n g
-- -----------------------------------------------------
CREATE TABLE ax_flaechegemischternutzung (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	artderbebauung		integer,
	funktion		integer,
	"name"			character varying(50),
	zustand			integer,
	CONSTRAINT ax_flaechegemischternutzung_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_flaechegemischternutzung','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_flaechegemischternutzung_geom_idx 
          ON ax_flaechegemischternutzung USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_flaechegemischternutzung_gml 
                 ON ax_flaechegemischternutzung USING btree (gml_id);

COMMENT ON TABLE  ax_flaechegemischternutzung        IS '"Fläche gemischter Nutzung" ist eine bebaute Fläche einschließlich der mit ihr im Zusammenhang stehenden Freifläche (Hofraumfläche, Hausgarten), auf der keine Art der baulichen Nutzung vorherrscht. Solche Flächen sind insbesondere ländlich-dörflich geprägte Flächen mit land- und forstwirtschaftlichen Betrieben, Wohngebäuden u.a. sowie städtisch geprägte Kerngebiete mit Handelsbetrieben und zentralen Einrichtungen für die Wirtschaft und die Verwaltung.';
COMMENT ON COLUMN ax_flaechegemischternutzung.gml_id IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_flaechegemischternutzung.artderbebauung IS 'BEB "Art der Bebauung" differenziert nach offener und geschlossener Bauweise aus topographischer Sicht und nicht nach gesetzlichen Vorgaben (z.B. BauGB).';
COMMENT ON COLUMN ax_flaechegemischternutzung.funktion       IS 'FKT "Funktion" ist die zum Zeitpunkt der Erhebung vorherrschende Nutzung (Dominanzprinzip).';
COMMENT ON COLUMN ax_flaechegemischternutzung.name           IS 'NAM "Name" ist der Eigenname von "Fläche gemischter Nutzung" insbesondere bei Objekten außerhalb von Ortslagen.';
COMMENT ON COLUMN ax_flaechegemischternutzung.zustand        IS 'ZUS "Zustand" beschreibt, ob "Fläche gemischter Nutzung" ungenutzt ist.';


-- F l a e c h e   b e s o n d e r e r   f u n k t i o n a l e r   P r a e g u n g
-- -------------------------------------------------------------------------------
CREATE TABLE ax_flaechebesondererfunktionalerpraegung (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion		integer,
	artderbebauung		integer,
	"name"			character varying(50),
	zustand			integer,
	CONSTRAINT ax_flaechebesondererfunktionalerpraegung_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_flaechebesondererfunktionalerpraegung','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_flaechebesondererfunktionalerpraegung_geom_idx ON ax_flaechebesondererfunktionalerpraegung USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_flaechebesondererfunktionalerpraegung_gml 
                 ON ax_flaechebesondererfunktionalerpraegung USING btree (gml_id);

COMMENT ON TABLE  ax_flaechebesondererfunktionalerpraegung        IS '"Fläche besonderer funktionaler Prägung" ist eine baulich geprägte Fläche einschließlich der mit ihr im Zusammenhang stehenden Freifläche, auf denen vorwiegend Gebäude und/oder Anlagen zur Erfüllung öffentlicher Zwecke oder historische Anlagen vorhanden sind.';
COMMENT ON COLUMN ax_flaechebesondererfunktionalerpraegung.gml_id IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_flaechebesondererfunktionalerpraegung.funktion       IS 'FKT "Funktion" ist die zum Zeitpunkt der Erhebung vorherrschende Nutzung von "Fläche besonderer funktionaler Prägung".';
COMMENT ON COLUMN ax_flaechebesondererfunktionalerpraegung.artderbebauung IS 'BEB "Art der Bebauung" differenziert nach offener und geschlossener Bauweise aus topographischer Sicht und nicht nach gesetzlichen Vorgaben (z.B. BauGB).';
COMMENT ON COLUMN ax_flaechebesondererfunktionalerpraegung.name           IS 'NAM "Name" ist der Eigenname von "Fläche besonderer funktionaler Prägung" insbesondere außerhalb von Ortslagen.';
COMMENT ON COLUMN ax_flaechebesondererfunktionalerpraegung.zustand        IS 'ZUS  "Zustand" beschreibt die Betriebsbereitschaft von "Fläche funktionaler Prägung".';


-- S p o r t - ,   F r e i z e i t -   u n d   E r h o h l u n g s f l ä c h e
-- ---------------------------------------------------------------------------
CREATE TABLE ax_sportfreizeitunderholungsflaeche (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion		integer,
	zustand			integer,
	"name"			character varying(50),
	CONSTRAINT ax_sportfreizeitunderholungsflaeche_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_sportfreizeitunderholungsflaeche','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_sportfreizeitunderholungsflaeche_geom_idx 
          ON ax_sportfreizeitunderholungsflaeche USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_sportfreizeitunderholungsflaeche_gml 
                 ON ax_sportfreizeitunderholungsflaeche USING btree (gml_id);

COMMENT ON TABLE  ax_sportfreizeitunderholungsflaeche          IS '"Sport-, Freizeit- und Erhohlungsfläche" ist eine bebaute oder unbebaute Fläche, die dem Sport, der Freizeitgestaltung oder der Erholung dient.';
COMMENT ON COLUMN ax_sportfreizeitunderholungsflaeche.gml_id   IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_sportfreizeitunderholungsflaeche.funktion IS 'FKT "Funktion" ist die Art der Nutzung von "Sport-, Freizeit- und Erholungsfläche".';
COMMENT ON COLUMN ax_sportfreizeitunderholungsflaeche.zustand  IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "SportFreizeitUndErholungsflaeche ".';
COMMENT ON COLUMN ax_sportfreizeitunderholungsflaeche.name     IS 'NAM "Name" ist der Eigenname von "Sport-, Freizeit- und Erholungsfläche".';


-- F r i e d h o f
-- ----------------
CREATE TABLE ax_friedhof (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion		integer,
	"name"			character varying(50),
	zustand			integer,
	CONSTRAINT ax_friedhof_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_friedhof','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_friedhof_geom_idx 
          ON ax_friedhof USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_friedhof_gml 
                 ON ax_friedhof USING btree (gml_id);

COMMENT ON TABLE  ax_friedhof           IS '"F r i e d h o f"  ist eine Fläche, auf der Tote bestattet sind.';
COMMENT ON COLUMN ax_friedhof.gml_id    IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_friedhof.funktion  IS 'FKT "Funktion" ist die Art der Begräbnisstätte.';
COMMENT ON COLUMN ax_friedhof.name      IS 'NAM "Name" ist der Eigenname von "Friedhof".';
COMMENT ON COLUMN ax_friedhof.zustand   IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Friedhof".';


--** Objektartengruppe: Verkehr (in Objektbereich:Tatsächliche Nutzung)
--   ===================================================================


-- S t r a s s e n v e r k e h r
-- ----------------------------------------------
CREATE TABLE ax_strassenverkehr (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion		integer,
	"name"			character varying(50),
	zweitname		character varying(50),
	zustand			integer,
	CONSTRAINT ax_strassenverkehr_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_strassenverkehr','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_strassenverkehr_geom_idx 
          ON ax_strassenverkehr USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_strassenverkehr_gml 
                 ON ax_strassenverkehr USING btree (gml_id);

COMMENT ON TABLE  ax_strassenverkehr           IS '"S t r a s s e n v e r k e h r" umfasst alle für die bauliche Anlage Straße erforderlichen sowie dem Straßenverkehr dienenden bebauten und unbebauten Flächen.';
COMMENT ON COLUMN ax_strassenverkehr.gml_id    IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_strassenverkehr.funktion  IS 'FKT "Funktion" beschreibt die verkehrliche Nutzung von "Straßenverkehr".';
COMMENT ON COLUMN ax_strassenverkehr.name      IS 'NAM "Name" ist der Eigenname von "Strassenverkehr".';
COMMENT ON COLUMN ax_strassenverkehr.zweitname IS 'ZNM "Zweitname" ist ein von der Lagebezeichnung abweichender Name von "Strassenverkehrsflaeche" (z.B. "Deutsche Weinstraße").';
COMMENT ON COLUMN ax_strassenverkehr.zustand   IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Strassenverkehrsflaeche".';


-- W e g 
-- ----------------------------------------------
-- 'Weg' umfasst alle Flächen, die zum Befahren und/oder Begehen vorgesehen sind. 
-- Zum 'Weg' gehören auch Seitenstreifen und Gräben zur Wegentwässerung.
CREATE TABLE ax_weg (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion		integer,
	name			character varying(50),
	bezeichnung		character varying(50),
	CONSTRAINT ax_weg_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_weg','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_weg_geom_idx 
          ON ax_weg USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_weg_gml 
                 ON ax_weg USING btree (gml_id);

COMMENT ON TABLE  ax_weg              IS '"W e g" umfasst alle Flächen, die zum Befahren und/oder Begehen vorgesehen sind. Zum "Weg" gehören auch Seitenstreifen und Gräben zur Wegentwässerung.';
COMMENT ON COLUMN ax_weg.gml_id       IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_weg.funktion     IS 'FKT "Funktion" ist die zum Zeitpunkt der Erhebung objektiv erkennbare oder feststellbare vorherrschend vorkommende Nutzung.';
COMMENT ON COLUMN ax_weg.name         IS 'NAM "Name" ist die Bezeichnung oder der Eigenname von "Wegflaeche".';
COMMENT ON COLUMN ax_weg.bezeichnung  IS 'BEZ "Bezeichnung" ist die amtliche Nummer des Weges.';


-- P l a t z
-- ----------------------------------------------
-- Platz' ist eine Verkehrsfläche in Ortschaften oder eine ebene, befestigte oder unbefestigte Fläche, die bestimmten Zwecken dient (z. B. für Verkehr, Märkte, Festveranstaltungen).
CREATE TABLE ax_platz (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion		integer,
	"name"			character varying(50),
	zweitname		character varying(50),
	CONSTRAINT ax_platz_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_platz','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_platz_geom_idx 
          ON ax_platz USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_platz_gml 
                 ON ax_platz USING btree (gml_id);

COMMENT ON TABLE  ax_platz           IS 'P l a t z   ist eine Verkehrsfläche in Ortschaften oder eine ebene, befestigte oder unbefestigte Fläche, die bestimmten Zwecken dient (z. B. für Verkehr, Märkte, Festveranstaltungen).';
COMMENT ON COLUMN ax_platz.gml_id    IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_platz.funktion  IS 'FKT "Funktion" ist die zum Zeitpunkt der Erhebung objektiv erkennbare oder feststellbare vorkommende Nutzung.';
COMMENT ON COLUMN ax_platz.name      IS 'NAM "Name" ist der Eigenname von "Platz".';
COMMENT ON COLUMN ax_platz.zweitname IS 'ZNM "Zweitname" ist der touristische oder volkstümliche Name von "Platz".';


-- B a h n v e r k e h r 
-- ----------------------------------------------
CREATE TABLE ax_bahnverkehr (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion		integer,
	bahnkategorie		integer,
	bezeichnung		character varying(50),
	nummerderbahnstrecke	character varying(20),
	zweitname		character varying(50),
	zustand			integer,
	CONSTRAINT ax_bahnverkehr_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_bahnverkehr','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_bahnverkehr_geom_idx 
          ON ax_bahnverkehr USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_bahnverkehr_gml 
                 ON ax_bahnverkehr USING btree (gml_id);

COMMENT ON TABLE  ax_bahnverkehr        IS '"B a h n v e r k e h r"  umfasst alle für den Schienenverkehr erforderlichen Flächen.';
-- Flächen von Bahnverkehr sind
--  * der Bahnkörper (Unterbau für Gleise; bestehend aus Dämmen oder Einschnitten und deren kleineren Böschungen, 
--    Durchlässen, schmalen Gräben zur Entwässerung, Stützmauern, Unter- und Überführung, Seiten und Schutzstreifen) mit seinen Bahnstrecken
--  * an den Bahnkörper angrenzende bebaute und unbebaute Flächen (z.B. größere Böschungsflächen).

COMMENT ON COLUMN ax_bahnverkehr.gml_id               IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_bahnverkehr.funktion             IS 'FKT "Funktion" ist die objektiv feststellbare Nutzung von "Bahnverkehr".';
COMMENT ON COLUMN ax_bahnverkehr.bahnkategorie        IS 'BKT "Bahnkategorie" beschreibt die Art des Verkehrsmittels.';
COMMENT ON COLUMN ax_bahnverkehr.bezeichnung          IS 'BEZ "Bezeichnung" ist die Angabe der Orte, in denen die Bahnlinie beginnt und endet (z. B. "Bahnlinie Frankfurt - Würzburg").';
COMMENT ON COLUMN ax_bahnverkehr.nummerderbahnstrecke IS 'NRB "Nummer der Bahnstrecke" ist die von der Bahn AG festgelegte Verschlüsselung der Bahnstrecke.';
COMMENT ON COLUMN ax_bahnverkehr.zweitname            IS 'ZNM "Zweitname" ist der von der Lagebezeichnung abweichende Name von "Bahnverkehr" (z. B. "Höllentalbahn").';
COMMENT ON COLUMN ax_bahnverkehr.zustand              IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Bahnverkehr".';


-- F l u g v e r k e h r
-- ----------------------
CREATE TABLE ax_flugverkehr (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion 		integer,
	art			integer,
	"name"			character varying(50),
	bezeichnung		character varying(50),
	nutzung			integer,
	zustand			integer,
	CONSTRAINT ax_flugverkehr_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_flugverkehr','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_flugverkehr_geom_idx
          ON ax_flugverkehr  USING gist  (wkb_geometry);

CREATE UNIQUE INDEX ax_flugverkehr_gml 
                 ON ax_flugverkehr USING btree (gml_id);

COMMENT ON TABLE  ax_flugverkehr             IS '"F l u g v e r k e h r"  umfasst die baulich geprägte Fläche und die mit ihr in Zusammenhang stehende Freifläche, die ausschließlich oder vorwiegend dem Flugverkehr dient.';
COMMENT ON COLUMN ax_flugverkehr.gml_id      IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_flugverkehr.funktion    IS 'FKT "Funktion" ist die zum Zeitpunkt der Erhebung vorherrschende Nutzung (Dominanzprinzip).';
COMMENT ON COLUMN ax_flugverkehr.art         IS 'ART "Art" ist Einstufung der Flugverkehrsfläche durch das Luftfahrtbundesamt.';
COMMENT ON COLUMN ax_flugverkehr.name        IS 'NAM "Name" ist der Eigenname von "Flugverkehr".';
COMMENT ON COLUMN ax_flugverkehr.bezeichnung IS 'BEZ "Bezeichnung" ist die von einer Fachstelle vergebene Kennziffer von "Flugverkehr".';
COMMENT ON COLUMN ax_flugverkehr.nutzung     IS 'NTZ "Nutzung" gibt den Nutzerkreis von "Flugverkehr" an.';
COMMENT ON COLUMN ax_flugverkehr.zustand     IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Flugverkehr".';


-- S c h i f f s v e r k e h r
-- ---------------------------
CREATE TABLE ax_schiffsverkehr (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion		integer,
	"name"			character varying(50),
	zustand			integer,
	CONSTRAINT ax_schiffsverkehr_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_schiffsverkehr','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_schiffsverkehr_geom_idx
          ON ax_schiffsverkehr USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_schiffsverkehr_gml 
                 ON ax_schiffsverkehr USING btree (gml_id);

COMMENT ON TABLE  ax_schiffsverkehr          IS '"S c h i f f s v e r k e h r"  umfasst die baulich geprägte Fläche und die mit ihr in Zusammenhang stehende Freifläche, die ausschließlich oder vorwiegend dem Schiffsverkehr dient.';
COMMENT ON COLUMN ax_schiffsverkehr.gml_id   IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_schiffsverkehr.funktion IS 'FKT "Funktion" ist die zum Zeitpunkt der Erhebung vorherrschende Nutzung von "Schiffsverkehr".';
COMMENT ON COLUMN ax_schiffsverkehr.name     IS 'NAM "Name" ist der Eigenname von "Schiffsverkehr".';
COMMENT ON COLUMN ax_schiffsverkehr.zustand  IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Schiffsverkehr".';
-- Diese Attributart kann nur in Verbindung mit der Attributart 'Funktion' und der Werteart 5620 vorkommen.


--** Objektartengruppe:Vegetation (in Objektbereich:Tatsächliche Nutzung)
--   ===================================================================

-- L a n d w i r t s c h a f t
-- ----------------------------------------------
CREATE TABLE ax_landwirtschaft (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	vegetationsmerkmal	integer,
	name			character varying(50),
	CONSTRAINT ax_landwirtschaft_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_landwirtschaft','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_landwirtschaft_geom_idx 
          ON ax_landwirtschaft USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_landwirtschaft_gml 
                 ON ax_landwirtschaft USING btree (gml_id);

COMMENT ON TABLE  ax_landwirtschaft                    IS '"L a n d w i r t s c h a f t"  ist eine Fläche für den Anbau von Feldfrüchten sowie eine Fläche, die beweidet und gemäht werden kann, einschließlich der mit besonderen Pflanzen angebauten Fläche. Die Brache, die für einen bestimmten Zeitraum (z. B. ein halbes oder ganzes Jahr) landwirtschaftlich unbebaut bleibt, ist als "Landwirtschaft" bzw. "Ackerland" zu erfassen';
COMMENT ON COLUMN ax_landwirtschaft.gml_id             IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_landwirtschaft.vegetationsmerkmal IS 'VEG "Vegetationsmerkmal" ist die zum Zeitpunkt der Erhebung erkennbare oder feststellbare vorherrschend vorkommende landwirtschaftliche Nutzung (Dominanzprinzip).';
COMMENT ON COLUMN ax_landwirtschaft.name               IS 'NAM "Name" ist die Bezeichnung oder der Eigenname von "Landwirtschaft".';


-- W a l d 
-- ----------------------------------------------
CREATE TABLE ax_wald (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	vegetationsmerkmal	integer,
	name			character varying(50),
	bezeichnung		character varying(40),
	CONSTRAINT ax_wald_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_wald','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_wald_geom_idx 
          ON ax_wald USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_wald_gml 
                 ON ax_wald USING btree (gml_id);

COMMENT ON TABLE  ax_wald             IS '"W a l d" ist eine Fläche, die mit Forstpflanzen (Waldbäume und Waldsträucher) bestockt ist.';
COMMENT ON COLUMN ax_wald.gml_id      IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_wald.vegetationsmerkmal IS 'VEG "Vegetationsmerkmal" beschreibt den Bewuchs von "Wald".';
COMMENT ON COLUMN ax_wald.name        IS 'NAM "Name" ist der Eigenname von "Wald".';
COMMENT ON COLUMN ax_wald.bezeichnung IS 'BEZ "Bezeichnung" ist die von einer Fachstelle vergebene Kennziffer (Forstabteilungsnummer, Jagenzahl) von "Wald".';


-- G e h o e l z
-- ----------------------------------------------
CREATE TABLE ax_gehoelz (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass 			integer,
	vegetationsmerkmal	integer,
	"name"			character varying(50),
	funktion		integer,
	CONSTRAINT ax_gehoelz_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_gehoelz','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_gehoelz_geom_idx 
          ON ax_gehoelz USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_gehoelz_gml 
                 ON ax_gehoelz USING btree (gml_id);

COMMENT ON TABLE  ax_gehoelz        IS '"G e h o e l z" ist eine Fläche, die mit einzelnen Bäumen, Baumgruppen, Büschen, Hecken und Sträuchern bestockt ist.';
COMMENT ON COLUMN ax_gehoelz.gml_id IS 'Identifikator, global eindeutig';

COMMENT ON COLUMN ax_gehoelz.vegetationsmerkmal IS 'VEG "Vegetationsmerkmal" beschreibt den Bewuchs von "Gehölz".';
COMMENT ON COLUMN ax_gehoelz.name               IS 'NAM "Name" ist der Eigenname von "Wald".';
COMMENT ON COLUMN ax_gehoelz.funktion           IS 'FKT "Funktion" beschreibt, welchem Zweck "Gehölz" dient.';


-- H e i d e
-- ----------------------------------------------
CREATE TABLE ax_heide (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	"name"			character varying(50),
	CONSTRAINT ax_heide_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_heide','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_heide_geom_idx 
          ON ax_heide USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_heide_gml 
                 ON ax_heide USING btree (gml_id);

COMMENT ON TABLE  ax_heide        IS '"H e i d e"  ist eine meist sandige Fläche mit typischen Sträuchern, Gräsern und geringwertigem Baumbestand.';
COMMENT ON COLUMN ax_heide.gml_id IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_heide.name   IS 'NAM "Name" ist der Eigenname von "Heide".';


-- M o o r
-- ----------------------------------------------
CREATE TABLE ax_moor (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	"name"			character varying(50),
	CONSTRAINT ax_moor_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_moor','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_moor_geom_idx
          ON ax_moor  USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_moor_gml 
                 ON ax_moor USING btree (gml_id);

COMMENT ON TABLE  ax_moor        IS '"M o o r"  ist eine unkultivierte Fläche, deren obere Schicht aus vertorften oder zersetzten Pflanzenresten besteht.';
-- Torfstich bzw. Torfabbaufläche wird der Objektart 41005 'Tagebau, Grube, Steinbruch' mit AGT 'Torf' zugeordnet.
COMMENT ON COLUMN ax_moor.gml_id IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_moor.name IS 'NAM "Name" ist der Eigenname von "Moor".';


-- S u m p f
-- ----------------------------------------------
CREATE TABLE ax_sumpf (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	"name"			character varying(50),
  CONSTRAINT ax_sumpf_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_sumpf','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_sumpf_geom_idx
          ON ax_sumpf USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_sumpf_gml 
                 ON ax_sumpf USING btree (gml_id);

COMMENT ON TABLE  ax_sumpf        IS '"S u m p f" ist ein wassergesättigtes, zeitweise unter Wasser stehendes Gelände. Nach Regenfällen kurzzeitig nasse Stellen im Boden werden nicht als "Sumpf" erfasst.';
COMMENT ON COLUMN ax_sumpf.gml_id IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_sumpf.name   IS 'NAM "Name" ist der Eigenname von "Sumpf".';


-- U n l a n d  /  V e g e t a t i o n s f l a e c h e
-- ---------------------------------------------------
CREATE TABLE ax_unlandvegetationsloseflaeche (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	oberflaechenmaterial	integer,
	"name"			character varying(50),
	funktion		integer,
	CONSTRAINT ax_unlandvegetationsloseflaeche_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_unlandvegetationsloseflaeche','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_unlandvegetationsloseflaeche_geom_idx 
          ON ax_unlandvegetationsloseflaeche USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_unlandvegetationsloseflaeche_gml 
                 ON ax_unlandvegetationsloseflaeche USING btree (gml_id);

COMMENT ON TABLE  ax_unlandvegetationsloseflaeche        IS '"Unland/Vegetationslose Fläche" ist eine Fläche, die dauerhaft landwirtschaftlich nicht genutzt wird, wie z.B. nicht aus dem Geländerelief herausragende Felspartien, Sand- oder Eisflächen, Uferstreifen längs von Gewässern und Sukzessionsflächen.';
COMMENT ON COLUMN ax_unlandvegetationsloseflaeche.gml_id IS 'Identifikator, global eindeutig';
-- Die Attributart 'Oberflächenmaterial' kann nur im Zusammenhang mit der Attributart 'Funktion' und der Werteart 1000 vorkommen.
COMMENT ON COLUMN ax_unlandvegetationsloseflaeche.oberflaechenmaterial IS 'OFM "Oberflächenmaterial" ist die Beschaffenheit des Bodens von "Unland/Vegetationslose Fläche".';
COMMENT ON COLUMN ax_unlandvegetationsloseflaeche.name                 IS 'NAM "Name" ist die Bezeichnung oder der Eigenname von "Unland/ VegetationsloseFlaeche".';
COMMENT ON COLUMN ax_unlandvegetationsloseflaeche.funktion             IS 'FKT "Funktion" ist die erkennbare Art von "Unland/Vegetationslose Fläche".';


--** Objektartengruppe: Gewässer (in Objektbereich:Tatsächliche Nutzung)
--   ===================================================================


-- F l i e s s g e w a e s s e r
-- ----------------------------------------------
-- 'Fließgewässer' ist ein geometrisch begrenztes, oberirdisches, auf dem Festland fließendes Gewässer, 
-- das die Wassermengen sammelt, die als Niederschläge auf die Erdoberfläche fallen oder in Quellen austreten, 
-- und in ein anderes Gewässer, ein Meer oder in einen See transportiert
--   oder
-- in einem System von natürlichen oder künstlichen Bodenvertiefungen verlaufendes Wasser, 
-- das zur Be- und Entwässerung an- oder abgeleitet wird
--   oder
-- ein geometrisch begrenzter, für die Schifffahrt angelegter künstlicher Wasserlauf, 
-- der in einem oder in mehreren Abschnitten die jeweils gleiche Höhe des Wasserspiegels besitzt.
CREATE TABLE ax_fliessgewaesser (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion		integer,
	"name"			character varying(50),
	zustand			integer,
	CONSTRAINT ax_fliessgewaesser_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_fliessgewaesser','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_fliessgewaesser_geom_idx 
          ON ax_fliessgewaesser USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_fliessgewaesser_gml 
                 ON ax_fliessgewaesser USING btree (gml_id);

COMMENT ON TABLE  ax_fliessgewaesser          IS '"F l i e s s g e w a e s s e r" ist ein geometrisch begrenztes, oberirdisches, auf dem Festland fließendes Gewässer, das die Wassermengen sammelt, die als Niederschläge auf die Erdoberfläche fallen oder in Quellen austreten, und in ein anderes Gewässer, ein Meer oder in einen See transportiert';
COMMENT ON COLUMN ax_fliessgewaesser.gml_id   IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_fliessgewaesser.funktion IS 'FKT "Funktion" ist die Art von "Fließgewässer".';
COMMENT ON COLUMN ax_fliessgewaesser.name     IS 'NAM "Name" ist die Bezeichnung oder der Eigenname von "Fließgewässer".';
COMMENT ON COLUMN ax_fliessgewaesser.zustand  IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Fließgewässer" mit FKT=8300 (Kanal).';


-- H a f e n b e c k e n
-- ---------------------
CREATE TABLE ax_hafenbecken (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion		integer,
	"name"			character varying(50),
	nutzung			integer,
	CONSTRAINT ax_hafenbecken_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_hafenbecken','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_hafenbecken_geom_idx
          ON ax_hafenbecken  USING gist  (wkb_geometry);

CREATE UNIQUE INDEX ax_hafenbecken_gml 
                 ON ax_hafenbecken USING btree (gml_id);

COMMENT ON TABLE  ax_hafenbecken        IS '"H a f e n b e c k e n"  ist ein natürlicher oder künstlich angelegter oder abgetrennter Teil eines Gewässers, in dem Schiffe be- und entladen werden.';
COMMENT ON COLUMN ax_hafenbecken.gml_id IS 'Identifikator, global eindeutig';

COMMENT ON COLUMN ax_hafenbecken.funktion IS 'FKT "Funktion" ist die objektiv erkennbare Nutzung von "Hafenbecken".';
COMMENT ON COLUMN ax_hafenbecken.name     IS 'NAM "Name" ist der Eigenname von "Hafenbecken".';
COMMENT ON COLUMN ax_hafenbecken.nutzung  IS 'NTZ "Nutzung" gibt den Nutzerkreis von "Hafenbecken" an.';


-- s t e h e n d e s   G e w a e s s e r
-- ----------------------------------------------
-- 'Stehendes Gewässer' ist eine natürliche oder künstliche mit Wasser gefüllte, 
-- allseitig umschlossene Hohlform der Landoberfläche ohne unmittelbaren Zusammenhang mit 'Meer'.
CREATE TABLE ax_stehendesgewaesser (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion		integer,
	name			character varying(50),
	gewaesserkennziffer	character varying(30),
	hydrologischesMerkmal	integer,
	CONSTRAINT ax_stehendesgewaesser_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_stehendesgewaesser','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_stehendesgewaesser_geom_idx
          ON ax_stehendesgewaesser USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_stehendesgewaesser_gml 
                 ON ax_stehendesgewaesser USING btree (gml_id);

COMMENT ON TABLE  ax_stehendesgewaesser           IS 's t e h e n d e s   G e w a e s s e r  ist eine natürliche oder künstliche mit Wasser gefüllte, allseitig umschlossene Hohlform der Landoberfläche ohne unmittelbaren Zusammenhang mit "Meer".';
COMMENT ON COLUMN ax_stehendesgewaesser.gml_id    IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_stehendesgewaesser.funktion  IS 'FKT "Funktion" ist die Art von "Stehendes Gewässer".';
COMMENT ON COLUMN ax_stehendesgewaesser.name      IS 'NAM "Name" ist der Eigenname von "Stehendes Gewässer".';
COMMENT ON COLUMN ax_stehendesgewaesser.gewaesserkennziffer   IS 'GWK  "Gewässerkennziffer" ist die von der zuständigen Fachstelle vergebene Verschlüsselung.';
COMMENT ON COLUMN ax_stehendesgewaesser.hydrologischesMerkmal IS 'HYD  "Hydrologisches Merkmal" gibt die Wasserverhältnisse von "Stehendes Gewässer" an.';


-- M e e r
-- ----------------------------------------------
CREATE TABLE ax_meer (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion		integer,
	"name"			character varying(50),
	bezeichnung		character varying(50),
	tidemerkmal		integer,
	CONSTRAINT ax_meer_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_meer','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_meer_geom_idx
          ON ax_meer USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_meer_gml 
                 ON ax_meer USING btree (gml_id);

COMMENT ON TABLE  ax_meer              IS '"M e e r" ist die das Festland umgebende Wasserfläche.';
COMMENT ON COLUMN ax_meer.gml_id       IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_meer.funktion     IS 'FKT "Funktion" ist die Art von "Meer".';
COMMENT ON COLUMN ax_meer.name         IS 'NAM "Name" ist der Eigenname von "Meer".';
COMMENT ON COLUMN ax_meer.bezeichnung  IS 'BEZ "Bezeichnung" ist die von der zuständigen Fachbehörde vergebene Verschlüsselung.';
COMMENT ON COLUMN ax_meer.tidemerkmal  IS 'TID "Tidemerkmal" gibt an, ob "Meer" von den periodischen Wasserstandsänderungen beeinflusst wird.';



--*** ############################################################
--*** Objektbereich: Bauwerke, Einrichtungen und sonstige Angaben
--*** ############################################################

--AX_BauwerkeEinrichtungenUndSonstigeAngaben
-- ** Tabelle bisher noch nicht generiert

--AX_DQMitDatenerhebung
-- ** Tabelle bisher noch nicht generiert


--AX_LI_Lineage_MitDatenerhebung
-- ** Tabelle bisher noch nicht generiert

--AX_LI_ProcessStep_MitDatenerhebung
-- ** Tabelle bisher noch nicht generiert

--AX_LI_Source_MitDatenerhebung
-- ** Tabelle bisher noch nicht generiert


--** Objektartengruppe: Bauwerke und Einrichtungen in Siedlungsflächen
--   ===================================================================

-- T u r m
-- ---------------------------------------------------
CREATE TABLE ax_turm (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	bauwerksfunktion	integer,
	CONSTRAINT ax_turm_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_turm','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_turm_geom_idx
          ON ax_turm USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_turm_gml 
                 ON ax_turm USING btree (gml_id);

COMMENT ON TABLE  ax_turm        IS 'T u r m';
COMMENT ON COLUMN ax_turm.gml_id IS 'Identifikator, global eindeutig';


-- Bauwerk oder Anlage fuer Industrie und Gewerbe
-- ----------------------------------------------
CREATE TABLE ax_bauwerkoderanlagefuerindustrieundgewerbe (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	bauwerksfunktion	integer,
	CONSTRAINT ax_bauwerkoderanlagefuerindustrieundgewerbe_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_bauwerkoderanlagefuerindustrieundgewerbe','wkb_geometry','25832','POLYGON',2);

-- POLYGON und POINT
ALTER TABLE ax_bauwerkoderanlagefuerindustrieundgewerbe DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_bauwerkoderanlagefuerindustrieundgewerbe_geom_idx 
          ON ax_bauwerkoderanlagefuerindustrieundgewerbe USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_bauwerkoderanlagefuerindustrieundgewerbe_gml 
                 ON ax_bauwerkoderanlagefuerindustrieundgewerbe USING btree (gml_id);

COMMENT ON TABLE ax_bauwerkoderanlagefuerindustrieundgewerbe         IS 'Bauwerk oder Anlage fuer Industrie und Gewerbe';
COMMENT ON COLUMN ax_bauwerkoderanlagefuerindustrieundgewerbe.gml_id IS 'Identifikator, global eindeutig';


-- V o r r a t s b e h a e l t e r  /  S p e i c h e r b a u w e r k
-- -----------------------------------------------------------------
CREATE TABLE ax_vorratsbehaelterspeicherbauwerk (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	speicherinhalt		integer,
	bauwerksfunktion	integer,
	CONSTRAINT ax_vorratsbehaelterspeicherbauwerk_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_vorratsbehaelterspeicherbauwerk','wkb_geometry','25832','POLYGON',2);

-- auf MULTIPOLYGON erweitern
ALTER TABLE ax_vorratsbehaelterspeicherbauwerk 
  DROP CONSTRAINT enforce_geotype_wkb_geometry;

ALTER TABLE ax_vorratsbehaelterspeicherbauwerk
  ADD CONSTRAINT enforce_geotype_wkb_geometry CHECK (geometrytype(wkb_geometry) = 'POLYGON'::text 
                                                  OR geometrytype(wkb_geometry) = 'MULTIPOLYGON'::text 
                                                  OR wkb_geometry IS NULL);

CREATE INDEX ax_vorratsbehaelterspeicherbauwerk_geom_idx 
          ON ax_vorratsbehaelterspeicherbauwerk USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_vorratsbehaelterspeicherbauwerk_gml 
                 ON ax_vorratsbehaelterspeicherbauwerk USING btree (gml_id);

COMMENT ON TABLE  ax_vorratsbehaelterspeicherbauwerk        IS 'V o r r a t s b e h a e l t e r  /  S p e i c h e r b a u w e r k';
COMMENT ON COLUMN ax_vorratsbehaelterspeicherbauwerk.gml_id IS 'Identifikator, global eindeutig';


-- T r a n s p o r t a n l a g e
-- ---------------------------------------------------
CREATE TABLE ax_transportanlage (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	bauwerksfunktion	integer,
	lagezurerdoberflaeche	integer,
	art			character varying(40),  --(15)
	"name"			character varying(20),  -- (3) "NPL", "RMR"
	CONSTRAINT ax_transportanlage_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_transportanlage','wkb_geometry','25832','LINESTRING',2);

CREATE INDEX ax_transportanlage_geom_idx 
          ON ax_transportanlage USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_transportanlage_gml 
                 ON ax_transportanlage USING btree (gml_id);

COMMENT ON TABLE  ax_transportanlage        IS 'T r a n s p o r t a n l a g e';
COMMENT ON COLUMN ax_transportanlage.gml_id IS 'Identifikator, global eindeutig';


-- L e i t u n g
-- ----------------------------------------------
CREATE TABLE ax_leitung (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	bauwerksfunktion	integer,
	spannungsebene		integer,
	CONSTRAINT ax_leitung_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_leitung','wkb_geometry','25832','LINESTRING',2);

CREATE INDEX ax_leitung_geom_idx
          ON ax_leitung USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_leitung_gml 
                 ON ax_leitung USING btree (gml_id);

COMMENT ON TABLE  ax_leitung        IS 'L e i t u n g';
COMMENT ON COLUMN ax_leitung.gml_id IS 'Identifikator, global eindeutig';


-- Bauwerk oder Anlage fuer Sport, Freizeit und Erholung
-- -----------------------------------------------------
CREATE TABLE ax_bauwerkoderanlagefuersportfreizeitunderholung (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	bauwerksfunktion	integer,
	-- "name"		character varying(15),
	CONSTRAINT ax_bauwerkoderanlagefuersportfreizeitunderholung_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_bauwerkoderanlagefuersportfreizeitunderholung','wkb_geometry','25832','POLYGON',2);

--POLYGON  oder POINT
ALTER TABLE ax_bauwerkoderanlagefuersportfreizeitunderholung DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_bauwerkoderanlagefuersportfreizeitunderholung_geom_idx 
          ON ax_bauwerkoderanlagefuersportfreizeitunderholung USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_bauwerkoderanlagefuersportfreizeitunderholung_gml 
                 ON ax_bauwerkoderanlagefuersportfreizeitunderholung USING btree (gml_id);

COMMENT ON TABLE  ax_bauwerkoderanlagefuersportfreizeitunderholung        IS 'Bauwerk oder Anlage fuer Sport, Freizeit und Erholung';
COMMENT ON COLUMN ax_bauwerkoderanlagefuersportfreizeitunderholung.gml_id IS 'Identifikator, global eindeutig';


-- Historisches Bauwerk oder historische Einrichtung
-- -------------------------------------------------
CREATE TABLE ax_historischesbauwerkoderhistorischeeinrichtung (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying[],
	anlass			integer,
	archaeologischertyp	integer,
	CONSTRAINT ax_historischesbauwerkoderhistorischeeinrichtung_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_historischesbauwerkoderhistorischeeinrichtung','wkb_geometry','25832','POLYGON',2);

-- POLYGON und POINT
ALTER TABLE  ax_historischesbauwerkoderhistorischeeinrichtung
	DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_historischesbauwerkoderhistorischeeinrichtung_geom_idx 
          ON ax_historischesbauwerkoderhistorischeeinrichtung USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_historischesbauwerkoderhistorischeeinrichtung_gml 
                 ON ax_historischesbauwerkoderhistorischeeinrichtung USING btree (gml_id);

COMMENT ON TABLE  ax_historischesbauwerkoderhistorischeeinrichtung        IS 'Historisches Bauwerk oder historische Einrichtung';
COMMENT ON COLUMN ax_historischesbauwerkoderhistorischeeinrichtung.gml_id IS 'Identifikator, global eindeutig';


-- H e i l q u e l l e  /  G a s q u e l l e
-- ----------------------------------------------
CREATE TABLE ax_heilquellegasquelle (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying(9),
	anlass			integer,
	art			integer,
	"name"			character varying(13),
	CONSTRAINT ax_heilquellegasquelle_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_heilquellegasquelle','wkb_geometry','25832','POINT',2);

CREATE INDEX ax_heilquellegasquelle_geom_idx 
          ON ax_heilquellegasquelle USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_heilquellegasquelle_gml 
                 ON ax_heilquellegasquelle USING btree (gml_id);

COMMENT ON TABLE  ax_heilquellegasquelle        IS 'H e i l q u e l l e  /  G a s q u e l l e';
COMMENT ON COLUMN ax_heilquellegasquelle.gml_id IS 'Identifikator, global eindeutig';


-- sonstiges Bauwerk oder sonstige Einrichtung
-- ----------------------------------------------
CREATE TABLE ax_sonstigesbauwerkodersonstigeeinrichtung (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	art			character varying(40),  -- (15)
	--description		integer,
	"name"			character varying(35), -- Lippe immer leer, RLP "Relationsbelegung bei Nachmigration"
	bauwerksfunktion	integer,
	CONSTRAINT ax_sonstigesbauwerkodersonstigeeinrichtung_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_sonstigesbauwerkodersonstigeeinrichtung','wkb_geometry','25832','POLYGON',2);

-- POLYGON  und LINESTRING
ALTER TABLE ax_sonstigesbauwerkodersonstigeeinrichtung DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_sonstigesbauwerkodersonstigeeinrichtung_geom_idx 
          ON ax_sonstigesbauwerkodersonstigeeinrichtung USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_sonstigesbauwerkodersonstigeeinrichtung_gml 
                 ON ax_sonstigesbauwerkodersonstigeeinrichtung USING btree (gml_id);

COMMENT ON TABLE  ax_sonstigesbauwerkodersonstigeeinrichtung        IS 'sonstiges Bauwerk oder sonstige Einrichtung';
COMMENT ON COLUMN ax_sonstigesbauwerkodersonstigeeinrichtung.gml_id IS 'Identifikator, global eindeutig';


-- E i n r i c h t u n g  i n  O e f f e n t l i c h e n  B e r e i c h e n 
-- ------------------------------------------------------------------------
CREATE TABLE ax_einrichtunginoeffentlichenbereichen (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character(28),
	beginnt			character(20),
	sonstigesmodell		character varying(9),
	anlass			integer,
	art			integer,
	CONSTRAINT ax_einrichtunginoeffentlichenbereichen_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_einrichtunginoeffentlichenbereichen','wkb_geometry','25832','POINT',2);

CREATE INDEX ax_einrichtunginoeffentlichenbereichen_geom_idx
          ON ax_einrichtunginoeffentlichenbereichen USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_einrichtunginoeffentlichenbereichen_gml 
                 ON ax_einrichtunginoeffentlichenbereichen USING btree (gml_id);

COMMENT ON TABLE  ax_einrichtunginoeffentlichenbereichen        IS 'E i n r i c h t u n g   i n   O e f f e n t l i c h e n   B e r e i c h e n';
COMMENT ON COLUMN ax_einrichtunginoeffentlichenbereichen.gml_id IS 'Identifikator, global eindeutig';


-- B e s o n d e r e r   B a u w e r k s p u n k t
-- -----------------------------------------------
CREATE TABLE ax_besondererbauwerkspunkt (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	punktkennung		character varying(15), -- integer,
	land			integer,
	stelle			integer,
	--sonstigeeigenschaft	character varying(26),
	CONSTRAINT ax_besondererbauwerkspunkt_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_besondererbauwerkspunkt', 'dummy', 2, 25832, 'POINT');

CREATE UNIQUE INDEX ax_besondererbauwerkspunkt_gml 
                 ON ax_besondererbauwerkspunkt USING btree (gml_id);

COMMENT ON TABLE  ax_besondererbauwerkspunkt        IS 'B e s o n d e r e r   B a u w e r k s p u n k t';
COMMENT ON COLUMN ax_besondererbauwerkspunkt.gml_id IS 'Identifikator, global eindeutig';


--** Objektartengruppe: Besondere Anlagen auf Siedlungsflächen
--   ===================================================================

--** Objektartengruppe: Bauwerke, Anlagen und Einrichtungen für den Verkehr
--   =======================================================================

-- B a u w e r k   i m  V e r k e h s b e r e i c h
-- ------------------------------------------------
CREATE TABLE ax_bauwerkimverkehrsbereich (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	bauwerksfunktion	integer,
	CONSTRAINT ax_bauwerkimverkehrsbereich_pk PRIMARY KEY (ogc_fid)
);

--SELECT AddGeometryColumn('ax_bauwerkimverkehrsbereich','wkb_geometry','25832','POLYGON',2);
SELECT AddGeometryColumn('ax_bauwerkimverkehrsbereich','wkb_geometry','25832','MULTIPOLYGON',2);

-- POLYGON und LINESTRING
ALTER TABLE ax_bauwerkimverkehrsbereich DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_bauwerkimverkehrsbereich_geom_idx 
          ON ax_bauwerkimverkehrsbereich USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_bauwerkimverkehrsbereich_gml 
                 ON ax_bauwerkimverkehrsbereich USING btree (gml_id);

COMMENT ON TABLE  ax_bauwerkimverkehrsbereich        IS 'B a u w e r k   i m  V e r k e h s b e r e i c h';
COMMENT ON COLUMN ax_bauwerkimverkehrsbereich.gml_id IS 'Identifikator, global eindeutig';


-- S t r a s s e n v e r k e h r s a n l a g e
-- ----------------------------------------------
CREATE TABLE ax_strassenverkehrsanlage (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying[],
	anlass			integer,
	art			integer 
);

SELECT AddGeometryColumn('ax_strassenverkehrsanlage','wkb_geometry','25832','POLYGON',2);

-- LINESTRING und POLYGON
ALTER TABLE ax_strassenverkehrsanlage DROP CONSTRAINT enforce_geotype_wkb_geometry;

ALTER TABLE ONLY ax_strassenverkehrsanlage
	ADD CONSTRAINT ax_strassenverkehrsanlage_pk PRIMARY KEY (ogc_fid);

CREATE INDEX ax_strassenverkehrsanlage_geom_idx 
          ON ax_strassenverkehrsanlage USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_strassenverkehrsanlage_gml 
                 ON ax_strassenverkehrsanlage USING btree (gml_id);

COMMENT ON TABLE  ax_strassenverkehrsanlage        IS 'S t r a s s e n v e r k e h r s a n l a g e';
COMMENT ON COLUMN ax_strassenverkehrsanlage.gml_id IS 'Identifikator, global eindeutig';


-- W e g  /  P f a d  /  S t e i g
-- ----------------------------------------------
CREATE TABLE ax_wegpfadsteig (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying[],
	anlass			integer,
	art			integer,
	CONSTRAINT ax_wegpfadsteig_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_wegpfadsteig','wkb_geometry','25832','LINESTRING',2);

-- LINESTRING und POLYGON
ALTER TABLE ax_wegpfadsteig DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_wegpfadsteig_geom_idx 
          ON ax_wegpfadsteig USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_wegpfadsteig_gml 
                 ON ax_wegpfadsteig USING btree (gml_id);

COMMENT ON TABLE  ax_wegpfadsteig        IS 'W e g  /  P f a d  /  S t e i g';
COMMENT ON COLUMN ax_wegpfadsteig.gml_id IS 'Identifikator, global eindeutig';


-- B a h n v e r k e h r s a n l a g e
-- ----------------------------------------------
CREATE TABLE ax_bahnverkehrsanlage (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying[],
	anlass			integer,
	bahnhofskategorie	integer,
	bahnkategorie		integer,
	CONSTRAINT ax_bahnverkehrsanlage_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_bahnverkehrsanlage','wkb_geometry','25832','POINT',2);

CREATE INDEX ax_bahnverkehrsanlage_geom_idx
          ON ax_bahnverkehrsanlage USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_bahnverkehrsanlage_gml 
                 ON ax_bahnverkehrsanlage USING btree (gml_id);

COMMENT ON TABLE  ax_bahnverkehrsanlage        IS 'B a h n v e r k e h r s a n l a g e';
COMMENT ON COLUMN ax_bahnverkehrsanlage.gml_id IS 'Identifikator, global eindeutig';


--AX_SeilbahnSchwebebahn
-- ** Tabelle bisher noch nicht generiert


-- G l e i s
-- ----------------------------------------------
CREATE TABLE ax_gleis (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying[],
	anlass			integer,
	bahnkategorie		integer,
	CONSTRAINT ax_gleis_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_gleis','wkb_geometry','25832','LINESTRING',2);

-- auch POLYGON
ALTER TABLE ax_gleis DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_gleis_geom_idx 
          ON ax_gleis USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_gleis_gml 
                 ON ax_gleis USING btree (gml_id);

COMMENT ON TABLE  ax_gleis        IS 'G l e i s';
COMMENT ON COLUMN ax_gleis.gml_id IS 'Identifikator, global eindeutig';


-- F l u g v e r k e h r s a n l a g e
-- -----------------------------------
CREATE TABLE ax_flugverkehrsanlage (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying(9),
	anlass			integer,
	art			integer,
	oberflaechenmaterial	integer,
	"name"			character varying(50),
	CONSTRAINT ax_flugverkehrsanlage_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_flugverkehrsanlage','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_flugverkehrsanlage_geom_idx
          ON ax_flugverkehrsanlage USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_flugverkehrsanlage_gml 
                 ON ax_flugverkehrsanlage USING btree (gml_id);

COMMENT ON TABLE  ax_flugverkehrsanlage             IS 'F l u g v e r k e h r s a n l a g e';
COMMENT ON COLUMN ax_flugverkehrsanlage.gml_id      IS 'Identifikator, global eindeutig';


--AX_EinrichtungenFuerDenSchiffsverkehr
-- ** Tabelle bisher noch nicht generiert


-- B a u w e r k   i m   G e w a e s s e r b e r e i c h
-- -----------------------------------------------------
CREATE TABLE ax_bauwerkimgewaesserbereich (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	bauwerksfunktion	integer,
	CONSTRAINT ax_bauwerkimgewaesserbereich_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_bauwerkimgewaesserbereich','wkb_geometry','25832','POLYGON',2);

-- Es wird (auch) LINESTRING / POINT geliefert!
ALTER TABLE ax_bauwerkimgewaesserbereich DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_bauwerkimgewaesserbereich_geom_idx 
          ON ax_bauwerkimgewaesserbereich USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_bauwerkimgewaesserbereich_gml 
                 ON ax_bauwerkimgewaesserbereich USING btree (gml_id);

COMMENT ON TABLE  ax_bauwerkimgewaesserbereich        IS 'B a u w e r k   i m   G e w a e s s e r b e r e i c h';
COMMENT ON COLUMN ax_bauwerkimgewaesserbereich.gml_id IS 'Identifikator, global eindeutig';


--** Objektartengruppe: Besondere Vegetationsmerkmale
--   ===================================================================

-- V e g a t a t i o n s m e r k m a l
-- ----------------------------------------------
CREATE TABLE ax_vegetationsmerkmal (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	bewuchs			integer,
	CONSTRAINT ax_vegetationsmerkmal_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_vegetationsmerkmal','wkb_geometry','25832','POLYGON',2);

-- verschiedene Geometrietypen
ALTER TABLE ONLY ax_vegetationsmerkmal DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_vegetationsmerkmal_geom_idx
          ON ax_vegetationsmerkmal USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_vegetationsmerkmal_gml 
                 ON ax_vegetationsmerkmal USING btree (gml_id);

COMMENT ON TABLE  ax_vegetationsmerkmal        IS 'V e g a t a t i o n s m e r k m a l';
COMMENT ON COLUMN ax_vegetationsmerkmal.gml_id IS 'Identifikator, global eindeutig';


--** Objektartengruppe: Besondere Eigenschaften von Gewässern
--   ===================================================================

-- G e w a e s s e r m e r k m a l
-- ----------------------------------------------
CREATE TABLE ax_gewaessermerkmal (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	art			integer,
	CONSTRAINT ax_gewaessermerkmal_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_gewaessermerkmal','wkb_geometry','25832','POINT',2);

CREATE INDEX ax_gewaessermerkmal_geom_idx
          ON ax_gewaessermerkmal USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_gewaessermerkmal_gml 
                 ON ax_gewaessermerkmal USING btree (gml_id);

COMMENT ON TABLE  ax_gewaessermerkmal        IS 'G e w a e s s e r m e r k m a l';
COMMENT ON COLUMN ax_gewaessermerkmal.gml_id IS 'Identifikator, global eindeutig';


-- u n t e r g e o r d n e t e s   G e w a e s s e r
-- -------------------------------------------------
CREATE TABLE ax_untergeordnetesgewaesser (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	funktion		integer,
	CONSTRAINT ax_untergeordnetesgewaesser_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_untergeordnetesgewaesser','wkb_geometry','25832','LINESTRING',2);

-- LINESTRING und POLYGON
ALTER TABLE ax_untergeordnetesgewaesser DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_untergeordnetesgewaesser_geom_idx 
          ON ax_untergeordnetesgewaesser USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_untergeordnetesgewaesser_gml 
                 ON ax_untergeordnetesgewaesser USING btree (gml_id);

COMMENT ON TABLE  ax_untergeordnetesgewaesser        IS 'u n t e r g e o r d n e t e s   G e w a e s s e r';
COMMENT ON COLUMN ax_untergeordnetesgewaesser.gml_id IS 'Identifikator, global eindeutig';


--** Objektartengruppe: Besondere Angaben zum Verkehr
--   ===================================================================

--** Objektartengruppe: Besondere Angaben zum Gewässer
--   ===================================================================

--AX_Wasserspiegelhoehe
-- ** Tabelle bisher noch nicht generiert

--AX_SchifffahrtslinieFaehrverkehr
-- ** Tabelle bisher noch nicht generiert

--*** ############################################################
--*** Objektbereich: Relief
--*** ############################################################

--** Objektartengruppe: Reliefformen
--   ===================================================================


-- B o e s c h u n g s k l i f f
-- -----------------------------
CREATE TABLE ax_boeschungkliff (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying[],
	anlass			integer
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_boeschungkliff', 'dummy', 2, 25832, 'POINT');

ALTER TABLE ONLY ax_boeschungkliff
	ADD CONSTRAINT ax_boeschungkliff_pk PRIMARY KEY (ogc_fid);

CREATE UNIQUE INDEX ax_boeschungkliff_gml 
                 ON ax_boeschungkliff USING btree (gml_id);

COMMENT ON TABLE  ax_boeschungkliff        IS 'B o e s c h u n g s k l i f f';
COMMENT ON COLUMN ax_boeschungkliff.gml_id IS 'Identifikator, global eindeutig';


-- B o e s c h u n g s f l a e c h e
-- ---------------------------------
--AX_Boeschungsflaeche Geändert (Revisionsnummer: 1623)
CREATE TABLE ax_boeschungsflaeche (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying[],
	anlass			integer,
	CONSTRAINT ax_boeschungsflaeche_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_boeschungsflaeche','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_boeschungsflaeche_geom_idx 
          ON ax_boeschungsflaeche USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_boeschungsflaeche_gml 
                 ON ax_boeschungsflaeche USING btree (gml_id);

COMMENT ON TABLE  ax_boeschungsflaeche        IS 'B o e s c h u n g s f l a e c h e';
COMMENT ON COLUMN ax_boeschungsflaeche.gml_id IS 'Identifikator, global eindeutig';


-- D a m m  /  W a l l  /  D e i c h
-- ----------------------------------------------
CREATE TABLE ax_dammwalldeich (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	art			integer,
	CONSTRAINT ax_dammwalldeich_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_dammwalldeich','wkb_geometry','25832','LINESTRING',2);

-- LINESTRING oder POLYGON
ALTER TABLE ax_dammwalldeich DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_dammwalldeich_geom_idx 
          ON ax_dammwalldeich USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_dammwalldeich_gml 
                 ON ax_dammwalldeich USING btree (gml_id);

COMMENT ON TABLE  ax_dammwalldeich        IS 'D a m m  /  W a l l  /  D e i c h';
COMMENT ON COLUMN ax_dammwalldeich.gml_id IS 'Identifikator, global eindeutig';


--AX_Hoehleneingang
-- ** Tabelle bisher noch nicht generiert


-- F e l s e n ,  F e l s b l o c k ,   F e l s n a d e l
-- ------------------------------------------------------
-- Nutzung
CREATE TABLE ax_felsenfelsblockfelsnadel (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	name			character varying(30),
	CONSTRAINT ax_felsenfelsblockfelsnadel_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_felsenfelsblockfelsnadel','wkb_geometry','25832','POLYGON',2);

CREATE INDEX ax_felsenfelsblockfelsnadel_geom_idx 
          ON ax_felsenfelsblockfelsnadel USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_felsenfelsblockfelsnadel_gml 
                 ON ax_felsenfelsblockfelsnadel USING btree (gml_id);

COMMENT ON TABLE  ax_felsenfelsblockfelsnadel        IS 'F e l s e n ,  F e l s b l o c k ,   F e l s n a d e l';
COMMENT ON COLUMN ax_felsenfelsblockfelsnadel.gml_id IS 'Identifikator, global eindeutig';


--AX_Duene
-- ** Tabelle bisher noch nicht generiert


--AX_Hoehenlinie
-- ** Tabelle bisher noch nicht generiert


--** Objektartengruppe: Primäres DGM
--   ===================================================================

--AX_Erfassung_DGM
-- ** Tabelle bisher noch nicht generiert


--AX_ErfassungMarkanterGelaendepunkt
-- ** Tabelle bisher noch nicht generiert


-- G e l a e n d e k a n t e
-- ----------------------------------------------
CREATE TABLE ax_gelaendekante (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying(9),
	anlass			integer,
	istteilvon		character varying, -- Beziehung?
	artdergelaendekante	integer,
	ax_dqerfassungsmethode	integer,
	identifikation		integer,
	CONSTRAINT ax_gelaendekante_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_gelaendekante','wkb_geometry','25832','LINESTRING',2);

CREATE INDEX ax_gelaendekante_geom_idx 
          ON ax_gelaendekante USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_gelaendekante_gml 
                 ON ax_gelaendekante USING btree (gml_id);

COMMENT ON TABLE  ax_gelaendekante        IS 'G e l a e n d e k a n t e';
COMMENT ON COLUMN ax_gelaendekante.gml_id IS 'Identifikator, global eindeutig';


--AX_MarkanterGelaendepunkt
-- ** Tabelle bisher noch nicht generiert


-- B e s o n d e r e r   H o e h e n p u n k t
-- -------------------------------------------------------------
CREATE TABLE ax_besondererhoehenpunkt (
	ogc_fid serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying(9),
	anlass			integer,
	besonderebedeutung	integer,
	CONSTRAINT ax_besondererhoehenpunkt_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_besondererhoehenpunkt','wkb_geometry','25832','POINT',2);

CREATE INDEX ax_besondererhoehenpunkt_geom_idx
          ON ax_besondererhoehenpunkt USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_besondererhoehenpunkt_gml 
                 ON ax_besondererhoehenpunkt USING btree (gml_id);

COMMENT ON TABLE  ax_besondererhoehenpunkt        IS 'B e s o n d e r e r   H ö h e n - P u n k t';
COMMENT ON COLUMN ax_besondererhoehenpunkt.gml_id IS 'Identifikator, global eindeutig';



--** Objektartengruppe:Sekundäres DGM
--   ===================================================================

--*** ############################################################
--*** Objektbereich: Gesetzliche Festlegungen, Gebietseinheiten, Kataloge
--*** ############################################################

--** Objektartengruppe: Öffentlich-rechtliche und sonstige Festlegungen
--   ===================================================================


-- K l a s s i f i z i e r u n g   n a c h   S t r a s s e n r e c h t
-- -------------------------------------------------------------------
CREATE TABLE ax_klassifizierungnachstrassenrecht (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	artderfestlegung	integer,
	bezeichnung		character varying(40),
	CONSTRAINT ax_klassifizierungnachstrassenrecht_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_klassifizierungnachstrassenrecht','wkb_geometry','25832','POLYGON',2);

-- auf MULTIPOLYGON erweitern
ALTER TABLE ax_klassifizierungnachstrassenrecht 
  DROP CONSTRAINT enforce_geotype_wkb_geometry;

ALTER TABLE ax_klassifizierungnachstrassenrecht
  ADD CONSTRAINT enforce_geotype_wkb_geometry CHECK (geometrytype(wkb_geometry) = 'POLYGON'::text 
                                                  OR geometrytype(wkb_geometry) = 'MULTIPOLYGON'::text 
                                                  OR wkb_geometry IS NULL);


CREATE INDEX ax_klassifizierungnachstrassenrecht_geom_idx
          ON ax_klassifizierungnachstrassenrecht  USING gist  (wkb_geometry);

CREATE UNIQUE INDEX ax_klassifizierungnachstrassenrecht_gml 
                 ON ax_klassifizierungnachstrassenrecht USING btree (gml_id);

COMMENT ON TABLE  ax_klassifizierungnachstrassenrecht        IS 'K l a s s i f i z i e r u n g   n a c h   S t r a s s e n r e c h t';
COMMENT ON COLUMN ax_klassifizierungnachstrassenrecht.gml_id IS 'Identifikator, global eindeutig';


-- K l a s s i f i z i e r u n g   n a c h   W a s s e r r e c h t
-- ---------------------------------------------------------------
CREATE TABLE ax_klassifizierungnachwasserrecht (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	artderfestlegung	integer,
	CONSTRAINT ax_klassifizierungnachwasserrecht_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_klassifizierungnachwasserrecht','wkb_geometry','25832','POLYGON',2);

-- auf MULTIPOLYGON erweitern
ALTER TABLE ax_klassifizierungnachwasserrecht 
  DROP CONSTRAINT enforce_geotype_wkb_geometry;

ALTER TABLE ax_klassifizierungnachwasserrecht
  ADD CONSTRAINT enforce_geotype_wkb_geometry CHECK (geometrytype(wkb_geometry) = 'POLYGON'::text 
                                                  OR geometrytype(wkb_geometry) = 'MULTIPOLYGON'::text 
                                                  OR wkb_geometry IS NULL);

CREATE INDEX ax_klassifizierungnachwasserrecht_geom_idx
          ON ax_klassifizierungnachwasserrecht USING gist (wkb_geometry);

COMMENT ON TABLE  ax_klassifizierungnachwasserrecht        IS 'K l a s s i f i z i e r u n g   n a c h   W a s s e r r e c h t';
COMMENT ON COLUMN ax_klassifizierungnachwasserrecht.gml_id IS 'Identifikator, global eindeutig';


-- B a u - ,   R a u m -   o d e r   B o d e n o r d n u n g s r e c h t
-- ---------------------------------------------------------------------
-- 'Bau-, Raum- oder Bodenordnungsrecht' ist ein fachlich übergeordnetes Gebiet von Flächen 
-- mit bodenbezogenen Beschränkungen, Belastungen oder anderen Eigenschaften nach öffentlichen Vorschriften.
CREATE TABLE ax_bauraumoderbodenordnungsrecht (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	art			character varying(40), -- (15)
	"name"			character varying(15),
	artderfestlegung	integer,
	land			integer,
	stelle			character varying(7), 
	bezeichnung		character varying(24), 
	CONSTRAINT ax_bauraumoderbodenordnungsrecht_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_bauraumoderbodenordnungsrecht','wkb_geometry','25832','MULTIPOLYGON',2);

-- verschiedene Goemetrie-Typen
ALTER TABLE ax_bauraumoderbodenordnungsrecht 
  DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_bauraumoderbodenordnungsrecht_geom_idx
          ON ax_bauraumoderbodenordnungsrecht USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_bauraumoderbodenordnungsrecht_gml 
                 ON ax_bauraumoderbodenordnungsrecht USING btree (gml_id);

COMMENT ON TABLE  ax_bauraumoderbodenordnungsrecht             IS 'REO: Bau-, Raum- oder Bodenordnungsrecht';
COMMENT ON COLUMN ax_bauraumoderbodenordnungsrecht.gml_id      IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_bauraumoderbodenordnungsrecht.artderfestlegung IS 'ADF';
COMMENT ON COLUMN ax_bauraumoderbodenordnungsrecht."name"      IS 'NAM, Eigenname von "Bau-, Raum- oder Bodenordnungsrecht"';
COMMENT ON COLUMN ax_bauraumoderbodenordnungsrecht.bezeichnung IS 'BEZ, Amtlich festgelegte Verschlüsselung von "Bau-, Raum- oder Bodenordnungsrecht"';


-- S o n s t i g e s   R e c h t
-- -----------------------------
CREATE TABLE ax_sonstigesrecht (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	artderfestlegung	integer,
	land			integer,
	stelle			character varying(5),
	bezeichnung		character varying(20),
	characterstring		integer,
	art			character varying(40),  --(15)
	"name"			character varying(20), 
--	"qualitaetsangaben|ax_dqmitdatenerhebung|herkunft|li_lineage|pro" character varying(8),
--	datetime		character varying(20),
	CONSTRAINT ax_sonstigesrecht_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_sonstigesrecht','wkb_geometry','25832','POLYGON',2);

ALTER TABLE ax_sonstigesrecht 
  DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_sonstigesrecht_geom_idx
          ON ax_sonstigesrecht USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_sonstigesrecht_gml 
                 ON ax_sonstigesrecht USING btree (gml_id);

COMMENT ON TABLE  ax_sonstigesrecht        IS 'S o n s t i g e s   R e c h t';
COMMENT ON COLUMN ax_sonstigesrecht.gml_id IS 'Identifikator, global eindeutig';


--** Objektartengruppe: Bodenschätzung, Bewertung
--   ===================================================================


-- B o d e n s c h a e t z u n g
-- ----------------------------------------------
CREATE TABLE ax_bodenschaetzung (
	ogc_fid				serial NOT NULL,
	gml_id				character(16),	-- character varying(32),
--	identifier			character varying(28),
	beginnt				character(20),
	advstandardmodell		character varying(9),
	anlass				integer,
	art				character varying(40), -- (15)
	"name"				character varying(33),
	kulturart			integer,
	bodenart			integer,
	zustandsstufeoderbodenstufe	integer,
	entstehungsartoderklimastufewasserverhaeltnisse	integer,
	bodenzahlodergruenlandgrundzahl	integer,
	ackerzahlodergruenlandzahl	integer,
	sonstigeangaben			integer,
	jahreszahl			integer,
	CONSTRAINT ax_bodenschaetzung_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_bodenschaetzung','wkb_geometry','25832','POLYGON',2);

-- auf MULTIPOLYGON erweitern
ALTER TABLE ax_bodenschaetzung 
  DROP CONSTRAINT enforce_geotype_wkb_geometry;

ALTER TABLE ax_bodenschaetzung
  ADD CONSTRAINT enforce_geotype_wkb_geometry CHECK (geometrytype(wkb_geometry) = 'POLYGON'::text 
                                                  OR geometrytype(wkb_geometry) = 'MULTIPOLYGON'::text 
                                                  OR wkb_geometry IS NULL);

CREATE INDEX ax_bodenschaetzung_geom_idx
          ON ax_bodenschaetzung USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_bodenschaetzung_gml 
                 ON ax_bodenschaetzung USING btree (gml_id);

COMMENT ON TABLE  ax_bodenschaetzung        IS 'B o d e n s c h a e t z u n g';
COMMENT ON COLUMN ax_bodenschaetzung.gml_id IS 'Identifikator, global eindeutig';


-- M u s t e r -,  L a n d e s m u s t e r -   u n d   V e r g l e i c h s s t u e c k
-- -----------------------------------------------------------------------------------
CREATE TABLE ax_musterlandesmusterundvergleichsstueck (
	ogc_fid				serial NOT NULL,
	gml_id				character(16),	-- character varying(32),
--	identifier			character varying(28),
	beginnt				character(20), 
	advstandardmodell		character varying(9),
	anlass				integer,
	merkmal				integer,
	nummer				integer,
	kulturart			integer,
	bodenart			integer,
	zustandsstufeoderbodenstufe	integer,
	entstehungsartoderklimastufewasserverhaeltnisse	integer,
	bodenzahlodergruenlandgrundzahl	integer,
	ackerzahlodergruenlandzahl	integer,
	art				character varying(40),  -- (15)
	"name"				character varying(27),
	CONSTRAINT ax_musterlandesmusterundvergleichsstueck_pk PRIMARY KEY (ogc_fid)
);


SELECT AddGeometryColumn('ax_musterlandesmusterundvergleichsstueck','wkb_geometry','25832','POLYGON',2);

-- auf MULTIPOLYGON erweitern
-- es kommt auch POINT vor !?
ALTER TABLE ax_musterlandesmusterundvergleichsstueck 
  DROP CONSTRAINT enforce_geotype_wkb_geometry;

ALTER TABLE ax_musterlandesmusterundvergleichsstueck
  ADD CONSTRAINT enforce_geotype_wkb_geometry CHECK (geometrytype(wkb_geometry) = 'POLYGON'::text 
                                                  OR geometrytype(wkb_geometry) = 'MULTIPOLYGON'::text 
                                                  OR geometrytype(wkb_geometry) = 'POINT'::text 
                                                  OR wkb_geometry IS NULL);

CREATE INDEX ax_musterlandesmusterundvergleichsstueck_geom_idx
          ON ax_musterlandesmusterundvergleichsstueck USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_musterlandesmusterundvergleichsstueck_gml 
                 ON ax_musterlandesmusterundvergleichsstueck USING btree (gml_id);

COMMENT ON TABLE  ax_musterlandesmusterundvergleichsstueck        IS 'Muster-, Landesmuster- und Vergleichsstueck';
COMMENT ON COLUMN ax_musterlandesmusterundvergleichsstueck.gml_id IS 'Identifikator, global eindeutig';


--** Objektartengruppe: Kataloge
--   ===================================================================


-- B u n d e s l a n d
-- ----------------------------------------------
CREATE TABLE ax_bundesland (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	schluesselgesamt	integer,
	bezeichnung		character varying(30), --(22)
	land			integer,
	CONSTRAINT ax_bundesland_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_bundesland', 'dummy', 2, 25832, 'POINT');

CREATE UNIQUE INDEX ax_bundesland_gml 
                 ON ax_bundesland USING btree (gml_id);

COMMENT ON TABLE  ax_bundesland        IS 'B u n d e s l a n d';
COMMENT ON COLUMN ax_bundesland.gml_id IS 'Identifikator, global eindeutig';


-- R e g i e r u n g s b e z i r k
-- ----------------------------------------------
CREATE TABLE ax_regierungsbezirk (
	ogc_fid				serial NOT NULL,
	gml_id				character(16),	-- character varying(32),
--	identifier			character varying(28),
	beginnt				character(20),
	advstandardmodell		character varying(9),
	anlass				integer,
	schluesselgesamt		integer,
	bezeichnung			character varying(20),
	land				integer,
	regierungsbezirk		integer,
	CONSTRAINT ax_regierungsbezirk_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_regierungsbezirk', 'dummy', 2, 25832, 'POINT');

-- Verbindungstabellen indizieren
CREATE UNIQUE INDEX ax_regierungsbezirk_gml 
                 ON ax_regierungsbezirk USING btree (gml_id);

COMMENT ON TABLE  ax_regierungsbezirk        IS 'R e g i e r u n g s b e z i r k';
COMMENT ON COLUMN ax_regierungsbezirk.gml_id IS 'Identifikator, global eindeutig';


--AX_KreisRegion Geändert (Revisionsnummer: 1658)

-- K r e i s   /   R e g i o n
-- ---------------------------
CREATE TABLE ax_kreisregion (
	ogc_fid				serial NOT NULL,
	gml_id				character(16),	-- character varying(32),
--	identifier			character varying(28),
	beginnt				character(20),
	advstandardmodell		character varying(9),
	anlass				integer,
	schluesselgesamt		integer,
	bezeichnung			character varying(20),
	land				integer,
	regierungsbezirk		integer,
	kreis				integer,
	CONSTRAINT ax_kreisregion_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_kreisregion', 'dummy', 2, 25832, 'POINT');

CREATE UNIQUE INDEX ax_kreisregion_gml 
                 ON ax_kreisregion USING btree (gml_id);

COMMENT ON TABLE  ax_kreisregion        IS 'K r e i s  /  R e g i o n';
COMMENT ON COLUMN ax_kreisregion.gml_id IS 'Identifikator, global eindeutig';


-- G e m e i n d e
-- ----------------------------------------------
CREATE TABLE ax_gemeinde (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	schluesselgesamt	integer,
	bezeichnung		character varying(25),
	land			integer,
	regierungsbezirk	integer,
	kreis			integer,
	gemeinde		integer,
	CONSTRAINT ax_gemeinde_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_gemeinde', 'dummy', 2, 25832, 'POINT');

-- Index für alkis_beziehungen
CREATE UNIQUE INDEX ax_gemeinde_gml 
                 ON ax_gemeinde USING btree (gml_id);

COMMENT ON TABLE  ax_gemeinde        IS 'G e m e i n d e';
COMMENT ON COLUMN ax_gemeinde.gml_id IS 'Identifikator, global eindeutig';


-- G e m e i n d e t e i l
-- -----------------------------------------
-- neu: 21.11.2011

CREATE TABLE ax_gemeindeteil (
	ogc_fid			serial NOT NULL,
	gml_id			character varying(16),
--	identifier		character varying(28),
	beginnt			character varying(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	schluesselgesamt	double precision,
	bezeichnung		character varying(40),
	administrativefunktion	integer,
	land			integer,
	regierungsbezirk	integer,
	kreis			integer,
	gemeinde		integer,
	gemeindeteil		integer,
	CONSTRAINT ax_gemeindeteil_pk PRIMARY KEY (ogc_fid)
);

-- Index für alkis_beziehungen
CREATE UNIQUE INDEX ax_gemeindeteil_gml 
                 ON ax_gemeindeteil USING btree (gml_id);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_gemeindeteil', 'dummy', 2, 25832, 'POINT');

COMMENT ON TABLE  ax_gemeindeteil        IS 'G e m e i n d e - T e i l';
COMMENT ON COLUMN ax_gemeindeteil.gml_id IS 'Identifikator, global eindeutig';



-- G e m a r k u n g
-- ----------------------------------------------
-- NREO, nur Schluesseltabelle: Geometrie entbehrlich
CREATE TABLE ax_gemarkung (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	schluesselgesamt	integer,
	bezeichnung		character varying(23),
	land			integer,
	gemarkungsnummer	integer,  -- Key
--	"istamtsbezirkvon|ax_dienststelle_schluessel|land" integer,
	stelle			integer,
	CONSTRAINT ax_gemarkung_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_gemarkung', 'dummy', 2, 25832, 'POINT');

-- Index für alkis_beziehungen
CREATE UNIQUE INDEX ax_gemarkung_gml 
                 ON ax_gemarkung USING btree (gml_id);

-- Such-Index, Verweis aus ax_Flurstueck
CREATE INDEX ax_gemarkung_nr  
          ON ax_gemarkung USING btree (land, gemarkungsnummer);

COMMENT ON TABLE  ax_gemarkung        IS 'G e m a r k u n g';
COMMENT ON COLUMN ax_gemarkung.gml_id IS 'Identifikator, global eindeutig';


-- G e m a r k u n g s t e i l   /   F l u r
-- ----------------------------------------------
-- Schluesseltabelle: Geometrie entbehrlich
CREATE TABLE ax_gemarkungsteilflur (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	schluesselgesamt	integer,
	bezeichnung		character varying(7), -- integer,
	land			integer,
	gemarkung		integer,
	gemarkungsteilflur	integer,
	CONSTRAINT ax_gemarkungsteilflur_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_gemarkungsteilflur', 'dummy', 2, 25832, 'POINT');

-- Index für alkis_beziehungen
CREATE UNIQUE INDEX ax_gemarkungsteilflur_gml 
                 ON ax_gemarkungsteilflur USING btree (gml_id);

COMMENT ON TABLE  ax_gemarkungsteilflur        IS 'G e m a r k u n g s t e i l   /   F l u r';
COMMENT ON COLUMN ax_gemarkungsteilflur.gml_id IS 'Identifikator, global eindeutig';


-- B u c h u n g s b l a t t - B e z i r k
-- ----------------------------------------------
CREATE TABLE ax_buchungsblattbezirk (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	schluesselgesamt	integer,
	bezeichnung		character varying(26),
	land			integer,
	bezirk			integer,
--	"gehoertzu|ax_dienststelle_schluessel|land" integer,
	stelle			character varying(4),
	CONSTRAINT ax_buchungsblattbezirk_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_buchungsblattbezirk', 'dummy', 2, 25832, 'POINT');

CREATE UNIQUE INDEX ax_buchungsblattbezirk_gml 
                 ON ax_buchungsblattbezirk USING btree (gml_id);

-- Such-Index auf Land + Bezirk 
-- Der Verweis von ax_buchungsblatt hat keine alkis_beziehung.
CREATE INDEX ax_buchungsblattbez_key 
          ON ax_buchungsblattbezirk USING btree (land, bezirk);

COMMENT ON TABLE  ax_buchungsblattbezirk        IS 'Buchungsblatt- B e z i r k';
COMMENT ON COLUMN ax_buchungsblattbezirk.gml_id IS 'Identifikator, global eindeutig';


-- D i e n s t s t e l l e
-- ----------------------------------------------
-- NREO, nur Schluesseltabelle: Geometrie entbehrlich
CREATE TABLE ax_dienststelle (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying(9),
	anlass			integer,
	schluesselgesamt	character varying(7),
	bezeichnung		character varying(120), -- 102
	land			integer,
	stelle			character varying(5),
	stellenart		integer,
	-- hat character	varying,
	CONSTRAINT ax_dienststelle_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_dienststelle', 'dummy', 2, 25832, 'POINT');

-- Index für alkis_beziehungen
CREATE UNIQUE INDEX ax_dienststelle_gml 
                 ON ax_dienststelle USING btree (gml_id);

COMMENT ON TABLE  ax_dienststelle        IS 'D i e n s t s t e l l e';
COMMENT ON COLUMN ax_dienststelle.gml_id IS 'Identifikator, global eindeutig';


-- L a g e b e z e i c h n u n g s - K a t a l o g e i n t r a g
-- --------------------------------------------------------------
CREATE TABLE ax_lagebezeichnungkatalogeintrag (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	schluesselgesamt	character varying(13),
	bezeichnung		character varying(28),
	land			integer,
	regierungsbezirk	integer,
	kreis			integer,
	gemeinde		integer,
	lage			character varying(5),
	CONSTRAINT ax_lagebezeichnungkatalogeintrag_pk PRIMARY KEY (ogc_fid)
);

INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_lagebezeichnungkatalogeintrag', 'dummy', 2, 25832, 'POINT');

CREATE UNIQUE INDEX ax_lagebezeichnungkatalogeintrag_gml 
                 ON ax_lagebezeichnungkatalogeintrag USING btree (gml_id);

-- NRW: Nummerierung Strassenschluessel innerhalb einer Gemeinde
-- Die Kombination Gemeinde und Straßenschlüssel ist also ein eindeutiges Suchkriterium.
CREATE INDEX ax_lagebezeichnungkatalogeintrag_lage 
          ON ax_lagebezeichnungkatalogeintrag USING btree (gemeinde, lage);

-- Suchindex (Verwendung in Navigations-Programm)
CREATE INDEX ax_lagebezeichnungkatalogeintrag_gesa 
          ON ax_lagebezeichnungkatalogeintrag USING btree (schluesselgesamt);

CREATE INDEX ax_lagebezeichnungkatalogeintrag_bez
          ON ax_lagebezeichnungkatalogeintrag USING btree (bezeichnung);

COMMENT ON TABLE  ax_lagebezeichnungkatalogeintrag              IS 'Straßentabelle';
COMMENT ON COLUMN ax_lagebezeichnungkatalogeintrag.gml_id       IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN ax_lagebezeichnungkatalogeintrag.lage         IS 'Straßenschlüssel';
COMMENT ON COLUMN ax_lagebezeichnungkatalogeintrag.bezeichnung  IS 'Straßenname';


--AX_Gemeindekennzeichen
-- ** Tabelle bisher noch nicht generiert

--AX_Katalogeintrag
-- ** Tabelle bisher noch nicht generiert

--AX_Buchungsblattbezirk_Schluessel
-- ** Tabelle bisher noch nicht generiert

--AX_Dienststelle_Schluessel
-- ** Tabelle bisher noch nicht generiert

--AX_Bundesland_Schluessel
-- ** Tabelle bisher noch nicht generiert

--AX_Gemarkung_Schluessel
-- ** Tabelle bisher noch nicht generiert

--AX_GemarkungsteilFlur_Schluessel
-- ** Tabelle bisher noch nicht generiert

--AX_Regierungsbezirk_Schluessel
-- ** Tabelle bisher noch nicht generiert

--AX_Kreis_Schluessel
-- ** Tabelle bisher noch nicht generiert

--AX_VerschluesselteLagebezeichnung
-- ** Tabelle bisher noch nicht generiert


--** Objektartengruppe: Geographische Gebietseinheiten
--   ===================================================================

--AX_Landschaft
-- ** Tabelle bisher noch nicht generiert


-- k l e i n r a e u m i g e r   L a n d s c h a f t s t e i l
-- -----------------------------------------------------------
CREATE TABLE ax_kleinraeumigerlandschaftsteil (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	sonstigesmodell		character varying[],
	anlass			integer,
	landschaftstyp		integer,
	name			character varying(20)
);

SELECT AddGeometryColumn('ax_kleinraeumigerlandschaftsteil','wkb_geometry','25832','POINT',2);

ALTER TABLE ONLY ax_kleinraeumigerlandschaftsteil
	ADD CONSTRAINT ax_kleinraeumigerlandschaftsteil_pk PRIMARY KEY (ogc_fid);

CREATE INDEX ax_kleinraeumigerlandschaftsteil_geom_idx 
          ON ax_kleinraeumigerlandschaftsteil USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_kleinraeumigerlandschaftsteil_gml 
                 ON ax_kleinraeumigerlandschaftsteil USING btree (gml_id);

COMMENT ON TABLE  ax_kleinraeumigerlandschaftsteil        IS 'k l e i n r a e u m i g e r   L a n d s c h a f t s t e i l';
COMMENT ON COLUMN ax_kleinraeumigerlandschaftsteil.gml_id IS 'Identifikator, global eindeutig';


-- W o h n p l a t z
-- -----------------------------------------------------------
CREATE TABLE ax_wohnplatz (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
--	identifier		character varying(28),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	"name"			character varying(20),
	CONSTRAINT ax_wohnplatz_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_wohnplatz','wkb_geometry','25832','POINT',2);

CREATE INDEX ax_wohnplatz_geom_idx 
          ON ax_wohnplatz USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_wohnplatz_gml 
                 ON ax_wohnplatz USING btree (gml_id);

COMMENT ON TABLE  ax_wohnplatz        IS 'W o h n p l a t z';
COMMENT ON COLUMN ax_wohnplatz.gml_id IS 'Identifikator, global eindeutig';


--** Objektartengruppe: Administrative Gebietseinheiten
--   ===================================================================


-- K o m m u n a l e s   G e b i e t
-- ----------------------------------------------
CREATE TABLE ax_kommunalesgebiet (
	ogc_fid			serial NOT NULL,
	gml_id			character(16),	-- character varying(32),
	beginnt			character(20),
	advstandardmodell	character varying(9),
	anlass			integer,
	schluesselgesamt	integer,
	land			integer,
	regierungsbezirk	integer,
	kreis			integer,
	gemeinde		integer,
	CONSTRAINT ax_kommunalesgebiet_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('ax_kommunalesgebiet','wkb_geometry','25832','MULTIPOLYGON',2);

-- verschiedene Geometrietypen?
ALTER TABLE ax_kommunalesgebiet DROP CONSTRAINT enforce_geotype_wkb_geometry;

CREATE INDEX ax_kommunalesgebiet_geom_idx 
          ON ax_kommunalesgebiet USING gist (wkb_geometry);

CREATE UNIQUE INDEX ax_kommunalesgebiet_gml 
                 ON ax_kommunalesgebiet USING btree (gml_id);

COMMENT ON TABLE  ax_kommunalesgebiet        IS 'K o m m u n a l e s   G e b i e t';
COMMENT ON COLUMN ax_kommunalesgebiet.gml_id IS 'Identifikator, global eindeutig';


--AX_Gebiet
-- ** Tabelle bisher noch nicht generiert


--*** ############################################################
--*** Objektbereich: Nutzerprofile
--*** ############################################################

--** Objektartengruppe: Nutzerprofile
--   ===================================================================

--AX_FOLGEVA

--*** ############################################################
--*** Objektbereich: Migration
--*** ############################################################

--** Objektartengruppe: Migrationsobjekte
--   ===================================================================


-- Schlüsseltabelle "advstandardmodell" (9):
-- ----------------------------------------
-- LiegenschaftskatasterModell = DLKM
-- KatasterkartenModell500     = DKKM500
-- KatasterkartenModell1000    = DKKM1000
-- KatasterkartenModell2000    = DKKM2000
-- KatasterkartenModell5000    = DKKM5000
-- BasisLandschaftsModell      = Basis-DLM
-- LandschaftsModell50         = DLM50
-- LandschaftsModell250        = DLM250
-- LandschaftsModell1000       = DLM1000
-- TopographischeKarte10       = DTK10
-- TopographischeKarte25       = DTK25
-- TopographischeKarte50       = DTK50
-- TopographischeKarte100      = DTK100
-- TopographischeKarte250      = DTK250
-- TopographischeKarte1000     = DTK1000
-- Festpunktmodell             = DFGM
-- DigitalesGelaendemodell2    = DGM2
-- DigitalesGelaendemodell5    = DGM5
-- DigitalesGelaendemodell25   = DGM25
-- Digitales Gelaendemodell50  = DGM50


-- wenn schon, dann auch alle Tabellen mit Kommanteren versehen:

COMMENT ON TABLE geometry_columns IS 'Metatabelle der Geometrie-Tabellen, Tabellen ohne Geometrie bekommen Dummy-Eintrag für PostNAS-Konverter (GDAL)';
COMMENT ON TABLE spatial_ref_sys  IS 'Koordinatensysteme und ihre Projektionssparameter';


-- Tabelle delete für Lösch- und Fortführungsdatensätze
CREATE TABLE "delete" (
	ogc_fid		serial NOT NULL,
	typename	character varying(255),
	featureid	character(32),
	CONSTRAINT delete_pk PRIMARY KEY (ogc_fid)
);

-- Dummy-Eintrag in Metatabelle
INSERT INTO geometry_columns 
       (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'delete', 'dummy', 2, 25832, 'POINT');

COMMENT ON TABLE "delete" IS 'Hilfstabelle für das temporäre Zwischenspeichern von Löschinformationen während einer Aktualisierung über NAS-NBA-Verfahren.';
COMMENT ON COLUMN delete.typename   IS 'Objektart, also Name der Tabelle, aus der das Obejkt zu löschen ist.';
COMMENT ON COLUMN delete.featureid  IS 'Zusammen gesetzt aus GML-ID (16) und Zeitstempel.';

--
-- Funktion to run after import of the delete-Layer
--
-- Siehe:  http://trac.wheregroup.com/PostNAS/wiki/SchrittfuerSchritt#ImportvonFortf%C3%BChrungsdatens%C3%A4tzen
-- zu löschende Objekte (gml_id, Stelle 1-16) werden zunächst in die Tabelle 'delete' eingetragen.
-- Dann werden sie mit dieser Function aus den Fachtabellen und der Beziehungstabelle gelöscht.
CREATE FUNCTION deleteFeature(typename text, featureid text) RETURNS text 
AS $$ 
 DECLARE 
  query text;
  res text; 
 BEGIN 
     query := 'DELETE FROM ' || $1 || ' WHERE gml_id = ''' || $2 || '''';
     EXECUTE query;
     query := 'DELETE FROM alkis_beziehungen WHERE beziehung_von = ''' || $2 || ''' OR beziehung_zu = ''' || $2 || '''';
     EXECUTE query;

     IF FOUND THEN 
	--RAISE NOTICE 'query successfull % ', query; 
	res := 1;
     ELSE 
        --RAISE NOTICE 'query no object found % ', query; 
        res := 0;
     END IF; 
  RETURN res; 
 END; 
$$ LANGUAGE plpgsql; 


--
--          THE  (happy)  END
--
