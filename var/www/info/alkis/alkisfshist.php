<?php
/*	Modul: alkisfshist.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Flurstücks-Historie fuer ein Flurstückskennzeichen aus ALKIS PostNAS

	Version:	03.11.2011  Entwurf Prototyp

	Sinnvoller Einstieg als Erweiterung der Navigation (Suche in Flur, (auch) nach Hist-FS).
	Verknüpfung aus aktuellem FS zur Zeit mangels Verweis nicht möglich.
	Oder kann man Sinvoll in einem Array-Feld suchen?

	Um auch Vorgänger eines aktuellen Flurstücks zu finden, müssten die Array-Felder mit den Verweisen
	als echte Verbindungstabellen aufgelöst werden (als Nachprozessierung zur Konvertierung in der DB).

	Ein aktuelles FS hat keine Verweise auf Vorgänger.
	Ein historischs FS (also MIT Raumbezug) hat keine Verweise auf Vorgänger.

	+++ Eine Geometrische Vorgänger-Suche dazu realisieren? Oder besser Hist-Layer in Mapfile als Einstieg.
	
	+++ Zusätzlicher Parameter x/y (aus WMS-Feature-Info) als Geometriescher Einstieg für historische FS MIT Raumbezug
*/

function fzerleg($fs) {
/*	Flurstückskennzeichen (20) zerlegen als lesbares Format (wie im Balken):
	Dies FS-Kennz-Format wird auch als Eingabe in der Navigation akzeptiert 
   ....*....1....*....2
   ll    fff     nnnn
     gggg   zzzzz    __
*/
	$fst=rtrim($fs,"_");	
	$zer=substr ($fst, 2, 4)."-".ltrim(substr($fst, 6, 3), "0")."-".ltrim(substr($fst, 9, 5),"0");
	$nenn=ltrim(substr($fst, 14), "0");
	if ($nenn != "") {$zer.="/".$nenn;}
	return $zer; 
}

function vornach($dbarr, $gkz, $idanzeige, $showkey) {
// Datenbank-Array-Feld zeilenweise ausgeben als Selbst-Link
	if ($dbarr == "") {
		echo "&nbsp;";
	} else {
		$stri=trim($dbarr, "{}");
		$arr = split(",",$stri);
		foreach($arr AS $val){
		   echo "<a title=' zur Flurst&uuml;ck Historie' href='".$_SERVER['PHP_SELF']."?gkz=".$gkz."&amp;fskennz=".$val;
		   	if ($idanzeige) {echo "&amp;id=j";}
				if ($showkey)   {echo "&amp;showkey=j";}
			echo "'>".fzerleg($val)."</a><br>";
		}
	}
	return 0;
}

session_start();
$gkz=urldecode($_REQUEST["gkz"]);
require_once("alkis_conf_location.php");
if ($auth == "mapbender") {require_once($mapbender);}
include("alkisfkt.php");
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta name="author" content="F. Jaeger krz" >
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
$gmlid = urldecode($_REQUEST["gmlid"]);
$fskennz = urldecode($_REQUEST["fskennz"]);
$id = isset($_GET["id"]) ? $_GET["id"] : "n";
if ($id == "j") {$idanzeige=true;} else {$idanzeige=false;}
$keys = isset($_GET["showkey"]) ? $_GET["showkey"] : "n";
if ($keys == "j") {$showkey=true;} else {$showkey=false;}
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) echo "<p class='err'>Fehler beim Verbinden der DB</p>\n";
// if ($debug > 1) {echo "<p class='err'>DB=".$dbname.", user=".$dbuser."</p>";}

