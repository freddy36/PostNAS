<?php
/*	alkis_www_conf.php
	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Zentrale Einstellungen - Internet-Version
	2010-09-16
*/

// Datenbank-Zugangsdaten
$dbhost = 'localhost';
$dbport = '5432';
$dbuser = '***';
$dbpass = '***';

// Entwicklung / Produktion
$idumschalter = false;

// Authentifizierung
$auth="mapbender";
$mapbender="/data/mapwww/http/php/mb_validateSession.php";

// Link für Hilfe
$hilfeurl = 'http://map.krz.de/mapwww/?Themen:ALKIS';

?>