-- Automatisch mit pg-to-oci_keytables.pl konvertiert.
---
---

CREATE OR REPLACE VIEW S_FLURSTUECK_NR
AS 
 SELECT f.OGR_FID, 
        p.ORA_GEOMETRY,
        f.zaehler || COALESCE ('/' || f.nenner, '') AS FSNUM
   FROM ap_pto             p
   JOIN alkis_beziehungen  v  ON p.GML_ID       = v.beziehung_von
   JOIN ax_flurstueck      f  ON v.beziehung_zu = f.GML_ID
  WHERE v.beziehungsart = 'dientZurDarstellungVon' 
    AND p.endet IS NULL
    AND f.endet IS NULL
  ;
-- COMMENT ON VIEW S_FLURSTUECK_NR IS 'fuer Kartendarstellung: Bruchnummerierung Flurstück';

-- ToDo: UNION ueber ORA_GEOMETRY  noch fehlerhaft, derzeit auskommentiert
CREATE OR REPLACE VIEW S_FLURSTUECK_NR2
AS 
  SELECT f.OGR_FID, 
         --p.ORA_GEOMETRY AS wkb_geometry,
         f.zaehler || COALESCE ('/' || f.nenner, '') AS FSNUM
    FROM ap_pto             p
    JOIN alkis_beziehungen  v  ON p.GML_ID       = v.beziehung_von
    JOIN ax_flurstueck      f  ON v.beziehung_zu = f.GML_ID
   WHERE v.beziehungsart = 'dientZurDarstellungVon' 
     AND p.endet IS NULL
     AND f.endet IS NULL
 UNION 
  SELECT f.OGR_FID,
         --SDO_GEOM.SDO_CENTROID(f.ORA_GEOMETRY,2) AS wkb_geometry,
         f.zaehler || COALESCE ('/' || f.nenner, '') AS FSNUM
    FROM      ax_flurstueck     f 
    LEFT JOIN alkis_beziehungen v  ON v.beziehung_zu = f.GML_ID
   WHERE v.beziehungsart is NULL
     AND f.endet IS NULL
  ;
-- COMMENT ON VIEW S_FLURSTUECK_NR2 IS 'Bruchnummerierung Flurstück, auch Standard-Position. Nicht direkt fuer WMS verwenden';

CREATE OR REPLACE VIEW S_HAUSNUMMER_GEBAEUDE 
AS 
 SELECT p.OGR_FID, 
        p.ORA_GEOMETRY,
        p.DREHWINKEL * 57.296 AS DREHWINKEL,
        l.hausnummer
   FROM ap_pto p
   JOIN alkis_beziehungen v
     ON p.GML_ID = v.beziehung_von
   JOIN AX_LAGEBEZEICHNUNGMITHAUSNUMME l
     ON v.beziehung_zu  = l.GML_ID
  WHERE v.beziehungsart = 'dientZurDarstellungVon'
    AND p.endet IS NULL
    AND l.endet IS NULL;
-- COMMENT ON VIEW S_HAUSNUMMER_GEBAEUDE IS 'fuer Kartendarstellung: Hausnummern Hauptgebäude';

CREATE OR REPLACE VIEW S_NUMMER_NEBENGEBAEUDE 
AS 
 SELECT p.OGR_FID, 
        p.ORA_GEOMETRY, 
        p.DREHWINKEL * 57.296 AS DREHWINKEL,
        l.laufendenummer
   FROM ap_pto p
   JOIN alkis_beziehungen v 
     ON p.GML_ID = v.beziehung_von
   JOIN AX_LAGEBEZEICHNUNGMITPSEUDONUM l
     ON v.beziehung_zu  = l.GML_ID
  WHERE v.beziehungsart = 'dientZurDarstellungVon'
    AND p.endet IS NULL
    AND l.endet IS NULL
;
-- COMMENT ON VIEW S_NUMMER_NEBENGEBAEUDE IS 'fuer Kartendarstellung: Hausnummern Nebengebäude';

