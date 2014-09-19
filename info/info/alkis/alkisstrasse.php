<?php
/*	alkisstrasse.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Alle Flurstücke an einer Strasse anzeigen, egal ob "mit" oder "ohne" Hausnummer
	Parameter: "gml_id" aus der Tabelle "ax_lagebezeichnungkatalogeintrag"

	Version:
	2014-01-23 Neu
	2014-01-24 CSV-Export
	2014-01-30 pg_free_result
	2014-09-03 PostNAS 0.8: ohne Tab. "alkis_beziehungen", mehr "endet IS NULL", Spalten varchar statt integer
	2014-09-15 Bei Relationen den Timestamp abschneiden
	2014-09-16 Wechsel Gem./Flur durch <b> hervorheben
*/
session_start();
$cntget = extract($_GET);
require_once("alkis_conf_location.php");
if ($auth == "mapbender") {require_once($mapbender);}
include("alkisfkt.php");

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
	<title>ALKIS Stra&szlig;e</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Strassen.ico">
	<script type="text/javascript">
		function ALKISexport() {
			window.open(<?php echo "'alkisexport.php?gkz=".$gkz."&tabtyp=strasse&gmlid=".$gmlid."'"; ?>);
		}
	</script>
	<style type='text/css' media='print'>
		.noprint {visibility: hidden;}
	</style>
</head>
<body>
<?php
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) echo "<p class='err'>Fehler beim Verbinden der DB</p>\n";

$sql ="SELECT s.land, s.regierungsbezirk, s.kreis, s.gemeinde, s.lage, s.bezeichnung AS snam, 
b.bezeichnung AS bnam, r.bezeichnung AS rnam, k.bezeichnung AS knam, g.bezeichnung AS gnam, o.gml_id AS ogml 
FROM ax_lagebezeichnungkatalogeintrag s JOIN ax_bundesland b ON s.land=b.land 
JOIN ax_regierungsbezirk r ON s.land=r.land AND s.regierungsbezirk=r.regierungsbezirk 
JOIN ax_kreisregion k ON s.land=k.land AND s.regierungsbezirk=k.regierungsbezirk AND s.kreis=k.kreis 
JOIN ax_gemeinde g ON s.land=g.land AND s.regierungsbezirk=g.regierungsbezirk AND s.kreis=g.kreis AND s.gemeinde=g.gemeinde 
LEFT JOIN ax_lagebezeichnungohnehausnummer o ON s.land=o.land AND s.regierungsbezirk=o.regierungsbezirk AND s.kreis=o.kreis AND s.gemeinde=o.gemeinde AND s.lage=o.lage 
WHERE s.gml_id= $1 AND s.endet IS NULL AND o.endet IS NULL ;"; 

$v=array($gmlid);
$res=pg_prepare("", $sql);
$res=pg_execute("", $v);
if (!$res) {
	echo "\n<p class='err'>Fehler bei Lagebezeichnungskatalogeintrag.</p>\n";
	if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}

if ($row = pg_fetch_array($res)) {
	$lage=$row["lage"]; // Strassenschluessel
	$snam=$row["snam"]; // Strassenname
	$gem=$row["gemeinde"];
	// Balken
	$kennz=$gem."-".$lage." (".$snam.")"; // Schluessel als Sucheingabe in NAV brauchbar?
	echo "<p class='strasse'>ALKIS Stra&szlig;e ".$kennz."&nbsp;</p>\n";
} else {
	echo "\n<p class='err'>Kein Treffer bei Lagebezeichnungskatalogeintrag.</p>\n";
}

echo "\n<h2><img src='ico/Strassen.ico' width='16' height='16' alt=''> Stra&szlig;e</h2>\n";

