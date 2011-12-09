
-- Neue Tabelle "gemeinde_person" definieren UND laden.
--
-- Zusammenfassung der neuen Teile aus 2 Dateien zum Nachtragen in vorhandene Datenbanken
--
-- Laufzeit 
--  für eine Stadt       ca.  1 Minute
--  für ein  Kreisgebiet ca. 10 Minuten 


-- ** aus gemeinden_definition.sql

-- =======================================================
-- Tabelle fuer die Zuordnung vom Eigentümern zu Gemeinden
-- =======================================================

-- Die Feststellung, ob eine Person (Mit-) Eigentümer von mindestens einem
-- Flurstück in einer Gemeinde ist, geht über viele Relationen.
-- Dabei kann es mehrere Varianten geben.
-- Dies sollte nach dem Laden ermittelt und gespeichert werden, damit dies in
-- der Navigation auf einfache Art verwendet werden kann. 


-- DROP TABLE gemeinde_person;

CREATE TABLE gemeinde_person (
  land 			integer,
  regierungsbezirk	integer,
  kreis			integer,
  gemeinde		integer,
  person		character varying(16), 
  buchtyp		integer,
  CONSTRAINT gemeinde_person_pk PRIMARY KEY (gemeinde, person)
);


COMMENT ON TABLE  gemeinde_person                IS 'Person ist Eigentümer von mindestens einem Flurstück in der Gemeinde';
COMMENT ON COLUMN gemeinde_person.gemeinde       IS 'Gemeindenummer';
COMMENT ON COLUMN gemeinde_person.buchtyp        IS 'Typ der Buchung 1=direkt, 2=Recht einer Buchungsstele an andere Buchungsstelle';
COMMENT ON COLUMN gemeinde_person.person         IS 'gml_id von Person';

-- Index zum Filtern in der Buchauskunft
CREATE INDEX person_gemeinde  ON gemeinde_person (person, gemeinde);


-- =======================================================
-- VIEWs  fuer die Zuordnung vom Eigentümern zu Gemeinden
-- =======================================================

-- "Normale" Buchungen

CREATE VIEW gemeinde_person_typ1
AS
  SELECT DISTINCT
    p.gml_id          AS person, 
    g.land, g.regierungsbezirk, g.kreis, g.gemeinde

  FROM ax_person               p

-- Person < benennt < Namensnummer
  JOIN alkis_beziehungen      bpn  ON bpn.beziehung_zu   = p.gml_id  -- Bez. Person - Nummer
  JOIN ax_namensnummer         n   ON bpn.beziehung_von  = n.gml_id

-- Namensnummer > istBestandteilVon > Blatt
  JOIN alkis_beziehungen      bnb  ON bnb.beziehung_von  = n.gml_id  -- Bez. Nummer - Blatt
  JOIN ax_buchungsblatt        b   ON bnb.beziehung_zu   = b.gml_id

-- Blatt < istBestandteilVon < buchungsStelle
  JOIN alkis_beziehungen      bbg  ON bbg.beziehung_zu   = b.gml_id  -- Bez. Blatt  - Stelle
  JOIN ax_buchungsstelle       s   ON bbg.beziehung_von  = s.gml_id 

-- buchungsStelle < istGebucht < flurstück
  JOIN alkis_beziehungen      bsf  ON bsf.beziehung_zu   = s.gml_id  -- Bez. Stelle - Flurstück
  JOIN ax_flurstueck           f   ON bsf.beziehung_von  = f.gml_id 

  JOIN ax_gemarkung            k   ON f.land             = k.land 
                                  AND f.gemarkungsnummer = k.gemarkungsnummer 
  JOIN gemeinde_gemarkung      g   ON k.gemarkungsnummer = g.gemarkung

  WHERE bpn.beziehungsart = 'benennt' 
    AND bnb.beziehungsart = 'istBestandteilVon'
    AND bbg.beziehungsart = 'istBestandteilVon'
    AND bsf.beziehungsart = 'istGebucht'
;

COMMENT ON VIEW gemeinde_person_typ1 IS 'Personen die Eigentümer vom Flurstücken in einer Gemeinde sind. Typ1 = nomale Buchungen mit direkter Beziehung.';


-- "Komplexe" Buchungen mit Rechten von Buchungen an Buchungen

CREATE VIEW gemeinde_person_typ2
AS
  SELECT DISTINCT
    p.gml_id          AS person, 
  --bpn.beziehungsart AS bpnbez, 
  --bnb.beziehungsart AS bnbbez, 
  --bbg.beziehungsart AS bbgbez, 
  --bsf.beziehungsart AS bsfbez, 
  --k.gemarkungsnummer,
    g.land, g.regierungsbezirk, g.kreis, g.gemeinde

  FROM ax_person               p