CREATE OR REPLACE VIEW S_ZUGEHOERIGKEITSHAKEN_FLURSTU 
AS 
 SELECT p.OGR_FID, 
        p.ORA_GEOMETRY, 
        p.DREHWINKEL * 57.296 AS DREHWINKEL,
        f.flurstueckskennzeichen
   FROM ap_ppo p
   JOIN alkis_beziehungen v
     ON p.GML_ID = v.beziehung_von
   JOIN ax_flurstueck f
     ON v.beziehung_zu = f.GML_ID
  WHERE p.art = 'Haken'
    AND v.beziehungsart = 'dientZurDarstellungVon'
    AND f.endet IS NULL
    AND p.endet IS NULL;
-- COMMENT ON VIEW S_ZUGEHOERIGKEITSHAKEN_FLURSTU IS 'fuer Kartendarstellung';

CREATE OR REPLACE VIEW S_ZUORDUNGSPFEIL_FLURSTUECK 
AS 
 SELECT l.OGR_FID, 
        l.ORA_GEOMETRY
   FROM ap_lpo l
   JOIN alkis_beziehungen v
     ON l.GML_ID = v.beziehung_von
   JOIN ax_flurstueck f
     ON v.beziehung_zu = f.GML_ID
  WHERE l.art = 'Pfeil'
    AND v.beziehungsart = 'dientZurDarstellungVon'
    -- AND ('DKKM1000' ~~ ANY (l.advstandardmodell))
    AND instr(l.advstandardmodell,'DKKM1000') > 0
    AND f.endet IS NULL
    AND l.endet IS NULL;
-- COMMENT ON VIEW S_ZUORDUNGSPFEIL_FLURSTUECK IS 'fuer Kartendarstellung: Zuordnungspfeil Flurstücksnummer';

-- ToDo Berechnung Pfeilspitze
CREATE OR REPLACE VIEW S_ZUORDUNGSPFEILSPITZE_FLURSTU 
AS 
 SELECT l.OGR_FID--, 
        --(((st_azimuth(st_pointn(l.ORA_GEOMETRY, 1), 
        --st_pointn(l.ORA_GEOMETRY, 2)) * (- (180)::double precision)) / pi()) + (90)::double precision) AS WINKEL, 
        --st_startpoint(l.ORA_GEOMETRY) AS wkb_geometry 
   FROM ap_lpo l
   JOIN alkis_beziehungen v
     ON l.GML_ID = v.beziehung_von
   JOIN ax_flurstueck f
     ON v.beziehung_zu = f.GML_ID
  WHERE l.art = 'Pfeil'
    AND v.beziehungsart = 'dientZurDarstellungVon'
    -- AND ('DKKM1000' ~~ ANY (l.advstandardmodell))
    AND instr(l.advstandardmodell,'DKKM1000') > 0
    AND f.endet IS NULL
    AND l.endet IS NULL;
-- COMMENT ON VIEW S_ZUORDUNGSPFEILSPITZE_FLURSTU IS 'fuer Kartendarstellung: Zuordnungspfeil Flurstücksnummer, Spitze';

CREATE OR REPLACE VIEW S_BESCHRIFTUNG 
AS 
  SELECT p.OGR_FID, 
         p.schriftinhalt, 
         p.art, 
         p.DREHWINKEL * 57.296 AS WINKEL,
         p.ORA_GEOMETRY 
    FROM ap_pto p
   WHERE not p.schriftinhalt IS NULL 
     AND p.endet IS NULL
     AND p.art NOT IN ('HNR', 'PNR');
-- COMMENT ON VIEW S_BESCHRIFTUNG IS 'ap_pto, die noch nicht in anderen Layern angezeigt werden';

CREATE OR REPLACE VIEW S_ZUORDUNGSPFEIL_GEBAEUDE 
AS 
 SELECT l.OGR_FID, 
        l.ORA_GEOMETRY
   FROM ap_lpo l
   JOIN alkis_beziehungen v
     ON l.GML_ID = v.beziehung_von
   JOIN ax_gebaeude g
     ON v.beziehung_zu = g.GML_ID
  WHERE l.art = 'Pfeil'
    AND v.beziehungsart = 'dientZurDarstellungVon'
    AND g.endet IS NULL
    AND l.endet IS NULL;
-- COMMENT ON VIEW S_ZUORDUNGSPFEIL_GEBAEUDE IS 'fuer Kartendarstellung: Zuordnungspfeil für Gebäude-Nummer';

