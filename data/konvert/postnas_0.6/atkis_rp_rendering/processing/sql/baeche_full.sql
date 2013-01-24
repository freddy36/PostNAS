DROP TABLE IF EXISTS ax_gewaesserachse_merged;
--
SELECT ax_gewaesserachse.wkb_geometry, ax_wasserlauf.name_ as widmung into ax_gewaesserachse_merged from ax_wasserlauf INNER JOIN alkis_beziehungen ON (alkis_beziehungen.beziehung_zu = ax_wasserlauf.gml_id) INNER JOIN ax_gewaesserachse ON 
(ax_gewaesserachse.gml_id=alkis_beziehungen.beziehung_von);
--
DROP TABLE IF EXISTS map_baeche_g0;
--
SELECT (ST_Dump(ST_Linemerge(ST_Collect(ST_SimplifyPreserveTopology( wkb_geometry, 2.5 ))))).geom AS wkb_geometry,
widmung
INTO map_baeche_g0 
FROM ax_gewaesserachse_merged GROUP BY ax_gewaesserachse_merged.widmung;
--
DROP SEQUENCE IF EXISTS map_baeche_g0_gid_seq;
CREATE SEQUENCE map_baeche_g0_gid_seq;
ALTER TABLE map_baeche_g0 ADD COLUMN gid INTEGER;
UPDATE map_baeche_g0 SET gid = nextval('map_baeche_g0_gid_seq');
ALTER TABLE map_baeche_g0 ALTER COLUMN gid SET DEFAULT nextval('map_baeche_g0_gid_seq');
CREATE INDEX map_baeche_g0_gidx ON map_baeche_g0 USING GIST ( wkb_geometry );
--
--
DROP TABLE IF EXISTS map_baeche_g1;
--
SELECT (ST_Dump(ST_SimplifyPreserveTopology( wkb_geometry, 5 ))).geom AS wkb_geometry, widmung
INTO map_baeche_g1 
FROM map_baeche_g0;
--
DROP SEQUENCE IF EXISTS map_baeche_g1_gid_seq;
CREATE SEQUENCE map_baeche_g1_gid_seq;
ALTER TABLE map_baeche_g1 ADD COLUMN gid INTEGER;
UPDATE map_baeche_g1 SET gid = nextval('map_baeche_g1_gid_seq');
ALTER TABLE map_baeche_g1 ALTER COLUMN gid SET DEFAULT nextval('map_baeche_g1_gid_seq');
CREATE INDEX map_baeche_g1_gidx ON map_baeche_g1 USING GIST ( wkb_geometry );
--
--
DROP TABLE IF EXISTS map_baeche_g2;
--
SELECT (ST_Dump(ST_SimplifyPreserveTopology( wkb_geometry, 15 ))).geom AS wkb_geometry, widmung
INTO map_baeche_g2 
FROM map_baeche_g1;
--
DROP SEQUENCE IF EXISTS map_baeche_g2_gid_seq;
CREATE SEQUENCE map_baeche_g2_gid_seq;
ALTER TABLE map_baeche_g2 ADD COLUMN gid INTEGER;
UPDATE map_baeche_g2 SET gid = nextval('map_baeche_g2_gid_seq');
ALTER TABLE map_baeche_g2 ALTER COLUMN gid SET DEFAULT nextval('map_baeche_g2_gid_seq');
CREATE INDEX map_baeche_g2_gidx ON map_baeche_g2 USING GIST ( wkb_geometry );
--
--
DROP TABLE IF EXISTS map_baeche_g3;
--
SELECT (ST_Dump(ST_SimplifyPreserveTopology( wkb_geometry, 35 ))).geom AS wkb_geometry, widmung
INTO map_baeche_g3 
FROM map_baeche_g2;
--
DROP SEQUENCE IF EXISTS map_baeche_g3_gid_seq;
CREATE SEQUENCE map_baeche_g3_gid_seq;
ALTER TABLE map_baeche_g3 ADD COLUMN gid INTEGER;
UPDATE map_baeche_g3 SET gid = nextval('map_baeche_g3_gid_seq');
ALTER TABLE map_baeche_g3 ALTER COLUMN gid SET DEFAULT nextval('map_baeche_g3_gid_seq');
CREATE INDEX map_baeche_g3_gidx ON map_baeche_g3 USING GIST ( wkb_geometry );
--
--
DROP TABLE IF EXISTS map_baeche_g4;
--
SELECT (ST_Dump(ST_SimplifyPreserveTopology( wkb_geometry, 65 ))).geom AS wkb_geometry, widmung
INTO map_baeche_g4 
FROM map_baeche_g3;
--
DROP SEQUENCE IF EXISTS map_baeche_g4_gid_seq;
CREATE SEQUENCE map_baeche_g4_gid_seq;
ALTER TABLE map_baeche_g4 ADD COLUMN gid INTEGER;
UPDATE map_baeche_g4 SET gid = nextval('map_baeche_g4_gid_seq');
ALTER TABLE map_baeche_g4 ALTER COLUMN gid SET DEFAULT nextval('map_baeche_g4_gid_seq');
CREATE INDEX map_baeche_g4_gidx ON map_baeche_g4 USING GIST ( wkb_geometry );
--
--
DROP TABLE IF EXISTS map_baeche_g5;
--
SELECT (ST_Dump(ST_SimplifyPreserveTopology( wkb_geometry, 125 ))).geom AS wkb_geometry, widmung
INTO map_baeche_g5 
FROM map_baeche_g4;
--
DROP SEQUENCE IF EXISTS map_baeche_g5_gid_seq;
CREATE SEQUENCE map_baeche_g5_gid_seq;
ALTER TABLE map_baeche_g5 ADD COLUMN gid INTEGER;
UPDATE map_baeche_g5 SET gid = nextval('map_baeche_g5_gid_seq');
ALTER TABLE map_baeche_g5 ALTER COLUMN gid SET DEFAULT nextval('map_baeche_g5_gid_seq');
CREATE INDEX map_baeche_g5_gidx ON map_baeche_g5 USING GIST ( wkb_geometry );
--
--
DROP TABLE IF EXISTS map_baeche_g6;
--
SELECT (ST_Dump(ST_SimplifyPreserveTopology( wkb_geometry, 250 ))).geom AS wkb_geometry, widmung
INTO map_baeche_g6 
FROM map_baeche_g5;
--
DROP SEQUENCE IF EXISTS map_baeche_g6_gid_seq;
CREATE SEQUENCE map_baeche_g6_gid_seq;
ALTER TABLE map_baeche_g6 ADD COLUMN gid INTEGER;
UPDATE map_baeche_g6 SET gid = nextval('map_baeche_g6_gid_seq');
ALTER TABLE map_baeche_g6 ALTER COLUMN gid SET DEFAULT nextval('map_baeche_g6_gid_seq');
CREATE INDEX map_baeche_g6_gidx ON map_baeche_g6 USING GIST ( wkb_geometry );
