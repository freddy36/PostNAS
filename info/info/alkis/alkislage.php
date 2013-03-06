<?php
/*	alkislage.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Kann die 3 Arten von Lagebezeichnung anzeigen und verbundene Objekte verlinken

	Version:	2011-11-22
		Felder ax_gebaeude.description und .individualname sind entfallen
		Gebäude als Tabelle
		Link auf neues Modul "alkishaus". 
		Sonderfall PostNAS-Vers. 05 entfernt.
		Kennzeichen im Balken verkürzt.
	2011-11-30  import_request_variables
	2013-03-06  Korrektur URL des Link im Abs. Lage bei eingeschalteten Test-Optionen

	ToDo:
	- Entschluesseln Kreis usw.
	- Das Balken-Kennzeichen noch kompatibel machen mit der Eingabe der Navigation für Adresse 
*/
session_start();
import_request_variables("G");
require_once("alkis_conf_location.php");
if ($auth == "mapbender") {require_once($mapbender);}
include("alkisfkt.php");
switch ($ltyp) {
	case "m": // "Mit HsNr"     = Hauptgebaeude
		$tnam = "ax_lagebezeichnungmithausnummer"; break;
	case "p": // "mit PseudoNr" = Nebengebaeude
		$tnam = "ax_lagebezeichnungmitpseudonummer";	break;
	case "o": //"Ohne HsNr"    = Gewanne oder Strasse
		$tnam = "ax_lagebezeichnungohnehausnummer"; break;
	default:
		$ltyp = "m";
		$tnam = "ax_lagebezeichnungmithausnummer"; break;
}
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
	<title>ALKIS Lagebezeichnung</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Lage_mit_Haus.ico">
	<style type='text/css' media='print'>
		.noprint {visibility: hidden;}
	</style>
</head>
<body>
<?php
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) echo "<p class='err'>Fehler beim Verbinden der DB</p>\n";

// L a g e b e z e i c h n u n g
$sql ="SELECT s.bezeichnung AS snam, k.bezeichnung AS knam, g.bezeichnung AS gnam, l.land, l.regierungsbezirk, l.kreis, l.gemeinde, l.lage, ";
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
// Gemeinde, Kreis, Strasse entschluesseln
$sql.="LEFT JOIN ax_gemeinde g ON l.land=g.land AND l.regierungsbezirk=g.regierungsbezirk AND l.kreis=g.kreis AND l.gemeinde=g.gemeinde ";
$sql.="LEFT JOIN ax_kreisregion k ON l.land=k.land AND l.regierungsbezirk=k.regierungsbezirk AND l.kreis=k.kreis ";
$sql.="LEFT JOIN ax_lagebezeichnungkatalogeintrag s ";
// ab PostNAS 0.6: Feld "lage" char(5) mit fuehr.Nullen
$sql.="ON l.land=s.land AND l.regierungsbezirk=s.regierungsbezirk AND l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND l.lage=s.lage ";
$sql.="WHERE l.gml_id= $1;";

$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);
if (!$res) {
	echo "\n<p class='err'>Fehler bei Lagebezeichnung.</p>\n";
	if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}

if ($row = pg_fetch_array($res)) {
	$land =$row["land"];
	$regbez=$row["regierungsbezirk"];
	$kreis=$row["kreis"];
	$knam=$row["knam"];
	$gem  =$row["gemeinde"];
	$gnam =$row["gnam"];
	$lage =$row["lage"]; // Strassenschluessel
	$snam =$row["snam"]; //Strassennamen
	$unver=$row["unverschluesselt"]; // Gewanne
//	$kennz=$land."-".$regbez."-".$kreis."-".$gem."-".$lage."-";
	$kennz=$gem."-".$lage."-"; // ToDo: Kompatibel machen als Eingabe in in Navigation/Adresse 
	
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
			$untertitel="Nebengebäude mit laufender Nummer (Lagebezeichnung mit Pseudonummer)";
			echo "<p class='lage'>ALKIS Lagebezeichnung Nebengebäude ".$kennz."&nbsp;</p>\n"; // Balken
		break;
		case "o": //"Ohne HsNr"
			if ($lage == "") {
				$kennz=" - ".$unver;
			} else {
				$kennz.=$unver;			}			$untertitel="Stra&szlig;e ohne Hausnummer und/oder Gewanne (unverschl&uuml;sselte Lage)";
			echo "<p class='lage'>ALKIS Lagebezeichnung Ohne Hausnummer ".$kennz."&nbsp;</p>\n"; // Balken
		break;
	}
} else {
	echo "<p class='err'>Fehler! Kein Treffer fuer gml_id=".$gmlid."</p>";
}

echo "\n<h2><img src='ico/Lage_mit_Haus.ico' width='16' height='16' alt=''> Lagebezeichnung</h2>\n";

echo "<p>Typ: ".$untertitel."</p>";