CREATE OR REPLACE VIEW SK2004_ZUORDNUNGSPFEIL 
AS
 SELECT ap.OGR_FID, ap.ORA_GEOMETRY 
 FROM ap_lpo ap 
 WHERE ((ap.signaturnummer = '2004') 
   -- AND ('DKKM1000' ~~ ANY ((ap.advstandardmodell)[])));
   AND (instr(ap.advstandardmodell,'DKKM1000') > 0));
-- COMMENT ON VIEW SK2004_ZUORDNUNGSPFEIL IS 'fuer Kartendarstellung: Zuordnungspfeil Flurstücksnummer"';


-- ToDo Berechnung SK2004_ZUORDNUNGSPFEIL_SPITZE
CREATE OR REPLACE VIEW SK2004_ZUORDNUNGSPFEIL_SPITZE 
AS
 SELECT ap.OGR_FID--, (((st_azimuth(st_pointn(ap.ORA_GEOMETRY, 1), 
        --st_pointn(ap.ORA_GEOMETRY, 2)) * (- (180)::double precision)) / pi()) + (90)::double precision) AS WINKEL, 
        --st_startpoint(ap.ORA_GEOMETRY) AS wkb_geometry 
 FROM ap_lpo ap 
 WHERE ((ap.signaturnummer = '2004') 
   --AND ('DKKM1000' ~~ ANY ((ap.advstandardmodell)[])));
   AND (instr(ap.advstandardmodell,'DKKM1000') > 0));


CREATE OR REPLACE VIEW SK2012_FLURGRENZE 
AS 
 SELECT fg.OGR_FID, fg.ORA_GEOMETRY
   FROM ax_besondereflurstuecksgrenze fg
  WHERE (
    --3000 = ANY (fg.artderflurstuecksgrenze)) 
    (instr(fg.artderflurstuecksgrenze,'3000') > 0)
    --AND fg.advstandardmodell ~~ 'DLKM';
    AND (instr(fg.advstandardmodell,'DLKM') > 0));
-- COMMENT ON VIEW SK2012_FLURGRENZE IS 'fuer Kartendarstellung: besondere Flurstücksgrenze "Flurgrenze"';

CREATE OR REPLACE VIEW SK2014_GEMARKUNGSGRENZE 
AS 
 SELECT gemag.OGR_FID, gemag.ORA_GEOMETRY
   FROM ax_besondereflurstuecksgrenze gemag
  WHERE (
    --7003 = ANY (gemag.artderflurstuecksgrenze)) 
    (instr(gemag.artderflurstuecksgrenze,'7003') > 0)
    --AND gemag.advstandardmodell ~~ 'DLKM';
    AND (instr(gemag.advstandardmodell,'DLKM') > 0));
-- COMMENT ON VIEW SK2014_GEMARKUNGSGRENZE IS 'fuer Kartendarstellung: besondere Flurstücksgrenze "Gemarkungsgrenze"';

CREATE OR REPLACE VIEW SK2018_BUNDESLANDGRENZE 
AS 
 SELECT blg.OGR_FID, blg.ORA_GEOMETRY
   FROM ax_besondereflurstuecksgrenze blg
  WHERE (
    --7102 = ANY (blg.artderflurstuecksgrenze)) 
    (instr(blg.artderflurstuecksgrenze,'7102') > 0)
    --AND blg.advstandardmodell ~~ 'DLKM';
    AND (instr(blg.advstandardmodell,'DLKM') > 0));
-- COMMENT ON VIEW SK2018_BUNDESLANDGRENZE IS 'fuer Kartendarstellung: besondere Flurstücksgrenze "BundesLANDgrenze"';

CREATE OR REPLACE VIEW SK2020_REGIERUNGSBEZIRKSGRENZE 
AS 
 SELECT rbg.OGR_FID, rbg.ORA_GEOMETRY
   FROM ax_besondereflurstuecksgrenze rbg
  WHERE (--7103 = ANY (rbg.artderflurstuecksgrenze)) 
    (instr(rbg.artderflurstuecksgrenze,'7103') > 0)
    --AND rbg.advstandardmodell ~~ 'DLKM';
    AND (instr(rbg.advstandardmodell,'DLKM') > 0));
-- COMMENT ON VIEW SK2020_REGIERUNGSBEZIRKSGRENZE IS 'fuer Kartendarstellung: besondere Flurstücksgrenze "Regierungsbezirksgrenze"';

