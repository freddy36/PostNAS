-- =====
-- ALKIS
-- =====

--  PostNAS 0.8

--  -----------------------------------------
--  Sichten für Fehlersuche und Daten-Analyse
--  -----------------------------------------

--  Dieses SQL braucht nur bei Bedarf in einer PostNAS-DB verarbeitet werden.
--  Es werden zusätzliche Views eingerichtet, die nur bei Fehlersuche und Analyse (vom Entwickler) benötigt werden.

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
--  2014-09-02 Tabelle "alkis_beziehungen" überflüssig machen. Relationen nun über Spalten in den Objekttabellen. 
--  2014-09-11 Neu: View "fehlersuche_namensanteile_je_blatt", substring(gml_id) bei Relation-Join, mehr "endet IS NULL"

-- ToDo: Einige Views sind sehr langsam geworden. Z.B. exp_csv welcher doppelverbindung verwendet.
--       Dadurch Export aus Bauchauskunft sehr langsam!
--       Derzeit provisorische Version von "doppelverbindung" (schnell aber nicht ganz korrrekt).

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

/*  -- korrekte Version, leider unerträglich langsam, z.B. beim Export von CSV aus der Auskunft

CREATE OR REPLACE VIEW public.doppelverbindung
AS
  -- FS >istGebucht> Buchungstelle
  SELECT f1.gml_id              AS fsgml,    -- gml_id Flurstück
         b1.gml_id              AS bsgml,    -- gml_id Buchungs
         0                      AS ba_dien
    FROM ax_flurstueck f1
    JOIN ax_buchungsstelle b1   ON f1.istgebucht = substring(b1.gml_id,1,16)
 UNION
  -- FS >istGebucht> Buchungstelle  <an<  Buchungstelle
  SELECT f2.gml_id              AS fsgml,    -- gml_id Flurstück
         b2.gml_id              AS bsgml,    -- gml_id Buchung - (herrschendes GB)
         dien.buchungsart       AS ba_dien   -- Ein Feld aus der Zwischen-Buchung zur Fall-Unterscheidung
    FROM ax_flurstueck f2
    JOIN ax_buchungsstelle dien ON f2.istgebucht = substring(dien.gml_id,1,16)
    JOIN ax_buchungsstelle b2   ON substring(dien.gml_id,1,16) = ANY (b2.an)  -- auch "zu" ?
   WHERE dien.endet IS NULL;   -- Für das zusätzliche Verbindungselement die Historie HIER ausschließen, 
                               -- Für andere Tabellen muss dies in dem View erfolgen, der dies verwendet.
*/

-- TEST: Schneller, wenn auf Subtring verzichtet wird?  Ja!
-- Aber: Verbindungen über aktualisierte, also lange ID's werden nicht gefunden.  
CREATE OR REPLACE VIEW public.doppelverbindung
AS
  -- FS >istGebucht> Buchungstelle
  SELECT f1.gml_id              AS fsgml,    -- gml_id Flurstück
         b1.gml_id              AS bsgml,    -- gml_id Buchungs
         0                      AS ba_dien
    FROM ax_flurstueck f1
    JOIN ax_buchungsstelle b1   ON f1.istgebucht = substring(b1.gml_id,1,16)
 UNION
  -- FS >istGebucht> Buchungstelle  <an<  Buchungstelle
  SELECT f2.gml_id              AS fsgml,    -- gml_id Flurstück
         b2.gml_id              AS bsgml,    -- gml_id Buchung - (herrschendes GB)
         dien.buchungsart       AS ba_dien   -- Ein Feld aus der Zwischen-Buchung zur Fall-Unterscheidung
    FROM ax_flurstueck f2
    JOIN ax_buchungsstelle dien ON f2.istgebucht = substring(dien.gml_id,1,16)
  --JOIN ax_buchungsstelle b2   ON substring(dien.gml_id,1,16) = ANY (b2.an)    -- korrekt
    JOIN ax_buchungsstelle b2   ON           dien.gml_id       = ANY (b2.an)    -- schnell
   WHERE dien.endet IS NULL;   -- Nur für das zusätzliche Verbindungselement die Historie HIER ausschließen, 
                               -- Für andere Tabellen muss dies in dem View erfolgen, der dies verwendet.

COMMENT ON VIEW public.doppelverbindung 
 IS 'ALKIS-Beziehung von Flurstück zu Buchung. UNION-Zusammenfassung des einfachen Falls mit direkter Buchung und des Falles mit Recht einer Buchungsstelle an einer anderen Buchungsstelle.
Dies ist ausschließlich gedacht zur Verwendung in anderen Views um diese einfacher zu machen.';

/* Test zur Zeitmessung

SELECT dien.gml_id, herr.gml_id
FROM ax_buchungsstelle dien 
JOIN ax_buchungsstelle herr  ON dien.gml_id = ANY (herr.an)
WHERE dien.endet IS NULL AND herr.endet IS NULL
LIMIT 300;
-- 78 ms

SELECT dien.gml_id, herr.gml_id
FROM ax_buchungsstelle dien 
JOIN ax_buchungsstelle herr  ON substring(dien.gml_id,1,16) = ANY (herr.an)
WHERE dien.endet IS NULL AND herr.endet IS NULL
LIMIT 300;
-- 19454 ms


*/

-- Test-Ausgabe: Ein paar Fälle mit "Recht an"
--   SELECT * FROM doppelverbindung WHERE ba_dien > 0 LIMIT 20;
-- Nach Umstellung auf PostNAS 0.8 - mit ANY() und Substring - sehr lange Antwortzeit in PG 8.4

