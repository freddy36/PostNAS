#!/bin/sh
## -------------------------------------------------
## Konvertierung von ALKIS NAS-Format nach PosGIS  -
## NAS-Daten in einem Ordner konvertieren          -
## Batch-Teil, Aufruf mit geprueften Parametern    -
## -------------------------------------------------
## Stand: 
##  2010-01-06
##  2010-01-26 postgreSQL 8.3 Port 5432
## 
## Konverter:   /opt/gdal-1.7/bin/ = GDAL 1.7 / PostNAS 0.5
## Koordinaten: EPSG:25832  UTM, Zone 32
##              -a_srs EPSG:25832   - bleibt im UTM-System (korrigierte Werte)
##
echo "**************************************************"
echo "**   K o n v e r t i e r u n g     PostNAS 0.5  **"
echo "**************************************************"
## Auswerten der Parameter:
ORDNER=$1
DBNAME=$2
DBUSER=$3
DBPASS=$4
UPD=$5
##
if [ $ORDNER = "" ]
then
	echo "Parameter 1 'Ordner' ist leer"
	exit 1
fi
##
if [ $DBNAME = "" ]
then
	echo "Parameter 2 'Datenbank' ist leer"
	exit 2
fi
##
if [ $DBUSER = "" ]
then
	echo "Parameter 3 'DB-User' ist leer"
	exit 3
fi
##
if [ $DBPASS = "" ]
then
	echo "Parameter 4 'DB-Passwort' ist leer"
	#exit 4
	echo "Datenbank-Passwort?  (wird nicht angezeigt)"
	stty -echo
	read DBPASS
	stty echo
fi
##
if [ $UPD = "a" ]
then
	verarb="NBA-Aktualisierung"
	update=" -update "
else
	verarb="Erstladen"
	update=""
fi
layer=""
# leer = alle Layer
 echo "Datenbank-Name . . = ${DBNAME}"
 echo "Ordner NAS-Daten . = ${ORDNER}"
 echo "Datenbank-User . . = ${DBUSER}"
#echo "Datenbank-Pass . . = ${DBPASS}"
 echo "Verarbeitungs-Modus= ${verarb}"
 echo " "
#logmeld="/data/konvert/postnas_0.5/log/meldungen"
#logerr="/data/konvert/postnas_0.5/log/fehler"
for nasdatei in ${ORDNER}/*.xml ; do 
	echo "  *******"
	echo "  * Datei: " $nasdatei
	# Groesse und Datum anzeigen
	#ls -l ${nasdatei}
	/opt/gdal-1.7/bin/ogr2ogr -f "PostgreSQL" -append  ${update}  -skipfailures \
		PG:"dbname=${DBNAME} user=${DBUSER} password=${DBPASS} host=localhost port=5432" \
		-a_srs EPSG:25832  ${nasdatei}  ${layer}  2>>  /data/konvert/postnas_0.5/log/postnas_err.prot
	# Fehlerprotokoll in log-Datei? 2>
	# Abbruch bei Fehler?
	nasresult=$?
	echo "  * Resultat: " $nasresult " fuer " ${nasdatei}
done
echo "** Ende Konvertierung Ordner ${ORDNER}"
##