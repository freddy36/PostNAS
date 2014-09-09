-- =====
-- ALKIS
-- =====

--  -----------------------------------------
--  Sichten für Fehlersuche und Daten-Analyse
--  -----------------------------------------

--  Dieses SQL braucht nur bei Bedarf in einer PostNAS-DB verarbeitet werden.
--  Es werden zusätzliche Views eingerichtet, die nur bei Fehlersuche und Analyse (vom Entwickler) benötigt werden.

--  PostNAS 0.7

--  2012-04-17 flstnr_ohne_position
--  2012-04-24 pauschal Filter 'endet IS NULL' um historische Objekte auszublenden
--  2012-10-29 Redundanzen in Beziehungen suchen (entstehen durch replace)
--  2013-02-20 Mehrfache Buchungsstellen zum FS suchen, dies sind Auswirkungen eines Fehlers bei Replace
--  2013-03-05 Beschriftungen aus ap_pto auseinander sortieren, neuer View "grenzpunkt"
--  2013-03-12 Optimierung Hausnummern, View "gebaeude_txt" (Funktion und Name)
--  2013-04-15 Unterdrücken doppelter Darstellung in den Views 'ap_pto_stra', 'ap_pto_nam', 'ap_pto_rest'
--  2013-04-16 Thema "Bodenschätzung" und fehlernde Kommentare zum Views ergänzt.
--             Diese Datei aufgeteilt in "sichten.sql" und "sichten_wms.sql"
--  2013-10-23 Fehlersuche Gebäude-Hausnummer-Relation
--  2013-11-26 Neue Views (doppelverbindung)
--  2014-01-17 View "exp_csv" für den Export von CSV-Daten aus der Auskunft mit Modul alkisexport.php.
--  2014-01-20 Erweiterung "exp_csv" für alkisexport.php
--  2014-01-21 In "exp_csv": Rechtsgemeinsachaft zu allen Personen statt als eigener Satz.
--  2014-01-27 Neuer Baustein "flst_an_strasse". Neuer View "exp_csv_str" für CSV-Export von Flst. an einer Straße
--  2014-01-29 Neuer View "strasse_als_gewanne" zur Fehlersuche.
--  2014-01-31 Kommentar
--  2014-02-06 nachmigration_aehnliche_anschriften

-- Bausteine für andere Views:
-- ---------------------------

-- Ein View, der die Verbindung von Flurstück zur Buchung für zwei verschiedene Fälle herstellt.
-- Einmal die "normalen" (direkten) Buchungen.
-- Zweitens über die Rechte von Buchungsstellen an anderen Buchungsstellen.
-- Dies kann als "Mittelstück" in den anderen Views eingefügt werden.

-- Einfach/Direkt:
--   Flurstück   >istGebucht>                         (Buchungs-Stelle)
--
-- Mit "Recht an":
--   Flurstück   >istGebucht>  Buchungs-Stelle  <an<  (Buchungs-Stelle)
--                               (dienend)              (herrschend) 

--           DROP VIEW public.doppelverbindung;
CREATE OR REPLACE VIEW public.doppelverbindung
AS
  SELECT v1.beziehung_von AS fsgml,       -- gml_id auf Flurstück - Seite
         v1.beziehung_zu  AS bsgml,       -- gml_id auf Buchungs  - Seite
      --'direkt' AS fall,
         0 AS ba_dien
    FROM alkis_beziehungen v1
   WHERE v1.beziehungsart = 'istGebucht'  -- FS --> Buchung
 UNION
  -- Buchungstelle  >an>  Buchungstelle  >istBestandteilVon>  BLATT 
  SELECT v2.beziehung_von AS fsgml,        -- gml_id auf Flurstück - Seite
         an.beziehung_von AS bsgml,        -- gml_id auf Buchungs  - Seite (herrschendes GB)
      --'Recht an' AS fall,
         dien.buchungsart AS ba_dien       -- Ein Feld aus der Zwischen-Buchung zur Fall-Unterscheidung
    FROM alkis_beziehungen v2
    JOIN ax_buchungsstelle dien
      ON  v2.beziehung_zu = dien.gml_id
    JOIN alkis_beziehungen an
      ON dien.gml_id = an.beziehung_zu
   WHERE v2.beziehungsart = 'istGebucht'   -- FS --> Buchung
     AND an.beziehungsart = 'an';

COMMENT ON VIEW public.doppelverbindung 
 IS 'ALKIS-Beziehung von Flurstück zu Buchung. UNION-Zusammenfassung des einfachen Falls mit direkter Buchung und des Falles mit Recht einer Buchungsstelle an einer anderen Buchungsstelle.';

-- Test-Ausgabe: Ein paar Fälle mit "Recht an"
--   SELECT * FROM doppelverbindung WHERE ba_dien > 0 LIMIT 20;


-- Ein View, der die Verbindung von Flurstück zur Straßentabelle für zwei verschiedene Fälle herstellt.
-- Einmal über die Lagebezeichnung MIT Hausnummer und einmal OHNE.
-- Dies kann als "Mittelstück" in den anderen Views eingefügt werden.

--   Flurstück  >weistAuf> ax_lagebezeichnungmithausnummer  <JOIN> ax_lagebezeichnungkatalogeintrag
--   Flurstück  >zeigtAuf> ax_lagebezeichnungohnehausnummer <JOIN> ax_lagebezeichnungkatalogeintrag

--           DROP VIEW public.flst_an_strasse;
CREATE OR REPLACE VIEW public.flst_an_strasse
AS
  SELECT vm.beziehung_von AS fsgml,          -- Join auf "gml_id" aus "ax_flurstück"
         sm.gml_id AS stgml,                 -- Filter: gml_id der Straße
      -- sm.gemeinde, sm.lage,               -- Gemeinde- und Straßenschluessel als Filter?
         'm' AS fall                         -- Sätze unterschieden: Mit HsNr
    FROM alkis_beziehungen vm                -- Verbindung Mit
    JOIN ax_lagebezeichnungmithausnummer lm  -- Lage MIT
      ON lm.gml_id=vm.beziehung_zu
     AND vm.beziehungsart= 'weistAuf' 
    JOIN ax_lagebezeichnungkatalogeintrag sm -- Ausnahmsweise mal direkt und nicht über die "alkis_beziehungen"
      ON lm.land=sm.land 
     AND lm.regierungsbezirk=sm.regierungsbezirk 
     AND lm.kreis=sm.kreis 
     AND lm.gemeinde=sm.gemeinde 
     AND lm.lage=sm.lage 
 UNION
  SELECT vo.beziehung_von AS fsgml,          -- Join auf gml_id aus ax_flurstück
         so.gml_id AS stgml,                 -- Filter: gml_id der Straße
      -- so.gemeinde, so.lage                -- Gemeinde- und Straßenschluessel als Filter?
         'o' AS fall                         -- Sätze unterschieden: Ohne HsNr
    FROM alkis_beziehungen vo                -- Verbindung OHNE
    JOIN ax_lagebezeichnungohnehausnummer lo -- Lage OHNE
      ON lo.gml_id=vo.beziehung_zu
     AND vo.beziehungsart= 'zeigtAuf' 
    JOIN ax_lagebezeichnungkatalogeintrag so -- Straße OHNE
      ON lo.land=so.land 
     AND lo.regierungsbezirk=so.regierungsbezirk 
     AND lo.kreis=so.kreis 
     AND lo.gemeinde=so.gemeinde 
     AND lo.lage=so.lage;

COMMENT ON VIEW public.flst_an_strasse 
 IS 'ALKIS-Beziehung von Flurstück zu Straßentabelle. UNION-Zusammenfassung der Fälle MIT und OHNE Hausnummer.';