-- Ein View, der die Verbindung von Flurstück zur Straßentabelle für zwei verschiedene Fälle herstellt.
-- Einmal über die Lagebezeichnung MIT Hausnummer und einmal OHNE.
-- Dies kann als "Mittelstück" in den anderen Views eingefügt werden.

--           DROP VIEW public.flst_an_strasse;
CREATE OR REPLACE VIEW public.flst_an_strasse
AS
  -- Flurstück >weistAuf> ax_lagebezeichnungMIThausnummer <JOIN> ax_lagebezeichnungkatalogeintrag
  SELECT fm.gml_id AS fsgml,
         sm.gml_id AS stgml,                 -- Filter: gml_id der Straße
         'm' AS fall                         -- Sätze unterschieden: Mit HsNr
    FROM ax_flurstueck fm                    -- Flurstück Mit
    JOIN ax_lagebezeichnungmithausnummer lm  -- Lage MIT
      ON substring(lm.gml_id,1,16) = ANY (fm.weistauf)  
    JOIN ax_lagebezeichnungkatalogeintrag sm
      ON lm.land=sm.land AND lm.regierungsbezirk=sm.regierungsbezirk AND lm.kreis=sm.kreis AND lm.gemeinde=sm.gemeinde AND lm.lage=sm.lage 
   WHERE lm.endet IS NULL AND fm.endet IS NULL -- nichts Historisches
 UNION
  -- Flurstück >zeigtAuf> ax_lagebezeichnungOHNEhausnummer <JOIN> ax_lagebezeichnungkatalogeintrag
  SELECT fo.gml_id AS fsgml,
         so.gml_id AS stgml,                 -- Filter: gml_id der Straße
         'o' AS fall                         -- Sätze unterschieden: Ohne HsNr
    FROM ax_flurstueck fo                    -- Flurstück OHNE
    JOIN ax_lagebezeichnungohnehausnummer lo -- Lage OHNE
      ON substring(lo.gml_id,1,16) = ANY (fo.zeigtauf)  
    JOIN ax_lagebezeichnungkatalogeintrag so -- Straße OHNE
      ON lo.land=so.land AND lo.regierungsbezirk=so.regierungsbezirk AND lo.kreis=so.kreis AND lo.gemeinde=so.gemeinde AND lo.lage=so.lage
   WHERE lo.endet IS NULL AND fo.endet IS NULL; -- nichts Historisches

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
  --s.zaehler, s.nenner,                                 -- Anteil des GB am FS, einzelne Felder
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
  JOIN ax_buchungsblatt  gb             -- Buchung >istBestandteilVon> Grundbuchblatt
    ON substring(gb.gml_id,1,16) = s.istbestandteilvon
  JOIN ax_buchungsblattbezirk z 
    ON gb.land=z.land AND gb.bezirk=z.bezirk 
  JOIN ax_namensnummer nn               -- Blatt <istBestandteilVon< NamNum
    ON substring(gb.gml_id,1,16) = nn.istbestandteilvon
  JOIN ax_person p                      -- NamNum >benennt> Person 
    ON substring(p.gml_id,1,16) = nn.benennt
  LEFT JOIN ax_anschrift a 
    ON substring(a.gml_id,1,16) = ANY (p.hat)

  -- 2mal "LEFT JOIN" verdoppelt die Zeile in der Ausgabe. Darum als Subquery in Spalten packen:
  -- Noch mal "GB -> NamNum", aber dieses Mal für "Rechtsgemeinschaft".
  -- Kommt max. 1 mal je GB vor und hat keine Relation auf Person.
  LEFT JOIN
   ( SELECT gr.gml_id, r.artderrechtsgemeinschaft, r.beschriebderrechtsgemeinschaft 
       FROM ax_namensnummer r 
       JOIN ax_buchungsblatt gr
         ON r.istbestandteilvon = substring(gr.gml_id,1,16) -- Blatt <istBestandteilVon< NamNum (Rechtsgemeinschaft) 
      WHERE NOT r.artderrechtsgemeinschaft IS NULL ) AS rg -- Rechtsgemeinschaft
   ON rg.gml_id = gb.gml_id  -- zum GB

  WHERE f.endet IS NULL AND s.endet IS NULL and gb.endet IS NULL and nn.endet IS NULL AND p.endet IS NULL

  ORDER BY f.flurstueckskennzeichen, 
           gb.bezirk, gb.buchungsblattnummermitbuchstabenerweiterung, s.laufendenummer,
           nn.laufendenummernachdin1421;

COMMENT ON VIEW exp_csv 
 IS 'View für einen CSV-Export aus der Buchauskunft mit alkisexport.php. Generelle Struktur. Für eine bestimmte gml_id noch den Filter setzen.';


-- Variante des View "exp_csv":
-- Hier wird zusätzlich der Baustein "flst_an_strasse" verwendet.
-- Der Filter "WHERE stgml= " auf die "gml_id" von "ax_lagebezeichnungkatalogeintrag" sollte gesetzt werden
-- um alle Flurstücke zu bekommen, die an einer Straße liegen.

-- DROP           VIEW exp_csv_str;

