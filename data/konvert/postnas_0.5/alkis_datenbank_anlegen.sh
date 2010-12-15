#! /bin/sh
## ------------------------------------------------
## Konvertierung von ALKIS NAS-Format nach PosGIS -
## Teil 1: Eine neue PostGIS-Datenbank anlegen    -
## ------------------------------------------------
##
## Stand:
##  2010-01-11
##  2010-01-26 postgreSQL 8.3 Port 5432
##  2010-08-27 Schluesseltabellen (Konstanten) dazu laden, 
##             Grant von Views getrennt
##  2010-11-10 Nutzungsarten
##  2010-11-25 Gemeinden
##
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
	echo "Datenbank-User?"
	read DBUSER
#
	#echo ""
	#echo "Datenbank-Passwort?  (wird nicht angezeigt)"
	#stty -echo
	#	read DBPASS
	#stty echo
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
## Datenbank-Connection:
#con="-h localhost -p 5432 -d ${DBNAME} "
con="-p 5432 -d ${DBNAME} "
echo "connection " $con
echo "******************************"
echo "**  Neue ALKIS-Datenbank    **"
echo "******************************"
##
echo " "
echo "** Löschen Datenbank " ${DBNAME}
#echo "DROP database ${DBNAME};" | psql -h localhost -p 5432 -d ${DBUSER} -U ${DBUSER} 
echo  "DROP database ${DBNAME};" | psql              -p 5432 -d ${DBUSER} -U ${DBUSER} 
##
echo " "
echo "** Anlegen (leere) PostGIS-Datenbank"
#createdb  --host=localhost  --port=5432 --username=${DBUSER} -E utf8  -T ${DBTEMPLATE}  ${DBNAME}
createdb                     --port=5432 --username=${DBUSER} -E utf8  -T ${DBTEMPLATE}  ${DBNAME}
##
echo " "
echo "** Anlegen der Datenbank-Struktur fuer PostNAS (alkis_PostNAS_0.5_schema.sql)"
psql $con -U ${DBUSER}  < /data/konvert/postnas_0.5/alkis_PostNAS_0.5_schema.sql
##
echo " "
echo "** Anlegen der Datenbank-Struktur - zusaetzliche Schluesseltabellen"
## Nur die benoetigten Tabellen fuer die Buchauskunft
psql $con -U ${DBUSER}  < /data/konvert/postnas_0.5/alkis_PostNAS_0.5_keytables.sql
##
echo " "
echo "** Anlegen Optimierung Nutzungsarten"
##
## Anlegen der Tabellen
psql $con -U ${DBUSER}  < /data/konvert/postnas_0.5/alkis_nutzungsart_definition.sql
##
## Laden der Metadaten und Schlüsseltabellen
psql $con -U ${DBUSER}  < /data/konvert/postnas_0.5/alkis_nutzungsart_metadaten.sql
##
echo "** Anlegen Optimierung Gemeinden"
##
## Anlegen der Tabellen
psql $con -U ${DBUSER}  < /data/konvert/postnas_0.5/alkis_gemeinden_definition.sql
##
echo " "
echo "** Definition von Views"
psql $con -U ${DBUSER}  < /data/konvert/postnas_0.5/alkis_sichten.sql
#echo "COMMENT ON DATABASE ${DBNAME} IS 'ALKIS - Konverter PostNAS 0.5';" | psql -h localhost -p 5432 -d ${DBNAME} -U ${DBUSER} 
echo  "COMMENT ON DATABASE ${DBNAME} IS 'ALKIS - Konverter PostNAS 0.5';" | psql              -p 5432 -d ${DBNAME} -U ${DBUSER} 
##
echo " "
echo "** Berechtigung"
psql $con -U ${DBUSER}  < /data/konvert/postnas_0.5/alkis_grant.sql
##
echo "***************************"
echo "**  Ende Neue Datenbank  **"
echo "***************************"