echo "\n<table class='outer'>\n<tr>\n\t<td>"; 	// Tabelle Kennzeichen
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
			echo "\n\t\t<td title='Kreis'>";
				if ($showkey) {
						echo "<span class='key'>".$kreis."</span><br>";
				}
			echo $knam."&nbsp;</td>";
			echo "\n\t\t<td title='Gemeinde'>";
				if ($showkey) {
					echo "<span class='key'>".$gem."</span><br>";
				}
			echo $gnam."&nbsp;</td>";

			echo "\n\t\t<td title='Stra&szlig;e'>";
				if ($showkey) {
					echo "<span class='key'>".$lage."</span><br>";
				}
			if ($ltyp == "o") {
				echo "<span class='wichtig'>".$snam."</div>";
			} else {
				echo $snam;
			}	
			echo "&nbsp;</td>";

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
		case "m": $bezart="weistAuf"; break;
		case "o": $bezart="zeigtAuf"; break;
	}
	$sql="SELECT g.gemarkungsnummer, g.bezeichnung, ";
	$sql.="f.gml_id, f.flurnummer, f.zaehler, f.nenner, f.regierungsbezirk, f.kreis, f.gemeinde, f.amtlicheflaeche ";
	$sql.="FROM ax_flurstueck f ";
	$sql.="JOIN alkis_beziehungen v ON f.gml_id=v.beziehung_von "; 
	$sql.="LEFT JOIN ax_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer ";
	$sql.="WHERE v.beziehung_zu= $1 "; // id Lage
	$sql.="AND v.beziehungsart= $2 ";
	$sql.="ORDER BY f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner;";

	$v = array($gmlid,$bezart);
	$resf = pg_prepare("", $sql);
	$resf = pg_execute("", $v);
	if (!$resf) {
		echo "<p class='err'>Fehler bei Flurst&uuml;ck.</p>\n";
		if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}	
	}

	echo "\n<table class='fs'>";
	echo "\n<tr>"; // Kopfzeile der Tabelle
		echo "\n\t<td class='head'>Gemarkung</td>";
		echo "\n\t<td class='head'>Flur</td>";
		echo "\n\t<td class='head' title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'>Flurst.</td>";
		echo "\n\t<td class='head fla'>Fl&auml;che</td>";
		echo "\n\t<td class='head nwlink noprint' title='Link: weitere Auskunft'>weit. Auskunft</td>";
	echo "\n</tr>";
	$j=0;
	while($rowf = pg_fetch_array($resf)) {
		$flur=str_pad($rowf["flurnummer"], 3, "0", STR_PAD_LEFT);
		$fskenn=$rowf["zaehler"]; // Bruchnummer
		if ($rowf["nenner"] != "") {$fskenn.="/".$rowf["nenner"];}
		$flae=number_format($rowf["amtlicheflaeche"],0,",",".") . " m&#178;";
		echo "\n<tr>";			echo "\n\t<td>";
			if ($showkey) {echo "<span class='key'>".$rowf["gemarkungsnummer"]."</span> ";}
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
	$whereclaus="WHERE land= $1 AND regierungsbezirk= $2 AND kreis= $3 AND gemeinde= $4 AND lage= $5 ";

	$url=$_SERVER['PHP_SELF']."?gkz=".$gkz."&amp;id=".$id; // Basis
	if ($idanzeige) {$url.="&amp;id=j";}
	if ($showkey)   {$url.="&amp;showkey=j";}
	$url.="&amp;gmlid=";

	switch ($ltyp) {
		case "m": // aktuell Hausnummer gefunden
			// dazu alle Nebengebäude suchen
			echo "\n<p>Nebengeb&auml;ude: ";
			$sql ="SELECT l.gml_id, l.laufendenummer FROM ax_lagebezeichnungmitpseudonummer l ";
			$sql.=$whereclaus."AND lage= $6 AND pseudonummer= $7 ORDER BY laufendenummer;";
		// pseudonummer character varying(5), laufendenummer character varying(2),

			$v = array($land,$regbez,$kreis,$gem,$lage,$lage,$hsnr);
			$res = pg_prepare("", $sql);
			$res = pg_execute("", $v);
			if (!$res) {
				echo "\n<p class='err'>Fehler bei Nebengeb&auml;ude.<br>".$sql."</p>\n";
				if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."</p>";}
			}
			while($row = pg_fetch_array($res)) {
				echo "\n\t<a href='".$url.$row["gml_id"]."&amp;ltyp=p'>lfd.-Nr ".$row["laufendenummer"]."</a>&nbsp;&nbsp;";
			}
			echo "\n</p>";
		break;

		case "p": // aktuell Nebengebäude: Haupt- und Nebengebäude suchen
			echo "\n<p>Hauptgeb&auml;ude: ";
			$sql ="SELECT l.gml_id FROM ax_lagebezeichnungmithausnummer l ";
			$sql.=$whereclaus."AND hausnummer= $6;";

			$v = array($land,$regbez,$kreis,$gem,$lage,$pseu);
			$res = pg_prepare("", $sql);
			$res = pg_execute("", $v);

			if (!$res) echo "<p class='err'>Fehler bei Hauptgeb&auml;ude.<br>".$sql."</p>\n";
			while($row = pg_fetch_array($res)) {
				echo "\n\t<a href='".$url.$row["gml_id"]."&amp;ltyp=m'>Haus-Nr ".$pseu."</a>&nbsp;&nbsp;";
			}
			echo "\n</p>";

			echo "\n<p>weitere Nebengeb&auml;ude: ";
			$sql ="SELECT l.gml_id, l.laufendenummer FROM ax_lagebezeichnungmitpseudonummer l ";
			$sql.=$whereclaus."AND pseudonummer= $6 AND laufendenummer <> $7 ORDER BY laufendenummer;";
			$v = array($land,$regbez,$kreis,$gem,$lage,$pseu,$lfd);
			$res = pg_prepare("", $sql);
			$res = pg_execute("", $v);
			if (!$res) {
				echo "\n<p class='err'>Fehler bei Nebengeb&auml;ude.</p>\n";
				if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."</p>";}			
			}
			while($row = pg_fetch_array($res)) {
				echo "\n\t<a href='".$url.$row["gml_id"]."&amp;ltyp=p'>lfd.-Nr ".$row["laufendenummer"]."</a>&nbsp;&nbsp;";
			}
			echo "\n</p>";
		break;	}
}

