#!/bin/bash
## -------------------------------------------------
## Konvertierung von ALKIS NAS-Format nach PostGIS -
## Teil 1: Eine neue PostGIS-Datenbank anlegen     -
## -------------------------------------------------
##
## Stand:
##  2012-02-10 PostNAS 07, Umbenennung
##  2013-01-15 Zwischenstopp um Meldungen lesen zu k�nnen bevor, sie aus dem Scrollbereich verschwinden
##  2013-04-16 Vers.-Nr. "0.7" aus dem Dateinamen von Schema und Keytable entfernt, sichten_wms.sql
##  2013-10-16 F.J. krz: Neues Sript "pp_praesentation_sichten.sql" f�r Reparatur Pr�sentationsobjekte Stra�ennamen
##  2013-12-03 F.J. krz: Script "sichten.sql" einbeziehen. Darin View "doppelverbindung" fuer WMS FS-Kommunal.
##  2014-01-31 F.J. krz: Unterschiede der Datenbank-Struktur f�r die Varianten MIT/OHNE Historie.

POSTNAS_HOME=$(dirname $0)
MANDANT_HOME=$PWD

# Koordinatensystem fuer Geometriefelder:
EPSG=25832

## Dialog mit Anwender
function get_db_config(){
	# welches Datenbank-Template?
	echo ""
	echo "Datenbank-Template fuer die neue ALKIS-Datenbank?"
	echo " (einfach Enter fuer die Voreinstellung template_postgis)"
	read DBTEMPLATE
	: ${DBTEMPLATE:="template_postgis"}
#
	# Name der neuen ALKIS-Datenbank
	until [ -n "$DBNAME" ]
	do
		echo ""
		echo "Name der ALKIS-Datenbank?"
		read DBNAME
	done
	echo ""
	echo "Datenbank-User?  (Dieser muss eine gleichnamige Service-Datenbank haben)"
	read DBUSER
#
	until [ "$JEIN" = "j" -o "$JEIN" = "n" ]
	do
		echo ""
		echo "Datenbank $DBNAME wird GELOESCHT und neu angelegt  - j oder n?"
		read JEIN
	done
}
#
## aller Laster  ANFANG
get_db_config;
if test $JEIN != "j"
then
	echo "Abbruch"
	exit 1
fi

cd $POSTNAS_HOME

if ! [ -e alkis-trigger.sql ]; then
	if ln -s alkis-trigger-kill.sql alkis-trigger.sql; then
		echo "** Symlink zu alkis-trigger-kill.sql (KEINE HISTORIE) wurde angelegt"
	else
		echo "** alkis-trigger.sql FEHLT!"
		exit 1
	fi
fi

## Datenbank-Connection:
# -h localhost
con="-p 5432 -d ${DBNAME} "
echo "connection " $con

echo "******************************"
echo "**  Neue ALKIS-Datenbank    **"
echo "******************************"
echo " "
echo "** Loeschen Datenbank " ${DBNAME}
## Hier wird vorausgesetzt, dass der User eine Service-DB hat, die seinen Namen traegt
echo  "DROP database ${DBNAME};" | psql -p 5432 -d ${DBUSER} -U ${DBUSER} 
echo " "
echo "** Anlegen (leere) PostGIS-Datenbank"
createdb --port=5432 --username=${DBUSER} -E utf8  -T ${DBTEMPLATE} ${DBNAME}
echo " "
echo "** Anlegen der Datenbank-Struktur fuer PostNAS (alkis_PostNAS_0.7_schema.sql)"
psql $con -v alkis_epsg=$EPSG -U ${DBUSER} -f alkis_PostNAS_schema.sql >$MANDANT_HOME/log/schema.log

# Zwischenstopp. Die Ausgabe-Zeilen sind sonst nicht mehr lesbar.
until [ "$CHECK" = "j" -o "$CHECK" = "n" ]
do
    echo " "
	echo "    Weiter?  'j' (weiter) oder 'n' (Abbruch)"
	read CHECK
done
if test $CHECK != "j"; then
	echo " Abbruch!"
	exit 1
fi

## Kommentar zur Datenbank (allgemein)
psql $con -U ${DBUSER} -c "COMMENT ON DATABASE ${DBNAME} IS 'ALKIS - Konverter PostNAS 0.7';"

## Kann man das Ziel des Symlinks abfragen? Wenn Kill, dann ...
##   if [ -e alkis-trigger.sql ]; then
echo " "
echo "** Besonderheiten der Datenbank OHNE Historie"
## auskommentieren, wenn die Datenbank MIT Historie gef�hrt wird
## Import-ID: Tabelle und Spalte in "alkis_beziehungen" anlegen
psql $con -U ${DBUSER} -f alkis_PostNAS_schema_ohneHist.sql >$MANDANT_HOME/log/schema.log
## Spalte "identifier" aus allen Tabellen entfernen (die wird nur vom Trigger MIT Historie benoetigt)
##psql $con -U ${DBUSER} -c "SELECT alkis_drop_all_identifier();"
psql $con -U ${DBUSER} -c "COMMENT ON DATABASE ${DBNAME} IS 'ALKIS - Konverter PostNAS 0.7 - Ohne Historie';"
## fi

echo " "
echo "** Anlegen der Datenbank-Struktur - zusaetzliche Schluesseltabellen"
## Nur die benoetigten Tabellen fuer die Buchauskunft
psql $con -U ${DBUSER} -f alkis_PostNAS_keytables.sql >$MANDANT_HOME/log/keytables.log

echo " "
echo "** Anlegen Optimierung Nutzungsarten (nutzungsart_definition.sql)"
psql $con -U ${DBUSER} -f nutzungsart_definition.sql

echo " "
echo "** Laden NUA-Metadaten (nutzungsart_metadaten.sql) Protokoll siehe log"
psql $con -U ${DBUSER} -f nutzungsart_metadaten.sql >$MANDANT_HOME/log/meta.log

echo " "
echo "** Anlegen Post Processing Tabellen (pp_definition.sql)"
psql $con -U ${DBUSER} -f pp_definition.sql >$MANDANT_HOME/log/pp_definition.log

echo " "
echo "** Anlegen Post Processing Views (pp_praesentation_sichten.sql)"
psql $con -U ${DBUSER} -f pp_praesentation_sichten.sql >$MANDANT_HOME/log/pp_praesentation_sichten.log

echo " "
echo "** Definition von Views fuer Kartendienste (sichten_wms.sql)"
psql $con -U ${DBUSER} -f sichten_wms.sql >$MANDANT_HOME/log/sichten_wms.log

echo " "
echo "** Definition von Views (sichten.sql)"
psql $con -U ${DBUSER} -f sichten.sql >$MANDANT_HOME/log/sichten.log

echo "** Berechtigung (grant.sql) Protokoll siehe log"
psql $con -U ${DBUSER} -f grant.sql >$MANDANT_HOME/log/log_grant.log
echo " 
***************************
**  Ende Neue Datenbank  **
***************************
"