-- Muss man noch dafür sorgen, dass Flurstück nicht doppelt vorkommt? z.B. mit DISTINCT
-- Oder müssen ggf. mehrfache FS im Programm übersprungen werden?

-- Test-Ausgabe:
--   SELECT * FROM flst_an_strasse WHERE stgml='DENW18AL000004Fl' LIMIT 40;

-- Ende "Bausteine"


-- Generelle Export-Struktur "Flurstück - Buchung - Grundbuch - Person"
-- --------------------------------------------------------------------
-- Verwendet den gespeicherten View "doppelverbindung".
-- Wird benötigt im Auskunft-Modul "alkisexport.php":
-- Je nach aufrufendem Modul wird der Filter (WHERE) an anderer Stelle gesetzt (gml_id von FS, GB oder Pers.)
-- Für Filter nach "Straße" siehe die nachfolgende Sonderversion "exp_csv_str".

-- Problem / Konflikt:
-- Es kann nur eine lineare Struktur aus Spalten und Zeilen exportiert werden. 
-- Wenn nicht nur die Daten des Ausgangs-Objektes exportiert werden, sondern auch verbundene Tabellen in 
-- einer 1:N-Struktur, dann verdoppeln sich Zeileninhalte und es werden redundante Daten erzeugt. 
-- Diese Redundanzen müssen vom dem Programm gefiltert werden, das die Daten über eine Schnittstelle einliest.

-- Anwendungs-Beispiel: Abrechnung von Anliegerbeiträgen.

-- 2014-01-21: "Rechtsgemeinschaft" in den Datensatz aller anderen Namen
--           DROP VIEW exp_csv;
CREATE OR REPLACE VIEW exp_csv
AS
 SELECT
  -- Flurstück
    f.gml_id                             AS fsgml,       -- möglicher Filter Flurstücks-GML-ID
    f.flurstueckskennzeichen             AS fs_kennz,
    f.gemarkungsnummer,                                  -- Teile des FS-Kennz. noch mal einzeln
    f.flurnummer, f.zaehler, f.nenner, 
    f.amtlicheflaeche                    AS fs_flae,
    g.bezeichnung                        AS gemarkung,

  -- Grundbuch
    gb.gml_id                            AS gbgml,       -- möglicher Filter Grundbuch-GML-ID
    gb.bezirk                            AS gb_bezirk,
    gb.buchungsblattnummermitbuchstabenerweiterung AS gb_blatt,
    z.bezeichnung                        AS beznam,      -- GB-Bezirks-Name

  -- Buchungsstelle (Grundstück)
    s.laufendenummer                     AS bu_lfd,      -- BVNR
    --s.zaehler, s.nenner,                                -- Anteil des GB am FS, einzelne Felder
    '=' || s.zaehler || '/' || s.nenner  AS bu_ant,      -- als Excel-Formel (nur bei Wohnungsgrundbuch JOIN über 'Recht an')
    s.buchungsart,                                       -- verschlüsselt
    b.bezeichner                         AS bu_art,      -- Buchungsart entschlüsselt

  -- NamensNummer (Normalfall mit Person)
    nn.laufendenummernachdin1421         AS nam_lfd, 
    '=' || nn.zaehler|| '/' || nn.nenner AS nam_ant,         -- als Excel-Formel

  -- Rechtsgemeinsachaft (Sonderfall von Namensnummer, ohne Person, ohne Nummer)
    rg.artderrechtsgemeinschaft          AS nam_adr,
    rg.beschriebderrechtsgemeinschaft    AS nam_bes,

  -- Person
    p.gml_id                             AS psgml,           -- möglicher Filter Personen-GML-ID
    p.anrede,
    p.vorname,
    p.namensbestandteil,
    p.nachnameoderfirma,                                     -- Familienname
    p.geburtsdatum,
    --p.geburtsname, p.akademischergrad 
 
  -- Adresse der Person
    a.postleitzahlpostzustellung         AS plz,
    a.ort_post                           AS ort,             -- Anschreifenzeile 1: PLZ+Ort
    a.strasse,  a.hausnummer,                                -- Anschriftenzeile 2: Straße+HsNr
    a.bestimmungsland                    AS land

  FROM ax_flurstueck    f               -- Flurstück
  JOIN doppelverbindung d               -- beide Fälle über Union-View: direkt und über Recht von Buchung an Buchung
    ON d.fsgml = f.gml_id 

  JOIN ax_gemarkung g                   -- entschlüsseln
    ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer 

  JOIN ax_buchungsstelle s              -- Buchungs-Stelle
    ON d.bsgml = s.gml_id 
  JOIN ax_buchungsstelle_buchungsart b  -- Enstschlüsselung der Buchungsart
    ON s.buchungsart = b.wert 

  JOIN alkis_beziehungen v3             -- Buchung --> Grundbuchblatt
    ON s.gml_id = v3.beziehung_von AND v3.beziehungsart = 'istBestandteilVon'
  JOIN ax_buchungsblatt  gb 
    ON v3.beziehung_zu = gb.gml_id 

  JOIN ax_buchungsblattbezirk z 
    ON gb.land=z.land AND gb.bezirk=z.bezirk 

  JOIN alkis_beziehungen v4             -- Blatt  --> NamNum
    ON v4.beziehung_zu = gb.gml_id AND v4.beziehungsart = 'istBestandteilVon'  
  JOIN ax_namensnummer nn 
    ON v4.beziehung_von = nn.gml_id

  JOIN alkis_beziehungen v5             -- NamNum --> Person 
   -- 2014-01-20: Mit LEFT ab hier werden auch NumNum-Zeilen mit "Beschreibung der Rechtsgemeinschaft" geliefert (ohne Person)
    ON v5.beziehung_von = nn.gml_id AND v5.beziehungsart = 'benennt'
  JOIN ax_person p
    ON v5.beziehung_zu = p.gml_id

  LEFT JOIN alkis_beziehungen v6        -- Person --> Anschrift
    ON v6.beziehung_von = p.gml_id AND v6.beziehungsart = 'hat' 
  LEFT JOIN ax_anschrift a 
    ON v6.beziehung_zu = a.gml_id

  -- 2mal "LEFT JOIN" verdoppelt die Zeile in der Ausgabe. Darum als Subquery:

  -- Noch mal "GB -> NamNum", aber dieses Mal für "Rechtsgemeinschaft".
  -- Kommt max. 1 mal je GB vor und hat keine Relation auf Person.
  LEFT JOIN
   ( SELECT v7.beziehung_zu,
            rg.artderrechtsgemeinschaft, 
            rg.beschriebderrechtsgemeinschaft 
       FROM ax_namensnummer rg 
       JOIN alkis_beziehungen v7              -- Blatt  --> NamNum (Rechtsgemeinschaft) 
         ON v7.beziehung_von = rg.gml_id
      WHERE v7.beziehungsart = 'istBestandteilVon'
        AND NOT rg.artderrechtsgemeinschaft IS NULL
   ) AS rg                         -- Rechtsgemeinschaft
   ON rg.beziehung_zu = gb.gml_id  -- zum GB

  ORDER BY f.flurstueckskennzeichen, 
           gb.bezirk, gb.buchungsblattnummermitbuchstabenerweiterung, s.laufendenummer,
           nn.laufendenummernachdin1421;

COMMENT ON VIEW exp_csv 
 IS 'View für einen CSV-Export aus der Buchauskunft mit alkisexport.php. Generelle Struktur. Für eine bestimmte gml_id noch den Filter setzen.';

  GRANT SELECT ON TABLE exp_csv TO mb27;       -- User für Auskunfts-Programme
--GRANT SELECT ON TABLE exp_csv TO alkisbuch;  -- User für Auskunfts-Programme RLP-Demo


