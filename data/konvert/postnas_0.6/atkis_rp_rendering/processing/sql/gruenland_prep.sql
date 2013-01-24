--
DROP TABLE IF EXISTS map_gruenland_g0;
DROP SEQUENCE IF EXISTS map_gruenland_g0_gid_seq;
--
SELECT (ST_Dump( ST_Union( ax_landwirtschaft.wkb_geometry ))).geom AS wkb_geometry, vegetationsmerkmal AS widmung
INTO map_gruenland_g0 
FROM ax_landwirtschaft 
WHERE vegetationsmerkmal = 1020  --
GROUP BY vegetationsmerkmal; 
--
CREATE INDEX map_gruenland_g0_gidx ON map_gruenland_g0 USING GIST ( wkb_geometry ); 
CREATE SEQUENCE map_gruenland_g0_gid_seq;
ALTER TABLE map_gruenland_g0 ADD COLUMN gid INTEGER;
UPDATE map_gruenland_g0 SET gid = nextval('map_gruenland_g0_gid_seq');
ALTER TABLE map_gruenland_g0 ALTER COLUMN gid SET DEFAULT nextval('map_gruenland_g0_gid_seq');
--