CREATE OR REPLACE VIEW SK2022_GEMEINDEGRENZE 
AS 
 SELECT gemg.OGR_FID, gemg.ORA_GEOMETRY
   FROM ax_besondereflurstuecksgrenze gemg
  WHERE (
    --7106 = ANY (gemg.artderflurstuecksgrenze)) 
     (instr(gemg.artderflurstuecksgrenze,'7106') > 0)
    --AND gemg.advstandardmodell ~~ 'DLKM';
    AND (instr(gemg.advstandardmodell,'DLKM') > 0));
-- COMMENT ON VIEW SK2022_GEMEINDEGRENZE IS 'fuer Kartendarstellung: besondere Flurstücksgrenze "Gemeindegrenze"';

CREATE OR REPLACE VIEW SK201X_POLITISCHE_GRENZE 
AS 
 SELECT OGR_FID, artderflurstuecksgrenze as art, ORA_GEOMETRY
   FROM ax_besondereflurstuecksgrenze
  WHERE (
     --7102 = ANY (artderflurstuecksgrenze) 
     --OR  7102 = ANY (artderflurstuecksgrenze) 
     --  7103 = ANY (artderflurstuecksgrenze) 
     -- OR  7104 = ANY (artderflurstuecksgrenze) 
     --OR  7106 = ANY (artderflurstuecksgrenze)
     (instr(artderflurstuecksgrenze,'7102') > 0)
     OR (instr(artderflurstuecksgrenze,'7102') > 0)
     OR (instr(artderflurstuecksgrenze,'7103') > 0)
     OR (instr(artderflurstuecksgrenze,'7104') > 0)
     OR (instr(artderflurstuecksgrenze,'7106') > 0)
    )
    --AND advstandardmodell ~~ 'DLKM';
   AND (instr(advstandardmodell,'DLKM') > 0);

-- COMMENT ON VIEW SK201X_POLITISCHE_GRENZE IS 'fuer Kartendarstellung: besondere Flurstücksgrenze Politische Grenzen (Bund, LAND, Kreis, Gemeinde)';


CREATE OR REPLACE VIEW FLSTNR_OHNE_POSITION
AS 
 SELECT f.GML_ID, 
        f.gemarkungsnummer || '-' || f.flurnummer || '-' || f.zaehler || COALESCE ('/' || f.nenner, '') AS SUCH
 FROM        ax_flurstueck     f 
   LEFT JOIN alkis_beziehungen v  ON v.beziehung_zu = f.GML_ID
  WHERE v.beziehungsart is NULL
    AND f.endet IS NULL
  ;
-- COMMENT ON VIEW FLSTNR_OHNE_POSITION IS 'Flurstücke ohne manuell gesetzte Position für die Präsentation der FS-Nr';

CREATE OR REPLACE VIEW S_ALLGEMEINE_TEXTE 
AS 
 SELECT p.OGR_FID, 
        p.ART, 
        p.DREHWINKEL * 57.296 AS DREHWINKEL,
        p.SCHRIFTINHALT
   FROM ap_pto p
  WHERE NOT p.art = 'ZAE_NEN' 
    AND NOT p.art = 'HNR' 
    AND NOT p.art = 'FKT' 
    AND NOT p.art = 'Friedhof' 
    AND p.schriftinhalt IS NOT NULL
    AND p.endet IS NULL;

CREATE OR REPLACE VIEW AP_PTO_ARTEN 
AS 
  SELECT DISTINCT art 
    FROM ap_pto;

-- ToDo: pruefen
CREATE OR REPLACE VIEW TEXTE_MIT_UMBRUCH 
AS 
 SELECT OGR_FID, schriftinhalt, art
   FROM ap_pto 
  WHERE not schriftinhalt is null
    AND schriftinhalt like '%/n%';

-- ToDo: 
CREATE OR REPLACE VIEW S_ALLGEMEINE_TEXTE_ARTEN
AS 
 SELECT DISTINCT art 
   FROM s_allgemeine_texte;