// G E B A E U D E
if ($ltyp <> "o") { // OhneHsNr linkt nur Flurst.
	echo "\n\n<a name='geb'></a><h3><img src='ico/Haus.ico' width='16' height='16' alt=''> Geb&auml;ude</h3>";
	echo "\n<p>mit dieser Lagebezeichnung.</p>";
	switch ($ltyp) {
		case "p": $bezart="hat"; break;
		case "m": $bezart="zeigtAuf"; break;
	}
	$sql ="SELECT g.gml_id, g.gebaeudefunktion, g.name, g.bauweise, g.grundflaeche, g.zustand, ";
	$sql.="round(area(g.wkb_geometry)::numeric,2) AS flaeche, h.bauweise_beschreibung, u.bezeichner ";
	$sql.="FROM ax_gebaeude g ";
	$sql.="JOIN alkis_beziehungen v ON g.gml_id=v.beziehung_von "; 
	$sql.="LEFT JOIN ax_gebaeude_bauweise h ON g.bauweise = h.bauweise_id ";
	$sql.="LEFT JOIN ax_gebaeude_funktion u ON g.gebaeudefunktion = u.wert ";
// +++ JOIN Zustand
	$sql.="WHERE v.beziehung_zu= $1 AND v.beziehungsart= $2 ;";
	$v = array($gmlid,$bezart);
	$res = pg_prepare("", $sql);
	$res = pg_execute("", $v);
	if (!$res) {
		echo "<p class='err'>Fehler bei Gebaeude.</p>\n";
		if ($debug > 2) {echo "<p class='err'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
	}
	echo "\n<table class='geb'>";	echo "\n<tr>"; // T-Header
		echo "\n\t<td class='head' title='Geb&auml;udename'>Name</td>";
		echo "\n\t<td class='head fla' title='Fl&auml;che'>Fl&auml;che</td>";		echo "\n\t<td class='head' title='Geb&auml;udefunktion ist die zum Zeitpunkt der Erhebung vorherrschend funktionale Bedeutung des Geb&auml;udes'>Funktion</td>";
		echo "\n\t<td class='head' title='Bauweise (Schl&uuml;ssel und Beschreibung)'>Bauweise</td>";
		echo "\n\t<td class='head' title='Zustand (Schl&uuml;ssel und Beschreibung)'>Zustand</td>";
		echo "\n\t<td class='head nwlink' title='Link zu kompletten Hausdaten'>Haus</td>";
	echo "\n</tr>";
	// T-Body
	$i=0;
	while($row = pg_fetch_array($res)) {
		$ggml=$row["gml_id"];
		$gfla=$row["flaeche"];
		echo "\n\t<tr>";

			echo "<td>";
				if ($idanzeige) {linkgml($gkz, $ggml, "Geb&auml;ude");}
				// +++ Hausnummer / Adresse ???
			echo $row["name"]."</td>";
			echo "<td class='fla'>".$gfla." m&#178;</td>";
			echo "<td>";
			if ($showkey) {echo "<span class='key'>".$row["gebaeudefunktion"]."</span> ";}
			echo $row["bezeichner"]."</td>";
			echo "<td>";
				if ($showkey) {echo "<span class='key'>".$row["bauweise"]."</span> ";}
			echo $row["bauweise_beschreibung"]."</td>";

			echo "<td>".$row["zustand"]."</td>"; // +++ Entschlüsseln

			echo "\n\t<td class='nwlink noprint'>";
				echo "<a title='Hausdaten' href='alkishaus.php?gkz=".$gkz."&amp;gmlid=".$ggml;
				if ($idanzeige) {echo "&amp;id=j";}
				echo "'><img src='ico/Haus.ico' width='16' height='16' alt=''></a>";
			echo "</td>";
		echo "</tr>";
	}
	echo "\n</table>";
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

<?php footer($gmlid, $_SERVER['PHP_SELF']."?", "&amp;ltyp=".$ltyp); ?>

</body>
</html>

