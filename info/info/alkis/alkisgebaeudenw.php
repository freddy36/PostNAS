<?php
/*	alkisgebaeudenw.php - Gebaeudenachweis
	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).

	Version:	22.11.2011  Feld ax_gebaeude.description ist entfallen, neue Spalte Zustand
	30.11.2011
		Fehlerkorrektur Gebaeude mit mehreren Adressen nicht mehrfach
		Sonderfall lage aus PostNAS 05 entfernt, import_request_variables
*/
session_start();
import_request_variables("G");
require_once("alkis_conf_location.php");
if ($auth == "mapbender") {require_once($mapbender);}include("alkisfkt.php");
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
	<title>ALKIS Geb&auml;udenachweis</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Haus.ico">
	<style type='text/css' media='print'>
		.noprint {visibility: hidden;}
	</style>
</head>
<body>
<?php
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) echo "<p class='err'>Fehler beim Verbinden der DB</p>\n";

// Flurstueck
$sqlf ="SELECT f.name, f.flurnummer, f.zaehler, f.nenner, f.amtlicheflaeche, f.zeitpunktderentstehung, ";
$sqlf.="g.gemarkungsnummer, g.bezeichnung ";
$sqlf.="FROM ax_flurstueck f ";
$sqlf.="LEFT JOIN ax_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer ";
$sqlf.="WHERE f.gml_id= $1;";
$v = array($gmlid);
$resf = pg_prepare("", $sqlf);
$resf = pg_execute("", $v);
if (!$resf) {
	echo "\n<p class='err'>Fehler bei Flurst&uuml;cksdaten.</p>\n";
	if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sqlf."<br>$1 = gml_id = '".$gmlid."'</p>";}
}

if ($rowf = pg_fetch_array($resf)) {
	$gemkname=htmlentities($rowf["bezeichnung"], ENT_QUOTES, "UTF-8");
	$gmkgnr=$rowf["gemarkungsnummer"];
	$flurnummer=$rowf["flurnummer"];
	$flstnummer=$rowf["zaehler"];
	$nenner=$rowf["nenner"];
	if ($nenner > 0) { // BruchNr
		$flstnummer.="/".$nenner;
	} 
	$flstflaeche = $rowf["amtlicheflaeche"] ;
} else {
	echo "<p class='err'>Fehler! Kein Treffer fuer gml_id=".$gmlid."</p>";
}

// Balkenecho "<p class='geb'>ALKIS Flurst&uuml;ck (Geb&auml;ude) ".$gmkgnr."-".$flurnummer."-".$flstnummer."&nbsp;</p>\n";

echo "\n<h2><img src='ico/Flurstueck.ico' width='16' height='16' alt=''> Flurst&uuml;ck (Geb&auml;ude)</h2>\n";

// Kennzeichen in Rahmen
echo "\n<table class='outer'>\n<tr>\n<td>";
	echo "\n\t<table class='kennzfs' title='Flurst&uuml;ckskennzeichen'>";
		echo "\n\t<tr>";
			echo "\n\t\t<td class='head'>Gmkg</td>";
			echo "\n\t\t<td class='head'>Flur</td>";
			echo "\n\t\t<td class='head'>Flurst-Nr.</td>";
		echo "\n\t</tr>";
		echo "\n\t<tr>";
			echo "\n\t\t<td title='Gemarkung'>";
			if  ($showkey) {echo "<span class='key'>".$gmkgnr."</span><br>";}
			echo $gemkname."&nbsp;</td>";
			echo "\n\t\t<td title='Flurnummer'>".$flurnummer."</td>";
			echo "\n\t\t<td title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'><span class='wichtig'>".$flstnummer."</span></td>";
		echo "\n\t</tr>";
	echo "\n\t</table>";
echo "\n</td>\n<td>";

// Links zu anderen Nachweisen
echo "\n\t<p class='nwlink noprint'>";
	echo "\n\t\t<a href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$gmlid;
	if ($idanzeige) {echo "&amp;id=j";}
	if ($showkey)   {echo "&amp;showkey=j";}	echo "&amp;eig=n' title='Flurst&uuml;cksnachweis'>Flurst&uuml;ck <img src='ico/Flurstueck_Link.ico' width='16' height='16' alt=''></a>";
