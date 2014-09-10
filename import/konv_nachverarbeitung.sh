#!/bin/bash
## ----------------------------------------------------
## Nur der Teil  "PostProcessing"  aus konv_batch.sh  -
## ----------------------------------------------------
##
## Stand: 
##  2012-04-25 Kopie aus konv_batch.sh
##  2013-01-23 Aktualisierung aus konv_batch.sh
##  2014-09-02 Vers. 0.8, mit konv_batch.sh synchronisiert

echo "
****************************************
**   Nachverarbeitung zu PostNAS 0.8  **
****************************************"
POSTNAS_HOME=$(dirname $0)
PATH=/opt/gdal-2.0/bin:$PATH # Konverterpfad
EPSG=25832
DBUSER=b600352

# Parameter:
DBNAME=$1
if [ $DBNAME == "" ]
then
	echo "Parameter 1 'Datenbank' ist leer"
	exit 2
fi

if [ $DBUSER == "" ]
then
  echo "kein DBUSER gesetzt"
else
  PGUSER=" -U ${DBUSER} "
fi

# DB-Connection
con="${PGUSER} -p 5432 -d ${DBNAME} "
echo "Connection: " $con

# Post-Processing / Nacharbeiten

echo "** - Optimierte Nutzungsarten neu Laden:"
(cd $POSTNAS_HOME; psql $con -f nutzungsart_laden.sql)

sleep 1

echo "** - Fluren, Gemarkungen, Gemeinden und Straﬂen-Namen neu Laden:"
(cd $POSTNAS_HOME; psql $con -f pp_laden.sql)

echo "** Nachverarbeitung beendet **"