#!/bin/bash
## -------------------------------------------------
## Konvertierung von ALKIS NAS-Format nach PosGIS  -
## NAS-Daten in einem Ordner konvertieren          -
## Batch-Teil, Aufruf mit geprueften Parametern    -
## -------------------------------------------------
## Stand: 
##  2011-02-01  Umstellen auf die Verarbeitung gezippter NAS-Daten.
##       Es wird dabei folgende Ordner-Struktur erwartet:
##       /mandant/
##               /0001/*.xml.zip
##               /0002/*.xml.zip
##               usw.
##               /temp/
##       Also auf der gleichen Ebene wie die Datenordner muss ein Ordner /temp/ existieren.
##       Dort werden die NAS-Daten temporär ausgepackt.
##       Relativ zum mitgegebenen Parameter ist das: '../temp/'
##
##       Achtung: Parallel laufende Konvertierungen zum gleichen Mandanten 
##                würden hier durcheinander geraten. Vermeiden!
##
##  ##  2011-07-25 PostNAS 06, Umbenennung
##  ##  2011-09-20 Verarbeiten der delete-Eintraege bei Aktualisierung.
##                 Siehe http://trac.wheregroup.com/PostNAS/wiki/SchrittfuerSchritt
##  ##  2011-11-04 Verarbeitung OHNE Parameter 3 Datenbank-User und  4 DB-Passwort.
##                 Berechtigung regeln über "/etc/postgresql/[version]/main/pg_hba.conf"
##                 Dort Zeile: "local  [db]  [user]  ident sameuser"
##       Alt:    # PG:"dbname=${DBNAME} user=${DBUSER} password=${DBPASS} host=localhost port=5432"
##      2011-11-22 Korrektur: UPD=$3 nicht $4
##                 Protokollierung nach Datenbanken getrennt
##      2012-02-28 Neuer Parameter um Post-Prozessing zu unterdrücken
##
## Konverter:   /opt/gdal-1.9/bin/ = GDAL 1.9 / PostNAS 0.6
## Koordinaten: EPSG:25832  UTM, Zone 32
##              -a_srs EPSG:25832   - bleibt im UTM-System (korrigierte Werte)
##
echo "**************************************************"
echo "**   K o n v e r t i e r u n g     PostNAS 0.6  **"
echo "**************************************************"
## Parameter:
ORDNER=$1
DBNAME=$2
UPD=$3
PP=$4
if [ $ORDNER == "" ]
then
	echo "FEHLER: Parameter 1 'Ordner' ist leer"
	exit 1
fi
if [ $DBNAME == "" ]
then
	echo "FEHLER: Parameter 2 'Datenbank' ist leer"
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
		echo "FEHLER: Parameter 3 'Aktualisierung' ist weder e noch a"
		exit 3
	fi
fi
if [ $PP == "nopp" ]
then
	echo "KEIN Post-Processing nach dieser Konvertierung."
else
	if [ $PP == "pp" ]
	then
		echo "normales Post-Processing."
	else
		echo "FEHLER: Parameter 4 'Post-Proscessing' ist weder 'nopp' noch 'pp'"
		exit 4
	fi
fi
layer=""
# leer = alle Layer
## Fehlerprotokoll:
errprot='/data/konvert/postnas_0.6/log/postnas_err_'$DBNAME'.prot'
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
      psql $con  < /data/konvert/postnas_0.6/delete.sql
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
if [ $PP == "nopp" ]
then
  echo "** KEIN Post-Processing - Dies Spaeter nachholen."
  # Dies kann sinnvoll sein, wenn mehrere kleine Aktualisierungen hintereinander auf einem großen Bestand laufen
  # Der Aufwand für das Post-Processing ist dann nur bei der LETZTEN Aktualisierung notwendig.
else
  echo "** Optimierte Nutzungsarten neu Laden:"
  psql -p 5432 -d ${DBNAME} < /data/konvert/postnas_0.6/nutzungsart_laden.sql
  ##
  echo "** Optimierte Gemeindetabelle neu Laden:"
  psql -p 5432 -d ${DBNAME} < /data/konvert/postnas_0.6/gemeinden_laden.sql
fi
#
echo "Das Fehler-Protokoll wurde ausgegeben in die Datei '$errprot' "
##