CREATE OR REPLACE VIEW exp_csv_str
AS
 SELECT
    l.stgml,                                             -- Filter: gml_id aus "ax_lagebezeichnungkatalogeintrag"
                                                         -- UNTERSCHIED zu exp_csv)

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
  --s.zaehler, s.nenner,                                 -- Anteil des GB am FS, einzelne Felder
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
  JOIN ax_buchungsblatt  gb             -- Buchung >istBestandteilVon> Grundbuchblatt
    ON substring(gb.gml_id,1,16) = s.istbestandteilvon
  JOIN ax_buchungsblattbezirk z 
    ON gb.land=z.land AND gb.bezirk=z.bezirk 
  JOIN ax_namensnummer nn               -- Blatt <istBestandteilVon< NamNum
    ON substring(gb.gml_id,1,16) = nn.istbestandteilvon
  JOIN ax_person p                      -- NamNum >benennt> Person 
    ON substring(p.gml_id,1,16) = nn.benennt
  LEFT JOIN ax_anschrift a 
    ON substring(a.gml_id,1,16) = ANY (p.hat)

  -- 2mal "LEFT JOIN" verdoppelt die Zeile in der Ausgabe. Darum als Subquery in Spalten packen:
  -- Noch mal "GB -> NamNum", aber dieses Mal für "Rechtsgemeinschaft".
  -- Kommt max. 1 mal je GB vor und hat keine Relation auf Person.
  LEFT JOIN
   ( SELECT gr.gml_id, r.artderrechtsgemeinschaft, r.beschriebderrechtsgemeinschaft 
       FROM ax_namensnummer r 
       JOIN ax_buchungsblatt gr
         ON r.istbestandteilvon = substring(gr.gml_id,1,16) -- Blatt <istBestandteilVon< NamNum (Rechtsgemeinschaft) 
      WHERE NOT r.artderrechtsgemeinschaft IS NULL ) AS rg  -- Rechtsgemeinschaft
   ON rg.gml_id = gb.gml_id  -- zum GB

  WHERE f.endet IS NULL AND s.endet IS NULL and gb.endet IS NULL and nn.endet IS NULL AND p.endet IS NULL

  ORDER BY f.flurstueckskennzeichen, 
           gb.bezirk, gb.buchungsblattnummermitbuchstabenerweiterung, s.laufendenummer,
           nn.laufendenummernachdin1421;

COMMENT ON VIEW exp_csv_str 
 IS 'View für einen CSV-Export aus der Buchauskunft mit alkisexport.php. Liefert nur Flurstücke, die eine Lagebezeichnung MIT/OHNE Hausnummer haben. Dazu noch den Filter auf GML-ID der Straßentabelle setzen.';

-- Test: SELECT * FROM exp_csv_str WHERE stgml = 'DENW15AL100000Q8'; -- Veilchenstraße in Löhne


-- Analyse: Kann es mehr als 1 "Rechtsgemeinschaft" zu einem GB-Blatt geben? 
-- (Diese Frage stellte sich beim Design des View "exp_csv".)

-- In umgekehrter Reihenfolge löschen (Abhängigkeiten).
DROP VIEW IF EXISTS rechtsgemeinschaften_mehrfachzeilen;
DROP VIEW IF EXISTS rechtsgemeinschaften_zaehlen;
DROP VIEW IF EXISTS rechtsgemeinschaften_zum_grundbuch;

-- Schritt 1: alle vorhandenen Rechtsgemeinschaften

CREATE OR REPLACE VIEW rechtsgemeinschaften_zum_grundbuch
AS
 SELECT
     gb.gml_id AS gb_gml,
     gb.bezirk,
     gb.buchungsblattnummermitbuchstabenerweiterung AS gb_blatt,
     nn.gml_id AS nn_gml, nn.beginnt, nn.laufendenummernachdin1421, 
     nn.artderrechtsgemeinschaft AS adr,
     nn.beschriebderrechtsgemeinschaft
  FROM ax_buchungsblatt gb 
  JOIN ax_namensnummer  nn  ON substring(gb.gml_id,1,16) = nn.istbestandteilvon
  WHERE NOT nn.artderrechtsgemeinschaft IS NULL
    AND gb.endet IS NULL AND nn.endet IS NULL -- Historie weglassen
  ORDER BY gb.bezirk, gb.buchungsblattnummermitbuchstabenerweiterung, nn.laufendenummernachdin1421;

COMMENT ON VIEW rechtsgemeinschaften_zum_grundbuch 
 IS 'Rechtsgemeinschaften zum Grundbuchblatt.';

-- Schritt 2: Wo gibt es mehrere zu einem GB-Blatt

CREATE OR REPLACE VIEW rechtsgemeinschaften_zaehlen
AS
 SELECT gb_gml, bezirk, gb_blatt, count(adr) AS anzahl
   FROM rechtsgemeinschaften_zum_grundbuch
   GROUP BY gb_gml, bezirk, gb_blatt
   HAVING count(adr) > 1
   ORDER BY bezirk, gb_blatt;

COMMENT ON VIEW rechtsgemeinschaften_zaehlen 
 IS 'Rechtsgemeinschaften zum Grundbuchblatt zählen. Nur Anzeigen, wenn es mehrere gibt.';
-- Ergebnis: Ja, kann es geben

-- Schritt 3: alle vorhandenen Zeilen anzeigen zu den GB-Blättern, bei denen es mehrere gibt.
CREATE OR REPLACE VIEW rechtsgemeinschaften_mehrfachzeilen
AS
 SELECT * 
   FROM rechtsgemeinschaften_zum_grundbuch
  WHERE gb_gml IN (SELECT gb_gml FROM rechtsgemeinschaften_zaehlen);

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

-- Diese Fälle identifizieren und unterscheiden:

CREATE OR REPLACE VIEW flstnr_mit_manueller_position
AS 
 SELECT f.gml_id, 
        f.gemarkungsnummer || '-' || f.flurnummer || '-' || f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS such -- Suchstring für ALKIS-Navigation nach FS-Kennzeichen
   FROM ax_flurstueck f 
   JOIN ap_pto p ON substring(f.gml_id,1,16) = ANY(p.dientzurdarstellungvon) 
  WHERE f.endet IS NULL AND p.endet IS NULL;
