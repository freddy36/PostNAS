<?php
/*	alkis_www_conf.php
	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Zentrale Einstellungen - Internet-Version
	2010-09-16  www-Version
	2010-12-14  $dbname hier
*/

// Datenbank-Zugangsdaten
$dbhost = 'localhost';
$dbport = '5432';
$dbname = 'alkis05' . $gkz; 
$dbuser = '***';
$dbpass = '***';
$dbname = 'alkis05' . $gkz;

// Entwicklung / Produktion
$idumschalter = false;

// Authentifizierung
$auth="mapbender";
//$auth="";  // temporaer deaktiviert
$mapbender="/data/mapwww/http/php/mb_validateSession.php";

// Link für Hilfe
$hilfeurl = 'http://map.krz.de/mapwww/?Themen:ALKIS';

?>