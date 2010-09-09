<?php
/*	alkislage.php
	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Kann die 3 Arten von Lagebezeichnung anzeigen und verbundene Objekte verlinken
	Parameter:	&gkz= &gmlid=
	Version:
		02.09.2010  Mit Icons
		06.09.2010  </a> korrigiert, Kennzeichen-Rahmenfarbe, Schluessel anschaltbar
*/
ini_set('error_reporting', 'E_ALL & ~ E_NOTICE');
session_start();
// Bindung an Mapbender-Authentifizierung
require_once("/data/mapwww/http/php/mb_validateSession.php");
require_once("/data/conf/alkis_conf.php");
include("alkisfkt.php");
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta name="author" content="Frank Jaeger" >
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ALKIS Lagebezeichnung</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Lage_mit_Haus.ico">
	<style type='text/css' media='print'>
		.noprint { visibility: hidden;}
	</style>
</head>
<body>
<?php
$gkz=urldecode($_REQUEST["gkz"]);
$gmlid=urldecode($_REQUEST["gmlid"]);
$ltyp=urldecode($_REQUEST["ltyp"]); // 3 Arten Lage-Typ
switch ($ltyp) {
	case "m": // "Mit HsNr"     = Hauptgebaeude
		$tnam = "ax_lagebezeichnungmithausnummer";
	break;
	case "p": // "mit PseudoNr" = Nebengebaeude
		$tnam = "ax_lagebezeichnungmitpseudonummer";
	break;
	case "o": //"Ohne HsNr"    = Gewanne oder Strasse
		$tnam = "ax_lagebezeichnungohnehausnummer";
	break;
	default:
		$ltyp = "m";
		$tnam = "ax_lagebezeichnungmithausnummer";
	break;
}
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
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);

// Lagebezeichnung
$sql ="SELECT s.bezeichnung AS snam, g.bezeichnung AS gnam, l.land, l.regierungsbezirk, l.kreis, l.gemeinde, l.lage, ";
switch ($ltyp) {
	case "m": // "Mit HsNr"
		$sql.="l.hausnummer ";
	break;
	case "p": // "mit PseudoNr"
		$sql.="l.pseudonummer, l.laufendenummer ";
	break;
	case "o": //"Ohne HsNr"
		$sql.="l.unverschluesselt ";
	break;
}
$sql.="FROM ".$tnam." l ";

// Gemeinde entschluesseln
$sql.="LEFT JOIN  ax_gemeinde g ";
$sql.="ON l.kreis=g.kreis AND l.gemeinde=g.gemeinde ";

// Strasse entschluesseln
$sql.="LEFT JOIN  ax_lagebezeichnungkatalogeintrag s ";
// Besonderheit: unterschiedliche Feldformate und Fuellungen!!!

switch ($ltyp) {
	case "o": //"Ohne HsNr"
		// hier beide .lage als Char(5)
		//  in ax_lagebezeichnungKatalogeintrag mit führenden Nullen
		//  in ax_lagebezeichnungOhneHausnummer jedoch ohne führende Nullen
		$sql.="ON l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND l.lage=trim(leading '0' from s.lage) ";
	break;
	default: // "Mit HsNr" + "mit PseudoNr"
		// ax_LagebezeichnungKatalogeintrag.lage   ist char,
		// ax_LagebezeichnungMitHausnummer.lage    ist integer,
		// ax_lagebezeichnungMitPseudonummer.lage  ist integer,
		$sql.="ON l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND to_char(l.lage, 'FM00000')=s.lage ";
	break;
}

$sql.="WHERE l.gml_id='".$gmlid."';";

$res=pg_query($con,$sql);
if (!$res) echo "\n<p class='err'>Fehler bei Lagebezeichnung\n<br>".$sql."</p>\n";

