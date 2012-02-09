--
-- *****************************
--       A  L   K   I   S       
-- *****************************
--
-- Datenbankstruktur PostNAS 0.6  (GDAL aus aktuellem Trunc)
--
-- Stand
-- -----

--  2012-02-09 Berechnungen der Gemeinden, Fluren und Gemarkungen ueber union der entsprechenden Flurstuecke aus ax_flurstueck

--
-- Tabelle gemarkungen ueber union anlegen
-- 
Drop Table gemarkungen ;
CREATE TABLE gemarkungen AS 
SELECT
gemarkungsnummer, land, kreis,regierungsbezirk, gemeinde,st_union(st_buffer(wkb_geometry,0)) AS the_geom 
FROM ax_flurstueck GROUP BY gemarkungsnummer, land, kreis,regierungsbezirk, gemeinde;

ALTER TABLE gemarkungen ADD CONSTRAINT pk_gemarkungen PRIMARY KEY (land, kreis,regierungsbezirk, gemeinde,gemarkungsnummer);

CREATE INDEX gemarkungen_the_geom_gidx
  ON gemarkungen
  USING gist
  (the_geom);

--
-- Tabelle fluren ueber union anlegen
-- 
Drop Table fluren;
CREATE TABLE fluren AS 
SELECT
gemarkungsnummer, flurnummer, land, kreis,regierungsbezirk, gemeinde,st_union(st_buffer(wkb_geometry,0)) AS the_geom 
FROM ax_flurstueck GROUP BY gemarkungsnummer, flurnummer, land, kreis,regierungsbezirk, gemeinde;

ALTER TABLE fluren ADD CONSTRAINT pk_fluren PRIMARY KEY (gemarkungsnummer, flurnummer, land, kreis,regierungsbezirk, gemeinde);

CREATE INDEX fluren_the_geom_gidx
  ON fluren
  USING gist
  (the_geom);


--
-- Tabelle gemeinden ueber union anlegen
-- 
Drop Table gemeinden;
CREATE TABLE gemeinden AS 
SELECT 
gemeinde, land,kreis,regierungsbezirk,st_union(st_buffer(wkb_geometry,0)) AS the_geom 
FROM ax_flurstueck GROUP BY land, kreis,regierungsbezirk, gemeinde;

ALTER TABLE gemeinden ADD CONSTRAINT pk_gemeinden PRIMARY KEY (land,kreis,regierungsbezirk,gemeinde);

CREATE INDEX gemeinden_the_geom_gidx
  ON gemeinden
  USING gist
  (the_geom); 