-- ToDo: 
--CREATE OR REPLACE VIEW FLURSTUECKS_MINMAX AS 
-- SELECT min(st_xmin(ORA_GEOMETRY)) AS r_min, 
--        min(st_ymin(ORA_GEOMETRY)) AS h_min, 
--        max(st_xmax(ORA_GEOMETRY)) AS r_max, 
--        max(st_ymax(ORA_GEOMETRY)) AS h_max
--   FROM ax_flurstueck f
--   WHERE f.endet IS NULL;
-- COMMENT ON VIEW FLURSTUECKS_MINMAX IS 'Maximale Ausdehnung von ax_flurstueck fuer EXTENT-Angabe im Mapfile';

-- ToDo: 
-- Tabelle liegt nur einmal vor wegen Laenge des Namens
CREATE OR REPLACE VIEW BAURECHT
AS
  SELECT r.OGR_FID, 
         r.ORA_GEOMETRY, 
         r.GML_ID, 
         r.artderfestlegung as adfkey,
         r.name,
         r.stelle,
         r.bezeichnung AS rechtbez,
        a.bezeichner  AS adfbez,
         d.bezeichnung AS stellbez
    FROM AX_BAURAUMODERBODENORDNUNGSREC r
    LEFT JOIN AX_BAURAUMODERBODENORDNUNGSKEY a
     ON r.artderfestlegung = a.wert
    LEFT JOIN ax_dienststelle d
      ON r.LAND   = d.LAND 
    AND r.stelle = d.stelle 
  WHERE r.endet IS NULL
   AND d.endet IS NULL ;

CREATE OR REPLACE VIEW GEMARKUNG_IN_GEMEINDE
AS
  SELECT DISTINCT LAND, regierungsbezirk, kreis, gemeinde, gemarkungsnummer
  FROM            ax_flurstueck
  WHERE           endet IS NULL
  ORDER BY        LAND, regierungsbezirk, kreis, gemeinde, gemarkungsnummer
;
-- COMMENT ON VIEW GEMARKUNG_IN_GEMEINDE IS 'Welche Gemarkung liegt in welcher Gemeinde? Durch Verweise aus Flurstück.';

--ToDo: 
--CREATE OR REPLACE VIEW ARTEN_VON_FLURSTUECKSGEOMETRIE
--AS
-- SELECT   count(GML_ID) as anzahl,
 --         st_geometrytype(ORA_GEOMETRY)
-- FROM     ax_flurstueck
-- WHERE    endet IS NULL
-- GROUP BY st_geometrytype(ORA_GEOMETRY);

CREATE OR REPLACE VIEW ADRESSEN_HAUSNUMMERN
AS
    SELECT 
        s.bezeichnung AS strassenname, 
         g.bezeichnung AS gemeindename, 
         l.LAND, 
         l.regierungsbezirk, 
         l.kreis, 
         l.gemeinde, 
         l.lage        AS strassenschluessel, 
         l.hausnummer 
    FROM   AX_LAGEBEZEICHNUNGMITHAUSNUMME l  
    JOIN   ax_gemeinde g 
      ON l.kreis=g.kreis 
     AND l.gemeinde=g.gemeinde 
    JOIN   AX_LAGEBEZEICHNUNGKATALOGEINTR s 
      ON l.kreis=s.kreis 
     AND l.gemeinde=s.gemeinde 
     AND l.lage = s.lage;
    --WHERE     l.gemeinde = 40;

CREATE OR REPLACE VIEW ADRESSEN_ZUM_FLURSTUECK
AS
    SELECT
           f.gemarkungsnummer, 
           f.flurnummer, 
           f.zaehler, 
           f.nenner,
           g.bezeichnung AS gemeindename, 
           s.bezeichnung AS strassenname, 
           l.lage        AS strassenschluessel, 
           l.hausnummer 
      FROM   ax_flurstueck f 
      JOIN   alkis_beziehungen v 
        ON f.GML_ID=v.beziehung_von
      JOIN   AX_LAGEBEZEICHNUNGMITHAUSNUMME l  
        ON l.GML_ID=v.beziehung_zu
      JOIN   ax_gemeinde g 
        ON l.kreis=g.kreis 
       AND l.gemeinde=g.gemeinde 
      JOIN   AX_LAGEBEZEICHNUNGKATALOGEINTR s 
        ON l.kreis=s.kreis 
       AND l.gemeinde=s.gemeinde 
       AND l.lage = s.lage
     WHERE v.beziehungsart='weistAuf'
       --AND l.gemeinde = 40
     ORDER BY 
           f.gemarkungsnummer,
           f.flurnummer,
           f.zaehler,
           f.nenner;

