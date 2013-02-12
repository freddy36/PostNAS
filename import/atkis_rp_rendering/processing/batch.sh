#!/bin/bash

source psql.conf

# Query aufbauen
if [ $dbpass == false ]; then
	CONN="psql --user=$dbuser $dbname --host=$dbhost --port=$dbport -w --quiet"
else	
	CONN="psql --user=$dbuser $dbname --host=$dbhost --port=$dbport --password=$dbpass --quiet"
fi

START=$(date +%s)

# Parameter:
# ./flaechen.sh map_sonderkultur_g0 map_sonderkultur_g1 widmung 10000 5000 10 10 false true
# Funktion	Eingabelayer	Ausgabelayer	Widmungsfeld	AußenpolygonMindestgröße InnenpolygonMindestgrößße SimplifyAußen SimplifyInnen Kachelungsgröße[false=keineKachelung] batch-Mode

#############################
# 0	PRE-PROCESSING
# 0.1	ERSTELLEN DER KACHELN
echo 
echo "-------------------------------------------------------------------------------------------"
echo "0.1 Kachelung"
#<<COMMENT0
time $CONN -c "DROP TABLE IF EXISTS map_rlp_kachel_2km, map_rlp_kachel_5km, map_rlp_kachel_10km, map_rlp_kachel_25km, map_rlp_kachel_50km;
				SELECT grid( 'map_rlp_kachel_2km', ST_ExteriorRing(ST_Union(wkb_geometry)), 2000) FROM ax_kommunalesgebiet;
				SELECT grid( 'map_rlp_kachel_5km', ST_ExteriorRing(ST_Union(wkb_geometry)), 5000) FROM ax_kommunalesgebiet;
				SELECT grid( 'map_rlp_kachel_10km', ST_ExteriorRing(ST_Union(wkb_geometry)), 10000) FROM ax_kommunalesgebiet;
				SELECT grid( 'map_rlp_kachel_25km', ST_ExteriorRing(ST_Union(wkb_geometry)), 25000) FROM ax_kommunalesgebiet;
				SELECT grid( 'map_rlp_kachel_50km', ST_ExteriorRing(ST_Union(wkb_geometry)), 50000) FROM ax_kommunalesgebiet;"
echo "  - Prozessierung abgeschlossen"
#COMMENT0
#echo "  - Wird nicht neu prozessiert"
sleep 1

# 1.	FLÄCHENHAFTE OBJEKTE
# 1.1	LANDESFLÄCHE und KACHELUNG über die Grids
echo 
echo "-------------------------------------------------------------------------------------------"
echo "1.1 Landesfläche"
time $CONN -f sql/landesflaeche.sql
echo "  - Abgeschlossen"
#echo "  - Wird nicht neu prozessiert"
sleep 1



# 1.2	WALDFlächen
# Vorprozessierung
echo 
echo "-------------------------------------------------------------------------------------------"
echo "1.2 Waldflächen"
time $CONN -f sql/wald_prep.sql
echo "  - g0 [1:7500] & g1 [1:17500] abgeschlossen"
sleep 1
./flaechen.sh map_wald_g1 map_wald_g2 widmung 25000 10000 25 20 false true
echo "  - g1->g2 [1:50000] abgeschlossen"
sleep 1
./flaechen.sh map_wald_g2 map_wald_g3 widmung 50000 30000 65 50 false true
echo "  - g2->g3 [1:100000] abgeschlossen"
sleep 1
./flaechen.sh map_wald_g3 map_wald_g4 widmung 85000 55000 100 75 false true
echo "  - g3->g4 [1:300000] abgeschlossen"
sleep 1
./flaechen.sh map_wald_g4 map_wald_g5 widmung 100000 85000 200 150 false true
echo "  - g4->g5 [1:750000] abgeschlossen"
sleep 1
./flaechen.sh map_wald_g5 map_wald_g6 widmung 1000000 1000000 350 350 false true
echo "  - g5->g6 [1:infinite] abgeschlossen"
sleep 1


