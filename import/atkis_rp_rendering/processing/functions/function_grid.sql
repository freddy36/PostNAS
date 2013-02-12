CREATE OR REPLACE FUNCTION grid(text, geometry, integer)
  RETURNS integer AS
$BODY$ 


DECLARE
bextent box3d_extent := ST_Extent($2);
maxx real := ST_XMax( bextent );
maxy real := ST_YMax( bextent );
minx real := ST_XMin( bextent );
miny real := ST_YMin( bextent );

cell geometry := ST_GeometryFromText('POLYGON((0 0, 0 1, 1 1, 2 1, 2 2, 1 2, 1 1, 1 0, 0 0))',25832);

counter integer := 0;
query text;
--i integer;
--j integer;

stepx integer := ceil((maxx-minx)/$3);
stepy integer := ceil((maxy-miny)/$3);

BEGIN

query := 'DROP TABLE IF EXISTS '||$1||';';
EXECUTE query;
query := 'CREATE TABLE '||$1||' (  gid integer );';
EXECUTE query;
query := 'SELECT AddGeometryColumn (\'public\',\''||$1||'\',\'wkb_geometry\',25832,\'POLYGON\',2);'; 
--RAISE NOTICE 'Info: %', query;
EXECUTE query;
FOR i IN  0..(stepx-1) LOOP
	FOR j IN  0..(stepy-1) LOOP
		 
		query := 'INSERT INTO '|| $1 ||' (wkb_geometry) VALUES (st_geometryfromtext(\'POLYGON(('
			|| minx+i*$3 || ' ' || miny+j*$3 || ',' 
			|| minx+i*$3 || ' ' || miny+(j+1)*$3 || ','
			|| minx+(i+1)*$3 || ' ' || miny+(j+1)*$3 || ','
			|| minx+(i+1)*$3 || ' ' || miny+j*$3 || ','
			|| minx+(i+1)*$3 || ' ' || miny+j*$3 || ','
			|| minx+i*$3 || ' ' || miny+j*$3 || 
		      '))\', 25832));';
		EXECUTE query;
        counter := counter + 1;
	END LOOP;
END LOOP;
query := 'DROP SEQUENCE IF EXISTS '||$1||'_gid_seq;';
EXECUTE query;

query := 'CREATE INDEX '||$1||'_gidx ON '||$1||' USING GIST ( wkb_geometry ); 
	  CREATE SEQUENCE '||$1||'_gid_seq;';
EXECUTE query;
query := 'UPDATE '||$1||' SET gid = nextval(\''||$1||'_gid_seq\');
	  ALTER TABLE '||$1||' ALTER COLUMN gid SET DEFAULT nextval(\''||$1||'_gid_seq\');';
EXECUTE query;

return counter;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
-- 