
-- PostNAS 0.8 Schema
-- 2014-10-14 Spalten-Format aendern von integer nach character.
-- Die Schema-�nderung auf bestehende gef�llt Datenbanken anwenden.

-- Neue Spalte hinzuf�gen
ALTER TABLE ax_wirtschaftlicheeinheit ADD column  anlass_neu character varying; 

-- Inhalt �bertragen
UPDATE      ax_wirtschaftlicheeinheit SET         anlass_neu = cast(anlass AS character varying);

-- alte Spalte wegnehmen
ALTER TABLE ax_wirtschaftlicheeinheit DROP column anlass; 

-- Name korrigieren
ALTER TABLE ax_wirtschaftlicheeinheit rename      anlass_neu TO anlass;

-- Gef�llt?
-- SELECT COUNT(anlass) AS anzahl FROM ax_wirtschaftlicheeinheit;
