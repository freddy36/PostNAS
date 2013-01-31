-- Automatisch mit pg-to-oci_keytables.pl konvertiert.
---
---

DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='PP_GEMEINDE';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PP_GEMEINDE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE PP_GEMEINDE (
    gid			integer,
    land		integer NOT NULL,
    regierungsbezirk	integer,
    kreis		integer,
    gemeinde		integer NOT NULL,
    gemeindename	character varying(80),
    anz_gemarkg		integer,
    CONSTRAINT ALKIS_KEY_0 PRIMARY KEY (land, gemeinde)
  );
CREATE UNIQUE INDEX ALKIS_KEY_1 ON pp_gemeinde (gid);
SELECT AddGeometryColumn('pp_gemeinde','the_geom','25832','MULTIPOLYGON',2);
CREATE INDEX ALKIS_KEY_2 ON PP_GEMEINDE(THE_GEOM) INDEXTYPE IS MDSYS.SPATIAL_INDEX PARALLEL;
SELECT AddGeometryColumn('pp_gemeinde','simple_geom','25832','MULTIPOLYGON',2);
CREATE INDEX ALKIS_KEY_3 ON PP_GEMEINDE(SIMPLE_GEOM) INDEXTYPE IS MDSYS.SPATIAL_INDEX PARALLEL;
  COMMENT ON TABLE  pp_gemeinde                IS 'Post-Processing: Gemeinde';
  COMMENT ON COLUMN pp_gemeinde.gemeinde       IS 'Gemeindenummer';
  COMMENT ON COLUMN pp_gemeinde.the_geom       IS 'präzise Geometrie aus Summe aller Gemarkungen';
  COMMENT ON COLUMN pp_gemeinde.simple_geom    IS 'vereinfachte Geometrie für die Suche und die Anzeige von Übersichten in kleinen Maßstäben.';
  
DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='PP_GEMARKUNG';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PP_GEMARKUNG CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE PP_GEMARKUNG (
    gid			integer,
    land		integer NOT NULL,
    regierungsbezirk	integer,
    kreis		integer,
    gemeinde		integer NOT NULL,
    gemarkung		integer NOT NULL,
    gemarkungsname	character varying(80),
    anz_flur		integer,
    CONSTRAINT ALKIS_KEY_4 PRIMARY KEY (land, gemarkung)
  );
CREATE UNIQUE INDEX ALKIS_KEY_5 ON pp_gemarkung (gid);
SELECT AddGeometryColumn('pp_gemarkung','the_geom','25832','MULTIPOLYGON',2);
CREATE INDEX ALKIS_KEY_6 ON PP_GEMARKUNG(THE_GEOM) INDEXTYPE IS MDSYS.SPATIAL_INDEX PARALLEL;
SELECT AddGeometryColumn('pp_gemarkung','simple_geom','25832','MULTIPOLYGON',2);
CREATE INDEX ALKIS_KEY_7 ON PP_GEMARKUNG(SIMPLE_GEOM) INDEXTYPE IS MDSYS.SPATIAL_INDEX PARALLEL;
COMMENT ON TABLE  pp_gemarkung               IS 'Post-Processing: Gemarkung. u.a. liegt in welcher Gemeinde';
COMMENT ON COLUMN pp_gemarkung.gemeinde      IS 'Gemeindenummer';
COMMENT ON COLUMN pp_gemarkung.gemarkung     IS 'Gemarkungsnummer';
COMMENT ON COLUMN pp_gemarkung.the_geom      IS 'präzise Geometrie aus Summe aller Fluren';
COMMENT ON COLUMN pp_gemarkung.simple_geom   IS 'vereinfachte Geometrie für die Suche und die Anzeige von Übersichten in kleinen Maßstäben.';
  
DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='PP_FLUR';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PP_FLUR CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE PP_FLUR (
    gid			integer,
    land		integer NOT NULL,
    regierungsbezirk	integer,
    kreis		integer,
    gemarkung		integer NOT NULL,
    flurnummer		integer NOT NULL,
    anz_fs		integer,
    CONSTRAINT ALKIS_KEY_8 PRIMARY KEY (land, gemarkung, flurnummer)
  );