// Such-Parameter bekommen? Welche?
if ($gmlid != "") { // Ja, die GML wurde uebergeben
	$parmtyp="GML";
	$parmval=$gmlid;
	$whereclause="WHERE gml_id= $1 ";
	$v = array($gmlid);
} else {	// Alternativ: das Flurstücks-Kennzeichen wurde übergeben
	if ($fskennz != "") {
		$parmtyp="Flurst&uuml;ckskennzeichen";
		$parmval=$fskennz;
		$whereclause="WHERE flurstueckskennzeichen= $1 "; // hinten auffuellen mit _ auf 20 Stellen
		$v = array($fskennz);
	} else { // Pfui!
		$parmtyp="";
		echo "<p class='err'>Parameter 'gmlid' oder 'fskennz' fehlt.</p>";
		// ++ Formular ausgeben um das Flurstückskennzeichen einzugeben? 
	}
}

if ($parmtyp != "") { // einer der beiden erlaubten Fälle
	// UNION-Abfrage auf 3 ähnliche Tabellen, darin aber immr nur 1 Treffer.
	$sqlu ="SELECT 'a' AS ftyp, gml_id, flurnummer, zaehler, nenner, amtlicheflaeche, zeitpunktderentstehung, gemarkungsnummer, null AS nach, null AS vor ";
	$sqlu.="FROM ax_flurstueck f ".$whereclause;
	$sqlu.="UNION ";
	$sqlu.="SELECT 'h' AS ftyp, gml_id, flurnummer, zaehler, nenner, amtlicheflaeche, zeitpunktderentstehung, gemarkungsnummer, nachfolgerflurstueckskennzeichen AS nach, vorgaengerflurstueckskennzeichen AS vor ";
	$sqlu.="FROM ax_historischesflurstueck h ".$whereclause;
	$sqlu.="UNION ";
	$sqlu.="SELECT 'o' AS ftyp, gml_id, flurnummer, zaehler, nenner, amtlicheflaeche, zeitpunktderentstehung, gemarkungsnummer, nachfolgerflurstueckskennzeichen AS nach, vorgaengerflurstueckskennzeichen AS vor ";
	$sqlu.="FROM ax_historischesflurstueckohneraumbezug o ".$whereclause;
	
	// "name" (FF-Nummer) ist uneinheitlich nach derzeitigem Schema.
	// Hier später herein nehmen, wenn einheitlich als array in allen DBs und Tabellen definiert:
	//   f.name character varying,   o.name character varying[]
	
	$resu = pg_prepare("", $sqlu);
	$resu = pg_execute("", $v);
	if ($rowu = pg_fetch_array($resu)) {
		$ftyp=$rowu["ftyp"];
		$gmkgnr=$rowu["gemarkungsnummer"];		$flurnummer=$rowu["flurnummer"];
		$flstnummer=$rowu["zaehler"];
		$nenner=$rowu["nenner"];
		if ($nenner > 0) {$flstnummer.="/".$nenner;} // BruchNr
		$flae=number_format($rowu["amtlicheflaeche"],0,",",".") . " m&#178;";
	//	$name=$rowu["name"];
		$gemkname=$gmkgnr; // +++ JOIN auf Schluesseltabelle fehlt noch
		$entsteh=$rowu["zeitpunktderentstehung"];
		$vor=$rowu["vor"];
		$nach=$rowu["nach"];
		if ($gmlid == "") {$gmlid=$rowu["gml_id"];} // für selbst-link-Umschalter ueber footer
	} else {
		if ($debug > 1) {echo "<br><p class='err'>Fehler! Kein Treffer f&uuml;r ".$parmtyp." = '".$parmval."'</p><br>";}
		if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sqlu."<br>$1=".$parmtyp." = '".$parmval."'</p>";}
	}
}

