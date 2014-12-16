<?php
/*	alkisinlayausk.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Dies Programm wird in einen iFrame im Mapserver-Template (FeatureInfo) geladen.
	Parameter: &gkz, &gml_id
	Dies Programm gibt einen kurzen Ueberblick zum Flurstueck.
	Eigentuemer ohne Adresse.
	Fuer detaillierte Angaben wird zum GB- oder FS-Nachweis verlinkt.
	Dies ist eine Variante von alkisausk.php welches als vollstaendige Seite aufgerufen wird.

	Version:
	2011-11-17 Link FS-Historie, Parameter der Functions geändert
	2011-11-30 import_request_variables, $dbvers PostNAS 0.5 entfernt
	2011-12-14 "window.open(..,width=680)"
	2013-04-08 deprecated "import_request_variables" ersetzt
	2013-05-06 Fehlende Leerstelle
	2014-01-28 Link zu alkisstrasse.php
	2014-02-06 pg_free_result
	2014-09-04 PostNAS 0.8: ohne Tab. "alkis_beziehungen", mehr "endet IS NULL", Spalten varchar statt integer
	2014-09-15 Bei Relationen den Timestamp abschneiden
	2014-09-30 Umbenennung Schlüsseltabellen (Prefix), Rückbau substring(gml_id)
	2014-12-16 hr-Tag vor Eigentum entfernt

*/
session_start();
$cntget = extract($_GET);
require_once("alkis_conf_location.php");
if ($auth == "mapbender") {require_once($mapbender);}
include("alkisfkt.php");
$gmlid = isset($_GET["gmlid"]) ? $_GET["gmlid"] : 0;
echo <<<END
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta name="author" content="b600352" >
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Flurstueck.ico">
	<title>ALKIS-Auskunft</title>
	<script type="text/javascript">
	function imFenster(dieURL) {
		var link = encodeURI(dieURL);
		window.open(link,'','left=10,top=10,width=680,height=800,resizable=yes,menubar=no,toolbar=no,location=no,status=no,scrollbars=yes');
	}
	</script>
</head>
<body>
END;
$con = pg_connect("host=".$dbhost." port=".$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) {echo "<br>Fehler beim Verbinden der DB.\n<br>";}

// *** F L U R S T U E C K ***
$sql ="SELECT f.flurnummer, f.zaehler, f.nenner, f.amtlicheflaeche, g.gemarkungsnummer, g.bezeichnung 
FROM ax_flurstueck f LEFT JOIN ax_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer 
WHERE f.gml_id= $1 AND f.endet IS NULL ;";
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
	//if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}

echo "\n<h2><img src='ico/Flurstueck.ico' width='16' height='16' alt=''> Flurst&uuml;ck - &Uuml;bersicht</h2>";

echo "\n<table class='outer'>\n<tr>\n<td>";
	echo "\n\t<table class='kennzfs' title='Flurst&uuml;ckskennzeichen'>\n\t<tr>";
	echo "\n\t\t<td class='head'>Gmkg</td>\n\t\t<td class='head'>Flur</td>\n\t\t<td class='head'>Flurst-Nr.</td>\n\t</tr>";
	echo "\n\t<tr>\n\t\t<td title='Gemarkung'>".$gemkname."</td>";
	echo "\n\t\t<td title='Flurnummer'>".$flurnummer."</td>";
	echo "\n\t\t<td title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'><span class='wichtig'>".$flstnummer."</span></td>\n\t</tr>";
	echo "\n\t</table>";
echo "\n</td>\n<td>";
echo "\n\t<p class='nwlink'>weitere Auskunft:<br>";

// Flurstuecksnachweis (mit Eigentümer)
echo "\n\t\t<a href='javascript:imFenster(\"alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$gmlid."&amp;eig=j\")' ";
	echo "title='Flurst&uuml;cksnachweis'>Flurst&uuml;ck&nbsp;";
	echo "<img src='ico/Flurstueck_Link.ico' width='16' height='16' alt=''>";
echo "</a><br>";

// FS-Historie
echo "\n\t\t<a href='javascript:imFenster(\"alkisfshist.php?gkz=".$gkz."&amp;gmlid=".$gmlid."\")' ";
	echo "title='Vorg&auml;nger des Flurst&uuml;cks'>Historie&nbsp;";
	echo "<img src='ico/Flurstueck_Historisch.ico' width='16' height='16' alt=''>";
echo "</a><br>";

// Gebaeude-NW zum FS
echo "\n\t\t<a href='javascript:imFenster(\"alkisgebaeudenw.php?gkz=".$gkz."&amp;gmlid=".$gmlid."\")' ";
	echo "title='Geb&auml;udenachweis'>Geb&auml;ude&nbsp;";
	echo "<img src='ico/Haus.ico' width='16' height='16' alt=''>";
