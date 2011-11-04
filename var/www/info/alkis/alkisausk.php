<?php
/*	alkisausk.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Dies Programm wird aus dem Mapserver-Template (FeatureInfo) aufgerufen.
	Parameter: &gkz, &gml_id (optional &id)
	Dies Programm gibt einen kurzen Ueberblick zum Flurstueck.
	Eigentuemer ohne Adresse.
	Fuer detaillierte Angaben wird zum GB- oder FS-Nachweis verlinkt.
	Siehe auch alkisinlayausk.php - eine Variante für den Einbau in einen iFrame

	Version:	25.07.2011  PostNAS 0.5/0.6 Versionen unterscheiden
	26.07.2011  debug, SQL nur im Testmodus ausgeben
	02.11.2011  6.+7. Parameter fuer function eigentuemer()
*/
ini_set('error_reporting', 'E_ALL');
session_start();
$gkz=urldecode($_REQUEST["gkz"]);
require_once("alkis_conf_location.php");
if ($auth == "mapbender") { // Bindung an Mapbender-Auth.
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
if (!$con) {echo "<br>Fehler beim Verbinden der DB.\n<br>";}

// *** F L U R S T U E C K ***
$sql ="SELECT f.flurnummer, f.zaehler, f.nenner, f.amtlicheflaeche, g.gemarkungsnummer, g.bezeichnung ";
$sql.="FROM ax_flurstueck f ";
$sql.="LEFT JOIN ax_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer ";
$sql.="WHERE f.gml_id= $1;";
// Weiter joinen: g.stelle -> ax_dienststelle "Katasteramt"

$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);
if (!$res) {
	echo "\n<p class='err'>Fehler bei Flurstuecksdaten.</p>\n";
	if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}

if ($row = pg_fetch_array($res)) {
	$gemkname=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
	$gmkgnr=$row["gemarkungsnummer"];
	$flurnummer=$row["flurnummer"];
	$flstnummer=$row["zaehler"];
	$nenner=$row["nenner"];
	if ($nenner > 0) $flstnummer.="/".$nenner; // BruchNr
	$flae=$row["amtlicheflaeche"];
	$flae=number_format($flae,0,",",".") . " m&#178;";
} else {
	echo "<p class='err'>Kein Treffer fuer gml_id=".$gmlid."</p>";
}

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
	echo "\n\t<table class='kennzfs' title='Flurst&uuml;ckskennzeichen'>\n\t<tr>";
	echo "\n\t\t<td class='head'>Gmkg</td>\n\t\t<td class='head'>Flur</td>\n\t\t<td class='head'>Flurst-Nr.</td>\n\t</tr>";
	echo "\n\t<tr>\n\t\t<td title='Gemarkung'>";
   if ($showkey) {
		echo "<span class='key'>".$gmkgnr."</span><br>";
	}
	echo $gemkname."</td>";
	echo "\n\t\t<td title='Flurnummer'>".$flurnummer."</td>";
	echo "\n\t\t<td title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'><span class='wichtig'>".$flstnummer."</span></td>\n\t</tr>";
	echo "\n\t</table>";
echo "\n</td>\n<td>";
if ($idanzeige) {linkgml($gkz, $gmlid, "Flurst&uuml;ck"); }
echo "\n\t<p class='nwlink'>weitere Auskunft:<br>";

// Flurstuecksnachweis (o. Eigent.)
echo "\n\t<a href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$gmlid."&amp;eig=n";
if ($idanzeige) { echo "&amp;id=j";}
if ($showkey)   {echo "&amp;showkey=j";}
echo "' title='Flurst&uuml;cksnachweis, alle Flurst&uuml;cksdaten'>Flurst&uuml;ck <img src='ico/Flurstueck_Link.ico' width='16' height='16' alt=''></a><br>";

// FS- u. Eigent.-NW
echo "\n\t\t<a href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$gmlid."&amp;eig=j";
if ($idanzeige) echo "&amp;id=j";
if ($showkey)   {echo "&amp;showkey=j";}
echo "' title='Flurst&uuml;ck mit Eigent&uuml;mer'>Flurst&uuml;ck mit Eigent&uuml;mer</a> <img src='ico/Flurstueck_Link.ico' width='16' height='16' alt=''><br>";

// Gebaeude-NW
echo "\n\t\t<a href='alkisgebaeudenw.php?gkz=".$gkz."&amp;gmlid=".$gmlid;
if ($idanzeige) {echo "&amp;id=j";}
if ($showkey)   {echo "&amp;showkey=j";}
echo "' title='Geb&auml;udenachweis'>Geb&auml;ude <img src='ico/Haus.ico' width='16' height='16' alt=''></a>";

