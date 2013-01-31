<?php
/*	alkishaus.php - Daten zum ALKIS-Geb&auml;ude-Objekt
	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).

	Version:	2011-11-30 NEU! Variante von alkisgebaeudenw: Aufruf für EIN Haus, nicht für ein FS
	2011-01-31 ax_gebaeude.weiteregebaeudefunktion ist jetzt Array, JOIN mit any()

	ToDo:
	- sinnvolle Sortierung und Gruppierung der Felder
	- geometrische Suche nach FS, auf denen das Haus steht
	- Template im WMS auf Ebene Gebäude hierhin verknüpfen.
	- Auch diese Relationen abbilden:
		ax_gebaeude >gehoertZu> ax_gebaeude  (ringförmige Verbindung Gebäudekomplex)
		ax_gebaeude (umschliesst) ax_bauteil
		ax_gebaeude >gehoert> ax_person  (Ausnahme)*/
session_start();
import_request_variables("G");
require_once("alkis_conf_location.php");
if ($auth == "mapbender") {require_once($mapbender);}include("alkisfkt.php");
if ($id == "j") {$idanzeige=true;} else {$idanzeige=false;}
$keys = isset($_GET["showkey"]) ? $_GET["showkey"] : "n";
if ($keys == "j") {$showkey=true;} else {$showkey=false;}
if ($allfld == "j") {$allefelder=true;} else {$allefelder=false;}
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta name="author" content="b600352" >
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ALKIS Daten zum Haus</title>
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

// // G e b a e u d e 
$sqlg ="SELECT g.gml_id, g.name, g.bauweise, g.gebaeudefunktion, g.anzahlderoberirdischengeschosse AS aog, g.anzahlderunterirdischengeschosse AS aug, ";
$sqlg.="g.lagezurerdoberflaeche, g.dachgeschossausbau, g.zustand, g.weiteregebaeudefunktion, g.dachform, g.hochhaus, g.objekthoehe, g.geschossflaeche, g.grundflaeche, g.umbauterraum, g.baujahr, g.dachart, g.qualitaetsangaben, ";
$sqlg.="h.bauweise_beschreibung, u.bezeichner AS bfunk, z.bezeichner AS bzustand, ";
// "w.bezeichner AS bweitfunk, ";
$sqlg.="d.bezeichner AS bdach, round(area(g.wkb_geometry)::numeric,2) AS gebflae ";$sqlg.="FROM ax_gebaeude g ";

// Entschluesseln
$sqlg.="LEFT JOIN ax_gebaeude_bauweise h ON g.bauweise = h.bauweise_id ";
$sqlg.="LEFT JOIN ax_gebaeude_funktion u ON g.gebaeudefunktion = u.wert ";
$sqlg.="LEFT JOIN ax_gebaeude_zustand z ON g.zustand = z.wert ";
//$sqlg.="LEFT JOIN ax_gebaeude_weiterefunktion w ON g.weiteregebaeudefunktion = w.wert "; // Alt
//$sqlg.="LEFT JOIN ax_gebaeude_weiterefunktion w ON g.weiteregebaeudefunktion = any(w.wert) "; // Vorschlag 
$sqlg.="LEFT JOIN ax_gebaeude_dachform d ON g.dachform = d.wert ";

$sqlg.="WHERE g.gml_id= $1 "; // ID des Hauses

$v = array($gmlid);
$resg = pg_prepare("", $sqlg);
$resg = pg_execute("", $v);
if (!$resg) {
	echo "\n<p class='err'>Fehler bei Geb&auml;ude.</p>\n";
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sqlg."<br>$1 = gml_id = '".$gmlid."'</p>";}
}

// Balkenecho "<p class='geb'>ALKIS Haus ".$gmlid."&nbsp;</p>\n"; // +++ Kennzeichen = ?

echo "\n<h2><img src='ico/Haus.ico' width='16' height='16' alt=''> Haus (Geb&auml;ude)</h2>\n";

// Kennzeichen in Rahmen 
// - Welches Kennzeichen zum Haus ?if ($idanzeige) {linkgml($gkz, $gmlid, "Haus"); }
echo "\n<hr>";
// Umschalter: auch leere Felder ausgeben?
echo "<p class='nwlink noprint'>";
echo "<a class='nwlink' href='".$_SERVER['PHP_SELF']."?gkz=".$gkz."&amp;gmlid=".$gmlid;
	if ($showkey) {echo "&amp;showkey=j";} else {echo "&amp;showkey=n";}
	if ($idanzeige) {echo "&amp;id=j";} else {echo "&amp;id=n";}
	if ($allefelder) {echo "&amp;allfld=n'>nur Felder mit Inhalt";} 
	else {echo "&amp;allfld=j'>auch leere Felder";}
