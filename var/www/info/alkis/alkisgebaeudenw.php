<?php
/*	alkisgebaeudenw.php - Gebaeudenachweis
	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Parameter:	&gkz= &gmlid= &eig=j/n
	Version:
	27.08.2010 von WhereGroup uebernommen
	31.08.2010 Link zum FS-NW, Lage
	01.09.2010 RLP-Daten: keine Relation Nebengebaeude->LagePseudonummer
					Spalte lfd.-Nr raus wegen Verwechslungsgefhr mit lfd-Nr.-Nebengebaeuude
	02.09.2010  Mit Icons
	06.09.2010  Kennzeichen-Rahmenfarbe, Schluessel anschaltbar
*/
ini_set('error_reporting', 'E_ALL & ~ E_NOTICE');
session_start();
// Bindung an Mapbender-Authentifizierung
require_once("/data/mapwww/http/php/mb_validateSession.php");
require_once("/data/conf/alkis_www_conf.php");
#require_once(dirname(__FILE__)."/../../../../php/mb_validateSession.php");
#require_once(dirname(__FILE__)."/../../../../conf/alkis_conf.php");include("alkisfkt.php");
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta name="author" content="Frank Jaeger" >
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ALKIS Geb&auml;udenachweis</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Haus.ico">
	<style type='text/css' media='print'>
		.noprint { visibility: hidden;}
	</style>
</head>
<body>
<?php
$gkz=urldecode($_REQUEST["gkz"]);
$gmlid=urldecode($_REQUEST["gmlid"]);
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
$style=isset($_GET["style"]) ? $_GET["style"] : "kompakt";
$dbname = 'alkis05' . $gkz;
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);

