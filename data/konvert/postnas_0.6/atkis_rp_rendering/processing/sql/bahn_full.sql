DROP TABLE IF EXISTS map_bahn_g0;
--
SELECT
(ST_Dump(ST_LineMerge(ST_Collect(ST_SimplifyPreserveTopology(ax_bahnstrecke.wkb_geometry, 2.5))))).geom AS wkb_geometry, NULL::text AS widmung
INTO map_bahn_g0
FROM ax_bahnstrecke;
--
DROP SEQUENCE IF EXISTS map_bahn_g0_gid_seq;
CREATE SEQUENCE map_bahn_g0_gid_seq;
ALTER TABLE map_bahn_g0 ADD COLUMN gid INTEGER;
UPDATE map_bahn_g0 SET gid = nextval('map_bahn_g0_gid_seq');
ALTER TABLE map_bahn_g0 ALTER COLUMN gid SET DEFAULT nextval('map_bahn_g0_gid_seq');
CREATE INDEX map_bahn_g0_gidx ON map_bahn_g0 USING GIST ( wkb_geometry );
CREATE INDEX map_bahn_g0_widmung_idx ON map_bahn_g0 (widmung);
--
--
DROP TABLE IF EXISTS map_bahn_g1;
--

SELECT ST_SimplifyPreserveTopology(wkb_geometry, 5) AS wkb_geometry, widmung
INTO map_bahn_g1
FROM map_bahn_g0
WHERE ST_Length( wkb_geometry ) > 45;
--
DROP SEQUENCE IF EXISTS map_bahn_g1_gid_seq;
CREATE SEQUENCE map_bahn_g1_gid_seq;
ALTER TABLE map_bahn_g1 ADD COLUMN gid INTEGER;
UPDATE map_bahn_g1 SET gid = nextval('map_bahn_g1_gid_seq');
ALTER TABLE map_bahn_g1 ALTER COLUMN gid SET DEFAULT nextval('map_bahn_g1_gid_seq');
CREATE INDEX map_bahn_g1_gidx ON map_bahn_g1 USING GIST ( wkb_geometry );
CREATE INDEX map_bahn_g1_widmung_idx ON map_bahn_g1 (widmung);
--
--
DROP TABLE IF EXISTS map_bahn_g2;
--
SELECT ST_SimplifyPreserveTopology(wkb_geometry, 25) AS wkb_geometry, widmung
INTO map_bahn_g2
FROM map_bahn_g1
WHERE ST_Length( wkb_geometry ) > 90;
--
DROP SEQUENCE IF EXISTS map_bahn_g2_gid_seq;
CREATE SEQUENCE map_bahn_g2_gid_seq;
ALTER TABLE map_bahn_g2 ADD COLUMN gid INTEGER;
UPDATE map_bahn_g2 SET gid = nextval('map_bahn_g2_gid_seq');
ALTER TABLE map_bahn_g2 ALTER COLUMN gid SET DEFAULT nextval('map_bahn_g2_gid_seq');
CREATE INDEX map_bahn_g2_gidx ON map_bahn_g2 USING GIST ( wkb_geometry );
CREATE INDEX map_bahn_g2_widmung_idx ON map_bahn_g2 (widmung);
--
--
DROP TABLE IF EXISTS map_bahn_g3;
--
SELECT ST_SimplifyPreserveTopology(wkb_geometry, 50) AS wkb_geometry, widmung
INTO map_bahn_g3
FROM map_bahn_g2
WHERE ST_Length( wkb_geometry ) > 90;
--
DROP SEQUENCE IF EXISTS map_bahn_g3_gid_seq;
CREATE SEQUENCE map_bahn_g3_gid_seq;
ALTER TABLE map_bahn_g3 ADD COLUMN gid INTEGER;
UPDATE map_bahn_g3 SET gid = nextval('map_bahn_g3_gid_seq');
ALTER TABLE map_bahn_g3 ALTER COLUMN gid SET DEFAULT nextval('map_bahn_g3_gid_seq');
CREATE INDEX map_bahn_g3_gidx ON map_bahn_g3 USING GIST ( wkb_geometry );
CREATE INDEX map_bahn_g3_widmung_idx ON map_bahn_g3 (widmung);
--
--
DROP TABLE IF EXISTS map_bahn_g4;
--
SELECT ST_SimplifyPreserveTopology(wkb_geometry, 150) AS wkb_geometry, widmung
INTO map_bahn_g4
FROM map_bahn_g3
WHERE ST_Length( wkb_geometry ) > 90;
--
DROP SEQUENCE IF EXISTS map_bahn_g4_gid_seq;
CREATE SEQUENCE map_bahn_g4_gid_seq;
ALTER TABLE map_bahn_g4 ADD COLUMN gid INTEGER;
UPDATE map_bahn_g4 SET gid = nextval('map_bahn_g4_gid_seq');
ALTER TABLE map_bahn_g4 ALTER COLUMN gid SET DEFAULT nextval('map_bahn_g4_gid_seq');
CREATE INDEX map_bahn_g4_gidx ON map_bahn_g4 USING GIST ( wkb_geometry );
CREATE INDEX map_bahn_g4_widmung_idx ON map_bahn_g4 (widmung);
