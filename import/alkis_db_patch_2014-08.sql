
-- Straßennamen als P und L-Variante
-- =================================

-- Bisher wurden die Namen von Straßen, Wegen und Klassifizierungen nur angezeigt, wenn sie
-- als Punkt über die Tabelle "ap_pto" positioniert waren.
-- Nun tauchen auch Texte auf, die über Linien positioniert sind (ap_lto).

-- Dies Script passt die Datenbank an. Ein überarbeitetes Mapfile muss die neue Tabelle präsentiern.

-- Es wurden mehrere Scripte angepasst.
-- Diese treten in Kraft, sobald eine Datenbank neu angelegt und neu geladen wird.

-- Dies Script patcht eine bereits bestehende Datenbank.
-- Dies Script ist nur temporär im Einsatz und wird darum nicht langfristig gepflegt.

-- Stand 2014-08-25


-- *** aus "pp_definition.sql"

-- Variante für Punkt-Geometrie
CREATE TABLE pp_strassenname_p 
(   gid                    serial NOT NULL,
    gml_id                 character(16),
 -- advstandardmodell      character varying[],
    schriftinhalt          character varying,      -- Label: anzuzeigender Text
    hor                    character varying,
    ver                    character varying,
 -- signaturnummer         character varying,
 -- darstellungsprioritaet integer,
    art                    character varying,
    winkel                 double precision,
    CONSTRAINT pp_snamp_pk  PRIMARY KEY (gid)
) WITH (OIDS=FALSE);

-- :alkis_epsg = 25832
SELECT AddGeometryColumn('pp_strassenname_p','the_geom',25832,'POINT',2);
CREATE INDEX pp_snamp_gidx ON pp_strassenname_p USING gist(the_geom); 

  COMMENT ON TABLE  pp_strassenname_p                IS 'Post-Processing: Label der Straßennamen in der Karte, Punktgeometrie. Auszug aus ap_pto.';

  COMMENT ON COLUMN pp_strassenname_p.gid            IS 'Editierschlüssel der Tabelle';
--COMMENT ON COLUMN pp_strassenname_p.gml_id         IS 'Objektschlüssel des Präsentationsobjektes aus ap_pto. Zur Verbindung mit Katalog.';
  COMMENT ON COLUMN pp_strassenname_p.gml_id         IS 'Objektschlüssel des Präsentationsobjektes aus "ax_lagebezeichnungohnehausnummer". Zur Verbindung mit Katalog beim Nachladen leerer Felder.';
  COMMENT ON COLUMN pp_strassenname_p.schriftinhalt  IS 'Label, darzustellender Name der Straße oder Klassifikation';
  COMMENT ON COLUMN pp_strassenname_p.hor            IS 'Horizontale Ausrichtung des Textes zur Punkt-Koordinate: linksbündig, zentrisch, ...';
  COMMENT ON COLUMN pp_strassenname_p.ver            IS 'Vertikale   Ausrichtung des Textes zur Punkt-Koordinate: Basis, ..';
  COMMENT ON COLUMN pp_strassenname_p.art            IS 'Klasse der Straße: Straße, Weg, .. , BezKlassifizierungStrasse';
  COMMENT ON COLUMN pp_strassenname_p.winkel         IS 'Drehung des Textes';
  COMMENT ON COLUMN pp_strassenname_p.the_geom       IS 'Position (Punkt) der Labels in der Karte';

-- Variante für Linien-Geometrie
CREATE TABLE pp_strassenname_l 
(   gid                    serial NOT NULL,
    gml_id                 character(16),
    schriftinhalt          character varying,      -- Label: anzuzeigender Text
    hor                    character varying,
    ver                    character varying,
    art                    character varying,
 -- winkel                 double precision,       -- bei Linien-Variante nicht benötigt
    CONSTRAINT pp_snaml_pk  PRIMARY KEY (gid)
) WITH (OIDS=FALSE);

