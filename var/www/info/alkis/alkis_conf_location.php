<?php
/*	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Pfad zur Konfigurationsdatei der ALKIS-Auskunft.
	Die Conf-Datei sollte aus Sicherheitsgründen nicht unterhalb des Web-Root-Verzeichnisses liegen.

	Version:
	14.12.2010 zentrale Anpassung des Pfades
	25.07.2011 PostNAS 0.5/0.6 Versionen unterscheiden*/
# relativ:
#require_once(dirname(__FILE__)."/../../../../conf/alkis_www_conf.php");
#
# absolut:
#  Hier: Entwicklungs-Version
require_once("/data/conf/alkis_www_conf.php");
$dbname = $dbpre.$dbvers.$gkz;  // Prefix + Konverter-Version + Mandant
?>