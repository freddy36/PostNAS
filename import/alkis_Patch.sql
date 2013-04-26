
-- ALKIS-Datenbank aus dem Konverter PostNAS 0.7

-- Gezielte Aktualisierung der Datenbank durch die "letzten Änderungen"

--  2013-04-17  F.J. Kurzbezeichnungen der Bodenschätzung für die Kartendarstellung

  SET client_encoding = 'UTF8';

-- Abhängigkeiten / bei Wiederholung:
-- DROP VIEW s_bodensch_wms;
-- DROP VIEW s_bodensch_ent;
-- DROP VIEW s_bodensch_po;
-- DROP VIEW s_bodensch_tx;
-- DROP VIEW s_zuordungspfeil_bodensch;
-- DROP VIEW s_zuordungspfeilspitze_bodensch;


-- B o d e n s c h a e t z u n g -  K u l t u r a r t
-- --------------------------------------------------
DROP TABLE ax_bodenschaetzung_kulturart;
CREATE TABLE ax_bodenschaetzung_kulturart (
    wert integer,
	kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_ax_bodenschaetzung_kulturart  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bodenschaetzung_kulturart 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

COMMENT ON COLUMN ax_bodenschaetzung_kulturart.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_bodenschaetzung_kulturart.kurz       IS 'Kürzel';
COMMENT ON COLUMN ax_bodenschaetzung_kulturart.bezeichner IS 'Lange Bezeichnung';

INSERT INTO ax_bodenschaetzung_kulturart (wert, kurz, bezeichner) VALUES (1000,'A'  , 'Ackerland (A)');
INSERT INTO ax_bodenschaetzung_kulturart (wert, kurz, bezeichner) VALUES (2000,'AGr', 'Acker-Grünland (AGr)');
INSERT INTO ax_bodenschaetzung_kulturart (wert, kurz, bezeichner) VALUES (3000,'Gr' , 'Grünland (Gr)');
INSERT INTO ax_bodenschaetzung_kulturart (wert, kurz, bezeichner) VALUES (4000,'GrA', 'Grünland-Acker (GrA)');


-- B o d e n s c h a e t z u n g  -  B o d e n a r t
-- -------------------------------------------------
DROP TABLE ax_bodenschaetzung_bodenart;
CREATE TABLE ax_bodenschaetzung_bodenart (
    wert integer,
	kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_ax_bodenschaetzung_bodenart  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bodenschaetzung_bodenart 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

COMMENT ON COLUMN ax_bodenschaetzung_bodenart.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_bodenschaetzung_bodenart.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN ax_bodenschaetzung_bodenart.bezeichner IS 'Lange Bezeichnung';

INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (1100,'S',     'Sand (S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (2100,'lS',    'Lehmiger Sand (lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (3100,'L',     'Lehm (L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (4100,'T',     'Ton (T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (5000,'Mo',    'Moor (Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (1200,'Sl',    'Anlehmiger Sand (Sl)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (2200,'SL',    'Stark lehmiger Sand (SL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (3200,'sL',    'Sandiger Lehm (sL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (4200,'LT',    'Schwerer Lehm (LT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6110,'SMo',   'Sand, Moor (SMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6120,'lSMo',  'Lehmiger Sand, Moor (lSMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6130,'LMo',   'Lehm, Moor (LMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6140,'TMo',   'Ton, Moor (TMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6210,'MoS',   'Moor,Sand (MoS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6220,'MolS',  'Moor, Lehmiger Sand (MolS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6230,'MoL',   'Moor, Lehm (MoL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (6240,'MoT',   'Moor, Ton (MoT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7110,'S/sL',  'Sand auf sandigem Lehm (S/sL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7130,'S/LT',  'Sand auf schwerem Lehm (S/LT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7210,'Sl/L',  'Anlehmiger Sand auf Lehm (Sl/L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7220,'Sl/LT', 'Anlehmiger Sand auf schwerem Lehm (Sl/LT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7230,'Sl/T',  'Anlehmiger Sand auf Ton (Sl/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7310,'lS/LT', 'Lehmiger Sand auf schwerem Lehm (lS/LT)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7320,'lS/S',  'Lehmiger Sand auf Sand (lS/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7400,'SL/T)', 'Stark lehmiger Sand auf Ton (SL/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7510,'T/SL',  'Ton auf stark lehmigen Sand (T/SL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7530,'T/Sl',  'Ton auf anlehmigen Sand (T/Sl)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7610,'LT/lS', 'Schwerer Lehm auf lehmigen Sand (LT/lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7620,'LT/Sl', 'Schwerer Lehm auf anlehmigen Sand (LT/Sl)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7630,'LT/S',  'Schwerer Lehm auf Sand (LT/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7710,'L/Sl',  'Lehm auf anlehmigen Sand (L/Sl)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7800,'sL/S',  'Sandiger Lehm auf Sand (sL/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7120,'S/L',   'Sand auf Lehm (S/L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7140,'S/T',   'Sand auf Ton (S/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7330,'lS/T',  'Lehmiger Sand auf Ton (lS/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7520,'T/lS',  'Ton auf lehmigen Sand (T/lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7540,'T/S',   'Ton auf Sand (T/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (7720,'L/S',   'Lehm auf Sand (L/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8110,'S/Mo',  'Sand auf Moor (S/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8120,'lS/Mo', 'Lehmiger Sand auf Moor (lS/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8130,'L/Mo',  'Lehm auf Moor (L/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8140,'T/Mo',  'Ton auf Moor (T/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8210,'Mo/S',  'Moor auf Sand (Mo/S)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8220,'Mo/lS', 'Moor auf lehmigen Sand (Mo/lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8230,'Mo/L',  'Moor auf Lehm (Mo/L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (8240,'Mo/T',  'Moor auf Ton (Mo/T)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9120,'L+Mo',  'Bodenwechsel vom Lehm zu Moor (L+Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9130,'lSg',   'Lehmiger Sand mit starkem Steingehalt (lSg)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9140,'Lg',    'Lehm mit starkem Steingehalt (Lg)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9150,'lS+St', 'lehmiger Sand mit Steinen und Blöcken (lS+St)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9160,'L+St',  'Lehm mit Steinen und Blöcken (L+St)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9170,'St+lS', 'Steine und Blöcke mit lehmigem Sand (St+lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9180,'St+L',  'Steine und Blöcke mit Lehm (St+L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9190,'lS+Fe', 'lehmiger Sand mit Felsen (lS+Fe)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9200,'L+Fe',  'Lehm mit Felsen (L+Fe)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9210,'Fe+lS', 'Felsen mit lehmigem Sand (Fe+lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9220,'Fe+L',  'Felsen mit Lehm (Fe+L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9310,'S/lS',  'Sand auf lehmigen Sand (S/lS)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9320,'Sl/Me', 'Anlehmiger Sand auf Mergel (Sl/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9330,'Sl/sL', 'Anlehmiger Sand auf sandigem Lehm (Sl/sL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9340,'lS/L',  'Lehmiger Sand auf Lehm (lS/L)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9350,'lS/Me', 'Lehmiger Sand auf Mergel (lS/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9360,'lS/sL', 'Lehmiger Sand auf sandigem Lehm (lS/sL)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9370,'lSMe',  'Lehmiger Sand, Mergel (lSMe)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9380,'lSMo/Me','Lehmiger Sand, Moor auf Mergel (lSMo/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9390,'SlMo',  'Anlehmiger Sand, Moor (SlMo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9410,'L/Me',  'Lehm auf Mergel (L/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9420,'LMo/Me','Lehm, Moor auf Mergel (LMo/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9430,'LT/Mo', 'Schwerer Lehm auf Moor (LT/Mo)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9440,'T/Me',  'Ton auf Mergel (T/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9450,'Mo/Me', 'Moor auf Mergel (Mo/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9460,'MoL/Me','Moor, Lehm auf Mergel (MoL/Me)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9470,'MoMe',  'Moor, Mergel (MoMe)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9480,'LöD',   'LößDiluvium (LöD)');
INSERT INTO ax_bodenschaetzung_bodenart (wert, kurz, bezeichner) VALUES (9490,'AlD',   'AlluviumDiluvium (AlD)');


-- B o d e n s c h a e t z u n g  -  Z u s t a n d s s t u f e
-- ------------------------------------------------------------
DROP TABLE ax_bodenschaetzung_zustandsstufe;
CREATE TABLE ax_bodenschaetzung_zustandsstufe (
    wert integer,
    kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_ax_bodenschaetzung_zustandsstufe  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bodenschaetzung_zustandsstufe 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

COMMENT ON COLUMN ax_bodenschaetzung_zustandsstufe.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_bodenschaetzung_zustandsstufe.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN ax_bodenschaetzung_zustandsstufe.bezeichner IS 'Lange Bezeichnung';

INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1100,'1','Zustandsstufe (1)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1200,'2','Zustandsstufe (2)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1300,'3','Zustandsstufe (3)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1400,'4','Zustandsstufe (4)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1500,'5','Zustandsstufe (5)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1600,'6','Zustandsstufe (6)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1700,'7','Zustandsstufe (7)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (1800,'-','Zustandsstufe Misch- und Schichtböden sowie künstlichveränderte Böden (-)');

INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (2100,'I','Bodenstufe (I)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (2200,'II','Bodenstufe (II)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (2300,'III','Bodenstufe (III)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (2400,'-','Bodenstufe Misch- und Schichtböden sowie künstlich veränderte Böden (-)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (3100,'II+III','Bodenstufe (II+III)');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (3200,'(III)','Bodenstufe ("(III)")');
INSERT INTO ax_bodenschaetzung_zustandsstufe (wert, kurz, bezeichner) VALUES (3300,'IV','Bodenstufe (IV)');


-- B o d e n s c h a e t z u n g   -  Muster-, Landesmuster- und Vergleichsstueck
-- ------------------------------------------------------------------------------
DROP TABLE ax_musterlandesmusterundvergleichsstueck_merkmal;
CREATE TABLE ax_musterlandesmusterundvergleichsstueck_merkmal (
    wert integer,
    kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_ax_musterlandesmusterundvergleichsstueck_merkmal  PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_musterlandesmusterundvergleichsstueck_merkmal 
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script.';

COMMENT ON COLUMN ax_musterlandesmusterundvergleichsstueck_merkmal.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_musterlandesmusterundvergleichsstueck_merkmal.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN ax_musterlandesmusterundvergleichsstueck_merkmal.bezeichner IS 'Lange Bezeichnung';

INSERT INTO ax_musterlandesmusterundvergleichsstueck_merkmal (wert, kurz, bezeichner) VALUES (1000,'M','Musterstück (M)');
INSERT INTO ax_musterlandesmusterundvergleichsstueck_merkmal (wert, kurz, bezeichner) VALUES (2000,'L','Landesmusterstück (L)');
INSERT INTO ax_musterlandesmusterundvergleichsstueck_merkmal (wert, kurz, bezeichner) VALUES (3000,'V','Vergleichsstück (V)');


-- B o d e n s c h a e t z u n g   -  Entstehungsart oder Klimastufe / Wasserverhaeltnisse
-- ----------------------------------------------------------------------------------------
DROP TABLE ax_bodenschaetzung_entstehungsartoderklimastufe;
CREATE TABLE ax_bodenschaetzung_entstehungsartoderklimastufe (
    wert integer,
    kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_ax_bodenschaetzung_entstehung PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bodenschaetzung_entstehungsartoderklimastufe
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bodenschaetzung", Feld "entstehungsartoderklimastufe".';

COMMENT ON COLUMN ax_bodenschaetzung_entstehungsartoderklimastufe.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_bodenschaetzung_entstehungsartoderklimastufe.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN ax_bodenschaetzung_entstehungsartoderklimastufe.bezeichner IS 'Lange Bezeichnung';


INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1000,'D',   'Diluvium (D)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1100,'DAl', 'Diluvium über Alluvium (DAl)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1200,'DLö', 'Diluvium über Löß (DLö)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1300,'DV',  'Diluvium über Verwitterung (DV)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1400,'Dg',  'Diluvium, gesteinig (Dg)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1410,'DgAl','Diluvium, gesteinig über Alluvium (DgAl)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1420,'DgLö','Diluvium, gesteinig über Löß (DgLö)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(1430,'DgV', 'Diluvium, gesteinig über Verwitterung (DgV)');

INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2000,'Lö',  'Löß (Lö)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2100,'LöD', 'Löß über Diluvium (LöD)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2110,'LöDg','Löß, Diluvium, Gesteinsböden (LöDg)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2120,'LöDV','Löß, Diluvium, Verwitterung (LöDV)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2200,'LöAl','Löß über Alluvium (LöAl)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2300,'LöV', 'Löß über Verwitterung (LöV)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2310,'LöVg','Löß, Verwitterung, Gesteinsböden (LöVg)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(2400,'LöVg','Löß über Verwitterung, gesteinig (LöVg)');

INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3000,'Al',  'Alluvium (Al)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3100,'AlD', 'Alluvium über Diluvium (AlD)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3200,'AlLö','Alluvium über Löß (AlLö)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3300,'AlV', 'Alluvium über Verwitterung (AlV)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3400,'Alg', 'Alluvium, gesteinig (Alg)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3410,'AlgD','Alluvium, gesteinig über Diluvium (AlgD)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3420,'AlgLö','Alluvium, gesteinig über Löß (AlgLö)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3430,'AlgV','Alluvium, gesteinig über Verwitterung (AlgV)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3500,'AlMa','Alluvium, Marsch (AlMa)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3610,'AlMo','Alluvium, Moor (AlMo)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3620,'MoAI','Moor, Alluvium (MoAI)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(3700,'Me',  'Mergel (Me)');

INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(4000,'V',   'Verwitterung (V)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(4100,'VD',  'Verwitterung über Diluvium (VD)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(4200,'VAl', 'Verwitterung über Alluvium (VAl)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(4300,'VLö', 'Verwitterung über Löß (VLö)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(4400,'Vg',  'Verwitterung, Gesteinsböden (Vg)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(4410,'VgD', 'Verwitterung, Gesteinsböden über Diluvium (VgD)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(5000,'-',   'Entstehungsart nicht erkennbar (-)');

INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(6100,'a',   'Klimastufe 8° C und darüber (a)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(6200,'b',   'Klimastufe 7,9° - 7,0° C (b)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(6300,'c',   'Klimastufe 6,9° - 5,7° C (c)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(6400,'d',   'Klimastufe 5,6° C und darunter (d)');

INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7100,'1',   'Wasserstufe (1)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7200,'2',   'Wasserstufe (2)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7300,'3',   'Wasserstufe (3)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7400,'4',   'Wasserstufe (4)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7410,'4-',  'Wasserstufe (4-)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7500,'5',   'Wasserstufe (5)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7510,'5-',  'Wasserstufe (5-)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7520,'3-',  'Wasserstufe (3-)');
INSERT INTO ax_bodenschaetzung_entstehungsartoderklimastufe (wert, kurz, bezeichner) VALUES(7530,'3+4', 'Wasserstufe (3+4)');


-- B o d e n s c h a e t z u n g   -  sonstige Angaben
-- ----------------------------------------------------------------------------------------
--DROP TABLE ax_bodenschaetzung_sonstigeangaben;
CREATE TABLE ax_bodenschaetzung_sonstigeangaben (
    wert integer,
    kurz character varying,
    bezeichner character varying,
    CONSTRAINT pk_ax_bodenschaetzung_sonst PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bodenschaetzung_sonstigeangaben
 IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bodenschaetzung", Feld "sonstigeangaben".';

COMMENT ON COLUMN ax_bodenschaetzung_sonstigeangaben.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_bodenschaetzung_sonstigeangaben.kurz       IS 'Kürzel, Kartenanzeige';
COMMENT ON COLUMN ax_bodenschaetzung_sonstigeangaben.bezeichner IS 'Lange Bezeichnung';

INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(1100,'Wa+',   'Nass, zu viel Wasser (Wa+) ');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(1200,'Wa-',   'Trocken, zu wenig Wasser (Wa-)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(1300,'Wa gt', 'Besonders günstige Wasserverhältnisse (Wa gt)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(1400,'RiWa',  'Rieselwasser, künstliche Bewässerung (RiWa)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(2100,'W',     'Unbedingtes Wiesenland (W)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(2200,'Str',   'Streuwiese (Str) ');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(2300,'Hu',    'Hutung (Hu)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(2400,'A-Hack','Acker-Hackrain (A-Hack)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(2500,'Gr-Hack','Grünland-Hackrain (Gr-Hack)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(2600,'G',     'Garten (G)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(3000,'N',     'Neukultur (N)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(4000,'T',     'Tiefkultur (T) ');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(5000,'Ger',   'Geringstland (Ger)');
INSERT INTO ax_bodenschaetzung_sonstigeangaben (wert, kurz, bezeichner) VALUES(9000,'',      'Nachschätzung erforderlich ');


--DROP TABLE ax_bewertung_klassifizierung;
CREATE TABLE ax_bewertung_klassifizierung (
    wert integer,
    bezeichner character varying,
	erklaer character varying,
    CONSTRAINT pk_ax_bewertung_klass PRIMARY KEY (wert)
  );

COMMENT ON TABLE ax_bewertung_klassifizierung
IS 'Schlüsseltabelle mit Werten aus GeoInfoDok NW, geladen mit SQL-Script. Zu Tabelle "ax_bewertung", Feld "klassifizierung".';

COMMENT ON COLUMN ax_bewertung_klassifizierung.wert       IS 'numerischer Schlüssel';
COMMENT ON COLUMN ax_bewertung_klassifizierung.bezeichner IS 'Lange Bezeichnung';
COMMENT ON COLUMN ax_bewertung_klassifizierung.erklaer    IS 'ggf. weitere Erlärung';


INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1100, 'Unbebautes Grundstück', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1120, 'Unbebautes Grundstück mit Gebäude von untergeordneter Bedeutung ', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1130, 'Unbebautes Grundstück mit einem dem Verfall preisgegebenen Gebäude', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1140, 'Unbebautes Grundstück für Erholungs- und Freizeitzwecke', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1210, 'Einfamilienhausgrundstück', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1220, 'Zweifamilienhausgrundstück', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1230, 'Mietwohngrundstück', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1240, 'Gemischtgenutztes Grundstück', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1250, 'Geschäftsgrundstück', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1260, 'Sonstiges bebautes Grundstück', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1310, 'Einfamilienhaus auf fremdem Grund und Boden', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1320, 'Zweifamilienhaus auf fremdem Grund und Boden', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1330, 'Mietwohngrundstück, Mietwohngebäude auf fremdem Grund und Boden', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1340, 'Gemischtgenutztes Grundstück, gemischtgenutztes Gebäude auf fremdem Grund und Boden ', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1350, 'Geschäftsgrundstück, Geschäftsgebäude auf fremdem Grund und Boden', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(1360, 'Sonstige bebaute Grundstücke, sonstige Gebäude auf fremdem Grund und Boden', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2110, 'Landwirtschaftliche Nutzung', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2120, 'Hopfen', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2130, 'Spargel', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2190, 'Sonstige Sonderkulturen', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2200, 'Holzung', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2300, 'Weingarten (allgemein)', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2310, 'Weingarten 1', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2320, 'Weingarten 2', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2330, 'Weingarten 3', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2340, 'Weingarten 4', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2350, 'Weingarten 5', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2360, 'Weingarten 6', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2370, 'Weingarten 7', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2380, 'Weingarten 8', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2390, 'Weingarten 9', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2410, 'Gartenland', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2420, 'Obstplantage', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2430, 'Baumschule', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2440, 'Anbaufläche unter Glas ', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2450, 'Kleingarten', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2510, 'Weihnachtsbaumkultur', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2520, 'Saatzucht', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2530, 'Teichwirtschaft', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2610, 'Abbauland der Land- und Forstwirtschaft ', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2620, 'Geringstland', '"Geringstland" sind Flächen geringster Ertragsfähigkeit ohne Wertzahlen nach dem Bodenschätzungsgesetz, das sind unkultivierte Moor- und Heideflächen (sofern nicht gesondert geführt), ehemals bodengeschätzte Flächen und ehemalige Weinbauflächen, die ihren Kulturzustand verloren haben.');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2630, 'Unland',   '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2640, 'Moor',     '"Moor" ist eine unkultivierte Fläche mit einer (mindestens 20 cm starken) Auflage aus vertorften und vermoorten Pflanzenresten, soweit sie nicht als Torfstich benutzt wird.');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2650, 'Heide',    '"Heide" ist eine unkultivierte, sandige, überwiegend mit Heidekraut oder Ginster bewachsene Fläche.');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2700, 'Reet',     '"Reet" ist eine ständig oder zeitweise unter Wasser stehende und mit Reet bewachsene Fläche.');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2710, 'Reet I',   'Reetfläche, deren Nutzung eingestuft ist in Güteklasse I (gut).');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2720, 'Reet II',  'Reetfläche, deren Nutzung eingestuft ist in Güteklasse II (mittel).');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2730, 'Reet III', 'Reetfläche, deren Nutzung eingestuft ist in Güteklasse III (gering).');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2800, 'Nebenfläche des Betriebs der Land- und Forstwirtschaft', '');
INSERT INTO ax_bewertung_klassifizierung (wert, bezeichner, erklaer) VALUES(2899, 'Noch nicht klassifiziert', '');

-- Bodenschätzung

-- Für Nachschlagen bei Feature-Info: Entschlüsselung in Langform zu einer Klassenfläche, ohne Geometrie.
--DROP VIEW s_bodensch_ent;
CREATE OR REPLACE VIEW s_bodensch_ent
AS 
 SELECT bs.ogc_fid,
      --bs.advstandardmodell,   -- NUR TEST
        ka.bezeichner                      AS kulturart_e,
        ba.bezeichner                      AS bodenart_e,
        zs.bezeichner                      AS zustandsstufe_e,
        bs.bodenzahlodergruenlandgrundzahl AS grundz,
        bs.ackerzahlodergruenlandzahl      AS agzahl,
        ea1.bezeichner                     AS entstehart1,
        ea2.bezeichner                     AS entstehart2,
        -- entstehungsartoderklimastufewasserverhaeltnisse ist array!
        bs.sonstigeangaben, 		-- integer array  - Entschlüsseln?
        so1.bezeichner                     AS sonst1, -- Enstschlüsselung 
        so2.bezeichner                     AS sonst2,
        bs.jahreszahl				-- integer
   FROM ax_bodenschaetzung bs
   LEFT JOIN ax_bodenschaetzung_kulturart      ka ON bs.kulturart = ka.wert
   LEFT JOIN ax_bodenschaetzung_bodenart       ba ON bs.bodenart  = ba.wert
   LEFT JOIN ax_bodenschaetzung_zustandsstufe  zs ON bs.zustandsstufeoderbodenstufe = zs.wert
   LEFT JOIN ax_bodenschaetzung_entstehungsartoderklimastufe ea1 
          ON bs.entstehungsartoderklimastufewasserverhaeltnisse[1] = ea1.wert   -- [1] fast immer gefüllt
   LEFT JOIN ax_bodenschaetzung_entstehungsartoderklimastufe ea2 
          ON bs.entstehungsartoderklimastufewasserverhaeltnisse[2] = ea2.wert   -- [2] manchmal gefüllt
   LEFT JOIN ax_bodenschaetzung_sonstigeangaben so1 ON bs.sonstigeangaben[1] = so1.wert -- [1] selten gefüllt
   LEFT JOIN ax_bodenschaetzung_sonstigeangaben so2 ON bs.sonstigeangaben[2] = so2.wert -- [2] noch seltener
   WHERE bs.endet IS NULL;
COMMENT ON VIEW s_bodensch_ent IS 'Sicht für Feature-Info: Bodenschätzung, mit Langtexten entschlüsselt';
GRANT SELECT ON TABLE s_bodensch_ent TO ms6;

-- Klassenfläche (Geometrie) mit ihrem Kurz-Label-Text, der dann mittig an Standardposition angezeigt werden kann. 
CREATE OR REPLACE VIEW s_bodensch_wms
AS 
 SELECT bs.ogc_fid,
        bs.wkb_geometry,
     -- bs.advstandardmodell,   -- NUR TEST
     -- bs.entstehungsartoderklimastufewasserverhaeltnisse AS entstehart, -- Array der Keys, NUR TEST
        ka.kurz AS kult,  -- Kulturart, CLASSITEM, steuert die Farbe
     -- Viele Felder zusammen packen zu einem kompakten Zwei-Zeilen-Label:
          ba.kurz  ||            -- Bodenart
          zs.kurz  ||            -- Zustandsstufe
          ea1.kurz ||            -- Entstehungsart oder Klimastufe, Wasserverhaeltnisse ist ein Array mit 1 bis 2 Elementen
          coalesce (ea2.kurz, '') -- NULL vermeiden!
          || ' ' ||              -- Zeilenwechsel im Label (UMN: WRAP)
          bs.bodenzahlodergruenlandgrundzahl || '/' ||
          bs.ackerzahlodergruenlandzahl 
        AS derlabel              -- LABELITEM Umbruch am Blank
   FROM ax_bodenschaetzung bs
   LEFT JOIN ax_bodenschaetzung_kulturart      ka ON bs.kulturart = ka.wert
   LEFT JOIN ax_bodenschaetzung_bodenart       ba ON bs.bodenart  = ba.wert
   LEFT JOIN ax_bodenschaetzung_zustandsstufe  zs ON bs.zustandsstufeoderbodenstufe = zs.wert
   LEFT JOIN ax_bodenschaetzung_entstehungsartoderklimastufe ea1 
          ON bs.entstehungsartoderklimastufewasserverhaeltnisse[1] = ea1.wert   -- [1] fast immer gefüllt
   LEFT JOIN ax_bodenschaetzung_entstehungsartoderklimastufe ea2 
          ON bs.entstehungsartoderklimastufewasserverhaeltnisse[2] = ea2.wert   -- [2] manchmal gefüllt
   WHERE bs.endet IS NULL;
COMMENT ON VIEW s_bodensch_wms IS 'Sicht für Kartendarstellung: Bodenschätzung mit kompakten Informationen für Label.';


-- Die Fläche ohne Label
CREATE OR REPLACE VIEW s_bodensch_po
AS
 SELECT ogc_fid,
        wkb_geometry,
        kulturart  -- Kulturart, numerischer Schlüssel, CLASSITEM
   FROM ax_bodenschaetzung
  WHERE endet IS NULL;
COMMENT ON VIEW s_bodensch_po IS 'Sicht für Kartendarstellung: Klassenfläche der Bodenschätzung ohne Label.';

-- Der Label zu den Klassenabschnitten
-- ACHTUNG: Zu einigen Abschnitten gibt es mehrerere (identische) Label an verschiedenen Positionen! 
CREATE OR REPLACE VIEW s_bodensch_tx
AS 
 SELECT bs.ogc_fid,
        p.wkb_geometry,           -- Geomterie (Punkt) des Labels
     -- bs.wkb_geometry,          -- Geometrie der Fläche, nicht des Label
        bs.advstandardmodell,     -- NUR TEST
     -- bs.entstehungsartoderklimastufewasserverhaeltnisse AS entstehart, -- Array der Keys, NUR TEST
        ka.kurz AS kult,  -- Kulturart, CLASSITEM, steuert die Farbe
     -- p.horizontaleausrichtung,  -- Feinpositionierung  ..    (zentrisch)
	 -- p.vertikaleausrichtung,    --  .. des Labels            (basis)   -> uc
     -- Viele Felder zusammen packen zu einem kompakten Zwei-Zeilen-Label:
          ba.kurz  ||              -- Bodenart
          zs.kurz  ||              -- Zustandsstufe
          ea1.kurz ||              -- Entstehungsart oder Klimastufe, Wasserverhaeltnisse
          coalesce (ea2.kurz, '')  -- Noch mal, ist ein Array mit 1 bis 2 Elementen
          || ' ' ||                -- Zeilenwechsel im Label (UMN: WRAP ' ')
          bs.bodenzahlodergruenlandgrundzahl || '/' ||
          bs.ackerzahlodergruenlandzahl 
        AS derlabel                -- LABELITEM, Umbruch am Leerzeichen
   FROM ap_pto                            p
   JOIN alkis_beziehungen                 v  ON p.gml_id       = v.beziehung_von
   JOIN ax_bodenschaetzung                bs ON v.beziehung_zu = bs.gml_id
   LEFT JOIN ax_bodenschaetzung_kulturart      ka ON bs.kulturart = ka.wert
   LEFT JOIN ax_bodenschaetzung_bodenart       ba ON bs.bodenart  = ba.wert
   LEFT JOIN ax_bodenschaetzung_zustandsstufe  zs ON bs.zustandsstufeoderbodenstufe = zs.wert
   LEFT JOIN ax_bodenschaetzung_entstehungsartoderklimastufe ea1 
          ON bs.entstehungsartoderklimastufewasserverhaeltnisse[1] = ea1.wert 
   LEFT JOIN ax_bodenschaetzung_entstehungsartoderklimastufe ea2 
          ON bs.entstehungsartoderklimastufewasserverhaeltnisse[2] = ea2.wert 
  WHERE -- v.beziehungsart = 'dientZurDarstellungVon' AND 
         p.endet  IS NULL
     AND bs.endet IS NULL;
COMMENT ON VIEW s_bodensch_tx IS 'Sicht für Kartendarstellung: Kompakter Label zur Klassenfläche der Bodenschätzung an manueller Position. Der Label wird zusammengesetzt aus: Bodenart, Zustandsstufe, Entstehungsart oder Klimastufe/Wasserverhältnisse, Bodenzahl oder Grünlandgrundzahl und Ackerzahl oder Grünlandzahl.';


-- Zuordnungspfeil Bodenschätzung (Signaturnummer 2701)
-- ----------------------------------------------------
CREATE OR REPLACE VIEW s_zuordungspfeil_bodensch
AS 
 SELECT l.ogc_fid, 
        l.wkb_geometry
   FROM ap_lpo l
   JOIN alkis_beziehungen v
     ON l.gml_id = v.beziehung_von
   JOIN ax_bodenschaetzung b
     ON v.beziehung_zu = b.gml_id
  WHERE l.art = 'Pfeil'
    AND v.beziehungsart = 'dientZurDarstellungVon'
    AND ('DKKM1000' ~~ ANY (l.advstandardmodell))
    AND b.endet IS NULL
    AND l.endet IS NULL;
COMMENT ON VIEW s_zuordungspfeil_bodensch IS 'Sicht fuer Kartendarstellung: Zuordnungspfeil Bodenschätzung, Linie';

CREATE OR REPLACE VIEW s_zuordungspfeilspitze_bodensch 
AS 
 SELECT l.ogc_fid, 
        (((st_azimuth(st_pointn(l.wkb_geometry, 1), 
        st_pointn(l.wkb_geometry, 2)) * (- (180)::double precision)) / pi()) + (90)::double precision) AS winkel, 
        st_startpoint(l.wkb_geometry) AS wkb_geometry 
   FROM ap_lpo l
   JOIN alkis_beziehungen v
     ON l.gml_id = v.beziehung_von
   JOIN ax_bodenschaetzung b
     ON v.beziehung_zu = b.gml_id
  WHERE l.art = 'Pfeil'
    AND v.beziehungsart = 'dientZurDarstellungVon'
    AND ('DKKM1000' ~~ ANY (l.advstandardmodell))
    AND b.endet IS NULL
    AND l.endet IS NULL;
COMMENT ON VIEW s_zuordungspfeilspitze_flurstueck IS 'Sicht fuer Kartendarstellung: Zuordnungspfeil Flurstücksnummer, Spitze';

-- GRANT
-- Bodenschätzung
GRANT SELECT ON TABLE ax_bodenschaetzung_bodenart          TO ms6;
GRANT SELECT ON TABLE ax_bodenschaetzung_bodenart          TO mb27;
GRANT SELECT ON TABLE ax_bodenschaetzung_entstehungsartoderklimastufe  TO ms6;
GRANT SELECT ON TABLE ax_bodenschaetzung_entstehungsartoderklimastufe  TO mb27;
GRANT SELECT ON TABLE ax_bodenschaetzung_kulturart         TO ms6;
GRANT SELECT ON TABLE ax_bodenschaetzung_kulturart         TO mb27;
GRANT SELECT ON TABLE ax_bodenschaetzung_zustandsstufe     TO ms6;
GRANT SELECT ON TABLE ax_bodenschaetzung_zustandsstufe     TO mb27;
GRANT SELECT ON TABLE ax_bodenschaetzung_sonstigeangaben   TO ms6;
GRANT SELECT ON TABLE ax_bodenschaetzung_sonstigeangaben   TO mb27;
GRANT SELECT ON TABLE ax_grablochderbodenschaetzung_bedeutung  TO ms6;
GRANT SELECT ON TABLE ax_grablochderbodenschaetzung_bedeutung  TO mb27;
GRANT SELECT ON TABLE ax_musterlandesmusterundvergleichsstueck_merkmal TO ms6;
GRANT SELECT ON TABLE ax_musterlandesmusterundvergleichsstueck_merkmal TO mb27;
GRANT SELECT ON TABLE ax_bewertung_klassifizierung         TO ms6;
GRANT SELECT ON TABLE ax_bewertung_klassifizierung         TO mb27;

-- Bodenschätzung Views
GRANT SELECT ON TABLE s_bodensch_wms TO ms6;
GRANT SELECT ON TABLE s_bodensch_ent TO ms6;
GRANT SELECT ON TABLE s_bodensch_po  TO ms6;
GRANT SELECT ON TABLE s_bodensch_tx  TO ms6;
GRANT SELECT ON TABLE s_zuordungspfeilspitze_bodensch TO ms6;
GRANT SELECT ON TABLE s_zuordungspfeil_bodensch       TO ms6;

-- ENDE --
