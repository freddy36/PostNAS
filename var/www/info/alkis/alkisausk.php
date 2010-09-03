<?php
/*	alkisausk.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Dies Programm wird aus dem Mapserver-Template (FeatureInfo) aufgerufen.
	Parameter:&gkz, &gml_id (optional &id)
	Dies Programm gibt einen kurzen Ueberblick zum Flurstueck.
	Eigentuemer ohne Adresse.
	Fuer detaillierte Angaben wird zum GB- oder FS-Nachweis verlinkt.

	Version:
		28.05.2010	Eigentümerausgabe in einer Function
		27.08.2010	Erweiterung um Link zu Gebaeudenachweis der WhereGroup
		31.08.2010	$style=ALKIS entfernt, alles Kompakt
		02.09.2010  Mit Icons
*/
ini_set('error_reporting', 'E_ALL');
session_start();
// Bindung an Mapbender-Authentifizierung
require_once("/data/mapwww/http/php/mb_validateSession.php");
//require_once(dirname(__FILE__)."/../../../php/mb_validateSession.php");
require_once("/data/conf/alkis_conf.php");
//require_once(dirname(__FILE__)."/../../../../conf/alkis_conf.php");
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
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Flurstueck.ico">
	<title>ALKIS-Auskunft</title>
	<style type='text/css' media='print'>
		.noprint { visibility: hidden;}
	</style>
</head>
<body>
<?php
$gmlid = isset($_GET["gmlid"]) ? $_GET["gmlid"] : 0;
$gkz=urldecode($_REQUEST["gkz"]);
$id = isset($_GET["id"]) ? $_GET["id"] : "n";
$idanzeige=false;
if ($id == "j") {$idanzeige=true;}
$dbname = 'alkis05' . $gkz;
$con = pg_connect("host=".$dbhost." port=".$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) {echo "<br>Fehler beim Verbinden der DB.\n<br>";}

// *** F L U R S T U E C K ***
$sql ="SELECT f.flurnummer, f.zaehler, f.nenner, f.amtlicheflaeche, ";
$sql.=" g.gemarkungsnummer, g.bezeichnung ";
$sql.="FROM ax_flurstueck f ";
$sql.="JOIN ax_gemarkung  g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer ";
$sql.="WHERE f.gml_id='".$gmlid."';";
// Weiter joinen: g.stelle -> ax_dienststelle "Katasteramt"
$res=pg_query($con,$sql);
if (!$res) echo "\n<p class='err'>Fehler bei Flurstuecksdaten\n<br>".$sql."</p>\n";
if ($row = pg_fetch_array($res)) {
	$gemkname=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
	$gmkgnr=$row["gemarkungsnummer"];
	$flurnummer=$row["flurnummer"];
	$flstnummer=$row["zaehler"];
	$nenner=$row["nenner"];
	if ($nenner > 0) $flstnummer.="/".$nenner; // BruchNr
	$flae=$row["amtlicheflaeche"];
	$flae=number_format($flae,0,",",".") . " m&#178;";
} else {echo "Fehler! Kein Treffer fuer gml_id=".$gmlid;}

// Balken
echo "\n<p class='fsausk'>ALKIS-Auskunft Flurst&uuml;ck-&Uuml;bersicht ".$gmkgnr."-".$flurnummer."-".$flstnummer."</p>";

echo "\n<table class='outer'>\n<tr><td>";
	// linke Seite
	echo "\n<h1>ALKIS-Auskunft</h1>";
	echo "\n<h2><img src='ico/Flurstueck.ico' width='16' height='16' alt=''> Flurst&uuml;ck - &Uuml;bersicht</h2>";
echo "</td><td align='right'>";
	// rechte Seite
	echo "<img src='pic/AAA.gif' alt=''>";
echo "</td></tr></table>";

