
-- ALKIS PostNAS 0.7

-- ======================================================
-- Zusammenfassung der Tabellen der tatsächlichen Nutzung
-- ======================================================

-- Um bei einer Feature.Info (Welche Nutzung an dieser Stelle?) 
-- oder einer Verschneidung (Welche Nutzungen auf dem Flurstück?) 
-- nicht 26 verschiedene Tabellen abfragen zu müssen, werden die wichtigsten 
-- Felder dieser Tabellen zusammen gefasst.

-- Teil 1: Anlegen der Tabellen

-- Stand 

--  2012-02-10 PostNAS 07, Umbenennung
--  2013-11-15 In nutzung_class.class können NULL-Werte auftreten.
--  2013-11-26 NULL wird durch Zahl "0" ersetzt, "NOT NULL" wieder aktivieren
--  2014-08-26 erweiterte gml_id (wie in den primären Tabellen)

SET client_encoding = 'UTF-8';

-- Alles auf Anfang!
/*
  DROP TABLE nutzung;
  DROP TABLE nutzung_class;
  DROP TABLE nutzung_meta;
*/

-- Meta-Informationen ueber die Zusammenfassung und Gruppierung
-- ------------------------------------------------------------
CREATE TABLE nutzung_meta (
	nutz_id           integer NOT NULL,
	gruppe            character varying(30),
	source_table      character varying(50),
	title             character varying(50),
	fldclass          character varying(30),
	fldinfo           character varying(30),
	CONSTRAINT nutzung_meta_pk PRIMARY KEY (nutz_id)
);

COMMENT ON TABLE  nutzung_meta                IS 'Gruppierung und Indizierung der zusammen gefassten Nutzungsarten in der Tabelle "nutzung".';
COMMENT ON COLUMN nutzung_meta.nutz_id        IS 'Index fuer die Quell-Tabelle bei der Zusammenfassung in der Tabelle "nutzung".';
COMMENT ON COLUMN nutzung_meta.source_table   IS 'Name der importierten Tabelle aus PostNAS.';
COMMENT ON COLUMN nutzung_meta.gruppe         IS 'Objektartengruppe, Gruppierung der Nutzungsart.';
COMMENT ON COLUMN nutzung_meta.title          IS 'Vorzeigbare Bezeichnung der Nutzungsartentabelle.';
COMMENT ON COLUMN nutzung_meta.fldclass       IS 'Name des Feldes aus "source_table", das in Feld "nutzung.class" kopiert wird.';
COMMENT ON COLUMN nutzung_meta.fldinfo        IS 'Name des Feldes aus "source_table", das in Feld "nutzung.info" kopiert wird.';


-- Alle Abschnitte der "tatsächlichen Nutzung" vereinigt in einer Tabelle 
-- Sie sind dann mit einem gemeinsamen Geometrie-Index mit einer SQL-Abfrage auffindbar.
-- Dies ist die förderlich für eine performante Auskunft.

