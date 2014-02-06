<?php
/*	Modul: alkisnamstruk.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Namens- und Adressdaten fuer einen Eigentuemer aus ALKIS PostNAS

	Version:
	2013-04-08 deprecated "import_request_variables" ersetzt
	2013-11-22 Namensbestandteil ("von") in Kompakt-Adresse vor den Namen setzen
	2014-02-06 Redundante Adressen kommen vor. Nur eine davon anzeigen.

	ToDo: Sortierung der Grundbücher zum Namen
*/
session_start();
$cntget = extract($_GET);
require_once("alkis_conf_location.php");
if ($auth == "mapbender") {require_once($mapbender);}
include("alkisfkt.php");
if ($id == "j") {	$idanzeige=true;} else {$idanzeige=false;}
$keys = isset($_GET["showkey"]) ? $_GET["showkey"] : "n";
if ($keys == "j") {$showkey=true;} else {$showkey=false;}

?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta name="author" content="b600352" >
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ALKIS Person und Adresse</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Eigentuemer_2.ico">
	<script type="text/javascript">
		function ALKISexport() {
			window.open(<?php echo "'alkisexport.php?gkz=".$gkz."&tabtyp=person&gmlid=".$gmlid."'"; ?>);
		}
	</script>
	<style type='text/css' media='print'>
		.noprint {visibility: hidden;}
	</style>
</head>
<body>

