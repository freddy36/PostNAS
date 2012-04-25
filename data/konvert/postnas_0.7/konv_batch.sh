#!/bin/bash
## -------------------------------------------------
## Konvertierung von ALKIS NAS-Format nach PosGIS  -
## NAS-Daten in einem Ordner konvertieren          -
## Batch-Teil, Aufruf mit geprueften Parametern    -
## -------------------------------------------------
##
## Ordner-Struktur:
##   /mandant/
##           /0001/*.xml.zip
##           /0002/*.xml.zip
##          usw.
##           /temp/
##   Auf der gleichen Ebene wie die Datenordner muss ein Ordner /temp/ existieren.
##   Dort werden die NAS-Daten temporär ausgepackt.
##   Relativ zum mitgegebenen Parameter ist das: '../temp/'
##   Parallel laufende Konvertierungen zum gleichen Mandanten 
##   würden hier durcheinander geraten. Vermeiden!
##
## Stand: 
##   2012-02-10 Umbennung nach 0.7
##   2012-02-17 Optimierung
##   2012-02-28 Neuer Parameter 4 um Post-Prozessing zu unterdrücken
##   2012-04-25 Durch GDAL Patch #5444 werden die Löschungen als Trigger auf Tabelle 'delete' verarbeitet
##
## ToDo: Option "-skipfailures" nach Test entfernen ?
##
## Konverter:   /opt/gdal-1.9.1/bin/ = GDAL 1.9-DEV / PostNAS 0.7
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
PP=$4
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
# Fehlerprotokoll:
  errprot='/data/konvert/postnas_0.7/log/postnas_err_'$DBNAME'.prot'
#
# DB-Connection
  con="-p 5432 -d ${DBNAME} "
  echo "Datenbank-Name . . = ${DBNAME}"
  echo "Ordner NAS-Daten . = ${ORDNER}"
  echo "Verarbeitungs-Modus= ${verarb}"
  echo " "
# Alte delete-Eintraege in DB?
  echo 'TRUNCATE table "delete";' | psql $con 
#
# Ordner abarbeiten
#
  cd ${ORDNER}
  rm ../temp/*.gfs
  echo "Dateien in " ${ORDNER} " (ls) :"
  ls
  for zipfile in *.zip ; do 
    echo " "
    rm ../temp/*.xml
    echo "*********"
   #echo "* Archiv: " $zipfile
    unzip ${zipfile}  -d ../temp
    # Es sollte nur ein XML-File in jedem ZIP-File stecken, aber es geht auch anders.
    for nasdatei in ../temp/*.xml ; do 
      # echo "* Datei:  " $nasdatei
      # Zwischenueberschrift im Fehlerprotokoll
      echo "* Datei: " $nasdatei >> $errprot
      #
      # PostNAS Konverter-Aufruf
      #
      /opt/gdal-1.9.1/bin/ogr2ogr -f "PostgreSQL" -append  ${update} -skipfailures \
         PG:"dbname=${DBNAME} host=localhost port=5432" -a_srs EPSG:25832 ${nasdatei} 2>> $errprot
      nasresult=$?
      echo "* Resultat: " $nasresult " fuer " ${nasdatei}
    done # Ende Zipfile
  done # Ende Ordner
  rm ../temp/*.xml
  echo " "
  echo "** Ende Konvertierung Ordner ${ORDNER}"
#
# Post-Processing / Nacharbeiten
#
  if [ $PP == "nopp" ]
  then
    echo "** KEIN Post-Processing - Dies Spaeter nachholen."
    # Dies kann sinnvoll sein, wenn mehrere kleine Aktualisierungen hintereinander auf einem großen Bestand laufen
    # Der Aufwand für das Post-Processing ist dann nur bei der LETZTEN Aktualisierung notwendig.
  else
    echo "** Post-Processing (Nacharbeiten zur Konvertierung)"
    echo "** - Optimierte Nutzungsarten neu Laden:"
    psql -p 5432 -d ${DBNAME} < /data/konvert/postnas_0.7/nutzungsart_laden.sql
    ##
    echo "** - Fluren / Gemarkungen / Gemeinden neu Laden:"
    psql -p 5432 -d ${DBNAME} < /data/konvert/postnas_0.7/pp_laden.sql
  fi
# Durch Einfuegen in Tabelle 'delete' werden Loeschungen anderer Tabellen getriggert
  echo "** delete-Tabelle enthält:"
  echo 'SELECT COUNT(featureid) AS delete_zeilen FROM "delete";' | psql $con
  echo "   delete-Tabelle loeschen:"
  echo 'TRUNCATE table "delete";' | psql $con
#
# Wenn die Datenbank MIT Historie angelegt wurde, man diese aber gar nicht braucht,
# dann hinterher aufräumen der historischen Objekte 
  echo "** geendete Objekte entfernen:"
# Function :
  echo 'SELECT alkis_delete_all_endet();' | psql $con
#
  echo "Das Fehler-Protokoll wurde ausgegeben in die Datei\n$errprot"
#