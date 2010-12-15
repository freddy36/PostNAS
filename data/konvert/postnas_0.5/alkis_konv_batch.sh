#!/bin/sh
## -------------------------------------------------
## Konvertierung von ALKIS NAS-Format nach PosGIS  -
## NAS-Daten in einem Ordner konvertieren          -
## Batch-Teil, Aufruf mit geprueften Parametern    -
## -------------------------------------------------
## Stand: 
##  2010-01-06
##  2010-01-26 postgreSQL 8.3
##  2010-08-16 Dateiname als Zwischen-Ueberschrift in Fehlerprotokoll
##  2010-10-14  gdal 1.8 compile aus svn gdal-trunk
##  2010-11-10  Tabellen "Optimierte Nutzungsarten" Laden
##  2010-11-25  Tabelle  "Optimierte Gemeinden"     Laden
## 
## Konverter:   /opt/gdal-1.8/bin/ = GDAL 1.8 / PostNAS 0.5
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
## Fehlerprotokoll
errprot='/data/konvert/postnas_0.5/log/postnas_err.prot'
## ! Bei parallelen Konvertierungen sollte die Ausgabe in getrennte Logfiles ausgegeben werden.
## ! Ggf. die Start-Zeit in den Namen einbauen?
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
  for nasdatei in ${ORDNER}/*.xml ; do 
	echo "  *******"
	echo "  * Datei: " $nasdatei
	# Zwischenueberschrift im Fehlerprotokoll
	echo "  * Datei: " $nasdatei >> $errprot
	# Groesse und Datum anzeigen
	#ls -l ${nasdatei}
	/opt/gdal-1.8/bin/ogr2ogr -f "PostgreSQL" -append  ${update}  -skipfailures \
		PG:"dbname=${DBNAME} user=${DBUSER} password=${DBPASS} host=localhost port=5432" \
		-a_srs EPSG:25832  ${nasdatei}  ${layer}  2>> $errprot
	# Abbruch bei Fehler?
	nasresult=$?
	echo "  * Resultat: " $nasresult " fuer " ${nasdatei}
  done
  echo "** Ende Konvertierung Ordner ${ORDNER}"
  echo "Das Fehler-Protokoll wurde ausgegeben in die Datei " $errprot
##
  echo "** Optimierte Nutzungsarten neu Laden:"
  psql -p 5432 -d ${DBNAME}  -U ${DBUSER}  < /data/konvert/postnas_0.5/alkis_nutzungsart_laden.sql
##
  echo "** Optimierte Gemeindetabelle neu Laden:"
  psql -p 5432 -d ${DBNAME}  -U ${DBUSER}  < /data/konvert/postnas_0.5/alkis_gemeinden_laden.sql
##