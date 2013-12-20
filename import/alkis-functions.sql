-- alkis-functions.sql - Trigger-Funktionen für die Fortführung der 
--                       alkis_beziehungen aus Einträgen der delete-Tabelle

-- 2013-07-10: Erweiterung zur Verarbeitung der Replace-Sätze in ALKIS-Beziehungen 

-- 2013-12-10:	In der Function "update_fields_beziehungen" den Fall behandeln, dass ein Objekt einer 
--				neuen Beziehung in keiner Tabelle gefunden wird.
--				Wenn ein einzelnes Objekt fehlt, soll dies keine Auswirkungen auf andere Objekte haben.
--              Füllen von "zu_typename" auskommentiert.

-- Table/View/Sequence löschen, wenn vorhanden
CREATE OR REPLACE FUNCTION alkis_dropobject(t TEXT) RETURNS varchar AS $$
DECLARE
	c RECORD;
	s varchar;
	r varchar;
	d varchar;
	i integer;
	tn varchar;
BEGIN
	r := '';
	d := '';

	-- drop objects
	FOR c IN SELECT relkind,relname
		FROM pg_class
		JOIN pg_namespace ON pg_class.relnamespace=pg_namespace.oid
		WHERE pg_namespace.nspname='public' AND pg_class.relname=t
		ORDER BY relkind
	LOOP
		IF c.relkind = 'v' THEN
			r := r || d || 'Sicht ' || c.relname || ' gelöscht.';
			EXECUTE 'DROP VIEW ' || c.relname || ' CASCADE';
		ELSIF c.relkind = 'r' THEN
			r := r || d || 'Tabelle ' || c.relname || ' gelöscht.';
			EXECUTE 'DROP TABLE ' || c.relname || ' CASCADE';
		ELSIF c.relkind = 'S' THEN
			r := r || d || 'Sequenz ' || c.relname || ' gelöscht.';
			EXECUTE 'DROP SEQUENCE ' || c.relname;
		ELSIF c.relkind <> 'i' THEN
			r := r || d || 'Typ ' || c.table_type || '.' || c.table_name || ' unerwartet.';
		END IF;
		d := E'\n';
	END LOOP;

	FOR c IN SELECT indexname FROM pg_indexes WHERE schemaname='public' AND indexname=t
	LOOP
		r := r || d || 'Index ' || c.indexname || ' gelöscht.';
		EXECUTE 'DROP INDEX ' || c.indexname;
		d := E'\n';
	END LOOP;

	FOR c IN SELECT proname,proargtypes
		FROM pg_proc
		JOIN pg_namespace ON pg_proc.pronamespace=pg_namespace.oid
		WHERE pg_namespace.nspname='public' AND pg_proc.proname=t
	LOOP
		r := r || d || 'Funktion ' || c.proname || ' gelöscht.';

		s := 'DROP FUNCTION ' || c.proname || '(';
		d := '';

		FOR i IN array_lower(c.proargtypes,1)..array_upper(c.proargtypes,1) LOOP
			SELECT typname INTO tn FROM pg_type WHERE oid=c.proargtypes[i];
			s := s || d || tn;
			d := ',';
		END LOOP;

		s := s || ')';

		EXECUTE s;

		d := E'\n';
	END LOOP;

	FOR c IN SELECT relname,conname
		FROM pg_constraint
		JOIN pg_class ON pg_constraint.conrelid=pg_constraint.oid
		JOIN pg_namespace ON pg_constraint.connamespace=pg_namespace.oid
		WHERE pg_namespace.nspname='public' AND pg_constraint.conname=t
	LOOP
		r := r || d || 'Constraint ' || c.conname || ' von ' || c.relname || ' gelöscht.';
		EXECUTE 'ALTER TABLE ' || c.relname || ' DROP CONSTRAINT ' || c.conname;
		d := E'\n';
	END LOOP;

	RETURN r;
END;
$$ LANGUAGE plpgsql;

-- Alle ALKIS-Tabellen löschen
SELECT alkis_dropobject('alkis_drop');
CREATE FUNCTION alkis_drop() RETURNS varchar AS $$
DECLARE
	c RECORD;
	r VARCHAR;
	d VARCHAR;
BEGIN
	r := '';
	d := '';
	-- drop tables & views
	FOR c IN SELECT table_type,table_name FROM information_schema.tables WHERE table_schema='public' AND ( substr(table_name,1,3) IN ('ax_','ap_','ks_') OR table_name IN ('alkis_beziehungen','delete')) ORDER BY table_type DESC LOOP
		IF c.table_type = 'VIEW' THEN
			r := r || d || 'Sicht ' || c.table_name || ' gelöscht.';
			EXECUTE 'DROP VIEW ' || c.table_name || ' CASCADE';
		ELSIF c.table_type = 'BASE TABLE' THEN
			r := r || d || 'Tabelle ' || c.table_name || ' gelöscht.';
			EXECUTE 'DROP TABLE ' || c.table_name || ' CASCADE';
		ELSE
			r := r || d || 'Typ ' || c.table_type || '.' || c.table_name || ' unerwartet.';
		END IF;
		d := E'\n';
	END LOOP;

	-- clean geometry_columns
	DELETE FROM geometry_columns
		WHERE f_table_schema='public'
		AND ( substr(f_table_name,1,2) IN ('ax_','ap_','ks_')
		 OR f_table_name IN ('alkis_beziehungen','delete') );

	RETURN r;
END;
$$ LANGUAGE plpgsql;

-- Alle ALKIS-Tabellen leeren
SELECT alkis_dropobject('alkis_delete');
CREATE FUNCTION alkis_delete() RETURNS varchar AS $$
DECLARE
	c RECORD;
	r varchar;
	d varchar;
BEGIN
	r := '';
	d := '';

	-- drop views
	FOR c IN
		SELECT table_name
		FROM information_schema.tables
		WHERE table_schema='public' AND table_type='BASE TABLE'
		  AND ( substr(table_name,1,3) IN ('ax_','ap_','ks_')
			OR table_name IN ('alkis_beziehungen','delete') )
	LOOP
		r := r || d || c.table_name || ' wurde geleert.';
		EXECUTE 'DELETE FROM '||c.table_name;
		d := E'\n';
	END LOOP;

	RETURN r;
