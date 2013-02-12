#!/bin/bash

source psql.conf

####################################################################
#					ab hier nichts mehr ändern
#				do not change anything below this line.
####################################################################

# Kommandozeilen-Variante
# @params
# Tabellenparameter::
# $1= einzulesende Tabelle
table_input=$1
# $2= auszugebende Tabelle
table_output=$2
# $3= in welcher Spalte wird die Widmung vorgehalten? (kann NULL-Werte enthalten)
column_label=$3
# Generalisierungsparameter:
# $4= Mindestgröße für Außenpolygone
minArea_outer=$4
# $5= Mindestgröße für Innenpolygono
minArea_inner=$5
# $6= SimplifyDistance für Außenpolygone
simplDist_outer=$6
# $7= SimplifyDistance für Innenpolygone
simplDist_inner=$7
# $8= RasterCellsize für Perimter-Verschneidungen (siehe Doku)
rasterCellsize=$8
##
##
##
# @ToDo: "Input at hoc"-Variante (read "Geben Sie den Tabellennamen der Eingabedaten ein:" table_input, ...)
# @ToDo: Automatisierte Variante mit cat betroffene.txt


force=false
if [ $9 ]; then
	if [ $9 == 'true' ] || [ $9 == 1 ]; then
		force=true
		echo "batch mode mit 'force' gesetzt."
	fi
fi

# Testen, ob Variablen gesetzt sind

if [ ! $table_input ]; then 
	error="${error}Keine Angabe zur Eingabetabelle gemacht!\r\n"
fi
if [ ! $table_output ]; then 
	error="${error}Keine Angabe zur Ausgabetabelle gemacht!\r\n"
fi
if [ ! $column_label ]; then 
	error="${error}Keine Angabe zur Spalte 'Widmung' gemacht!\r\n"
fi
if [ ! $minArea_outer ]; then 
	error="${error}Keine Angabe zur Mindestgröße der Außenpolygone!\r\n"
fi
if [ ! $minArea_inner ]; then 
	error="${error}Keine Angabe zur Mindestgröße der Innenpolygone!\r\n"
fi
if [ ! $simplDist_outer ]; then 
	error="${error}Keine Angabe zur Simplify-Distance für die Außenpolygone!\r\n"
fi
if [ ! $simplDist_inner ]; then 
	error="${error}Keine Angabe zur Simplify-Distance für die Innenpolygone!\r\n"
fi
if [ ! $RasterCellsize ]; then 
	error="${error}Keine Angabe zur Zellgröße (in km) für die Verschneidung!\r\n"
fi