CREATE OR REPLACE VIEW FLURSTUECKE_EINES_EIGENTUEMERS 
AS 
   SELECT 
      k.bezeichnung                AS gemarkung, 
      k.gemarkungsnummer           AS gemkg_nr, 
      f.flurnummer                 AS flur, 
      f.zaehler                    AS fs_zaehler, 
      f.nenner                     AS fs_nenner, 
      f.amtlicheflaeche            AS flaeche, 
      f.ORA_GEOMETRY               AS geom,
      b.bezeichnung                AS bezirkname,
      g.BUCHUNGSBLATTNUMMERMITBUCHSTAB AS gb_blatt, 
      g.blattart, 
      s.laufendenummer             AS bvnr, 
      art.bezeichner               AS buchgsart, 
      n.laufendenummernachdin1421  AS name_num, 
      p.nachnameoderfirma          AS nachname
   FROM       ax_person              p
        JOIN  alkis_beziehungen      bpn  ON bpn.beziehung_zu  = p.GML_ID 
        JOIN  ax_namensnummer        n    ON bpn.beziehung_von =n.GML_ID 
        JOIN  alkis_beziehungen      bng  ON n.GML_ID = bng.beziehung_von 
        JOIN  ax_buchungsblatt       g    ON bng.beziehung_zu = g.GML_ID 
        JOIN  ax_buchungsblattbezirk b    ON g.LAND = b.LAND AND g.bezirk = b.bezirk 
        JOIN  alkis_beziehungen      bgs  ON bgs.beziehung_zu = g.GML_ID 
        JOIN  ax_buchungsstelle      s    ON s.GML_ID = bgs.beziehung_von 
        JOIN  ax_buchungsstelle_buchungsart art ON s.buchungsart = art.wert 
        JOIN  alkis_beziehungen      bsf  ON bsf.beziehung_zu = s.GML_ID
        JOIN  ax_flurstueck          f    ON f.GML_ID = bsf.beziehung_von 
        JOIN  ax_gemarkung           k    ON f.LAND = k.LAND AND f.gemarkungsnummer = k.gemarkungsnummer 
   WHERE p.nachnameoderfirma LIKE 'Gemeinde %'
     AND bpn.beziehungsart = 'benennt'
     AND bng.beziehungsart = 'istBestandteilVon'
     AND bgs.beziehungsart = 'istBestandteilVon'
     AND bsf.beziehungsart = 'istGebucht'
     AND p.endet IS NULL 
     AND n.endet IS NULL
     AND g.endet IS NULL
     AND b.endet IS NULL
     AND s.endet IS NULL
     AND f.endet IS NULL
     AND k.endet IS NULL
   ORDER BY   
         k.bezeichnung,
         f.flurnummer,
         f.zaehler,
         f.nenner,
         g.bezirk, 
         g.BUCHUNGSBLATTNUMMERMITBUCHSTAB,
         s.laufendenummer 