echo "</a>";

echo "\n\t</p>\n</td>";
pg_free_result($res);

// Lage MIT HausNr (Adresse)
$sql ="SELECT DISTINCT s.gml_id AS kgml, l.gml_id, s.bezeichnung, l.hausnummer 
FROM ax_flurstueck f JOIN ax_lagebezeichnungmithausnummer l ON l.gml_id=ANY(f.weistauf)
JOIN ax_lagebezeichnungkatalogeintrag s ON l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND l.lage=s.lage 
WHERE f.gml_id= $1 AND f.endet IS NULL AND l.endet IS NULL AND s.endet IS NULL 
ORDER BY s.bezeichnung, l.hausnummer;";

$v=array($gmlid); // id FS
$res=pg_prepare("", $sql);
$res=pg_execute("", $v);
if (!$res) {
	echo "<p class='err'>Fehler bei Lagebezeichnung mit Hausnummer.</p>";
	if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}
$j=0;
$kgmlalt='';
while($row = pg_fetch_array($res)) {
	$sname = htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8"); // Str.-Name
	echo "\n<tr>\n\t\n\t<td class='lr'>".$sname."&nbsp;".$row["hausnummer"]."</td>";
	echo "\n\t<td>\n\t\t<p class='nwlink noprint'>";
	$kgml=$row["kgml"]; // Wiederholung vermeiden
	if ($kgml != $kgmlalt) { // NEUE Strasse vor Lage
		$kgmlalt=$kgml; // Katalog GML-ID
		echo "\n\t\t\t<a title='Flurst&uuml;cke an der Stra&szlig;e' ";
		echo "href='javascript:imFenster(\"alkisstrasse.php?gkz=".$gkz."&amp;gmlid=".$row["kgml"]."\")'>Stra&szlig;e ";
		echo "<img src='ico/Strassen.ico' width='16' height='16' alt='STRA'></a>";
	}
		echo "\n\t\t\t<a title='Lagebezeichnung mit Hausnummer' ";
		echo "href='javascript:imFenster(\"alkislage.php?gkz=".$gkz."&amp;ltyp=m&amp;gmlid=".$row["gml_id"]."\")'>Lage ";
		echo "<img src='ico/Lage_mit_Haus.ico' width='16' height='16' alt='HAUS'></a>&nbsp;";
	echo "\n\t\t</p>\n\t</td>\n</tr>";
	$j++;
}
pg_free_result($res);
if ($j == 0) { // keine HsNr gefunden
	// Lage OHNE HausNr
	$sql ="SELECT DISTINCT s.gml_id AS kgml, l.gml_id, s.bezeichnung, l.unverschluesselt 
	FROM ax_flurstueck f JOIN ax_lagebezeichnungohnehausnummer l ON l.gml_id=ANY(f.zeigtauf)
	LEFT JOIN ax_lagebezeichnungkatalogeintrag s ON l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND l.lage=s.lage 
	WHERE f.gml_id= $1 AND f.endet IS NULL AND l.endet IS NULL AND s.endet IS NULL  
	ORDER BY s.bezeichnung;";

	$v=array($gmlid);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "<p class='err'>Fehler bei Lagebezeichnung ohne Hausnummer.</p>";
		if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
	}
	while($row = pg_fetch_array($res)) {
		$sname =htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8"); // Str.-Name
		$gewann=htmlentities($row["unverschluesselt"], ENT_QUOTES, "UTF-8");
		echo "\n<tr>";
		if ($sname != "") { // Typ=Strasse
			echo "\n\t<td class='lr' title='An Stra&szlig;e aber ohne Hausnummer'>".$sname."&nbsp;</td>";
			$ico="Lage_an_Strasse.ico";
		} else {
			echo "\n\t<td class='lr' title='Gewanne'>".$gewann."&nbsp;</td>";
			$ico="Lage_Gewanne.ico";
		}
		echo "\n\t<td>\n\t\t<p class='nwlink noprint'>";
		$kgml=$row["kgml"]; // Wiederholung vermeiden
		if ($kgml != $kgmlalt) { // NEUE Strasse vor Lage-O
			$kgmlalt=$kgml; // Katalog GML-ID
			echo "\n\t\t\t<a title='Flurst&uuml;cke an der Stra&szlig;e' ";
			echo "href='javascript:imFenster(\"alkisstrasse.php?gkz=".$gkz."&amp;gmlid=".$row["kgml"]."\")'>Stra&szlig;e ";
			echo "<img src='ico/Strassen.ico' width='16' height='16' alt='STRA'></a>";
		}
		echo "\n\t\t\t<a title='Lagebezeichnung ohne Hausnummer' ";
		echo "href='javascript:imFenster(\"alkislage.php?gkz=".$gkz."&amp;ltyp=o&amp;gmlid=".$row["gml_id"]."\")'>Lage ";
		echo "<img src='ico/".$ico."' width='16' height='16' alt='OHNE'></a>&nbsp;";
		echo "\n\t\t</p>\n\t</td>\n</tr>";
	}
	pg_free_result($res);
}
echo "\n</table>\n";

