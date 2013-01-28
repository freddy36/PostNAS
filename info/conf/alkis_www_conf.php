<?php
/*	alkis_www_conf.php
	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Zentrale Einstellungen - Internet-Version
	2011-07-25  PostNAS 0.5/0.6 Versionen unterscheiden
	2011-07-26  debug-Parameter zur Fehlersuche
*/

// Datenbank-Zugangsdaten
$dbhost = 'localhost';
$dbport = '5432';
$dbuser = '***';
$dbpass = '***';
$dbpre  = 'alkis';
$dbvers = '06';

// Entwicklung / Produktion
$idumschalter = false;

// Authentifizierung
//$auth="mapbender";
$auth="";  // ** temporaer deaktiviert **!
$mapbender="/data/mapwww/http/php/mb_validateSession.php";

// Link für Hilfe
$hilfeurl = 'http://map.krz.de/mapwww/?Themen:ALKIS';

// Entwicklungsumgebung
$debug=3; // 0=Produktion, 1=mit Fehlermeldungen, 2=mit Informationen, 3=mit SQL
?>