CREATE TABLE nutzung (
	gml_id		     character varying NOT NULL,
	beginnt		     character(20),	     -- mehrfache gml_id eindeutig machen
--   endet               character(20),      -- nur "ended IS NULL" kopieren
	nutz_id		     integer,
	class		     integer NOT NULL,   -- NULL-Werte der Quelltabelle durch den num. Wert 0 ersetzen
	info		          integer,
	zustand		     integer,
	"name"		     character varying,
	bezeichnung	     character varying,
	CONSTRAINT nutzung_pk      PRIMARY KEY (gml_id, beginnt),
	CONSTRAINT nutzung_meta_id FOREIGN KEY (nutz_id)
		REFERENCES nutzung_meta (nutz_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (OIDS=FALSE);


SELECT AddGeometryColumn('nutzung','wkb_geometry','25832','POLYGON',2);
-- Vereinzelt auch vorkommende MULTIPOLYGON

-- 'class' ist nur innerhalb einer Gruppe ein sinvoller Index
CREATE INDEX idx_nutz_cls  ON nutzung USING btree (nutz_id, class);

-- Geometrischer Index für die räumliche Suche
CREATE INDEX nutzung_geom_idx ON nutzung USING gist (wkb_geometry);

COMMENT ON TABLE  nutzung             IS 'Zusammenfassung von 26 Tabellen des Objektbereiches "Tatsächliche Nutzung".';
COMMENT ON COLUMN nutzung.gml_id      IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN nutzung.nutz_id     IS 'Index fuer die Quell-Tabelle bei der Zusammenfassung in der Tabelle "nutzung".';
COMMENT ON COLUMN nutzung.class       IS 'Klassifizierung innerhalb der Nutzung. Aus verschiedenen Feldern importiert. Siehe "nutzung_meta.fldclass".';
COMMENT ON COLUMN nutzung.info        IS 'Weitere verschlüsselte Information zur Nutzung. Aus verschiedenen Feldern importiert. Siehe "nutzung_meta.fldinfo".';
COMMENT ON COLUMN nutzung.name        IS 'NAM Eigenname';
COMMENT ON COLUMN nutzung.bezeichnung IS 'weitere unverschlüsselte Information wie Zweitname, Bezeichnung, fachliche Nummerierung usw.';
COMMENT ON COLUMN nutzung.zustand     IS 'ZUS "Zustand" beschreibt, ob der Abschnitt ungenutzt ist.';


-- Schluesseltabelle: classes innerhalb einer Nutzungsart.
-- Wird nicht aus NAS geladen sondern durch das manuell zu pflegende Script "nutzungsart_metadaten.sql"
CREATE TABLE nutzung_class (
	nutz_id       integer NOT NULL,
	class         integer, --  NOT NULL,
	label         character varying(100),
	blabla        character varying(1000),
    CONSTRAINT nutzung_class_pk PRIMARY KEY (nutz_id, class),
	CONSTRAINT nutzung_class_id FOREIGN KEY (nutz_id)
		REFERENCES nutzung_meta (nutz_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE
);

  COMMENT ON TABLE  nutzung_class            IS 'Schlüsseltabelle. Feinere Klassifizierung der zusammen gefassten Nutzungsarten.';
  COMMENT ON COLUMN nutzung_class.nutz_id    IS 'Index fuer die Quell-Tabelle bei der Zusammenfassung in der Tabelle nutzung.';
  COMMENT ON COLUMN nutzung_class.class      IS 'Key, Schlüsselwert oder NULL';
  COMMENT ON COLUMN nutzung_class.label      IS 'Entschlüsselung. Art der Nutzung, Dies Feld soll in der Auskunft angezeigt werden.';
  COMMENT ON COLUMN nutzung_class.blabla     IS 'Weitere Erläuterungen und Definitionen dazu.';


-- Fehlersuche nach GDAL Patch #5444:
-- Da nun gml_id nicht mehr PRIMARY KEY der Ausgangstabellen ist , kommt es auch zu Doppelbelegungen der Zusammenfassung.
-- Diese Fälle suchen.
CREATE OR REPLACE VIEW nutzung_mehrfache_gml AS
	SELECT a.gml_id, a.nutz_id, a.beginnt as beginnt1, b.beginnt as beginnt2
	FROM nutzung a 
	JOIN nutzung b ON a.gml_id = b.gml_id
	WHERE a.beginnt < b.beginnt
	--LIMIT 100
	;

-- Vorkommende Geometry-Typen

--  SELECT a.gml_id, st_geometrytype(a.wkb_geometry) as geomtype ,a.artderbebauung, a.zustand, a.name, a.beginnt
--  FROM ax_wohnbauflaeche a WHERE geometrytype(wkb_geometry) <> 'POLYGON';

--  SELECT a.gml_id, st_geometrytype(a.wkb_geometry) as geomtype ,a.artderbebauung, a.zustand, a.name, a.beginnt
--  FROM ax_wohnbauflaeche a WHERE geometrytype(wkb_geometry) <> 'POLYGON';

-- Ergebnis:    Ein MULTIPOLYGON
-- Konsequenz:  nur Polygone kopieren.

-- END --
