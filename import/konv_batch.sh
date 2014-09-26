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
##   2013-10-16 F.J. krz: Neues Script "pp_praesentation_action.sql" für Reparatur der 
##              Präsentationsobjekte Straßenname im Post-Processing
##   2013-10-24 F.J. krz: Zwischenlösung "praesentation_action.sql" wieder deaktiviert.
##   2014-01-31 F.J. krz: Import Eintrag erzeugen (nach Vorschlag Marvin Brandt, Unna)
##   2014-02-13 A.Emde WhereGroup: Einführung DBUSER, damit im Skript der Datenbankbenutzer angegeben werden kann
##   2014-05-12 F.J. krz: Unterschiedliche Pfade in Test (TRUNK) und Produktion (Rel. 1.11.0)
##   2014-06-18 F.J. DB-User nicht "postgres" (in $con). 
##                   Konverter ind Nacharbeiten sonst mit unterschiedlichem User.
##                   Abgleich Test/Prod-Version.
##                   Entfernen der historischen Objekte nach Konvertierung.
##   2014-09-09 F.J. krz: Parameter "--config PG_USE_COPY YES" zur Beschleunigung. Ausgabe import-Tabelle.
##   2014-09-11 F.J. krz: Eintrag in import-Tabelle repariert.
##                   Keine Abfrage des Symlinks auf kill/hist. Enstscheidend ist die aktuelle DB, nicht der Symlink
##   2014-09-23 F.J. krz: Zählung der Funktionen in delete, dies in import-Tabelle eintragen (Metadaten)

## ToDo: 
## - Unterscheidung e/a noch sinnvoll? Immer "a" = Aktualisierung = -update ?
## - PostProcessing: Aufruf Script, sonst redundant zu pflegen

POSTNAS_HOME=$(dirname $0)

# Konverterpfad. TRUNK-Version (immer letzter Stand der Entwicklung)
PATH=/opt/gdal-2.0/bin:$PATH
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
**********************************************"
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

  echo "GDAL/PostNAS Konverter-Version:" >> $errprot
  ogr2ogr --version >> $errprot

# DB-Connection
  con="${PGUSER} -p 5432 -d ${DBNAME} "
  echo "Datenbank-Name . . = ${DBNAME}"
  echo "DBUSER ${DBUSER}"
  echo "PGUSER ${PGUSER}"
  echo "OGRPGUSER ${OGRPGUSER}"
  echo "Ordner NAS-Daten . = ${ORDNER}"
  echo "Verarbeitungs-Modus= ${verarb}"
  echo "POSTNAS_HOME ${POSTNAS_HOME}"

  # noch alte delete-Eintraege?
  echo "Leeren der delete-Tabelle"
  psql $con -c 'TRUNCATE table "delete";'

  #echo "Bisherige Konvertierungen (Import-Tabelle):"
  #psql $con -c "SELECT * FROM import ORDER by id;"

# Import Eintrag erzeugen
# Ursprünglich für Trigger-Steuerung benötigt. Nun als Metadaten nützlich.
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
      #   --config PG_USE_COPY YES
      ogr2ogr -f "PostgreSQL" -append  ${update} -skipfailures  \
         PG:"dbname=${DBNAME} host=localhost port=5432 ${OGRPGUSER}" -a_srs EPSG:$EPSG ${nasdatei} 2>> $errprot
      nasresult=$?
      echo "* Resultat: " $nasresult " fuer " ${nasdatei} | tee -a $errprot
    done # Ende Zipfile
  done # Ende Ordner
  rm ../temp/*.xml
  echo " "
  echo "** Ende Konvertierung Ordner ${ORDNER}"

  # Durch Einfügen in Tabelle 'delete' werden Löschungen und Aktualisierungen anderer Tabellen getriggert
  echo "** Die delete-Tabelle enthaelt so viele Zeilen:"
  psql $con -c 'SELECT COUNT(featureid) AS delete_zeilen FROM "delete";'

  echo "** aufgeteilt auf diese Funktionen:"
  psql $con -c 'SELECT context, COUNT(featureid) AS anzahl FROM "delete" GROUP BY context ORDER BY context;' 

  # Kontext-Funktionen zählen und dei Anzahl als Metadaten zum aktuellen Konvertierungslauf speichern
  psql $con -c "
   UPDATE import SET anz_delete=(SELECT count(*) FROM \"delete\" WHERE context='delete') 
   WHERE id=(SELECT max(id) FROM import) AND verzeichnis='${ORDNER}' AND anz_delete IS NULL;
   UPDATE import SET anz_update=(SELECT count(*) FROM \"delete\" WHERE context='update') 
   WHERE id=(SELECT max(id) FROM import) AND verzeichnis='${ORDNER}' AND anz_update IS NULL;
   UPDATE import SET anz_replace=(SELECT count(*) FROM \"delete\" WHERE context='replace') 
   WHERE id=(SELECT max(id) FROM import) AND verzeichnis='${ORDNER}' AND anz_replace IS NULL;" 
   # ignored = true auswerten, ggf. warnen ?

#
# Post-Processing / Nacharbeiten
#
  if [ $PP == "nopp" ]
  then
    echo "** KEIN Post-Processing - Dies spaeter nachholen."
    # Dies kann sinnvoll sein, wenn mehrere kleine Aktualisierungen hintereinander auf einem grossen Bestand laufen
    # Der Aufwand für das Post-Processing ist dann nur bei der LETZTEN Aktualisierung notwendig.

  else
    echo "** Post-Processing (Nacharbeiten zur Konvertierung)"

    echo "** - Optimierte Nutzungsarten neu Laden (Script nutzungsart_laden.sql):"
    (cd $POSTNAS_HOME; psql $con -f nutzungsart_laden.sql)
 
    echo "** - Fluren, Gemarkungen, Gemeinden und Straßen-Namen neu Laden (Script pp_laden.sql):"
    (cd $POSTNAS_HOME; psql $con -f pp_laden.sql)

  fi

  # Aufräumen der historischen Objekte -- besser vorher als nachher. Analyse für Trigger-Entwicklung

 #echo "   delete-Tabelle loeschen:"
 #psql $con -c 'TRUNCATE table "delete";'

 #echo "** geendete Objekte entfernen:"
 #psql $con -c "SELECT alkis_delete_all_endet();"

  echo "Das Fehler-Protokoll wurde ausgegeben in die Datei $errprot"
  echo "** ENDE PostNAS 0.8-Konvertierung  DB='$DBNAME'  Ordner='$ORDNER' "
 