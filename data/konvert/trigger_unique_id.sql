-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- unique_id - Eindeutigkeit von "gml_id", "beginnt" und "endet" 
--             sicherstellen und Historie auf Basis der gml_id pflegen
--
-- Fr. Nov 4 2011 ralf dot suhr at itc-halle dot de
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


SET client_encoding = 'UTF-8';


CREATE OR REPLACE FUNCTION public.unique_id()
  RETURNS TRIGGER AS
$$
DECLARE
  _test       boolean;
BEGIN

  IF NEW.gml_id IS NULL THEN
    RAISE NOTICE 'Leere gml_id in % abgelehnt', TG_RELNAME;
    RETURN NULL;
  END IF;

  -- doppelte Datensätze vermeiden (auch NBA)
  FOR _test IN EXECUTE '
      SELECT TRUE
      FROM public.' || TG_RELNAME || '
      WHERE gml_id = ''' || substr(NEW.gml_id, 1 , 16) || ''' AND
        beginnt = ''' || NEW.beginnt || ''' AND
        endet IS NULL
      LIMIT 1' LOOP
    -- Abarbeitung beenden
    RETURN NULL;
  END LOOP;

  -- auf NBA Update testen
  IF char_length(NEW.gml_id) > 18 THEN
    NEW.gml_id := substr(NEW.gml_id, 1 , 16);
    -- abgelaufenen Datensatz markieren (Enddatum setzen)
    EXECUTE 'UPDATE public.' || TG_RELNAME || ' SET endet = ''' || NEW.beginnt || '''
      WHERE gml_id = ''' || NEW.gml_id || ''' AND endet IS NULL';
  END IF;

  -- Lebenszeitintervall nachtragen (ATKIS)
  IF NEW.beginnt IS NULL THEN
    NEW.beginnt := NOW()::text;
  END IF;

  -- alles zurückgeben
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';
