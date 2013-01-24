#!/bin/sh
## Konvertierung von ALKIS NAS-Format nach PosGIS
## 1       2       3       4       5
## ORDNER  DBNAME  DBUSER  DBPASS  UPD
##
# altes Protokoll loeschen
echo "** Konvertierung ALKIS **" | /data/konvert/postnas_0.5/log/postnas_err.prot
echo "** Aktualisierung Lage **"
#cd /data/konvert/postnas_0.5/
##                                             Ordner                             Datenbank     User      Passw.  Erst/Aktualisierung
/data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0002" "alkis05150n" "xxxxxxxx" "xxxxxxxx" "a"
/data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0003" "alkis05150n" "xxxxxxxx" "xxxxxxxx" "a"
/data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0004" "alkis05150n" "xxxxxxxx" "xxxxxxxx" "a"
/data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0005" "alkis05150n" "xxxxxxxx" "xxxxxxxx" "a"
/data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0006" "alkis05150n" "xxxxxxxx" "xxxxxxxx" "a"
/data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0007" "alkis05150n" "xxxxxxxx" "xxxxxxxx" "a"
/data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0008" "alkis05150n" "xxxxxxxx" "xxxxxxxx" "a"
/data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0009" "alkis05150n" "xxxxxxxx" "xxxxxxxx" "a"
/data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0010" "alkis05150n" "xxxxxxxx" "xxxxxxxx" "a"
/data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0011" "alkis05150n" "xxxxxxxx" "xxxxxxxx" "a"
/data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0012" "alkis05150n" "xxxxxxxx" "xxxxxxxx" "a"
echo "** Ende **"
##