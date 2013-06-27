<?php
/*	alkisbaurecht.php - Baurecht
	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).

	Version:
	2013-06-27	Neu als Variante von alkis*inlay*baurecht.ph (mit Footer, Balken und Umschaltung Key)
*/
session_start();
$cntget = extract($_GET);
require_once("alkis_conf_location.php");
if ($auth == "mapbender") {require_once($mapbender);}
include("alkisfkt.php"); // f. Footer
if ($id == "j") {$idanzeige=true;} else {$idanzeige=false;}
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
	<title>ALKIS Bau-, Raum- oder Bodenordnungsrecht</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Gericht.ico">
</head>
<body>

<?php
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) echo "<p class='err'>Fehler beim Verbinden der DB</p>\n";

// wie View "baurecht"
$sql ="SELECT r.ogc_fid, r.artderfestlegung as adfkey, r.name, r.stelle, r.bezeichnung AS rechtbez, ";
$sql.="a.bezeichner AS adfbez, d.bezeichnung AS stellbez, d.stellenart, ";
$sql.="round(st_area(r.wkb_geometry)::numeric,0) AS flae ";
$sql.="FROM ax_bauraumoderbodenordnungsrecht r ";
$sql.="LEFT JOIN ax_bauraumoderbodenordnungsrecht_artderfestlegung a ON r.artderfestlegung = a.wert ";
$sql.="LEFT JOIN ax_dienststelle d ON r.land = d.land AND r.stelle = d.stelle ";
$sql.="WHERE r.gml_id= $1 ;";

$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);

if (!$res) {
	echo "\n<p class='err'>Fehler bei Baurecht.</p>\n";
	if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = ".$gmlid."</p>\n";}
}

if ($row = pg_fetch_array($res)) {
	$artfest=$row["adfkey"];  // Art der Festlegung, Key
	$verfnr=$row["rechtbez"]; // Verfahrens-Nummer
	$enam=$row["name"];
	$stellk=$row["stelle"]; // LEFT JOIN !
	$stellb=$row["stellbez"];
	$stella=$row["stellenart"];

	// Balken
	echo "<p class='recht'>ALKIS Bau-, Raum- oder Bodenordnungsrecht ".$artfest."-".$verfnr."&nbsp;</p>\n";

	echo "\n<h2><img src='ico/Gericht.ico' width='16' height='16' alt=''> Bau-, Raum- oder Bodenordnungsrecht</h2>\n";

	echo "\n<table>";

		echo "\n<tr>";
			echo "\n\t<td class='li'>Art der Festlegung:</td>\n\t<td>";
			if ($showkey) {
				echo "<span class='key'>(".$artfest.")</span> ";
			}
			echo "<span class='wichtig'>".$row["adfbez"]."</span></td>";
		echo "\n</tr>";

		if ($enam != "") {
			echo "\n<tr>";
				echo "\n\t<td class='li'>Eigenname des Gebietes:</td>\n\t<td>".$enam."</td>";
			echo "\n</tr>";
		}

		if ($verfnr != "") {
			echo "\n<tr>";
				echo "\n\t<td class='li'>Verfahrensnummer:</td>";
				echo "\n\t<td>".$verfnr."</td>";
				// if ($idanzeige) {linkgml($gkz, $gmlid, "Verfahren"); } // KEINE Bez.!
			echo "\n</tr>";
		}

		if ($stellb != "") { // z.B. Umlegung mit und Baulast ohne Dienststelle
			echo "\n<tr>";
				echo "\n\t<td class='li'>Dienststelle:</td>\n\t<td>";
					if ($showkey) {echo "<span class='key'>(".$stellk.")</span> ";}
					echo $stellb;
				echo "</td>";
			echo "\n</tr>";
			if ($stella != "") {
				echo "\n<tr>";
					echo "\n\t<td class='li'>Art der Dienststelle:</td>";
					echo "\n\t<td>";
						if ($showkey) {echo " <span class='key'>(".$stella.")</span>";}
						// d.stellenart -- weiter entschluesseln 1000, 1200, 1300
						// Dazu Schlüsseltabelle aus GeoInfoDok erfassen
						echo "&nbsp;"; // Platzhalter
					echo "</td>";
				echo "\n</tr>";
			}
		}

		echo "\n<tr>";
			echo "\n\t<td class='li'>Fl&auml;che:</td>";
			$flae=number_format($row["flae"],0,",",".")." m&#178;";
			echo "\n\t<td>".$flae."</td>";
		echo "\n</tr>";

	echo "\n</table>";
} else {
	echo "\n<p class='err'>Fehler! Kein Treffer bei gml_id=".$gmlid."</p>";
}