-- Variante des View "exp_csv":
-- Hier wird zusätzlich der Baustein "flst_an_strasse" verwendet.
-- Der Filter "WHERE stgml= " auf die "gml_id" von "ax_lagebezeichnungkatalogeintrag" sollte gesetzt werden
-- um alle Flurstücke zu bekommen, die an einer Straße liegen.
-- DROP           VIEW exp_csv_str;
CREATE OR REPLACE VIEW exp_csv_str
AS
 SELECT
    l.stgml,                                             -- Filter: Straßen-GML-ID

  -- Flurstück
    f.gml_id                             AS fsgml,       -- Gruppenwechsel für "function lage_zum_fs" in alkisexport.php
    f.flurstueckskennzeichen             AS fs_kennz,
    f.gemarkungsnummer,                                  -- Teile des FS-Kennz. noch mal einzeln
    f.flurnummer, f.zaehler, f.nenner, 
    f.amtlicheflaeche                    AS fs_flae,
    g.bezeichnung                        AS gemarkung,

  -- Grundbuch
  --gb.gml_id                            AS gbgml,       -- möglicher Filter Grundbuch-GML-ID
    gb.bezirk                            AS gb_bezirk,
    gb.buchungsblattnummermitbuchstabenerweiterung AS gb_blatt,
    z.bezeichnung                        AS beznam,      -- GB-Bezirks-Name

  -- Buchungsstelle (Grundstück)
    s.laufendenummer                     AS bu_lfd,      -- BVNR
    --s.zaehler, s.nenner,                                -- Anteil des GB am FS, einzelne Felder
    '=' || s.zaehler || '/' || s.nenner  AS bu_ant,      -- als Excel-Formel (nur bei Wohnungsgrundbuch JOIN über 'Recht an')
    s.buchungsart,                                       -- verschlüsselt
    b.bezeichner                         AS bu_art,      -- Buchungsart entschlüsselt

  -- NamensNummer (Normalfall mit Person)
    nn.laufendenummernachdin1421         AS nam_lfd, 
    '=' || nn.zaehler|| '/' || nn.nenner AS nam_ant,         -- als Excel-Formel

  -- Rechtsgemeinsachaft (Sonderfall von Namensnummer, ohne Person, ohne Nummer)
    rg.artderrechtsgemeinschaft          AS nam_adr,
    rg.beschriebderrechtsgemeinschaft    AS nam_bes,

  -- Person
  --p.gml_id                             AS psgml,           -- möglicher Filter Personen-GML-ID
    p.anrede,
    p.vorname,
    p.namensbestandteil,
    p.nachnameoderfirma,                                     -- Familienname
    p.geburtsdatum,
    --p.geburtsname, p.akademischergrad 
 
  -- Adresse der Person
    a.postleitzahlpostzustellung         AS plz,
    a.ort_post                           AS ort,             -- Anschreifenzeile 1: PLZ+Ort
    a.strasse,  a.hausnummer,                                -- Anschriftenzeile 2: Straße+HsNr
    a.bestimmungsland                    AS land

  FROM ax_flurstueck    f               -- Flurstück

  JOIN flst_an_strasse  l               -- Lage (hier zusätzlicher JOIN gegenüber Version "exp_csv") 
	ON l.fsgml = f.gml_id 

  JOIN doppelverbindung d               -- beide Fälle über Union-View: direkt und über Recht von Buchung an Buchung
    ON d.fsgml = f.gml_id 

  JOIN ax_gemarkung g                   -- entschlüsseln
    ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer 

  JOIN ax_buchungsstelle s              -- Buchungs-Stelle
    ON d.bsgml = s.gml_id 
  JOIN ax_buchungsstelle_buchungsart b  -- Enstschlüsselung der Buchungsart
    ON s.buchungsart = b.wert 

  JOIN alkis_beziehungen v3             -- Buchung --> Grundbuchblatt
    ON s.gml_id = v3.beziehung_von AND v3.beziehungsart = 'istBestandteilVon'
  JOIN ax_buchungsblatt  gb 
    ON v3.beziehung_zu = gb.gml_id 

  JOIN ax_buchungsblattbezirk z 
    ON gb.land=z.land AND gb.bezirk=z.bezirk 

  JOIN alkis_beziehungen v4             -- Blatt  --> NamNum
    ON v4.beziehung_zu = gb.gml_id AND v4.beziehungsart = 'istBestandteilVon'  
  JOIN ax_namensnummer nn 
    ON v4.beziehung_von = nn.gml_id

  JOIN alkis_beziehungen v5             -- NamNum --> Person 
   -- 2014-01-20: Mit LEFT ab hier werden auch NumNum-Zeilen mit "Beschreibung der Rechtsgemeinschaft" geliefert (ohne Person)
    ON v5.beziehung_von = nn.gml_id AND v5.beziehungsart = 'benennt'
  JOIN ax_person p
    ON v5.beziehung_zu = p.gml_id

  LEFT JOIN alkis_beziehungen v6        -- Person --> Anschrift
    ON v6.beziehung_von = p.gml_id AND v6.beziehungsart = 'hat' 
  LEFT JOIN ax_anschrift a 
    ON v6.beziehung_zu = a.gml_id

  -- 2mal "LEFT JOIN" verdoppelt die Zeile in der Ausgabe. Darum als Subquery:

  -- Noch mal "GB -> NamNum", aber dieses Mal für "Rechtsgemeinschaft".
  -- Kommt max. 1 mal je GB vor und hat keine Relation auf Person.
  LEFT JOIN
   ( SELECT v7.beziehung_zu,
            rg.artderrechtsgemeinschaft, 
            rg.beschriebderrechtsgemeinschaft 
       FROM ax_namensnummer rg 
       JOIN alkis_beziehungen v7              -- Blatt  --> NamNum (Rechtsgemeinschaft) 
         ON v7.beziehung_von = rg.gml_id
      WHERE v7.beziehungsart = 'istBestandteilVon'
        AND NOT rg.artderrechtsgemeinschaft IS NULL
   ) AS rg                         -- Rechtsgemeinschaft
   ON rg.beziehung_zu = gb.gml_id  -- zum GB

  ORDER BY f.flurstueckskennzeichen, 
           gb.bezirk, gb.buchungsblattnummermitbuchstabenerweiterung, s.laufendenummer,
           nn.laufendenummernachdin1421;

COMMENT ON VIEW exp_csv_str 
 IS 'View für einen CSV-Export aus der Buchauskunft mit alkisexport.php. Liefert nur Flurstücke, die eine Lagebezeichnung MIT/OHNE Hausnummer haben. Dazu noch den Filter auf GML-ID der Straßentabelle setzen.';

  GRANT SELECT ON TABLE exp_csv_str TO mb27;       -- User für Auskunfts-Programme
--GRANT SELECT ON TABLE exp_csv_str TO alkisbuch;  -- User für Auskunfts-Programme RLP-Demo


-- Test-Ausgabe:
--   SELECT * FROM exp_csv_str WHERE stgml='DENW18AL000004Fl' LIMIT 40;


-- Analyse: Kann es mehr als 1 "Rechtsgemeinschaft" zu einem GB-Blatt geben? 
-- (Diese Frage stellte sich beim Design des View "exp_csv".)
-- Schritt 1: alle vorhandenen
CREATE OR REPLACE VIEW rechtsgemeinschaften_zum_grundbuch
AS
 SELECT
     gb.gml_id,
     gb.bezirk,
     gb.buchungsblattnummermitbuchstabenerweiterung AS gb_blatt,
     nn.artderrechtsgemeinschaft,
     nn.beschriebderrechtsgemeinschaft
  FROM ax_buchungsblatt  gb 
  JOIN alkis_beziehungen v
    ON v.beziehung_zu = gb.gml_id AND v.beziehungsart = 'istBestandteilVon'  
  JOIN ax_namensnummer nn 
    ON v.beziehung_von = nn.gml_id
  WHERE NOT nn.artderrechtsgemeinschaft IS NULL
  ORDER BY gb.bezirk, gb.buchungsblattnummermitbuchstabenerweiterung,
           nn.laufendenummernachdin1421;