// Flurstueck
$sqlf ="SELECT f.name, f.flurnummer, f.zaehler, f.nenner, f.amtlicheflaeche, f.zeitpunktderentstehung, ";
$sqlf.="g.gemarkungsnummer, g.bezeichnung ";
$sqlf.="FROM ax_flurstueck f ";
$sqlf.="JOIN ax_gemarkung  g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer ";
$sqlf.="WHERE f.gml_id='".$gmlid."';";
$resf=pg_query($con,$sqlf);
if (!$resf) echo "\n<p class='err'>Fehler bei Flurst&uuml;cksdaten\n<br>".$sqlf."</p>\n";
if ($rowf = pg_fetch_array($resf)) {
	$gemkname=htmlentities($rowf["bezeichnung"], ENT_QUOTES, "UTF-8");
	$gmkgnr=$rowf["gemarkungsnummer"];
	$flurnummer=$rowf["flurnummer"];
	$flstnummer=$rowf["zaehler"];
	$nenner=$rowf["nenner"];
	if ($nenner > 0) $flstnummer.="/".$nenner; // BruchNr
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
			if  ($shaowkey) {
				echo "<span class='key'>".$gmkgnr."</span><br>";
			}
			echo $gemkname."</td>";
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
$sqlg ="SELECT g.gml_id, g.name, g.description, g.bauweise, g.gebaeudefunktion, ";
$sqlg.=" h.bauweise_beschreibung, u.bezeichner, v.beziehungsart, v.beziehung_zu, l.hausnummer, ";

// Gebaeudeflaeche komplett auch ausserhalb des FS
$sqlg.="round(area(g.wkb_geometry)::numeric,2) AS gebflae, ";

// wie viel vom GEB liegt im FS?
$sqlg.="round(st_area(ST_Intersection(g.wkb_geometry,f.wkb_geometry))::numeric,2) AS schnittflae, ";

// liegt das GEB komplett im FS?
$sqlg.="st_within(g.wkb_geometry,f.wkb_geometry) as drin ";

// FS und GEB geometrisch verschneiden
$sqlg.="FROM ax_flurstueck f, ax_gebaeude g ";

// Entschluesseln
$sqlg.="LEFT JOIN ax_bauweise_gebaeude h ON g.bauweise = h.bauweise_id ";
$sqlg.="LEFT JOIN ax_gebaeude_gebaeudefunktion u ON g.gebaeudefunktion = u.wert ";

// Beziehungen verfolgen (holt die Hausnummer)
$sqlg.="LEFT JOIN alkis_beziehungen v ON g.gml_id=v.beziehung_von "; 
$sqlg.="LEFT JOIN ax_lagebezeichnungmithausnummer l ON v.beziehung_zu=l.gml_id ";

// auch die Nebengebaeude-Pseudo-Nummern suchen?
// $sqlg.="LEFT JOIN ax_lagebezeichnungmitpseudonummer p ON v.beziehung_zu=p.gml_id ";

// ID des aktuellen FS
$sqlg.="WHERE f.gml_id='".$gmlid."' "; 

// ALT: "within" liefert nur Gebaeude, die komplett im Flurstueck liegen
//$sqlg.="AND within(g.wkb_geometry,f.wkb_geometry) = true ";

// "intersects" liefert ueberlappende Flaechen
$sqlg.="AND st_intersects(g.wkb_geometry,f.wkb_geometry) = true ";

// RLP: keine Relationen zu Nebengebaeuden:
// auf Qualifizierung verzichten, sonst werden Nebengebäude nicht angezeigt
	//$sqlg.="AND (v.beziehungsart='zeigtAuf' OR v.beziehungsart='hat') ";

$sqlg.="ORDER BY schnittflae DESC;";

// Problem: HsNr ist linksbuedig Char:
//$sqlg.="ORDER BY hausnummer, flaeche DESC;";  

// ax_gebaeude  (zeigtAuf) ax_LagebezeichnungMitHausnummer    (Hauptgebäude)
// ax_gebaeude  (hat)      ax_LagebezeichnungMitPseudonummer  (Nebengebäude)
$resg=pg_query($con,$sqlg);
if (!$resg) {
	echo "\n<p class='err'>Keine Geb&auml;ude ermittelt.<br>\nSQL=<br></p>\n";
	echo "\n<p class='err'>".$sqlg."</p>\n";
}

$gebnr=0;
echo "\n<hr>\n<table class='geb'>";
	// Header
	echo "\n<tr>\n";
		//echo "\n\t<td class='head' title='laufende Nummer'>Lfd. Nr.</td>"; // 1
		echo "\n\t<td class='head' title='ggf. Hausnummer und/oder Geb&auml;udename'>Nr/Name</td>"; // 2
		echo "\n\t<td class='head fla' title='Schnittsfl&auml;che'>Fl&auml;che</td>"; // 3
		echo "\n\t<td class='head' title='Geb&auml;udefl&auml;che'>&nbsp;</td>";
		echo "\n\t<td class='head' title='Geb&auml;udefunktion ist die zum Zeitpunkt der Erhebung vorherrschend funktionale Bedeutung des Geb&auml;udes'>Funktion</td>";
		echo "\n\t<td class='head' title='Bauweise (Schl&uuml;ssel und Beschreibung)'>Bauweise</td>"; // 5
		echo "\n\t<td class='head nwlink' title='Typ von .. und Link zur Lagebezeichnung'>Lage</td>"; // 6
	echo "\n</tr>";
	// Body
	while($rowg = pg_fetch_array($resg)) {
		$gebnr = $gebnr + 1;
		$gebflsum = $gebflsum + $rowg["schnittflae"];		
		echo "\n<tr>";
			//echo "\n\t<td>".$gebnr."</td>"; // 1
			echo "\n\t<td>".$rowg["hausnummer"]."&nbsp;".$rowg["name"];
				if ($idanzeige) {
					linkgml($gkz, $rowg["gml_id"], "Geb&auml;ude");
				}	
			echo "</td>"; // 2
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
			if ($showkey) {
				echo "<span class='key'>".$rowg["gebaeudefunktion"]."</span>&nbsp;";
			}
			echo $rowg["bezeichner"]."</td>"; // 4
			echo "\n\t<td>";
			if ($showkey) {
				echo "<span class='key'>".$rowg["bauweise"]."</span>&nbsp;";
			}
			echo $rowg["bauweise_beschreibung"]."</td>"; // 5
			echo "\n\t<td class='nwlink noprint'>";
			$bezieh=$rowg["beziehungsart"];		
			if (!$bezieh == "" ) {
				switch ($bezieh) {
					case "hat":			// *P*seudonummer
						echo "\n\t\t<a title='Lagebezeichnung' href='alkislage.php?gkz=".$gkz."&amp;gmlid=".$rowg["beziehung_zu"]."&amp;ltyp=p'>lfd-Nr</a>";
						break;
					case "zeigtAuf":	// *M*it HausNr
						echo "\n\t\t<a title='Lagebezeichnung' href='alkislage.php?gkz=".$gkz."&amp;gmlid=".$rowg["beziehung_zu"]."&amp;ltyp=m'>Haus-Nr</a>";
						break;
					default:
						echo "<p>unbekannte Beziehungsart ".$bezieh."</p>";
						break;
				}
			}			
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
		echo "\n</tr>";
	echo "\n</table>";
	$unbebaut = number_format(($flstflaeche - $gebflsum),0,",",".") . " m&#178;";	echo "\n<p>Flurst&uuml;cksfl&auml;che abz&uuml;glich Geb&auml;udefl&auml;che: <b>".$unbebaut."</b></p>";
}

// Diese Berechnung beruht auf der Annahme, dass alle gefundenen Gebaeude vollstaendig innerhalb
// des Flurstuecks liegen. Fehler bei Gebäuden auf der Grenze.

//echo "\n<p class='err'>".$sqlg."</p>\n";

?>
<form action=''>
	<div class='buttonbereich noprint'>
	<hr>
		<input type='button' name='back'  value='&lt;&lt;' title='Zur&uuml;ck'  onClick='javascript:history.back()'>&nbsp;
		<input type='button' name='print' value='Druck' title='Seite Drucken' onClick='window.print()'>&nbsp;
		<input type='button' name='close' value='X' title='Fenster schlie&szlig;en' onClick='window.close()'>
	</div>
</form>

<?php footer($gkz, $gmlid, $idanzeige, $self, $hilfeurl, "", $showkey); ?>

</body>
</html>
