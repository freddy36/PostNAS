-- Automatisch mit pg-to-oci_keytables.pl konvertiert.
---
---

SET client_encoding = 'UTF-8';

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='NUTZUNG_META';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NUTZUNG_META CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE NUTZUNG_META (
	nutz_id           integer NOT NULL,
	gruppe            character varying(30),
	source_table      character varying(50),
	title             character varying(50),
	fldclass          character varying(30),
	fldinfo           character varying(30),
	CONSTRAINT ALKIS_KEY_0 PRIMARY KEY (nutz_id)
);
COMMENT ON TABLE  nutzung_meta                IS 'Gruppierung und Indizierung der zusammen gefassten Nutzungsarten in der Tabelle "nutzung".';
COMMENT ON COLUMN nutzung_meta.nutz_id        IS 'Index fuer die Quell-Tabelle bei der Zusammenfassung in der Tabelle "nutzung".';
COMMENT ON COLUMN nutzung_meta.source_table   IS 'Name der importierten Tabelle aus PostNAS.';
COMMENT ON COLUMN nutzung_meta.gruppe         IS 'Objektartengruppe, Gruppierung der Nutzungsart.';
COMMENT ON COLUMN nutzung_meta.title          IS 'Vorzeigbare Bezeichnung der Nutzungsartentabelle.';
COMMENT ON COLUMN nutzung_meta.fldclass       IS 'Name des Feldes aus "source_table", das in Feld "nutzung.class" kopiert wird.';
COMMENT ON COLUMN nutzung_meta.fldinfo        IS 'Name des Feldes aus "source_table", das in Feld "nutzung.info" kopiert wird.';

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='NUTZUNG';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NUTZUNG CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE NUTZUNG (
	gml_id		character(16),
	beginnt		character(20),
	nutz_id		integer,
	class		integer,
	info		integer,
	zustand		integer,
	"name"		varchar2(2047),
	bezeichnung	varchar2(2047),
	CONSTRAINT	nutzung_pk      PRIMARY KEY (gml_id, beginnt),
	CONSTRAINT	nutzung_meta_id FOREIGN KEY (nutz_id)
		REFERENCES nutzung_meta (nutz_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE
)
WITH (OIDS=FALSE);
SELECT AddGeometryColumn('nutzung','ora_geometry','25832','POLYGON',2);
CREATE INDEX ALKIS_KEY_1  ON nutzung (nutz_id, class);
CREATE INDEX ALKIS_KEY_2 ON NUTZUNG(ORA_GEOMETRY) INDEXTYPE IS MDSYS.SPATIAL_INDEX PARALLEL;
COMMENT ON TABLE  nutzung             IS 'Zusammenfassung von 26 Tabellen des Objektbereiches "Tatsächliche Nutzung".';
COMMENT ON COLUMN nutzung.gml_id      IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN nutzung.nutz_id     IS 'Index fuer die Quell-Tabelle bei der Zusammenfassung in der Tabelle "nutzung".';
COMMENT ON COLUMN nutzung.class       IS 'Klassifizierung innerhalb der Nutzung. Aus verschiedenen Feldern importiert. Siehe "nutzung_meta.fldclass".';
COMMENT ON COLUMN nutzung.info        IS 'Weitere verschlüsselte Information zur Nutzung. Aus verschiedenen Feldern importiert. Siehe "nutzung_meta.fldinfo".';
COMMENT ON COLUMN nutzung.name        IS 'NAM Eigenname';
COMMENT ON COLUMN nutzung.bezeichnung IS 'weitere unverschlüsselte Information wie Zweitname, Bezeichnung, fachliche Nummerierung usw.';
COMMENT ON COLUMN nutzung.zustand     IS 'ZUS "Zustand" beschreibt, ob der Abschnitt ungenutzt ist.';

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='NUTZUNG_CLASS';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NUTZUNG_CLASS CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE NUTZUNG_CLASS (
	nutz_id       integer NOT NULL,
	class         integer NOT NULL,
	label         character varying(100),
	blabla        character varying(1000),
	CONSTRAINT ALKIS_KEY_3 PRIMARY KEY (nutz_id, class),
	CONSTRAINT ALKIS_KEY_4 FOREIGN KEY (nutz_id)
		REFERENCES nutzung_meta (nutz_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE
);
COMMENT ON TABLE  nutzung_class            IS 'Schlüsseltabelle. Feinere Klassifizierung der zusammen gefassten Nutzungsarten.';
COMMENT ON COLUMN nutzung_class.nutz_id    IS 'Index fuer die Quell-Tabelle bei der Zusammenfassung in der Tabelle nutzung.';
COMMENT ON COLUMN nutzung_class.class      IS 'Key, Schlüsselwert.';
COMMENT ON COLUMN nutzung_class.label      IS 'Entschlüsselung. Art der Nutzung, Dies Feld soll in der Auskunft angezeigt werden.';
COMMENT ON COLUMN nutzung_class.blabla     IS 'Weitere Erläuterungen und Definitionen dazu.';
CREATE OR REPLACE VIEW nutzung_mehrfache_gml AS
	SELECT	a.gml_id, 
		a.nutz_id,
		a.beginnt as beginnt1, 
		b.beginnt as beginnt2
	FROM nutzung a 
	JOIN nutzung b 
	  ON a.gml_id = b.gml_id
	WHERE a.beginnt < b.beginnt
	;
purge recyclebin;
QUIT;