-- :alkis_epsg = 25832
SELECT AddGeometryColumn('pp_strassenname_l','the_geom',25832,'LINESTRING',2); -- Hier liegt der Unterschied
CREATE INDEX pp_snaml_gidx ON pp_strassenname USING gist(the_geom); 

  COMMENT ON TABLE  pp_strassenname_l                IS 'Post-Processing: Label der Straßennamen in der Karte, Liniengeometrie. Auszug aus ap_lto.';

  COMMENT ON COLUMN pp_strassenname_l.gid            IS 'Editierschlüssel der Tabelle';
  COMMENT ON COLUMN pp_strassenname_l.gml_id         IS 'Objektschlüssel des Präsentationsobjektes aus "ax_lagebezeichnungohnehausnummer". Zur Verbindung mit Katalog beim Nachladen leerer Felder.';
  COMMENT ON COLUMN pp_strassenname_l.schriftinhalt  IS 'Label, darzustellender Name der Straße oder Klassifikation';
  COMMENT ON COLUMN pp_strassenname_l.hor            IS 'Horizontale Ausrichtung des Textes: linksbündig, zentrisch, ...';
  COMMENT ON COLUMN pp_strassenname_l.ver            IS 'Vertikale   Ausrichtung des Textes: Basis, ..';
  COMMENT ON COLUMN pp_strassenname_l.art            IS 'Klasse der Straße: Straße, Weg, .. , BezKlassifizierungStrasse';
  COMMENT ON COLUMN pp_strassenname_l.the_geom       IS 'Position (Punkt) der Labels in der Karte';


--  *** aus "sichten_wms.sql"

-- HIER START für Wiederholung

DROP VIEW ap_pto_stra;

CREATE OR REPLACE VIEW ap_pto_stra 
AS 
  SELECT p.ogc_fid,
         l.gml_id,                               -- wird im PP zum Nachladen aus Katalog gebraucht
         p.schriftinhalt,                        -- WMS: LABELITEM
         p.art,                                  -- WMS: CLASSITEM
         p.horizontaleausrichtung  AS hor,       -- Verfeinern der Text-Position ..
         p.vertikaleausrichtung    AS ver,       --  .. durch Klassifizierung hor/ver
         p.drehwinkel * 57.296     AS winkel,    -- * 180 / Pi
         p.wkb_geometry
    FROM ap_pto p
    JOIN alkis_beziehungen v   -- Relation zur Lagebezeichnung o. HsNr.
      ON p.gml_id = v.beziehung_von
    JOIN ax_lagebezeichnungohnehausnummer l
      ON v.beziehung_zu = l.gml_id
   WHERE  p.endet IS NULL                            -- nichts historisches
     AND  p.art   IN ('Strasse','Weg','Platz','BezKlassifizierungStrasse') -- Diese Werte als CLASSES in LAYER behandeln. 
     AND  v.beziehungsart = 'dientZurDarstellungVon' -- kann, muss aber nicht
     AND (   'DKKM1000' = ANY (p.advstandardmodell)  -- "Lika 1000" bevorzugen
          OR 'DLKM'     = ANY (p.advstandardmodell)   
     -- Leopoldshöhe, Heinestraße: 'DLKM'
           -- Ersatzweise auch "keine Angabe", aber nur wenn es keinen besseren Text zur Lage gibt
           OR (p.advstandardmodell IS NULL
               AND (SELECT s.ogc_fid                -- irgend ein Feld
                      FROM ap_pto s                 -- eines anderen Textes (suchen)
                      JOIN alkis_beziehungen vs     -- zur gleichen Lage o.HsNr
                        ON s.gml_id = vs.beziehung_von
                      JOIN ax_lagebezeichnungohnehausnummer ls
                        ON vs.beziehung_zu = ls.gml_id
                     WHERE ls.gml_id = l.gml_id
                       AND vs.beziehungsart = 'dientZurDarstellungVon' -- kann, muss aber nicht
                       AND NOT s.advstandardmodell IS NULL 
                     LIMIT 1  -- einer reicht als Beweis
                   ) IS NULL 
              ) -- "Subquery IS NULL" liefert true wenn kein weiterer Text gefunden wird
         )
;

COMMENT ON VIEW ap_pto_stra 
  IS 'Sicht für Kartendarstellung: Beschriftung aus "ap_pto" für Lagebezeichnung mit Art "Straße", "Weg", "Platz" oder Klassifizierung.
 Vorzugsweise mit advstandardmodell="DKKM1000", ersatzweise ohne Angabe. Dient im Script pp_laden.sql zum ersten Füllen der Tabelle "pp_strassenname_p".';

-- Daten aus dem View "ap_pto_stra" werden im PostProcessing gespeichert in der Tabelle "pp_strassenname_p".
-- Der View übernimmt die Auswahl des passenden advstandardmodell und rechnet den Winkel passend um,
-- In der Tabelle werden dann die leer gebliebenen Label aus dem Katalog noch ergänzt.