COMMENT ON VIEW rechtsgemeinschaften_zum_grundbuch 
 IS 'Rechtsgemeinschaften zum Grundbuchblatt.';

-- Schritt 2: Wo gibt es mehrere zu einem GB-Blatt
CREATE OR REPLACE VIEW rechtsgemeinschaften_zaehlen
AS
 SELECT gml_id, bezirk, gb_blatt, count(artderrechtsgemeinschaft) AS anzahl
   FROM rechtsgemeinschaften_zum_grundbuch
   GROUP BY gml_id, bezirk, gb_blatt
   HAVING count(artderrechtsgemeinschaft) > 1
   ORDER BY bezirk, gb_blatt;

COMMENT ON VIEW rechtsgemeinschaften_zaehlen 
 IS 'Rechtsgemeinschaften zum Grundbuchblatt zaehlen. Anzeigen, wenn es mehrere gibt.';
-- Ja, kann es geben

-- Schritt 3: alle vorhandenen Zeilen anzeigen zu den GB-Blättern, bei denen es mehrere gibt.
CREATE OR REPLACE VIEW rechtsgemeinschaften_mehrfachzeilen
AS
 SELECT * 
   FROM rechtsgemeinschaften_zum_grundbuch
  WHERE gml_id IN (SELECT gml_id FROM rechtsgemeinschaften_zaehlen);

COMMENT ON VIEW rechtsgemeinschaften_mehrfachzeilen 
 IS 'Grundbuchblätter mit mehr als einer Zeile Rechtsgemeinschaft.';
-- Fazit:
-- Man findet einige wenige identische oder ähnlich aussehende Zeilen zu einem Grundbuch.
-- Das sieht also eher nach einem PostNAS-Fortführungsproblem aus, als nach unabhängigen Zeilen.
-- Wurde hier eine Relation nicht sauber gelöscht?


-- Welche Karten-Typen ?
CREATE OR REPLACE VIEW kartentypen_der_texte_fuer_hnr
AS 
   SELECT DISTINCT advstandardmodell 
   FROM ap_pto p 
   WHERE p.art = 'HNR';
COMMENT ON VIEW kartentypen_der_texte_fuer_hnr 
  IS 'Datenanalyse: Kartentypen in Tabelle ap_pto für Hausnummern.';

-- Dies liefert:
--  "{DKKM1000}"
--  "{DKKM1000,DKKM500}"
--  "{DKKM500}"
--  NULL

-- Texte, die NICHT dargestellt werden sollen.
-- -------------------------------------------
-- Texte und Text-Fragmente aus der Konvertierung ALK+ALB, die noch nicht gelöscht worden sind.
CREATE OR REPLACE VIEW ap_pto_muell 
AS 
  SELECT p.ogc_fid, 
         p.schriftinhalt, 
         p.art, 
         p.drehwinkel * 57.296 AS winkel, -- * 180 / Pi
         p.wkb_geometry 
    FROM ap_pto p
   WHERE not p.schriftinhalt IS NULL 
     AND p.endet IS NULL
     AND p.art IN ('AOG_AUG','PNR');
COMMENT ON VIEW ap_pto_muell 
 IS 'Datenanalyse: Beschriftungen aus "ap_pto", die NICHT dargestellt werden sollen.';


-- Flurstücke mit Anzeige der Flurstücksnummer an der "Standardposition"

-- Nach der Konvertierung aus ALK hat zunächst jedes Flurstück eine explizit gesetzte Position der Flurstücksnummer.

-- Nach einer manuellen Teilung bekommen die neuen Flurstücke im ALKIS nur dann eine Position,
-- wenn die Positioin manuell bestimmt (verschoben) wurde.
-- Wenn die Flurstücksnummer an ihrer "Standardposition" angezeigt werden soll, 
-- dann wird diese in den Daten (DHK, NAS) nicht gesetzt.
-- Der Konverter PostNAS konvertiert aber nur die Daten, die er bekommt, er setzt nicht die Standard-Position 
-- für die Flurstücke, die ohne eine manuelle Position kommen.

-- Diese Fälle identifizieren
CREATE OR REPLACE VIEW flstnr_ohne_position
AS 
 SELECT f.gml_id, 
        f.gemarkungsnummer || '-' || f.flurnummer || '-' || f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS such -- Suchstring für ALKIS-Navigation nach FS-Kennzeichen
 FROM        ax_flurstueck     f 
   LEFT JOIN alkis_beziehungen v  ON v.beziehung_zu = f.gml_id
 --LEFT JOIN ap_pto            p  ON p.gml_id       = v.beziehung_von
  WHERE v.beziehungsart is NULL
    AND f.endet IS NULL
--ORDER BY f.gemarkungsnummer, f.flurnummer, f.zaehler
  ;
COMMENT ON VIEW flstnr_ohne_position IS 'Sicht für Datenanalyse: Flurstücke ohne manuell gesetzte Position für die Präsentation der FS-Nr';

-- Umbruch im Label? z.B. "Schwimm-/nbecken"
-- Sind 2 Buchstaben in Mapfile bei "WRAP" möglich?
CREATE OR REPLACE VIEW texte_mit_umbruch 
AS 
 SELECT ogc_fid, schriftinhalt, art
   FROM ap_pto 
  WHERE not schriftinhalt is null
    AND schriftinhalt like '%/n%';
COMMENT ON VIEW texte_mit_umbruch 
 IS 'Sicht für Datenanalyse: Vorkommen eines Umbruchs im Label-Text.';

-- EXTENT für das Mapfile eines Mandanten ermitteln
CREATE OR REPLACE VIEW flurstuecks_minmax AS 
 SELECT min(st_xmin(wkb_geometry)) AS r_min, 
        min(st_ymin(wkb_geometry)) AS h_min, 
        max(st_xmax(wkb_geometry)) AS r_max, 
        max(st_ymax(wkb_geometry)) AS h_max
   FROM ax_flurstueck f
   WHERE f.endet IS NULL;
COMMENT ON VIEW flurstuecks_minmax 
 IS 'Sicht für Datenanalyse: Maximale Ausdehnung von ax_flurstueck fuer EXTENT-Angabe im Mapfile.';

-- Nach Laden der Keytables:
CREATE OR REPLACE VIEW baurecht
AS
  SELECT r.ogc_fid, 
         r.wkb_geometry, 
         r.gml_id, 
         r.artderfestlegung as adfkey, -- Art der Festlegung - Key 
         r."name",                     -- Eigenname des Gebietes
         r.stelle,                     -- Stelle Key
         r.bezeichnung AS rechtbez,    -- Verfahrensnummer
         a.bezeichner  AS adfbez,      -- Art der Festlegung - Bezeichnung
         d.bezeichnung AS stellbez     -- Stelle Bezeichnung
      -- , d.stellenart                -- weiter entschluesseln?
    FROM ax_bauraumoderbodenordnungsrecht r
    LEFT JOIN ax_bauraumoderbodenordnungsrecht_artderfestlegung a
      ON r.artderfestlegung = a.wert
    LEFT JOIN ax_dienststelle d
      ON r.land   = d.land 
     AND r.stelle = d.stelle 
  WHERE r.endet IS NULL AND d.endet IS NULL ;
COMMENT ON VIEW baurecht 
 IS 'Datenanalyse: Enstschlüsselte Felder zu einer Fläche des Baurechts.';

