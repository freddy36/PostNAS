#!/bin/bash
## -------------------------------------------------
## Konvertierung von ALKIS NAS-Format nach PosGIS  -
## NAS-Daten in einem Ordner konvertieren          -
## Batch-Teil, Aufruf mit geprueften Parametern    -
## -------------------------------------------------
## Stand: 
##   2012-02-10 Umbennung nach 0.7
##
## Konverter:   /opt/gdal-1.9/bin/ = GDAL 1.9 / PostNAS 0.7
## Koordinaten: EPSG:25832  UTM, Zone 32
##              -a_srs EPSG:25832   - bleibt im UTM-System (korrigierte Werte)
##
echo "**************************************************"
echo "**   K o n v e r t i e r u n g     PostNAS 0.7  **"
echo "**************************************************"
## Parameter:
ORDNER=$1
DBNAME=$2
UPD=$3
if [ $ORDNER == "" ]
then
	echo "Parameter 1 'Ordner' ist leer"
	exit 1
fi
if [ $DBNAME == "" ]
then
	echo "Parameter 2 'Datenbank' ist leer"
	exit 2
fi
if [ $UPD == "a" ]
then
	verarb="NBA-Aktualisierung"
	update=" -update "
else
	if [ $UPD == "e" ]
	then
		verarb="Erstladen"
		update=""
	else
		echo "Parameter 3 'Aktualisierung' ist weder e noch a"
		exit 3
	fi
fi
layer=""
# leer = alle Layer
## Fehlerprotokoll:
errprot='/data/konvert/postnas_0.7/log/postnas_err_'$DBNAME'.prot'
#
# DB-Connection
con="-p 5432 -d ${DBNAME} "
#
echo "Datenbank-Name . . = ${DBNAME}"
echo "Ordner NAS-Daten . = ${ORDNER}"
echo "Verarbeitungs-Modus= ${verarb}"
echo " "
cd ${ORDNER}
rm ../temp/*.gfs
echo "Dateien in " ${ORDNER} " (ls) :"
ls
# Alte delete-Eintraege (vorangegangener Abbruch?) loeschen, oder abarbeiten?
echo 'TRUNCATE table "delete";' | psql $con 
for zipfile in *.zip ; do 
  echo " "
  echo "*********"
  echo "* Archiv: " $zipfile
  rm ../temp/*.xml
  unzip ${zipfile}  -d ../temp
  # Es sollte eigentlich immer geneu ein XML-File in jedem ZIP-File stecken,
  # aber es geht auch anders.
  for nasdatei in ../temp/*.xml ; do 
    echo "* Datei:  " $nasdatei
    # Zwischenueberschrift im Fehlerprotokoll
    echo "* Datei: " $nasdatei >> $errprot
    if [ $UPD == "e" ]
    then
      # E R S T L A D E N
      /opt/gdal-1.9/bin/ogr2ogr -f "PostgreSQL" -append  ${update}  -skipfailures \
         PG:"dbname=${DBNAME} host=localhost port=5432" \
         -a_srs EPSG:25832  ${nasdatei}  ${layer}  2>> $errprot
      # Abbruch bei Fehler?
      nasresult=$?
      echo "* Resultat: " $nasresult " fuer " ${nasdatei}
    else
      # A K T U A L I S I E R U N G
      echo "- 1. Nur delete-Layer auswerten" 
      /opt/gdal-1.9/bin/ogr2ogr -f "PostgreSQL" -append  ${update}  -skipfailures \
         PG:"dbname=${DBNAME} host=localhost port=5432" \
         -a_srs EPSG:25832  ${nasdatei}  delete  2>> $errprot
      nasresult=$?
      echo "* Resultat: " $nasresult " fuer delete aus " ${nasdatei}
      #
      # Durch die Funktion 'deleteFeature' in der Datenbank die delete-Objekte abarbeiten
      echo "- 1a. delete-Layer abarbeiten:"
      psql $con  < /data/konvert/postnas_0.7/delete.sql
      #
      echo "- 2. alle Layer auswerten"
      /opt/gdal-1.9/bin/ogr2ogr -f "PostgreSQL" -append  ${update}  -skipfailures \
        PG:"dbname=${DBNAME} host=localhost port=5432" \
        -a_srs EPSG:25832  ${nasdatei}  ${layer}  2>> $errprot
      nasresult=$?
      echo "* Resultat: " $nasresult " fuer " ${nasdatei}
      #
      echo "- 2a. delete-Layer nochmals leoeschen:"
      echo 'TRUNCATE table "delete";' | psql $con 
    fi
  done
  # Ende Zipfile
  echo "*********"
done
rm ../temp/*.xml
echo " "
echo "** Ende Konvertierung Ordner ${ORDNER}"
##
echo "** Optimierte Nutzungsarten neu Laden:"
psql -p 5432 -d ${DBNAME} < /data/konvert/postnas_0.7/nutzungsart_laden.sql
##
echo "** Post Processing neu Laden:"
psql -p 5432 -d ${DBNAME} < /data/konvert/postnas_0.7/pp_laden.sql
#
echo "Das Fehler-Protokoll wurde ausgegeben in die Datei '$errprot' "
##