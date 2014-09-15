<?php
/*	Modul: alkisfshist.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Flurstuecks-Historie fuer ein Flurstueckskennzeichen aus ALKIS PostNAS
	Version:
	2011-11-16  Zum aktuellen FS die VorgÃ¤nger suchen
	2011-11-17  Parameter der Functions geÃ¤ndert
	2011-11-30  import_request_variables
	2012-11-27  Function split deprecated: explode
	2013-04-08  deprecated "import_request_variables" ersetzt
	2014-09-15  PostNAS 0.8: ohne Tab. "alkis_beziehungen", mehr "endet IS NULL", Spalten varchar statt integer
*/

function fzerleg($fs) {
/*	Flurstueckskennzeichen (20) zerlegen als lesbares Format (wie im Balken):
	Dies FS-Kennz-Format wird auch als Eingabe in der Navigation akzeptiert 
   ....*....1....*....2
   ll    fff     nnnn
     gggg   zzzzz    __
*/
	$fst=rtrim($fs,"_");	
	$zer=substr ($fst, 2, 4)."-".ltrim(substr($fst, 6, 3), "0")."-<b>".ltrim(substr($fst, 9, 5),"0");
	$nenn=ltrim(substr($fst, 14), "0");
	if ($nenn != "") {$zer.="/".$nenn;}
	$zer.="</b>";
	return $zer; 
}

function vornach($dbarr) {
// Datenbank-Array-Feld zeilenweise ausgeben als Selbst-Link
	global $gkz, $idanzeige, $showkey;
	if ($dbarr == "") {
		echo "(keine)";
	} else {
		$stri=trim($dbarr, "{}");
		//$arr = split(",",$stri);
		$arr = explode(",",$stri);
		foreach($arr AS $val){
		   echo "Flurst&uuml;ck <a title=' zur Flurst&uuml;ck Historie' href='".$_SERVER['PHP_SELF']."?gkz=".$gkz."&amp;fskennz=".$val;
		   	if ($idanzeige) {echo "&amp;id=j";}
				if ($showkey)   {echo "&amp;showkey=j";}
			echo "'>".fzerleg($val)."</a><br>";
		}
	}
	return 0;
}

function gemkg_name($gkey) {
// Schluessel wird uebergeben, Name in DB nachschlagen
	global $con;
	$sql ="SELECT bezeichnung FROM ax_gemarkung g WHERE g.gemarkungsnummer= $1 ;";
	$v=array($gkey);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {echo "\n<p class='err'>Fehler bei Gemarkung.</p>";}
	$zgmk=0;
	while($row = pg_fetch_array($res)) { // eigentlich nur EINE
		$gmkg=$row["bezeichnung"];
		$zgmk++;
	}
	if ($zgmk == 0) {
		echo "\n<p class='err'>Gemarkung ".$gkey." ist unbekannt.</p>";
		return;
	}
	return $gmkg;
}

function such_vor_arr($fsk) {
// Suchen der Vorgaenger zum aktuellen Flurst. Ausgabe von Selbst-Links Zeilenweise in <td>.
// Akt. FS hat keine Verweise auf Vorgaenger. Darum in den Nachfolger-Verweisen von Hist.-FS suchen.
// Problem: Dies sind Arrays, die nicht performant durchsucht werden koennen.
	global $gkz, $con, $debug;

	$wherecl="WHERE $1 = ANY (nachfolgerflurstueckskennzeichen) ";

	// Bei kleinere Datenbanken keine spürbare Verzögerung bei Suche mit " = ANY(Array)"
	// Für grosse Bestände zusätzlich filtern über indizierte Felder Gemarkung + Flur?
	// Dazu die nächsten 2 Zeilen aktivieren.	
//	$wherecl.="AND gemarkungsnummer=".substr($fsk, 2, 4)." ";
//	$wherecl.="AND flurnummer=".ltrim(substr($fsk, 6, 3), "0")." ";
	// Frage: kann das bei Historisierung wechseln? (Umflurung, Umgemarkung). Dann ggf. Fehler (nicht gefunden)

	$sqlv.="SELECT 'h' AS ftyp, gml_id, flurstueckskennzeichen FROM ax_historischesflurstueck h ".$wherecl
	."UNION SELECT 'o' AS ftyp, gml_id, flurstueckskennzeichen FROM ax_historischesflurstueckohneraumbezug o ".$wherecl
	."ORDER BY flurstueckskennzeichen";

	$v=array($fsk);
	$resv = pg_prepare("", $sqlv);
	$resv = pg_execute("", $v);
	if (!$resv) {
		echo "\n<p class='err'>Fehler bei Vorg&auml;nger-FS.</p>";
		if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sqlv."<br>$1='".$fsk."'</p>";}
	}
	$zv=0;
	while($rowv = pg_fetch_array($resv)) {
		$ftyp=$rowv["ftyp"];
		$gmlv=$rowv["gml_id"];
		$vfsk=$rowv["flurstueckskennzeichen"];
		echo "Flurst&uuml;ck <a title='Historie des Vorg&auml;ngerflurst&uuml;cks' href='".$_SERVER['PHP_SELF']."?gkz=".$gkz."&amp;fskennz=".$vfsk."&amp;gmlid=".$gmlv;
	   	if ($idanzeige) {echo "&amp;id=j";}
			if ($showkey)   {echo "&amp;showkey=j";}
		echo "'>".fzerleg($vfsk)."</a><br>";
		$zv++;
	}
	if ($zv == 0) {echo "(keine)";}
	return;
}