if ($row = pg_fetch_array($res)) {	
	$land =$row["land"];
	$regbez=$row["regierungsbezirk"];
	$kreis=$row["kreis"];
	$gem  =$row["gemeinde"];
	$gnam =$row["gnam"];
	$lage =$row["lage"]; // Strassenschluessel
	$snam =$row["snam"]; //Strassennamen
	$unver=$row["unverschluesselt"]; // Gewanne
	$kennz=$land."-".$regbez."-".$kreis."-".$gem."-".$lage."-";	

	switch ($ltyp) {
		case "m": // "Mit HsNr"
			$hsnr=$row["hausnummer"];
			$kennz.=$hsnr;
			$untertitel="Hauptgeb&auml;ude mit Hausnummer";			
			// Balken
			echo "<p class='lage'>ALKIS Lagebezeichnung mit Hausnummer ".$kennz."&nbsp;</p>\n"; // Balken
		break;
		case "p": // "mit PseudoNr"
			$pseu=$row["pseudonummer"];
			$lfd=$row["laufendenummer"];
			$kennz.=$pseu."-".$lfd;
			$untertitel="Nebengebäude mit laufender Nummer";			
			// Balken			
			echo "<p class='lage'>ALKIS Lagebezeichnung mit Pseudonummer ".$kennz."&nbsp;</p>\n"; // Balken
		break;
		case "o": //"Ohne HsNr"
			if ($lage == "") {
				$kennz=" - ".$unver;
			} else {
				$kennz.=$unver;				
			}
			// Balken			
			echo "<p class='lage'>ALKIS Lagebezeichnung Ohne Hausnummer ".$kennz."&nbsp;</p>\n"; // Balken
		break;
	}

	echo "<p class='err'>Fehler! Kein Treffer fuer gml_id=".$gmlid."</p>";
}

echo "\n<h2><img src='ico/Lage_mit_Haus.ico' width='16' height='16' alt=''> Lagebezeichnung</h2>\n";

echo "<p>Typ: ".$untertitel."</p>";

echo "\n<table class='outer'>\n<tr>\n\t<td>";
	// Tabelle Kennzeichen
	// ToDo: !! kleiner, wenn ltyp=0 und die Schluesselfelder leer sind
	echo "\n\t<table class='kennzla' title='Lage'>";
		echo "\n\t<tr>";
			echo "\n\t\t<td class='head'>Land</td>";
			echo "\n\t\t<td class='head'>Reg.-Bez.</td>";
			echo "\n\t\t<td class='head'>Kreis</td>";
			echo "\n\t\t<td class='head'>Gemeinde</td>";
			echo "\n\t\t<td class='head'>Stra&szlig;e</td>";
			switch ($ltyp) {
				case "m": // "Mit HsNr"
					echo "\n\t\t<td class='head'>Haus-Nr</td>";
				break;
				case "p": // "mit PseudoNr"
					echo "\n\t\t<td class='head'>Haus-Nr</td>";
					echo "\n\t\t<td class='head'>lfd.-Nr</td>";	
				break;
				case "o": //"Ohne HsNr"
					echo "\n\t\t<td class='head'>unverschl&uuml;sselte Lage</td>";
				break;
			}
		echo "\n\t</tr>";
		echo "\n\t<tr>";
			echo "\n\t\t<td title='Bundesland'>".$land."</td>";
			echo "\n\t\t<td title='Regierungsbezirk'>".$regbez."</td>";
			echo "\n\t\t<td title='Kreis'>".$kreis."</td>";
			echo "\n\t\t<td title='Gemeinde'>";
			if ($showkey) {
				echo "<span class='key'>".$gem."</span><br>";
			}			
			echo $gnam."</td>";
			echo "\n\t\t<td title='Stra&szlig;e'>";
			if ($showkey) {
				echo "<span class='key'>".$lage."</span><br>";
			}
			echo $snam."</td>";
			switch ($ltyp) {
				case "m":
					echo "\n\t\t<td title='Hausnummer und Zusatz'><span class='wichtig'>".$hsnr."</span></td>";
				break;
				case "p":
					echo "\n\t\t<td title='Pseudonummer - Nebengeb&auml;ude zu dieser Hausnummer'>".$pseu."</td>";
					echo "\n\t\t<td title='Laufende Nummer Nebengeb&auml;ude'><span class='wichtig'>".$lfd."</span></td>";
				break;
				case "o":
					echo "\n\t\t<td title='Gewanne'><span class='wichtig'>".$unver."</span></td>";
				break;
			}
		echo "\n\t</tr>";
	echo "\n\t</table>";

	echo "\n\t</td>\n\t<td>";

	// Kopf Rechts: weitere Daten?
	// z.B. hier Ausgabe von "georeferenzierte Gebäudeadresse" ?	
	if ($idanzeige) {linkgml($gkz, $gmlid, "Lage"); }