-- Person < benennt < Namensnummer
  JOIN alkis_beziehungen      bpn  ON bpn.beziehung_zu   = p.gml_id  -- Bez. Person - Nummer
  JOIN ax_namensnummer         n   ON bpn.beziehung_von  = n.gml_id

-- Namensnummer > istBestandteilVon > Blatt
  JOIN alkis_beziehungen      bnb  ON bnb.beziehung_von  = n.gml_id  -- Bez. Nummer - Blatt
  JOIN ax_buchungsblatt        b   ON bnb.beziehung_zu   = b.gml_id

-- Blatt < istBestandteilVon < buchungsStelle1
  JOIN alkis_beziehungen      bbg  ON bbg.beziehung_zu   = b.gml_id  -- Bez. Blatt  - Stelle
  JOIN ax_buchungsstelle       s1  ON bbg.beziehung_von  = s1.gml_id 

-- buchungsStelle2 < an < buchungsStelle1
  JOIN alkis_beziehungen      bss  ON bss.beziehung_von  = s1.gml_id  -- Bez. Stelle  - Stelle
  JOIN ax_buchungsstelle       s2  ON bss.beziehung_zu   = s2.gml_id 

-- buchungsStelle2 < istGebucht < flurstück
  JOIN alkis_beziehungen      bsf  ON bsf.beziehung_zu   = s2.gml_id  -- Bez. Stelle - Flurstück
  JOIN ax_flurstueck           f   ON bsf.beziehung_von  = f.gml_id 

  JOIN ax_gemarkung            k   ON f.land             = k.land 
                                  AND f.gemarkungsnummer = k.gemarkungsnummer 
  JOIN gemeinde_gemarkung      g   ON k.gemarkungsnummer = g.gemarkung

  WHERE bpn.beziehungsart = 'benennt' 
    AND bnb.beziehungsart = 'istBestandteilVon'
    AND bbg.beziehungsart = 'istBestandteilVon'
    AND bss.beziehungsart = 'an'
    AND bsf.beziehungsart = 'istGebucht'
 -- LIMIT 100  -- Test-Option
;

COMMENT ON VIEW gemeinde_person_typ2 IS 'Personen die Eigentümer vom Flurstücken in einer Gemeinde sind. Typ2 = Buchungen mit Rechten einer Buchungssstelle an einer anderen.';


-- Statistik über die Buchungs-Typen je Gemeinde
CREATE VIEW gemeinde_person_statistik
AS
  SELECT p.land, p.regierungsbezirk, p.kreis, p.gemeinde, g.gemeindename, p.buchtyp, count(p.person) as personen
  FROM   gemeinde_person    p
  JOIN   gemeinde_gemarkung g
    ON   p.land     = g.land 
    AND  p.regierungsbezirk = g.regierungsbezirk 
    AND  p.kreis    = g.kreis 
    AND  p.gemeinde = g.gemeinde
  GROUP BY p.land, p.regierungsbezirk, p.kreis, p.gemeinde, g.gemeindename, p.buchtyp
  ORDER BY p.land, p.regierungsbezirk, p.kreis, p.gemeinde, p.buchtyp
;

COMMENT ON VIEW gemeinde_person_statistik IS 'Zählen der Personen je Gemeinde und Buchungstyp';



-- ** aus gemeinden_laden.sql


-- =======================================================
-- Tabelle fuer die Zuordnung vom Eigentümern zu Gemeinden
-- =======================================================


-- erst mal sauber machen
DELETE FROM gemeinde_person;

-- alle direkten Buchungen mit View ermitteln und in Tabelle speichern
-- Für eine Stadt: ca. 20 Sekunden
INSERT INTO  gemeinde_person 
       (land, regierungsbezirk, kreis, gemeinde, person, buchtyp)
 SELECT land, regierungsbezirk, kreis, gemeinde, person, 1
   FROM gemeinde_person_typ1;


-- noch die komplexeren Buchungen ergänzen (Recht an ..)
-- Mit View ermitteln und in Tabelle speichern
-- Für eine Stadt: ca. 10 Sekunden
INSERT INTO  gemeinde_person 
       (  land,   regierungsbezirk,   kreis,   gemeinde,   person,  buchtyp)
 SELECT q.land, q.regierungsbezirk, q.kreis, q.gemeinde, q.person,  2
   FROM gemeinde_person_typ2 q   -- Quelle
   LEFT JOIN gemeinde_person z   -- Ziel
     ON q.person   = z.person    -- Aber nur, wenn dieser Fall im Ziel
    AND q.land     = z.land 
    AND q.regierungsbezirk = z.regierungsbezirk 
    AND q.kreis    = z.kreis 
    AND q.gemeinde = z.gemeinde
  WHERE z.gemeinde is Null;      -- ..  noch nicht vorhanden ist


-- Berechtigungen

-- GRANT SELECT ON TABLE ...


-- ENDE --