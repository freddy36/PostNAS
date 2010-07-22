<?php
/*	alkisrelationen.php
	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Verfolgt die Beziehungen von ALKIS-Objekten in der Tabelle 'alkis_beziehungen'.
	Link durch "&id=j;" in den anderen Modulen zuschaltbar.
	Ist eher fuer die Entwicklung der Auskunft gedacht (Sonderfaelle) als fuer den Anwender.
	Parameter:	gkz, gml_id
	Version:
	26.01.2010	internet-Version  mit eigener conf
*/
ini_set('error_reporting', 'E_ALL');
session_start();
// Mapbender-Authentifizierung
require_once("/data/mapwww/http/php/mb_validateSession.php");
require_once("/data/conf/alkis_www_conf.php");
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta name="author" content="F. Jaeger">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<title>ALKIS-Relationen-Browser</title>
</head>
<body>
<?php
$gkz=urldecode($_REQUEST["gkz"]);
$gmlid=isset($_GET["gmlid"]) ? $_GET["gmlid"] : 0;
$style=isset($_GET["style"]) ? $_GET["style"] : "kompakt";
$otyp=isset($_GET["otyp"]) ? $_GET["otyp"] : "Objekt";
$dbname = 'alkis05' . $gkz;
$con = pg_connect("host=".$dbhost." port=".$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
echo "\n<p class='bezieh'>Beziehungen ".$gmlid."</p>";
echo "\n\n<h2>ALKIS-Beziehungen</h2>";
if (!$con) {echo "\n<p class='err'>Fehler beim Verbinden der DB.</p>";
} else {
	echo "\n<p>von ALKIS-".$otyp."</p>";
	echo "\n\n<h3 title='Die gml_is ist global eindeutig'>".$gmlid."</h3>";
	$sql="SELECT beziehungsart, beziehung_zu FROM alkis_beziehungen WHERE beziehung_von='".$gmlid."';";
	$res=pg_query($con,$sql);
	echo "\n<table>";
	if (!$res) { // vorab Anzahl der Saetze ermitteln?
		echo "\n<tr>\n\t<td colspan=3><b>Keine</b> Beziehungen vom Objekt</td>\n</tr>";
	} else {
		echo "\n<tr>\n\t<td class='head' colspan=3><br>Beziehungen <b>vom</b> Objekt zu ..</td>\n</tr>";
		$i=0;
		while($row = pg_fetch_array($res)) {
			echo "\n<tr>\n\t<td>".$otyp."</td>";
			echo "\n\t<td class='bez'>".$row["beziehungsart"]."</td>";
			echo "\n\t<td>\n\t\t<a href='".$self."gkz=".$gkz."&amp;gmlid=".$row["beziehung_zu"]."&amp;style=".$style."'>".$row["beziehung_zu"]."</a>";
			echo "\n\t</td>\n</tr>";
			$i++;
		}
		if ($i == 0) echo "<tr><td colspan=3>.. keine</td></tr>";
	}
	$sql="SELECT beziehungsart, beziehung_von FROM alkis_beziehungen WHERE beziehung_zu='".$gmlid."';";
	$res=pg_query($con,$sql);
	if (!$res) {
		echo "<tr><td colspan=3><b>Keine</b> Beziehungen zum Objekt</td></tr>";
	} else {
		echo "\n<tr>\n\t<td class='head' colspan=3><br>Beziehungen <b>zum</b> Objekt von ..</td>\n</tr>";
		$i=0;
		while($row = pg_fetch_array($res)) {
			echo "\n<tr>\n\t<td>";
			echo "\n\t\t<a href='".$self."gkz=".$gkz."&amp;gmlid=".$row["beziehung_von"]."&amp;style=".$style."'>".$row["beziehung_von"]."</a>";
			echo "\n\t</td>";
			echo "\n\t<td class='bez'>".$row["beziehungsart"]."</td>";
			echo "\n\t<td>".$otyp."</td>\n</tr>";
			$i++;
		}
		if ($i == 0) echo "\n<tr>\n\t<td colspan=3>.. keine</td>\n</tr>";
	}
	echo "\n</table>";
}
echo "\n<hr>\n<p class='nwlink'>\n\t<a target='_blank' href='".$hilfeurl."' title='Dokumentation'>Hilfe zur ALKIS-Auskunft</a>\n</p>\n";
?>
</body>
</html>