-- TIPP: mit zusätzlichem LIMIT auftrufen!

COMMENT ON VIEW flstnr_mit_manueller_position 
  IS 'Sicht für Datenanalyse: Flurstücke MIT manuell gesetzter Position für die Präsentation der FS-Nr';

CREATE OR REPLACE VIEW flstnr_ohne_manuelle_position
AS 
 SELECT f.gml_id, 
        f.gemarkungsnummer || '-' || f.flurnummer || '-' || f.zaehler::text || COALESCE ('/' || f.nenner::text, '') AS such -- Suchstring für ALKIS-Navigation nach FS-Kennzeichen
 FROM   ax_flurstueck f 
 LEFT JOIN ap_pto p ON substring(f.gml_id,1,16) = ANY(p.dientzurdarstellungvon) 
 WHERE p.gml_id IS NULL
   AND f.endet IS NULL;
-- TIPP: mit zusätzlichem LIMIT aufrufen!

COMMENT ON VIEW flstnr_ohne_manuelle_position 
  IS 'Sicht für Datenanalyse: Flurstücke OHNE manuell gesetzte Position für die Präsentation der FS-Nr';


-- Umbruch im Label? z.B. "Schwimm-/nbecken"
-- Sind 2 Buchstaben in Mapfile bei "WRAP" möglich?
CREATE OR REPLACE VIEW texte_mit_umbruch 
AS 
 SELECT ogc_fid, schriftinhalt, art
   FROM ap_pto 
  WHERE NOT schriftinhalt IS NULL AND schriftinhalt LIKE '%/n%';

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
         r.artderfestlegung AS adfkey, -- Art der Festlegung - Key 
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
      ON r.land=d.land AND r.stelle=d.stelle 
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
 IS 'Welche Gemarkung liegt in welcher Gemeinde? Durch Verweise aus Flurstücken ermitteln.';


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

-- Verschluesselte Lagebezeichnung (Strasse und Hausnummer) für eine Gemeinde
-- Schlüssel der Gemeinde im Filter (WHERE) nach Bedarf anpassen!
CREATE OR REPLACE VIEW adressen_hausnummern
AS
    SELECT 
        s.bezeichnung AS strassenname, 
        g.bezeichnung AS gemeindename, 
        l.land, l.regierungsbezirk, l.kreis, l.gemeinde, 
        l.lage        AS strassenschluessel, l.hausnummer 
    FROM ax_lagebezeichnungmithausnummer l  
    JOIN ax_gemeinde g 
      ON l.kreis=g.kreis AND l.gemeinde=g.gemeinde 
    JOIN ax_lagebezeichnungkatalogeintrag s 
      ON l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND l.lage = s.lage
    WHERE l.gemeinde = '40';  -- '40' = Stadt Lage

COMMENT ON VIEW adressen_hausnummern IS 'Datenanalyse: Verschlüsselte Lagebezeichnung (Straße und Hausnummer) für eine Gemeinde. Schlüssel der Gemeinde nach Bedarf anpassen.';

-- Zuordnung Adressen zu Flurstuecken
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
      JOIN   ax_lagebezeichnungmithausnummer l   ON  substring(l.gml_id,1,16) = ANY (f.weistauf)
      JOIN   ax_gemeinde g   ON l.kreis=g.kreis  AND l.gemeinde=g.gemeinde 
      JOIN   ax_lagebezeichnungkatalogeintrag s  ON  l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND l.lage = s.lage
 --  WHERE l.gemeinde = '40'  -- ggf. Anpassen
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

-- Flurstücke eines Eigentümers
-- ----------------------------

-- Dieser View liefert nur die (einfache) Buchungsart "Grundstück"
-- Solche Fälle wie "Erbbaurecht an Grundstück" oder "Wohnungs-/Teileigentum an aufgeteiltes Grundstück"
-- oder "Miteigentum an aufgeteiltes Grundstück" fehlen in dieser Auswertung.
-- Dazu siehe: "rechte_eines_eigentuemers".

-- Das Ergebnis ist gedacht für den Export als CSV und Weiterverarbeitung mit einer Tabellenkalkulation
-- oder einer einfachen Datenbank.

-- Auch ein Export als Shape ist moeglich (dafür: geom hinzugefügt, Feldnamen gekürzt)
-- Kommando:
--  pgsql2shp -h localhost -p 5432 -f "/data/.../alkis_fs_gemeinde.shp"  [db-name]  public.flurstuecke_eines_eigentuemers

-- Übersicht der Tabellen:
--
-- Person <benennt< NamNum. >istBestandteilVon> Blatt <istBestandteilVon< Stelle >istGebucht> Flurstueck
--                                              *-> Bezirk                *-> Buchungsart     *-> Gemarkung

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
   FROM   ax_person              p
     JOIN ax_namensnummer        n   -- Namennummer >benennt> Person
       ON substring(p.gml_id,1,16) = n.benennt
     JOIN ax_buchungsblatt       g   -- Namensnummer >istBestandteilVon> Grundbuch
       ON n.istbestandteilvon = substring(g.gml_id,1,16)
     JOIN ax_buchungsblattbezirk b    ON g.land = b.land AND g.bezirk = b.bezirk 
     JOIN ax_buchungsstelle      s   -- Buchungs-Stelle >istBestandteilVon> Grundbuch
       ON s.istbestandteilvon = substring(g.gml_id,1,16)
     JOIN ax_buchungsstelle_buchungsart art 
       ON s.buchungsart = art.wert 
     JOIN ax_flurstueck          f  -- Flurstueck >istGebucht> Buchungs-Stelle
       ON f.istgebucht = substring(s.gml_id,1,16)
     JOIN ax_gemarkung           k    
       ON f.land = k.land AND f.gemarkungsnummer = k.gemarkungsnummer 
   WHERE p.nachnameoderfirma LIKE 'Stadt %'   -- ** Bei Bedarf anpassen!
     AND p.endet IS NULL AND n.endet IS NULL AND g.endet IS NULL AND b.endet IS NULL
     AND s.endet IS NULL AND f.endet IS NULL AND k.endet IS NULL
   ORDER BY k.bezeichnung, f.flurnummer, f.zaehler, f.nenner, g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung, s.laufendenummer;

