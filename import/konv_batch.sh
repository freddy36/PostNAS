#!/bin/bash
## -------------------------------------------------
## Konvertierung von ALKIS NAS-Format nach PostGIS -
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
##   Dort werden die NAS-Daten temporaer ausgepackt.
##   Relativ zum mitgegebenen Parameter ist das: '../temp/'
##   Parallel laufende Konvertierungen zum gleichen Mandanten 
##   wuerden hier durcheinander geraten. Vermeiden!
##
## Stand: 
##   2012-02-10 Umbennung nach 0.7
##   2012-02-17 Optimierung
##   2012-02-28 Neuer Parameter 4 um Post-Prozessing zu unterdruecken
##   2012-04-25 Durch GDAL Patch #5444 werden die Loeschungen als Trigger auf Tabelle 'delete' verarbeitet
##   2012-05-18 Umzug neue GDI, GDAL-Trunk unter Pfad 
##   2012-06-04 SQL-Skripte in deren Verzeichnis ausfuehren (Voraussetzung fuer \i Includes)
##   2012-10-30 Umgebungsvariable setzen, delete-Tabelle am Ende fuer Analyse gefuellt lassen.
##              Test als 0.7a mit gepatchter gdal-Version (noch 2.0dev)
##   2013-10-16 F.J. krz: Neues Script "pp_praesentation_action.sql" f�r Reparatur der 
##              Pr�sentationsobjekte Stra�enname im Post-Processing
##   2013-10-24 F.J. krz: Zwischenl�sung "praesentation_action.sql" wieder deaktiviert.
##   2014-01-31 F.J. krz: Import Eintrag erzeugen (nach Vorschlag Marvin Brandt, Unna)
##   2014-02-13 A.Emde WhereGroup: Einf�hrung DBUSER, damit im Skript der Datenbankbenutzer angegeben werden kann
##   2014-05-12 F.J. krz: Unterschiedliche Pfade in Test (TRUNK) und Produktion (Rel. 1.11.0)
##   2014-06-18 F.J. DB-User nicht "postgres" (in $con). 
##                   Konverter ind Nacharbeiten sonst mit unterschiedlichem User.
##                   Abgleich Test/Prod-Version
##                   Entfernen der historischen Objekte nach Konvertierung.
##   2014-09-03 F.J. Auch f�r 0.7-Datenstruktur die aktuelle Programmversion, PG_USE_COPY

## Koordinaten: EPSG:25832  UTM, Zone 32
##              -a_srs EPSG:25832   - bleibt im UTM-System (korrigierte Werte)

POSTNAS_HOME=$(dirname $0)
 PATH=/opt/gdal-2.0/bin:$PATH   # TRUNK-Version (immer letzter Stand der Entwicklung)
#PATH=/opt/gdal-1.11/bin:$PATH  # Release GDAL 1.11.0 vom April 2014
EPSG=25832
DBUSER=b600352

if [ $DBUSER == "" ]
then
  echo "kein DBUSER gesetzt"
else
  PGUSER=" -U ${DBUSER} "
fi

if [ $DBUSER == "" ]
then
  echo "kein DBUSER gesetzt"
else
  OGRPGUSER=" user=${DBUSER}"
fi
 
echo " 
**********************************************
**   K o n v e r t i e r u n g     PostNAS  **
********************************************** 
 "
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
errprot=${POSTNAS_HOME}'/log/postnas_err_'$DBNAME'.prot'

# DB-Connection
con="${PGUSER} -p 5432 -d ${DBNAME} "

echo "Datenbank-Name . . = ${DBNAME}"
echo "DBUSER ${DBUSER}"
echo "PGUSER ${PGUSER}"
echo "OGRPGUSER ${OGRPGUSER}"
echo "Ordner NAS-Daten . = ${ORDNER}"
echo "Verarbeitungs-Modus= ${verarb}"
echo "POSTNAS_HOME ${POSTNAS_HOME}"

# noch alte delete-Eintraege in DB?
echo "Leeren der delete-Tabelle"
echo 'TRUNCATE table "delete";' | psql $con 

# Import Eintrag erzeugen
#
# Die dadurch erzeugte Import-ID dient zur Steuerung des L�schens alter Relationen im Trigger. 
# Wird die Datenbank MIT Historie geladen, muss die folgende Zeile auskommentiert werden.
echo "INSERT INTO import (datum,verzeichnis,importart) VALUES ('"$(date '+%Y-%m-%d %H:%M:%S')"','"${ORDNER}"','"${verarb}"');" | psql $con

# Ordner abarbeiten

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

      # Umgebungsvariable setzen:
        export GML_FIELDTYPES=ALWAYS_STRINGS    # PostNAS behandelt Zahlen wie Strings, PostgreSQL-Treiber macht daraus Zahlen
        export OGR_SETFIELD_NUMERIC_WARNING=YES # Meldung abgeschnittene Zahlen?
       #export CPL_DEBUG=ON                     # Meldung, wenn Attribute ueberschrieben werden

      # PostNAS Konverter-Aufruf
      ogr2ogr -f "PostgreSQL" -append  ${update} -skipfailures  --config PG_USE_COPY YES  \
         PG:"dbname=${DBNAME} host=localhost port=5432 ${OGRPGUSER}" -a_srs EPSG:$EPSG ${nasdatei} 2>> $errprot
      nasresult=$?
      echo "* Resultat: " $nasresult " fuer " ${nasdatei} | tee -a $errprot
    done # Ende Zipfile
  done # Ende Ordner
  rm ../temp/*.xml
  echo " "
  echo "** Ende Konvertierung Ordner ${ORDNER}
  "

# Post-Processing / Nacharbeiten

  if [ $PP == "nopp" ]
  then

    echo "** KEIN Post-Processing - Dies spaeter nachholen."
    # Dies kann sinnvoll sein, wenn mehrere kleine Aktualisierungen hintereinander auf einem grossen Bestand laufen
    # Der Aufwand fuer das Post-Processing ist dann nur bei der LETZTEN Aktualisierung notwendig.

  else

    echo "** Post-Processing (Nacharbeiten zur Konvertierung)"

    echo "** - Optimierte Nutzungsarten neu Laden:"
    (cd $POSTNAS_HOME; psql $con -f nutzungsart_laden.sql)
 
    echo "** - Fluren / Gemarkungen / Gemeinden neu Laden:"
    (cd $POSTNAS_HOME; psql $con -f pp_laden.sql)

  fi

  if [ "$(readlink $POSTNAS_HOME/alkis-trigger.sql)" = "alkis-trigger-kill.sql" ]; then

     # Durch Einfuegen in Tabelle 'delete' werden Loeschungen anderer Tabellen getriggert
     echo "** delete-Tabelle enthaelt:"
     psql $con -c 'SELECT COUNT(featureid) AS delete_zeilen FROM "delete";'

     echo "   delete-Tabelle loeschen:"
     psql $con -c 'TRUNCATE table "delete";'

    # Wenn die Datenbank MIT Historie geladen wurde, man diese aber gar nicht braucht,
    # dann hinterher aufraeumen der historischen Objekte 
    echo "** geendete Objekte entfernen:"

    # Function:
    psql $con -c "SELECT alkis_delete_all_endet();"

  fi

  echo "Das Fehler-Protokoll wurde ausgegeben in die Datei $errprot"
 