END;
$$ LANGUAGE plpgsql;

-- Übersicht erzeugen, die alle alkis_beziehungen mit den Typen der beteiligen ALKIS-Objekte versieht
SELECT alkis_dropobject('alkis_mviews');
CREATE FUNCTION alkis_mviews() RETURNS varchar AS $$
DECLARE
	sql TEXT;
	delim TEXT;
	c RECORD;
BEGIN
	SELECT alkis_dropobject('vbeziehungen') INTO sql;
	SELECT alkis_dropobject('vobjekte') INTO sql;

	delim := '';
	sql := 'CREATE VIEW vobjekte AS ';

	FOR c IN SELECT table_name FROM information_schema.columns WHERE column_name='gml_id' AND substr(table_name,1,3) IN ('ax_','ap_','ks_') LOOP
		sql := sql || delim || 'SELECT gml_id,beginnt,''' || c.table_name || ''' AS table_name FROM ' || c.table_name;
		delim := ' UNION ';
	END LOOP;

	EXECUTE sql;

--	CREATE UNIQUE INDEX vobjekte_gmlid ON vobjekte(gml_id,beginnt);
--	CREATE INDEX vobjekte_table ON vobjekte(table_name);

	CREATE VIEW vbeziehungen AS
		SELECT	beziehung_von,(SELECT table_name FROM vobjekte WHERE gml_id=beziehung_von) AS typ_von
			,beziehungsart
			,beziehung_zu,(SELECT table_name FROM vobjekte WHERE gml_id=beziehung_zu) AS typ_zu
		FROM alkis_beziehungen;

--	CREATE INDEX vbeziehungen_von    ON vbeziehungen(beziehung_von);
--	CREATE INDEX vbeziehungen_vontyp ON vbeziehungen(typ_von);
--	CREATE INDEX vbeziehungen_art    ON vbeziehungen(beziehungsart);
--	CREATE INDEX vbeziehungen_zu     ON vbeziehungen(beziehung_zu);
--	CREATE INDEX vbeziehungen_zutyp  ON vbeziehungen(typ_zu);

	RETURN 'ALKIS-Views erzeugt.';
END;
$$ LANGUAGE plpgsql;

-- Indizes erzeugen
SELECT alkis_dropobject('alkis_update_schema');
CREATE FUNCTION alkis_update_schema() RETURNS varchar AS $$
DECLARE
	sql TEXT;
	c RECORD;
	i RECORD;
	n INTEGER;
BEGIN
	-- Spalten in delete ergänzen
	SELECT count(*) INTO n FROM information_schema.columns WHERE table_schema='public' AND table_name='delete' AND column_name='ignored';
	IF n=0 THEN
		ALTER TABLE "delete" ADD ignored BOOLEAN;
	END IF;

	SELECT count(*) INTO n FROM information_schema.columns WHERE table_schema='public' AND table_name='delete' AND column_name='context';
	IF n=0 THEN
		ALTER TABLE "delete" ADD context VARCHAR;
	END IF;

	SELECT count(*) INTO n FROM information_schema.columns WHERE table_schema='public' AND table_name='delete' AND column_name='safetoignore';
	IF n=0 THEN
		ALTER TABLE "delete" ADD safetoignore VARCHAR;
	END IF;

	SELECT count(*) INTO n FROM information_schema.columns WHERE table_schema='public' AND table_name='delete' AND column_name='replacedby';
	IF n=0 THEN
		ALTER TABLE "delete" ADD replacedBy VARCHAR;
	END IF;

	-- Spalte identifier ergänzen, wo sie fehlt
	FOR c IN SELECT table_name FROM information_schema.columns a WHERE a.column_name='gml_id'
		AND     EXISTS (SELECT * FROM information_schema.columns b WHERE b.column_name='beginnt'    AND a.table_catalog=b.table_catalog AND a.table_schema=b.table_schema AND a.table_name=b.table_name)
		AND NOT EXISTS (SELECT * FROM information_schema.columns b WHERE b.column_name='identifier' AND a.table_catalog=b.table_catalog AND a.table_schema=b.table_schema AND a.table_name=b.table_name)
	LOOP
		EXECUTE 'ALTER TABLE ' || c.table_name || ' ADD identifier character(44)';
	END LOOP;

	-- Spalte endet ergänzen, wo sie fehlt
	FOR c IN SELECT table_name FROM information_schema.columns a WHERE a.column_name='gml_id'
		AND     EXISTS (SELECT * FROM information_schema.columns b WHERE b.column_name='beginnt' AND a.table_catalog=b.table_catalog AND a.table_schema=b.table_schema AND a.table_name=b.table_name)
		AND NOT EXISTS (SELECT * FROM information_schema.columns b WHERE b.column_name='endet'   AND a.table_catalog=b.table_catalog AND a.table_schema=b.table_schema AND a.table_name=b.table_name)
	LOOP
		EXECUTE 'ALTER TABLE ' || c.table_name || ' ADD endet character(20) CHECK (endet>beginnt)';
	END LOOP;

	-- Lebensdauer-Constraint ergänzen
	FOR c IN SELECT table_name FROM information_schema.columns a WHERE a.column_name='gml_id'
		AND EXISTS (SELECT * FROM information_schema.columns b WHERE b.column_name='beginnt' AND a.table_catalog=b.table_catalog AND a.table_schema=b.table_schema AND a.table_name=b.table_name)
		AND EXISTS (SELECT * FROM information_schema.columns b WHERE b.column_name='endet'   AND a.table_catalog=b.table_catalog AND a.table_schema=b.table_schema AND a.table_name=b.table_name)
	LOOP
		SELECT alkis_dropobject(c.table_name||'_lebensdauer');
		EXECUTE 'ALTER TABLE ' || c.table_name || ' ADD CONSTRAINT ' || c.table_name || '_lebensdauer CHECK (beginnt IS NOT NULL AND endet>beginnt)';
	END LOOP;

	-- Indizes aktualisieren
	FOR c IN SELECT table_name FROM information_schema.columns a WHERE a.column_name='gml_id'
		AND EXISTS (SELECT * FROM information_schema.columns b WHERE b.column_name='beginnt' AND a.table_catalog=b.table_catalog AND a.table_schema=b.table_schema AND a.table_name=b.table_name)
	LOOP
		-- Vorhandene Indizes droppen (TODO: Löscht auch die Sonderfälle - entfernen)
		FOR i IN EXECUTE 'SELECT indexname FROM pg_indexes WHERE NOT indexname LIKE ''%_pk'' AND schemaname=''public'' AND tablename='''||c.table_name||'''' LOOP
			EXECUTE 'DROP INDEX ' || i.indexname;
		END LOOP;

		-- Indizes erzeugen
		EXECUTE 'CREATE UNIQUE INDEX ' || c.table_name || '_id ON ' || c.table_name || '(gml_id,beginnt)';
		EXECUTE 'CREATE UNIQUE INDEX ' || c.table_name || '_ident ON ' || c.table_name || '(identifier)';
		EXECUTE 'CREATE INDEX ' || c.table_name || '_gmlid ON ' || c.table_name || '(gml_id)';
		EXECUTE 'CREATE INDEX ' || c.table_name || '_beginnt ON ' || c.table_name || '(beginnt)';
		EXECUTE 'CREATE INDEX ' || c.table_name || '_endet ON ' || c.table_name || '(endet)';
	END LOOP;

	-- Geometrieindizes aktualisieren
	FOR c IN SELECT table_name FROM information_schema.columns a WHERE a.column_name='gml_id'
		AND EXISTS (SELECT * FROM information_schema.columns b WHERE b.column_name='wkb_geometry' AND a.table_catalog=b.table_catalog AND a.table_schema=b.table_schema AND a.table_name=b.table_name)
	LOOP
		EXECUTE 'CREATE INDEX ' || c.table_name || '_geom ON ' || c.table_name || ' USING GIST (wkb_geometry)';
	END LOOP;

	RETURN 'Schema aktualisiert.';
END;
$$ LANGUAGE plpgsql;

-- Im Trigger 'delete_feature_trigger' muss eine dieser beiden Funktionen
-- (delete_feature_hist oder delete_feature_kill) verlinkt werden, je nachdem ob nur
-- aktuelle oder auch historische Objekte in der Datenbank geführt werden sollen.

-- Löschsatz verarbeiten (MIT Historie)
-- context='delete'        => "endet" auf aktuelle Zeit setzen
-- context='replace'       => "endet" des ersetzten auf "beginnt" des neuen Objekts setzen
CREATE OR REPLACE FUNCTION delete_feature_hist() RETURNS TRIGGER AS $$
DECLARE
	sql TEXT;
	gml_id TEXT;
	endete TEXT;
	n INTEGER;
BEGIN
	NEW.context := lower(NEW.context);
	gml_id      := substr(NEW.featureid, 1, 16);

	IF NEW.context IS NULL THEN
		NEW.context := 'delete';
	END IF;

	IF NEW.context='delete' THEN
		endete := to_char(CURRENT_TIMESTAMP AT TIME ZONE 'UTC','YYYY-MM-DD"T"HH24:MI:SS"Z"');

	ELSIF NEW.context='replace' THEN
		NEW.safetoignore := lower(NEW.safetoignore);

		IF NEW.safetoignore IS NULL THEN
			RAISE EXCEPTION '%: safeToIgnore nicht gesetzt.', NEW.featureid;
		ELSIF NEW.safetoignore<>'true' AND NEW.safetoignore<>'false' THEN
			RAISE EXCEPTION '%: safeToIgnore ''%'' ungültig (''true'' oder ''false'' erwartet).', NEW.featureid, NEW.safetoignore;
		END IF;

		IF NEW.replacedBy IS NULL OR length(NEW.replacedBy)<16 THEN
			IF NEW.safetoignore = 'true' THEN
				RAISE NOTICE '%: Nachfolger ''%'' nicht richtig gesetzt - ignoriert', NEW.featureid, NEW.replacedBy;
				NEW.ignored := true;
				RETURN NEW;
			ELSE
				RAISE EXCEPTION '%: Nachfolger ''%'' nicht richtig gesetzt - Abbruch', NEW.featureid, NEW.replacedBy;
			END IF;
		END IF;

		IF length(NEW.replacedBy)=16 THEN
			EXECUTE 'SELECT beginnt FROM ' || NEW.typename ||
			        ' WHERE gml_id=''' || NEW.replacedBy || ''' AND endet IS NULL' ||
				' ORDER BY beginnt DESC LIMIT 1'
                           INTO endete;
		ELSE
			-- replaceBy mit Timestamp
			EXECUTE 'SELECT beginnt FROM ' || NEW.typename ||
			        ' WHERE identifier=''urn:adv:oid:' || NEW.replacedBy || ''''
			   INTO endete;
			IF endete IS NULL THEN
				EXECUTE 'SELECT beginnt FROM ' || NEW.typename ||
					' WHERE gml_id=''' || substr(NEW.replacedBy,1,16) || ''' AND endet IS NULL' ||
					' ORDER BY beginnt DESC LIMIT 1'
				   INTO endete;
			END IF;
		END IF;

		IF endete IS NULL THEN
			IF NEW.safetoignore = 'true' THEN
				RAISE NOTICE '%: Nachfolger % nicht gefunden - ignoriert', NEW.featureid, NEW.replacedBy;
				NEW.ignored := true;
				RETURN NEW;
			ELSE
				RAISE EXCEPTION '%: Nachfolger % nicht gefunden', NEW.featureid, NEW.replacedBy;
			END IF;
		END IF;
	ELSE
		RAISE EXCEPTION '%: Ungültiger Kontext % (''delete'' oder ''replace'' erwartet).', NEW.featureid, NEW.context;
	END IF;

	sql	:= 'UPDATE ' || NEW.typename
		|| ' SET endet=''' || endete || ''''
		|| ' WHERE gml_id=''' || gml_id || ''''
		|| ' AND endet IS NULL'
		|| ' AND beginnt<''' || endete || '''';
	-- RAISE NOTICE 'SQL: %', sql;
	EXECUTE sql;
	GET DIAGNOSTICS n = ROW_COUNT;
	IF n<>1 THEN
		RAISE NOTICE 'SQL: %', sql;
		IF NEW.context = 'delete' OR NEW.safetoignore = 'true' THEN
			RAISE NOTICE '%: Untergangsdatum von % Objekten statt nur einem auf % gesetzt - ignoriert', NEW.featureid, n, endete;
			NEW.ignored := true;
			RETURN NEW;
		ELSE
			RAISE EXCEPTION '%: Untergangsdatum von % Objekten statt nur einem auf % gesetzt - Abbruch', NEW.featureid, n, endete;
		END IF;
	END IF;

	NEW.ignored := false;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Löschsatz verarbeiten (OHNE Historie)
-- historische Objekte werden sofort gelöscht.
-- Siehe Mail W. Jacobs vom 23.03.2012 in PostNAS-Mailingliste
-- geaendert krz FJ 2012-10-31
-- geändertt krz FJ 2013-07-10 auf Vorschlag MB Krs. Unna
CREATE OR REPLACE FUNCTION delete_feature_kill() RETURNS TRIGGER AS $$
DECLARE
	query TEXT;
	begsql TEXT;
	aktbeg TEXT;
	gml_id TEXT;
	query_bez TEXT; -- 2013-07-10 Erweiterung
BEGIN
	NEW.typename := lower(NEW.typename);
	NEW.context := lower(NEW.context);
	gml_id      := substr(NEW.featureid, 1, 16);

	IF NEW.context IS NULL THEN
		NEW.context := 'delete';
	END IF;

	IF NEW.context='delete' THEN
		-- ersatzloses Loeschen eines Objektes

		query := 'DELETE FROM ' || NEW.typename
			|| ' WHERE gml_id = ''' || gml_id || '''';
		EXECUTE query;

		query := 'DELETE FROM alkis_beziehungen WHERE beziehung_von = ''' || gml_id
			|| ''' OR beziehung_zu = ''' || gml_id || '''';
		EXECUTE query;
		RAISE NOTICE 'Lösche gml_id % in % und Beziehungen', gml_id, NEW.typename;

	ELSE
		-- Ersetzen eines Objektes (Replace)
		-- In der objekt-Tabelle sind bereits 2 Objekte vorhanden (alt und neu).
		-- Die 2 Datensätze unterscheiden sich nur in ogc_fid und beginnt

		-- beginnt-Wert des aktuellen Objektes ermitteln
		-- RAISE NOTICE 'Suche beginnt von neuem gml_id % ', substr(NEW.replacedBy, 1, 16);
		begsql := 'SELECT max(beginnt) FROM ' || NEW.typename || ' WHERE gml_id = ''' || substr(NEW.replacedBy, 1, 16) || ''' AND endet IS NULL';
		EXECUTE begsql INTO aktbeg;

		-- Nur alte Objekte entfernen
		query := 'DELETE FROM ' || NEW.typename
			|| ' WHERE gml_id = ''' || gml_id || ''' AND beginnt < ''' || aktbeg || '''';
		EXECUTE query;

		-- Tabelle "alkis_beziehungen"
        -- Löschen der Beziehungen des in einer anderen Tabelle ersetzten Objektes.
		IF gml_id = substr(NEW.replacedBy, 1, 16) THEN -- gml_id gleich
			-- Beziehungen des Objektes wurden redundant noch einmal eingetragen
			-- ToDo:         HIER sofort die Redundanzen zum aktuellen Objekt beseitigen.
			-- Workaround: Nach der Konvertierung werden im Post-Processing
			--             ALLE Redundanzen mit einem SQL-Statement beseitigt.
		--	RAISE NOTICE 'Ersetze gleiche gml_id % in %', gml_id, NEW.typename;

		-- ENTWURF FJ, noch ungetestet:
        -- Bei Replace wird zur aktuellen gml_id nach redundanten Sätzen in alkis_beziehungen gesucht.
        -- Die Version mit dem kleineren serial-Feld wird gelöscht.
		--query := 'DELETE FROM alkis_beziehungen AS bezalt
		--	WHERE (bezalt.beziehung_von = ' || gml_id || ' OR bezalt.beziehung_zu = ' || gml_id ||')
		--	AND EXISTS (SELECT ogc_fid FROM alkis_beziehungen AS bezneu
		--		WHERE bezalt.beziehung_von = bezneu.beziehung_von
		--		AND bezalt.beziehung_zu = bezneu.beziehung_zu
		--		AND bezalt.beziehungsart = bezneu.beziehungsart
		--		AND bezalt.ogc_fid < bezneu.ogc_fid);'
		--EXECUTE query;

		-- Funktioniert wahrscheinlich nicht wegen:
		--   Der zu löschende Satz in "alkis_beziehungen" muss nicht komplett redandant sein (von+zu+art). 
        -- Es ist entweder ein Replace des von-objektes passiert oder ein Replace des zu-Objektes.
		-- In beiden Fällen kann auf der entgegen gesetzten Seite der Beziehung auch ein anderes Objekt sein.
		-- Dummerweise sind die neuen Beziehungen mit der gleichen gml_id schon eingetragen worden.

        -- 2013-07-10 Alternative Version von Marvon Brandt (Krs. Unna) 
        -- Diese Version setzt voraus, dass das Feld 'beginnt' beim Einfügen der Beziehung aus 
        -- dem Satz des von-Objektes kopiert wurde.
        -- Dies geschieht in "update_fields_beziehungen" als Trigger beim Einfügen der alkis_beziehung.
           -- alte Beziehungen löschen
           query_bez := 'DELETE FROM alkis_beziehungen WHERE beziehung_von = ''' || gml_id  
                        || ''' AND beginnt < ''' || aktbeg || '''';
           RAISE NOTICE 'Lösche in beziehungen alte gml_id % vor %', gml_id, aktbeg;
           EXECUTE query_bez;

          -- Was ist, wenn das in der delete-Tabelle ersetzte Objekt nur/auch auf der zu-Seite der Beziehung auftaucht.
          -- Hier wird es nur auf der von-Seite gesucht.
 
        -- 2013-07-10 Erweiterung Ende

		ELSE
			-- replace mit ungleicher gml_id
			-- Falls dies vorkommt, die Function erweitern
			RAISE EXCEPTION '%: neue gml_id % bei Replace in %. alkis_beziehungen muss aktualisiert werden!', gml_id, NEW.replacedBy, NEW.typename;
		END IF;
	END IF;

	NEW.ignored := false;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Beziehungssätze aufräumen
CREATE OR REPLACE FUNCTION alkis_beziehung_inserted() RETURNS TRIGGER AS $$
BEGIN
	DELETE FROM alkis_beziehungen WHERE ogc_fid<NEW.ogc_fid AND beziehung_von=NEW.beziehung_von AND beziehungsart=NEW.beziehungsart AND beziehung_zu=NEW.beziehung_zu;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Wenn die Datenbank MIT Historie angelegt wurde, kann nach dem Laden hiermit aufgeräumt werden.
CREATE OR REPLACE FUNCTION alkis_delete_all_endet() RETURNS void AS $$
DECLARE
	c RECORD;
BEGIN
	-- In allen Tabellen die Objekte löschen, die ein Ende-Datum haben
	FOR c IN
		SELECT table_name
		FROM information_schema.columns a
		WHERE a.column_name='endet'
		ORDER BY table_name
	LOOP
		EXECUTE 'DELETE FROM ' || c.table_name || ' WHERE NOT endet IS NULL';
		-- RAISE NOTICE 'Lösche ''endet'' in: %', c.table_name;
	END LOOP;
END;
$$ LANGUAGE plpgsql;


-- 2013-07-10: Erweiterung zur Verarbeitung der Replace-Sätze in ALKIS-Beziehungen 

-- Zusätzliche Felder für alkis_beziehungen auswerten.
-- In die Tabelle alkis_beziehungen wird zusätzlich zu den gml_ids der Objekte auf von- und zu-Seite 
-- auch noch eingetragen, aus welcher Tabelle die gml_id stammt. Dies sollte langfristig direkt 
-- vom PostNAS (ogr2ogr) gemacht werden so dass dieser Trigger als Provisorium anzusehen ist.

-- Eventuell kann auch die Sammlung der bekannten Tabellen-Namen als Kette von UNION-Zeilen ersetzt werden
-- durch eine smarte Function, die eine gefilterte Liste der vorhandenen Tabellen (-namen) durchsucht.
-- Somit würden auch solche Tabellen einbezogen, die von PostNAS nachträglich angelegt wurden.

-- Das Beginnt-Datum des Datensatzes auf der Seite "beziehung_von" wird zu der Beziehung kopiert (redundant).
CREATE OR REPLACE FUNCTION update_fields_beziehungen() RETURNS TRIGGER AS $$
DECLARE
	sql_vonTypename TEXT;
	sql_zuTypename TEXT;
	sql_beginnt TEXT;
BEGIN
    -- Die folgende Liste von Tabellen-Namen kann reduziert werden, auf solche Tabellen, die auf
    -- von-Seite von Beziehungen auftauchen können.
    sql_vonTypename := 
       'SELECT ''ap_darstellung'' FROM ap_darstellung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ap_lpo'' FROM ap_lpo WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ap_lto'' FROM ap_lto WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ap_ppo'' FROM ap_ppo WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ap_pto'' FROM ap_pto WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_anderefestlegungnachwasserrecht'' FROM ax_anderefestlegungnachwasserrecht WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_anschrift'' FROM ax_anschrift WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_aufnahmepunkt'' FROM ax_aufnahmepunkt WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_bahnverkehr'' FROM ax_bahnverkehr WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_bahnverkehrsanlage'' FROM ax_bahnverkehrsanlage WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_baublock'' FROM ax_baublock WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_bauraumoderbodenordnungsrecht'' FROM ax_bauraumoderbodenordnungsrecht WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_bauteil'' FROM ax_bauteil WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_bauwerkimgewaesserbereich'' FROM ax_bauwerkimgewaesserbereich WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_bauwerkimverkehrsbereich'' FROM ax_bauwerkimverkehrsbereich WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_bauwerkoderanlagefuerindustrieundgewerbe'' FROM ax_bauwerkoderanlagefuerindustrieundgewerbe WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_bauwerkoderanlagefuersportfreizeitunderholung'' FROM ax_bauwerkoderanlagefuersportfreizeitunderholung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_bergbaubetrieb'' FROM ax_bergbaubetrieb WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_besondereflurstuecksgrenze'' FROM ax_besondereflurstuecksgrenze WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_besonderegebaeudelinie'' FROM ax_besonderegebaeudelinie WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_besondererbauwerkspunkt'' FROM ax_besondererbauwerkspunkt WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_besonderergebaeudepunkt'' FROM ax_besonderergebaeudepunkt WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_besondererhoehenpunkt'' FROM ax_besondererhoehenpunkt WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_besonderertopographischerpunkt'' FROM ax_besonderertopographischerpunkt WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_bewertung'' FROM ax_bewertung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_bodenschaetzung'' FROM ax_bodenschaetzung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_boeschungkliff'' FROM ax_boeschungkliff WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_boeschungsflaeche'' FROM ax_boeschungsflaeche WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_buchungsblatt'' FROM ax_buchungsblatt WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_buchungsblattbezirk'' FROM ax_buchungsblattbezirk WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_buchungsstelle'' FROM ax_buchungsstelle WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_bundesland'' FROM ax_bundesland WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_dammwalldeich'' FROM ax_dammwalldeich WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_denkmalschutzrecht'' FROM ax_denkmalschutzrecht WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_dienststelle'' FROM ax_dienststelle WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_duene'' FROM ax_duene WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_einrichtungenfuerdenschiffsverkehr'' FROM ax_einrichtungenfuerdenschiffsverkehr WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_einrichtunginoeffentlichenbereichen'' FROM ax_einrichtunginoeffentlichenbereichen WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_felsenfelsblockfelsnadel'' FROM ax_felsenfelsblockfelsnadel WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_firstlinie'' FROM ax_firstlinie WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_flaechebesondererfunktionalerpraegung'' FROM ax_flaechebesondererfunktionalerpraegung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_flaechegemischternutzung'' FROM ax_flaechegemischternutzung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_fliessgewaesser'' FROM ax_fliessgewaesser WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_flugverkehr'' FROM ax_flugverkehr WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_flugverkehrsanlage'' FROM ax_flugverkehrsanlage WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_flurstueck'' FROM ax_flurstueck WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_forstrecht'' FROM ax_forstrecht WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_fortfuehrungsfall'' FROM ax_fortfuehrungsfall WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_fortfuehrungsnachweisdeckblatt'' FROM ax_fortfuehrungsnachweisdeckblatt WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_friedhof'' FROM ax_friedhof WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_gebaeude'' FROM ax_gebaeude WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_gebaeudeausgestaltung'' FROM ax_gebaeudeausgestaltung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_gehoelz'' FROM ax_gehoelz WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_gelaendekante'' FROM ax_gelaendekante WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_gemarkung'' FROM ax_gemarkung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_gemarkungsteilflur'' FROM ax_gemarkungsteilflur WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_gemeinde'' FROM ax_gemeinde WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_gemeindeteil'' FROM ax_gemeindeteil WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_georeferenziertegebaeudeadresse'' FROM ax_georeferenziertegebaeudeadresse WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_gewaessermerkmal'' FROM ax_gewaessermerkmal WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_gleis'' FROM ax_gleis WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_grablochderbodenschaetzung'' FROM ax_grablochderbodenschaetzung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_grenzpunkt'' FROM ax_grenzpunkt WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_hafenbecken'' FROM ax_hafenbecken WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_halde'' FROM ax_halde WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_heide'' FROM ax_heide WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_heilquellegasquelle'' FROM ax_heilquellegasquelle WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_historischesbauwerkoderhistorischeeinrichtung'' FROM ax_historischesbauwerkoderhistorischeeinrichtung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_historischesflurstueck'' FROM ax_historischesflurstueck WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_historischesflurstueckalb'' FROM ax_historischesflurstueckalb WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_historischesflurstueckohneraumbezug'' FROM ax_historischesflurstueckohneraumbezug WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_hoehenlinie'' FROM ax_hoehenlinie WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_hoehleneingang'' FROM ax_hoehleneingang WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_industrieundgewerbeflaeche'' FROM ax_industrieundgewerbeflaeche WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_klassifizierungnachstrassenrecht'' FROM ax_klassifizierungnachstrassenrecht WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_klassifizierungnachwasserrecht'' FROM ax_klassifizierungnachwasserrecht WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_kleinraeumigerlandschaftsteil'' FROM ax_kleinraeumigerlandschaftsteil WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_kommunalesgebiet'' FROM ax_kommunalesgebiet WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_kreisregion'' FROM ax_kreisregion WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_lagebezeichnungkatalogeintrag'' FROM ax_lagebezeichnungkatalogeintrag WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_lagebezeichnungmithausnummer'' FROM ax_lagebezeichnungmithausnummer WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_lagebezeichnungmitpseudonummer'' FROM ax_lagebezeichnungmitpseudonummer WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_lagebezeichnungohnehausnummer'' FROM ax_lagebezeichnungohnehausnummer WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_landwirtschaft'' FROM ax_landwirtschaft WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_leitung'' FROM ax_leitung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_meer'' FROM ax_meer WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_moor'' FROM ax_moor WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_musterlandesmusterundvergleichsstueck'' FROM ax_musterlandesmusterundvergleichsstueck WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_namensnummer'' FROM ax_namensnummer WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_naturumweltoderbodenschutzrecht'' FROM ax_naturumweltoderbodenschutzrecht WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_person'' FROM ax_person WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_platz'' FROM ax_platz WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_punktkennunguntergegangen'' FROM ax_punktkennunguntergegangen WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_punktortag'' FROM ax_punktortag WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_punktortau'' FROM ax_punktortau WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_punktortta'' FROM ax_punktortta WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_regierungsbezirk'' FROM ax_regierungsbezirk WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_reservierung'' FROM ax_reservierung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_schifffahrtsliniefaehrverkehr'' FROM ax_schifffahrtsliniefaehrverkehr WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_schiffsverkehr'' FROM ax_schiffsverkehr WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_schutzgebietnachnaturumweltoderbodenschutzrecht'' FROM ax_schutzgebietnachnaturumweltoderbodenschutzrecht WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_schutzgebietnachwasserrecht'' FROM ax_schutzgebietnachwasserrecht WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_schutzzone'' FROM ax_schutzzone WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_seilbahnschwebebahn'' FROM ax_seilbahnschwebebahn WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_sicherungspunkt'' FROM ax_sicherungspunkt WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_soll'' FROM ax_soll WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_sonstigervermessungspunkt'' FROM ax_sonstigervermessungspunkt WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_sonstigesbauwerkodersonstigeeinrichtung'' FROM ax_sonstigesbauwerkodersonstigeeinrichtung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_sonstigesrecht'' FROM ax_sonstigesrecht WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_sportfreizeitunderholungsflaeche'' FROM ax_sportfreizeitunderholungsflaeche WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_stehendesgewaesser'' FROM ax_stehendesgewaesser WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_strassenverkehr'' FROM ax_strassenverkehr WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_strassenverkehrsanlage'' FROM ax_strassenverkehrsanlage WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_sumpf'' FROM ax_sumpf WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_tagebaugrubesteinbruch'' FROM ax_tagebaugrubesteinbruch WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_tagesabschnitt'' FROM ax_tagesabschnitt WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_topographischelinie'' FROM ax_topographischelinie WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_transportanlage'' FROM ax_transportanlage WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_turm'' FROM ax_turm WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_unlandvegetationsloseflaeche'' FROM ax_unlandvegetationsloseflaeche WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_untergeordnetesgewaesser'' FROM ax_untergeordnetesgewaesser WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_vegetationsmerkmal'' FROM ax_vegetationsmerkmal WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_vertretung'' FROM ax_vertretung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_verwaltung'' FROM ax_verwaltung WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_verwaltungsgemeinschaft'' FROM ax_verwaltungsgemeinschaft WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_vorratsbehaelterspeicherbauwerk'' FROM ax_vorratsbehaelterspeicherbauwerk WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_wald'' FROM ax_wald WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_wasserspiegelhoehe'' FROM ax_wasserspiegelhoehe WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_weg'' FROM ax_weg WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_wegpfadsteig'' FROM ax_wegpfadsteig WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_wohnbauflaeche'' FROM ax_wohnbauflaeche WHERE gml_id = ''' || NEW.beziehung_von || ''' UNION
		SELECT ''ax_wohnplatz'' FROM ax_wohnplatz WHERE gml_id = ''' || NEW.beziehung_von || '''';
	EXECUTE sql_vonTypename INTO NEW.von_typename;

	-- 2013-12-10: Den Fall behandeln, dass das Objekt in keiner Tabelle gefunden wird.
	-- NULL-Wert führt zu Abbruch des 2. Execute. Dies führt in einer Kettenreaktion dazu,
	-- dass auch weitere Objekte nicht eingefügt werden können.
	IF NEW.von_typename IS NULL THEN
		RAISE NOTICE 'Neue gml_id fuer "beziehung_von" in "alkis_beziehungen" ist keiner Tabelle zuzuordnen. "beziehung_von" und "beginnt" bleiben leer. gml_id: %', NEW.beziehung_von;
	ELSE
		-- Der von_typename (= Tabellen-Name) muss zuvor ermittelt worden sein. Dort wird nach der gml_id gesucht. 
		sql_beginnt := 'SELECT max(beginnt) FROM ' || NEW.von_typename || ' WHERE gml_id = ''' || NEW.beziehung_von ||'''';
		EXECUTE sql_beginnt INTO NEW.beginnt;
		-- Was passiert bei Replace eines Objektes, das nur auf der zu-Seite einer Beziehung auftaucht.
	END IF;

    -- Die folgende Liste von Tabellen-Namen kann reduziert werden, auf solche Tabellen, die auf
    -- zu-Seite von Beziehungen auftauchen können.
	-- Diese Spalte erleichtert die Analyse, wird aber nicht für die aktuelle Version des Triggers nicht verwendet.
    -- Diese Anweisung liefert nur teilweise ein Ergebnis.

-- -- 2013-12-10 Wird nicht benötigt und ist auch nur teilweise erfolgreich. 
-- --            Dann den Aufwand sparen. Auskommentiert.
--	sql_zuTypename := 
--       'SELECT ''ap_darstellung'' FROM ap_darstellung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ap_lpo'' FROM ap_lpo WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ap_lto'' FROM ap_lto WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ap_ppo'' FROM ap_ppo WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ap_pto'' FROM ap_pto WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_anderefestlegungnachwasserrecht'' FROM ax_anderefestlegungnachwasserrecht WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_anschrift'' FROM ax_anschrift WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_aufnahmepunkt'' FROM ax_aufnahmepunkt WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_bahnverkehr'' FROM ax_bahnverkehr WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_bahnverkehrsanlage'' FROM ax_bahnverkehrsanlage WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_baublock'' FROM ax_baublock WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_bauraumoderbodenordnungsrecht'' FROM ax_bauraumoderbodenordnungsrecht WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_bauteil'' FROM ax_bauteil WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_bauwerkimgewaesserbereich'' FROM ax_bauwerkimgewaesserbereich WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_bauwerkimverkehrsbereich'' FROM ax_bauwerkimverkehrsbereich WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_bauwerkoderanlagefuerindustrieundgewerbe'' FROM ax_bauwerkoderanlagefuerindustrieundgewerbe WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_bauwerkoderanlagefuersportfreizeitunderholung'' FROM ax_bauwerkoderanlagefuersportfreizeitunderholung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_bergbaubetrieb'' FROM ax_bergbaubetrieb WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_besondereflurstuecksgrenze'' FROM ax_besondereflurstuecksgrenze WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_besonderegebaeudelinie'' FROM ax_besonderegebaeudelinie WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_besondererbauwerkspunkt'' FROM ax_besondererbauwerkspunkt WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_besonderergebaeudepunkt'' FROM ax_besonderergebaeudepunkt WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_besondererhoehenpunkt'' FROM ax_besondererhoehenpunkt WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_besonderertopographischerpunkt'' FROM ax_besonderertopographischerpunkt WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_bewertung'' FROM ax_bewertung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_bodenschaetzung'' FROM ax_bodenschaetzung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_boeschungkliff'' FROM ax_boeschungkliff WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_boeschungsflaeche'' FROM ax_boeschungsflaeche WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_buchungsblatt'' FROM ax_buchungsblatt WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_buchungsblattbezirk'' FROM ax_buchungsblattbezirk WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_buchungsstelle'' FROM ax_buchungsstelle WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_bundesland'' FROM ax_bundesland WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_dammwalldeich'' FROM ax_dammwalldeich WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_denkmalschutzrecht'' FROM ax_denkmalschutzrecht WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_dienststelle'' FROM ax_dienststelle WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_duene'' FROM ax_duene WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_einrichtungenfuerdenschiffsverkehr'' FROM ax_einrichtungenfuerdenschiffsverkehr WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_einrichtunginoeffentlichenbereichen'' FROM ax_einrichtunginoeffentlichenbereichen WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_felsenfelsblockfelsnadel'' FROM ax_felsenfelsblockfelsnadel WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_firstlinie'' FROM ax_firstlinie WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_flaechebesondererfunktionalerpraegung'' FROM ax_flaechebesondererfunktionalerpraegung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_flaechegemischternutzung'' FROM ax_flaechegemischternutzung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_fliessgewaesser'' FROM ax_fliessgewaesser WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_flugverkehr'' FROM ax_flugverkehr WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_flugverkehrsanlage'' FROM ax_flugverkehrsanlage WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_flurstueck'' FROM ax_flurstueck WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_forstrecht'' FROM ax_forstrecht WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_fortfuehrungsfall'' FROM ax_fortfuehrungsfall WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_fortfuehrungsnachweisdeckblatt'' FROM ax_fortfuehrungsnachweisdeckblatt WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_friedhof'' FROM ax_friedhof WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_gebaeude'' FROM ax_gebaeude WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_gebaeudeausgestaltung'' FROM ax_gebaeudeausgestaltung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_gehoelz'' FROM ax_gehoelz WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_gelaendekante'' FROM ax_gelaendekante WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_gemarkung'' FROM ax_gemarkung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_gemarkungsteilflur'' FROM ax_gemarkungsteilflur WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_gemeinde'' FROM ax_gemeinde WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_gemeindeteil'' FROM ax_gemeindeteil WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_georeferenziertegebaeudeadresse'' FROM ax_georeferenziertegebaeudeadresse WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_gewaessermerkmal'' FROM ax_gewaessermerkmal WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_gleis'' FROM ax_gleis WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_grablochderbodenschaetzung'' FROM ax_grablochderbodenschaetzung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_grenzpunkt'' FROM ax_grenzpunkt WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_hafenbecken'' FROM ax_hafenbecken WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_halde'' FROM ax_halde WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_heide'' FROM ax_heide WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_heilquellegasquelle'' FROM ax_heilquellegasquelle WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_historischesbauwerkoderhistorischeeinrichtung'' FROM ax_historischesbauwerkoderhistorischeeinrichtung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_historischesflurstueck'' FROM ax_historischesflurstueck WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_historischesflurstueckalb'' FROM ax_historischesflurstueckalb WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_historischesflurstueckohneraumbezug'' FROM ax_historischesflurstueckohneraumbezug WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_hoehenlinie'' FROM ax_hoehenlinie WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_hoehleneingang'' FROM ax_hoehleneingang WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_industrieundgewerbeflaeche'' FROM ax_industrieundgewerbeflaeche WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_klassifizierungnachstrassenrecht'' FROM ax_klassifizierungnachstrassenrecht WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_klassifizierungnachwasserrecht'' FROM ax_klassifizierungnachwasserrecht WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_kleinraeumigerlandschaftsteil'' FROM ax_kleinraeumigerlandschaftsteil WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_kommunalesgebiet'' FROM ax_kommunalesgebiet WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_kreisregion'' FROM ax_kreisregion WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_lagebezeichnungkatalogeintrag'' FROM ax_lagebezeichnungkatalogeintrag WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_lagebezeichnungmithausnummer'' FROM ax_lagebezeichnungmithausnummer WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_lagebezeichnungmitpseudonummer'' FROM ax_lagebezeichnungmitpseudonummer WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_lagebezeichnungohnehausnummer'' FROM ax_lagebezeichnungohnehausnummer WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_landwirtschaft'' FROM ax_landwirtschaft WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_leitung'' FROM ax_leitung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_meer'' FROM ax_meer WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_moor'' FROM ax_moor WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_musterlandesmusterundvergleichsstueck'' FROM ax_musterlandesmusterundvergleichsstueck WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_namensnummer'' FROM ax_namensnummer WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_naturumweltoderbodenschutzrecht'' FROM ax_naturumweltoderbodenschutzrecht WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_person'' FROM ax_person WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_platz'' FROM ax_platz WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_punktkennunguntergegangen'' FROM ax_punktkennunguntergegangen WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_punktortag'' FROM ax_punktortag WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_punktortau'' FROM ax_punktortau WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_punktortta'' FROM ax_punktortta WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_regierungsbezirk'' FROM ax_regierungsbezirk WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_reservierung'' FROM ax_reservierung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_schifffahrtsliniefaehrverkehr'' FROM ax_schifffahrtsliniefaehrverkehr WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_schiffsverkehr'' FROM ax_schiffsverkehr WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_schutzgebietnachnaturumweltoderbodenschutzrecht'' FROM ax_schutzgebietnachnaturumweltoderbodenschutzrecht WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_schutzgebietnachwasserrecht'' FROM ax_schutzgebietnachwasserrecht WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_schutzzone'' FROM ax_schutzzone WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_seilbahnschwebebahn'' FROM ax_seilbahnschwebebahn WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_sicherungspunkt'' FROM ax_sicherungspunkt WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_soll'' FROM ax_soll WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_sonstigervermessungspunkt'' FROM ax_sonstigervermessungspunkt WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_sonstigesbauwerkodersonstigeeinrichtung'' FROM ax_sonstigesbauwerkodersonstigeeinrichtung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_sonstigesrecht'' FROM ax_sonstigesrecht WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_sportfreizeitunderholungsflaeche'' FROM ax_sportfreizeitunderholungsflaeche WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_stehendesgewaesser'' FROM ax_stehendesgewaesser WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_strassenverkehr'' FROM ax_strassenverkehr WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_strassenverkehrsanlage'' FROM ax_strassenverkehrsanlage WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_sumpf'' FROM ax_sumpf WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_tagebaugrubesteinbruch'' FROM ax_tagebaugrubesteinbruch WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_tagesabschnitt'' FROM ax_tagesabschnitt WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_topographischelinie'' FROM ax_topographischelinie WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_transportanlage'' FROM ax_transportanlage WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_turm'' FROM ax_turm WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_unlandvegetationsloseflaeche'' FROM ax_unlandvegetationsloseflaeche WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_untergeordnetesgewaesser'' FROM ax_untergeordnetesgewaesser WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_vegetationsmerkmal'' FROM ax_vegetationsmerkmal WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_vertretung'' FROM ax_vertretung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_verwaltung'' FROM ax_verwaltung WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_verwaltungsgemeinschaft'' FROM ax_verwaltungsgemeinschaft WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_vorratsbehaelterspeicherbauwerk'' FROM ax_vorratsbehaelterspeicherbauwerk WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_wald'' FROM ax_wald WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_wasserspiegelhoehe'' FROM ax_wasserspiegelhoehe WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_weg'' FROM ax_weg WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_wegpfadsteig'' FROM ax_wegpfadsteig WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_wohnbauflaeche'' FROM ax_wohnbauflaeche WHERE gml_id = ''' || NEW.beziehung_zu || ''' UNION
--		SELECT ''ax_wohnplatz'' FROM ax_wohnplatz WHERE gml_id = ''' || NEW.beziehung_zu || '''';
--	EXECUTE sql_zuTypename INTO NEW.zu_typename;
-- -- 2013-12-10 Ende

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;