echo "\n\t</td>\n</tr>\n</table>";
// Ende Seitenkopf

// F L U R S T U E C K E
if ($ltyp <> "p") { // Pseudonummer linkt nur Gebäude
	echo "\n\n<a name='fs'></a><h3><img src='ico/Flurstueck.ico' width='16' height='16' alt=''> Flurst&uuml;cke</h3>\n";
	echo "\n<p>mit dieser Lagebezeichnung.</p>";
	// ax_Flurstueck  >weistAuf>  ax_LagebezeichnungMitHausnummer
	// ax_Flurstueck  >zeigtAuf>  ax_LagebezeichnungOhneHausnummer
	switch ($ltyp) {
		case "m":
			$bezart="weistAuf";
		break;
		case "o":
			$bezart="zeigtAuf";
		break;
	}
	$sql="SELECT g.gemarkungsnummer, g.bezeichnung, ";
	$sql.="f.gml_id, f.flurnummer, f.zaehler, f.nenner, f.regierungsbezirk, f.kreis, f.gemeinde, f.amtlicheflaeche ";
	$sql.="FROM ax_gemarkung g ";
	$sql.="JOIN ax_flurstueck f ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer ";
	$sql.="JOIN alkis_beziehungen v ON f.gml_id=v.beziehung_von "; 
	$sql.="WHERE v.beziehung_zu='".$gmlid."' "; // id Lage
	$sql.="AND v.beziehungsart='".$bezart."' ";
	$sql.="ORDER BY f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner;";

	$resf=pg_query($con,$sql);
	if (!$resf) {echo "<p class='err'>Fehler bei Flurst&uuml;ck<br><br>".$sql."</p>\n";}

	echo "\n<table class='fs'>";
	echo "\n<tr>"; // Kopfzeile der Tabelle
		echo "\n\t<td class='head'>Gemarkung</td>";
		echo "\n\t<td class='head'>Flur</td>";
		echo "\n\t<td class='head' title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'>Flurst.</td>";
		echo "\n\t<td class='head fla'>Fl&auml;che</td>";
		echo "\n\t<td class='head nwlink' title='Link: weitere Auskunft'>weit. Auskunft</td>";
	echo "\n</tr>";
	$j=0;
	while($rowf = pg_fetch_array($resf)) {
		if ($rowf["nenner"] != "") {$fskenn.="/".str_pad($rowf["nenner"], 3, "0", STR_PAD_LEFT);}
		$flae=number_format($rowf["amtlicheflaeche"],0,",",".") . " m&#178;";
		$flur=str_pad($rowf["flurnummer"], 3, "0", STR_PAD_LEFT);
		$fskenn=str_pad($rowf["zaehler"], 5, "0", STR_PAD_LEFT);
		echo "\n<tr>";
			if ($showkey) {
				echo "<span class='key'>".$rowf["gemarkungsnummer"]."</span> ";
			}
			echo $rowf["bezeichnung"]."</td>";
			echo "\n\t<td>".$flur."</td>";
			echo "\n\t<td><span class='wichtig'>".$fskenn."</span>";
				if ($idanzeige) {linkgml($gkz, $rowf["gml_id"], "Flurst&uuml;ck");}
			echo "</td>";
			echo "\n\t<td class='fla'>".$flae."</td>";
			echo "\n\t<td>\n\t\t<p class='nwlink noprint'>";
				echo "\n\t\t<a href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$rowf["gml_id"]."&amp;eig=n";
				if ($idanzeige) {echo "&amp;id=j";}
				if ($showkey)   {echo "&amp;showkey=j";}
				echo "' title='Flurst&uuml;cksnachweis'>Flurst&uuml;ck <img src='ico/Flurstueck_Link.ico' width='16' height='16' alt=''></a>";
			echo "\n\t\t</p>\n\t</td>";
		echo "\n</tr>";
		$j++;
	}
	echo "\n</table>";
}

