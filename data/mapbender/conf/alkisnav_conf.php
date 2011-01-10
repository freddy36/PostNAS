<?php
# Einstellungen fuer Mapbender-Navigation mit ALKIS-Daten
# ALKIS-PostGIS-Datenbank aus Konverter PostNAS 0.5
# krz Mi.-Ra./Li. 2010-11-17

# DB-Connection
$host="localhost";
$port="5432";
$dbname="alkis05"; // .$gkz - Mandant
$user="***";
$password="****";

# Pfad zu den ALKIS-Auskunft-Programmen
$auskpath="../../../intern/";

# Massstab zum Positionieren auf Flurstueck, Strasse, Hausnummer
$scalefs=750;
$scalestr=2000;
$scalehs=500;

# default-Koordinatensystem der GUI
$gui_epsg=31467;

# Entwicklungsumgebung
$debug=0; // 0=Produktion, 1=mit Fehlermeldungen, 2=mit Informationen, 3=mit SQL
?>