-- Man glaubt es kaum, aber im ALKIS haben Gemeinde und Gemarkung keinerlei Beziehung miteinander
-- Nur durch Auswertung der Flurstücke kann man ermitteln, in welcher Gemeinde eine Gemarkung liegt.
CREATE OR REPLACE VIEW gemarkung_in_gemeinde
AS
  SELECT DISTINCT land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer
  FROM            ax_flurstueck
  WHERE           endet IS NULL
  ORDER BY        land, regierungsbezirk, kreis, gemeinde, gemarkungsnummer;
COMMENT ON VIEW gemarkung_in_gemeinde 
 IS 'Welche Gemarkung liegt in welcher Gemeinde? Durch Verweise aus Flurstück.';


-- Untersuchen, welche Geometrie-Typen vorkommen
CREATE OR REPLACE VIEW arten_von_flurstuecksgeometrie
AS
 SELECT   count(gml_id) as anzahl,
          st_geometrytype(wkb_geometry)
 FROM     ax_flurstueck
 WHERE    endet IS NULL
 GROUP BY st_geometrytype(wkb_geometry);
COMMENT ON VIEW arten_von_flurstuecksgeometrie IS 'Datenanalyse: vorkommende Geometry-Typen in Tabelle ax_flurstueck.';


-- A d r e s s e n 

-- Verschluesselte Lagebezeichnung (Strasse und Hausnummer) fuer eine Gemeinde
-- Schluessel der Gemeinde nach Bedarf anpassen!
CREATE OR REPLACE VIEW adressen_hausnummern
AS
    SELECT 
        s.bezeichnung AS strassenname, 
        g.bezeichnung AS gemeindename, 
        l.land, 
        l.regierungsbezirk, 
        l.kreis, 
        l.gemeinde, 
        l.lage        AS strassenschluessel, 
        l.hausnummer 
    FROM   ax_lagebezeichnungmithausnummer l  
    JOIN   ax_gemeinde g 
      ON l.kreis=g.kreis 
     AND l.gemeinde=g.gemeinde 
    JOIN   ax_lagebezeichnungkatalogeintrag s 
      ON l.kreis=s.kreis 
     AND l.gemeinde=s.gemeinde 
     AND l.lage = s.lage
    WHERE l.gemeinde = 40;  -- "40" = Stadt Lage
COMMENT ON VIEW adressen_hausnummern IS 'Datenanalyse: Verschlüsselte Lagebezeichnung (Straße und Hausnummer) für eine Gemeinde. Schlüssel der Gemeinde nach Bedarf anpassen.';

-- Zuordnung dieser Adressen zu Flurstuecken
-- Schluessel der Gemeinde nach Bedarf anpassen!
CREATE OR REPLACE VIEW adressen_zum_flurstueck
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
        ON f.gml_id=v.beziehung_von
      JOIN   ax_lagebezeichnungmithausnummer l  
        ON l.gml_id=v.beziehung_zu
      JOIN   ax_gemeinde g 
        ON l.kreis=g.kreis 
       AND l.gemeinde=g.gemeinde 
      JOIN   ax_lagebezeichnungkatalogeintrag s 
        ON l.kreis=s.kreis 
       AND l.gemeinde=s.gemeinde 
       AND l.lage = s.lage
     WHERE v.beziehungsart='weistAuf'
       AND l.gemeinde = 40  -- "40" = Stadt Lage
     ORDER BY f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner;
COMMENT ON VIEW adressen_zum_flurstueck IS 'Datenanalyse: Zuordnung von Adressen zu Flurstuecken. Schlüssel der Gemeinde nach Bedarf anpassen.';

-- Punktförmige  P r ä s e n t a t i o n s o b j e k t e  (ap_pto)
-- Ermittlung der vorkommenden Arten
CREATE OR REPLACE VIEW beschriftung_was_kommt_vor 
AS 
  SELECT DISTINCT art, horizontaleausrichtung, vertikaleausrichtung 
    FROM ap_pto 
   WHERE not schriftinhalt is null 
  ORDER BY art;
COMMENT ON VIEW beschriftung_was_kommt_vor IS 'Analyse der vorkommenden Kombinationen in ap_pto (Beschriftung)';

-- Ergebnis:
-- 2013: PostNAS 0.7  (aus 150,260,340)
-- ------------------
--	"AOG_AUG"				"zentrisch";"Basis"  - Schriftinhalkt immer nur "I" ?
--	"BWF"					"zentrisch";"Basis"/"zentrisch";"Mitte"
--	"BWF_ZUS"				"zentrisch";"Basis"
--	"FKT"					"zentrisch";"Basis"/"linksbündig";"Basis"/"zentrisch";"Mitte"
--	"FKT_TEXT"				"zentrisch";"Mitte"
--	"FreierText"			"zentrisch";"Basis"/"zentrisch";"Mitte"/"linksbündig";"Basis"
--	"FreierTextHHO"			"zentrisch";"Mitte"
--	"Friedhof"				"zentrisch";"Basis"
--	"Gewanne"				"zentrisch";"Basis"/"zentrisch";"Mitte"
--	"GFK"					"zentrisch";"Basis"/"zentrisch";"Mitte"
--	"HNR"					"zentrisch";"Basis"/"linksbündig";"Basis"/"zentrisch";"Mitte"  --> Hausnummer, group gebaeude
--	"HHO"					"zentrisch";"Mitte"  -- HHO = objekthoehe zu ax_gebaeude?
--	"NAM"					"zentrisch";"Basis"/"zentrisch";"Mitte"/"linksbündig";"Basis"
--	"SPO"					"zentrisch";"Basis"/
--	"Vorratsbehaelter"		"zentrisch";"Basis"
--	"WeitereHoehe"			"zentrisch";"Mitte"
--	"ZAE_NEN"				"zentrisch";"Basis"
--	"ZNM"					"zentrisch";"Basis"/"linksbündig";"Basis"

--* Layer "ap_pto_stra"
--                          hor ; ver / hor ; ver 
--	"BezKlassifizierungStrasse" "zent.";"Basis"	/ "linksbündig";"Basis"
--	"Platz"					"zentrisch";"Basis" / "zentrisch";"Mitte"
--	"Strasse"				"zentrisch";"Basis" / "zentrisch";"Mitte" / "linksbündig";"Basis"
--	"Weg"					"zentrisch";"Basis" / "zentrisch";"Mitte" / "linksbündig";"Basis"

--* geplanter layer "ap_pto_wasser"
--	"StehendesGewaesser"	"zentrisch";"Basis"
--	"Fliessgewaesser"		"zentrisch";"Basis"/"linksbündig";"Basis"


-- Flurstücke eines Eigentümers
-- ----------------------------

-- Dieser View liefert nur die (einfache) Buchungsart "Grundstück"
-- Solche Fälle wie "Erbbaurecht an Grundstück" oder "Wohnungs-/Teileigentum an aufgeteiltes Grundstück"
-- oder "Miteigentum an aufteteiltes Grundstück" fehlen in deisere Auswertung.
-- Dazu siehe: "rechte_eines_eigentuemers".

-- Das Ergbenis ist gedacht für den Export als CSV und Weiterverarbeitung mit einer Tabellenkalkulation
-- oder einer einfachen Datenbank.

-- Auch ein Export als Shape ist moeglich (dafuer: geom hinzugefuegt, Feldnamen gekuerzt)
-- Kommando:
--  pgsql2shp -h localhost -p 5432 -f "/data/.../alkis_fs_gemeinde.shp"  [db-name]  public.flurstuecke_eines_eigentuemers

-- Übersicht der Tabellen:
--
-- Person <benennt< NamNum. >istBestandteilVon> Blatt <istBestandteilVon< Stelle >istGebucht> Flurstueck
--                                              *-> Bezirk                *-> Buchungsart     *-> Gemarkung

