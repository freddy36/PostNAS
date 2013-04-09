-- Automatisch mit pg-to-oci_keytables.pl konvertiert.
---
---
define alkis_epsg=&1

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='NUTZUNG_META';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NUTZUNG_META CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE NUTZUNG_META (
	NUTZ_ID           integer NOT NULL,
	GRUPPE            varchar2(30),
	SOURCE_TABLE      varchar2(50),
	TITLE             varchar2(50),
	FLDCLASS          varchar2(30),
	FLDINFO           varchar2(30),
	CONSTRAINT ALKIS_KEYN_0 PRIMARY KEY (NUTZ_ID)
);
COMMENT ON TABLE  NUTZUNG_META                IS 'Gruppierung und Indizierung der zusammen gefassten NUTZUNGsarten in der Tabelle "NUTZUNG".';
COMMENT ON COLUMN NUTZUNG_META.NUTZ_ID        IS 'Index fuer die Quell-Tabelle bei der Zusammenfassung in der Tabelle "NUTZUNG".';
COMMENT ON COLUMN NUTZUNG_META.SOURCE_TABLE   IS 'Name der importierten Tabelle aus PostNAS.';
COMMENT ON COLUMN NUTZUNG_META.GRUPPE         IS 'Objektartengruppe, Gruppierung der NUTZUNGsart.';
COMMENT ON COLUMN NUTZUNG_META.TITLE          IS 'Vorzeigbare Bezeichnung der NUTZUNGsartentabelle.';
COMMENT ON COLUMN NUTZUNG_META.FLDCLASS       IS 'Name des Feldes aus "source_table", das in Feld "NUTZUNG.CLASS" kopiert wird.';
COMMENT ON COLUMN NUTZUNG_META.FLDINFO        IS 'Name des Feldes aus "source_table", das in Feld "NUTZUNG.info" kopiert wird.';

DELETE FROM user_sdo_geom_METAdata WHERE upper(table_name)='NUTZUNG';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NUTZUNG CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE NUTZUNG (
	GML_ID		character(16),
	BEGINNT		character(20),
	NUTZ_ID		integer,
	CLASS		integer,
	INFO		integer,
	ZUSTAND		integer,
	NAME		varchar2(2047),
	BEZEICHNUNG	varchar2(2047),
	CONSTRAINT	NUTZUNG_pk      PRIMARY KEY (GML_ID, BEGINNT)
);

ALTER TABLE NUTZUNG ADD ORA_GEOMETRY MDSYS.SDO_GEOMETRY;
INSERT INTO user_sdo_geom_metadata(table_name,column_name,srid,diminfo) VALUES ('NUTZUNG','ORA_GEOMETRY',&&alkis_epsg,mdsys.sdo_dim_array(mdsys.sdo_dim_element('X',200000,800000,0.001),mdsys.sdo_dim_element('Y',5200000,6100000,0.001)));

CREATE INDEX ALKIS_KEYN_1  ON NUTZUNG (NUTZ_ID, CLASS);
CREATE INDEX ALKIS_KEYN_2 ON NUTZUNG(ORA_GEOMETRY) INDEXTYPE IS MDSYS.SPATIAL_INDEX PARALLEL;

ALTER TABLE NUTZUNG ADD CONSTRAINT NUTZUNG_META_ID FOREIGN KEY (NUTZ_ID) 
REFERENCES NUTZUNG_META (NUTZ_ID) ON DELETE CASCADE;

COMMENT ON TABLE  NUTZUNG             IS 'Zusammenfassung von 26 Tabellen des Objektbereiches "Tatsächliche NUTZUNG".';
COMMENT ON COLUMN NUTZUNG.GML_ID      IS 'Identifikator, global eindeutig';
COMMENT ON COLUMN NUTZUNG.NUTZ_ID     IS 'Index fuer die Quell-Tabelle bei der Zusammenfassung in der Tabelle "NUTZUNG".';
COMMENT ON COLUMN NUTZUNG.CLASS       IS 'Klassifizierung innerhalb der NUTZUNG. Aus verschiedenen Feldern importiert. Siehe "NUTZUNG_META.fldCLASS".';
COMMENT ON COLUMN NUTZUNG.INFO        IS 'Weitere verschlüsselte Information zur NUTZUNG. Aus verschiedenen Feldern importiert. Siehe "NUTZUNG_META.fldinfo".';
COMMENT ON COLUMN NUTZUNG.NAME        IS 'NAM Eigenname';
COMMENT ON COLUMN NUTZUNG.BEZEICHNUNG IS 'weitere unverschlüsselte Information wie Zweitname, Bezeichnung, fachliche Nummerierung usw.';
COMMENT ON COLUMN NUTZUNG.ZUSTAND     IS 'ZUS "Zustand" beschreibt, ob der Abschnitt ungenutzt ist.';

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='NUTZUNG_CLASS';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NUTZUNG_CLASS CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE NUTZUNG_CLASS (
	NUTZ_ID       integer NOT NULL,
	CLASS         integer NOT NULL,
	LABEL         varchar2(100),
	BLABLA        varchar2(1000),
	CONSTRAINT ALKIS_KEYN_3 PRIMARY KEY (NUTZ_ID, CLASS)
);

ALTER TABLE NUTZUNG_CLASS ADD CONSTRAINT ALKIS_KEYN_4 FOREIGN KEY (NUTZ_ID) 
REFERENCES NUTZUNG_META (NUTZ_ID) ON DELETE CASCADE;

COMMENT ON TABLE  NUTZUNG_CLASS            IS 'Schlüsseltabelle. Feinere Klassifizierung der zusammen gefassten NUTZUNGsarten.';
COMMENT ON COLUMN NUTZUNG_CLASS.NUTZ_ID    IS 'Index fuer die Quell-Tabelle bei der Zusammenfassung in der Tabelle NUTZUNG.';
COMMENT ON COLUMN NUTZUNG_CLASS.CLASS      IS 'Key, Schlüsselwert.';
COMMENT ON COLUMN NUTZUNG_CLASS.LABEL      IS 'Entschlüsselung. Art der NUTZUNG, Dies Feld soll in der Auskunft angezeigt werden.';
COMMENT ON COLUMN NUTZUNG_CLASS.BLABLA     IS 'Weitere Erläuterungen und Definitionen dazu.';


CREATE OR REPLACE VIEW NUTZUNG_MEHRFACHE_GML AS
	SELECT	a.GML_ID, 
		a.NUTZ_ID,
		a.BEGINNT as BEGINNT1, 
		b.BEGINNT as BEGINNT2
	FROM NUTZUNG a 
	JOIN NUTZUNG b 
	  ON a.GML_ID = b.GML_ID
	WHERE a.BEGINNT < b.BEGINNT
	;
purge recyclebin;
QUIT;
