<?php
/*	alkisausk.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Dies Programm wird aus dem Mapserver-Template (FeatureInfo) aufgerufen.
	Parameter:&gkz, &gml_id (optional &id)
	Dies Programm gibt einen kurzen Ueberblick über die wichtigsten Daten zum Flurstueck.
	In einfachen Faellen wird auch der Eigentümer ohne Adresse angezeigt.
	Fuer detaillierte Angaben wird zum GB- oder FS-Nachweis verlinkt.

	Version:
	26.01.2010	internet-Version  mit eigener conf
*/
ini_set('error_reporting', 'E_ALL');
session_start();
// Bindung an Mapbender-Authentifizierung
#require_once("/data/mapwww/http/php/mb_validateSession.php");
#require_once("/data/conf/alkis_www_conf.php");
#AE
require_once(dirname(__FILE__)."/../../../php/mb_validateSession.php");
require_once(dirname(__FILE__)."/../../../../conf/alkis_www_conf.php");

include("alkisfkt.php");
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
	<title>ALKIS-Auskunft</title>
</head>
<body>
<?php
$gmlid = isset($_GET["gmlid"]) ? $_GET["gmlid"] : 0;
$gkz=urldecode($_REQUEST["gkz"]);
$id = isset($_GET["id"]) ? $_GET["id"] : "n";
$idanzeige=false;
if ($id == "j") {$idanzeige=true;}
$style=isset($_GET["style"]) ? $_GET["style"] : "kompakt";
#$dbname = 'alkis05' . $gkz;
#AE
#$dbname = 'nas_wesseling';
# echo("host=".$dbhost." port=".$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
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

echo "<p class='fsausk'>Flurst&uuml;ck ".$gmkgnr."-".$flurnummer."-".$flstnummer."</p>\n";
echo "<h1>ALKIS-Auskunft</h1>\n";
echo "\n<h2>Flurst&uuml;ck</h2>\n";
echo "\n<table class='bez'>\n";
echo "\n<table class='outer'>\n<tr>\n<td>";
echo "\n\t<table class='kennz' title='Flurst&uuml;ckskennzeichen'>\n\t<tr>";
echo "\n\t\t<td class='head'>Gmkg</td>\n\t\t<td class='head'>Flur</td>\n\t\t<td class='head'>Flurst-Nr.</td>\n\t</tr>";
echo "\n\t<tr>\n\t\t<td title='Gemarkung'>".$gmkgnr."<br>".$gemkname."</td>";
echo "\n\t\t<td title='Flurnummer'>".$flurnummer."</td>";
echo "\n\t\t<td title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'>".$flstnummer."</td>\n\t</tr>\n\t</table>\n";
echo "</td>\n<td>";
if ($idanzeige) { linkgml($gkz, $gmlid, "Flurst&uuml;ck"); }
echo "<br>\n\t<p class='nwlink'>weitere Auskunft:<br>";
echo "\n\t<a href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$gmlid."&amp;eig=n"."&amp;style=".$style;
if ($idanzeige) { echo "&amp;id=j";}
echo "' title='Flurst&uuml;cksnachweis, alle Flurst&uuml;cksdaten'>FS-Nachweis</a>&nbsp;|&nbsp;";
echo "\n\t\t<a href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$gmlid."&amp;eig=j"."&amp;style=".$style;
if ($idanzeige) echo "&amp;id=j";
echo "' title='Flurst&uuml;cks- und Eigent&uuml;mernachweis'>FS- u. Eigent.-Nw</a><br>";
echo "\n\t\t<a href='alkisgebaeudenw.php?gkz=".$gkz."&amp;gmlid=".$gmlid."&amp;eig=j"."&amp;style=".$style;
if ($idanzeige) echo "&amp;id=j";
echo "' title='Geb&auml;udenachweis'>Geb&auml;udenachweis</a>";
//echo "&nbsp;|&nbsp;<a href='alkisfshist.php?gkz=".$gkz."&amp;flurstkennz=".$gmlid."' title='Vorg&auml;nger- und Nachfolger-Flurst&uuml;cke'>Historie</a>\n";
echo "\n\t</p>\n</td>";
echo "\n</tr>\n</table>\n";
echo "\n<p class='fsd'>Flurst&uuml;cksfl&auml;che: <b>".$flae."</b></p>\n";