-- Wobei ">xxx>" = JOIN über die Verbindungs-Tabelle "alkis_beziehungen" mit der Beziehungsart "xxx".

CREATE OR REPLACE VIEW flurstuecke_eines_eigentuemers 
AS 
   SELECT 
      k.bezeichnung                AS gemarkung, 
      k.gemarkungsnummer           AS gemkg_nr, 
      f.flurnummer                 AS flur, 
      f.zaehler                    AS fs_zaehler, 
      f.nenner                     AS fs_nenner, 
      f.amtlicheflaeche            AS flaeche, 
      f.wkb_geometry               AS geom,  -- fuer Export als Shape
   -- g.bezirk, 
      b.bezeichnung                AS bezirkname,
      g.buchungsblattnummermitbuchstabenerweiterung AS gb_blatt, 
      g.blattart, 
      s.laufendenummer             AS bvnr, 
      art.bezeichner               AS buchgsart, 
   -- s.zaehler || '/' || s.nenner AS buchg_anteil, 
      n.laufendenummernachdin1421  AS name_num, 
   -- n.zaehler || '/' || n.nenner AS nam_anteil, 
      p.nachnameoderfirma          AS nachname --, 
   -- p.vorname 
   FROM       ax_person              p
        JOIN  alkis_beziehungen      bpn  ON bpn.beziehung_zu  = p.gml_id 
        JOIN  ax_namensnummer        n    ON bpn.beziehung_von =n.gml_id 
        JOIN  alkis_beziehungen      bng  ON n.gml_id = bng.beziehung_von 
        JOIN  ax_buchungsblatt       g    ON bng.beziehung_zu = g.gml_id 
        JOIN  ax_buchungsblattbezirk b    ON g.land = b.land AND g.bezirk = b.bezirk 
        JOIN  alkis_beziehungen      bgs  ON bgs.beziehung_zu = g.gml_id 
        JOIN  ax_buchungsstelle      s    ON s.gml_id = bgs.beziehung_von 
        JOIN  ax_buchungsstelle_buchungsart art ON s.buchungsart = art.wert 
        JOIN  alkis_beziehungen      bsf  ON bsf.beziehung_zu = s.gml_id
        JOIN  ax_flurstueck          f    ON f.gml_id = bsf.beziehung_von 
        JOIN  ax_gemarkung           k    ON f.land = k.land AND f.gemarkungsnummer = k.gemarkungsnummer 
   WHERE p.nachnameoderfirma LIKE 'Gemeinde %'   -- ** Bei Bedarf anpassen!
     AND bpn.beziehungsart = 'benennt'           -- Namennummer     >> Person
     AND bng.beziehungsart = 'istBestandteilVon' -- Namensnummer    >> Grundbuch
     AND bgs.beziehungsart = 'istBestandteilVon' -- Buchungs-Stelle >> Grundbuch
     AND bsf.beziehungsart = 'istGebucht'        -- Flurstueck      >> Buchungs-Stelle
     AND p.endet IS NULL AND n.endet IS NULL AND g.endet IS NULL AND b.endet IS NULL
     AND s.endet IS NULL AND f.endet IS NULL AND k.endet IS NULL
   ORDER BY k.bezeichnung, f.flurnummer, f.zaehler, f.nenner, g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung, s.laufendenummer;
COMMENT ON VIEW flurstuecke_eines_eigentuemers IS 'Muster für Export: Suchkriteriumnach Bedarf anpassen.';

-- Rechte eines Eigentümers
-- ------------------------
-- Dieser View sucht speziell die Fälle wo eine Buchungsstelle ein Recht "an" einer anderen Buchungsstelle hat.
--  - "Erbbaurecht *an* Grundstück" 
--  - "Wohnungs-/Teileigentum *an* Aufgeteiltes Grundstück"
--  - "Miteigentum *an* Aufteteiltes Grundstück"
-- Suchkriterium ist der Name des Eigentümers auf dem "herrschenden" Grundbuch, also dem Besitzer des Rechtes.

-- Diese Fälle fehlen im View "flurstuecke_eines_eigentuemers".

-- Übersicht der Tabellen:
-- Person <benennt< NamNum. >istBestandteilVon> Blatt <istBestandteilVon< Stelle-h >an> Stelle-d >istGebucht> Flurstueck
-- Wobei ">xxx>" = JOIN über die Verbindungs-Tabelle "alkis_beziehungen" mit der Beziehungsart "xxx".

CREATE OR REPLACE VIEW rechte_eines_eigentuemers 
AS
   SELECT 
      k.bezeichnung                AS gemarkung, 
      k.gemarkungsnummer           AS gemkg_nr, 
      f.flurnummer                 AS flur, 
      f.zaehler                    AS fs_zaehler, 
      f.nenner                     AS fs_nenner, 
      f.amtlicheflaeche            AS flaeche, 
      f.wkb_geometry               AS geom,  -- fuer Export als Shape
   -- g.bezirk, 
      b.bezeichnung                AS bezirkname,
      g.buchungsblattnummermitbuchstabenerweiterung AS gb_blatt, 
   -- g.blattart, 
      sh.laufendenummer            AS bvnr_herr, 
      sh.zaehler || '/' || sh.nenner AS buchg_anteil_herr, 
      arth.bezeichner              AS buchgsa_herr, 
      bss.beziehungsart            AS bez_art,
      artd.bezeichner              AS buchgsa_dien, 
      sd.laufendenummer            AS bvnr_dien, 
   -- sd.zaehler || '/' || sd.nenner AS buchg_anteil_dien,
      n.laufendenummernachdin1421  AS name_num, 
   -- n.zaehler || '/' || n.nenner AS nam_anteil, 
      p.nachnameoderfirma          AS nachname --,  
   -- p.vorname 
   FROM       ax_person              p
        JOIN  alkis_beziehungen      bpn  ON bpn.beziehung_zu  = p.gml_id 
        JOIN  ax_namensnummer        n    ON bpn.beziehung_von =n.gml_id 
        JOIN  alkis_beziehungen      bng  ON n.gml_id = bng.beziehung_von 
        JOIN  ax_buchungsblatt       g    ON bng.beziehung_zu = g.gml_id 
        JOIN  ax_buchungsblattbezirk b    ON g.land = b.land AND g.bezirk = b.bezirk 
        JOIN  alkis_beziehungen      bgs  ON bgs.beziehung_zu = g.gml_id 
        JOIN  ax_buchungsstelle      sh   ON sh.gml_id = bgs.beziehung_von  -- herrschende Buchung
        JOIN  ax_buchungsstelle_buchungsart arth ON sh.buchungsart = arth.wert 
        JOIN  alkis_beziehungen      bss  ON sh.gml_id = bss.beziehung_von
        JOIN  ax_buchungsstelle      sd   ON sd.gml_id = bss.beziehung_zu   -- dienende Buchung
        JOIN  ax_buchungsstelle_buchungsart artd ON sd.buchungsart = artd.wert 
        JOIN  alkis_beziehungen      bsf  ON bsf.beziehung_zu = sd.gml_id
        JOIN  ax_flurstueck          f    ON f.gml_id = bsf.beziehung_von 
        JOIN  ax_gemarkung           k    ON f.land = k.land AND f.gemarkungsnummer = k.gemarkungsnummer 
   WHERE p.nachnameoderfirma LIKE 'Stadt %'   -- ** Bei Bedarf anpassen!
     AND bpn.beziehungsart = 'benennt'           -- Namennummer     >> Person
     AND bng.beziehungsart = 'istBestandteilVon' -- Namensnummer    >> Grundbuch
     AND bgs.beziehungsart = 'istBestandteilVon' -- B-Stelle herr   >> Grundbuch
     AND bss.beziehungsart in ('an','zu')        -- B-Stelle herr.  >> B-Stelle dien.
     AND bsf.beziehungsart = 'istGebucht'        -- Flurstueck      >> B-Stelle dien
     AND p.endet IS NULL AND n.endet IS NULL AND g.endet IS NULL AND b.endet IS NULL
     AND sh.endet IS NULL AND sd.endet IS NULL AND f.endet IS NULL AND k.endet IS NULL
   ORDER BY k.bezeichnung, f.flurnummer, f.zaehler, f.nenner, g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung, sh.laufendenummer;
