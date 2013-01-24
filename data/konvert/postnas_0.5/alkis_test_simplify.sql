
-- Vereinfachung der Geometrie mit der PostGIS-Function ST_Simplify

-- Stand 2010-10-11

-- Kommentar siehe Datei "alkis_geom_simplify.sql"
-- Siehe Diskussion auf der Mailingliste

-- http://www.postgis.org/documentation/manual-1.3/ch06.html#id2575027

-- ST_Simplify(geometry, tolerance)

-- Returns a "simplified" version of the given geometry using the Douglas-Peuker algorithm. 
-- Will actually do something only with (multi)lines and (multi)polygons but you can safely call it with any kind of geometry.
-- Since simplification occurs on a object-by-object basis you can also feed a GeometryCollection to this function.
-- Note that returned geometry might loose its simplicity (see IsSimple)


-- geeignete Tabellen für die Optimierung:

CREATE VIEW simplify_optimierbare_tabellen
AS
 SELECT f_table_name, type 
 FROM   geometry_columns
 WHERE  not f_geometry_column = 'dummy'
   AND  type in ('LINESTRING', 'POLYGON', 'MULTIPOLYGON');  -- ,'GEOMETRY' ?


-- liefert u.a.:
--
--"ax_flurstueck"       "MULTIPOLYGON"
--"ax_wald"             "POLYGON"
--"ax_wohnbauflaeche"   "POLYGON"


-- einfacher Test der Function
CREATE VIEW flst_simple 
AS
  SELECT gml_id,
         flurstueckskennzeichen, 
         st_simplify(wkb_geometry, 0.01) AS geom_simple
  FROM   ax_flurstueck
  LIMIT  200;


-- Mengenanalyse zum Finden der passenden Toleranz
-- Je eine Spalte zaehlt die durchschnittliche Anzahl von Punkten im Geometriefeld
-- Anzezeigt wird: ursprüngliche Anzahl und Simplify mit 1mm, 1cm und 5 cm.

-- Flurstueck
CREATE VIEW analyse_simple_flst
AS
  SELECT 
    count(gml_id) AS anzahl,
    round(avg(ST_npoints(wkb_geometry)),2)                     AS punktanzahl_orig,
    round(avg(ST_npoints(st_simplify(wkb_geometry, 0.001))),2) AS punktanzahl_simply_mm,
    round(avg(ST_npoints(st_simplify(wkb_geometry, 0.01))),2)  AS punktanzahl_simply_cm,
    round(avg(ST_npoints(st_simplify(wkb_geometry, 0.05))),2)  AS punktanzahl_simply_5cm
  FROM ax_flurstueck
;

-- Nutzungsart Wald
CREATE VIEW analyse_simple_wald
AS
  SELECT 
    count(gml_id) AS anzahl,
    round(avg(ST_npoints(wkb_geometry)),2)                     AS punktanzahl_orig,
    round(avg(ST_npoints(st_simplify(wkb_geometry, 0.001))),2) AS punktanzahl_simply_mm,
    round(avg(ST_npoints(st_simplify(wkb_geometry, 0.01))),2)  AS punktanzahl_simply_cm,
    round(avg(ST_npoints(st_simplify(wkb_geometry, 0.05))),2)  AS punktanzahl_simply_5cm
  FROM ax_wald
;

-- Nutzungsart Wohnflaeche
CREATE VIEW analyse_simple_wohn
AS
  SELECT 
    count(gml_id) AS anzahl,
    round(avg(ST_npoints(wkb_geometry)),2)                     AS punktanzahl_orig,
    round(avg(ST_npoints(st_simplify(wkb_geometry, 0.001))),2) AS punktanzahl_simply_mm,
    round(avg(ST_npoints(st_simplify(wkb_geometry, 0.01))),2)  AS punktanzahl_simply_cm,
    round(avg(ST_npoints(st_simplify(wkb_geometry, 0.05))),2)  AS punktanzahl_simply_5cm
  FROM ax_wohnbauflaeche
;


--
--   Tabelle                 Anz.Punkte  1 mm    1 cm    5 cm 
--   -----------------  -------- ------  ------  ------  ------
-- Musterkarte RLP:
--   ax_flurstueck        2369    20.45   10.24    9.06    8.80
--   ax_wald                89    20.70   11.53   11.15   11.08
--   ax_wohnbauflaeche      76    28.37   12.59   11.53   10.91
-- Lage/Lippe:
--   ax_flurstueck       23589    30.55   12.60   11.57   11.08
--   ax_wald              1207    61.44   27.88   27.24   26.28
--   ax_wohnbauflaeche    2357    44.41   18.60   16.55   15.54


-- Die Mengenanalyse zeigt eine grosse Optimierung bereits im Millimeter-Bereich.


-- END --