// FS-Historie (noch nicht in DB)
//echo "&nbsp;|&nbsp;<a href='alkisfshist.php?gkz=".$gkz."&amp;flurstkennz=".$gmlid."' title='Vorg&auml;nger- und Nachfolger-Flurst&uuml;cke'>Historie</a>\n";
echo "\n\t</p>\n</td>";
// Lagebezeichnung Mit Hausnummer (Adresse)
// Analog zu alkisfsnachw.php, Kommentare siehe dort$sql ="SELECT DISTINCT l.gml_id, l.gemeinde, l.lage, l.hausnummer, s.bezeichnung ";
$sql.="FROM alkis_beziehungen v ";
$sql.="JOIN ax_lagebezeichnungmithausnummer l ON v.beziehung_zu=l.gml_id "; // Strassennamen JOIN
$sql.="LEFT JOIN ax_lagebezeichnungkatalogeintrag s ON l.kreis=s.kreis AND l.gemeinde=s.gemeinde ";
if ($dbvers=="05") {
	$sql.="AND to_char(l.lage, 'FM00000') = lpad(s.lage,5,'0') ";
} else { // ab PostNAS 0.6
	$sql.="AND l.lage = s.lage ";
}
$sql.="WHERE v.beziehung_von= $1 "; // id FS";
$sql.="AND v.beziehungsart='weistAuf' ";
$sql.="ORDER BY l.gemeinde, l.lage, l.hausnummer;";
$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);
if (!$res) {
	echo "<p class='err'>Fehler bei Lagebezeichnung mit Hausnummer.</p>";
	if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}
$j=0;
while($row = pg_fetch_array($res)) {
	$sname = htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8"); // Str.-Name
	echo "\n<tr>\n\t";
		echo "\n\t<td class='lr'>".$sname."&nbsp;".$row["hausnummer"]."</td>";
		echo "\n\t<td>\n\t\t<p class='nwlink noprint'>";
			echo "\n\t\t\t<a title='Lagebezeichnung mit Hausnummer' href='alkislage.php?gkz=".$gkz."&amp;ltyp=m&amp;gmlid=".$row["gml_id"]."'>Lage ";
			echo "<img src='ico/Lage_mit_Haus.ico' width='16' height='16' alt=''></a>";
		echo "\n\t\t</p>\n\t</td>";
	echo "\n</tr>";
	$j++;
}
echo "\n</tr>\n</table>\n";

// Flurstuecksflaeche
echo "\n<p class='fsd'>Flurst&uuml;cksfl&auml;che: <b>".$flae."</b></p>\n";

// *** G R U N D B U C H ***
echo "\n<h2><img src='ico/Grundbuch_zu.ico' width='16' height='16' alt=''> Grundbuch</h2>";
// ALKIS: FS --> bfs --> GS --> bsb --> GB.
$sql ="SELECT b.gml_id, b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung as blatt, b.blattart, ";
$sql.="s.gml_id AS s_gml, s.buchungsart, s.laufendenummer, s.zaehler, s.nenner, ";
$sql.="z.bezeichnung, a.bezeichner AS bart ";  // stelle -> amtsgericht
$sql.="FROM alkis_beziehungen bfs "; // Bez Flurst.- Stelle.
$sql.="JOIN ax_buchungsstelle s ON bfs.beziehung_zu=s.gml_id ";
$sql.="JOIN alkis_beziehungen bsb ON s.gml_id=bsb.beziehung_von "; // Bez. Stelle - Blatt
$sql.="JOIN ax_buchungsblatt b ON bsb.beziehung_zu=b.gml_id ";
$sql.="LEFT JOIN ax_buchungsblattbezirk z ON z.land=b.land AND z.bezirk=b.bezirk ";
$sql.="LEFT JOIN ax_buchungsstelle_buchungsart a ON s.buchungsart = a.wert ";
$sql.="WHERE bfs.beziehung_von= $1 ";
$sql.="AND bfs.beziehungsart='istGebucht' ";
$sql.="AND bsb.beziehungsart='istBestandteilVon' ";
$sql.="ORDER BY b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung, s.laufendenummer;";

$v = array($gmlid);
$resg = pg_prepare("", $sql);
$resg = pg_execute("", $v);
if (!$resg) {
	echo "\n<p class='err'>Keine Buchungen.</p>\n";
	if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}