COMMENT ON VIEW flurstuecke_eines_eigentuemers 
  IS 'Nur einfache Buchungsart "Grundstück". Muster für Export: Suchkriterium nach Bedarf anpassen.';


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

-- DROP VIEW rechte_eines_eigentuemers;
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
      artd.bezeichner              AS buchgsa_dien, 
      sd.laufendenummer            AS bvnr_dien, 
   -- sd.zaehler || '/' || sd.nenner AS buchg_anteil_dien,
      n.laufendenummernachdin1421  AS name_num, 
   -- n.zaehler || '/' || n.nenner AS nam_anteil, 
      p.nachnameoderfirma          AS nachname --,  
   -- p.vorname 
   FROM   ax_person              p
     JOIN ax_namensnummer        n    -- Namennummer >benennt> Person
       ON substring(p.gml_id,1,16) = n.benennt
     JOIN ax_buchungsblatt       g    -- Namensnummer >istBestandteilVon> Grundbuch
       ON n.istBestandteilVon = substring(g.gml_id,1,16)
     JOIN ax_buchungsblattbezirk b    
       ON g.land = b.land AND g.bezirk = b.bezirk 
     JOIN ax_buchungsstelle      sh  -- B-Stelle herr >istBestandteilVon> Grundbuch
       ON sh.istbestandteilvon = substring(g.gml_id,1,16) -- herrschende Buchung
     JOIN ax_buchungsstelle_buchungsart arth 
       ON sh.buchungsart = arth.wert 
     JOIN ax_buchungsstelle      sd   -- B-Stelle herr.  >an/zu> B-Stelle dien.
       ON (substring(sd.gml_id,1,16) = ANY(sh.an) OR substring(sd.gml_id,1,16) = ANY(sh.zu))
     JOIN ax_buchungsstelle_buchungsart artd 
       ON sd.buchungsart = artd.wert
     JOIN ax_flurstueck          f    -- Flurstueck  >istGebucht> B-Stelle dien     
       ON f.istgebucht = substring(sd.gml_id,1,16)
     JOIN ax_gemarkung           k    
       ON f.land = k.land AND f.gemarkungsnummer = k.gemarkungsnummer 
   WHERE p.nachnameoderfirma LIKE 'Stadt %'   -- ** Bei Bedarf anpassen!    
     AND p.endet IS NULL AND n.endet IS NULL AND g.endet IS NULL AND b.endet IS NULL
     AND sh.endet IS NULL AND sd.endet IS NULL AND f.endet IS NULL AND k.endet IS NULL
   ORDER BY k.bezeichnung, f.flurnummer, f.zaehler, f.nenner, g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung, sh.laufendenummer;

COMMENT ON VIEW rechte_eines_eigentuemers IS 'Muster für Export: Suchkriteriumnach Bedarf anpassen. Dies ergänzt "flurstuecke_eines_eigentuemers" um die Fälle mit besonderen Buchungen.';


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
   JOIN ax_lagebezeichnungmithausnummer l  
     ON substring(l.gml_id,1,16) = ANY(g.zeigtauf)
  WHERE g.endet IS NULL AND l.endet IS NULL
  GROUP BY l.gml_id, l.gemeinde, l.lage, l.hausnummer
  HAVING count(g.gml_id) > 1;

COMMENT ON VIEW fehler_hausnummer_mehrfach_verwendet
 IS 'Fehlersuche: Nach replace von ax_lagebezeichnungmithausnummer mit einem neuen ax_gebaeude bleibt die alte Verbindung?';

-- Ein Gebäude hat mehrere Nummern.
CREATE OR REPLACE VIEW adressen_zu_gebauede_mit_mehreren_hausnummern
AS
 SELECT g1.gml_id, l1.gemeinde, l1.lage, l1.hausnummer -- Anzeige der Adressfelder
   FROM ax_gebaeude g1
   JOIN ax_lagebezeichnungmithausnummer l1 ON l1.gml_id = ANY(g1.zeigtauf)
  WHERE g1.endet IS NULL AND l1.endet IS NULL 
    AND g1.gml_id IN -- Subquery sucht Gebäude mit meherern Hausnummen
   (SELECT g2.gml_id 
      FROM ax_gebaeude g2
      JOIN ax_lagebezeichnungmithausnummer l2 ON substring(l2.gml_id,1,16) = ANY(g2.zeigtauf)
     WHERE g2.endet IS NULL AND l2.endet IS NULL
     GROUP BY g2.gml_id 
   HAVING count(l2.gml_id) > 1)
   ORDER BY l1.gemeinde, l1.lage, l1.hausnummer;

COMMENT ON VIEW adressen_zu_gebauede_mit_mehreren_hausnummern
 IS 'Gebäude mit mehreren Hausnummern suchen (ist erlaubt) und dazu die Adressen anzeigen.';


