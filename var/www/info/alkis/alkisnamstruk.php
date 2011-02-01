<?php
/*	Modul: alkisnamstruk.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Namens- und Adressdaten fuer einen Eigentuemer aus ALKIS PostNAS

	Version:
	06.09.2010  Schluessel anschaltbar
	15.09.2010  Function "buchungsart" durch JOIN ersetzt, Tabelle GB einzeilig
	14.12.2010  Pfad zur Conf
	17.12.2010  Astrid Emde: Prepared Statements (pg_query -> pg_prepare + pg_execute)
	26.01.2011  Space in leere td
	01.02.2011  *Left* Join - Fehlertoleranz bei unvollstaendigen Schluesseltabellen
	ToDo: 
	Sortierung der Grundbücher zum Namen
*/
ini_set('error_reporting', 'E_ALL & ~ E_NOTICE');
session_start();
$gkz=urldecode($_REQUEST["gkz"]);
require_once("alkis_conf_location.php");
if ($auth == "mapbender") {
	// Bindung an Mapbender-Authentifizierung
	require_once($mapbender);
}
include("alkisfkt.php");
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta name="author" content="F. Jaeger krz" >
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ALKIS Person und Adresse</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Eigentuemer_2.ico">
	<style type='text/css' media='print'>
		.noprint {visibility: hidden;}
	</style>
</head>
<body>
<?php
$gmlid=urldecode($_REQUEST["gmlid"]);
$id = isset($_GET["id"]) ? $_GET["id"] : "n";
if ($id == "j") {
	$idanzeige=true;
} else {
	$idanzeige=false;
}
$keys = isset($_GET["showkey"]) ? $_GET["showkey"] : "n";
if ($keys == "j") {
	$showkey=true;
} else {
	$showkey=false;
}
$con = pg_connect("host=".$dbhost." port=".$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) echo "<p class='err'>Fehler beim Verbinden der DB</p>\n";

// Balken
echo "<p class='nakennz'>ALKIS Name id=".$gmlid."&nbsp;</p>\n";

echo "\n<h2><img src='ico/Eigentuemer.ico' width='16' height='16' alt=''> Person</h2>\n";
if (!$con) "\n<p class='err'>Fehler beim Verbinden der DB</p>\n";

$sql="SELECT nachnameoderfirma, anrede, vorname, geburtsname, geburtsdatum, namensbestandteil, akademischergrad ";
$sql.="FROM ax_person WHERE gml_id= $1;";

$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);

