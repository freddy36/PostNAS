<?php
/* Einstellungen fuer Mapbender-Navigation mit ALKIS-Daten
	ALKIS-PostGIS-Datenbank aus Konverter PostNAS 0.6
	krz Mi.-Ra./Li.
	2011-07-26
	2011-11-07 Land
	2011-12-09 $persfilter (gemeinde_person)
*/

# DB-Connection
$host="localhost";
$port="5432";
$dbname="alkis";	// .$dbvers.$gkz - Mandant
$dbvers="06";		// 05 oder 06 (steuert Format von .lage)
$user="***";
$password="***";

# Pfad zu den ALKIS-Auskunft-Programmen
$auskpath="../../../info/alkis";

# Massstab zum Positionieren auf Flurstueck, Strasse, Hausnummer
# in MapProxy gecachte Masstaebe verwenden
$scalefs=750;
$scalestr=2500;
$scalehs=500;

# default-Koordinatensystem der GUI
$gui_epsg=31467;

# Landes-Kennung
$land="05"; // NRW

# Filter:
# Liste der relevanten Amtsgerichts-Nummern aus ax_dienststelle.stelle
# Form: WHERE IN ()
# Bei leerer Eingabe in Tab 'Grundb.'
$ag_liste = "'2102','2105','2106','2107','2108','2110','2303','2307'";

# Nur Personen anzeigen, die Eigentum in der Gemeinde (-liste) haben
# "true" setzt voraus, dass die Hilfstabelle "gemeinde_person" gefuellt ist
$persfilter=true;

# hausnummernohnegebaeude - sollen Hausnummern ohne Gebäude ausgegeben werden? 1 ja / 0 nein
$hausnummernohnegebaeude = 1;

# Entwicklungsumgebung
$debug=0; // 0=Produktion, 1=mit Fehlermeldungen, 2=mit Informationen, 3=mit SQL
?>