echo "\n<table class='outer'>\n<tr>\n<td>";
	echo "\n\t<table class='kennz' title='Flurst&uuml;ckskennzeichen'>\n\t<tr>";
	echo "\n\t\t<td class='head'>Gmkg</td>\n\t\t<td class='head'>Flur</td>\n\t\t<td class='head'>Flurst-Nr.</td>\n\t</tr>";
	echo "\n\t<tr>\n\t\t<td title='Gemarkung'><span class='key'>".$gmkgnr."</span><br>".$gemkname."</td>";
	echo "\n\t\t<td title='Flurnummer'>".$flurnummer."</td>";
	echo "\n\t\t<td title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'><span class='wichtig'>".$flstnummer."</span></td>\n\t</tr>";
	echo "\n\t</table>";
echo "\n</td>\n<td>";
if ($idanzeige) { linkgml($gkz, $gmlid, "Flurst&uuml;ck"); }
echo "<br>\n\t<p class='nwlink'>weitere Auskunft:<br>";

// Flurstuecksnachweis (o. Eigent.)
echo "\n\t<a href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$gmlid."&amp;eig=n";
if ($idanzeige) { echo "&amp;id=j";}
echo "' title='Flurst&uuml;cksnachweis, alle Flurst&uuml;cksdaten'>Flurst&uuml;ck <img src='ico/Flurstueck_Link.ico' width='16' height='16' alt=''></a><br>";

// FS- u. Eigent.-NW
echo "\n\t\t<a href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$gmlid."&amp;eig=j";
if ($idanzeige) echo "&amp;id=j";
echo "' title='Flurst&uuml;ck mit Eigent&uuml;mer'>Flurst&uuml;ck mit Eigent&uuml;mer</a> <img src='ico/Flurstueck_Link.ico' width='16' height='16' alt=''><br>";

// Gebaeude-NW
echo "\n\t\t<a href='alkisgebaeudenw.php?gkz=".$gkz."&amp;gmlid=".$gmlid;
if ($idanzeige) echo "&amp;id=j";
echo "' title='Geb&auml;udenachweis'>Geb&auml;ude <img src='ico/Haus.ico' width='16' height='16' alt=''></a>";

// FS-Historie (noch nicht in DB)
//echo "&nbsp;|&nbsp;<a href='alkisfshist.php?gkz=".$gkz."&amp;flurstkennz=".$gmlid."' title='Vorg&auml;nger- und Nachfolger-Flurst&uuml;cke'>Historie</a>\n";
echo "\n\t</p>\n</td>";
echo "\n</tr>\n</table>\n";
echo "\n<p class='fsd'>Flurst&uuml;cksfl&auml;che: <b>".$flae."</b></p>\n";