echo "\n<table class='outer'>\n<tr>\n\t<td>"; // Tabelle Kennzeichen
echo "\n\t<table class='kennzstra' title='Lage'>";
	echo "\n\t<tr>";
		echo "\n\t\t<td class='head'>Land</td>";
		echo "\n\t\t<td class='head'>Reg.-Bez.</td>";
		echo "\n\t\t<td class='head'>Kreis</td>";
		echo "\n\t\t<td class='head'>Gemeinde</td>";
		echo "\n\t\t<td class='head'>Stra&szlig;e</td>";
	echo "\n\t</tr>";
	echo "\n\t<tr>";

		echo "\n\t\t<td title='Bundesland'>";
		if ($showkey) {echo "<span class='key'>".$row["land"]."</span><br>";}
		echo $row["bnam"]."&nbsp;</td>";

		echo "\n\t\t<td title='Regierungsbezirk'>";
		if ($showkey) {echo "<span class='key'>".$row["regierungsbezirk"]."</span><br>";}
		echo $row["rnam"]."&nbsp;</td>";

		echo "\n\t\t<td title='Kreis'>";
		if ($showkey) {echo "<span class='key'>".$row["kreis"]."</span><br>";}
		echo $row["knam"]."&nbsp;</td>";

		echo "\n\t\t<td title='Gemeinde'>";
		if ($showkey) {echo "<span class='key'>".$gem."</span><br>";}
		echo $row["gnam"]."&nbsp;</td>";

		echo "\n\t\t<td title='Stra&szlig;e'>";
		if ($showkey) {echo "<span class='key'>".$lage."</span><br>";}
		echo "<span class='wichtig'>".$snam."</span>";

		echo "&nbsp;</td>";
	echo "\n\t</tr>";
echo "\n\t</table>";

echo "\n\t</td>\n\t<td>";

// Kopf Rechts:
$ogml=$row["ogml"]; // ID von "Lage Ohne HsNr"
if ($ogml != "") {
	echo "\n\t\t<p class='nwlink noprint'>";
		echo "\n\t\t<a href='alkislage.php?gkz=".$gkz."&amp;ltyp=o&amp;gmlid=".$ogml;
			if ($idanzeige) {echo "&amp;id=j";}
			if ($showkey)   {echo "&amp;showkey=j";}
		echo "' title='Lage Ohne Hausnummer'>Lage <img src='ico/Lage_an_Strasse.ico' width='16' height='16' alt=''></a>";
	echo "\n\t\t</p>";
}

echo "\n\t</td>\n</tr>\n</table>";
pg_free_result($res);
// Ende Seitenkopf

// F L U R S T U E C K E
echo "\n\n<a name='fs'></a><h3><img src='ico/Flurstueck.ico' width='16' height='16' alt=''> Flurst&uuml;cke</h3>\n";
echo "\n<p>Zusammenfassung von 'Lage mit Hausnummer' und 'Lage ohne Hausnummer' an dieser Straße</p>";

// ax_Flurstueck >weistAuf> ax_LagebezeichnungMitHausnummer  > = Hauptgebaeude 
// ax_Flurstueck >zeigtAuf> ax_LagebezeichnungOhneHausnummer > = Strasse
// Suchkriterium: gml_id aus Katalog
$subquery = "SELECT f1.gml_id AS fsgml, lm.gml_id AS lgml, lm.land, lm.regierungsbezirk, lm.kreis, lm.gemeinde, lm.lage, lm.hausnummer 
 FROM ax_flurstueck f1 JOIN ax_lagebezeichnungmithausnummer lm ON substring(lm.gml_id,1,16)=ANY(f1.weistAuf) 
 WHERE f1.endet IS NULL AND lm.endet IS NULL
UNION SELECT f2.gml_id AS fsgml, '' AS lgml, lo.land, lo.regierungsbezirk, lo.kreis, lo.gemeinde, lo.lage, '' AS hausnummer 
 FROM ax_flurstueck f2 JOIN ax_lagebezeichnungohnehausnummer lo ON substring(lo.gml_id,1,16)=ANY(f2.zeigtauf) 
 WHERE f2.endet IS NULL AND lo.endet IS NULL";

$sql="SELECT g.gemarkungsnummer, g.bezeichnung, f.gml_id, f.flurnummer, f.zaehler, f.nenner, f.amtlicheflaeche, duett.lgml, duett.hausnummer 
 FROM ax_flurstueck f JOIN ( ".$subquery." ) AS duett ON substring(f.gml_id,1,16)=duett.fsgml 
 JOIN ax_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer 
 JOIN ax_lagebezeichnungkatalogeintrag s ON duett.land=s.land AND duett.regierungsbezirk=s.regierungsbezirk AND duett.kreis=s.kreis AND duett.gemeinde=s.gemeinde AND duett.lage=s.lage 
WHERE s.gml_id = $1 AND f.endet IS NULL AND s.endet IS NULL 
ORDER BY f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner;";

$v=array($gmlid);
$resf=pg_prepare("", $sql);
$resf=pg_execute("", $v);
if (!$resf) {
	echo "<p class='err'>Fehler bei Flurst&uuml;ck.</p>\n";
	if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}	
}

