<?php
/*	Modul: alkisfsnw.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Flurstücksnachweis fuer ein Flurstückskennzeichen aus ALKIS PostNAS

	Version:
	31.08.2010	$style=ALKIS entfernt, alles Kompakt
	02.09.2010  Mit Icons
	07.09.2010  Kennzeichen-Rahmen f. fiktives Blatt, Schluessel anschaltbar
	15.09.2010  Function "buchungsart" durch JOIN ersetzt

	ToDo: 
	NamNum >bestehtAusRechtsverhaeltnissenZu> NamNum*/
ini_set('error_reporting', 'E_ALL & ~ E_NOTICE');
session_start();
require_once("/data/conf/alkis_www_conf.php");
if ($auth == "mapbender") {
	// Bindung an Mapbender-Authentifizierung
	require_once($mapbender);
}
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
	<title>ALKIS Flurst&uuml;cksnachweis</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Flurstueck.ico">
	<style type='text/css' media='print'>
		.noprint { visibility: hidden;}
	</style>
</head>
<body>
<?php
$gkz=urldecode($_REQUEST["gkz"]);
$gmlid=urldecode($_REQUEST["gmlid"]);
$eig=urldecode($_REQUEST["eig"]);

// getswitch($idanzeige, $showkey);
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

$dbname = 'alkis05' . $gkz;
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);

// F L U R S T U E C K
$sql ="SELECT f.name, f.flurnummer, f.zaehler, f.nenner, f.regierungsbezirk, f.kreis, f.gemeinde, f.amtlicheflaeche, f.zeitpunktderentstehung, ";
$sql.="g.gemarkungsnummer, g.bezeichnung ";
$sql.="FROM ax_flurstueck f ";
$sql.="JOIN ax_gemarkung  g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer ";
$sql.="WHERE f.gml_id='".$gmlid."';";
$res=pg_query($con,$sql);
if (!$res) echo "\n<p class='err'>Fehler bei Flurstuecksdaten\n<br>".$sql."</p>\n";
if ($row = pg_fetch_array($res)) {
	$gemkname=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
	$gmkgnr=$row["gemarkungsnummer"];
	$flurnummer=$row["flurnummer"];
	$flstnummer=$row["zaehler"];
	$nenner=$row["nenner"];
	if ($nenner > 0) $flstnummer.="/".$nenner; // BruchNr
	$flae=number_format($row["amtlicheflaeche"],0,",",".") . " m&#178;";
} else {echo "Fehler! Kein Treffer fuer gml_id=".$gmlid;}

// Balken
if ($eig=="j") {
	echo "<p class='fsei'>ALKIS Flurst&uuml;ck ".$gmkgnr."-".$flurnummer."-".$flstnummer."&nbsp;</p>\n";
	echo "\n<h2><img src='ico/Flurstueck.ico' width='16' height='16' alt=''> Flurst&uuml;ck mit Eigent&uuml;mer</h2>\n";
} else {
	echo "<p class='fskennz'>ALKIS Flurst&uuml;ck ".$gmkgnr."-".$flurnummer."-".$flstnummer."&nbsp;</p>\n";
	echo "\n<h2><img src='ico/Flurstueck.ico' width='16' height='16' alt=''> Flurst&uuml;ck</h2>\n";
}
echo "\n<table class='outer'>\n<tr>\n\t<td>"; // linke Seite

	// darin Tabelle Kennzeichen
	echo "\n\t<table class='kennzfs' title='Flurst&uuml;ckskennzeichen'>\n\t<tr>";
		echo "\n\t\t<td class='head'>Gmkg</td>\n\t\t<td class='head'>Flur</td>\n\t\t<td class='head'>Flurst-Nr.</td>\n\t</tr>";
		echo "\n\t<tr>\n\t\t<td title='Gemarkung'>";
		if ($showkey) {		
			echo "<span class='key'>".$gmkgnr."</span><br>";
		}		
		echo $gemkname."</td>";
		echo "\n\t\t<td title='Flurnummer'>".$flurnummer."</td>";
		echo "\n\t\t<td title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'><span class='wichtig'>".$flstnummer."</span></td>\n\t</tr>";
	echo "\n\t</table>";