CREATE UNIQUE INDEX ALKIS_KEY_9 ON pp_flur (gid);
SELECT AddGeometryColumn('pp_flur','the_geom','25832','MULTIPOLYGON',2);
CREATE INDEX ALKIS_KEY_10 ON PP_FLUR(THE_GEOM) INDEXTYPE IS MDSYS.SPATIAL_INDEX PARALLEL;
COMMENT ON TABLE  pp_flur                IS 'Post-Processing: Flur';
COMMENT ON COLUMN pp_flur.gemarkung      IS 'Gemarkungsnummer';
COMMENT ON COLUMN pp_flur.the_geom       IS 'Geometrie aus Summe aller Flurstücke';
  
DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='GEMEINDE_PERSON';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE GEMEINDE_PERSON CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE GEMEINDE_PERSON (
    land 		integer,
    regierungsbezirk	integer,
    kreis		integer,
    gemeinde		integer,
    person		character varying(16),
    buchtyp		integer,
    CONSTRAINT ALKIS_KEY_11 PRIMARY KEY (gemeinde, person)
  );
COMMENT ON TABLE  gemeinde_person            IS 'Person ist Eigentümer von mindestens einem Flurstück in der Gemeinde';
COMMENT ON COLUMN gemeinde_person.gemeinde   IS 'Gemeindenummer';
COMMENT ON COLUMN gemeinde_person.buchtyp    IS 'Typ der Buchung 1=direkt, 2=Recht einer Buchungsstele an andere Buchungsstelle';
COMMENT ON COLUMN gemeinde_person.person     IS 'gml_id von Person';
CREATE INDEX ALKIS_KEY_12  ON gemeinde_person (person, gemeinde);
  
DELETE FROM user_sdo_geom_metadata WHERE upper(table_name)='PP_FLURSTUECK_NR';
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PP_FLURSTUECK_NR CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE PP_FLURSTUECK_NR (
    gid		integer,
    fsgml	character(16),
    fsnum	character varying(10),
    CONSTRAINT ALKIS_KEY_13  PRIMARY KEY (gid)
  );
SELECT AddGeometryColumn('pp_flurstueck_nr','the_geom','25832','POINT',2);
CREATE INDEX ALKIS_KEY_14 ON PP_FLURSTUECK_NR(THE_GEOM) INDEXTYPE IS MDSYS.SPATIAL_INDEX PARALLEL;
CREATE INDEX ALKIS_KEY_15 ON pp_flurstueck_nr(fsgml);
COMMENT ON TABLE  pp_flurstueck_nr           IS 'Post-Processing: Position der Flurstücksnummer in der Karte';
COMMENT ON COLUMN pp_flurstueck_nr.fsgml     IS 'gml_id des zugehörigen Flurstücks-Objektes';
COMMENT ON COLUMN pp_flurstueck_nr.fsnum     IS 'Label, Darzustellende FS-Nummer als Bruch';
COMMENT ON COLUMN pp_flurstueck_nr.the_geom  IS 'Position der Flurstücksnummer in der Karte';
CREATE VIEW gemeinde_gemarkung
AS
  SELECT g.land, g.regierungsbezirk, g.kreis, g.gemeinde, k.gemarkung, g.gemeindename, k.gemarkungsname
  FROM pp_gemarkung k
  JOIN pp_gemeinde  g 
    ON k.land = g.land 
   AND k.gemeinde = g.gemeinde;
CREATE VIEW gemeinde_person_typ1
AS
  SELECT DISTINCT
    p.gml_id          AS person, 
    g.land, g.regierungsbezirk, g.kreis, g.gemeinde
  FROM ax_person               p
  JOIN alkis_beziehungen      bpn  ON bpn.beziehung_zu   = p.gml_id
  JOIN ax_namensnummer         n   ON bpn.beziehung_von  = n.gml_id
  JOIN alkis_beziehungen      bnb  ON bnb.beziehung_von  = n.gml_id
  JOIN ax_buchungsblatt        b   ON bnb.beziehung_zu   = b.gml_id
  JOIN alkis_beziehungen      bbg  ON bbg.beziehung_zu   = b.gml_id
  JOIN ax_buchungsstelle       s   ON bbg.beziehung_von  = s.gml_id 
  JOIN alkis_beziehungen      bsf  ON bsf.beziehung_zu   = s.gml_id
  JOIN ax_flurstueck           f   ON bsf.beziehung_von  = f.gml_id 
  JOIN ax_gemarkung            k   ON f.land             = k.land 
                                  AND f.gemarkungsnummer = k.gemarkungsnummer 
  JOIN gemeinde_gemarkung      g   ON k.gemarkungsnummer = g.gemarkung
  WHERE bpn.beziehungsart = 'benennt' 
    AND bnb.beziehungsart = 'istBestandteilVon'
    AND bbg.beziehungsart = 'istBestandteilVon'
    AND bsf.beziehungsart = 'istGebucht';
