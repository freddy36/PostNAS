#!/bin/bash
echo "* =================================================================="
echo "* Bereinigung 'doppelte Objekte' in den Tabellen der ALKIS-Datenbank"
echo "* =================================================================="
## Z.B. nachdem eine NAS-Datei doppelt konvertiert wurde.
## Die Tabellen werden jeweils mit sich selbst verglichen.
## Wenn eine "gml_id" doppelt ist, dann wird der Eintrag mit dem groesseren serial "ogc_fid" geloescht.
## Warnung: Bei grossen Datenbanken erzeugt dies Script fuer laengere Zeit eine hohe Last auf dem DB-Server!!
## Stand 03.02.2011
#
# Konfig:
# -------
  port="5432"       # 5432  PG 8.3 main/UTF
  db="alkis05300"   # Datenbank-Name
#
# Hilfs-Variable
# --------------
  mylist="/data/bkup/${db}_tablenames"
  myselect="SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename like 'ax_%' ORDER BY tablename;"
#
# Here we go ....
# ---------------
echo "Datenbank : " $db
echo "Liste     : " $mylist
#echo "** Liste der Tabellen erzeugen"
echo $myselect | psql -t -h localhost -p $port -d ${db} > ${mylist}
for tabname in  `cat $mylist` 
do
  echo " "
  echo " * Tabelle  $tabname "
  mysql="DELETE FROM $tabname AS dublette WHERE EXISTS (SELECT solitaer.gml_id FROM $tabname AS solitaer WHERE solitaer.gml_id  = dublette.gml_id AND dublette.ogc_fid > solitaer.ogc_fid);"
  echo $mysql | psql -t -h localhost -p $port -d ${db}
  echo "-----------------------------"
done
##
echo "** fertig!  (vaccuum empfohlen)"
