<?php
/*	alkisinlaybaurecht.php - Inlay fuer Template: Baurecht
	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).

	Version:
	26.07.2011  debug
	28.11.2011  import_request_variables
	14.12.2011  function imFenster
	2013-04-08  deprecated "import_request_variables" ersetzt
*/
session_start();
//import_request_variables("G"); // php 5.3 deprecated, php 5.4 entfernt
$cntget = extract($_GET);
require_once("alkis_conf_location.php");
if ($auth == "mapbender") {require_once($mapbender);}
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
	<script type="text/javascript">
	function imFenster(dieURL) {
		var link = encodeURI(dieURL);
		window.open(link,'','left=10,top=10,width=680,height=800,resizable=yes,menubar=no,toolbar=no,location=no,status=no,scrollbars=yes');
	}
	</script>
</head>
<body>

<?php
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) echo "<p class='err'>Fehler beim Verbinden der DB</p>\n";
if ($debug > 1) {echo "<p class='err'>DB=".$dbname.", user=".$dbuser."</p>";}

// wie View "baurecht"
$sql ="SELECT r.ogc_fid,  r.artderfestlegung as adfkey, r.name, r.stelle, r.bezeichnung AS rechtbez, ";
$sql.="a.bezeichner  AS adfbez, d.bezeichnung AS stellbez, d.stellenart, ";
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
echo "\n<h2><img src='ico/Gericht.ico' width='16' height='16' alt=''> Bau-, Raum- oder Bodenordnungsrecht</h2>\n";

if ($row = pg_fetch_array($res)) {
	echo "\n<table>";

		echo "\n<tr>";
			echo "\n\t<td class='li'>Art der Festlegung:</td>\n\t<td><span class='key'>(".$row["adfkey"].")</span> ";
			echo "<span class='wichtig'>".$row["adfbez"]."</span></td>";
		echo "\n</tr>";

		$enam=$row["name"];
		if ($enam != "") {
			echo "\n<tr>";
				echo "\n\t<td class='li'>Eigenname des Gebietes:</td>\n\t<td>".$enam."</td>";
			echo "\n</tr>";
		}
		echo "\n<tr>";
			echo "\n\t<td class='li'>Verfahrensnummer:</td>";
			echo "\n\t<td>".$row["rechtbez"]."</td>";
		echo "\n</tr>";

		$stell=$row["stelle"];
		if ($stell != "") {
			echo "\n<tr>";
				echo "\n\t<td class='li'>Dienststelle:</td>\n\t<td><span class='key'>(".$stell.")</span> ".$row["stellbez"];
				$stellart=$row["stellenart"];
				if ($stellart != "") {
					echo " (".$stellart.")"; // d.stellenart -- weiter entschluesseln
				}
				echo "</td>";
			echo "\n</tr>";
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
				echo "\n\t\t<a href='javascript:imFenster(\"alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$row["gml_id"]."&amp;eig=n\")' " ;					echo "title='Flurst&uuml;cksnachweis'>Flurst&uuml;ck ";
					echo "\n\t\t\t<img src='ico/Flurstueck_Link.ico' width='16' height='16' alt=''>";
				echo "\n\t\t</a>";
			echo "\n\t</td>";
		echo "\n</tr>";
	}
echo "\n</table>";

if ($fscnt == 40) {
	echo "<p>... und weitere Flurst&uuml;cke (Limit 40 erreicht).</p>";
}

?>

</body>
</html>