$j=0; // Z.Blatt
while($rowg = pg_fetch_array($resg)) {
	$beznam=$rowg["bezeichnung"];
	echo "\n<hr>\n<table class='outer'>";
	echo "\n<tr>";
	echo "\n<td>";

		$blattkey=$rowg["blattart"];
		$blattart=blattart($blattkey);
		if ($blattkey == 1000) {
			echo "\n\t<table class='kennzgb' title='Bestandskennzeichen'>";
		} else {
			echo "\n\t<table class='kennzgbf' title='Bestandskennzeichen'>"; // dotted
		}
			echo "\n\t<tr>";
				echo "\n\t\t<td class='head'>Bezirk</td>";
				echo "\n\t\t<td class='head'>".$blattart."</td>";
				echo "\n\t\t<td class='head'>Lfd-Nr,</td>";
				echo "\n\t\t<td class='head'>Buchungsart</td>";
			echo "\n\t</tr>";
			echo "\n\t<tr>";
				echo "\n\t\t<td title='Grundbuchbezirk'>";
					if ($showkey) {
						echo "<span class='key'>".$rowg["bezirk"]."</span><br>";
					}
				echo $beznam."</td>";
				echo "\n\t\t<td title='Grundbuch-Blatt'><span class='wichtig'>".$rowg["blatt"]."</span></td>";
				echo "\n\t\t<td title='Bestandsverzeichnis-Nummer (BVNR, Grundst&uuml;ck)'>".$rowg["laufendenummer"]."</td>";
				echo "\n\t\t<td title='Buchungsart'>";
					if ($showkey) {
						echo "<span class='key'>".$rowg["buchungsart"]."</span><br>";
					}
					echo $rowg["bart"];
				echo "</td>";
			echo "\n\t</tr>";
		echo "\n\t</table>";

		if ($rowg["zahler"] <> "") {
			echo "\n<p class='ant'>".$rowg["zahler"]."/".$rowg["nenner"]."&nbsp;Anteil am Flurst&uuml;ck</p>";
		}
		echo "\n</td>\n<td>";
		if ($idanzeige) {linkgml($gkz, $rowg[0], "Buchungsblatt");}		echo "\n\t<p class='nwlink'>weitere Auskunft:<br>";
			echo "\n\t\t<a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$rowg[0];
				if ($idanzeige) {echo "&amp;id=j";}
				if ($showkey)   {echo "&amp;showkey=j";}
				echo "' title='Grundbuchnachweis'>";
				echo $blattart;
				echo " <img src='ico/GBBlatt_link.ico' width='16' height='16' alt=''>";
			echo "</a>";
		echo "\n\t</p>";
	echo "\n</td>";
	echo "\n</tr>";
	echo "\n</table>";

	// E I G E N T U E M E R
	if ($blattkey == 5000) { // Schluessel Blattart
		echo "\n<p>Keine Angaben zum Eigentum bei fiktivem Blatt</p>\n";
		echo "\n<p>Siehe weitere Grundbuchbl&auml;tter mit Rechten an dem fiktiven Blatt.</p>\n";
	} else {// kein Eigent. bei fiktiv. Blatt
		echo "\n<hr>\n\n<h3><img src='ico/Eigentuemer_2.ico' width='16' height='16' alt=''> Angaben zum Eigentum</h3>\n";

		// Ausgabe Name in Function
		$n = eigentuemer($con, $gkz, $idanzeige, $rowg["gml_id"], false, $showkey, $debug); // hier ohne Adressen

		if ($n == 0) { // keine Namensnummer, kein Eigentuemer
			echo "\n<p class='err'>Keine Eigent&uuml;mer gefunden.</p>";
			echo "\n<p class='err'>Bezirk ".$rowg["bezirk"]." Blatt ".$rowg["blatt"]." Blattart ".$blattkey." (".$blattart.")</p>";
			linkgml($gkz, $gmlid, "Buchungsblatt");
		}
	}	$j++;
}
if ($j == 0) { // Entwicklungshilfe
	echo "\n<p class='err'>Keine Buchungen gefunden.</p>";
	echo "\n<p><a target='_blank' href=alkisrelationen.php?gkz=".$gkz."&amp;gmlid=".$gmlid.">Beziehungen des Flurst&uuml;cks</a></p>";
	//echo "<p>".$sql."</p>"; // TEST
}
echo "\n<hr>";

footer($gkz, $gmlid, $idumschalter, $idanzeige, $_SERVER['PHP_SELF']."?", $hilfeurl, "", $showkey);

?>
</body>
</html>