-- Analyse der Buchungs-Arten im Bestand
CREATE OR REPLACE VIEW buchungsarten_vorkommend
AS
  SELECT a.wert, a.bezeichner, 
         count(b.gml_id) AS anzahl_buchungen
    FROM ax_buchungsstelle_buchungsart a
    JOIN ax_buchungsstelle b  ON a.wert = b.buchungsart
   WHERE b.endet IS NULL
GROUP BY a.wert, a.bezeichner
ORDER BY a.wert, a.bezeichner;

COMMENT ON VIEW buchungsarten_vorkommend
 IS 'Welche Arten von Buchungsart kommen in dieser Datenbank tätsächlich vor?.';


-- Analyse: Fälle mit Erbbaurecht
-- Benutzt den Baustein-View "doppelverbindung"

--   +++ BESSER: analog doppelverbindung direkt codieren

CREATE OR REPLACE VIEW erbbaurechte_suchen
AS
  SELECT f.gml_id, f.gemarkungsnummer || '-' || f.flurnummer || '-' || f.zaehler AS fssuch, f.nenner
   FROM ax_flurstueck    f 
   JOIN doppelverbindung d     -- beide Fälle über Union-View: direkt und über Recht von BS an BS
     ON d.fsgml = f.gml_id 
   JOIN ax_buchungsstelle s    -- Buchungs-Stelle
     ON d.bsgml = s.gml_id 
   WHERE s.buchungsart = 2101 AND f.endet IS NULL AND s.endet IS NULL;

COMMENT ON VIEW erbbaurechte_suchen
 IS 'Suche nach Fällen mit Buchungsrt 2101=Erbbaurecht';


-- Suchen von Gewannenbezeichnungen, die auch als Straßenname verwendet werden.
-- Diese Fälle führen möglicherweise zu unvollständiger Ausgabe beim Export "alle Flurstücke an einer Straße"
-- weil nur Lagebezeichnung MIT und OHNE Hausnummer gesucht wird, aber keine gleich lautende Gewanne.

-- DROP VIEW strasse_als_gewanne;
CREATE OR REPLACE VIEW strasse_als_gewanne
AS
  SELECT k.gemeinde, k.lage AS strassenschluessel,
         o.unverschluesselt AS gewanne_und_strasse, -- = k.bezeichnung = Straßenname
         count(f.gml_id) AS anzahl_fs_gewanne
  FROM ax_lagebezeichnungkatalogeintrag k   -- Straßentabelle
  JOIN ax_lagebezeichnungohnehausnummer o   -- Gewanne
    ON k.bezeichnung = o.unverschluesselt   -- Gleiche Namen
  -- Join Gewanne auf Flurstücke um nur solche Fälle anzuzeigen, die hier verwendet werden.
  -- UND die auch in der gleichen Gemeinde liegen.
  -- Sonst könnte zufällige Namensgleichheiten aus verschiedenen Gemeinden geben. 
  JOIN ax_flurstueck f               --  Flurst. >zeigtAuf>  Lage
    ON o.gml_id = ANY(f.zeigtauf)  
 WHERE f.gemeinde = k.gemeinde  -- Gewanne wird für ein Flst. in gleicher Gemeinde verwendet, wie der Straßenschlüssel
  GROUP BY k.gemeinde, k.lage, o.unverschluesselt
  ORDER BY k.gemeinde, k.lage, o.unverschluesselt;

COMMENT ON VIEW strasse_als_gewanne
 IS 'Gewannenbezeichnungen, die auch als Straßenname verwendet werden. Mit Flurstücks-Zähler.';


-- Wie zuvor, aber die Flurstücke werden hier nicht nur gezählt sondern auch aufgelistet.
-- das Format des Flusrtückskennzeichens kann in die Mapbender-Navigation eingegeben werden.

CREATE OR REPLACE VIEW strasse_als_gewanne_flst
AS
  SELECT fo.gemarkungsnummer || '-' || fo.flurnummer || '-' || fo.zaehler::text || COALESCE ('/' || fo.nenner::text, '') AS flstkennz,
         k.gemeinde, 
         o.unverschluesselt AS gewanne,
         k.lage        -- AS strassen_schluessel
  FROM ax_lagebezeichnungkatalogeintrag k   -- Straßentabelle
  JOIN ax_lagebezeichnungohnehausnummer o   -- Gewanne
    ON k.bezeichnung = o.unverschluesselt   -- Gleiche Namen 
   JOIN ax_flurstueck fo                    --  Flurst. >zeigtAuf>  Lage
    ON substring(o.gml_id,1,16) = ANY(fo.zeigtauf)  
 WHERE fo.gemeinde = k.gemeinde  -- Gewanne wird für ein Flst. in gleicher Gemeinde verwendet, wie der Straßenschlüssel
   AND k.endet IS NULL AND o.endet IS NULL AND fo.endet IS NULL 
  ORDER BY fo.gemarkungsnummer, fo.flurnummer, fo.zaehler, k.gemeinde, k.bezeichnung;

COMMENT ON VIEW strasse_als_gewanne_flst
 IS 'Flurstücke mit Gewannenbezeichnungen, die auch als Straßenname verwendet werden.';


-- Suche nach Fehlern in den Daten, die moeglicherweise aus der Migration stammen und
-- im Rahmen der Nachmigration noch korrigiert werden muessen.

CREATE OR REPLACE VIEW nachmigration_aehnliche_anschriften
AS
  SELECT DISTINCT p.gml_id, p.nachnameoderfirma, p.vorname, 
         a1.ort_post, a1.strasse AS strasse1, a2.strasse AS strasse2, a1.hausnummer
    FROM ax_person    p
    JOIN ax_anschrift a1 ON substring(a1.gml_id,1,16) = ANY(p.hat)
    JOIN ax_anschrift a2 ON substring(a2.gml_id,1,16) = ANY(p.hat)
   WHERE a1.gml_id <> a2.gml_id
      AND a1.ort_post =  a2.ort_post
      AND a1.strasse like trim(a2.strasse, '.') || '%'
      AND a1.hausnummer = a2.hausnummer
      AND p.endet IS NULL AND a1.endet IS NULL and a2.endet IS NULL
    ORDER BY p.nachnameoderfirma, p.vorname;

