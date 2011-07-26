
-- ALKIS PostNAS 0.6

-- ======================================================
-- Zusammenfassung der Tabellen der tatsächlichen Nutzung
-- ======================================================

-- Um bei einer Feature.Info (Welche Nutzung an dieser Stelle?) 
-- oder einer Verschneidung (Welche Nutzungen auf dem Flurstück?) 
-- nicht 26 verschiedene Tabellen abfragen zu müssen, werden die wichtigsten 
-- Felder dieser Tabellen zusammen gefasst.

-- Teil 1: Anlegen der Tabellen

-- Stand 
--  2010-11-10  

--  2011-07-25 PostNAS 06, Umbenennung


SET client_encoding = 'UTF-8';

-- Alles auf Anfang!

-- DROP TABLE nutzung;
-- DROP TABLE nutzung_class;
-- DROP TABLE nutzung_meta;


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
-- Dies ist die Voraussetzung für eine performante Auskunft.

CREATE TABLE nutzung
( gml_id       character(16),
  nutz_id      integer,
  class        integer,
  info         integer,
  zustand      integer,
  "name"       character varying(50),
  bezeichnung  character varying(50),
  CONSTRAINT nutzung_pk      PRIMARY KEY (gml_id),
  CONSTRAINT nutzung_meta_id FOREIGN KEY (nutz_id)
      REFERENCES nutzung_meta (nutz_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (OIDS=FALSE);

SELECT AddGeometryColumn('nutzung','wkb_geometry','25832','POLYGON',2);

-- 'class' ist nur innerhalb einer Gruppe ein sinvoller Index
CREATE INDEX idx_nutz_cls  ON nutzung USING btree (nutz_id, class);

-- Geometrischer Index für die räumliche Suche
CREATE INDEX nutzung_geom_idx ON nutzung USING gist (wkb_geometry);

-- Kommentare
COMMENT ON TABLE  nutzung             IS 'Zusammenfassung von 26 einzelnen Tabellen des Objektbereiches "Tatsächliche Nutzung".';
COMMENT ON COLUMN nutzung.gml_id      IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN nutzung.nutz_id     IS 'Index fuer die Quell-Tabelle bei der Zusammenfassung in der Tabelle "nutzung".';
COMMENT ON COLUMN nutzung.class       IS 'Klassifizierung innerhalb der Nutzung. Aus verschiedenen Feldern importiert. Siehe "nutzung_meta.fldclass".';
COMMENT ON COLUMN nutzung.info        IS 'Weitere verschlüsselte Information zur Nutzung. Aus verschiedenen Feldern importiert. Siehe "nutzung_meta.fldinfo".';
COMMENT ON COLUMN nutzung.name        IS 'NAM Eigenname';
COMMENT ON COLUMN nutzung.bezeichnung IS 'weitere unverschlüsselte Information wie Zweitname, Bezeichnung, fachliche Nummerierung usw.';
COMMENT ON COLUMN nutzung.zustand     IS 'ZUS "Zustand" beschreibt, ob der Abschnitt ungenutzt ist.';


-- Schluesseltabelle: classes innerhalb einer Nutzungsart.
-- Wird nicht aus NAS geladen sondern durch das manuell zu pflegende Script.
--  "alkis_nutzungsart_metadaten.sql"

CREATE TABLE nutzung_class (
  nutz_id       integer NOT NULL,
  class         integer NOT NULL,
  label         character varying(100),
  blabla        character varying(1000),
  CONSTRAINT nutzung_class_pk PRIMARY KEY (nutz_id, class),
  CONSTRAINT nutzung_class_id FOREIGN KEY (nutz_id)
      REFERENCES nutzung_meta (nutz_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);

COMMENT ON TABLE  nutzung_class            IS 'Schlüsseltabelle. Feinere Klassifizierung der zusammen gefassten Nutzungsarten.';
COMMENT ON COLUMN nutzung_class.nutz_id    IS 'Index fuer die Quell-Tabelle bei der Zusammenfassung in der Tabelle nutzung.';
COMMENT ON COLUMN nutzung_class.class      IS 'Key, Schlüsselwert.';
COMMENT ON COLUMN nutzung_class.label      IS 'Entschlüsselung. Art der Nutzung, Dies Feld soll in der Auskunft angezeigt werden.';
COMMENT ON COLUMN nutzung_class.blabla     IS 'Weitere Erläuterungen und Definitionen dazu.';

-- END --