// Flurstuecksflaeche
echo "\n<p class='fsd'>Flurst&uuml;cksfl&auml;che: <b>".$flae."</b></p>\n";

// *** G R U N D B U C H ***
echo "\n<h2><img src='ico/Grundbuch_zu.ico' width='16' height='16' alt=''> Grundbuch</h2>";

// FS >istgebucht> GS >istbestandteilvon> GB.
$sql ="SELECT b.gml_id, b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung as blatt, b.blattart, 
s.gml_id AS s_gml, s.buchungsart, s.laufendenummer, s.zaehler, s.nenner, z.bezeichnung, a.bezeichner AS bart 
FROM ax_flurstueck f JOIN ax_buchungsstelle s ON f.istgebucht=s.gml_id 
JOIN ax_buchungsblatt b ON s.istbestandteilvon=b.gml_id
LEFT JOIN ax_buchungsblattbezirk z ON z.land=b.land AND z.bezirk=b.bezirk 
LEFT JOIN v_bs_buchungsart a ON s.buchungsart=a.wert 
WHERE f.gml_id= $1 AND f.endet IS NULL AND s.endet IS NULL AND b.endet IS NULL AND z.endet IS NULL 
ORDER BY b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung, s.laufendenummer;";

$v=array($gmlid);
$resg=pg_prepare("", $sql);
$resg=pg_execute("", $v);
if (!$resg) {
	echo "\n<p class='err'>Keine Buchungen.</p>\n";
	if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}
while($rowg = pg_fetch_array($resg)) {
	$beznam=$rowg["bezeichnung"];
	echo "\n<hr>\n<table class='outer'>\n<tr>\n<td>";
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
				echo $beznam."</td>";
				echo "\n\t\t<td title='Grundbuch-Blatt'><span class='wichtig'>".$rowg["blatt"]."</span></td>";
				echo "\n\t\t<td title='Bestandsverzeichnis-Nummer (BVNR, Grundst&uuml;ck)'>".$rowg["laufendenummer"]."</td>";
				echo "\n\t\t<td title='Buchungsart'>".$rowg["bart"]."</td>";
			echo "\n\t</tr>";
		echo "\n\t</table>";

		if ($rowg["zahler"] <> "") {
			echo "\n<p class='ant'>".$rowg["zahler"]."/".$rowg["nenner"]."&nbsp;Anteil am Flurst&uuml;ck</p>";
		}
		echo "\n</td>\n<td>";
		echo "\n\t<p class='nwlink'>weitere Auskunft:<br>";
			echo "\n\t\t<a href='javascript:imFenster(\"alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$rowg[0]."\")' ";
				echo "title='Grundbuchnachweis'>";
				echo $blattart;
				echo " <img src='ico/GBBlatt_link.ico' width='16' height='16' alt=''>";
			echo "</a>";
		echo "\n\t</p>";
	echo "\n</td>\n</tr>\n</table>";

	// E I G E N T U E M E R
	if ($blattkey == 5000) { // Schluessel Blattart
		echo "\n<p>Keine Angaben zum Eigentum bei fiktivem Blatt</p>\n";
		echo "\n<p>Siehe weitere Grundbuchbl&auml;tter mit Rechten an dem fiktiven Blatt.</p>\n";
	} else {// kein Eigent. bei fiktiv. Blatt
		echo "\n\n<h3><img src='ico/Eigentuemer_2.ico' width='16' height='16' alt=''> Angaben zum Eigentum</h3>\n";

		// Ausgabe Name in Function
		$n = eigentuemer($con, $rowg["gml_id"], false, "imFenster"); // ohne Adressen

		if ($n == 0) { // keine NamensNr, kein Eigentuemer
			echo "\n<p class='err'>Keine Eigent&uuml;mer gefunden.</p>";
			echo "\n<p class='err'>Bezirk ".$rowg["bezirk"]." Blatt ".$rowg["blatt"]." Blattart ".$blattkey." (".$blattart.")</p>";
			linkgml($gkz, $gmlid, "Buchungsblatt", "");
		}
	}
}
pg_free_result($resg);

?>
</body>
</html>