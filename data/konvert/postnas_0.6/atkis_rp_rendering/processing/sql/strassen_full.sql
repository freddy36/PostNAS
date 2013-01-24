DROP TABLE IF EXISTS map_strasse_g0;
--
SELECT
(ST_Dump(ST_LineMerge(ST_Collect(ax_strassenachse.wkb_geometry)))).geom AS wkb_geometry, 
ax_strasse.widmung,
ax_strasse.name_, 
CASE 
  WHEN ax_strasse.widmung = 1301 
  THEN unnest(regexp_matches(ax_strasse.bezeichnung, E'(A[0-9]+)'))
  ELSE ax_strasse.bezeichnung
END AS bezeichnung,
ax_strasse.strassenschluessel 
INTO map_strasse_g0
FROM ax_strasse 
INNER JOIN alkis_beziehungen 
ON (alkis_beziehungen.beziehung_zu = ax_strasse.gml_id) 
INNER JOIN ax_strassenachse ON (ax_strassenachse.gml_id=alkis_beziehungen.beziehung_von)
GROUP BY name_, bezeichnung, strassenschluessel, widmung;
--
DROP SEQUENCE IF EXISTS map_strasse_g0_gid_seq;
CREATE SEQUENCE map_strasse_g0_gid_seq;
ALTER TABLE map_strasse_g0 ADD COLUMN gid INTEGER;
UPDATE map_strasse_g0 SET gid = nextval('map_strasse_g0_gid_seq');
ALTER TABLE map_strasse_g0 ALTER COLUMN gid SET DEFAULT nextval('map_strasse_g0_gid_seq');
CREATE INDEX map_strasse_g0_gidx ON map_strasse_g0 USING GIST ( wkb_geometry );
CREATE INDEX map_strasse_g0_widmung_idx ON map_strasse_g0 (widmung);
--
--
DROP TABLE IF EXISTS map_strasse_g1;
--
SELECT ST_SimplifyPreserveTopology(wkb_geometry, 5) AS wkb_geometry, widmung, name_, bezeichnung
INTO map_strasse_g1
FROM map_strasse_g0;
--
DROP SEQUENCE IF EXISTS map_strasse_g1_gid_seq;
CREATE SEQUENCE map_strasse_g1_gid_seq;
ALTER TABLE map_strasse_g1 ADD COLUMN gid INTEGER;
UPDATE map_strasse_g1 SET gid = nextval('map_strasse_g1_gid_seq');
ALTER TABLE map_strasse_g1 ALTER COLUMN gid SET DEFAULT nextval('map_strasse_g1_gid_seq');
CREATE INDEX map_strasse_g1_gidx ON map_strasse_g1 USING GIST ( wkb_geometry );
CREATE INDEX map_strasse_g1_widmung_idx ON map_strasse_g1 (widmung);
--
--
DROP TABLE IF EXISTS map_strasse_g2;
--
SELECT ST_SimplifyPreserveTopology(wkb_geometry, 15) AS wkb_geometry, widmung, name_, bezeichnung
INTO map_strasse_g2
FROM map_strasse_g1;
--
DROP SEQUENCE IF EXISTS map_strasse_g2_gid_seq;
CREATE SEQUENCE map_strasse_g2_gid_seq;
ALTER TABLE map_strasse_g2 ADD COLUMN gid INTEGER;
UPDATE map_strasse_g2 SET gid = nextval('map_strasse_g2_gid_seq');
ALTER TABLE map_strasse_g2 ALTER COLUMN gid SET DEFAULT nextval('map_strasse_g2_gid_seq');
CREATE INDEX map_strasse_g2_gidx ON map_strasse_g2 USING GIST ( wkb_geometry );
CREATE INDEX map_strasse_g2_widmung_idx ON map_strasse_g2 (widmung);
--
--
DROP TABLE IF EXISTS map_strasse_g3;
--
SELECT ST_SimplifyPreserveTopology(wkb_geometry, 35) AS wkb_geometry, widmung, name_, bezeichnung
INTO map_strasse_g3
FROM map_strasse_g2;
--
DROP SEQUENCE IF EXISTS map_strasse_g3_gid_seq;
CREATE SEQUENCE map_strasse_g3_gid_seq;
ALTER TABLE map_strasse_g3 ADD COLUMN gid INTEGER;
UPDATE map_strasse_g3 SET gid = nextval('map_strasse_g3_gid_seq');
ALTER TABLE map_strasse_g3 ALTER COLUMN gid SET DEFAULT nextval('map_strasse_g3_gid_seq');
CREATE INDEX map_strasse_g3_gidx ON map_strasse_g3 USING GIST ( wkb_geometry );
CREATE INDEX map_strasse_g3_widmung_idx ON map_strasse_g3 (widmung);
--
--
DROP TABLE IF EXISTS map_strasse_g4;
--
SELECT ST_SimplifyPreserveTopology(wkb_geometry, 50) AS wkb_geometry, widmung, name_, bezeichnung
INTO map_strasse_g4
FROM map_strasse_g3;
--
DROP SEQUENCE IF EXISTS map_strasse_g4_gid_seq;
CREATE SEQUENCE map_strasse_g4_gid_seq;
ALTER TABLE map_strasse_g4 ADD COLUMN gid INTEGER;
UPDATE map_strasse_g4 SET gid = nextval('map_strasse_g4_gid_seq');
ALTER TABLE map_strasse_g4 ALTER COLUMN gid SET DEFAULT nextval('map_strasse_g4_gid_seq');
CREATE INDEX map_strasse_g4_gidx ON map_strasse_g4 USING GIST ( wkb_geometry );
CREATE INDEX map_strasse_g4_widmung_idx ON map_strasse_g4 (widmung);
--
--
DROP TABLE IF EXISTS map_strasse_g5;
--
SELECT ST_SimplifyPreserveTopology(wkb_geometry, 100) AS wkb_geometry, widmung, name_, bezeichnung
INTO map_strasse_g5
FROM map_strasse_g4;
--
DROP SEQUENCE IF EXISTS map_strasse_g5_gid_seq;
CREATE SEQUENCE map_strasse_g5_gid_seq;
ALTER TABLE map_strasse_g5 ADD COLUMN gid INTEGER;
UPDATE map_strasse_g5 SET gid = nextval('map_strasse_g5_gid_seq');
ALTER TABLE map_strasse_g5 ALTER COLUMN gid SET DEFAULT nextval('map_strasse_g5_gid_seq');
CREATE INDEX map_strasse_g5_gidx ON map_strasse_g5 USING GIST ( wkb_geometry );
CREATE INDEX map_strasse_g5_widmung_idx ON map_strasse_g5 (widmung);
--
--
DROP TABLE IF EXISTS map_strasse_g6;
--
SELECT (ST_Dump(ST_SimplifyPreserveTopology(wkb_geometry, 200))).geom AS wkb_geometry, widmung, name_, bezeichnung
INTO map_strasse_g6
FROM map_strasse_g5;
--
DROP SEQUENCE IF EXISTS map_strasse_g6_gid_seq;
CREATE SEQUENCE map_strasse_g6_gid_seq;
ALTER TABLE map_strasse_g6 ADD COLUMN gid INTEGER;
UPDATE map_strasse_g6 SET gid = nextval('map_strasse_g6_gid_seq');
ALTER TABLE map_strasse_g6 ALTER COLUMN gid SET DEFAULT nextval('map_strasse_g6_gid_seq');
CREATE INDEX map_strasse_g6_gidx ON map_strasse_g6 USING GIST ( wkb_geometry );
CREATE INDEX map_strasse_g6_widmung_idx ON map_strasse_g6 (widmung);
--