COMMENT ON VIEW nachmigration_aehnliche_anschriften
 IS 'Nachmigration? Zu einer Person gibt es mehrere Anschriften, die in Ort und Hausnummer identisch sind und beim Straßennemen entweder auch identisch sind oder eine Abkürzung mit Punkt enthalten.';


-- Bevor alle inversen Relationen im Schema auskommentiert werden,
-- noch mal in die Datenbank schauen, ob nicht doch eine davon gefüllt ist.
-- Nach dem Entfernen dieser Spalten wird der View nicht mehr funktionieren 
-- und wird darum ebenfalls auskommentiert.

/*
CREATE OR REPLACE VIEW nicht_gefuellte_inverse_relationen_spalten
AS
  SELECT 'ax_flurstueck' AS tabelle, 'beziehtsichaufflurstueck' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_flurstueck WHERE NOT beziehtsichaufflurstueck IS NULL
UNION
  SELECT 'ax_flurstueck' AS tabelle, 'gehoertanteiligzu' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_flurstueck WHERE NOT gehoertanteiligzu IS NULL
UNION
  SELECT 'ax_lagebezeichnungohnehausnummer' AS tabelle, 'beschreibt' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_lagebezeichnungohnehausnummer WHERE NOT beschreibt IS NULL
UNION
  SELECT 'ax_lagebezeichnungohnehausnummer' AS tabelle, 'gehoertzu' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_lagebezeichnungohnehausnummer WHERE NOT gehoertzu IS NULL
UNION
  SELECT 'ax_lagebezeichnungmithausnummer' AS tabelle, 'hat' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_lagebezeichnungmithausnummer WHERE NOT hat IS NULL
UNION
  SELECT 'ax_lagebezeichnungmithausnummer' AS tabelle, 'beziehtsichauf' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_lagebezeichnungmithausnummer WHERE NOT beziehtsichauf IS NULL
UNION
  SELECT 'ax_lagebezeichnungmithausnummer' AS tabelle, 'beziehtsichauchauf' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_lagebezeichnungmithausnummer WHERE NOT beziehtsichauchauf IS NULL
UNION
  SELECT 'ax_lagebezeichnungmithausnummer' AS tabelle, 'gehoertzu' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_lagebezeichnungmithausnummer WHERE NOT gehoertzu IS NULL
UNION
  SELECT 'ax_lagebezeichnungmithausnummer' AS tabelle, 'weistzum' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_lagebezeichnungmithausnummer WHERE NOT weistzum IS NULL
UNION
  SELECT 'ax_lagebezeichnungmitpseudonummer' AS tabelle, 'gehoertzu' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_lagebezeichnungmitpseudonummer WHERE NOT gehoertzu IS NULL
--UNION
--  -- ist gefüllt!
--  SELECT 'ax_georeferenziertegebaeudeadresse' AS tabelle, 'hatauch' AS spalte, 
--     count(gml_id) AS anzahl_eintraege
--  FROM ax_georeferenziertegebaeudeadresse WHERE NOT hatauch IS NULL
UNION
  SELECT 'ax_sicherungspunkt' AS tabelle, 'beziehtsichauf' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_sicherungspunkt WHERE NOT beziehtsichauf IS NULL
UNION
  SELECT 'ax_sicherungspunkt' AS tabelle, 'gehoertzu' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_sicherungspunkt WHERE NOT gehoertzu IS NULL
-- Punktort: ist gefüllt (nicht invers)
--UNION
--  SELECT 'ax_punktortag' AS tabelle, 'istteilvon' AS spalte, 
--     count(gml_id) AS anzahl_eintraege
--  FROM ax_punktortag WHERE NOT istteilvon IS NULL
--UNION
--  SELECT 'ax_punktortau' AS tabelle, 'istteilvon' AS spalte, 
--     count(gml_id) AS anzahl_eintraege
--  FROM ax_punktortau WHERE NOT istteilvon IS NULL
--UNION
--  SELECT 'ax_punktortta' AS tabelle, 'istteilvon' AS spalte, 
--     count(gml_id) AS anzahl_eintraege
--  FROM ax_punktortta WHERE NOT istteilvon IS NULL
UNION
  SELECT 'ax_person' AS tabelle, 'weistauf' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_person WHERE NOT weistauf IS NULL
UNION
  SELECT 'ax_person' AS tabelle, 'uebtaus' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_person WHERE NOT uebtaus IS NULL
UNION
  SELECT 'ax_person' AS tabelle, 'besitzt' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_person WHERE NOT besitzt IS NULL
UNION
  SELECT 'ax_person' AS tabelle, 'zeigtauf' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_person WHERE NOT zeigtauf IS NULL
UNION
  SELECT 'ax_person' AS tabelle, 'benennt' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_person WHERE NOT benennt IS NULL
UNION
  SELECT 'ax_anschrift' AS tabelle, 'beziehtsichauf' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_anschrift WHERE NOT beziehtsichauf IS NULL
UNION
  SELECT 'ax_anschrift' AS tabelle, 'gehoertzu' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_anschrift WHERE NOT gehoertzu IS NULL
UNION
  SELECT 'ax_verwaltung' AS tabelle, 'beziehtsichauf' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_verwaltung WHERE NOT beziehtsichauf IS NULL
UNION
  SELECT 'ax_vertretung' AS tabelle, 'vertritt' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_vertretung WHERE NOT vertritt IS NULL
UNION
  SELECT 'ax_buchungsblatt' AS tabelle, 'bestehtaus' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_buchungsblatt WHERE NOT bestehtaus IS NULL
UNION
  SELECT 'ax_buchungsstelle' AS tabelle, 'grundstueckbestehtaus' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_buchungsstelle WHERE NOT grundstueckbestehtaus IS NULL
UNION
  SELECT 'ax_gebaeude' AS tabelle, 'haengtzusammenmit' AS spalte, 
     count(gml_id) AS anzahl_eintraege
  FROM ax_gebaeude WHERE NOT haengtzusammenmit IS NULL
;

COMMENT ON VIEW nicht_gefuellte_relationen_spalten
 IS 'Überprüfung auf nicht gefüllte Inverse Relationen. 
Funktioniert nur, solange diese nicht entfernt wurden.';

*/