if (!$res) {echo "\n<p class='err'>Fehler bei Zugriff auf Namensnummer</p>\n";}
if ($idanzeige) { linkgml($gkz, $gmlid, "Person"); }
if ($row = pg_fetch_array($res)) {
	$vor=htmlentities($row["vorname"], ENT_QUOTES, "UTF-8");
	$nam=htmlentities($row["nachnameoderfirma"], ENT_QUOTES, "UTF-8");
	$geb=htmlentities($row["geburtsname"], ENT_QUOTES, "UTF-8");
	$anr=anrede($row["anrede"]);
	$aka=$row["akademischergrad"];

	echo "<table>\n";
		echo "\t<tr><td class='nhd'>Anrede:</td><td class='nam'>".$anr."</td></tr>\n";
		echo "\t<tr><td class='nhd'>Nachname oder Firma:</td><td class='nam'>".$nam."</td></tr>\n";
		echo "\t<tr><td class='nhd'>Vorname:</td><td class='nam'>".$vor."</td></tr>\n";
		echo "\t<tr><td class='nhd'>Geburtsname:</td><td class='nam'>".$geb."</td></tr>\n";
		echo "\t<tr><td class='nhd'>Geburtsdatum:</td><td class='nam'>".$row["geburtsdatum"]."&nbsp;</td></tr>\n";
		echo "\t<tr><td class='nhd'>Namensbestandteil:</td><td class='nam'>".$row["namensbestandteil"]."&nbsp;</td></tr>\n";
		echo "\t<tr><td class='nhd'>akademischer Grad:</td><td class='nam'>".$aka."&nbsp;</td></tr>\n";
	echo "\n</table>\n<hr>\n";

	// A d r e s s e
	echo "\n<h3><img src='ico/Strasse_mit_Haus.ico' width='16' height='16' alt=''> Adresse</h3>\n";
	$sql ="SELECT a.gml_id, a.ort_post, a.postleitzahlpostzustellung AS plz, a.strasse, a.hausnummer, a.bestimmungsland ";
	$sql.="FROM ax_anschrift a ";
	$sql.="JOIN alkis_beziehungen b ON a.gml_id=b.beziehung_zu ";
	$sql.="WHERE b.beziehung_von= $1 ";
	$sql.="AND b.beziehungsart='hat';"; //"ORDER  BY ?;";
	//echo "\n<p class='err'>".$sql."</p>\n";

	$v = array($gmlid);
	$resa = pg_prepare("", $sql);
	$resa = pg_execute("", $v);

	if (!$resa) echo "\n<p class='err'>Fehler bei Adressen.<br>\nSQL= ".$sql."</p>\n";
	$j=0;
	while($rowa = pg_fetch_array($resa)) {
		$gmla=$rowa["gml_id"];
		$plz=$rowa["plz"];
		$ort=htmlentities($rowa["ort_post"], ENT_QUOTES, "UTF-8");
		$str=htmlentities($rowa["strasse"], ENT_QUOTES, "UTF-8");
		$hsnr=$rowa["hausnummer"];
		$land=htmlentities($rowa["bestimmungsland"], ENT_QUOTES, "UTF-8");
		if ($idanzeige) { linkgml($gkz, $gmla, "Adresse"); }

		echo "<table>\n";
			echo "\t<tr><td class='nhd'>PLZ:</td><td class='nam'>".$plz."</td></tr>\n";
			echo "\t<tr><td class='nhd'>Ort:</td><td class='nam'>".$ort."</td></tr>\n";
			echo "\t<tr><td class='nhd'>Strasse:</td><td class='nam'>".$str."</td></tr>\n";
			echo "\t<tr><td class='nhd'>Hausnummer:</td><td class='nam'>".$hsnr."</td></tr>\n";
			echo "\t<tr><td class='nhd'>Land:</td><td class='nam'>".$land."</td></tr>\n";
		echo "\n</table>\n<br>\n";
		$j++;

		// Name und Adresse Kompakt (im Rahmen)
		// Alles was man fuer ein Anschreiben braucht
		echo "<img src='ico/Namen.ico' width='16' height='16' alt='Brief' title='Anschrift'>"; // Symbol "Brief"
		echo "\n<div class='adr' title='Anschrift'>".$anr." ".$aka." ".$vor." ".$nam."<br>";
		echo "\n".$str." ".$hsnr."<br>";
		echo "\n".$plz." ".$ort."</div>";
	}
	if ($j == 0) {echo "\n<p class='err'>Keine Adressen.</p>\n";}

	// *** G R U N D B U C H ***
	echo "\n<hr>\n<h3><img src='ico/Grundbuch_zu.ico' width='16' height='16' alt=''> Grundb&uuml;cher</h3>\n";
	// person <benennt< namensnummer >istBestandteilVon>                Buchungsblatt
	//                               >bestehtAusRechtsverhaeltnissenZu> namensnummer   (Nebenzweig/Sonderfälle?)

	$sql ="SELECT n.gml_id AS gml_n, n.laufendenummernachdin1421 AS lfd, n.zaehler, n.nenner, ";
	$sql.="g.gml_id AS gml_g, g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung as nr, g.blattart, ";
	$sql.="b.bezeichnung AS beznam ";
	$sql.="FROM alkis_beziehungen bpn ";
	$sql.="JOIN ax_namensnummer n ON bpn.beziehung_von=n.gml_id ";
	$sql.="JOIN alkis_beziehungen bng ON n.gml_id=bng.beziehung_von ";
	$sql.="JOIN ax_buchungsblatt g ON bng.beziehung_zu=g.gml_id ";
	$sql.="LEFT JOIN ax_buchungsblattbezirk b ON g.land = b.land AND g.bezirk = b.bezirk ";
	$sql.="WHERE bpn.beziehung_zu= $1 ";
	$sql.="AND bpn.beziehungsart='benennt' AND bng.beziehungsart='istBestandteilVon' ";
	$sql.="ORDER BY g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung;";
	// buchungsblatt... mal mit und mal ohne fuehrende Nullen, bringt die Sortierung durcheinander

	//echo "\n<p class='err'>".$sql."</p>\n";
	$v = array($gmlid);
	$resg = pg_prepare("", $sql);
	$resg = pg_execute("", $v);

	if (!$resg) echo "\n<p class='err'>Fehler bei Grundbuch.<br>\nSQL= ".$sql."</p>\n";
	$j=0;
	echo "<table class='eig'>";

	echo "\n<tr>";
		echo "\n\t<td class='head'>Bezirk</td>";
		echo "\n\t<td class='head'>Blattart</td>";
		echo "\n\t<td class='head'>Blatt</td>";
		echo "\n\t<td class='head'>Namensnummer</td>";
		echo "\n\t<td class='head'>Anteil</td>";
		echo "\n\t<td class='head nwlink noprint' title='Link: weitere Auskunft'>weit. Auskunft</td>";
	echo "\n</tr>";

	while($rowg = pg_fetch_array($resg)) {
		$gmln=$rowg["gml_n"];
		$gmlg=$rowg["gml_g"];
		$namnum=kurz_namnr($rowg["lfd"]);
		$zae=$rowg["zaehler"];
		$blattkey=$rowg["blattart"];
		$blattart=blattart($blattkey);

		echo "\n<tr>";

			echo "\n\t<td class='gbl'>"; // GB-Bezirk"
				if ($showkey) {
					echo "<span class='key'>".$rowg["bezirk"]."</span> ";
				}
				echo $rowg["beznam"];
			echo "</td>";

			echo "\n\t<td class='gbl'>"; // Blattart
				if ($showkey) {
					echo "<span class='key'>".$blattkey."</span> ";
				}
				echo $blattart;
			echo "</td>";

			echo "\n\t<td class='gbl'>"; // Blatt
				echo "<span class='wichtig'>".$rowg["nr"]."</span>";
				if ($idanzeige) {
					linkgml($gkz, $gmlg, "Grundbuchblatt");				}
			echo "</td>";

			echo "\n\t<td class='gbl'>"; // Namensnummer
				If ($namnum == "") {
					echo "&nbsp;";
				} else {
					echo $namnum;
				}
				if ($idanzeige) {
					linkgml($gkz, $gmln, "Namensnummer"); 
				}
			echo "</td>";

			echo "\n\t<td class='gbl'>"; // Anteil
				If ($zae == "") {
					echo "&nbsp;";
				} else {
					echo $zae."/".$rowg["nenner"]." Anteil";
				} 
			echo "</td>";

			echo "\n\t<td class='gbl'>";
				echo "\n\t\t<p class='nwlink noprint'>";
					echo "\n\t\t\t<a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$gmlg;
						if ($idanzeige) {echo "&amp;id=j";}
						if ($showkey)   {echo "&amp;showkey=j";}
						echo "' title='Bestandsnachweis'>";
						echo $blattart;
					echo "\n\t\t\t<img src='ico/GBBlatt_link.ico' width='16' height='16' alt=''></a>";
				echo "\n\t\t</p>";			echo "\n\t</td>";

		echo "\n</tr>";
		// +++ >bestehtAusRechtsverhaeltnissenZu> namensnummer ??
		//     z.B. eine Namennummer "Erbengemeinschaft" zeigt auf Namensnummern mit Eigentümern
		$i++;
	}
	echo "</table>";
	if ($i == 0) {echo "\n<p class='err'>Kein Grundbuch.</p>\n";}
} else {
	echo "\n\t<p class='err'>Fehler! Kein Treffer f&uuml;r\n\t<a target='_blank' href='alkisrelationen.php?gkz=".$gkz."&amp;gmlid=".$gmlid."'>".$gmlid."</a>\n</p>\n\n";
}
?>

<form action=''>
	<div class='buttonbereich noprint'><hr>
		<input type='button' name='back'  value='&lt;&lt;' title='Zur&uuml;ck'  onClick='javascript:history.back()'>&nbsp;
		<input type='button' name='print' value='Druck' title='Seite Drucken' onClick='window.print()'>&nbsp;
		<input type='button' name='close' value='X' title='Fenster schlie&szlig;en' onClick='window.close()'>
	</div>
</form>

<?php footer($gkz, $gmlid, $idumschalter, $idanzeige, $_SERVER['PHP_SELF']."?", $hilfeurl, "", $showkey); ?>

</body>
</html>