COMMENT ON VIEW rechte_eines_eigentuemers IS 'Muster für Export: Suchkriteriumnach Bedarf anpassen. Dies ergänzt "flurstuecke_eines_eigentuemers" um die Fälle mit besonderen Buchungen.';

-- Die 2 Views nur fuer Entwicklung: 

-- 	CREATE OR REPLACE VIEW beziehungen_redundant 
-- 	AS
-- 	 SELECT *
-- 	   FROM alkis_beziehungen AS bezalt
-- 	   WHERE EXISTS
-- 		   (SELECT ogc_fid
-- 			 FROM alkis_beziehungen AS bezneu
-- 			WHERE bezalt.beziehung_von = bezneu.beziehung_von
-- 			  AND bezalt.beziehung_zu  = bezneu.beziehung_zu
-- 			  AND bezalt.beziehungsart = bezneu.beziehungsart
-- 			  AND bezalt.ogc_fid       < bezneu.ogc_fid
-- 			);
-- 	COMMENT ON VIEW beziehungen_redundant IS 'Datenanalyse: alkis_beziehungen zu denen es eine identische neue Version gibt. Fehlersuche bei PostNAS-Trigger für Replace.';
--
-- 	CREATE OR REPLACE VIEW beziehungen_redundant_in_delete
-- 	AS
-- 	SELECT *
-- 	 FROM alkis_beziehungen AS bezalt
-- 	 WHERE EXISTS
-- 		   (SELECT ogc_fid
-- 			 FROM alkis_beziehungen AS bezneu
-- 			WHERE bezalt.beziehung_von = bezneu.beziehung_von
-- 			  AND bezalt.beziehung_zu  = bezneu.beziehung_zu
-- 			  AND bezalt.beziehungsart = bezneu.beziehungsart
-- 			  AND bezalt.ogc_fid       < bezneu.ogc_fid
-- 			)
-- 		 -- mit dem Zusatz nur die Faelle aus dem letzten Durchlauf,
-- 		 -- die aktuell noch in der Delete-Tabelle stehen
-- 		 AND EXISTS
-- 			(SELECT ogc_fid
-- 			 FROM delete
-- 			 WHERE bezalt.beziehung_von = substr(featureid, 1, 16)
-- 				OR bezalt.beziehung_zu  = substr(featureid, 1, 16)
-- 			);
-- 	COMMENT ON VIEW beziehungen_redundant_in_delete IS 'Datenanalyse: alkis_beziehungen zu denen es eine identische neue Version gibt und wo das Objekt noch in der delete-Tabelle vorkommt. Fehlersuche bei PostNAS-Trigger für Replace.';


-- Suche nach Fehler durch "Replace"
-- Wenn ax_flurstueck über "replace" ausgetauscht wird und dabei gleichzeitig eine andere 
-- Buchungsstelle bekommt, dann bleibt die alte Buchungsstelle in den alkis_beziehungen.
-- Mail PostNAS Mailingliste von 2013-02-20
CREATE OR REPLACE VIEW mehrfache_buchung_zu_fs
AS
  SELECT f.gml_id, count(b.ogc_fid) AS anzahl
    FROM ax_flurstueck f
    JOIN alkis_beziehungen b
      ON f.gml_id = b.beziehung_von 
  WHERE b.beziehungsart = 'istGebucht'
  GROUP BY f.gml_id
  HAVING count(b.ogc_fid) > 1;

-- Noch einfacher? - Auch ohne JOIN wird das selbe Ergebnis geliefert.
-- Doppelte Verweise zählen ohne zu prüfen, ob die gml_id in ax_flurstueck existiert.
--   SELECT b.beziehung_von, count(b.ogc_fid) AS anzahl
--     FROM alkis_beziehungen b
--    WHERE b.beziehungsart = 'istGebucht'
--   GROUP BY b.beziehung_von
--   HAVING count(b.ogc_fid) > 1;

COMMENT ON VIEW mehrfache_buchung_zu_fs 
 IS 'Fehler: Nach replace von ax_flurtstueck mit einer neuen ax_buchungsstelle bleibt die alte Verbindung in alkis_beziehungen';


-- Suche nach Fehler durch "Replace"
-- Eine Hausnummer darf nur einem Gebaeude zugeordnet werden.
-- Das verschieben der Relation 
--   ax_gebaeude   >von>zeigtAuf>zu>  ax_lagebezeichnungmithausnummer
-- fuehrt möglicherweise dazu, dass die alte Relation nicht gelöscht wird.
-- Die angezeigten Fälle sind potentielle Fehler.

CREATE OR REPLACE VIEW fehler_hausnummer_mehrfach_verwendet
AS
 SELECT l.gml_id, l.gemeinde, l.lage, l.hausnummer 
   FROM ax_gebaeude g
   JOIN alkis_beziehungen b ON b.beziehung_von = g.gml_id
   JOIN ax_lagebezeichnungmithausnummer l ON b.beziehung_zu = l.gml_id
  WHERE b.beziehungsart = 'zeigtAuf'
  GROUP BY l.gml_id, l.gemeinde, l.lage, l.hausnummer
  HAVING count(g.gml_id) > 1;

COMMENT ON VIEW fehler_hausnummer_mehrfach_verwendet
 IS 'Fehler: Nach replace von ax_lagebezeichnungmithausnummer mit einem neuen ax_gebaeude bleibt die alte Verbindung in alkis_beziehungen';


-- Der umgekehrt Fall ist erlaubt.
-- Gebäude hat mehrere Nummern.

CREATE OR REPLACE VIEW adressen_zu_gebauede_mit_mehreren_hausnummern
AS
 SELECT l.gml_id, l.gemeinde, l.lage, l.hausnummer -- Anzeige der Adressfelder
 FROM ax_gebaeude g1
   JOIN alkis_beziehungen b ON b.beziehung_von = g1.gml_id
   JOIN ax_lagebezeichnungmithausnummer l ON b.beziehung_zu = l.gml_id
  WHERE b.beziehungsart = 'zeigtAuf' AND g1.gml_id IN -- Subquery sucht Gebäude mit meherern Hausnummen
   (SELECT g2.gml_id 
    FROM ax_gebaeude g2
    JOIN alkis_beziehungen b ON b.beziehung_von = g2.gml_id
    JOIN ax_lagebezeichnungmithausnummer l ON b.beziehung_zu = l.gml_id
   WHERE b.beziehungsart = 'zeigtAuf'
   GROUP BY g2.gml_id 
   HAVING count(l.gml_id) > 1);

COMMENT ON VIEW adressen_zu_gebauede_mit_mehreren_hausnummern
 IS 'Gebäude mit mehreren Hausnummern suchen (ist erlaubt) und dazu die Adressen anzeigen.';


-- Analyse der Buchungs-Arten im Bestand
CREATE OR REPLACE VIEW buchungsarten_vorkommend
AS
  SELECT a.wert, a.bezeichner, 
         count(b.gml_id) AS anzahl_buchungen
    FROM ax_buchungsstelle_buchungsart a
    JOIN ax_buchungsstelle b  ON a.wert = b.buchungsart
GROUP BY a.wert, a.bezeichner
ORDER BY a.wert, a.bezeichner;

