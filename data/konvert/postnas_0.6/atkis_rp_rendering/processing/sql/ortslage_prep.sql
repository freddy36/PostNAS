-- map_wald_g0 [Echtdaten, zusammengefasst]
-- Laufzeit gesamt: 18"
-- ST_GeometryType(): ST_Polygon
-- ST_IsSimple(): WAHR
-- ST_IsEmpty(): FALSE
-- ST_IsValid(): WAHR
-- COUNT(*): 3956 
-- SUM(ST_NPoints()): 612574
DROP TABLE IF EXISTS map_ortslage_g0;
DROP SEQUENCE IF EXISTS map_ortslage_g0_gid_seq;
--
SELECT (ST_Dump( ST_Union( wkb_geometry ))).geom AS wkb_geometry, name_ AS widmung
INTO map_ortslage_g0 
FROM ax_ortslage
GROUP BY name_;
--
CREATE INDEX map_ortslage_g0_gidx ON map_ortslage_g0 USING GIST ( wkb_geometry ); 
CREATE SEQUENCE map_ortslage_g0_gid_seq;
ALTER TABLE map_ortslage_g0 ADD COLUMN gid INTEGER;
UPDATE map_ortslage_g0 SET gid = nextval('map_ortslage_g0_gid_seq');
ALTER TABLE map_ortslage_g0 ALTER COLUMN gid SET DEFAULT nextval('map_ortslage_g0_gid_seq');
--


