-- map_wald_g0 [Echtdaten, zusammengefasst nach Vegetationsmerkmal]
-- Laufzeit gesamt: 364"
-- ST_GeometryType(): ST_Polygon
-- ST_IsSimple(): WAHR
-- ST_IsEmpty(): FALSE
-- ST_IsValid(): WAHR
-- COUNT(*): 55019
-- SUM(ST_NPoints()): 4058371
DROP TABLE IF EXISTS map_wald_g0;
DROP SEQUENCE IF EXISTS map_wald_g0_gid_seq;
--
SELECT (ST_Dump( ST_Union( ax_wald.wkb_geometry ))).geom AS wkb_geometry, vegetationsmerkmal AS widmung
INTO map_wald_g0 
FROM ax_wald 
GROUP BY vegetationsmerkmal; 
--
CREATE INDEX map_wald_g0_gidx ON map_wald_g0 USING GIST ( wkb_geometry ); 
CREATE SEQUENCE map_wald_g0_gid_seq;
ALTER TABLE map_wald_g0 ADD COLUMN gid INTEGER;
UPDATE map_wald_g0 SET gid = nextval('map_wald_g0_gid_seq');
ALTER TABLE map_wald_g0 ALTER COLUMN gid SET DEFAULT nextval('map_wald_g0_gid_seq');
--
--
DROP TABLE IF EXISTS map_wald_g1;
DROP SEQUENCE IF EXISTS map_wald_g1_gid_seq;
--
-- map_wald_g1 [Echtdaten, keine Differenzierung mehr nach Vegetationsart]
-- Laufzeit gesamt: 563"
-- ST_GeometryType(): ST_Polygon
-- ST_IsSimple(): WAHR
-- ST_IsEmpty(): FALSCH
-- ST_IsValid(): WAHR
-- COUNT(*): 19164
-- SUM(ST_NPoints()): 1958223
SELECT (ST_Dump(ST_Union( wkb_geometry ))).geom AS wkb_geometry, NULL::text AS widmung 
INTO map_wald_g1 
FROM map_wald_g0;
-- Index und Sequenz
CREATE INDEX map_wald_g1_gidx ON map_wald_g1 USING GIST ( wkb_geometry ); 
CREATE SEQUENCE map_wald_g1_gid_seq;
ALTER TABLE map_wald_g1 ADD COLUMN gid INTEGER;
UPDATE map_wald_g1 SET gid = nextval('map_wald_g1_gid_seq');
ALTER TABLE map_wald_g1 ALTER COLUMN gid SET DEFAULT nextval('map_wald_g1_gid_seq');