echo "\n<h2><img src='ico/Flurstueck.ico' width='16' height='16' alt=''> betroffene Flurst&uuml;cke</h2>\n";
echo "\n<p>Ermittelt durch geometrische Verschneidung. Nach Gr&ouml;&szlig;e absteigend.</p>";

$sql ="SELECT f.gml_id, f.flurnummer, f.zaehler, f.nenner, f.amtlicheflaeche, ";
$sql.="round(st_area(ST_Intersection(r.wkb_geometry,f.wkb_geometry))::numeric,1) AS schnittflae ";
$sql.="FROM ax_flurstueck f, ax_bauraumoderbodenordnungsrecht r  ";
$sql.="WHERE r.gml_id= $1 "; 
$sql.="AND st_intersects(r.wkb_geometry,f.wkb_geometry) = true ";
$sql.="AND st_area(st_intersection(r.wkb_geometry,f.wkb_geometry)) > 0.05 ";  // > 0.0 ist gemeint, Ungenauigkeit durch st_simplify
$sql.="ORDER BY schnittflae DESC ";
$sql.="LIMIT 40;"; // Limit: Flurbereinig. kann gross werden!
// Trotz Limit lange Antwortzeit, wegen OrderBy -> intersection
$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);

if (!$res) {
	echo "\n<p class='err'>Keine Flurst&uuml;cke ermittelt.<br>\nSQL=<br></p>\n";
	if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = ".$gmlid."</p>\n";}
}

echo "\n<table class='fs'>";
	echo "\n<tr>"; // Header
		echo "\n\t<td class='head' title='Flur- und Flurst&uuml;cksnummer'>Flurst&uuml;ck</td>";
		echo "\n\t<td class='head fla' title='geometrische Schnittfl&auml;che'>Fl&auml;che</td>";
		echo "\n\t<td class='head fla' title='amtliche Flurst&uuml;cksfl&auml;che, Buchfl&auml;che'>von</td>";
		echo "\n\t<td class='head nwlink' title='Link zum Flurst&uuml;ck'>weitere Auskunft</td>";
	echo "\n</tr>";

	$fscnt=0;
	while($row = pg_fetch_array($res)) {
		$fscnt++;
		echo "\n<tr>";
			echo "\n\t<td>".$row["flurnummer"]."-<span class='wichtig'>".$row["zaehler"];
			$nen=$row["nenner"];
			if ($nen != "") {
				echo "/".$nen;
			}
			echo "</span></td>";
			echo "\n\t<td class='fla'>".$row["schnittflae"]." m&#178;</td>"; 
			echo "\n\t<td class='fla'>".$row["amtlicheflaeche"]." m&#178;</td>";
			echo "\n\t<td class='nwlink noprint'>";
				echo "\n\t\t<a href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$row["gml_id"]."&amp;eig=n' " ;					echo "title='Flurst&uuml;cksnachweis'>Flurst&uuml;ck ";
					echo "\n\t\t\t<img src='ico/Flurstueck_Link.ico' width='16' height='16' alt=''>";
				echo "\n\t\t</a>";
			echo "\n\t</td>";
		echo "\n</tr>";
	}
echo "\n</table>";

if ($fscnt == 40) {
	echo "<p>... und weitere Flurst&uuml;cke (Limit 40 erreicht).</p>";
}

pg_close($con);
echo <<<END

<form action=''>
	<div class='buttonbereich noprint'>
	<hr>
		<a title="zur&uuml;ck" href='javascript:history.back()'><img src="ico/zurueck.ico" width="16" height="16" alt="zur&uuml;ck" /></a>&nbsp;
		<a title="Drucken" href='javascript:window.print()'><img src="ico/print.ico" width="16" height="16" alt="Drucken" /></a>&nbsp;
	</div>
</form>
END;

footer($gmlid, $_SERVER['PHP_SELF']."?", "");

?>

</body>
</html>