echo "\n<table class='fs'>";
echo "\n<tr>"; // Kopfzeile der Tabelle
	echo "\n\t<td class='head' title='Name der Gemarkung (Ortsteil)'>Gemarkung</td>";
	echo "\n\t<td class='head' title='Flur-Nummer'>Flur</td>";
	echo "\n\t<td class='head' title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'>Flurst.</td>";
	echo "\n\t<td class='head fla' title='amtliche Fl&auml;che in Quadratmeter'>Fl&auml;che</td>";
	echo "\n\t<td class='head hsnr' title='Hausnummer aus der Lagebezeichnung des Flurst&uuml;cks'>HsNr.</td>";
	echo "\n\t<td class='head nwlink noprint' title='Link: weitere Auskunft'>weit. Auskunft</td>";
echo "\n</tr>";
$j=0;
$cnths=0; // Count Haus
$gwgmkg=""; // Gruppenwechsel
$gwflur="";

while($rowf = pg_fetch_array($resf)) {
	$gmkg=$rowf["bezeichnung"];
	$flur=str_pad($rowf["flurnummer"], 3, "0", STR_PAD_LEFT);
	$fskenn=$rowf["zaehler"]; // Bruchnummer
	if ($rowf["nenner"] != "") {$fskenn.="/".$rowf["nenner"];}
	$flae=number_format($rowf["amtlicheflaeche"],0,",",".") . " m&#178;";
	$lgml=$rowf["lgml"]; // ID von "Lage Mit" oder leer

	echo "\n<tr>";

		echo "\n\t<td>";
		if ($showkey) {echo "<span class='key'>".$rowf["gemarkungsnummer"]."</span> ";}
		if ($gwgmkg != $gmkg) {
			echo "<b>".$gmkg."</b></td>";
			$gwgmkg=$gmkg;
			$gwflur="";
		} else {
			echo $gmkg."</td>";
		}

		if ($gwflur != $flur) {
			echo "\n\t<td><b>".$flur."</b></td>";
			$gwflur=$flur;
		} else {
			echo "\n\t<td>".$flur."</td>";
		}

		echo "\n\t<td><span class='wichtig'>".$fskenn."</span>";
		if ($idanzeige) {linkgml($gkz, $rowf["gml_id"], "Flurst&uuml;ck", "ax_flurstueck");}
		echo "</td>";
		echo "\n\t<td class='fla'>".$flae."</td>";
		echo "\n\t<td class='hsnr'>".$rowf["hausnummer"]."</td>";
		echo "\n\t<td>\n\t\t<p class='nwlink noprint'>";

			if ($lgml != '') {
				echo "\n\t\t<a href='alkislage.php?gkz=".$gkz."&amp;ltyp=m&amp;gmlid=".$lgml;
				if ($idanzeige) {echo "&amp;id=j";}
				if ($showkey)   {echo "&amp;showkey=j";}
				echo "' title='Lage Mit Hausnummer'>Lage <img src='ico/Lage_mit_Haus.ico' width='16' height='16' alt=''></a>&nbsp;";
				$cnths++;
			}

			echo "\n\t\t<a href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$rowf["gml_id"]."&amp;eig=n";
			if ($idanzeige) {echo "&amp;id=j";}
			if ($showkey)   {echo "&amp;showkey=j";}
			echo "' title='Flurst&uuml;cksnachweis'>Flurst&uuml;ck <img src='ico/Flurstueck_Link.ico' width='16' height='16' alt=''></a>";

		echo "\n\t\t</p>\n\t</td>";
	echo "\n</tr>";
	$j++;
}
echo "\n</table>";
if ($j > 6) {
	echo "<p class='cnt'>".$j." Flurst&uuml;cke";
	if ($cnths > 4) {
		echo ", ".$cnths." H&auml;user";
	}
	echo "</p>";
}
pg_free_result($res);
?>

<form action=''>
	<div class='buttonbereich noprint'>
	<hr>
		<a title="zur&uuml;ck" href='javascript:history.back()'><img src="ico/zurueck.ico" width="16" height="16" alt="zur&uuml;ck"></a>&nbsp;
		<a title="Drucken" href='javascript:window.print()'><img src="ico/print.ico" width="16" height="16" alt="Drucken"></a>&nbsp;
		<a title="Export als CSV" href='javascript:ALKISexport()'><img src="ico/download.ico" width="16" height="16" alt="Export"></a>&nbsp;
	</div>
</form>

<?php footer($gmlid, $_SERVER['PHP_SELF']."?", "&amp;ltyp=".$ltyp); ?>

</body>
</html>