echo "\n\t</td>\n\t<td>"; // rechte Seite

	// FS-Daten 2 Spalten
	echo "\n\t<table class='fsd'>";
		echo "\n\t<tr>\n\t\t<td>Entstehung</td>";
		echo "\n\t\t<td>".$row["zeitpunktderentstehung"]."</td>\n\t</tr>";
		echo "\n\t<tr>\n\t\t<td>letz. Fortf</td>";
		echo "\n\t\t<td title='Jahrgang / Fortf&uuml;hrungsnummer - Fortf&uuml;hrungsart'>".$row["name"]."</td>\n\t</tr>";
	echo "\n\t</table>";
	if ($idanzeige) {linkgml($gkz, $gmlid, "Flurst&uuml;ck"); }
echo "\n\t</td>\n</tr>\n</table>";

//	echo "\n<tr>\n\t<td>Finanzamt</td>\n\t<td>".$finanzamt." ".$finame  . "</td>\n</tr>";
// Ende Seitenkopf

echo "\n<hr>";
echo "\n<p class='nwlink noprint'>weitere Auskunft:</p>"; // oben rechts von der Tabelle
echo "\n<table class='fs'>";
	
	fs_gebietszug($con, $row["gemeinde"], $row["kreis"], $row["regierungsbezirk"], $showkey); // Gebietszugehoerigkeit

	fs_lage($con, $gmlid, $gkz, $showkey); // Adresse, Lagebezeichnung

	fs_nutz($con, $gmlid, $showkey); // Tatsaechliche Nutzung

	// Flaeche und Link auf Gebäude-Auswertung
	echo "\n<tr>";
		echo "\n\t<td class='ll'>Fl&auml;che:</td>"; // Sp. 1
		echo "\n\t<td class='lr'>".$flae."</td>"; // Sp. 2
		echo "\n\t<td>"; // Sp. 3
			echo "\n\t\t<p class='nwlink noprint'>"; // Gebaeude-Verschneidung
				echo "\n\t\t\t<a href='alkisgebaeudenw.php?gkz=".$gkz."&amp;gmlid=".$gmlid;
				if ($idanzeige) {echo "&amp;id=j";}
				if ($showkey)   {echo "&amp;id=j";}
				echo "' title='Geb&auml;udenachweis'>Geb&auml;ude <img src='ico/Haus.ico' width='16' height='16' alt=''></a>";
			echo "\n\t\t</p>";
		echo "\n\t</td>";
	echo "\n</tr>";

echo "\n</table>";
// ALB: KLASSIFIZIERUNG  BAULASTEN  HINWEISE  TEXTE  VERFAHREN

// G R U N D B U C H
echo "\n<table class='outer'>";
	echo "\n<tr>";
		echo "\n\t<td>";
			echo "\n\t\t<a name='gb'></a>\n\t\t<h3><img src='ico/Grundbuch_zu.ico' width='16' height='16' alt=''> Grundb&uuml;cher</h3>";
		echo "\n\t</td>";
		echo "\n\t<td>";
			echo "\n\t\t<p class='nwlink noprint'>";
				echo "\n\t\t\t<a href='".$self."gkz=".$gkz."&amp;gmlid=".$gmlid;
				if ($idanzeige) { echo "&amp;id=j";}
				if ($showkey)   {echo "&amp;showkey=j";}
				// Umschalter: FS-Nachw ruft sich selbst mit geaend. Param. auf. Posit. auf Marke #gb
				if ($eig=="j") {
					echo "&amp;eig=n#gb' title='Flurst&uuml;cksnachweis'>ohne Eigent&uuml;mer</a>";
				} else {	
					echo "&amp;eig=j#gb' title='Flurst&uuml;cks- und Eigent&uuml;mernachweis'>mit Eigent&uuml;mer";
					echo "<img src='ico/EigentuemerGBzeile.ico' width='16' height='16' alt=''></a>";
				}			echo "\n\t\t</p>";
		echo "\n\t</td>";
	echo "\n</tr>";
echo "\n</table>\n";

// B U C H U N G S S T E L L E N  zum FS (istGebucht)
$sql ="SELECT s.gml_id, s.buchungsart, s.laufendenummer as lfd, s.zaehler, s.nenner, ";
$sql.="s.nummerimaufteilungsplan as nrpl, s.beschreibungdessondereigentums as sond, b.bezeichner AS bart ";
//  s.beschreibungdesumfangsderbuchung as umf,  ?
$sql.="FROM  alkis_beziehungen  v "; // Bez Flurst.- Stelle.
$sql.="JOIN  ax_buchungsstelle  s ON v.beziehung_zu=s.gml_id ";

