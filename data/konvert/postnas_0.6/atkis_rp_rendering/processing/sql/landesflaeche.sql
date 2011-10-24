-----------------------------------------
-----------------------------------------
--  Landesfläche [Umriss, gefüllt]
--  alles in einer Tabelle 
--  (keine Attributierungen)
--  t gesamt: 30s
-----------------------------------------
-----------------------------------------
--
-- Erstellen eines Polygons der Landesfläche RLP
DROP TABLE IF EXISTS map_landesflaeche;
--
SELECT ST_BuildArea(ST_ExteriorRing(ST_Union( wkb_geometry ))) AS wkb_geometry
INTO map_landesflaeche
FROM ax_kommunalesgebiet;
--
CREATE INDEX map_landesflaeche_gidx ON map_landesflaeche USING GIST ( wkb_geometry );
--
DROP SEQUENCE IF EXISTS map_landesflaeche_gid_seq;
CREATE SEQUENCE map_landesflaeche_gid_seq;
ALTER TABLE map_landesflaeche ADD COLUMN gid INTEGER;
UPDATE map_landesflaeche SET gid = nextval('map_landesflaeche_gid_seq');
ALTER TABLE map_landesflaeche ALTER COLUMN gid SET DEFAULT nextval('map_landesflaeche_gid_seq');
--
--
/*
-- GRID - MUSS NICHT JEDES MAL ERSTELLT WERDEN!
-- DROP-Statement wird auch nochmal in Funktion selbst aufgerufen
-- DROP TABLE IF EXISTS map_rlp_kachel_2km, map_rlp_kachel_5km, map_rlp_kachel_10km, map_rlp_kachel_25km, map_rlp_kachel_50km; 

SELECT grid( 'map_rlp_kachel_2km', wkb_geometry, 2000)
FROM temp0;
--
SELECT grid( 'map_rlp_kachel_5km', wkb_geometry, 5000)
FROM temp0;
--
SELECT grid( 'map_rlp_kachel_10km', wkb_geometry, 10000)
FROM temp0;
--
SELECT grid( 'map_rlp_kachel_25km', wkb_geometry, 25000)
FROM temp0;
--
SELECT grid( 'map_rlp_kachel_50km', wkb_geometry, 50000)
FROM temp0;
*/
--
--
-------------------------------------------
-- Clipping des GRID auf Landesgrenzen 
-- ergibt gekachelte Fläche Rheinland-Pfalz
-- = Grundlage weiterer räumlicher Verschneidungen
-- + performante Darstellung der Landesfläche selbst
--
-- 2km Kachelung [g0] 2km
DROP TABLE IF EXISTS map_landesflaeche_g0;
--
SELECT (ST_Dump(ST_Intersection( t.wkb_geometry, g.wkb_geometry ))).geom AS wkb_geometry
INTO map_landesflaeche_g0
FROM  map_landesflaeche t
LEFT JOIN map_rlp_kachel_2km g
ON ST_Intersects( t.wkb_geometry, g.wkb_geometry );
--
CREATE INDEX map_landesflaeche_g0_gidx ON map_landesflaeche_g0 USING GIST ( wkb_geometry );
--
DROP SEQUENCE IF EXISTS map_landesflaeche_g0_gid_seq;
CREATE SEQUENCE map_landesflaeche_g0_gid_seq;
ALTER TABLE map_landesflaeche_g0 ADD COLUMN gid INTEGER;
UPDATE map_landesflaeche_g0 SET gid = nextval('map_landesflaeche_g0_gid_seq');
ALTER TABLE map_landesflaeche_g0 ALTER COLUMN gid SET DEFAULT nextval('map_landesflaeche_g0_gid_seq');
-- 423s für RLP
--
--
-- 5km Kachelung [g1] 5km
DROP TABLE IF EXISTS map_landesflaeche_g1;
--
SELECT (ST_Dump(ST_Intersection( t.wkb_geometry, g.wkb_geometry ))).geom AS wkb_geometry
INTO map_landesflaeche_g1
FROM  map_landesflaeche t
LEFT JOIN map_rlp_kachel_5km g
ON ST_Intersects( t.wkb_geometry, g.wkb_geometry );
--
CREATE INDEX map_landesflaeche_g1_gidx ON map_landesflaeche_g1 USING GIST ( wkb_geometry );
--
DROP SEQUENCE IF EXISTS map_landesflaeche_g1_gid_seq;
CREATE SEQUENCE map_landesflaeche_g1_gid_seq;
ALTER TABLE map_landesflaeche_g1 ADD COLUMN gid INTEGER;
UPDATE map_landesflaeche_g1 SET gid = nextval('map_landesflaeche_g1_gid_seq');
ALTER TABLE map_landesflaeche_g1 ALTER COLUMN gid SET DEFAULT nextval('map_landesflaeche_g1_gid_seq');
-- 67s für RLP
--
--
-- 10km Kachelung [g2] 10km
DROP TABLE IF EXISTS map_landesflaeche_g2;
--
SELECT (ST_Dump(ST_Intersection( t.wkb_geometry, g.wkb_geometry ))).geom AS wkb_geometry
INTO map_landesflaeche_g2
FROM  map_landesflaeche t
LEFT JOIN map_rlp_kachel_10km g
ON ST_Intersects( t.wkb_geometry, g.wkb_geometry );
--
CREATE INDEX map_landesflaeche_g2_gidx ON map_landesflaeche_g2 USING GIST ( wkb_geometry );
--
DROP SEQUENCE IF EXISTS map_landesflaeche_g2_gid_seq;
CREATE SEQUENCE map_landesflaeche_g2_gid_seq;
ALTER TABLE map_landesflaeche_g2 ADD COLUMN gid INTEGER;
UPDATE map_landesflaeche_g2 SET gid = nextval('map_landesflaeche_g2_gid_seq');
ALTER TABLE map_landesflaeche_g2 ALTER COLUMN gid SET DEFAULT nextval('map_landesflaeche_g2_gid_seq');
-- 17s für RLP
--
--
-- 25km Kachelung [g3] 25km
DROP TABLE IF EXISTS map_landesflaeche_g3;
--
SELECT (ST_Dump(ST_Intersection( t.wkb_geometry, g.wkb_geometry ))).geom AS wkb_geometry
INTO map_landesflaeche_g3
FROM  map_landesflaeche t
LEFT JOIN map_rlp_kachel_25km g
ON ST_Intersects( t.wkb_geometry, g.wkb_geometry );
--
CREATE INDEX map_landesflaeche_g3_gidx ON map_landesflaeche_g3 USING GIST ( wkb_geometry );
--
DROP SEQUENCE IF EXISTS map_landesflaeche_g3_gid_seq;
CREATE SEQUENCE map_landesflaeche_g3_gid_seq;
ALTER TABLE map_landesflaeche_g3 ADD COLUMN gid INTEGER;
UPDATE map_landesflaeche_g3 SET gid = nextval('map_landesflaeche_g3_gid_seq');
ALTER TABLE map_landesflaeche_g3 ALTER COLUMN gid SET DEFAULT nextval('map_landesflaeche_g3_gid_seq');
-- 3s für RLP
--
--
-- 50km Kachelung [g4] 50km
DROP TABLE IF EXISTS map_landesflaeche_g4;
--
SELECT (ST_Dump(ST_Intersection( t.wkb_geometry, g.wkb_geometry ))).geom AS wkb_geometry
INTO map_landesflaeche_g4
FROM  map_landesflaeche t
LEFT JOIN map_rlp_kachel_50km g
ON ST_Intersects( t.wkb_geometry, g.wkb_geometry );
--
CREATE INDEX map_landesflaeche_g4_gidx ON map_landesflaeche_g4 USING GIST ( wkb_geometry );
--
DROP SEQUENCE IF EXISTS map_landesflaeche_g4_gid_seq;
CREATE SEQUENCE map_landesflaeche_g4_gid_seq;
ALTER TABLE map_landesflaeche_g4 ADD COLUMN gid INTEGER;
UPDATE map_landesflaeche_g4 SET gid = nextval('map_landesflaeche_g4_gid_seq');
ALTER TABLE map_landesflaeche_g4 ALTER COLUMN gid SET DEFAULT nextval('map_landesflaeche_g4_gid_seq');
-- 1s für RLP 
--

