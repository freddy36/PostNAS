#!/bin/sh
## -------------------------------------------------
## Konvertierung von ALKIS NAS-Format nach PosGIS  -
## NAS-Daten in einem Ordner konvertieren          -
## Dialog-Teil zum Ermitteln der Parameter         -
## -------------------------------------------------
## Stand:
##  2011-07-25  PostNAS 06, Umbenennung
## 
function get_db_config(){

	# Name der zu ladenden ALKIS-Datenbank
	until [ -n "$DBNAME" ]
	do
		echo ""
		echo "Name der ALKIS-Datenbank?"
		read DBNAME
	done

	echo ""
	echo "Datenbank-User?"
	read DBUSER

	echo ""
	echo "Datenbank-Passwort?"
	stty -echo
		read DBPASS
	stty echo

	## Ordner (Eingabedaten)
	echo ""
	echo "Ordner mit gezippten NAS-Daten (*.xml.zip)? (Absoluter Pfad)"
	echo "  z.B.  /data/nas_daten/150/0001"
	read ORDNER
	# Inhalt des Ordners anzeigen
	ls  ${ORDNER}
	LSRESULT=$?
	until [ "$LSRESULT" = 0 ]
	do
		echo "Korrektur: Ordner mit NAS-Daten?"
		read ORDNER
		ls  ${ORDNER}
		LSRESULT=$?
	done

	# Erstladen oder NBA-Aktualisierung
	echo " "
	echo "Art der Konvertierung"
	until [ "$UPD" = "e" -o "$UPD" = "a" ]
	do
		echo " "
		echo "Erstmaliges Laden             =>  e"
		echo "Aktualisierung NBA-Verfahren  =>  a"
		read UPD
	done
	# Bestaetigung holen
	echo " "
	echo "Abschließende Bestätigung:"
	until [ "$JEIN" = "j" -o "$JEIN" = "n" ]
	do
		echo " "
		echo "Datenbank $DBNAME Laden aus Ordner $ORDNER  -  j oder n ?"
		read JEIN
	done
}
## aller Laster Anfang
get_db_config;
if test $JEIN != "j"
then
	echo "Abbruch"
	exit 1
fi
# Protokolldatei ueberschreiben
echo "** Konvertierung ALKIS **" > /data/konvert/postnas_0.6/log/postnas_err.prot
echo "** Beginn Batch **"
#echo "  Kommando fuer Wiederholung:"
#echo "  /data/konvert/postnas_0.6/konv_batch.sh  $ORDNER  $DBNAME  $DBUSER  $DBPASS  $UPD  "
##                                                1        2        3        4        5
         /data/konvert/postnas_0.6/konv_batch.sh  $ORDNER  $DBNAME  $DBUSER  $DBPASS  $UPD
result=$?
if [ $result = 0 ]
then
	echo "** Ende   Batch **"
else
	echo "** Fehler, Batch-Returncode = " $result
fi
echo " "
echo " Kommando fuer Wiederholung:"
echo " /data/konvert/postnas_0.6/konv_batch.sh  $ORDNER  $DBNAME  $DBUSER  $DBPASS  $UPD  "
echo " "
###