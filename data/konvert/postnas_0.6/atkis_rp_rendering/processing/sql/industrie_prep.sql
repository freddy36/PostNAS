DROP TABLE IF EXISTS map_industrie_g0;
DROP SEQUENCE IF EXISTS map_industrie_g0_gid_seq;
--
SELECT (ST_Dump( ST_Union( ax_industrieundgewerbeflaeche.wkb_geometry ))).geom AS wkb_geometry, funktion AS widmung
INTO map_industrie_g0 
FROM ax_industrieundgewerbeflaeche 
--WHERE (funktion IS NULL OR funktion in (..??..))
GROUP BY funktion; 
--
CREATE INDEX map_industrie_g0_gidx ON map_industrie_g0 USING GIST ( wkb_geometry ); 
CREATE SEQUENCE map_industrie_g0_gid_seq;
ALTER TABLE map_industrie_g0 ADD COLUMN gid INTEGER;
UPDATE map_industrie_g0 SET gid = nextval('map_industrie_g0_gid_seq');
ALTER TABLE map_industrie_g0 ALTER COLUMN gid SET DEFAULT nextval('map_industrie_g0_gid_seq');
----