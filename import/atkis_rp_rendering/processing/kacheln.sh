#!/bin/bash

source psql.conf

# Die zu verarbeitendenden Tabellen
# gefolgt vom entsprechenden Geometrietyp
#
#	TODO: saubere Array-Struktur ...

#	PROBLEM: unterschiedliche (Anzahl) Spalten:
# 	wenn alles pauschal prozessiert wird,
#	werden alle Spalten abgesehen von 'wkb_geometry' und
#	'widmung' nicht berücksichtigt! 
#	Workaround: auxfields...

tables=('map_wald_g0')
geomtype=('ST_Polygon')
auxfields=('')

tables+=('map_wald_g1')
geomtype+=('ST_Polygon')
auxfields+=('')

tables+=('map_wald_g2')
geomtype+=('ST_Polygon')
auxfields+=('')

tables+=('map_wald_g3')
geomtype+=('ST_Polygon')
auxfields+=('')

tables+=('map_wald_g4')
geomtype+=('ST_Polygon')
auxfields+=('')

tables+=('map_wald_g5')
geomtype+=('ST_Polygon')
auxfields+=('')

tables+=('map_wald_g6')
geomtype+=('ST_Polygon')
auxfields+=('')

tables+=('map_fluesse_g0')
geomtype+=('ST_Polygon')
auxfields+=('')

tables+=('map_fluesse_g1')
geomtype+=('ST_Polygon')
auxfields+=('')

tables+=('map_fluesse_g2')
geomtype+=('ST_Polygon')
auxfields+=('')

tables+=('map_fluesse_g3')
geomtype+=('ST_Polygon')
auxfields+=('')

tables+=('map_fluesse_g4')
geomtype+=('ST_Polygon')
auxfields+=('')

tables+=('map_fluesse_g5')
geomtype+=('ST_Polygon')
auxfields+=('')

tables+=('map_fluesse_g6')
geomtype+=('ST_Polygon')
auxfields+=('')

tables+=('map_baeche_g0')
geomtype+=('ST_LineString')
auxfields+=('')

tables+=('map_baeche_g1')
geomtype+=('ST_LineString')
auxfields+=('')

tables+=('map_baeche_g2')
geomtype+=('ST_LineString')
auxfields+=('')

tables+=('map_baeche_g3')
geomtype+=('ST_LineString')
auxfields+=('')

tables+=('map_baeche_g4')
geomtype+=('ST_LineString')
auxfields+=('')

tables+=('map_baeche_g5')
geomtype+=('ST_LineString')
auxfields+=('')

tables+=('map_baeche_g6')
geomtype+=('ST_LineString')
auxfields+=('')

tables+=('map_strasse_g0')
geomtype+=('ST_LineString')
auxfields+=('name_, bezeichnung,')

tables+=('map_strasse_g1')
geomtype+=('ST_LineString')
auxfields+=('name_, bezeichnung,')

tables+=('map_strasse_g2')
geomtype+=('ST_LineString')
auxfields+=('name_, bezeichnung,')

tables+=('map_strasse_g3')
geomtype+=('ST_LineString')
auxfields+=('name_, bezeichnung,')

tables+=('map_strasse_g4')
geomtype+=('ST_LineString')
auxfields+=('name_, bezeichnung,')

tables+=('map_strasse_g5')
geomtype+=('ST_LineString')
auxfields+=('name_, bezeichnung,')

tables+=('map_strasse_g6')
geomtype+=('ST_LineString')
auxfields+=('name_, bezeichnung,')

tables+=('map_wege_g0')
geomtype+=('ST_LineString')
auxfields+=('')

tables+=('map_wege_g1')
geomtype+=('ST_LineString')
auxfields+=('')

tables+=('map_wege_g2')
geomtype+=('ST_LineString')
auxfields+=('')




# Es können auch noch andere Datensätze hier geclippt werden.
# Einfach danach auch das $cells-Array entsprechend erweitern.

# Die zu verwendenden Kacheln: g0=2km, g1=5km, g2=10km, g3=25km, g4=50km
cells=('map_landesflaeche_g0')  #wald_g0
cells+=('map_landesflaeche_g0') #wald_g1
cells+=('map_landesflaeche_g1') #wald_g2
cells+=('map_landesflaeche_g1') #wald_g3
cells+=('map_landesflaeche_g2') #wald_g4
cells+=('map_landesflaeche_g3') #wald_g5
cells+=('map_landesflaeche_g4') #wald_g6