$sql.="LEFT JOIN ax_buchungsstelle_buchungsart b ON s.buchungsart = b.wert ";

$sql.="WHERE v.beziehung_von='".$gmlid."' "; // id FS
$sql.="AND   v.beziehungsart='istGebucht' ";
$sql.="ORDER BY s.laufendenummer;";
$ress=pg_query($con,$sql);
if (!$ress) {
	echo "\n<p class='err'>Keine Buchungsstelle.<br>\nSQL= ".$sql."</p>\n";
}
$bs=0; // Z.Buchungsstelle
while($rows = pg_fetch_array($ress)) {
	$gmls=$rows["gml_id"];
	$lfd=$rows["lfd"]; // BVNR

	// B U C H U N G S B L A T T  zur Buchungsstelle (istBestandteilVon)
	$sql ="SELECT b.gml_id, b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung as blatt, b.blattart, ";
	$sql.="z.bezeichnung ";  // stelle -> amtsgericht
	$sql.="FROM  alkis_beziehungen      v "; // Bez. Stelle - Blatt
	$sql.="JOIN  ax_buchungsblatt       b ON v.beziehung_zu=b.gml_id ";
	$sql.="JOIN  ax_buchungsblattbezirk z ON z.land=b.land AND z.bezirk=b.bezirk ";
	$sql.="WHERE v.beziehung_von='".$gmls."' "; // id Buchungsstelle
	$sql.="AND   v.beziehungsart='istBestandteilVon' ";
	$sql.="ORDER BY b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung ;";

	$resg=pg_query($con,$sql);
	if (!$resg) {
		echo "\n<p class='err'>Keine Buchungsblatt.<br>\nSQL= ".$sql."</p>\n";
	}
	$bl=0; // Z.Blatt
	while($rowg = pg_fetch_array($resg)) {
		$gmlg=$rowg["gml_id"];
		$beznam=$rowg["bezeichnung"];
		$blattkeyg=$rowg["blattart"];
		$blattartg=blattart($blattkeyg);

		echo "\n<hr>";
		echo "\n<table class='outer'>";
		echo "\n<tr>"; // 1 row only
			echo "\n\t<td>"; // Outer linke Spalte:

				// Rahmen mit GB-Kennz
				if ($blattkeyg == 1000) {
					echo "\n\t<table class='kennzgb' title='Bestandskennzeichen'>";
				}else {
					echo "\n\t<table class='kennzgbf' title='Bestandskennzeichen'>"; // dotted
				}				
					echo "\n\t<tr>\n\t\t<td class='head'>Bezirk</td>";
						echo "\n\t\t<td class='head'>".$blattartg."</td>";
						echo "\n\t\t<td class='head'>Lfd-Nr,</td>";
						echo "\n\t\t<td class='head'>Buchungsart</td>";
					echo "\n\t</tr>";
					echo "\n\t<tr>";
						echo "\n\t\t<td title='Grundbuchbezirk'>";
							if ($showkey) {						
								echo "<span class='key'>".$rowg["bezirk"]."</span><br>";						
							}						
							echo $beznam;
						echo "</td>";

						echo "\n\t\t<td title='Grundbuch-Blatt'><span class='wichtig'>".$rowg["blatt"]."</span></td>";

						echo "\n\t\t<td title='Bestandsverzeichnis-Nummer (BVNR, Grundst&uuml;ck)'>".$rows["lfd"]."</td>";

						echo "\n\t\t<td title='Buchungsart'>";
							if ($showkey) {
								echo "<span class='key'>".$rows["buchungsart"]."</span><br>";
							}
							echo $rows["bart"];
						echo "</td>";
						
					echo "\n\t</tr>";
				echo "\n\t</table>";

				// Miteigentumsanteil
				if ($rows["zaehler"] <> "") {
					echo "\n<p class='ant'>".$rows["zaehler"]."/".$rows["nenner"]."&nbsp;Anteil am Flurst&uuml;ck</p>";
				}
			echo "\n</td>";

			echo "\n<td>"; // Outer rechte Spalte: NW-Links
				if ($idanzeige) {
					linkgml($gkz, $gmls, "Buchungsstelle");
					echo "<br>";
					linkgml($gkz, $gmlg, "Buchungsblatt");
				}
				echo "\n\t<p class='nwlink'>weitere Auskunft:<br>";
					echo "\n\t\t<a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$gmlg."#bvnr".$lfd;
						if ($idanzeige) {echo "&amp;id=j";}
						if ($showkey)   {echo "&amp;showkey=j";}
						if ($blattkeyg == 1000) {						
							echo "' title='Grundbuchnachweis mit kompletter Eigent&uuml;merangabe'>";
						} else {
							echo "' title='Grundbuchnachweis'>";
						}						
						echo $blattartg." <img src='ico/GBBlatt_link.ico' width='16' height='16' alt=''></a>";
				echo "\n\t</p>";
			echo "\n</td>";
		echo "\n</tr>";
		echo "\n</table>";

		// +++ Weitere Felder ausgeben ?? beschreibungdesumfangsderbuchung		if ($rows["sond"] != "") {
			echo "<p class='sond' title='Sondereigentum'>Verbunden mit dem Sondereigentum<br>".$rows["sond"]."</p>";
		}
		if ($rows["nrpl"] != "") {
			echo "<p class='nrap' title='Nummer im Aufteilungsplan'>Nummer <span class='wichtig'>".$rows["nrpl"]."</span> im Aufteilungsplan.</p>";		
		}
		// E I G E N T U E M E R, zum GB
		// Person <-benennt< AX_Namensnummer  >istBestandteilVon-> AX_Buchungsblatt
		if ($eig=="j") { // Wahlweise mit/ohne Eigentümer			$n = eigentuemer($con, $gkz, $idanzeige, $gmlg, false); // hier aber ohne Adresse
 			if ($n == 0) {
				if ($blattkeyg == 1000) {
					echo "\n<p class='err'>Keine Namensnummer gefunden.</p>";
					linkgml($gkz, $gmlg, "Buchungsblatt");
				} else {
					echo "\n<p>ohne Eigent&uuml;mer.</p>";				}
			}
		}
		$bl++;	}
	if ($bl == 0) {
		echo "\n<p class='err'>Kein Buchungsblatt gefunden.</p>";
		linkgml($gkz, $gmls, "Buchungstelle");
	}

	// Buchungstelle  >an>  Buchungstelle  >istBestandteilVon>  BLATT  ->  Bezirk
	$sql ="SELECT s.gml_id AS s_gml, s.buchungsart, s.laufendenummer as lfd, ";
	// , s.beschreibungdesumfangsderbuchung as umf   ?
	$sql.="s.zaehler, s.nenner, s.nummerimaufteilungsplan as nrpl, s.beschreibungdessondereigentums as sond, ";
	$sql.="b.gml_id AS g_gml, b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung as blatt, b.blattart, ";
	$sql.="z.bezeichnung, a.bezeichner AS bart ";  // stelle -> amtsgericht
	$sql.="FROM  alkis_beziehungen an "; // Bez. Stelle - Stelle
	$sql.="JOIN  ax_buchungsstelle s ON an.beziehung_von = s.gml_id ";
	$sql.="JOIN  alkis_beziehungen v ON s.gml_id = v.beziehung_von "; // Bez. Stelle - Blatt
	$sql.="JOIN  ax_buchungsblatt  b ON v.beziehung_zu = b.gml_id ";
	$sql.="JOIN  ax_buchungsblattbezirk z ON z.land = b.land AND z.bezirk = b.bezirk ";
	$sql.="JOIN  ax_buchungsstelle_buchungsart a ON s.buchungsart = a.wert ";
	$sql.="WHERE an.beziehung_zu = '".$gmls."' "; // id herrschende Buchungsstelle
	$sql.="AND   an.beziehungsart = 'an' ";
	$sql.="AND   v.beziehungsart = 'istBestandteilVon' ";
	$sql.="ORDER BY b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung;";

	$resan=pg_query($con,$sql);

	if (!$resan) {
		echo "\n<p class='err'>Keine weiteren Buchungsstellen.<br>\nSQL=<br>".$sql."</p>\n";
	}
	$an=0; // Stelle an Stelle
	while($rowan = pg_fetch_array($resan)) {
		$beznam=$rowan["bezeichnung"];
		$blattkeyan=$rowan["blattart"]; // Schluessel von Blattart
		$blattartan=blattart($blattkeyan);

		//echo "\n<p class='err'>SQL=<br>".$sql."</p>\n";

		echo "\n<hr>\n<table class='outer'>";
		echo "\n<tr>"; // 1 row only
			echo "\n<td>"; // outer linke Spalte

				// Rahmen mit Kennzeichen GB
				if ($blattkeyan == 1000) {
					echo "\n\t<table class='kennzgb' title='Bestandskennzeichen'>";
				} else {
					echo "\n\t<table class='kennzgbf' title='Bestandskennzeichen'>"; // dotted
				}				
					echo "\n\t<tr>";
						echo "\n\t\t<td class='head'>Bezirk</td>";
						echo "\n\t\t<td class='head'>".$blattartan."</td>";
						echo "\n\t\t<td class='head'>Lfd-Nr,</td>";
						echo "\n\t\t<td class='head'>Buchungsart</td>";
					echo "\n\t</tr>";

					echo "\n\t<tr>";
						echo "\n\t\t<td title='Grundbuchbezirk'>";
						if ($showkey) {						
							echo "<span class='key'>".$rowan["bezirk"]."</span><br>";
						}						
						echo $beznam."</td>";

						echo "\n\t\t<td title='Grundbuch-Blatt'><span class='wichtig'>".$rowan["blatt"]."</span></td>";

						echo "\n\t\t<td title='Bestandsverzeichnis-Nummer (BVNR, Grundst&uuml;ck)'>".$rowan["lfd"]."</td>";

						echo "\n\t\t<td title='Buchungsart'>";
							if ($showkey) {						
								echo "<span class='key'>".$rowan["buchungsart"]."</span><br>";
							}
							echo $rowan["bart"];
						echo "</td>";

					echo "\n\t</tr>";
				echo "\n\t</table>";
				if ($rowan["zaehler"] <> "") {
					echo "\n<p class='ant'>".$rowan["zaehler"]."/".$rowan["nenner"]."&nbsp;Anteil am Flurst&uuml;ck</p>";
				}
			echo "\n</td>";
			echo "\n<td>"; // outer rechte Spalte
				if ($idanzeige) {
					linkgml($gkz, $rowan["s_gml"], "Buchungsstelle");
					echo "<br>";
					linkgml($gkz, $rowan["g_gml"], "Buchungsblatt");
				}
				echo "\n<br>";
				echo "\n\t<p class='nwlink'>";
					echo "\n\t\t<a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$rowan["g_gml"];
						if ($idanzeige) {echo "&amp;id=j";}
						if ($showkey)   {echo "&amp;showkey=j";}
						echo "' title='Grundbuchnachweis mit kompletter Eigent&uuml;merangabe'>";
						echo $blattartan;
						echo " <img src='ico/GBBlatt_link.ico' width='16' height='16' alt=''>";				
					echo "</a>";
				echo "\n\t</p>";
			echo "\n\t</td>";
		echo "\n</tr>";
		echo "\n</table>";

		if ($blattkeyan != 1000) {
			echo "\n<p>Blattart: ".$blattartan." (".$blattkeyan.").<br>\n"; 
		}

		// +++ Weitere Felder ausgeben ?? BeschreibungDesUmfangsDerBuchung		if ($rowan["nrpl"] != "") {
			echo "<p class='nrap' title='Nummer im Aufteilungsplan'>Nummer <span class='wichtig'>".$rowan["nrpl"]."</span> im Aufteilungsplan.</p>";
		}
		if ($rowan["sond"] != "") {
			echo "<p class='sond' title='Sondereigentum'>Verbunden mit dem Sondereigentum<br>".$rowan["sond"]."</p>";
		}

		if ($eig=="j") {
			$n = eigentuemer($con, $gkz, $idanzeige, $rowan["g_gml"], false, $showkey); // ohne Adresse
			// Anzahl $n kontrollieren? Warnen?
		}
		$an++;
	}
	// Zaehler $an==0 ist hier der Normalfall
	$bs++;
}
if ($bs == 0) {
	echo "\n<p class='err'>Keine Buchungstelle gefunden.</p>";
	linkgml($gkz, $gmlid, "Flurst&uuml;ck");
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