switch ($ftyp) { // Unterschiede Historisch/Aktuell
	case 'a': 
		$wert = "aktuell";
		$ico= "Flurstueck.ico";
		$cls= "kennzfs";	
	break;
	case 'h': 
		$wert = "historisch<br>(mit Raumbezug)";
		$ico= "Flurstueck_Historisch.ico"; // ++ anderes Icon, wenn Geomtrie vorhanden?
		$cls= "kennzfsh";
	break;
	case 'o': 
		$wert = "historisch<br>ohne Raumbezug";
		$ico= "Flurstueck_Historisch.ico";
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
	// darin Tabelle Kennzeichen	echo "\n\t<table class='".$cls."' title='Flurst&uuml;ckskennzeichen'>\n\t<tr>";
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
		echo "\n\t\t<td>".$entsteh."</td>\n\t</tr>";
	//	echo "\n\t<tr>\n\t\t<td>letz. Fortf</td>";
	//	echo "\n\t\t<td title='Jahrgang / Fortf&uuml;hrungsnummer - Fortf&uuml;hrungsart'>".$name."</td>";
		echo "\n\t\t<td>&nbsp;</td><td>&nbsp;</td>"; // Leer-Zeile statt FF-Nr
		echo "\n\t</tr>";
	echo "\n\t</table>";
	if ($idanzeige) {linkgml($gkz, $gmlid, "Flurst&uuml;ck"); }
echo "\n\t</td>\n</tr>\n</table>";
echo "\n<hr>";
//echo "\n<p class='nwlink noprint'>weitere Auskunft:</p>"; // oben rechts von der Tabelle

// if ($debug > 1) {echo "<p class='err'>VOR ".$vor." NACH ".$nach."</p>";}

echo "<table class='outer'>";
	echo "\n<tr>
		<td class='head'>Flurst&uuml;ck</td>
		<td class='head'>Vorg&auml;nger</td>
		<td class='head'>Nachfolger</td>
	</tr>"; // Head
	echo "\n<tr>\n\t<td>";
	echo "<img src='ico/".$ico."' width='16' height='16' alt=''> ".$wert;
	echo "<br>Fl&auml;che <span class='flae'>".$flae."</span>";
	if ($ftyp == "a") { //Aktuell
		echo "\n<p class='nwlink noprint'>weitere Auskunft: ";
			echo "<a href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$gmlid."&amp;eig=n";
				if ($idanzeige) {echo "&amp;id=j";}
				if ($showkey)   {echo "&amp;showkey=j";}
				echo "' title='Flurst&uuml;cksnachweis'>Flurst&uuml;ck ";
				echo "<img src='ico/Flurstueck_Link.ico' width='16' height='16' alt=''>";
			echo "</a>";
	}
	echo "</td>";
	echo "\n\t<td>";
	// In ax_historischesflurstueck ist vorgaenger immer leer!
	// Man muss wohl geometrisch suchen !?
	if ($ftyp == "h" and $vor == "") {
		echo "Geometrische Suche<br>(noch nicht m&ouml;glich)";
	} else {
		vornach($vor, $gkz, $idanzeige, $showkey);
	}
	echo"</td>\n\t<td>";
	vornach($nach, $gkz, $idanzeige, $showkey);
	echo "</td>\n</tr>";
echo "\n</table>";

// TEST
if ($debug > 1) {
	$z=1;
	while($rowu = pg_fetch_array($resu)) {
		$ftyp=$rowu["ftyp"];
		echo "<p class='err'>Mehr als EIN Eintrag gefunden: '".$ftyp."' (".$z.")</p>";
		$z++;
	}
}
?>

<form action=''>
	<div class='buttonbereich noprint'>
	<hr>
		<input type='button' name='back'  value='&lt;&lt;' title='Zur&uuml;ck'  onClick='javascript:history.back()'>&nbsp;
		<input type='button' name='print' value='Druck' title='Seite Drucken' onClick='window.print()'>&nbsp;
		<input type='button' name='close' value='X' title='Fenster schlie&szlig;en' onClick='window.close()'>
	</div>
</form>

<?php footer($gkz, $gmlid, $idumschalter, $idanzeige, $_SERVER['PHP_SELF']."?", $hilfeurl, "&amp;eig=".$eig, $showkey); ?>

</body>
</html>