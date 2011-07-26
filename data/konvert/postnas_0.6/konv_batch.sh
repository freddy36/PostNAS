#!/bin/sh
## -------------------------------------------------
## Konvertierung von ALKIS NAS-Format nach PosGIS  -
## NAS-Daten in einem Ordner konvertieren          -
## Batch-Teil, Aufruf mit geprueften Parametern    -
## -------------------------------------------------
## Stand: 
##  2010-11-10  Tabellen "Optimierte Nutzungsarten" Laden
##  2010-11-25  Tabelle  "Optimierte Gemeinden"     Laden
##
##  2011-02-01  Umstellen auf die Verarbeitung gezippter NAS-Daten.
##       Es wird dabei folgende Ordner-Struktur erwartet:
##       /mandant/
##               /0001/*.xml.zip
##               /0002/*.xml.zip
##             usw.
##               /temp/
##       Also auf der gleichen Ebene wie die Datenordner muss ein Ordner /temp/ existieren.
##       Dort werden die NAS-Daten temporär ausgepackt.
##       Relativ zum mitgegebenen Parameter ist das: ../temp/
##
##       Achtung: Parallel laufende Konvertierungen zum gleichen Mandanten 
##                würden hier durcheinander geraten. Vermeiden!
##
##       Alternative:
##       Könnte ogr2ogr auch pipe mit stdin verarbeiten?
##       $  unzip -p  aktuelle.xml.zip  | ogr2ogr ....
##       Wahrscheinlich nicht, wie heisst dann die *.gfs?
##
##  ##  2011-07-25 PostNAS 06, Umbenennung
##
## Konverter:   /opt/gdal-1.9/bin/ = GDAL 1.9 / PostNAS 0.6
## Koordinaten: EPSG:25832  UTM, Zone 32
##              -a_srs EPSG:25832   - bleibt im UTM-System (korrigierte Werte)
##
echo "**************************************************"
echo "**   K o n v e r t i e r u n g     PostNAS 0.6  **"
echo "**************************************************"
## Auswerten der Parameter:
ORDNER=$1
DBNAME=$2
DBUSER=$3
DBPASS=$4
UPD=$5
##
## Fehlerprotokoll
errprot='/data/konvert/postnas_0.6/log/postnas_err.prot'
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
  echo "Verarbeitungs-Modus= ${verarb}"
  echo " "
  cd ${ORDNER}
  rm ../temp/*.gfs
  echo "Dateien in " ${ORDNER} " (ls) :"
  ls
# for zipfile in ${ORDNER}/*.xml.zip ; do 
  for zipfile in *.zip               ; do 
    echo " "
    echo "*******"
    echo "* Archiv: " $zipfile
    rm ../temp/*.xml
    unzip ${zipfile}  -d ../temp
    for nasdatei in ../temp/*.xml ; do 
      echo "* Datei:  " $nasdatei
      # Zwischenueberschrift im Fehlerprotokoll
      echo "* Datei: " $nasdatei >> $errprot
      # Groesse und Datum anzeigen
      #ls -l ${nasdatei}
      /opt/gdal-1.9/bin/ogr2ogr -f "PostgreSQL" -append  ${update}  -skipfailures \
        PG:"dbname=${DBNAME} user=${DBUSER} password=${DBPASS} host=localhost port=5432" \
        -a_srs EPSG:25832  ${nasdatei}  ${layer}  2>> $errprot
      # Abbruch bei Fehler?
      nasresult=$?
      echo "* Resultat: " $nasresult " fuer " ${nasdatei}
    done
  done
  rm ../temp/*.xml
  echo "** Ende Konvertierung Ordner ${ORDNER}"
  echo "Das Fehler-Protokoll wurde ausgegeben in die Datei " $errprot
##
  echo "** Optimierte Nutzungsarten neu Laden:"
  psql -p 5432 -d ${DBNAME}  -U ${DBUSER}  < /data/konvert/postnas_0.6/nutzungsart_laden.sql
##
  echo "** Optimierte Gemeindetabelle neu Laden:"
  psql -p 5432 -d ${DBNAME}  -U ${DBUSER}  < /data/konvert/postnas_0.6/gemeinden_laden.sql
##