// *** G R U N D B U C H ***
echo "\n<h2><img src='ico/Grundbuch_zu.ico' width='16' height='16' alt=''> Grundbuch</h2>";
// ALKIS: FS --> bfs --> GS --> bsb --> GB.
$sql ="SELECT b.gml_id, b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung as blatt, b.blattart, ";
$sql.="s.gml_id AS s_gml, s.buchungsart, s.laufendenummer, s.zaehler, s.nenner, ";
$sql.="z.bezeichnung ";  // stelle -> amtsgericht
$sql.="FROM  alkis_beziehungen    bfs "; // Bez Flurst.- Stelle.
$sql.="JOIN  ax_buchungsstelle      s ON bfs.beziehung_zu=s.gml_id ";
$sql.="JOIN  alkis_beziehungen    bsb ON s.gml_id=bsb.beziehung_von "; // Bez. Stelle - Blatt
$sql.="JOIN  ax_buchungsblatt       b ON bsb.beziehung_zu=b.gml_id ";
$sql.="JOIN  ax_buchungsblattbezirk z ON z.land=b.land AND z.bezirk=b.bezirk ";
$sql.="WHERE bfs.beziehung_von='".$gmlid."' ";
$sql.="AND   bfs.beziehungsart='istGebucht' ";
$sql.="AND   bsb.beziehungsart='istBestandteilVon' ";
$sql.="ORDER BY b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung, s.laufendenummer;";
$resg=pg_query($con,$sql);
if (!$resg) echo "\n<p class='err'>Keine Buchungen.<br>\nSQL= ".$sql."</p>\n";
$j=0; // Z.Blatt
while($rowg = pg_fetch_array($resg)) {
	$beznam=$rowg["bezeichnung"];
	echo "\n<hr>\n<table class='outer'>\n<tr>\n<td>";
	echo "\n\t<table class='kennz' title='Bestandskennzeichen'>\n\t<tr>\n\t\t<td class='head'>Bezirk</td>";
		echo "\n\t\t<td class='head'>".blattart($rowg["blattart"])."</td>\n\t\t<td class='head'>Lfd-Nr,</td>\n\t\t<td class='head'>Buchungsart</td>\n\t</tr>";
		echo "\n\t<tr>\n\t\t<td title='Grundbuchbezirk'><span class='key'>".$rowg["bezirk"]."</span><br>".$beznam."</td>";
		echo "\n\t\t<td title='Grundbuch-Blatt'><span class='wichtig'>".$rowg["blatt"]."</span></td>";
		echo "\n\t\t<td title='Bestandsverzeichnis-Nummer (BVNR, Grundst&uuml;ck)'>".$rowg["laufendenummer"]."</td>";
		echo "\n\t\t<td title='Buchungsart'>".$rowg["buchungsart"]."<br>".buchungsart($rowg["buchungsart"])."</td>\n\t</tr>";
	echo "\n\t</table>";
	if ($rowg["zahler"] <> "") {
		echo "\n<p class='ant'>".$rowg["zahler"]."/".$rowg["nenner"]."&nbsp;Anteil am Flurst&uuml;ck</p>";
	}
	echo "\n</td>\n<td>";
		if ($idanzeige) { linkgml($gkz, $rowg[0], "Buchungsblatt");}
		echo "<br>\n";
		echo "\n\t<p class='nwlink'>weitere Auskunft:<br>";
		echo "\n\t\t<a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$rowg[0];
			if ($idanzeige) echo "&amp;id=j";
			echo "' title='Grundbuchnachweis mit kompletter Eigent&uuml;merangabe'>Grundbuch-Blatt ";
			echo "<img src='ico/GBBlatt_link.ico' width='16' height='16' alt=''></a>";
	echo "\n\t</p>\n</td>\n";
	echo "</table>";
	
	// E I G E N T U E M E R
	if ($rowg["blattart"] == 5000) { 
		echo "\n<p>Keine Angaben zum Eigentum bei fiktivem Blatt</p>\n";
		echo "\n<p>Siehe weitere Grundbuchbl&auml;tter mit Rechten an dem fiktiven Blatt.</p>\n";
	} else {// kein Eigent. bei fiktiv. Blatt
		echo "\n<hr>\n\n<h3><img src='ico/Eigentuemer_2.ico' width='16' height='16' alt=''> Angaben zum Eigentum</h3>\n";
		// Ausgabe Name in Function
		$n = eigentuemer($con, $gkz, $idanzeige, $rowg["gml_id"], false); // hier ohne Adressen
		if ($n == 0) { // keine Namensnummer, kein Eigentuemer
			echo "\n<p class='err'>Keine Namensnummer gefunden.</p>";
			echo "\n<p>Bezirk: ".$row["bezirk"].", Blatt: ".$row["nr"].", Blattart ".$row["blattart"]." (".$blattart.")</p>";
			linkgml($gkz, $gmlid, "Buchungsblatt");
		}
	}
	$j++;
}
if ($j == 0) { // Entwicklungshilfe
	echo "\n<p class='err'>Keine Buchungen gefunden.</p>";
	echo "\n<p><a target='_blank' href=alkisrelationen.php?gkz=".$gkz."&amp;gmlid=".$gmlid.">Beziehungen des Flurst&uuml;cks</a></p>";
	//echo "<p>".$sql."</p>"; // TEST
}
echo "\n<hr>";
footer($gkz, $gmlid, $idanzeige, $self, $hilfeurl, "");

?>
</body>
</html>