echo "\n\t</p>";
if ($idanzeige) {linkgml($gkz, $gmlid, "Flurst&uuml;ck"); }
echo "\n\t</td>\n</tr>\n</table>";
// Ende Seitenkopf

echo "\n<p class='fsd'>Flurst&uuml;cksfl&auml;che: <b>".number_format($flstflaeche,0,",",".") . " m&#178;</b></p>";

echo "\n\n<h3><img src='ico/Haus.ico' width='16' height='16' alt=''> Geb&auml;ude</h3>";
echo "\n<p>.. auf oder an dem Flurst&uuml;ck. Ermittelt durch Verschneidung der Geometrie.</p>";

// G e b a e u d e
$sqlg ="SELECT g.gml_id, g.name, g.bauweise, g.gebaeudefunktion, ";
$sqlg.="h.bauweise_beschreibung, u.bezeichner, g.zustand, z.bezeichner AS bzustand, ";

// Gebaeudeflaeche komplett auch ausserhalb des FS
$sqlg.="round(area(g.wkb_geometry)::numeric,2) AS gebflae, ";

// wie viel vom GEB liegt im FS?
$sqlg.="round(st_area(ST_Intersection(g.wkb_geometry,f.wkb_geometry))::numeric,2) AS schnittflae, ";

// liegt das GEB komplett im FS?
$sqlg.="st_within(g.wkb_geometry,f.wkb_geometry) as drin ";

// FS und GEB geometrisch verschneiden
$sqlg.="FROM ax_flurstueck f, ax_gebaeude g ";

// Entschluesseln
$sqlg.="LEFT JOIN ax_gebaeude_bauweise h ON g.bauweise = h.bauweise_id ";
$sqlg.="LEFT JOIN ax_gebaeude_funktion u ON g.gebaeudefunktion = u.wert ";
$sqlg.="LEFT JOIN ax_gebaeude_zustand z ON g.zustand = z.wert ";
$sqlg.="WHERE f.gml_id= $1 "; // ID des akt. FS

// "within" liefert nur Gebaeude, die komplett im Flurstueck liegen
// "intersects" liefert ueberlappende Flaechen
$sqlg.="AND st_intersects(g.wkb_geometry,f.wkb_geometry) = true ";

// RLP: keine Relationen zu Nebengebaeuden:
// auf Qualifizierung verzichten, sonst werden Nebengebäude nicht angezeigt
	//$sqlg.="AND (v.beziehungsart='zeigtAuf' OR v.beziehungsart='hat') ";
$sqlg.="ORDER BY schnittflae DESC;";