COMMENT ON VIEW gemeinde_person_typ1 IS 'Personen die Eigentümer vom Flurstücken in einer Gemeinde sind. Typ1 = nomale Buchungen mit direkter Beziehung.';
CREATE VIEW gemeinde_person_typ2
AS
  SELECT DISTINCT
    p.gml_id          AS person, 
    g.land, g.regierungsbezirk, g.kreis, g.gemeinde
  FROM ax_person               p
  JOIN alkis_beziehungen      bpn  ON bpn.beziehung_zu   = p.gml_id
  JOIN ax_namensnummer         n   ON bpn.beziehung_von  = n.gml_id
  JOIN alkis_beziehungen      bnb  ON bnb.beziehung_von  = n.gml_id
  JOIN ax_buchungsblatt        b   ON bnb.beziehung_zu   = b.gml_id
  JOIN alkis_beziehungen      bbg  ON bbg.beziehung_zu   = b.gml_id
  JOIN ax_buchungsstelle       s1  ON bbg.beziehung_von  = s1.gml_id 
  JOIN alkis_beziehungen      bss  ON bss.beziehung_von  = s1.gml_id
  JOIN ax_buchungsstelle       s2  ON bss.beziehung_zu   = s2.gml_id 
  JOIN alkis_beziehungen      bsf  ON bsf.beziehung_zu   = s2.gml_id
  JOIN ax_flurstueck           f   ON bsf.beziehung_von  = f.gml_id 
  JOIN ax_gemarkung            k   ON f.land             = k.land 
                                  AND f.gemarkungsnummer = k.gemarkungsnummer 
  JOIN gemeinde_gemarkung      g   ON k.gemarkungsnummer = g.gemarkung
  WHERE bpn.beziehungsart = 'benennt' 
    AND bnb.beziehungsart = 'istBestandteilVon'
    AND bbg.beziehungsart = 'istBestandteilVon'
    AND bss.beziehungsart = 'an'
    AND bsf.beziehungsart = 'istGebucht'
;
COMMENT ON VIEW gemeinde_person_typ2 IS 'Personen die Eigentümer vom Flurstücken in einer Gemeinde sind. Typ2 = Buchungen mit Rechten einer Buchungssstelle an einer anderen.';
CREATE VIEW gemeinde_person_statistik
AS
  SELECT p.land, p.regierungsbezirk, p.kreis, p.gemeinde, g.gemeindename, p.buchtyp, count(p.person) as personen
  FROM   gemeinde_person    p
  JOIN   gemeinde_gemarkung g
    ON   p.land     = g.land 
    AND  p.regierungsbezirk = g.regierungsbezirk 
    AND  p.kreis    = g.kreis 
    AND  p.gemeinde = g.gemeinde
  GROUP BY p.land, p.regierungsbezirk, p.kreis, p.gemeinde, g.gemeindename, p.buchtyp
  ORDER BY p.land, p.regierungsbezirk, p.kreis, p.gemeinde, p.buchtyp;
COMMENT ON VIEW gemeinde_person_statistik IS 'Zählen der Personen je Gemeinde und Buchungstyp';
CREATE VIEW pp_gemeinde_analyse AS
  SELECT land, gemeinde, gemeindename,
         st_npoints(the_geom)    AS umring_alle_punkte,
         st_npoints(simple_geom) AS umring_einfache_punkte
  FROM pp_gemeinde;
CREATE VIEW pp_gemarkung_analyse AS
  SELECT land, gemeinde, gemarkung, gemarkungsname,
         st_npoints(the_geom)    AS umring_alle_punkte,
         st_npoints(simple_geom) AS umring_einfache_punkte
  FROM pp_gemarkung;
purge recyclebin;
QUIT;