cells+=('map_landesflaeche_g0') #fluesse_g0
cells+=('map_landesflaeche_g0') #fluesse_g1
cells+=('map_landesflaeche_g1') #fluesse_g2
cells+=('map_landesflaeche_g1') #fluesse_g3
cells+=('map_landesflaeche_g2') #fluesse_g4
cells+=('map_landesflaeche_g3') #fluesse_g5
cells+=('map_landesflaeche_g4') #fluesse_g6

cells+=('map_landesflaeche_g0') #baeche_g0
cells+=('map_landesflaeche_g0') #baeche_g1
cells+=('map_landesflaeche_g1') #baeche_g2
cells+=('map_landesflaeche_g1') #baeche_g3
cells+=('map_landesflaeche_g2') #baeche_g4
cells+=('map_landesflaeche_g3') #baeche_g5
cells+=('map_landesflaeche_g4') #baeche_g6

cells+=('map_landesflaeche_g0') #strasse_g0
cells+=('map_landesflaeche_g0') #strasse_g1
cells+=('map_landesflaeche_g1') #strasse_g2
cells+=('map_landesflaeche_g1') #strasse_g3
cells+=('map_landesflaeche_g2') #strasse_g4
cells+=('map_landesflaeche_g3') #strasse_g5
cells+=('map_landesflaeche_g4') #strasse_g6

cells+=('map_landesflaeche_g0') #wege_g0
cells+=('map_landesflaeche_g0') #wege_g1
cells+=('map_landesflaeche_g1') #wege_g2
####################################################################
#					ab hier nichts mehr ändern
#				do not change anything below this line.
####################################################################

# Festlegen der Datenbank-Verbindung
echo "Teste PostGIS-Verbindung zu $dbname auf $dbuser@$dbhost:$dbport:"
if [ $dbpass == false ]; then
	CONN="psql --user=$dbuser $dbname --host=$dbhost --port=$dbport -w"
else	
	CONN="psql --user=$dbuser $dbname --host=$dbhost --port=$dbport --password=$dbpass"
fi




#### SCHLEIFE über tables ####
echo ${#tables[@]}
for (( x=0 ; x < ${#tables[@]}; x++ ))
do
	echo -e "\n-----------------------------------------------------------------"
	echo "Prozessiere ${tables[$x]}:"
	
	QUERY="${CONN} -c 'SELECT true FROM ${tables[$x]} LIMIT 1 OFFSET 0' --quiet"

	if eval $QUERY &> /dev/null;
	then 
		echo "  Verbindung erfolgreich hergestellt, Eingabetabelle existiert."
	else # Kein Abruf von Tabelle möglich - DB-Konfig falsch oder Tabelle nicht existent
		QUERY="${CONN} -c 'SELECT false' --quiet"
		if eval $QUERY &> /dev/null;
		then 
			echo "  Fehler: Eingabetabelle ${tables[$x]} existiert nicht."
		else
			echo "  Fehler: Verbindung zum Server konnte nicht hergestellt werden!"
			echo "  Bitte Verbindungseinstellungen überprüfen."
		fi
		exit 0
	fi
	
	#### PROZESSIERUNG ####

	
	echo "Geometrie-Layer: ${tables[$x]}, Clipping-Layer: ${cells[$x]}, aux fields: ${auxfields[$x]}"
	time $CONN -c "DROP TABLE IF EXISTS temp0; 
	SELECT ${auxfields[$x]} (ST_Dump(ST_Intersection(rlp.wkb_geometry, t.wkb_geometry))).geom AS wkb_geometry, t.widmung
	INTO temp0
	FROM ${tables[$x]} t
	INNER JOIN ${cells[$x]} rlp
	ON rlp.wkb_geometry && t.wkb_geometry
	WHERE ST_Intersects( rlp.wkb_geometry, t.wkb_geometry);
	DELETE FROM ${tables[$x]} ;
	INSERT INTO ${tables[$x]} (${auxfields[$x]} wkb_geometry, widmung) SELECT ${auxfields[$x]} wkb_geometry, widmung FROM temp0 WHERE ST_GeometryType( wkb_geometry ) = '${geomtype[$x]}';"

done
