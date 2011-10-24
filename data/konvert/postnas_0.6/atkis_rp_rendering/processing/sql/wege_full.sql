DROP TABLE IF EXISTS map_wege_g0;
--
SELECT
(ST_Dump(ST_LineMerge(ST_Collect(ST_SimplifyPreserveTopology(ax_fahrwegachse.wkb_geometry, 2.5))))).geom AS wkb_geometry, 
NULL::text AS widmung
INTO map_wege_g0
FROM ax_fahrwegachse;
--
DROP SEQUENCE IF EXISTS map_wege_g0_gid_seq;
CREATE SEQUENCE map_wege_g0_gid_seq;
ALTER TABLE map_wege_g0 ADD COLUMN gid INTEGER;
UPDATE map_wege_g0 SET gid = nextval('map_wege_g0_gid_seq');
ALTER TABLE map_wege_g0 ALTER COLUMN gid SET DEFAULT nextval('map_wege_g0_gid_seq');
CREATE INDEX map_wege_g0_gidx ON map_wege_g0 USING GIST ( wkb_geometry );
CREATE INDEX map_wege_g0_widmung_idx ON map_wege_g0 (widmung);
--
--
DROP TABLE IF EXISTS map_wege_g1;
--

SELECT ST_SimplifyPreserveTopology(wkb_geometry, 5) AS wkb_geometry, widmung
INTO map_wege_g1
FROM map_wege_g0
WHERE ST_Length( wkb_geometry ) > 5;
--
DROP SEQUENCE IF EXISTS map_wege_g1_gid_seq;
CREATE SEQUENCE map_wege_g1_gid_seq;
ALTER TABLE map_wege_g1 ADD COLUMN gid INTEGER;
UPDATE map_wege_g1 SET gid = nextval('map_wege_g1_gid_seq');
ALTER TABLE map_wege_g1 ALTER COLUMN gid SET DEFAULT nextval('map_wege_g1_gid_seq');
CREATE INDEX map_wege_g1_gidx ON map_wege_g1 USING GIST ( wkb_geometry );
CREATE INDEX map_wege_g1_widmung_idx ON map_wege_g1 (widmung);
--
--
DROP TABLE IF EXISTS map_wege_g2;
--
SELECT ST_SimplifyPreserveTopology(wkb_geometry, 15) AS wkb_geometry, widmung
INTO map_wege_g2
FROM map_wege_g1
WHERE ST_Length( wkb_geometry ) > 15;
--
DROP SEQUENCE IF EXISTS map_wege_g2_gid_seq;
CREATE SEQUENCE map_wege_g2_gid_seq;
ALTER TABLE map_wege_g2 ADD COLUMN gid INTEGER;
UPDATE map_wege_g2 SET gid = nextval('map_wege_g2_gid_seq');
ALTER TABLE map_wege_g2 ALTER COLUMN gid SET DEFAULT nextval('map_wege_g2_gid_seq');
CREATE INDEX map_wege_g2_gidx ON map_wege_g2 USING GIST ( wkb_geometry );
CREATE INDEX map_wege_g2_widmung_idx ON map_wege_g2 (widmung);
--
--
