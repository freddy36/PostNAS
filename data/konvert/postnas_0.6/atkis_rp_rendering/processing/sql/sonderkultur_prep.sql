--
DROP TABLE IF EXISTS map_sonderkultur_g0;
DROP SEQUENCE IF EXISTS map_sonderkultur_g0_gid_seq;
--
SELECT (ST_Dump( ST_Union( ax_landwirtschaft.wkb_geometry ))).geom AS wkb_geometry, vegetationsmerkmal AS widmung
INTO map_sonderkultur_g0 
FROM ax_landwirtschaft 
WHERE vegetationsmerkmal in ( 
   1012, -- Hopfen; ohne Signatur - nur Flächenfärbung
   1031,  -- Baumschule; ohne Signatur - dito
   1040, -- Weingarten; signaturiert
   1050  -- Obstplantage; signaturiert
) -- 
GROUP BY vegetationsmerkmal; 
--
CREATE INDEX map_sonderkultur_g0_gidx ON map_sonderkultur_g0 USING GIST ( wkb_geometry ); 
CREATE SEQUENCE map_sonderkultur_g0_gid_seq;
ALTER TABLE map_sonderkultur_g0 ADD COLUMN gid INTEGER;
UPDATE map_sonderkultur_g0 SET gid = nextval('map_sonderkultur_g0_gid_seq');
ALTER TABLE map_sonderkultur_g0 ALTER COLUMN gid SET DEFAULT nextval('map_sonderkultur_g0_gid_seq');
--