-- Daraus resultiert der folgende Patch für bereits angelegte Datenbanken:
/*
	ALTER TABLE ax_flurstueck                    DROP COLUMN beziehtsichaufflurstueck;
	ALTER TABLE ax_flurstueck                    DROP COLUMN gehoertanteiligzu;
	ALTER TABLE ax_lagebezeichnungohnehausnummer DROP COLUMN beschreibt;
	ALTER TABLE ax_lagebezeichnungohnehausnummer DROP COLUMN gehoertzu;
	ALTER TABLE ax_lagebezeichnungmithausnummer  DROP COLUMN hat;
	ALTER TABLE ax_lagebezeichnungmithausnummer  DROP COLUMN beziehtsichauf;
	ALTER TABLE ax_lagebezeichnungmithausnummer  DROP COLUMN beziehtsichauchauf;
	ALTER TABLE ax_lagebezeichnungmithausnummer  DROP COLUMN gehoertzu;
	ALTER TABLE ax_lagebezeichnungmithausnummer  DROP COLUMN weistzum;
	ALTER TABLE ax_lagebezeichnungmitpseudonummer DROP COLUMN gehoertzu;
	ALTER TABLE ax_sicherungspunkt               DROP COLUMN beziehtsichauf;
	ALTER TABLE ax_sicherungspunkt               DROP COLUMN gehoertzu;
	ALTER TABLE ax_person                        DROP COLUMN weistauf;
	ALTER TABLE ax_person                        DROP COLUMN uebtaus;
	ALTER TABLE ax_person                        DROP COLUMN besitzt;
	ALTER TABLE ax_person                        DROP COLUMN zeigtauf;
	ALTER TABLE ax_person                        DROP COLUMN benennt;
	ALTER TABLE ax_anschrift                     DROP COLUMN beziehtsichauf;
	ALTER TABLE ax_anschrift                     DROP COLUMN gehoertzu;
	ALTER TABLE ax_verwaltung                    DROP COLUMN beziehtsichauf;
	ALTER TABLE ax_vertretung                    DROP COLUMN vertritt;
	ALTER TABLE ax_buchungsblatt                 DROP COLUMN bestehtaus;
	ALTER TABLE ax_buchungsstelle                DROP COLUMN grundstueckbestehtaus;
	ALTER TABLE ax_gebaeude                      DROP COLUMN haengtzusammenmit;
*/

-- Anteile der Namensnummern am Blatt aufsummieren.
-- Blätter mit Rechtsverhältnis (Beschrieb) nicht beachten.
-- Anzeigen, wenn die Summe nicht 1 ergibt.
-- Keine Angabe in Zähler/Nenner wird als 1 gewertet.

-- Anlass zu dieser Auswertung war:
-- Wenn mit PostNAS 0.8 und Trigger "kill" (ohne Historie) eine NBA-Abgabe mit Abgabeart "3100 fallbezogen (mit Historie)"
-- konvertiert wird, dann wird Update nicht richtig verarbeitet.
-- Update setzt z.B. das endet-Datum an einen Namensnummer. Alte Namen verbleiben auf dem Grundbuch.

CREATE OR REPLACE VIEW fehlersuche_namensanteile_je_blatt
AS
  SELECT g.gml_id, g.bezirk || '-' || g.buchungsblattnummermitbuchstabenerweiterung AS kennzeichen, 
         sum(coalesce(n.zaehler/n.nenner, 1.0))::double precision AS summe_der_anteile
  FROM ax_buchungsblatt g
  JOIN ax_namensnummer n ON substring(g.gml_id,1,16) = n.istbestandteilvon
  WHERE g.endet IS NULL AND n.endet IS NULL
  GROUP BY g.gml_id, g.bezirk || '-' || g.buchungsblattnummermitbuchstabenerweiterung
  HAVING sum(coalesce(n.zaehler/n.nenner, 1)) <> 1.0::double precision
     AND (  -- die Fälle mit einer Rechtsgemeinschaft nicht verwenden
        SELECT gml_id 
        FROM ax_namensnummer nr 
        WHERE substring(g.gml_id,1,16) = nr.istbestandteilvon
          AND NOT nr.artderrechtsgemeinschaft IS NULL
          AND nr.endet IS NULL
        LIMIT 1
     ) IS NULL
  LIMIT 100;

COMMENT ON VIEW fehlersuche_namensanteile_je_blatt
 IS 'Suchen nach GB-Blättern bei denen die Summe der Anteile der Namensnummern nicht passt.
Mit Ausnahme von Rechtsverhältnissen sollte sie Summe der Brüche immer 1/1 ergeben.';

-- END --
