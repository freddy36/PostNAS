DROP TABLE IF EXISTS map_stehendesgewaesser_g0;
DROP SEQUENCE IF EXISTS map_stehendesgewaesser_g0_gid_seq;
--

SELECT 
wkb_geometry,
widmung
INTO map_stehendesgewaesser_g0 

FROM (
	SELECT (ST_Dump( ST_Union( ax_stehendesgewaesser.wkb_geometry ))).geom AS wkb_geometry, unverschluesselt as widmung 
	FROM ax_stehendesgewaesser GROUP BY widmung 
) AS wrapper; 
--
CREATE INDEX map_stehendesgewaesser_g0_gidx ON map_stehendesgewaesser_g0 USING GIST ( wkb_geometry ); 
CREATE SEQUENCE map_stehendesgewaesser_g0_gid_seq;
ALTER TABLE map_stehendesgewaesser_g0 ADD COLUMN gid INTEGER;
UPDATE map_stehendesgewaesser_g0 SET gid = nextval('map_stehendesgewaesser_g0_gid_seq');
ALTER TABLE map_stehendesgewaesser_g0 ALTER COLUMN gid SET DEFAULT nextval('map_stehendesgewaesser_g0_gid_seq');
----