// *** G R U N D B U C H ***
echo "\n<h2>Grundbuch</h2>";
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
	echo "\n\t<tr>\n\t\t<td title='Grundbuchbezirk'>".$rowg["bezirk"]."<br>".$beznam."</td>";
	echo "\n\t\t<td title='Grundbuch-Blatt'>".$rowg["blatt"]."</td>";
	echo "\n\t\t<td title='Bestandsverzeichnis-Nummer (BVNR, Grundst&uuml;ck)'>".$rowg["laufendenummer"]."</td>";
	echo "\n\t\t<td title='Buchungsart'>".$rowg["buchungsart"]."<br>".buchungsart($rowg["buchungsart"])."</td>\n\t</tr>\n\t</table>";
	if ($rowg["zahler"] <> "") {
		echo "\n<p class='ant'>".$rowg["zahler"]."/".$rowg["nenner"]."&nbsp;Anteil am Flurst&uuml;ck</p>";
	}
	echo "\n</td>\n<td>";
	if ($idanzeige) { linkgml($gkz, $rowg[0], "Buchungsblatt");}
	echo "<br>\n";
	echo "\n\t<p class='nwlink'>weitere Auskunft:<br>\n\t\t<a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$rowg[0]."&amp;style=".$style;
	if ($idanzeige) echo "&amp;id=j";
	echo "' title='Grundbuchnachweis mit kompletter Eigent&uuml;merangabe'>GB-Nachweis</a>\n\t</p>\n</td>\n";
	echo "</table>";
	if ($rowg["blattart"] <> "1000") { // schwierige Sonderfälle nicht in der Übersicht bearbeiten
		echo "\n<p>Blattart: ".blattart($rowg["blattart"])." (".$rowg["blattart"].").<br>\n"; 
		echo "Eigent&uuml;mer siehe\n\t<a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$rowg[0]."&amp;style=".$style;
		if ($idanzeige) echo "&amp;id=j";
		echo "' title='Grundbuchnachweis mit kompletter Eigent&uuml;merangabe'>GB-Nachweis</a>\n</p>";
		//echo "oder"\n\t<a title='ALKIS-Beziehungen-Browser' href='alkisrelationen.php?gkz=".$gkz."&amp;gmlid=".$rowg["s_gml"]."&amp;style=".$style."'>Beziehungen der Buchungsstelle</a>\n</p>";
		linkgml($gkz, $rowg["s_gml"], "Buchungsstelle"); 
	} else { // normales Grundbuchblatt

		// ** E I G E N T U E M E R, zum GB
		echo "\n\n<h3>Eigent&uuml;mer:</h3>\n";

		// Schleife 1: N a m e n s n u m m e r
		// Beziehung: ax_namensnummer  >istBestandteilVon>  ax_buchungsblatt
		$sql="SELECT n.gml_id, n.laufendenummernachdin1421 AS lfd, n.zaehler, n.nenner, ";
		$sql.="n.artderrechtsgemeinschaft AS adr, n.beschriebderrechtsgemeinschaft as beschr, n.eigentuemerart, n.anlass ";
		$sql.="FROM  ax_namensnummer   n ";
		$sql.="JOIN  alkis_beziehungen b ON b.beziehung_von=n.gml_id ";
		$sql.="WHERE b.beziehung_zu='".$rowg["gml_id"]."' "; // id blatt
		$sql.="AND   b.beziehungsart='istBestandteilVon' ";
		$sql.="ORDER BY laufendenummernachdin1421;";
		$resn=pg_query($con, $sql);
		if (!$resn) {echo "<p class='err'>Fehler bei Eigentuemer<br>SQL= ".$sql."<br></p>\n";}
		echo "\n<table class='eig'>";
		$n=0; // Z.NamNum.
		while($rown = pg_fetch_array($resn)) {
			echo "\n<tr>\n\t<td class='nanu' title='Namens-Nummer'>";
			// VOR die Tabelle: "Eigentümer"
			$namnum=kurz_namnr($rown["lfd"]);
			echo "\n\t<p>".$namnum."</p>";
			if ($idanzeige) {linkgml($gkz, $rown["gml_id"], "Namensnummer");}
			echo "\n\t</td>\n\t<td>";
			$rechtsg=$rown["adr"];
			if ($rechtsg != "" ) {
				if ($rechtsg == 9999) { // sonstiges
					echo "\n\t\t<p class='zus' title='Beschrieb der Rechtsgemeinschaft'>".htmlentities($rown["beschr"], ENT_QUOTES, "UTF-8")."</p>";
				} else {
					echo "\n\t\t<p class='zus' title='Art der Rechtsgemeinschaft'>".htmlentities(rechtsgemeinschaft($rown["adr"]), ENT_QUOTES, "UTF-8")."</p>";
				}
			}
			// +++ ggf. Seitenzweige ("andere Namennummern")

			// Schleife 2: P e r s o n  
			// Beziehung: ax_person  <benennt<  ax_namensnummer
			$sql="SELECT p.gml_id, p.nachnameoderfirma, p.vorname, p.geburtsname, p.geburtsdatum, p.namensbestandteil, p.akademischergrad ";
			$sql.="FROM  ax_person p ";
			$sql.="JOIN  alkis_beziehungen v ON v.beziehung_zu=p.gml_id ";
			$sql.="WHERE v.beziehung_von='".$rown["gml_id"]."' "; // id num
			$sql.="AND   v.beziehungsart='benennt';";
			$rese=pg_query($con, $sql);
			if (!$rese) echo "\n<p class='err'>Fehler bei Eigentuemer<br>SQL= ".$sql."<br></p>\n";
			$i=0; // Z.Eig.
			while($rowe = pg_fetch_array($rese)) {
				$diePerson="";
				if ($rowe["akademischergrad"] <> "") $diePerson=$rowe["akademischergrad"]." ";
				$diePerson.=$rowe["nachnameoderfirma"];
				if ($rowe["vorname"] <> "") $diePerson.=", ".$rowe["vorname"];
				if ($rowe["namensbestandteil"] <> "") $diePerson.=". ".$rowe["namensbestandteil"];
				if ($rowe["geburtsdatum"] <> "") $diePerson.=", geb. ".$rowe["geburtsdatum"];
				if ($rowe["geburtsname"] <> "") $diePerson.=", geb. ".$rowe["geburtsname"];
				$diePerson=htmlentities($diePerson, ENT_QUOTES, "UTF-8"); // Umlaute
				// Spalte 1 enthält die Namensnummer, nur in Zeile 0
				if ($i > 0) {echo "\n<tr>\n\t<td></td>\n\t<td>";}
				// Spalte 2 = Angaben
				echo "\n\t<p class='geig' title='Eigent&uuml;merart ".eigentuemerart($rown["eigentuemerart"])."'>".$diePerson."</p></td>";
				// Spalte 3 = Link
				echo "\n\t\t<td>\n\t\t\t<p class='nwlink noprint'>\n\t\t\t<a href='alkisnamstruk.php?gkz=".$gkz."&amp;gmlid=".$rowe[0]."&amp;style=".$style;
				if ($idanzeige) { echo "&amp;id=j";}
				echo "' title='vollst&auml;ndiger Name und Adresse eines Eigent&uuml;mers'>Person</a>\n\t\t</p>";
				if ($idanzeige) { linkgml($gkz, $rowe["gml_id"], "Person");}
				echo "</td>\n</tr>";
				$i++; // Z. Person
				if ($rown["zaehler"] <> "") {
					echo "\n<tr>\n\t<td></td>\n\t<td><p class='avh' title='Anteil'>".$rown["zaehler"]."/".$rown["nenner"]." Anteil</p>";
					echo "\n</td>\n\t<td></td>\n</tr>";
				}
			}
			if ($i == 0) { // keine Pers zur NamNum
				if ($rechtsg != 9999) { // Normal bei Sondereigentum
					echo "\n<tr>\n<td>";
					linkgml($gkz, $rown["gml_id"], "Namensnummer");
					echo "</td>\n<td>\n\t\t<p class='err'>Kein Eigent&uuml;mer gefunden.</p>";
					echo "\n\t\t\n\t</td>\n\t<td></td>\n<tr>";
				}
			}
			$n++; // Z.NamNum
		}
		echo "\n</table>\n";
		if ($n == 0) {
			echo "\n<p class='err'>Keine Namensnummer gefunden.</p>";
			linkgml($gkz, $gmlid, "Buchungsblatt");
		}
	}
	$j++;
}
if ($j == 0) { // Entwicklungshilfe
	echo "\n<p class='err'>Keine Buchungen gefunden.</p>";
	echo "\n<p><a target='_blank' href=alkisrelationen.php?gkz=".$gkz."&amp;gmlid=".$gmlid."&amp;style=".$style.">Beziehungen des Flurst&uuml;cks</a></p>";
	//echo "<p>".$sql."</p>"; // TEST
}
echo "\n<hr>";
footer($gkz, $gmlid, $idanzeige, $self, $hilfeurl, $style);

?>
</body>
</html>