# 1.3	ORTSLAGEN
# Vorprozessierung
echo 
echo "-------------------------------------------------------------------------------------------"
echo "1.3 Ortslagen"
time $CONN -f sql/ortslage_prep.sql
sleep 1
echo "  - Vorprozessierung abgeschlossen"
./flaechen.sh map_ortslage_g0 map_ortslage_g1 widmung 10000 5000 10 10 false true
echo "  - g0->g1 [1:17500] abgeschlossen"
sleep 1
./flaechen.sh map_ortslage_g1 map_ortslage_g2 widmung 25000 10000 25 20 false true
echo "  - g1->g2 [1:50000] abgeschlossen"
sleep 1
./flaechen.sh map_ortslage_g2 map_ortslage_g3 widmung 50000 30000 65 50 false true
echo "  - g2->g3 [1:100000] abgeschlossen"
sleep 1
./flaechen.sh map_ortslage_g3 map_ortslage_g4 widmung 85000 55000 100 75 false true
echo "  - g3->g4 [1:300000] abgeschlossen"
sleep 1
./flaechen.sh map_ortslage_g4 map_ortslage_g5 widmung 100000 85000 200 150 false true
echo "  - g4->g5 [1:750000] abgeschlossen"
sleep 1
./flaechen.sh map_ortslage_g5 map_ortslage_g6 widmung 1000000 1000000 350 350 false true
echo "  - g5->g6 [1:infinite] abgeschlossen"
sleep 1


# 1.4	INDUSTRIE und GEWERBEFLÄCHEN
# Hier sind noch sehr viele Objekte (>13000) mit funktion NULL belegt!
echo 
echo "-------------------------------------------------------------------------------------------"
echo "1.4 Industrie- und Gewerbeflächen"
time $CONN -f sql/industrie_prep.sql
sleep 1
echo "  - Vorprozessierung abgeschlossen"
./flaechen.sh map_industrie_g0 map_industrie_g1 widmung 10000 5000 10 10 false true
echo "  - g0->g1 [1:17500] abgeschlossen"
sleep 1
./flaechen.sh map_industrie_g1 map_industrie_g2 widmung 25000 10000 25 20 false true
echo "  - g1->g2 [1:50000] abgeschlossen"
sleep 1
./flaechen.sh map_industrie_g2 map_industrie_g3 widmung 50000 30000 65 50 false true
echo "  - g2->g3 [1:100000] abgeschlossen"
sleep 1
./flaechen.sh map_industrie_g3 map_industrie_g4 widmung 85000 55000 100 75 false true
echo "  - g3->g4 [1:300000] abgeschlossen"
sleep 1
./flaechen.sh map_industrie_g4 map_industrie_g5 widmung 100000 85000 200 150 false true
echo "  - g4->g5 [1:750000] abgeschlossen"
sleep 1
./flaechen.sh map_industrie_g5 map_industrie_g6 widmung 1000000 1000000 350 350 false true
echo "  - g5->g6 [1:infinite] abgeschlossen"
sleep 1

echo 
echo "-------------------------------------------------------------------------------------------"
echo "1.5 Landwirtschaft -> Derivat 'Grünland'"
echo "  - Wird nicht prozessiert"
<<COMMENT1
	time $CONN -f sql/gruenland_prep.sql
	# 414"
	sleep 1
	echo "  - Vorprozessierung abgeschlossen"
	./flaechen.sh map_gruenland_g0 map_gruenland_g1 widmung 10000 5000 10 10 false true
	echo "  - g0->g1 [1:17500] abgeschlossen"
	sleep 1
	./flaechen.sh map_gruenland_g1 map_gruenland_g2 widmung 25000 10000 25 20 false true
	echo "  - g1->g2 [1:50000] abgeschlossen"
	sleep 1
	./flaechen.sh map_gruenland_g2 map_gruenland_g3 widmung 50000 30000 65 50 false true
	echo "  - g2->g3 [1:100000] abgeschlossen"
	sleep 1
	./flaechen.sh map_gruenland_g3 map_gruenland_g4 widmung 85000 55000 100 75 false true
	echo "  - g3->g4 [1:300000] abgeschlossen"
	sleep 1
	./flaechen.sh map_gruenland_g4 map_gruenland_g5 widmung 100000 85000 200 150 false true
	echo "  - g4->g5 [1:750000] abgeschlossen"
	sleep 1
	./flaechen.sh map_gruenland_g5 map_gruenland_g6 widmung 1000000 1000000 350 350 false true
	echo "  - g5->g6 [1:infinite] abgeschlossen"
	sleep 1
COMMENT1


# 1.6	SONDERKULTUREN
# Vorprozessierung
echo 
echo "-------------------------------------------------------------------------------------------"
echo "1.6 Landwirtschaft -> Derivat 'Sonderkulturen'"
time $CONN -f sql/sonderkultur_prep.sql
sleep 1
echo "  - Vorprozessierung abgeschlossen"
./flaechen.sh map_sonderkultur_g0 map_sonderkultur_g1 widmung 10000 5000 10 10 false true
echo "  - g0->g1 [1:17500] abgeschlossen"
sleep 1
./flaechen.sh map_sonderkultur_g1 map_sonderkultur_g2 widmung 25000 10000 25 20 false true
echo "  - g1->g2 [1:50000] abgeschlossen"
sleep 1
./flaechen.sh map_sonderkultur_g2 map_sonderkultur_g3 widmung 50000 30000 65 50 false true
echo "  - g2->g3 [1:100000] abgeschlossen"
sleep 1
./flaechen.sh map_sonderkultur_g3 map_sonderkultur_g4 widmung 85000 55000 100 75 false true
echo "  - g3->g4 [1:300000] abgeschlossen"
sleep 1
./flaechen.sh map_sonderkultur_g4 map_sonderkultur_g5 widmung 100000 85000 200 150 false true
echo "  - g4->g5 [1:750000] abgeschlossen"
sleep 1
./flaechen.sh map_sonderkultur_g5 map_sonderkultur_g6 widmung 1000000 1000000 350 350 false true
echo "  - g5->g6 [1:infinite] abgeschlossen"
sleep 1