<?php
$con = pg_connect("host=".$dbhost." port=".$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
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
	$anrk=$row["anrede"];
	$anr=anrede($anrk);
	$nbest=$row["namensbestandteil"];
	$aka=$row["akademischergrad"];

	echo "<table>\n";
		echo "\t<tr><td class='nhd'>Anrede:</td><td class='nam'>";
		if ($showkey) {echo "<span class='key' title='Anredekennung'>(".$anrk.")</span> ";}
		echo $anr."</td></tr>\n";
		echo "\t<tr><td class='nhd'>Nachname oder Firma:</td><td class='nam'>".$nam."</td></tr>\n";
		echo "\t<tr><td class='nhd'>Vorname:</td><td class='nam'>".$vor."&nbsp;</td></tr>\n";
		echo "\t<tr><td class='nhd'>Geburtsname:</td><td class='nam'>".$geb."&nbsp;</td></tr>\n";
		echo "\t<tr><td class='nhd'>Geburtsdatum:</td><td class='nam'>".$row["geburtsdatum"]."&nbsp;</td></tr>\n";
		echo "\t<tr><td class='nhd'>Namensbestandteil:</td><td class='nam'>".$nbest."&nbsp;</td></tr>\n";
		echo "\t<tr><td class='nhd'>akademischer Grad:</td><td class='nam'>".$aka."&nbsp;</td></tr>\n";
	echo "\n</table>\n<hr>\n";

	// A d r e s s e
	echo "\n<h3><img src='ico/Strasse_mit_Haus.ico' width='16' height='16' alt=''> Adresse</h3>\n";
	$sqla ="SELECT a.gml_id, a.ort_post, a.postleitzahlpostzustellung AS plz, a.strasse, a.hausnummer, a.bestimmungsland ";
	$sqla.="FROM ax_anschrift a JOIN alkis_beziehungen b ON a.gml_id=b.beziehung_zu ";
	$sqla.="WHERE b.beziehung_von= $1 AND b.beziehungsart='hat' ";
	// Es können redundante Adressen vorhanden sein, z.B. aus Migration, temporär aus LBESAS. Die letzte davon anzeigen.
	$sqla.="ORDER BY a.gml_id DESC ;";

	$v = array($gmlid);
	$resa = pg_prepare("", $sqla);
	$resa = pg_execute("", $v);
	if (!$resa) {
		echo "\n<p class='err'>Fehler bei Adressen</p>\n";
		if ($debug > 2) {	
			echo "<p class='err'>SQL=<br>".$sqla."<br>$1=gml(Person)= '".$gmlid."'</p>\n";
		}
	}

	$j=0;
	// Parameter $multiadress = j zeigt alle Adressen an
	while($rowa = pg_fetch_array($resa)) {
		$j++;
		if ($multiadress == "j" OR $j == 1) {
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

			// Name und Adresse Kompakt (im Rahmen) - Alles was man fuer ein Anschreiben braucht
			echo "<img src='ico/Namen.ico' width='16' height='16' alt='Brief' title='Anschrift'>"; // Symbol "Brief"
			echo "\n<div class='adr' title='Anschrift'>".$anr." ".$aka." ".$vor." ".$nbest." ".$nam."<br>";
			echo "\n".$str." ".$hsnr."<br>";
			echo "\n".$plz." ".$ort."</div>";
		}
	}
	pg_free_result($resa);
	if ($j == 0) {
		echo "\n<p class='err'>Keine Adressen.</p>\n";
	} elseif ($j > 1) {
		echo "\n\t\t<p class='nwlink noprint'>";
		echo "\n\t\t\t<a href='".$_SERVER['PHP_SELF']. "?gkz=".$gkz."&amp;gmlid=".$gmlid;
		if ($idanzeige) {echo "&amp;id=j";}
		if ($showkey) {echo "&amp;showkey=j";}
		if ($multiadress == "j") {
			echo "&amp;multiadress=n' title='mehrfache Adressen unterdr&uuml;cken'>erste Adresse ";
		} else {
			echo "&amp;multiadress=j' title='Adressen ggf. mehrfach vorhanden'>alle Adressen ";
		}
		echo "\n\t\t\t</a>";
		echo "\n\t\t</p>";
	}

	// *** G R U N D B U C H ***
	echo "\n<hr>\n<h3><img src='ico/Grundbuch_zu.ico' width='16' height='16' alt=''> Grundb&uuml;cher</h3>\n";
	// person <benennt< namensnummer >istBestandteilVon>                Buchungsblatt
	//                               >bestehtAusRechtsverhaeltnissenZu> namensnummer   (Nebenzweig/Sonderfälle?)

	$sqlg ="SELECT n.gml_id AS gml_n, n.laufendenummernachdin1421 AS lfd, n.zaehler, n.nenner, g.gml_id AS gml_g, ";
	$sqlg.="g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung as nr, g.blattart, b.bezeichnung AS beznam ";
	$sqlg.="FROM alkis_beziehungen bpn JOIN ax_namensnummer n ON bpn.beziehung_von=n.gml_id ";
	$sqlg.="JOIN alkis_beziehungen bng ON n.gml_id=bng.beziehung_von ";
	$sqlg.="JOIN ax_buchungsblatt g ON bng.beziehung_zu=g.gml_id ";
	$sqlg.="LEFT JOIN ax_buchungsblattbezirk b ON g.land = b.land AND g.bezirk = b.bezirk ";
	$sqlg.="WHERE bpn.beziehung_zu= $1 AND bpn.beziehungsart='benennt' AND bng.beziehungsart='istBestandteilVon' ";
	$sqlg.="ORDER BY g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung;";
	// buchungsblatt... mal mit und mal ohne fuehrende Nullen, bringt die Sortierung durcheinander

	$v = array($gmlid);
	$resg = pg_prepare("", $sqlg);
	$resg = pg_execute("", $v);

	if (!$resg) {
		echo "\n<p class='err'>Fehler bei Grundbuch</p>\n";
		if ($debug > 2) {
			echo "\n<p class='err'>SQL=".$sqlg."</p>\n";
		}
	}
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
					linkgml($gkz, $gmlg, "Grundbuchblatt");
				}
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
				echo "\n\t\t</p>";
			echo "\n\t</td>";

		echo "\n</tr>";
		// +++ >bestehtAusRechtsverhaeltnissenZu> namensnummer ?
		// z.B. eine Namennummer "Erbengemeinschaft" zeigt auf Namensnummern mit Eigentümern
		$i++;
	}
	pg_free_result($resg);
	echo "</table>";
	if ($i == 0) {echo "\n<p class='err'>Kein Grundbuch.</p>\n";}
} else {
	echo "\n\t<p class='err'>Fehler! Kein Treffer f&uuml;r\n\t<a target='_blank' href='alkisrelationen.php?gkz=".$gkz."&amp;gmlid=".$gmlid."'>".$gmlid."</a>\n</p>\n\n";
}
?>

<form action=''>
	<div class='buttonbereich noprint'>
	<hr>
		<a title="zur&uuml;ck" href='javascript:history.back()'><img src="ico/zurueck.ico" width="16" height="16" alt="zur&uuml;ck"></a>&nbsp;
		<a title="Drucken" href='javascript:window.print()'><img src="ico/print.ico" width="16" height="16" alt="Drucken"></a>&nbsp;
		<a title="Export als CSV" href='javascript:ALKISexport()'><img src="ico/download.ico" width="32" height="16" alt="Export"></a>&nbsp;
	</div>
</form>

<?php footer($gmlid, $_SERVER['PHP_SELF']."?", ""); ?>

</body>
</html>