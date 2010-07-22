<?php
/*	alkisfsnw.php
	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Flurstücksnachweis fuer ein Flurstückskennzeichen aus ALKIS PostNAS
	Parameter:	&gkz= &gmlid= &eig=j/n
	Version:
	26.01.2010	internet-Version  mit eigener conf

	ToDo: NamNum >bestehtAusRechtsverhaeltnissenZu> NamNum

*/
ini_set('error_reporting', 'E_ALL & ~ E_NOTICE');
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
	<title>ALKIS Geb&auml;udenachweis</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<style type='text/css' media='print'>
		.noprint { visibility: hidden;}
	</style>
</head>
<body>
<?php
$gkz=urldecode($_REQUEST["gkz"]);
$gmlid=urldecode($_REQUEST["gmlid"]);
$eig=urldecode($_REQUEST["eig"]);
$id = isset($_GET["id"]) ? $_GET["id"] : "n";
$idanzeige=false;
if ($id == "j") {$idanzeige=true;}
$style=isset($_GET["style"]) ? $_GET["style"] : "kompakt";
$dbname = 'alkis05' . $gkz;
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);

// Gebaeude
$sql ="SELECT f.name, f.flurnummer, f.zaehler, f.nenner, f.amtlicheflaeche, f.zeitpunktderentstehung, ";
$sql.="round(area(g.wkb_geometry)::numeric,2) as flaeche, g.description, g.bauweise, g.gebaeudefunktion, ";
$sql.="h.bauweise_id, h.bauweise_beschreibung ";
$sql.="FROM ax_flurstueck f, ax_gebaeude g LEFT JOIN ax_bauweise_gebaeude h ON g.bauweise = h.bauweise_id ";
$sql.="WHERE f.gml_id='".$gmlid."' ";
$sql.="and within(g.wkb_geometry,f.wkb_geometry) = true order by flaeche DESC;";

// echo $sql;
$res=pg_query($con,$sql);
if (!$res) echo "\n<p class='err'>Fehler bei Flurstuecksdaten\n<br>".$sql."</p>\n";
if ($row = pg_fetch_array($res)) {
	$gemkname=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
	#$gmkgnr=$row["gemarkungsnummer"];
	$flurnummer=$row["flurnummer"];
	$flstnummer=$row["zaehler"];
	$nenner=$row["nenner"];
	if ($nenner > 0) $flstnummer.="/".$nenner; // BruchNr
	$flstflaeche = $row["amtlicheflaeche"] ;
	$gesamtflaechegebaeude =  $row["flaeche"];
	$flstflaeche_minus_gesamtflaechegebaeude = 0;
	
	while($row = pg_fetch_array($res)) {
		$gesamtflaechegebaeude = $gesamtflaechegebaeude + $row["flaeche"];
	}
	$flstflaeche_minus_gesamtflaechegebaeude = number_format(($flstflaeche - $gesamtflaechegebaeude),0,",",".") . " m&#178;";
	$flstflaeche = number_format($flstflaeche,0,",",".") . " m&#178;";
	$gesamtflaechegebaeude =  number_format($gesamtflaechegebaeude,0,",",".") . " m&#178;";
	
} else {echo "Fehler! Kein Treffer fuer gml_id=".$gmlid;}
if ($eig=="j") {
	echo "<p class='fsei'>Flurst&uuml;ck ".$gmkgnr."-".$flurnummer."-".$flstnummer."&nbsp;</p>\n";
	echo "\n<h2>ALKIS Geb&auml;udenachweis</h2>\n";
}
else {
	echo "<p class='fskennz'>Flurst&uuml;ck ".$gmkgnr."-".$flurnummer."-".$flstnummer."&nbsp;</p>\n";
	echo "\n<h2>ALKIS Flurst&uuml;cksnachweis</h2>\n";
}
echo "\n<table class='outer'>\n<tr>\n<td>";

	echo "\n\t<table class='kennz' title='Flurst&uuml;ckskennzeichen'>\n\t<tr>";
		echo "\n\t\t<td class='head'>Flur</td>\n\t\t<td class='head'>Flurst-Nr.</td>\n\t</tr>";
		echo "\n\t\t<td title='Flurnummer'>".$flurnummer."</td>";
		echo "\n\t\t<td title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'>".$flstnummer."</td>\n\t</tr>";
	echo "\n\t</table>\n";
	echo "\n<p class='fsd'>Flurst&uuml;cksfl&auml;che: <b>".$flstflaeche."</b></p>\n";
	echo "\n<p class='fsd'>Flurst&uuml;cksfl&auml;che abz&uuml;glich Geb&auml;udefl&auml;che: <b>".$flstflaeche_minus_gesamtflaechegebaeude."</b></p>\n";
	echo "\n<p class='fsd'>Gesamtfl&auml;che Geb&auml;ude: <b>".$gesamtflaechegebaeude."</b></p>\n";
	
	
echo "</td>\n<td>";

echo "\n\t</td>\n</tr>\n</table>";
// Ende Seitenkopf

echo "\n<h2>Auflistung der Geb&auml;ude</h2>";

	$res=pg_query($con,$sql);
	if (!$res) echo "\n<p class='err'>Keine Geb&auml;ude.<br>\nSQL= ".$sql."</p>\n";
	$gebnr=0;
	echo "\n<hr>\n<table class='outer'>\n<tr>\n"; // link *neben* GB-Rahmen
	echo "\n\t\t<td class='head'>Lfd. Nr.</td>";
	echo "\n\t\t<td class='head'>Fl&auml;che</td>";
	echo "\n\t\t<td class='head'>Geb&auml;udefunktion</td>";
	echo "\n\t\t<td class='head'>Bauweise</td>";
	echo "\n\t\t<td class='head'>Beschreibung</td>\n\t\t</tr>";
	while($row = pg_fetch_array($res)) {
		$gebnr = $gebnr + 1;
		echo "\n\t<tr>";
		echo "\n\t\t<td title='Nr'>".$gebnr."</td>";
		echo "\n\t\t<td title='Fl&auml;che'>".$row["flaeche"]. " m&#178;". "</td>";
		echo "\n\t\t<td title='Geb&auml;udefunktion'>".$row["gebaeudefunktion"]. "</td>";
		echo "\n\t\t<td title='Bauweise'>".$row["bauweise_beschreibung"]. "</td>";
		echo "\n\t\t<td title='Beschreibung'>".$row["description"]. "</td>";
		echo "\n\t</tr>\n\t";
	}
	echo "</table>";
?>

<form action=''>
	<div class='buttonbereich noprint'>
	<hr>
		<input type='button' name='back'  value='&lt;&lt;' title='Zur&uuml;ck'  onClick='javascript:history.back()'>&nbsp;
		<input type='button' name='print' value='Druck' title='Seite Drucken' onClick='window.print()'>&nbsp;
		<input type='button' name='close' value='X' title='Fenster schlie&szlig;en' onClick='window.close()'>
	</div>
</form>

<?php footer($gkz, $gmlid, $idanzeige, $self, $hilfeurl,$style); ?>

</body>
</html>
