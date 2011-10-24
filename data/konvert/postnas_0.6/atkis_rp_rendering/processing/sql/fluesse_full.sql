DROP TABLE IF EXISTS map_fluesse_g0;
--

SELECT (ST_Dump(ST_Union(ax_fliessgewaesser.wkb_geometry))).geom AS wkb_geometry, ax_wasserlauf.name_ AS widmung
INTO map_fluesse_g0
FROM ax_wasserlauf 
INNER JOIN alkis_beziehungen 
	ON (alkis_beziehungen.beziehung_zu = ax_wasserlauf.gml_id) 
INNER JOIN ax_fliessgewaesser 
	ON (ax_fliessgewaesser.gml_id=alkis_beziehungen.beziehung_von)
GROUP BY name_
/*
--
UNION ALL 
--
SELECT wkb_geometry AS wkb_geometry, NULL AS name_
FROM ax_gewaesserachse
*/
;
--
DROP SEQUENCE IF EXISTS map_fluesse_g0_gid_seq;
CREATE SEQUENCE map_fluesse_g0_gid_seq;
ALTER TABLE map_fluesse_g0 ADD COLUMN gid INTEGER;
UPDATE map_fluesse_g0 SET gid = nextval('map_fluesse_g0_gid_seq');
ALTER TABLE map_fluesse_g0 ALTER COLUMN gid SET DEFAULT nextval('map_fluesse_g0_gid_seq');
CREATE INDEX map_fluesse_g0_gidx ON map_fluesse_g0 USING GIST ( wkb_geometry );
--
--
DROP TABLE IF EXISTS map_fluesse_g1;
--
SELECT (ST_Dump(ST_Buffer(ST_SimplifyPreserveTopology(ST_Buffer(wkb_geometry, 4), 8),-4))).geom AS wkb_geometry, widmung 
INTO map_fluesse_g1 FROM map_fluesse_g0;
--
DROP SEQUENCE IF EXISTS map_fluesse_g1_gid_seq;
CREATE SEQUENCE map_fluesse_g1_gid_seq;
ALTER TABLE map_fluesse_g1 ADD COLUMN gid INTEGER;
UPDATE map_fluesse_g1 SET gid = nextval('map_fluesse_g1_gid_seq');
ALTER TABLE map_fluesse_g1 ALTER COLUMN gid SET DEFAULT nextval('map_fluesse_g1_gid_seq');
CREATE INDEX map_fluesse_g1_gidx ON map_fluesse_g1 USING GIST ( wkb_geometry );
--
--
DROP TABLE IF EXISTS map_fluesse_g2;
--
SELECT (ST_Dump(ST_SimplifyPreserveTopology(ST_Buffer(ST_Buffer(wkb_geometry, 8), -8),30))).geom AS wkb_geometry, widmung INTO map_fluesse_g2 FROM map_fluesse_g1;
--
DROP SEQUENCE IF EXISTS map_fluesse_g2_gid_seq;
CREATE SEQUENCE map_fluesse_g2_gid_seq;
ALTER TABLE map_fluesse_g2 ADD COLUMN gid INTEGER;
UPDATE map_fluesse_g2 SET gid = nextval('map_fluesse_g2_gid_seq');
ALTER TABLE map_fluesse_g2 ALTER COLUMN gid SET DEFAULT nextval('map_fluesse_g2_gid_seq');
CREATE INDEX map_fluesse_g2_gidx ON map_fluesse_g2 USING GIST ( wkb_geometry );
--
--
--
DROP TABLE IF EXISTS map_fluesse_g3;
--
SELECT wkb_geometry, widmung INTO map_fluesse_g3 FROM map_fluesse_g2;
--
DROP SEQUENCE IF EXISTS map_fluesse_g3_gid_seq;
CREATE SEQUENCE map_fluesse_g3_gid_seq;
ALTER TABLE map_fluesse_g3 ADD COLUMN gid INTEGER;
UPDATE map_fluesse_g3 SET gid = nextval('map_fluesse_g3_gid_seq');
ALTER TABLE map_fluesse_g3 ALTER COLUMN gid SET DEFAULT nextval('map_fluesse_g3_gid_seq');
CREATE INDEX map_fluesse_g3_gidx ON map_fluesse_g3 USING GIST ( wkb_geometry );
--
--
DROP TABLE IF EXISTS map_fluesse_g4;
--
SELECT wkb_geometry, widmung INTO map_fluesse_g4 FROM map_fluesse_g3;
--
DROP SEQUENCE IF EXISTS map_fluesse_g4_gid_seq;
CREATE SEQUENCE map_fluesse_g4_gid_seq;
ALTER TABLE map_fluesse_g4 ADD COLUMN gid INTEGER;
UPDATE map_fluesse_g4 SET gid = nextval('map_fluesse_g4_gid_seq');
ALTER TABLE map_fluesse_g4 ALTER COLUMN gid SET DEFAULT nextval('map_fluesse_g4_gid_seq');
CREATE INDEX map_fluesse_g4_gidx ON map_fluesse_g4 USING GIST ( wkb_geometry );
--
--
DROP TABLE IF EXISTS map_fluesse_g5;
--
SELECT wkb_geometry, widmung INTO map_fluesse_g5 FROM map_fluesse_g4;
--
DROP SEQUENCE IF EXISTS map_fluesse_g5_gid_seq;
CREATE SEQUENCE map_fluesse_g5_gid_seq;
ALTER TABLE map_fluesse_g5 ADD COLUMN gid INTEGER;
UPDATE map_fluesse_g5 SET gid = nextval('map_fluesse_g5_gid_seq');
ALTER TABLE map_fluesse_g5 ALTER COLUMN gid SET DEFAULT nextval('map_fluesse_g5_gid_seq');
CREATE INDEX map_fluesse_g5_gidx ON map_fluesse_g5 USING GIST ( wkb_geometry );
--
--
DROP TABLE IF EXISTS map_fluesse_g6;
--
SELECT wkb_geometry, widmung INTO map_fluesse_g6 FROM map_fluesse_g5;
--
DROP SEQUENCE IF EXISTS map_fluesse_g6_gid_seq;
CREATE SEQUENCE map_fluesse_g6_gid_seq;
ALTER TABLE map_fluesse_g6 ADD COLUMN gid INTEGER;
UPDATE map_fluesse_g6 SET gid = nextval('map_fluesse_g6_gid_seq');
ALTER TABLE map_fluesse_g6 ALTER COLUMN gid SET DEFAULT nextval('map_fluesse_g6_gid_seq');
CREATE INDEX map_fluesse_g6_gidx ON map_fluesse_g6 USING GIST ( wkb_geometry );




