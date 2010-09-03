<?php
/*	Modul: alkisnamstruk.php
	Version:
	30.08.2010	$style=ALKIS entfernt, alles Kompakt
	02.09.2010  Mit Icons

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Namens- und Adressdaten fuer einen Eigentuemer aus ALKIS PostNAS
	Parameter:	&gkz= &gmlid=

	ToDo:  
	1. Sortierung der Grundbücher zum Namen
	2. ID ein auch für Buchungsstelle
*/
ini_set('error_reporting', 'E_ALL & ~ E_NOTICE');
session_start();
// Bindung an Mapbender-Authentifizierung
require_once("/data/mapwww/http/php/mb_validateSession.php");
require_once("/data/conf/alkis_www_conf.php");
include("alkisfkt.php");
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta name="author" content="Frank Jaeger" >
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ALKIS Person und Adresse</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Eigentuemer_2.ico">
	<style type='text/css' media='print'>
		.noprint { visibility: hidden;}
	</style>
</head>
<body>
<?php
$gmlid=urldecode($_REQUEST["gmlid"]);
$gkz=urldecode($_REQUEST["gkz"]);
$id = isset($_GET["id"]) ? $_GET["id"] : "n";
$idanzeige=false;
if ($id == "j") {$idanzeige=true;}
$dbname = 'alkis05' . $gkz;
$con = pg_connect("host=".$dbhost." port=".$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);

// Balken
echo "<p class='nakennz'>ALKIS Name id=".$gmlid."&nbsp;</p>\n";

echo "\n<h2><img src='ico/Eigentuemer.ico' width='16' height='16' alt=''> Person</h2>\n";
if (!$con) "\n<p class='err'>Fehler beim Verbinden der DB</p>\n";
$sql="SELECT nachnameoderfirma, anrede, vorname, geburtsname, geburtsdatum, namensbestandteil, akademischergrad ";
$sql.="FROM ax_person WHERE gml_id='".$gmlid."'";
$res=pg_query($con,$sql);
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
		echo "\t<tr><td class='nhd'>Geburtsdatum:</td><td class='nam'>".$row["geburtsdatum"]."</td></tr>\n";
		echo "\t<tr><td class='nhd'>Namensbestandteil:</td><td class='nam'>".$row["namensbestandteil"]."</td></tr>\n";
		echo "\t<tr><td class='nhd'>akademischer Grad:</td><td class='nam'>".$aka."</td></tr>\n";
	echo "\n</table>\n<hr>\n";
	
	// A d r e s s e
	echo "\n<h3><img src='ico/Strasse_mit_Haus.ico' width='16' height='16' alt=''> Adresse</h3>\n";
	$sql ="SELECT a.gml_id, a.ort_post, a.postleitzahlpostzustellung AS plz, a.strasse, a.hausnummer, a.bestimmungsland ";
	$sql.="FROM   ax_anschrift a ";
	$sql.="JOIN   alkis_beziehungen b ON a.gml_id=b.beziehung_zu ";
	$sql.="WHERE  b.beziehung_von='".$gmlid."' ";
	$sql.="AND    b.beziehungsart='hat';"; //"ORDER  BY ?;";
	//echo "\n<p class='err'>".$sql."</p>\n";
	$resa=pg_query($con,$sql);
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
		// beides Kompakt (im Rahmen):
		echo "\n<div class='adr'>".$anr." ".$aka." ".$vor." ".$nam."<br>\n".$str." ".$hsnr."<br>\n".$plz." ".$ort."</div>";
	}
	if ($j == 0) {echo "\n<p class='err'>Keine Adressen.</p>\n";}

	// *** G R U N D B U C H ***
	echo "\n<hr>\n<h3><img src='ico/Grundbuch_zu.ico' width='16' height='16' alt=''> Grundb&uuml;cher</h3>\n";
	// person <benennt< namensnummer >istBestandteilVon>                Buchungsblatt
	//                               >bestehtAusRechtsverhaeltnissenZu> namensnummer   (Nebenzweig/Sonderfälle?)

	$sql ="SELECT n.gml_id AS gml_n, n.laufendenummernachdin1421 AS lfd, n.zaehler, n.nenner, ";
	$sql.="g.gml_id AS gml_g, g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung as nr, g.blattart ";
	$sql.="FROM  alkis_beziehungen bpn ";
	$sql.="JOIN  ax_namensnummer   n   ON bpn.beziehung_von=n.gml_id ";
	$sql.="JOIN  alkis_beziehungen bng ON n.gml_id=bng.beziehung_von ";
	$sql.="JOIN  ax_buchungsblatt  g   ON bng.beziehung_zu=g.gml_id ";
	$sql.="WHERE bpn.beziehung_zu='".$gmlid."' ";
	$sql.="AND   bpn.beziehungsart='benennt' AND bng.beziehungsart='istBestandteilVon' ";
	$sql.="ORDER BY g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung ;";

	//echo "\n<p class='err'>".$sql."</p>\n";
	$resg=pg_query($con,$sql);
	if (!$resg) echo "\n<p class='err'>Fehler bei Grundbuch.<br>\nSQL= ".$sql."</p>\n";
	$j=0;
	echo "<table class='eig'>";
	while($rowg = pg_fetch_array($resg)) {
		$gmln=$rowg["gml_n"];
		$gmlg=$rowg["gml_g"];
		$namnum=kurz_namnr($rowg["lfd"]);
		$zae=$rowg["zaehler"];

		echo "\n<tr>";

			echo "\n\t<td class='gbl'>".blattart($rowg["blattart"])."<br>Buchungsstelle</td>";

			echo "\n\t<td class='gbl'>";
				echo "Bezirk ".$rowg["bezirk"].", Blatt ".$rowg["nr"];
				If ($namnum == "") {echo "<br>&nbsp;";} 
				else {echo "<br>Name Nr: ".$namnum;};
			echo "</td>";

			echo "\n\t<td class='gbl'>"; 
				If ($zae == "") {echo "&nbsp;";} 
				else {echo $zae."/".$rowg["nenner"]." Anteil";} 
			echo "</td>";

			echo "\n\t<td class='gbl'>";
				echo "<p class='nwlink noprint'>";
					echo "<a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$gmlg;
						if ($idanzeige) { echo "&amp;id=j";}
						echo "' title='Bestandsnachweis'>Grundbuch-Blatt <img src='ico/GBBlatt_link.ico' width='16' height='16' alt=''></a></p>";
				if ($idanzeige) {
					linkgml($gkz, $gmlg, "Grundbuchblatt");
					linkgml($gkz, $gmln, "Namensnummer"); 
				}
			echo "</td>";

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

<?php footer($gkz, $gmlid, $idanzeige, $self, $hilfeurl, ""); ?>

</body>
</html>