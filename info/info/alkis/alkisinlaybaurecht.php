<?php
/*	alkisinlaybaurecht.php - Inlay fuer Template: Baurecht
	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).

	Version:
	2011-07-26  debug
	2011-11-28  import_request_variables
	2011-12-14  function imFenster
	2013-04-08  deprecated "import_request_variables" ersetzt
	2013-06-27	hiervon neue Variante alkisbaurecht (ohne "inlay"), 
			dafür hier die Schlüssel ganz raus und Flurstücks-Verschneidung raus.
	2014-09-03 PostNAS 0.8: ohne Tab. "alkis_beziehungen", mehr "endet IS NULL", Spalten varchar statt integer
	2014-09-10 Bei Relationen den Timestamp abschneiden
	2014-09-30 Umbenennung Schlüsseltabellen (Prefix)
*/
session_start();
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
		window.open(link,'','left=30,top=30,width=680,height=800,resizable=yes,menubar=no,toolbar=no,location=no,status=no,scrollbars=yes');
	}
	</script>
	</script>
</head>
<body>

<?php
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) echo "<p class='err'>Fehler beim Verbinden der DB</p>\n";

// wie View "baurecht"
$sql ="SELECT r.ogc_fid, r.name, r.stelle, r.bezeichnung AS rechtbez, a.bezeichner  AS adfbez, d.bezeichnung AS stellbez, round(st_area(r.wkb_geometry)::numeric,0) AS flae 
FROM ax_bauraumoderbodenordnungsrecht r 
LEFT JOIN v_baurecht_adf a ON r.artderfestlegung=a.wert 
LEFT JOIN ax_dienststelle d ON r.land=d.land AND r.stelle=d.stelle WHERE r.gml_id= $1 ;";

$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);

if (!$res) {
	echo "\n<p class='err'>Fehler bei Baurecht.</p>\n";
	if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = ".$gmlid."</p>\n";}
}
echo "\n<h2><img src='ico/Gericht.ico' width='16' height='16' alt=''> Bau-, Raum- oder Bodenordnungsrecht</h2>\n";

// ToDo: ++++ Spalte anfügen, darin Link auf neue Variante alkisbaurecht.php

if ($row = pg_fetch_array($res)) {
	echo "\n<table>";

		echo "\n<tr>";
			echo "\n\t<td class='li'>Art der Festlegung:</td>\n\t<td>";
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
				echo "\n\t<td class='li'>Dienststelle:</td>\n\t<td>".$row["stellbez"];
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

echo "\n<p class='nwlink'>";
	echo "\n\t<a href='javascript:imFenster(\"alkisbaurecht.php?gkz=".$gkz."&amp;gmlid=".$gmlid."\")' ";
	echo "' title='Bau-, Raum- oder Bodenordnungsrecht'>Weitere Auskunft <img src='ico/Gericht.ico' width='16' height='16' alt=''></a>";
echo "\n</p>";

?>

</body>
</html>