session_start();
//import_request_variables("G"); // php 5.3 deprecated, php 5.4 entfernt
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
	<title>ALKIS Flurst&uuml;cks-Historie</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Flurstueck_Historisch.ico">
	<style type='text/css' media='print'>
		.noprint {visibility: hidden;}
	</style>
</head>
<body>
<?php
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) echo "<p class='err'>Fehler beim Verbinden der DB</p>\n";
// if ($debug > 1) {echo "<p class='err'>DB=".$dbname.", user=".$dbuser."</p>";}

// Such-Parameter bekommen? Welche?
if ($gmlid != "") { // Ja, die GML wurde uebergeben
	$parmtyp="GML";
	$parmval=$gmlid;
	$whereclause="WHERE gml_id= $1 ";
	$v = array($gmlid);
} else {	// Alternativ: Flurst.-Kennz. uebergeben
	if ($fskennz != "") {
		$parmtyp="Flurst&uuml;ckskennzeichen";
		$parmval=$fskennz;
		$whereclause="WHERE flurstueckskennzeichen= $1 "; // hinten auffuellen mit _ auf 20 Stellen
		$v = array($fskennz);
	} else { // Pfui!
		$parmtyp="";
		echo "<p class='err'>Parameter 'gmlid' oder 'fskennz' fehlt.</p>";
	}
}

if ($parmtyp != "") { // einer der beiden erlaubten Fälle
	// UNION-Abfrage auf 3ähnliche Tabellen, darin aber immer nur 1 Treffer.

	$felder="gml_id, flurnummer, zaehler, nenner, flurstueckskennzeichen, amtlicheflaeche, zeitpunktderentstehung, gemarkungsnummer, ";

	$sqlu ="SELECT 'a' AS ftyp, ".$felder."null AS nach, null AS vor, null AS \"name\" FROM ax_flurstueck f ".$whereclause." AND f.endet IS NULL "
	."UNION SELECT 'h' AS ftyp, ".$felder."nachfolgerflurstueckskennzeichen AS nach, vorgaengerflurstueckskennzeichen AS vor, name FROM ax_historischesflurstueck h ".$whereclause." AND h.endet IS NULL "
	."UNION SELECT 'o' AS ftyp, ".$felder."nachfolgerflurstueckskennzeichen AS nach, vorgaengerflurstueckskennzeichen AS vor, name FROM ax_historischesflurstueckohneraumbezug o ".$whereclause." AND o.endet IS NULL;";

	$resu = pg_prepare("", $sqlu);
	$resu = pg_execute("", $v);
	if ($rowu = pg_fetch_array($resu)) {
		$ftyp=$rowu["ftyp"];
		$gmkgnr=$rowu["gemarkungsnummer"];
		$flurnummer=$rowu["flurnummer"];
		$zaehler=$rowu["zaehler"];
		$nenner=$rowu["nenner"];
		$flstnummer=$zaehler;
		if ($nenner > 0) {$flstnummer.="/".$nenner;} // BruchNr
		$fskenn=$rowu["flurstueckskennzeichen"];
		$flae=number_format($rowu["amtlicheflaeche"],0,",",".") . " m&#178;";
		$name=$rowu["name"]; // in DB ein Array
		$arrn=explode(",", trim($name, "{}") ); // PHP-Array 
		$gemkname= gemkg_name($gmkgnr);
		$entsteh=$rowu["zeitpunktderentstehung"];
		$vor=$rowu["vor"];
		$nach=$rowu["nach"];
		if ($gmlid == "") {$gmlid=$rowu["gml_id"];} // fuer selbst-link-Umschalter ueber footer
	} else {
		if ($debug > 1) {echo "<br><p class='err'>Fehler! Kein Treffer f&uuml;r ".$parmtyp." = '".$parmval."'</p><br>";}
		if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sqlu."<br>$1=".$parmtyp." = '".$parmval."'</p>";}
	}
}

switch ($ftyp) { // Unterschiede Hist./Aktuell
	case 'a': 
		$wert = "aktuell";
		$ico= "Flurstueck.ico";
		$cls= "kennzfs";	
	break;
	case 'h': 
		$wert = "historisch<br>(mit Raumbezug)";
		$ico= "Flurstueck_Historisch.ico"; //
		$cls= "kennzfsh";
	break;
	case 'o': 
		$wert = "historisch<br>ohne Raumbezug";
		$ico= "Flurstueck_Historisch_oR.ico";
		$cls= "kennzfsh";
	break;
	default:
		$wert = "<b>nicht gefunden: ".$parmtyp." = '".$parmval."'</b>";
		$ico= "Flurstueck_Historisch.ico";
		$cls= "kennzfsh";
	break;
}