if [ $# -lt 9 ]; then
	echo "Aufruf mit inkorrekter Anzahl an Parametern:"
	echo -e $error #@ ToDo
	exit 0
fi

# Festlegen der Datenbank-Verbindung
echo "Teste PostGIS-Verbindung zu $dbname auf $dbuser@$dbhost:$dbport:"
if [ $dbpass == false ]; then
	CONN="psql --user=$dbuser $dbname --host=$dbhost --port=$dbport -w"
else	
	CONN="psql --user=$dbuser $dbname --host=$dbhost --port=$dbport --password=$dbpass"
fi

# Testen, ob die Eingangstabelle exisitiert
QUERY="${CONN} -c 'SELECT true FROM $table_input LIMIT 1 OFFSET 0' --quiet"

if eval $QUERY &> /dev/null;
then 
	echo "Verbindung erfolgreich hergestellt, Eingabetabelle existiert."
else # Kein Abruf von Tabelle möglich - DB-Konfig falsch oder Tabelle nicht existent
	QUERY="${CONN} -c 'SELECT false' --quiet"
	if eval $QUERY &> /dev/null;
	then 
		echo "Fehler: Eingabetabelle $table_input existiert nicht."
	else
		echo "Fehler: Verbindung zum Server konnte nicht hergestellt werden!"
		echo "Bitte Verbindungseinstellungen überprüfen."
	fi
	exit 0
fi


# Testen, ob die Ausgabetabelle bereits exisitiert - Abfrage: Überschreiben oder Abbruch?
QUERY="${CONN} -c 'SELECT true FROM $table_output LIMIT 1 OFFSET 0' --quiet"

if eval $QUERY &> /dev/null;
then 
	echo "Ausgabetabelle existiert bereits!"
	
	response=false
	if [ $force == true ]; then
		response=true
		QUERY="${CONN} -c 'DROP TABLE $table_output' --quiet"
		eval $QUERY &> /dev/null;
		echo "Tabelle $table_output gelöscht."
	fi

	while [ $response = false ]; do
		read -p "[L]ösche Tabelle oder [A]bbruch: " var
		if [ "$var" = 'L' ]; then
			response=true
			QUERY="${CONN} -c 'DROP TABLE $table_output' --quiet"
			eval $QUERY &> /dev/null;
			echo "Tabelle $table_output gelöscht."
		elif [ "$var" = 'A' ]; then
			response=true
			echo "Abbruch durch Benutzer."
			exit 0
		fi
	done
else # Kein Abruf von Tabelle möglich - DB-Konfig falsch oder Tabelle nicht existent
	QUERY="${CONN} -c 'SELECT false' --quiet"
	if eval $QUERY &> /dev/null;
	then 
		echo "Alle Vorbereitungen zum Prozessieren sind abgeschlossen."
	else
		echo "Fehler: Verbindung zum Server konnte nicht hergestellt werden!"
		echo "Bitte Verbindungseinstellungen überprüfen."
	fi
fi

# Nächstes "Fenster"
if [ $force != true ]; then
	read -p "Drücken Sie eine beliebige Taste zum Fortfahren: " > /dev/null
	echo '##            ATKIS-Generalisierung :: Wrapper            ##'
fi;

if [ $dbpass == false ]; then
	CONN="psql --user=$dbuser $dbname --host=$dbhost --port=$dbport -w"
else	
	CONN="psql --user=$dbuser $dbname --host=$dbhost --port=$dbport --password=$dbpass"
fi

################################# GENERALISIERUNG per se #################################

time $CONN -c "DROP TABLE IF EXISTS temp0;
	SELECT path[1] AS path, ST_MakePolygon(ST_ExteriorRing(geom)) AS wkb_geometry, $3::text
	INTO temp0
	FROM (
		SELECT (ST_DumpRings( wkb_geometry )).*, $3
		FROM $1
	) AS t1;
	CREATE INDEX temp0_geomidx ON temp0 USING GIST ( wkb_geometry );
	DROP SEQUENCE IF EXISTS temp0_geomid_seq;
	CREATE SEQUENCE temp0_geomid_seq;
	ALTER TABLE temp0 ADD COLUMN geomid INTEGER;
	UPDATE temp0 SET geomid = nextval('temp0_geomid_seq');
	ALTER TABLE temp0 ALTER COLUMN geomid SET DEFAULT nextval('temp0_geomid_seq');
	-- 
	DELETE FROM temp0 WHERE path = 0 AND ST_Area( wkb_geometry ) < $4; -- 
	DELETE FROM temp0 WHERE path <> 0 AND ST_Area( wkb_geometry ) < $5; -- 
	UPDATE temp0 SET wkb_geometry = ST_Buffer( 
											ST_Buffer(
													ST_SimplifyPreserveTopology( wkb_geometry, $6 )
											, SQRT( $6 ) )
									, SQRT( $6 ) *-1 )
	WHERE path = 0;
	UPDATE temp0 SET wkb_geometry = ST_Buffer( 
											ST_Buffer(
													ST_SimplifyPreserveTopology( wkb_geometry, $7 )
											, SQRT( $7 ) )
									, SQRT( $7 ) *-1 )
	WHERE path <> 0;
	INSERT INTO temp0
	(wkb_geometry, path, $3)
	SELECT
		ST_Buffer(	ST_Buffer( wkb_geometry	, 1.5 ), -1.5 ) AS wkb_geometry,
		path, $3
	FROM temp0
	WHERE NOT ST_IsValid( wkb_geometry );
	DELETE FROM temp0 WHERE NOT ST_IsValid( wkb_geometry );";


time $CONN -c "ALTER TABLE temp0 ADD COLUMN relate VARCHAR;
	UPDATE temp0 AS t SET relate = 'intersects' 
	WHERE EXISTS (
		SELECT 1 
			FROM map_landesflaeche_g0 AS rlp 
			WHERE rlp.wkb_geometry && t.wkb_geometry
			GROUP BY t.wkb_geometry 
			HAVING ST_Overlaps( ST_Union(rlp.wkb_geometry), t.wkb_geometry )
	);
	INSERT INTO temp0 
	(relate, wkb_geometry, path, $3)
	SELECT 'clipped' AS relate, proc.wkb_geometry, path, $3
	FROM (
		SELECT path, $3, (ST_Dump(wkb_geometry)).geom AS wkb_geometry
		FROM (
			SELECT ST_Intersection( lyr, rlp) AS wkb_geometry, path, $3
			FROM
			(
				SELECT path, $3, relate, wkb_geometry AS lyr FROM temp0 
			) AS w,
			(
				SELECT wkb_geometry AS rlp FROM map_landesflaeche
			) AS l
			WHERE w.relate = 'intersects' 
		) AS wrapper
	) AS proc;

	DELETE FROM temp0 WHERE relate = 'intersects' OR ST_GeometryType( wkb_geometry ) IN ('ST_Point', 'ST_LineString');

	INSERT INTO temp0
	(relate, wkb_geometry, path, $3 )
	SELECT relate, (ST_Dump( wkb_geometry )).geom AS wkb_geometry, path, $3
	FROM temp0
	WHERE ST_GeometryType( wkb_geometry ) = 'ST_MultiPolygon';
	DELETE FROM temp0 WHERE ST_GeometryType( wkb_geometry ) = 'ST_MultiPolygon';
	DROP TABLE IF EXISTS $2;

		SELECT ST_MakePolygon( ST_ExteriorRing(o.wkb_geometry) , ST_Accum(ST_ExteriorRing(i.wkb_geometry)) ) AS wkb_geometry, o.$3
		INTO $2
		FROM temp0 AS o
		INNER JOIN temp0 AS i
		ON ST_Contains(o.wkb_geometry, i.wkb_geometry) 
		WHERE o.path = 0 AND NOT (o.wkb_geometry ~= i.wkb_geometry)
		GROUP BY o.wkb_geometry, o.$3
	UNION ALL
		SELECT
		t0.wkb_geometry, $3
		FROM temp0 AS t0
		WHERE NOT EXISTS( SELECT 1 FROM temp0 AS t1 WHERE ST_Contains(t0.wkb_geometry, t1.wkb_geometry) AND NOT (t0.wkb_geometry ~= t1.wkb_geometry) ) AND t0.path = 0;
	DROP TABLE temp0;
	CREATE INDEX $2_gidx ON $2 USING GIST ( wkb_geometry );
	DROP SEQUENCE IF EXISTS $2_gid_seq;
	CREATE SEQUENCE $2_gid_seq;
	ALTER TABLE $2 ADD COLUMN gid INTEGER;
	UPDATE $2 SET gid = nextval('$2_gid_seq');
	ALTER TABLE $2 ALTER COLUMN gid SET DEFAULT nextval('$2_gid_seq'); 
	UPDATE $2 SET wkb_geometry = ST_Buffer(ST_Buffer( wkb_geometry, 1), -1) WHERE NOT ST_IsValid( wkb_geometry );
	UPDATE $2 SET wkb_geometry = (ST_Dump( wkb_geometry )).geom WHERE ST_GeometryType( wkb_geometry ) = 'ST_MultiPolygon'; 
	REINDEX TABLE $2; " 