;
CREATE OR REPLACE VIEW RECHTE_EINES_EIGENTUEMERS 
AS
   SELECT 
      k.bezeichnung                AS gemarkung, 
      k.gemarkungsnummer           AS gemkg_nr, 
      f.flurnummer                 AS flur, 
      f.zaehler                    AS fs_zaehler, 
      f.nenner                     AS fs_nenner, 
      f.amtlicheflaeche            AS flaeche, 
      f.ORA_GEOMETRY               AS geom,
      b.bezeichnung                AS bezirkname,
      g.BUCHUNGSBLATTNUMMERMITBUCHSTAB AS gb_blatt, 
      sh.laufendenummer            AS bvnr_herr, 
      sh.zaehler || '/' || sh.nenner AS buchg_anteil_herr, 
      arth.bezeichner              AS buchgsa_herr, 
      bss.beziehungsart            AS bez_art,
      artd.bezeichner              AS buchgsa_dien, 
      sd.laufendenummer            AS bvnr_dien, 
      n.laufendenummernachdin1421  AS name_num, 
      p.nachnameoderfirma          AS nachname
   FROM       ax_person              p
        JOIN  alkis_beziehungen      bpn  ON bpn.beziehung_zu  = p.GML_ID 
        JOIN  ax_namensnummer        n    ON bpn.beziehung_von =n.GML_ID 
        JOIN  alkis_beziehungen      bng  ON n.GML_ID = bng.beziehung_von 
        JOIN  ax_buchungsblatt       g    ON bng.beziehung_zu = g.GML_ID 
        JOIN  ax_buchungsblattbezirk b    ON g.LAND = b.LAND AND g.bezirk = b.bezirk 
        JOIN  alkis_beziehungen      bgs  ON bgs.beziehung_zu = g.GML_ID 
        JOIN  ax_buchungsstelle      sh   ON sh.GML_ID = bgs.beziehung_von
        JOIN  ax_buchungsstelle_buchungsart arth ON sh.buchungsart = arth.wert 
        JOIN  alkis_beziehungen      bss  ON sh.GML_ID = bss.beziehung_von
        JOIN  ax_buchungsstelle      sd   ON sd.GML_ID = bss.beziehung_zu
        JOIN  ax_buchungsstelle_buchungsart artd ON sd.buchungsart = artd.wert 
        JOIN  alkis_beziehungen      bsf  ON bsf.beziehung_zu = sd.GML_ID
        JOIN  ax_flurstueck          f    ON f.GML_ID = bsf.beziehung_von 
        JOIN  ax_gemarkung           k    ON f.LAND = k.LAND AND f.gemarkungsnummer = k.gemarkungsnummer 
   WHERE p.nachnameoderfirma LIKE 'Stadt %'
     AND bpn.beziehungsart = 'benennt'
     AND bng.beziehungsart = 'istBestandteilVon'
     AND bgs.beziehungsart = 'istBestandteilVon'
     AND bss.beziehungsart in ('an','zu')
     AND bsf.beziehungsart = 'istGebucht'
     AND p.endet IS NULL
     AND n.endet IS NULL
     AND g.endet IS NULL
     AND b.endet IS NULL
     AND sh.endet IS NULL
     AND sd.endet IS NULL
     AND f.endet IS NULL
     AND k.endet IS NULL
   ORDER BY   
         k.bezeichnung,
         f.flurnummer,
         f.zaehler,
         f.nenner,
         g.bezirk, 
         g.BUCHUNGSBLATTNUMMERMITBUCHSTAB,
         sh.laufendenummer 
;

CREATE OR REPLACE VIEW BEZIEHUNGEN_REDUNDANT 
AS
SELECT *
 FROM alkis_beziehungen bezalt
 WHERE EXISTS
       (SELECT OGR_FID
         FROM alkis_beziehungen bezneu
        WHERE bezalt.beziehung_von = bezneu.beziehung_von
          AND bezalt.beziehung_zu  = bezneu.beziehung_zu
          AND bezalt.beziehungsart = bezneu.beziehungsart
          AND bezalt.OGR_FID       < bezneu.OGR_FID
        );

-- COMMENT ON VIEW BEZIEHUNGEN_REDUNDANT IS 'alkis_beziehungen zu denen es eine identische neue Version gibt.';

--ToDo
--CREATE OR REPLACE VIEW BEZIEHUNGEN_REDUNDANT_IN_DELET
--AS
--SELECT *
-- FROM alkis_beziehungen AS bezalt
-- WHERE EXISTS
--       (SELECT OGR_FID
--         FROM alkis_beziehungen bezneu
--        WHERE bezalt.beziehung_von = bezneu.beziehung_von
--          AND bezalt.beziehung_zu  = bezneu.beziehung_zu
--         AND bezalt.beziehungsart = bezneu.beziehungsart
--          AND bezalt.OGR_FID       < bezneu.ogc_fid
--        )
--     AND EXISTS
--        (SELECT OGR_FID
--         FROM delete
--         WHERE bezalt.beziehung_von = substr(featureid, 1, 16)
--            OR bezalt.beziehung_zu  = substr(featureid, 1, 16)
--        );

---- COMMENT ON VIEW BEZIEHUNGEN_REDUNDANT_IN_DELET IS 'alkis_beziehungen zu denen es eine identische neue Version gibt und wo das Objekt noch in der delete-Tabelle vorkommt.';
purge recyclebin;
QUIT;