COMMENT ON VIEW buchungsarten_vorkommend
 IS 'Welche Arten von Buchungsart kommen in dieser Datenbank tätsächlich vor?.';


-- Analyse: Fälle mit Erbbaurecht
-- Benutzt den Baustein-View "doppelverbindung"
CREATE OR REPLACE VIEW erbbaurechte_suchen
AS
  SELECT f.gml_id, 
  --f.flurstueckskennzeichen,
    f.gemarkungsnummer || '-' || f.flurnummer || '-' || f.zaehler AS fssuch, f.nenner
   FROM ax_flurstueck    f 
   JOIN doppelverbindung d     -- beide Fälle über Union-View: direkt und über Recht von BS an BS
     ON d.fsgml = f.gml_id 
   JOIN ax_buchungsstelle s    -- Buchungs-Stelle
     ON d.bsgml = s.gml_id 
   WHERE s.buchungsart = 2101;

COMMENT ON VIEW erbbaurechte_suchen
 IS 'Suche nach Fällen mit Buchungsrt 2101=Erbbaurecht';


-- Probleme mit der Trigger-Function "update_fields_beziehungen()"
-- Manchmal kann zu einer gml_id in "alkis_beziehungen" die zuständige Tabelle nicht gefunden werden.
-- Nach Änderung der Trigger-Function am 10.12.2013 wird die Beziehung trotzdem eingetragen,
-- nur die Felder "von_typename" und "beginnt" bleiben leer.
-- 2014-01-31: Dieser Trigger wird nicht mehr verwendet.

     -- Diese Fälle anzeigen:
--     CREATE OR REPLACE VIEW beziehungsproblem_faelle
--    AS
--       SELECT *
--        FROM alkis_beziehungen
--        WHERE beginnt IS NULL;
--     COMMENT ON VIEW beziehungsproblem_faelle
--      IS 'Fehlersuche: Im Trigger "update_fields_beziehungen()" wurde das Objekt in seiner Tabelle nicht gefunden, darum kein "beginnt" in "alkis_beziehungen" eingetragen.';

     -- Wie viele sind das?
--     CREATE OR REPLACE VIEW beziehungsproblem_zaehler
--     AS
--       SELECT count(ogc_fid) AS anzahl
--         FROM alkis_beziehungen
--        WHERE beginnt IS NULL;
--     COMMENT ON VIEW beziehungsproblem_faelle
--      IS 'Fehlersuche: Wie oft fehlt das beginnt-Feld in alkis_beziehungen?';


-- Suchen von Gewannenbezeichnungen, die auch als Straßenname verwendet werden.
-- Diese Fälle führen möglicherweise zu unvollständiger Ausgabe beim Export "alle Flurstücke an einer Straße"
-- weil nur Lagebezeichnung MIT und OHNE Hausnummer gesucht wird, aber keine gleich lautende Gewanne.
CREATE OR REPLACE VIEW strasse_als_gewanne
AS
  SELECT k.gemeinde, k.lage AS strassenschluessel,
      -- k.bezeichnung      AS strassenname,
         o.unverschluesselt AS gewanne,
         count(fo.gml_id) AS anzahl_fs_gewanne
  FROM ax_lagebezeichnungkatalogeintrag k   -- Straßentabelle
  JOIN ax_lagebezeichnungohnehausnummer o   -- Gewanne
    ON k.bezeichnung = o.unverschluesselt   -- Gleiche Namen
  -- Join Gewanne auf Flurstücke um nur solche Fälle anzuzeigen, die verwendet werden 
  -- UND die auch in der gleichen Gemeinde liegen.
  -- Sonst könnte zufällige Namensgleichheiten aus verschiedenen Gemeinden geben. 
  JOIN alkis_beziehungen vo
    ON o.gml_id=vo.beziehung_zu AND vo.beziehungsart= 'zeigtAuf' 
  JOIN ax_flurstueck fo
    ON fo.gml_id=vo.beziehung_von
 WHERE fo.gemeinde = k.gemeinde  -- Gewanne wird für ein Flst. in gleicher Gemeinde verwendet, wie der Straßenschlüssel
  GROUP BY k.gemeinde, k.lage, o.unverschluesselt --, k.bezeichnung
  ORDER BY k.gemeinde, k.lage, o.unverschluesselt --, k.bezeichnung
  ;

COMMENT ON VIEW strasse_als_gewanne
 IS 'Gewannenbezeichnungen, die auch als Straßenname verwendet werden. Mit Flurstücks-Zähler.';


-- Wie zuvor, aber die Flurstücke werden hier nicht nur gezählt sondern auch aufgelistet.
-- das Format des Flusrtückskennzeichens kann in die Mapbender-Navigation eingegeben werden.
CREATE OR REPLACE VIEW strasse_als_gewanne_flst
AS
  SELECT -- fo.gml_id, 
         fo.gemarkungsnummer || '-' || fo.flurnummer || '-' || fo.zaehler::text || COALESCE ('/' || fo.nenner::text, '') AS flstkennz,
         k.gemeinde, 
         o.unverschluesselt AS gewanne,
      -- k.bezeichnung AS strassenname,
         k.lage        -- AS strassen_schluessel
  FROM ax_lagebezeichnungkatalogeintrag k   -- Straßentabelle
  JOIN ax_lagebezeichnungohnehausnummer o   -- Gewanne
    ON k.bezeichnung = o.unverschluesselt   -- Gleiche Namen 
  JOIN alkis_beziehungen vo
    ON o.gml_id=vo.beziehung_zu AND vo.beziehungsart= 'zeigtAuf' 
  JOIN ax_flurstueck fo
    ON fo.gml_id=vo.beziehung_von
 WHERE fo.gemeinde = k.gemeinde  -- Gewanne wird für ein Flst. in gleicher Gemeinde verwendet, wie der Straßenschlüssel
  ORDER BY fo.gemarkungsnummer, fo.flurnummer, fo.zaehler, k.gemeinde, k.bezeichnung;

COMMENT ON VIEW strasse_als_gewanne_flst
 IS 'Flurstücke mit Gewannenbezeichnungen, die auch als Straßenname verwendet werden.';



-- Suche nach Fehlern in den Daten, die moeglicherweise aus der Migration stammen und
-- im Rahmen der Nachmigration noch korrigiert werden muessen.

CREATE OR REPLACE VIEW nachmigration_aehnliche_anschriften
AS
  SELECT DISTINCT p.gml_id, p.nachnameoderfirma, p.vorname, 
        a1.ort_post, a1.strasse AS strasse1, a2.strasse AS strasse2, a1.hausnummer
     -- , b1.import_id AS import1, b2.import_id AS import2
    FROM ax_person         p
    JOIN alkis_beziehungen b1 ON b1.beziehung_von=p.gml_id
    JOIN ax_anschrift      a1 ON a1.gml_id=b1.beziehung_zu
    JOIN alkis_beziehungen b2 ON b2.beziehung_von=p.gml_id
    JOIN ax_anschrift      a2 ON a2.gml_id=b2.beziehung_zu
    WHERE b1.beziehungsart='hat' 
      AND b2.beziehungsart='hat'
      AND a1.gml_id    <>  a2.gml_id
      AND a1.ort_post   =  a2.ort_post
      AND a1.strasse    like trim(a2.strasse, '.') || '%'
      AND a1.hausnummer =  a2.hausnummer
    ORDER BY p.nachnameoderfirma, p.vorname;

COMMENT ON VIEW nachmigration_aehnliche_anschriften
 IS 'Zu einer Person gibt es mehrere Anschriften, die in Ort und Hausnummer identisch sind und beim Straßennemen entweder auch identisch sind oder eine Abkürzung mit Punkt enthalten.';


-- END --