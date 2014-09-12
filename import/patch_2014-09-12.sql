--
-- PostNAS 0.8
-- Anwendung der der Schema-Änderungen vom 12.09.2014 auf bestehende Datenbanken
--
-- 2014-09-12 FJ Indizierung der ersten 16 Zeichen der gml_id, wenn diese Ziel einer ALKIS-Beziehung ist.
--
-- -> aa_objekt
-- Welche konkreten Tabellen kann das betreffen?

-- -> ap_lpo
CREATE INDEX ap_lpo_gml16 ON ap_lpo USING btree (substring(gml_id,1,16)); -- ALKIS-Relation

-- -> ax_buchungsblatt
CREATE INDEX ax_buchungsblatt_gml16 ON ax_buchungsblatt USING btree (substring(gml_id,1,16)); -- ALKIS-Relation

-- -> ax_buchungsstelle 
-- Für Relationen (ALKIS-Beziehungen) aus anderen Tabellen über die gml_id ohne Zeitstempel
CREATE INDEX ax_buchungsstelle_gml16 ON ax_buchungsstelle USING btree (substring(gml_id,1,16)); -- ALKIS-Relation

-- -> ax_flurstueck
CREATE INDEX ax_flurstueck_gml16 ON ax_flurstueck USING btree (substring(gml_id,1,16)); -- ALKIS-Relation

-- -> ax_gebaeude
CREATE INDEX ax_gebaeude_gml16 ON ax_gebaeude USING btree (substring(gml_id,1,16)); -- ALKIS-Relation

-- -> ax_lagebezeichnungohnehausnummer 
CREATE INDEX ax_lagebezeichnungohnehausnummer_gml16 ON ax_lagebezeichnungohnehausnummer USING btree (substring(gml_id,1,16)); -- ALKIS-Relation

-- -> ax_lagebezeichnungmithausnummer
CREATE INDEX ax_lagebezeichnungmithausnummer_gml16 ON ax_lagebezeichnungmithausnummer USING btree (substring(gml_id,1,16)); -- ALKIS-Relation

-- -> ax_lagebezeichnungmitpseudonummer
CREATE INDEX ax_lagebezeichnungmitpseudonummer_gml16 ON ax_lagebezeichnungmitpseudonummer USING btree (substring(gml_id,1,16)); -- ALKIS-Relation

-- -> ax_verwaltung
CREATE INDEX ax_verwaltung_gml16 ON ax_verwaltung USING btree (substring(gml_id,1,16)); -- ALKIS-Relation

-- -> ax_grenzpunkt
CREATE INDEX ax_grenzpunkt_gml16 ON ax_grenzpunkt USING btree (substring(gml_id,1,16)); -- ALKIS-Relation

-- -> ax_namensnummer 
CREATE INDEX ax_namensnummer_gml16 ON ax_namensnummer USING btree (substring(gml_id,1,16)); -- ALKIS-Relation

-- -> ax_anschrift
CREATE INDEX ax_anschrift_gml16 ON ax_anschrift USING btree (substring(gml_id,1,16)); -- ALKIS-Relation

-- -> ax_person
CREATE INDEX ax_person_gml16 ON ax_person USING btree (substring(gml_id,1,16)); -- ALKIS-Relation

-- -> ax_personengruppe  -- Tabelle im Schema noch nicht vorhanden
--CREATE INDEX ax_personengruppe_gml16 ON ax_personengruppe USING btree (substring(gml_id,1,16)); -- ALKIS-Relation

-- Test: -- -> ax_buchungsblatt
/*

-- Falsch und schnell, Findet nicht die Fälle mit langer ID:
 SELECT dien.gml_id, herr.gml_id
   FROM ax_buchungsstelle dien
   JOIN ax_buchungsstelle herr  
     ON dien.gml_id = ANY (herr.an) 
  WHERE dien.endet IS NULL AND herr.endet IS NULL 
  LIMIT 300;
-- 78 ms

-- findet alle Fälle, ist aber unbrauchbar langsam:
 SELECT dien.gml_id, herr.gml_id
   FROM ax_buchungsstelle dien
   JOIN ax_buchungsstelle herr  ON substring(dien.gml_id,1,16) = ANY (herr.an) 
  WHERE dien.endet IS NULL AND herr.endet IS NULL 
  LIMIT 300;
-- 19454 ms  (vor dem Patch)

*/