echo "</a></p>";
while($rowg = pg_fetch_array($resg)) { // Als Schleife, kann aber nur EIN Haus sein.
	$gebnr++;
	echo "\n<table class='geb'>";
	echo "\n<tr>\n";		echo "\n\t<td class='head' title=''>Attribut</td>";		echo "\n\t<td class='head' title=''>Wert</td>";
	echo "\n</tr>";

	$aog=$rowg["aog"];
	$aug=$rowg["aug"];
	$hoh=$rowg["hochhaus"];
	$nam=$rowg["name"]; // Gebaeude-Name
	$bfunk=$rowg["bfunk"];
	$baw=$rowg["bauweise"];
	$bbauw=$rowg["bauweise_beschreibung"];
	$ofl=$rowg["lagezurerdoberflaeche"];
	$dga=$rowg["dachgeschossausbau"];
	$zus=$rowg["zustand"];
	$zustand=$rowg["bzustand"];
	$wgf=$rowg["weiteregebaeudefunktion"];
	$daf=$rowg["dachform"];
//	$weitfunk=$rowg["bweitfunk"];
	$dach=$rowg["bdach"];
	$hho=$rowg["objekthoehe"];
	$gfl=$rowg["geschossflaeche"];
	$grf=$rowg["grundflaeche"];
	$ura=$rowg["umbauterraum"];
	$bja=$rowg["baujahr"];
	$daa=$rowg["dachart"];
	$qag=$rowg["qualitaetsangaben"];

	if (($nam != "") OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='\"Name\" ist der Eigenname oder die Bezeichnung des Geb&auml;udes.'>Name</td>";
			echo "\n\t<td>";
			echo $nam."</td>";
		echo "\n</tr>";
	}

	// 0 bis N Lagebezeichnungen mit Haus- oder Pseudo-Nummer
	// HAUPTgeb&auml;ude
	$sqll ="SELECT 'm' AS ltyp, v.beziehung_zu, s.lage, s.bezeichnung, l.hausnummer, '' AS laufendenummer ";
	$sqll.="FROM alkis_beziehungen v "; 
	$sqll.="JOIN ax_lagebezeichnungmithausnummer l ON v.beziehung_zu=l.gml_id ";
	$sqll.="JOIN ax_lagebezeichnungkatalogeintrag s ON l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND l.lage=s.lage ";
	$sqll.="WHERE v.beziehungsart = 'zeigtAuf' AND v.beziehung_von = $1 ";
	$sqll.="UNION ";
	// oder NEBENgeb&auml;ude
	$sqll.="SELECT 'p' AS ltyp, v.beziehung_zu, s.lage, s.bezeichnung, l.pseudonummer AS hausnummer, l.laufendenummer ";
	$sqll.="FROM alkis_beziehungen v "; 
	$sqll.="JOIN ax_lagebezeichnungmitpseudonummer l ON v.beziehung_zu=l.gml_id ";
	$sqll.="JOIN ax_lagebezeichnungkatalogeintrag s ON l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND l.lage=s.lage ";	$sqll.="WHERE v.beziehungsart = 'hat' AND v.beziehung_von = $1 "; // ID des Hauses"

	$sqll.="ORDER BY bezeichnung, hausnummer ";

	$v = array($gmlid);
	$resl = pg_prepare("", $sqll);
	$resl = pg_execute("", $v);
	if (!$resl) {
		echo "\n<p class='err'>Fehler bei Lage mit HsNr.</p>\n";
		if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sqll."<br>$1 = gml_id = '".$gmlid."'</p>";}
	}
	$zhsnr=0;
	while($rowl = pg_fetch_array($resl)) { // LOOP: Lagezeilen
		$zhsnr++;
		$ltyp=$rowl["ltyp"]; // Lagezeilen-Typ
		$skey=$rowl["lage"]; // Str.-Schluessel
		$snam=htmlentities($rowl["bezeichnung"], ENT_QUOTES, "UTF-8"); // -Name
		$hsnr=$rowl["hausnummer"];
		$hlfd=$rowl["laufendenummer"];
		$gmllag=$rowl["beziehung_zu"];

			if ($zhsnr == 1) {
				echo "\n<tr>\n\t<td title='Lage mit Hausnummer oder Pseudonummer'>Adresse</td>";
				echo "\n\t<td>";
			}
			echo "\n\t\t<img src='ico/Lage_mit_Haus.ico' width='16' height='16' alt=''>&nbsp;";
			if ($showkey) {echo "<span class='key'>(".$skey.")</span>&nbsp;";}			
			echo "\n\t\t<a title='Hausnummer' href='alkislage.php?gkz=".$gkz."&amp;gmlid=".$gmllag."&amp;ltyp=".$ltyp;
				if ($idanzeige) {echo "&amp;id=j";}
			echo "'>";
				echo $snam."&nbsp;".$hsnr;
				if ($ltyp == "p") { echo ", lfd.Nr ".$hlfd;}
			echo "</a>";
			if ($idanzeige) {linkgml($gkz, $gmllag, "Lage"); }
			echo "<br>";
	} // Ende Loop Lagezeilen m.H.

	if ($zhsnr > 0) {
		echo "\n\t</td>\n</tr>";
	}

		echo "\n<tr>";
			echo "\n\t<td title='\"Geb&auml;udefunktion\" ist die zum Zeitpunkt der Erhebung vorherrschend funktionale Bedeutung des Geb&auml;udes'>Funktion</td>";
			echo "\n\t<td>";
			if ($showkey) {echo "<span class='key'>".$rowg["gebaeudefunktion"]."</span>&nbsp;";}
			echo $bfunk."</td>";
		echo "\n</tr>";

	if ($baw != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='\"Bauweise\" ist die Beschreibung der Art der Bauweise.'>Bauweise</td>";
			echo "\n\t<td>";
			if ($showkey) {echo "<span class='key'>".$baw."</span>&nbsp;";}
			echo $bbauw."</td>";
		echo "\n</tr>";
	}

	if ($aog != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='Anzahl oberirdischer Geschosse'>Geschosse</td>";
			echo "\n\t<td>".$aog."</td>";		echo "\n</tr>";
	}

	if ($aug != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='Anzahl unterirdischer Geschosse'>U-Geschosse</td>";
			echo "\n\t<td>".$aug."</td>";		echo "\n</tr>";
	}

	if ($hoh != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='\"Hochhaus\" ist ein Geb&auml;ude, das nach Geb&auml;udeh&ouml;he und Auspr&auml;gung als Hochhaus zu bezeichnen ist. F&uuml;r Geb&auml;ude im Geschossbau gilt dieses i.d.R. ab 8 oberirdischen Geschossen, f&uuml;r andere Geb&auml;ude ab einer Geb&auml;udeh&ouml;he von 22 m.'>Hochhaus</td>";
			echo "\n\t<td>".$hoh."</td>";		echo "\n</tr>";
	}

	if ($ofl != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='\"Lage zur Erdoberfl&auml;che\" ist die Angabe der relativen Lage des Geb&auml;udes zur Erdoberfl&auml;che. Diese Attributart wird nur bei nicht ebenerdigen Geb&auml;uden gef&uuml;hrt.'>Lage zur Erdoberfl&auml;che</td>";
			echo "\n\t<td>";
			if ($showkey) {echo "<span class='key'>".$ofl."</span>&nbsp;";}
			switch ($ofl) {
				case 1200: echo "Unter der Erdoberfl&auml;che"; break;
				// "Unter der Erdoberfl&auml;che" bedeutet, dass sich das Geb&auml;ude unter der Erdoberfl&auml;che befindet
				case 1400: echo "Aufgest&auml;ndert"; break;
				// "Aufgest&auml;ndert" bedeutet, dass ein Geb&auml;ude auf St&uuml;tzen steht
				case "": echo "&nbsp;"; break;				default: echo "** Unbekannte Lage zur Erdoberfl&auml;che '".$ofl."' **"; break;
			}
			echo "&nbsp;</td>";
		echo "\n</tr>";
	}

	if ($dga != "" OR $allefelder) { // keine Schluesseltabelle in DB
		echo "\n<tr>";
			echo "\n\t<td title='\"Dachgeschossausbau\" ist ein Hinweis auf den Ausbau bzw. die Ausbauf&auml;higkeit des Dachgeschosses.'>Dachgeschossausbau</td>";
			echo "\n\t<td>";
			if ($showkey) {echo "<span class='key'>".$dga."</span>&nbsp;";}			switch ($dga) {
				case 1000: echo "Nicht ausbauf&auml;hig"; break;
				case 2000: echo "Ausbauf&auml;hig"; break;
				case 3000: echo "Ausgebaut"; break;
				case 4000: echo "Ausbauf&auml;higkeit unklar"; break;
				case "": echo "&nbsp;"; break;				default: echo "** Unbekannter Wert Dachgeschossausbau '".$dga."' **"; break;
			}
			echo "</td>";
		echo "\n</tr>";
	}

	if ($zus != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='\"Zustand\" beschreibt die Beschaffenheit oder die Betriebsbereitschaft von \"Geb&auml;ude\". Diese Attributart wird nur dann optional gef&uuml;hrt, wenn der Zustand des Geb&auml;udes vom nutzungsf&auml;higen Zustand abweicht.'>Zustand</td>";
			echo "\n\t<td>";
			if ($showkey) {echo "<span class='key'>".$zus."</span>&nbsp;";}
			echo $zustand."</td>";
		echo "\n</tr>";
	}

	if ($wgf != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='\"Weitere Geb&auml;udefunktion\" ist die Funktion, die ein Geb&auml;ude neben der dominierenden Geb&auml;udefunktion hat.'>Weitere Geb&auml;udefunktionen</td>";
			echo "\n\t<td>";

			// weiteregebaeudefunktion ist jetzt ein Array
			$wgflist=trim($wgf, "{}"); // kommagetrennte(?) Liste der Schluesselwerte
			//$wgfarr=explode(",", $wgflist);
			//for each ...
			$sqlw.="SELECT wert, bezeichner FROM ax_gebaeude_weiterefunktion WHERE wert in ( $1 ) ORDER BY wert;";
			$v = array($wgflist);
			$resw = pg_prepare("", $sqlw);
			$resw = pg_execute("", $v);
			if (!$resw) {
				echo "\n<p class='err'>Fehler bei Geb&auml;ude - weitere Funktion.</p>\n";
				if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sqlw."<br>$1 = Werteliste = '".$wgflist."'</p>";}
			}
			$zw=0;
			while($roww = pg_fetch_array($resw)) { // LOOP: w.Funktion
				$wwert=$roww["wert"];
				$wbez=$roww["bezeichner"];
				if ($zw > 0) {echo ", ";} // Liste oder Zeile? echo "<br>"; 
				if ($showkey) {echo "<span class='key'>".$wwert."</span>&nbsp;";}
				echo $wbez;
				$zw++;
		   }
			echo "</td>";
		echo "\n</tr>";
	}

	if ($daf != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='\"Dachform\" beschreibt die charakteristische Form des Daches.'>Dachform</td>";
			echo "\n\t<td>";
			if ($showkey) {echo "<span class='key'>".$daf."</span>&nbsp;";}
			echo $dach."</td>";
		echo "\n</tr>";
	}

	if ($hho != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='\"Objekth&ouml;he\" ist die H&ouml;hendifferenz in [m] zwischen dem h&ouml;chsten Punkt der Dachkonstruktion und der festgelegten Gel&auml;ndeoberfl&auml;che des Geb&auml;udes.'>Objekth&ouml;he</td>";
			echo "\n\t<td>";
			echo $hho."</td>";
		echo "\n</tr>";
	}

	if ($gfl != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='\"Geschossfl&auml;che\" ist die Geb&auml;udegeschossfl&auml;che in [qm].'>Geschossfl&auml;che</td>";
			echo "\n\t<td>";
			if ($gfl != "") {
				echo $gfl." m&#178;";
			}
			echo "</td>";
		echo "\n</tr>";
	}

	if ($grf != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='\"Grundfl&auml;che\" ist die Geb&auml;udegrundfl&auml;che in [qm].'>Grundfl&auml;che</td>";
			echo "\n\t<td>";
			if ($grf != "") {
				echo $grf." m&#178;";
			}
		echo "\n</tr>";
	}

	if ($ura != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='\"Umbauter Raum\" ist der umbaute Raum [Kubikmeter] des Geb&auml;udes.'>Umbauter Raum</td>";
			echo "\n\t<td>";
			echo $ura."</td>";
		echo "\n</tr>";
	}

	if ($bja != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='\"Baujahr\" ist das Jahr der Fertigstellung oder der baulichen Ver&auml;nderung des Geb&auml;udes.'>Baujahr</td>";
			echo "\n\t<td>";
			echo $bja."</td>";
		echo "\n</tr>";
	}

	if ($daa != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='\"Dachart\" gibt die Art der Dacheindeckung (z.B. Reetdach) an.'>Dachart</td>";
			echo "\n\t<td>";
			echo $daa."</td>";
		echo "\n</tr>";
	}

	if ($qag != "" OR $allefelder) {
		echo "\n<tr>";
			echo "\n\t<td title='Angaben zur Herkunft der Informationen (Erhebungsstelle). Die Information ist konform zu den Vorgaben aus ISO 19115 zu repr&auml;sentieren.'>Qualit&auml;tsangaben</td>";
			echo "\n\t<td>";
			echo $qag."</td>";
		echo "\n</tr>";
	}

	echo "\n</table>";
}
if ($gebnr == 0) {echo "<p class='err'><br>Kein Geb&auml;ude gefunden<br>&nbsp;</p>";}
// ++ ToDo: Verschnitt mit FS

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