// L A G E
// andere Lage mit gleicher Hausnummer suchen
if ($ltyp <> "o") { // nicht bei Gewanne (Ohne HsNr)
	echo "\n\n<a name='lage'></a><h3><img src='ico/Lage_mit_Haus.ico' width='16' height='16' alt=''> Lage</h3>\n";
	echo "\n<p>andere Lagebezeichnungen zur gleichen Hausnummer.</p>";
	$whereclaus="WHERE land='".$land."' AND regierungsbezirk='".$regbez."' AND kreis='".$kreis."' AND gemeinde='".$gem."' AND lage=".$lage." ";
	$url=$self."gkz=".$gkz."&amp;id=".$id."&amp;gmlid="; // Basis

	switch ($ltyp) {
		case "m": // aktuell Hausnummer gefunden
			// dazu alle Nebengebäude suchen
			echo "\n<p>Nebengeb&auml;ude: ";
			$sql ="SELECT l.gml_id, l.laufendenummer FROM ax_lagebezeichnungmitpseudonummer l ";
			$sql.=$whereclaus."AND lage=".$lage." AND pseudonummer='".$hsnr."' ORDER BY laufendenummer;";
		// pseudonummer character varying(5), laufendenummer character varying(2),
			$res=pg_query($con,$sql);
			if (!$res) echo "\n<p class='err'>Fehler bei Nebengeb&auml;ude.<br>".$sql."</p>\n";
			while($row = pg_fetch_array($res)) {
				echo "\n\t<a href='".$url.$row["gml_id"]."&amp;ltyp=p'>lfd.-Nr ".$row["laufendenummer"]."</a>&nbsp;&nbsp;";
			}
			echo "\n</p>";
		break;

		case "p": // aktuell Nebengebäude: Haupt- und Nebengebäude suchen
			echo "\n<p>Hauptgeb&auml;ude: ";
			$sql ="SELECT l.gml_id FROM ax_lagebezeichnungmithausnummer l ";
			$sql.=$whereclaus."AND hausnummer='".$pseu."';";
			$res=pg_query($con,$sql);
			if (!$res) echo "<p class='err'>Fehler bei Hauptgeb&auml;ude.<br>".$sql."</p>\n";
			while($row = pg_fetch_array($res)) {
				echo "\n\t<a href='".$url.$row["gml_id"]."&amp;ltyp=m'>Haus-Nr ".$pseu."</a>&nbsp;&nbsp;";
			}
			echo "\n</p>";

			echo "\n<p>weitere Nebengeb&auml;ude: ";
			$sql ="SELECT l.gml_id, l.laufendenummer FROM ax_lagebezeichnungmitpseudonummer l ";
			$sql.=$whereclaus."AND pseudonummer='".$pseu."' AND laufendenummer <> '".$lfd."' ORDER BY laufendenummer;";
			$res=pg_query($con,$sql);
			if (!$res) echo "\n<p class='err'>Fehler bei Nebengeb&auml;ude.<br>".$sql."</p>\n";
			while($row = pg_fetch_array($res)) {
				echo "\n\t<a href='".$url.$row["gml_id"]."&amp;ltyp=p'>lfd.-Nr ".$row["laufendenummer"]."</a>&nbsp;&nbsp;";
			}
			echo "\n</p>";
		break;
}

// G E B A E U D E

// Mittelfristig ist zu ueberlegen, ob hier weitere Einzelheiten dargestellt werden,
// oder ob nicht besser ein eigenes Modul alkisgebaeude.php dies uebernehmen sollte.
// Dort sollten auch diese Relationen abgebildet werden:
//  ax_gebaeude >gehoertZu> ax_gebaeude  (ringförmige Verbindung Gebäudekomplex)
//  ax_gebaeude (umschliesst) ax_bauteil
//  ax_gebaeude >gehoert> ax_person  (Ausnahme)

if ($ltyp <> "o") { // OhneHsNr linkt nur Flurst.
	echo "\n\n<a name='geb'></a><h3><img src='ico/Haus.ico' width='16' height='16' alt=''> Geb&auml;ude</h3>";
	echo "\n<p>mit dieser Lagebezeichnung.</p>";
	switch ($ltyp) {
		case "p":
			$bezart="hat";
			break;
		case "m":
			$bezart="zeigtAuf";
			break;
	}
	$sql ="SELECT g.gml_id, g.gebaeudefunktion, g.description, g.name, g.lagezurerdoberflaeche, g.bauweise, g.anzahlderoberirdischengeschosse, g.grundflaeche, g.individualname, g.zustand, ";
	$sql.="round(area(g.wkb_geometry)::numeric,2) AS flaeche, h.bauweise_beschreibung, u.bezeichner ";
	$sql.="FROM ax_gebaeude g ";
	$sql.="JOIN alkis_beziehungen v ON g.gml_id=v.beziehung_von "; 
	$sql.="LEFT JOIN ax_bauweise_gebaeude h ON g.bauweise = h.bauweise_id ";
	$sql.="LEFT JOIN ax_gebaeude_gebaeudefunktion u ON g.gebaeudefunktion = u.wert ";
	$sql.="WHERE v.beziehung_zu='".$gmlid."' ";
	$sql.="AND   v.beziehungsart='".$bezart."' ;";
	if (!$res) echo "<p class='err'>Fehler bei Gebaeude.<br>".$sql."</p>\n";
	$i=0;
	while($row = pg_fetch_array($res)) { // Only You!
		echo "<p>";
			if ($idanzeige) {linkgml($gkz, $row["gml_id"], "Geb&auml;ude");}		
		echo "</p>";
		echo "\n<table>";
			echo "\n\t<tr><td>Geometrische Fl&auml;che:</td><td>".$row["flaeche"]." m&#178;</td></tr>";			
			echo "\n\t<tr><td>Funktion:</td><td>";
			if ($showkey) {
				echo "<span class='key'>".$row["gebaeudefunktion"]."</span> ";
			}
			echo $row["bezeichner"]."</td></tr>"; // integer
			if (!$row["description"] == "") {
				echo "\n\t<tr><td>Beschreibung:</td><td>".$row["description"]."</td></tr>"; // integer - Entschlüsseln!
			}			
			if (!$row["name"] == "") {
				echo "\n\t<tr><td>Name:</td><td>".$row["name"]."</td></tr>"; // char(25)
			}
			if (!$row["lagezurerdoberflaeche"] == "") {
				echo "\n\t<tr><td>Lage zur Erdoberfl&auml;che:</td><td>".$row["lagezurerdoberflaeche"]."</td></tr>";
			} // integer - Entschlüsseln!
			if (!$row["bauweise"] == "") {
				echo "\n\t<tr><td>Bauweise:</td><td>";
				if ($showkey) {
					echo "<span class='key'>".$row["bauweise"]."</span> ";
				}
				echo $row["bauweise_beschreibung"]."</td></tr>"; // integer
			}			
			if (!$row["anzahlderoberirdischengeschosse"] == "") {
				echo "\n\t<tr><td>Anz. der oberird. Geschosse:</td><td>".$row["anzahlderoberirdischengeschosse"]."</td></tr>"; //
			}				
			if (!$row["grundflaeche"] == "") {
				echo "\n\t<tr><td>Grundfl&auml;che:</td><td>".$row["grundflaeche"]."</td></tr>"; // integer
			}
			if (!$row["individualname"] == "") {			
				echo "\n\t<tr><td>Individualname:</td><td>".$row["individualname"]."</td></tr>"; // char(7)
			}
			if (!$row["zustand"] == "") {
				echo "\n\t<tr><td>Zustand:</td><td>".$row["zustand"]."</td></tr>"; // integer
			}		
		echo "\n</table>";
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

<?php footer($gkz, $gmlid, $idanzeige, $self, $hilfeurl, "&amp;ltyp=".$ltyp , $showkey); ?>

</body>
</html>