DROP VIEW ap_lto_stra;

CREATE OR REPLACE VIEW ap_lto_stra 
AS 
  SELECT p.ogc_fid,
         l.gml_id,                               -- wird im PP zum Nachladen aus Katalog gebraucht
         p.schriftinhalt,                        -- WMS: LABELITEM
         p.art,                                  -- WMS: CLASSITEM
         p.horizontaleausrichtung  AS hor,       -- Verfeinern der Text-Position ..
         p.vertikaleausrichtung    AS ver,       --  .. durch Klassifizierung hor/ver
         p.wkb_geometry
    FROM ap_lto p
    JOIN alkis_beziehungen v   -- Relation zur Lagebezeichnung o. HsNr.
      ON p.gml_id = v.beziehung_von
    JOIN ax_lagebezeichnungohnehausnummer l
      ON v.beziehung_zu = l.gml_id
   WHERE  p.endet IS NULL                            -- nichts historisches
     AND  p.art   IN ('Strasse','Weg','Platz','BezKlassifizierungStrasse') -- Diese Werte als CLASSES in LAYER behandeln. 
     AND  v.beziehungsart = 'dientZurDarstellungVon' -- kann, muss aber nicht

--   AND (   ('DKKM1000' = ANY (p.advstandardmodell)     -- "Lika 1000" bevorzugen
--        OR ('DLKM'     = ANY (p.advstandardmodell)  ) 

     -- ++ Muss als Array angelegt sein!!
     AND ( NOT p.advstandardmodell  IS NULL          -- ++ Zwischenlösung bis DB mit neuem Schema (2014-08-22) angelegt und geladen wurde ++

           -- Ersatzweise auch "keine Angabe", aber nur wenn es keinen besseren Text zur Lage gibt
           OR (p.advstandardmodell IS NULL
               AND (SELECT s.ogc_fid                -- irgend ein Feld
                      FROM ap_lto s                 -- eines anderen Textes (suchen)
                      JOIN alkis_beziehungen vs     -- zur gleichen Lage o.HsNr
                        ON s.gml_id = vs.beziehung_von
                      JOIN ax_lagebezeichnungohnehausnummer ls
                        ON vs.beziehung_zu = ls.gml_id
                     WHERE ls.gml_id = l.gml_id
                       AND vs.beziehungsart = 'dientZurDarstellungVon' -- kann, muss aber nicht
                       AND NOT s.advstandardmodell IS NULL 
                     LIMIT 1  -- einer reicht als Beweis
                   ) IS NULL 
              ) -- "Subquery IS NULL" liefert true wenn kein weiterer Text gefunden wird
         )
;
COMMENT ON VIEW ap_lto_stra 
  IS 'Sicht für Kartendarstellung: Beschriftung aus "ap_lto" für Lagebezeichnung mit Art "Straße", "Weg", "Platz" oder Klassifizierung.
 Vorzugsweise mit advstandardmodell="DKKM1000", ersatzweise ohne Angabe. Dient im Script pp_laden.sql zum ersten Füllen der Tabelle "pp_strassenname_l".';

-- 2014-08-22: Daten aus dem View "ap_lto_stra" werden im PostProcessing gespeichert in den Tabellen "pp_strassenname_l".
-- Der View übernimmt die Auswahl des passenden advstandardmodell.
-- In der Tabelle werden dann die leer gebliebenen Label aus dem Katalog noch ergänzt.


-- *** aus "pp_laden.sql"

-- Alles auf Anfang
TRUNCATE pp_strassenname_p;

-- Zunächst die Sonderschreibweisen (Abkürzungen) und die Standardschreibweisen, 
-- die von der Migration redundant abgelegt wurden.
INSERT INTO pp_strassenname_p (gml_id, schriftinhalt, hor, ver, art, winkel, the_geom)
       SELECT gml_id, schriftinhalt, hor, ver, art, winkel, wkb_geometry
       FROM ap_pto_stra; -- Der View sucht das passende advstandardmodell

-- Schriftinhalt ergänzen
-- Das sind die Standardschreibweisen aus dem Katalog, die nicht mehr redundant in ap_pto sind.
UPDATE pp_strassenname_p  p
   SET schriftinhalt =     -- Hier ist der Label noch leer
   -- Subquery "Gib mir den Straßennamen":
   ( SELECT k.bezeichnung                         -- Straßenname ..
       FROM ax_lagebezeichnungkatalogeintrag k    --  .. aus Katalog
       JOIN ax_lagebezeichnungohnehausnummer l    -- verwendet als Lage o.H.
         ON (k.land=l.land AND k.regierungsbezirk=l.regierungsbezirk AND k.kreis=l.kreis AND k.gemeinde=l.gemeinde AND k.lage=l.lage )
      WHERE p.gml_id = l.gml_id                   -- die gml_id wurde aus View importiert
    )
 WHERE     p.schriftinhalt IS NULL
   AND NOT p.the_geom      IS NULL;

-- Die immer noch leeren Texte sind nun sinnlos.
-- Die finden sich ggf. in der Variante "_l" mit Liniengeometrie.
DELETE FROM pp_strassenname_p WHERE schriftinhalt IS NULL;

-- Nun das Gleiche noch einmal für Linien-Geometrie

-- Auf Anfang
TRUNCATE pp_strassenname_l;

-- Zunächst die Sonderschreibweisen (Abkürzungen) und die Standardschreibweisen, 
-- die von der Migration redundant abgelegt wurden.
INSERT INTO pp_strassenname_l (gml_id, schriftinhalt, hor, ver, art, the_geom)
       SELECT gml_id, schriftinhalt, hor, ver, art, wkb_geometry
       FROM ap_lto_stra; -- Der View sucht das passende advstandardmodell

-- Schriftinhalt ergänzen (korrigiert 2014-08-25)
-- Das sind die Standardschreibweisen aus dem Katalog, die nicht mehr redundant in ap_pto sind.
-- Der Satz mit der passenen gml_id (Lage o.H.) ist aus dem View bereits importiert.
-- Jetzt noch den dazu passenen Schriftinhalt aus dem Katalog holen.
UPDATE pp_strassenname_l  p
   SET schriftinhalt =     -- Hier ist der Label noch leer
   -- Subquery "Gib mir den Straßennamen":
   ( SELECT k.bezeichnung                         -- Straßenname ..
       FROM ax_lagebezeichnungkatalogeintrag k    --  .. aus Katalog
       JOIN ax_lagebezeichnungohnehausnummer l    -- verwendet als Lage o.H.
         ON (k.land=l.land AND k.regierungsbezirk=l.regierungsbezirk AND k.kreis=l.kreis AND k.gemeinde=l.gemeinde AND k.lage=l.lage )
      WHERE p.gml_id = l.gml_id                   -- die gml_id wurde aus View importiert
    )
 WHERE     p.schriftinhalt IS NULL
   AND NOT p.the_geom      IS NULL;

-- Die immer noch leeren Texte sind sinnlos.
DELETE FROM pp_strassenname_l WHERE schriftinhalt IS NULL;


-- *** aus "grant.sql"

-- Berechtigungen

  GRANT SELECT ON TABLE  pp_strassenname_p                 TO ms6;
  GRANT SELECT ON TABLE  pp_strassenname_l                 TO ms6;


-- Zwischenzeitlich auch noch die alte Tabelle (ohne _P + _L-Trennung) aktualisieren
-- Wirkt in Produktion bis zur Einführung der angepassten Mapfiles (Entwickler-Version)

-- Alles auf Anfang
TRUNCATE pp_strassenname;

INSERT INTO pp_strassenname (gml_id, schriftinhalt, hor, ver, art, winkel, the_geom)
       SELECT gml_id, schriftinhalt, hor, ver, art, winkel, wkb_geometry
       FROM ap_pto_stra; 

UPDATE pp_strassenname  p
   SET schriftinhalt =    
   ( SELECT k.bezeichnung                         -- Straßenname ..
       FROM ax_lagebezeichnungkatalogeintrag k    --  .. aus Katalog
       JOIN ax_lagebezeichnungohnehausnummer l    -- verwendet als Lage o.H.
         ON (k.land=l.land AND k.regierungsbezirk=l.regierungsbezirk AND k.kreis=l.kreis AND k.gemeinde=l.gemeinde AND k.lage=l.lage )
      WHERE p.gml_id = l.gml_id                   -- die gml_id wurde aus View importiert
    )
 WHERE     p.schriftinhalt IS NULL
   AND NOT p.the_geom      IS NULL;


-- ENDE --