#!/bin/sh
## Konvertierung von ALKIS NAS-Format nach PosGIS
##
## Beispiel:
##
##   Eine Datenbank komplett neu Laden. 
##   Der Stapel besteht aus Erstladen (e) und mehreren NBA-Aktualisierungen (a).
##   Der Dialog-Teil wird umgangen, die benötigten Parameter werden gleich mitgegeben. 
##
# altes Protokoll loeschen
  echo "** Konvertierung ALKIS **" | /data/konvert/postnas_0.5/log/postnas_err.prot
  echo "** Aktualisierung Muster-Gemeinde **"
# cd /data/konvert/postnas_0.5/
##                                               Ordner                             Datenbank      User      Passw.  Erst/Aktualisierung
## E r s t l a d e n:
##
  /data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0001" "alkis05150neu" "MyUser" "geheim" "e"
##
## A k t u a l i s i e r u n g e n:
##
  /data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0002" "alkis05150neu" "MyUser" "geheim" "a"
  /data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0003" "alkis05150neu" "MyUser" "geheim" "a"
  /data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0004" "alkis05150neu" "MyUser" "geheim" "a"
  /data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0005" "alkis05150neu" "MyUser" "geheim" "a"
  /data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0006" "alkis05150neu" "MyUser" "geheim" "a"
  /data/konvert/postnas_0.5/alkis_konv_batch.sh "/data/konvert/nas_daten/150/0007" "alkis05150neu" "MyUser" "geheim" "a"
#
  echo "** Ende Muster-Gemeinde **"
##