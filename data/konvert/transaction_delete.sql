-- Table: "delete"

-- DROP TABLE "delete";

CREATE TABLE "delete"
(
  ogc_fid serial NOT NULL,
  typename character(33),
  featureid character(32),
  CONSTRAINT delete_pk PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE "delete" OWNER TO postgres;

DROP FUNCTION deletefeature(text, text);
CREATE FUNCTION deleteFeature(typename text, featureid text) RETURNS text 
AS $$ 
 DECLARE 
  query text;
  res text; 
 BEGIN 
     query := 'DELETE FROM ' || $1 || ' WHERE gml_id = substring(''' || $2 || ''' from 1 for 16)';
     EXECUTE query;

     IF FOUND THEN 
	RAISE NOTICE 'query successfull % ', query; 
	res := 1;
     ELSE 
        RAISE NOTICE 'query no object found % ', query; 
        res := 0;
     END IF; 
  RETURN res; 
 END; 
$$ LANGUAGE plpgsql; 


INSERT INTO AA_Antragsgebiet (gml_id) VALUES ('DENW44AL0000okRc');

INSERT INTO delete (typename, featureid) VALUES ('AA_Antragsgebiet','DENW44AL0000okRc20110428T135110Z');

Select deleteFeature('AA_Antragsgebiet','DENW44AL0000okRc20110428T135110Z');

INSERT INTO AA_Antragsgebiet (gml_id) VALUES ('DENW44AL0000okRc');

Select * from AA_Antragsgebiet

Select substring('DENW44AL0000okRc20110428T135110Z' from 1 for 16)

Select deleteFeature(typename,featureid) from delete;