$v = array($gmlid);
$resg = pg_prepare("", $sqlg);
$resg = pg_execute("", $v);
if (!$resg) {
	echo "\n<p class='err'>Keine Geb&auml;ude ermittelt.</p>\n";
	if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sqlg."<br>$1 = gml_id = '".$gmlid."'</p>";}
}
$gebnr=0;
echo "\n<hr>\n<table class='geb'>";
	// T-Header
	echo "\n<tr>\n";
		echo "\n\t<td class='head' title='ggf. Geb&auml;udename'>Name</td>";
		echo "\n\t<td class='head fla' title='Schnittsfl&auml;che'>Fl&auml;che</td>";
		echo "\n\t<td class='head' title='Geb&auml;udefl&auml;che'>&nbsp;</td>";
		echo "\n\t<td class='head' title='Geb&auml;udefunktion ist die zum Zeitpunkt der Erhebung vorherrschend funktionale Bedeutung des Geb&auml;udes'>Funktion</td>";
		echo "\n\t<td class='head' title='Bauweise (Schl&uuml;ssel und Beschreibung)'>Bauweise</td>";
		echo "\n\t<td class='head' title='Zustand (Schl&uuml;ssel und Beschreibung)'>Zustand</td>";		echo "\n\t<td class='head nwlink' title='Lagebezeichnung mit Stra&szlig;e und Hausnummer'>Lage</td>";
		echo "\n\t<td class='head nwlink' title='Link zu den kompletten Hausdaten'>Haus</td>";
	echo "\n</tr>";
	// T-Body
	while($rowg = pg_fetch_array($resg)) {
		$gebnr = $gebnr + 1;
// ++ ToDo:
// Die Zeilen abwechselnd verschieden einfärben 
// Angrenzend anders einfärben 

		$ggml=$rowg["gml_id"];
		$gebflsum = $gebflsum + $rowg["schnittflae"];
		$skey=$rowg["lage"]; // Strassenschluessel		
		$gnam=$rowg["name"];
		$gzus=$rowg["zustand"];
		$gzustand=$rowg["bzustand"];

		echo "\n<tr>";
			echo "\n\t<td>";
				if ($gnam != "") {echo "<span title='Geb&auml;udename'>".$gnam."</span><br>";}
			echo "\n\t</td>";

			if ($rowg["drin"] == "t") { // 3 komplett enthalten
				echo "\n\t<td class='fla'>".$rowg["schnittflae"]." m&#178;</td>"; 
				echo "\n\t<td>&nbsp;</td>";
			} else {
	       	if ($rowg["schnittflae"] == "0.00") { // angrenzend
					echo "\n\t<td class='fla'>&nbsp;</td>";
					echo "\n\t<td>angrenzend</td>";
				} else { // Teile enthalten
					echo "\n\t<td class='fla'>".$rowg["schnittflae"]." m&#178;</td>";
					echo "\n\t<td>(von ".$rowg["gebflae"]." m&#178;)</td>";
				}
			}
			echo "\n\t<td>";
			if ($showkey) {echo "<span class='key'>".$rowg["gebaeudefunktion"]."</span>&nbsp;";}
			echo $rowg["bezeichner"]."</td>";

			echo "\n\t<td>";
			if ($showkey) {echo "<span class='key'>".$rowg["bauweise"]."</span>&nbsp;";}
			echo $rowg["bauweise_beschreibung"]."&nbsp;</td>";

			echo "\n\t<td>";
			if ($showkey) {echo "<span class='key'>".$gzus."</span>&nbsp;";}
			echo $gzustand."&nbsp;</td>";

			echo "\n\t<td class='nwlink noprint'>";

			// 0 bis N Lagebezeichnungen mit Haus- oder Pseudo-Nummer, alle in ein TD zu EINEM Gebäude
			// HAUPTgebäude
			$sqll ="SELECT 'm' AS ltyp, v.beziehung_zu, s.lage, s.bezeichnung, l.hausnummer, '' AS laufendenummer ";
			$sqll.="FROM alkis_beziehungen v "; 
			$sqll.="JOIN ax_lagebezeichnungmithausnummer l ON v.beziehung_zu=l.gml_id ";
			$sqll.="JOIN ax_lagebezeichnungkatalogeintrag s ON l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND l.lage=s.lage ";
			$sqll.="WHERE v.beziehungsart = 'zeigtAuf' AND v.beziehung_von = $1 ";
			$sqll.="UNION ";
			// oder NEBENgebäude
			$sqll.="SELECT 'p' AS ltyp, v.beziehung_zu, s.lage, s.bezeichnung, l.pseudonummer AS hausnummer, l.laufendenummer ";
			$sqll.="FROM alkis_beziehungen v "; 
			$sqll.="JOIN ax_lagebezeichnungmitpseudonummer l ON v.beziehung_zu=l.gml_id ";
			$sqll.="JOIN ax_lagebezeichnungkatalogeintrag s ON l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND l.lage=s.lage ";			$sqll.="WHERE v.beziehungsart = 'hat' AND v.beziehung_von = $1 "; // ID des Hauses"
		
			$sqll.="ORDER BY bezeichnung, hausnummer ";
		
			$v = array($ggml);
			$resl = pg_prepare("", $sqll);
			$resl = pg_execute("", $v);
			if (!$resl) {
				echo "\n<p class='err'>Fehler bei Lage mit HsNr.</p>\n";
				if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sqll."<br>$1 = gml_id = '".$gmlid."'</p>";}
			}
			while($rowl = pg_fetch_array($resl)) { // LOOP: Lagezeilen
				$ltyp=$rowl["ltyp"]; // Lagezeilen-Typ
				$skey=$rowl["lage"]; // Str.-Schluessel
				$snam=htmlentities($rowl["bezeichnung"], ENT_QUOTES, "UTF-8"); // -Name
				$hsnr=$rowl["hausnummer"];
				$hlfd=$rowl["laufendenummer"];
				$gmllag=$rowl["beziehung_zu"];
				if ($ltyp == "p") {
					$lagetitl="Nebengebäude - Pseudonummer";
					$lagetxt="Nebengeb&auml;ude Nr. ".$hlfd;
				} else {
					$lagetitl="Hauptgabäude - Hausnummer";
					$lagetxt=$snam."&nbsp;".$hsnr;
				}
				echo "\n\t\t<img src='ico/Lage_mit_Haus.ico' width='16' height='16' alt=''>&nbsp;";
				if ($showkey) {echo "<span class='key'>(".$skey.")</span>&nbsp;";}			
				echo "\n\t\t<a title='".$lagetitl."' href='alkislage.php?gkz=".$gkz."&amp;gmlid=".$gmllag."&amp;ltyp=".$ltyp;
					if ($idanzeige) {echo "&amp;id=j";}
					if ($showkey)   {echo "&amp;showkey=j";}
				echo "'>".$lagetxt."</a>";
				if ($idanzeige) {linkgml($gkz, $gmllag, "Lage"); }
				echo "<br>";
			} // Ende Loop Lagezeilen m.H.

			echo "\n\t</td>";

			echo "\n\t<td class='nwlink noprint'>";
				echo "\n\t\t<a title='Daten zum Geb&auml;ude-Objekt' href='alkishaus.php?gkz=".$gkz."&amp;gmlid=".$ggml;
				if ($idanzeige) {echo "&amp;id=j";}
				if ($showkey)   {echo "&amp;showkey=j";}
				echo "'><img src='ico/Haus.ico' width='16' height='16' alt=''></a>";
			echo "\n\t</td>";

		echo "\n</tr>";
	}// Footer
	if ($gebnr == 0) {
		echo "\n</table>";
		echo "<p class='err'><br>Keine Geb&auml;ude auf diesem Flurst&uuml;ck.<br>&nbsp;</p>";
	} else {
		echo "\n<tr>";
			echo "\n\t<td>Summe:</td>"; // 1
			echo "\n\t<td class='fla sum'>".number_format($gebflsum,0,",",".")."&nbsp;&nbsp;&nbsp;&nbsp;m&#178;</td>";
			echo "\n\t<td>&nbsp;</td>"; // 3
			echo "\n\t<td>&nbsp;</td>"; // 4
			echo "\n\t<td>&nbsp;</td>"; // 5
			echo "\n\t<td>&nbsp;</td>"; // 6
			echo "\n\t<td>&nbsp;</td>"; // 7
		echo "\n</tr>";
	echo "\n</table>";
	$unbebaut = number_format(($flstflaeche - $gebflsum),0,",",".") . " m&#178;";	echo "\n<p>Flurst&uuml;cksfl&auml;che abz&uuml;glich Geb&auml;udefl&auml;che: <b>".$unbebaut."</b></p><br>";
}

?>

<form action=''>
	<div class='buttonbereich noprint'>
	<hr>
		<a title="zur&uuml;ck" href='javascript:history.back()'><img src="ico/zurueck.ico" width="16" height="16" alt="zur&uuml;ck" /></a>&nbsp;
		<a title="Drucken" href='javascript:window.print()'><img src="ico/print.ico" width="16" height="16" alt="Drucken" /></a>&nbsp;
<!--	<a title="Export als CSV" href='javascript:ALKISexport()'><img src="ico/download.ico" width="16" height="16" alt="Export" /></a>&nbsp;
		<a title="Seite schlie&szlig;en" href="javascript:window.close()"><img src="ico/close.ico" width="16" height="16" alt="Ende" /></a>	-->
	</div>
</form>

<?php footer($gmlid, $_SERVER['PHP_SELF']."?", ""); ?>

</body>
</html>