// Balken
echo "<p class='fshis'>ALKIS Flurst&uuml;ck ".$gmkgnr."-".$flurnummer."-".$flstnummer."&nbsp;</p>\n";
echo "\n<h2><img src='ico/".$ico."' width='16' height='16' alt=''> Flurst&uuml;ck Historie</h2>\n";

echo "\n<table class='outer'>\n<tr>\n\t<td>"; // linke Seite
	// darin Tabelle Kennzeichen
	echo "\n\t<table class='".$cls."' title='Flurst&uuml;ckskennzeichen'>\n\t<tr>";
		echo "\n\t\t<td class='head'>Gmkg</td>\n\t\t<td class='head'>Flur</td>\n\t\t<td class='head'>Flurst-Nr.</td>\n\t</tr>";
		echo "\n\t<tr>\n\t\t<td title='Gemarkung'>";
		if ($showkey) {echo "<span class='key'>".$gmkgnr."</span><br>";}
		echo $gemkname."&nbsp;</td>";
		echo "\n\t\t<td title='Flurnummer'>".$flurnummer."</td>";
		echo "\n\t\t<td title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'><span class='wichtig'>".$flstnummer."</span></td>\n\t</tr>";
	echo "\n\t</table>";
echo "\n\t</td>\n\t<td>"; // rechte Seite
	// FS-Daten 2 Spalten
	echo "\n\t<table class='fsd'>";
		echo "\n\t<tr>\n\t\t<td>Entstehung</td>";
			echo "\n\t\t<td>".$entsteh."</td>";
		echo "\n\t</tr>";
		echo "\n\t<tr>";
			echo "\n\t\t<td>letz. Fortf</td>";
			echo "\n\t\t<td title='Jahrgang / Fortf&uuml;hrungsnummer - Fortf&uuml;hrungsart'>";
				foreach($arrn AS $val) { // Zeile f. jedes Element
					echo trim($val, '"')."<br>";
				}
			echo "</td>";
		echo "\n\t</tr>";
	echo "\n\t</table>";
	if ($idanzeige) {linkgml($gkz, $gmlid, "Flurst&uuml;ck", "ax_flurstueck"); }
echo "\n\t</td>\n</tr>\n</table>";

if ($ftyp == "a") { // Aktuell -> Historie
	echo "\n<p class='nwlink noprint'>weitere Auskunft: ";
		echo "<a href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$gmlid."&amp;eig=n";
			if ($idanzeige) {echo "&amp;id=j";}
			if ($showkey)   {echo "&amp;showkey=j";}
			echo "' title='Flurst&uuml;cksnachweis'>Flurst&uuml;ck ";
			echo "<img src='ico/Flurstueck_Link.ico' width='16' height='16' alt=''>";
		echo "</a>";
}
echo "\n<hr>";

echo "<table class='outer'>";
	echo "\n<tr>
		<td class='head'>Flurst&uuml;ck</td>
		<td class='head'>Vorg&auml;nger</td>
		<td class='head'>Nachfolger</td>
	</tr>"; // Head
	
	// Spalte 1: F l u r s t ü c k
	echo "\n<tr>\n\t<td>";
		echo "<img src='ico/".$ico."' width='16' height='16' alt=''> ".$wert;
		echo "<br>Fl&auml;che <span class='flae'>".$flae."</span>";
	echo "</td>";

	// Spalte 2: V o r g ä n g e r
	echo "\n\t<td>";
	switch ($ftyp) { // Unterschiede Historisch/Aktuell
		case 'a':
			such_vor_arr($fskenn);
		break;
		case 'h':
			if ($vor == "") {
				echo "Geometrische Suche<br>(noch nicht m&ouml;glich)";
			} else {
				vornach($vor);
			}
		break;
		case 'o':
			vornach($vor);
		break;
	}
	echo"</td>";

	// Spalte 3: N a c h f o l g e r
	echo "\n\t<td>";
		vornach($nach);
	echo "</td>\n</tr>";
echo "\n</table>";

if ($debug > 1) {
	$z=1;
	while($rowu = pg_fetch_array($resu)) {
		$ftyp=$rowu["ftyp"];
		echo "<p class='dbg'>Mehr als EIN Eintrag gefunden: '".$ftyp."' (".$z.")</p>";
		$z++;
	}
}
?>

<form action=''>
	<div class='buttonbereich noprint'>
	<hr>
		<a title="zur&uuml;ck" href='javascript:history.back()'><img src="ico/zurueck.ico" width="16" height="16" alt="zur&uuml;ck"></a>&nbsp;
		<a title="Drucken" href='javascript:window.print()'><img src="ico/print.ico" width="16" height="16" alt="Drucken"></a>&nbsp;
	</div>
</form>

<?php footer($gmlid, $_SERVER['PHP_SELF']."?", "&amp;eig=".$eig); ?>

</body>
</html>