# 1.7	Stehendes Gewaesser
# Vorprozessierung
echo 
echo "-------------------------------------------------------------------------------------------"
echo "1.7 Stehendes Gewässer 'See'"
time $CONN -f sql/stehendesgewaesser_prep.sql
sleep 1
echo "  - Vorprozessierung abgeschlossen"
./flaechen.sh map_stehendesgewaesser_g0 map_stehendesgewaesser_g1 widmung 500 250 5 5 false true
echo "  - g0->g1 [1:17500] abgeschlossen"
sleep 1
./flaechen.sh map_stehendesgewaesser_g1 map_stehendesgewaesser_g2 widmung 1500 500 15 10 false true
echo "  - g1->g2 [1:50000] abgeschlossen"
sleep 1
./flaechen.sh map_stehendesgewaesser_g2 map_stehendesgewaesser_g3 widmung 10000 5000 30 30 false true
echo "  - g2->g3 [1:100000] abgeschlossen"
sleep 1
./flaechen.sh map_stehendesgewaesser_g3 map_stehendesgewaesser_g4 widmung 25000 10000 50 50 false true
echo "  - g3->g4 [1:300000] abgeschlossen"
sleep 1
./flaechen.sh map_stehendesgewaesser_g4 map_stehendesgewaesser_g5 widmung 50000 25000 75 75 false true
echo "  - g4->g5 [1:750000] abgeschlossen"
sleep 1
./flaechen.sh map_stehendesgewaesser_g5 map_stehendesgewaesser_g6 widmung 150000 75000 150 150 false true
echo "  - g5->g6 [1:infinite] abgeschlossen"
sleep 1

# 1.8	Flüsse
echo 
echo "-------------------------------------------------------------------------------------------"
echo "1.8 Fließgewässer - Flüsse [Polygone]"
time $CONN -f sql/fluesse_full.sql
echo "  - Prozessierung abgeschlossen"
sleep 1

# 1.	FLÄCHENHAFTE OBJEKTE
# 1.8	GEBÄUDEGRUNDRISSE
echo 
echo "-------------------------------------------------------------------------------------------"
echo "1.9 Gebäude - Transformation [Polygone]->[Punktsignaturen]"
time $CONN -f sql/gebaeude_prep.sql
echo "  - Prozessierung abgeschlossen"
sleep 1

# 2.	LINIENHAFTE OBJEKTE
# 2.1	STRASSEN
echo 
echo "-------------------------------------------------------------------------------------------"
echo "2.1 Straßen"
time $CONN -f sql/strassen_full.sql
echo "  - Prozessierung abgeschlossen"

# 2.2	BAHN
echo 
echo "-------------------------------------------------------------------------------------------"
echo "2.3 Bahn"
time $CONN -f sql/bahn_full.sql
echo "  - Prozessierung abgeschlossen"
sleep 1

# 2.3	Bäche
echo 
echo "-------------------------------------------------------------------------------------------"
echo "2.4 Fließgewässer - Bäche"
time $CONN -f sql/baeche_full.sql
echo "  - Prozessierung abgeschlossen"
sleep 1

# 2.4	Wege
echo 
echo "-------------------------------------------------------------------------------------------"
echo "2.4 Wege"
time $CONN -f sql/wege_full.sql
echo "  - Prozessierung abgeschlossen"
sleep 1

# POST-PROCESSING
# 3.	KACHELUNG
echo 
echo "-------------------------------------------------------------------------------------------"
echo "3. Kachelung"
time ./kacheln.sh 
echo "  - Kachelung abgeschlossen"


echo 
echo "-------------------------------------------------------------------------------------------"
echo "4. VACUUM ANALYZE"
time $CONN -c "VACUUM ANALYZE"
echo "  - Abgeschlossen"

END=$(date +%s)
DIFF=$(( $END - $START ))
echo -e "\r\nProzessierung abgeschlossen nach ${DIFF} Sekunden"
