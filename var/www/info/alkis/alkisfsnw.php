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
require_once("/data/mapwww/http/php/mb_validateSession.php");
require_once("/data/conf/alkis_www_conf.php");
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
	<title>ALKIS Flurst&uuml;cksnachweis</title>
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

// F L U R S T U E C K
$sql ="SELECT f.name, f.flurnummer, f.zaehler, f.nenner, f.gemeinde, f.amtlicheflaeche, f.zeitpunktderentstehung, ";
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
if ($eig=="j") {
	echo "<p class='fsei'>Flurst&uuml;ck ".$gmkgnr."-".$flurnummer."-".$flstnummer."&nbsp;</p>\n";
	echo "\n<h2>ALKIS Flurst&uuml;cks- und Eigent&uuml;mernachweis</h2>\n";
}
else {
	echo "<p class='fskennz'>Flurst&uuml;ck ".$gmkgnr."-".$flurnummer."-".$flstnummer."&nbsp;</p>\n";
	echo "\n<h2>ALKIS Flurst&uuml;cksnachweis</h2>\n";
}
echo "\n<table class='outer'>\n<tr>\n<td>";

	echo "\n\t<table class='kennz' title='Flurst&uuml;ckskennzeichen'>\n\t<tr>";
		echo "\n\t\t<td class='head'>Gmkg</td>\n\t\t<td class='head'>Flur</td>\n\t\t<td class='head'>Flurst-Nr.</td>\n\t</tr>";
		echo "\n\t<tr>\n\t\t<td title='Gemarkung'>".$gmkgnr."<br>".$gemkname."</td>";
		echo "\n\t\t<td title='Flurnummer'>".$flurnummer."</td>";
		echo "\n\t\t<td title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'>".$flstnummer."</td>\n\t</tr>";
	echo "\n\t</table>\n";

echo "</td>\n<td>";

	// Kopf Rechts: FS-Daten 2 Spalten
	echo "\n\t<table class='fsd'>";
		echo "\n\t<tr>\n\t\t<td>Entstehung</td>";
		echo "\n\t<td>".$row["zeitpunktderentstehung"]."</td>\n</tr>";

		echo "\n\t<tr>\n\t\t<td>letz. Fortf</td>";
		echo "\n\t\t<td title='Jahrgang / Fortf&uuml;hrungsnummer - Fortf&uuml;hrungsart'>".$row["name"]."</td>\n\t</tr>";
	echo "\n\t</table>";
	if ($idanzeige) { linkgml($gkz, $gmlid, "Flurst&uuml;ck"); }
echo "\n\t</td>\n</tr>\n</table>";
// Ende Seitenkopf

echo "\n<hr>\n\n<table>";

/*	echo "\n<tr>\n\t<td>Gemeinde</td>\n\t<td>".$gemeinde." ".$gemeindename."</td>\n</tr>";
	echo "\n<tr>\n\t<td>Finanzamt</td>\n\t<td>".$finanzamt." ".$finame  . "</td>\n</tr>";
*/
echo "\n<tr>\n\t<td class='ll'>Gebietszugehörigkeit:</td>";
echo "\n\t<td class='lr'>Gemeinde ".$row["gemeinde"]."</td>\n</tr>"; // +++ Entschluesseln

// L A G E  Adressen
//   ax_flurstueck  >weistAuf>  AX_LagebezeichnungMitHausnummer
//                  <gehoertZu<
$sql ="SELECT l.gml_id, l.gemeinde, l.lage, l.hausnummer, s.bezeichnung ";
$sql.="FROM  alkis_beziehungen v ";
$sql.="JOIN  ax_lagebezeichnungmithausnummer  l ON v.beziehung_zu=l.gml_id "; // Strassennamen JOIN
// Theoretisch JOIN notwendig über den kompletten Schlüssel bestehend aus land+regierungsbezirk+kreis+gemeinde+lage
// bei einem Sekundärbestand für eine Gemeinde oder einen Kreis reicht dies hier:

//$sql.="JOIN  ax_lagebezeichnungkatalogeintrag s ON l.gemeinde=s.gemeinde AND l.lage=s.lage ";
// Problem: ax_lagebezeichnungkatalogeintrag.lage ist char,ax_lagebezeichnungmithausnummer = integer,

// cast() scheitert weil auch nicht numerische Inhalte
//$sql.="JOIN  ax_lagebezeichnungkatalogeintrag s ON l.gemeinde=s.gemeinde AND l.lage=cast(s.lage AS integer) ";

$sql.="JOIN  ax_lagebezeichnungkatalogeintrag s ON l.gemeinde=s.gemeinde AND to_char(l.lage, 'FM00000')=s.lage ";
$sql.="WHERE v.beziehung_von='".$gmlid."' "; // id FS";
$sql.="AND   v.beziehungsart='weistAuf' ";
$sql.="ORDER BY l.gemeinde, l.lage, l.hausnummer;";
//$sql.="ORDER  ;";
$res=pg_query($con, $sql);
if (!$res) {echo "<p class='err'>Fehler bei Lagebezeichnung mit Hausnummer<br>\n".$sql."</p>";}
$j=0;
while($row = pg_fetch_array($res)){
	$sname = htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8"); // Str.-Name
	echo "\n<tr>\n\t<td class='ll'>Lage:</td>";
	echo "\n\t<td class='lr'>(".$row["lage"].")&nbsp;".$sname."&nbsp;".$row["hausnummer"]."</td>\n</tr>";
	$j++;
}
// L A G E  Gewanne
//   ax_flurstueck  >zeigtAuf>  AX_LagebezeichnungOhneHausnummer
//                  <gehoertZu<
$sql ="SELECT l.gml_id, l.unverschluesselt ";
$sql.="FROM  ax_lagebezeichnungohnehausnummer l ";
$sql.="JOIN  alkis_beziehungen  v ON l.gml_id=v.beziehung_zu ";
$sql.="WHERE v.beziehung_von='".$gmlid."' "; // id FS";
$sql.="AND   v.beziehungsart='zeigtAuf';";
//$sql.="ORDER  ";
$res=pg_query($con, $sql);
if (!$res) {echo "<p class='err'>Fehler bei Lagebezeichnung ohne Hausnummer<br>\n".$sql."</p>";}
$j=0;
while($row = pg_fetch_array($res)){
	$gewann = htmlentities($row["unverschluesselt"], ENT_QUOTES, "UTF-8");
	echo "\n<tr>\n\t<td class='ll'>Lage:</td>";
	echo "\n\t<td class='lr'>".$gewann."</td>\n</tr>";
	$j++;
}
//Flurstuecksflaeche
echo "\n<tr>\n\t<td class='ll'>Fl&auml;che:</td>";
echo "\n\t<td class='lr'>".$flae."</td>\n</tr>";

echo "\n</table>";

// N U T Z U N G
//echo "\n\n<h3>Tats&auml;chliche Nutzung</h3>\n";

/*
$sql="SELECT n.nutzungsart, n.flaeche, v.bez1, v.bez2, v.bez3, v.bez4, v.kurz1, v.kurz2, v.kurz3, v.kurz4 ";
$sql.="FROM v_Nutzungsarten as v INNER JOIN f_Nutzungen as n ON v.nutzungsart = n.nutzungsart ".$sqlwhere;
$res=pg_query($con, $sql);
if (!$res) {echo "<p class='err'>Fehler bei tats. Nutzung<br>\n".$sql."</p>";}

echo "<table class='nua'>\n";
// Fläche hier oder oben?
echo "<tr>\n\t<td class='fla sum'>" .$flae."</td>\n\t<td class='key'>&nbsp;</td>\n\t<td>Flurst&uuml;cksfl&auml;che</td>\n\t<td class='kurz'>&nbsp;</td>\n</tr>";
echo "\n</table>\n";
*/

/*
// ** K L A S S I F I Z I E R U N G
$sql="SELECT DISTINCT k.tabkenn, t.art_der_klassifizierung ";
$sql.="FROM k_arten_der_klassifizierung as t RIGHT JOIN f_klassifizierungen as k ON t.TabKenn = k.tabkenn ";
$sql.=$sqlwhere." ORDER BY k.tabkenn";
$resg=pg_query($con, $sql);
if (!$resg) {
	echo "<p class='err'>Fehler bei Klassifizierung Gruppen<br>\n".$sql."</p>";
}
$i=0;
while($rowg = pg_fetch_row($resg)){
	if ($i==0) {
		echo "\n<h3>Klassifizierung</h3>\n<table class='klas'>\n";
	}
	$tabkeng = pg_fetch_result($resg,$i,"tabkenn");
	$tabbez = pg_fetch_result($resg,$i,"art_der_klassifizierung");
	echo "<tr>\n\t<td class='fla'>&nbsp;</td>\n\t<td class='key head'>".$tabkeng."</td>";
	if ($tabkeng == "32") {
		echo "\n\t<td class='head'>Land- und Forstwirtschaft</td>";
		echo "\n\t<td class='head'>Bodensch&auml;tzung</td>\n\t";
		echo "<td class='emz head' title='Ertragsmeßzahl'>EMZ</td>";
	}
	else {
		echo "\n\t<td class='head'>".$tabbez."</td>";
		echo "\n\t<td class='head'>Angaben</td>\n\t";
		echo "<td class='head'>&nbsp;</td>";
		}
	echo "\n\t<td class='kurz'>&nbsp;</td>\n</tr>\n";
	// inner Loop: je Gruppe
	$sql="SELECT k.klass, k.flaeche, v.bez1, v.bez2, v.bez3, v.kurz1, v.kurz2, v.kurz3, k.angaben ";
	$sql.="FROM v_klassifizierungen as v INNER JOIN f_klassifizierungen as k ON v.klass = k.klass AND v.tabkenn = k.tabkenn ";
	$sql.= $sqlwhere." AND k.tabkenn = '".$tabkeng."'";
	$res=pg_query($con, $sql);
	if (!$res) {
		echo "<p class='err'>Fehler bei Klassifizierung Abschnitt<br>\n".$sql."</p>";
	}
	$j=0;
	$flaesum=0;
	$emzsum=0;
	while($row = pg_fetch_row($res)){
		$klass = pg_fetch_result($res,$j,"klass");
		$flae = pg_fetch_result($res,$j,"flaeche");
		$flaesum = $flaesum + $flae;
		$bez1 = htmlentities(pg_fetch_result($res,$j,"bez1"), ENT_QUOTES, "UTF-8");
		$bez2 = htmlentities(pg_fetch_result($res,$j,"bez2"), ENT_QUOTES, "UTF-8");
		$bez3 = htmlentities(pg_fetch_result($res,$j,"bez3"), ENT_QUOTES, "UTF-8");
		$kurz1 = pg_fetch_result($res,$j,"kurz1");
		$kurz2 = pg_fetch_result($res,$j,"kurz2");
		$kurz3 = pg_fetch_result($res,$j,"kurz3");
		$angab = pg_fetch_result($res,$j,"angaben");
		if ($tabkeng == "32" and strlen($angab) > 0) {
			$woslash = strpos($angab, "/");
			if ($woslash > 0) {
			// Streng genommen: Kataster-Rundung anwenden: .50 zum geraden Wert runden
				$emz = round(substr($angab, $woslash+1)*$flae/100);
				$emzsum=$emzsum+$emz;
			}
		}
		else {
			$emz = "";
			}
		echo "<tr>\n\t<td class='fla'>".number_format($flae,0,",",".")."&nbsp;m&#178;</td>";
		//echo "\n\t<td class='key'>".$tabkeng."-".$klass."</td>";
		echo "\n\t<td class='key'>".$klass."</td>";
		echo "\n\t<td>".$bez1;
		if ($bez2 != "") {
			echo "<br>".$bez2;
		}
		if ($bez3 != "") {
			echo "<br>".$bez3;
		}
		// Änderung: Angabe in eigene Spalte
		echo "</td>\n\t<td>".$angab."</td>\n\t<td class='emz'>".$emz."</td>\n\t<td class='kurz'>".$kurz1;
		if ($kurz2 != "") {
			echo "<br>".$kurz2;
		}
		if ($kurz2 != "") {
			echo "<br>".$kurz3;
		}
		echo "</td>\n</tr>\n";
		$j++;
	}
	//Summenzeile bei mehreren Zeilen
	if ($j > 1) {
		echo "<tr>\n\t<td class='fla sum'>".number_format($flaesum,0,",",".")."&nbsp;m&#178;</td>\n\t<td class='key'>&nbsp;</td>\n\t<td>&nbsp;</td>\n\t<td>&nbsp;</td>\n\t";
		if ($tabkeng == "32") {
			echo "<td class='emz sum' title='Summe Ertragsme&szlig;zahl'>".number_format($emzsum,0,",",".")."</td>";
		}
		else {
			echo "<td>&nbsp;</td>";
			}
		echo "\n\t<td class='kurz'>&nbsp;</td>\n</tr>\n";
	}
	if ($j > 0) {
		echo "</table>\n";
	}
	$i++;
}
*/

// ALB: BAULASTEN  HINWEISE  TEXTE  VERFAHREN

// G R U N D B U C H
echo "\n<table class='outer'>\n<tr>\n\t<td>"; // link *neben* Ueberschrift
echo "\n\t\t<a name='gb'></a>\n\t\t<h3>Grundb&uuml;cher</h3>";
echo "\n\t</td>\n\t<td>";
echo "\n\t\t<p class='nwlink noprint'>\n\t\t\t\t<a href='".$self."gkz=".$gkz."&amp;gmlid=".$gmlid."&amp;style=".$style;
if ($idanzeige) { echo "&amp;id=j";}
// Umschalter. Ruft sich selbst mit geaend. Param. auf. Posit. auf Marke #gb
if ($eig=="j") {echo "&amp;eig=n#gb' title='Flurst&uuml;cksnachweis'>ohne Eigent&uuml;mer</a>\n\t\t</p>";
} else {	echo "&amp;eig=j#gb' title='Flurst&uuml;cks- und Eigent&uuml;mernachweis'>mit Eigent&uuml;mer</a>\n\t\t</p>";}
echo "\n\t</td>\n</tr>\n</table>\n";


// BUCHUNGSSTELLEn zum FS (istGebucht)
$sql ="SELECT s.gml_id, s.buchungsart, s.laufendenummer as lfd, s.zaehler, s.nenner, ";
$sql.="s.nummerimaufteilungsplan as nrpl, s.beschreibungdessondereigentums as sond ";
//  s.beschreibungdesumfangsderbuchung as umf,  ?
$sql.="FROM  alkis_beziehungen  v "; // Bez Flurst.- Stelle.
$sql.="JOIN  ax_buchungsstelle  s ON v.beziehung_zu=s.gml_id ";
$sql.="WHERE v.beziehung_von='".$gmlid."' "; // id FS
$sql.="AND   v.beziehungsart='istGebucht' ";
$sql.="ORDER BY s.laufendenummer;";
$ress=pg_query($con,$sql);
if (!$ress) echo "\n<p class='err'>Keine Buchungsstelle.<br>\nSQL= ".$sql."</p>\n";
$bs=0; // Z.Buchungsstelle
while($rows = pg_fetch_array($ress)) {
	// BUCHUNGSBLATT zur Buchungsstelle (istBestandteilVon)
	$sql ="SELECT b.gml_id, b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung as blatt, b.blattart, ";
	$sql.="z.bezeichnung ";  // stelle -> amtsgericht
	$sql.="FROM  alkis_beziehungen      v "; // Bez. Stelle - Blatt
	$sql.="JOIN  ax_buchungsblatt       b ON v.beziehung_zu=b.gml_id ";
	$sql.="JOIN  ax_buchungsblattbezirk z ON z.land=b.land AND z.bezirk=b.bezirk ";
	$sql.="WHERE v.beziehung_von='".$rows["gml_id"]."' "; // id Buchungsstelle
	$sql.="AND   v.beziehungsart='istBestandteilVon' ";
	$sql.="ORDER BY b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung ;";

	$resg=pg_query($con,$sql);
	if (!$resg) echo "\n<p class='err'>Keine Buchungsblatt.<br>\nSQL= ".$sql."</p>\n";
	$bl=0; // Z.Blatt
	while($rowg = pg_fetch_array($resg)) {
		$beznam=$rowg["bezeichnung"];
		echo "\n<hr>\n<table class='outer'>\n<tr>\n<td>"; // link *neben* GB-Rahmen
		echo "\n\t<table class='kennz' title='Bestandskennzeichen'>\n\t<tr>\n\t\t<td class='head'>Bezirk</td>";
		echo "\n\t\t<td class='head'>".blattart($rowg["blattart"])."</td>\n\t\t<td class='head'>Lfd-Nr,</td>\n\t\t<td class='head'>Buchungsart</td>\n\t</tr>";
		echo "\n\t<tr>\n\t\t<td title='Grundbuchbezirk'>".$rowg["bezirk"]."<br>".$beznam."</td>";
		echo "\n\t\t<td title='Grundbuch-Blatt'>".$rowg["blatt"]."</td>";
		echo "\n\t\t<td title='Bestandsverzeichnis-Nummer (BVNR, Grundst&uuml;ck)'>".$rows["lfd"]."</td>";
		echo "\n\t\t<td title='Buchungsart'>".$rows["buchungsart"]."<br>".buchungsart($rows["buchungsart"])."</td>\n\t</tr>\n\t</table>";
		if ($rows["zaehler"] <> "") {
			echo "\n<p class='ant'>".$rows["zaehler"]."/".$rows["nenner"]."&nbsp;Anteil am Flurst&uuml;ck</p>";
		}
		echo "\n</td>\n<td>";
		if ($idanzeige) {
			linkgml($gkz, $rows["gml_id"], "Buchungsstelle");
			linkgml($gkz, $rowg["gml_id"], "Buchungsblatt");
		}
		echo "<br>\n";
		echo "\n\t<p class='nwlink'>weitere Auskunft:<br>\n\t\t<a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$rowg[0]."&amp;style=".$style;
		if ($idanzeige) echo "&amp;id=j";
		echo "' title='Grundbuchnachweis mit kompletter Eigent&uuml;merangabe'>GB-Nachweis</a>\n\t</p>\n</td>\n";
		echo "</table>";

		if ($rowg["blattart"] <> "1000") {
			echo "\n<p>Blattart: ".blattart($rowg["blattart"])." (".$rowg["blattart"].").<br>\n"; 
		}

		// ++++++Weitere Felder ausgeben ??????   oder in SQL weglassen
		//  +++ STYLE ?
		if ($rows["sond"] != "") {echo "<p>Sondereigentum: ".$rows["sond"]."</p>";}
		if ($rows["nrpl"] != "") {echo "<p>Nr im A-Plan: ".$rows["nrpl"]."</p>";}


		// E I G E N T U E M E R, zum GB
		if ($eig=="j") { // Wahlweise mit/ohne Eigentümer
			//echo "\n\n<h4>Eigent&uuml;mer:</h4>\n";
			// Person <-benennt< AX_Namensnummer  >istBestandteilVon-> AX_Buchungsblatt

			// Schleife 1: N a m e n s n u m m e r
			// Beziehung: ax_namensnummer  >istBestandteilVon>  ax_buchungsblatt
			$sql="SELECT n.gml_id, n.laufendenummernachdin1421 AS lfd, n.zaehler, n.nenner, ";
			$sql.="n.artderrechtsgemeinschaft AS adr, n.beschriebderrechtsgemeinschaft as beschr, n.eigentuemerart, n.anlass ";
			$sql.="FROM  ax_namensnummer   n ";
			$sql.="JOIN  alkis_beziehungen b ON b.beziehung_von=n.gml_id ";
			$sql.="WHERE b.beziehung_zu='".$rowg["gml_id"]."' "; // id blatt
			$sql.="AND   b.beziehungsart='istBestandteilVon' ";
			$sql.="ORDER BY laufendenummernachdin1421;";
			$resn=pg_query($con, $sql);
			if (!$resn) {echo "<p class='err'>Fehler bei Eigentuemer<br>SQL= ".$sql."<br></p>\n";}
			echo "\n<table class='eig'>";
			$n=0; // Z.NamNum.
			while($rown = pg_fetch_array($resn)) {
				echo "\n<tr>\n\t<td class='nanu' title='Namens-Nummer'>";
				// VOR die Tabelle: "Eigentümer"
				$namnum=kurz_namnr($rown["lfd"]);
				echo "\n\t\t<p>".$namnum."</p>";
				if ($idanzeige) {linkgml($gkz, $rown["gml_id"], "Namensnummer");}
				echo "\n\t</td>\n\t<td>";
				$rechtsg=$rown["adr"];
				if ($rechtsg != "" ) {
					if ($rechtsg == 9999) { // sonstiges
						echo "\n\t\t<p class='zus' title='Beschrieb der Rechtsgemeinschaft'>".htmlentities($rown["beschr"], ENT_QUOTES, "UTF-8")."</p>";
					} else {
						echo "\n\t\t<p class='zus' title='Art der Rechtsgemeinschaft'>".htmlentities(rechtsgemeinschaft($rown["adr"]), ENT_QUOTES, "UTF-8")."</p>";
					}
				}

				// Schleife 2: P e r s o n  
				// Beziehung: ax_person  <benennt<  ax_namensnummer
				$sql="SELECT p.gml_id, p.nachnameoderfirma, p.vorname, p.geburtsname, p.geburtsdatum, p.namensbestandteil, p.akademischergrad ";
				$sql.="FROM  ax_person p ";
				$sql.="JOIN  alkis_beziehungen v ON v.beziehung_zu=p.gml_id ";
				$sql.="WHERE v.beziehung_von='".$rown["gml_id"]."' "; // id num
				$sql.="AND   v.beziehungsart='benennt';";
				$rese=pg_query($con, $sql);
				if (!$rese) echo "\n\t<p class='err'>Fehler bei Eigentuemer<br>SQL= ".$sql."<br></p>\n";
				$i=0; // Z.Eig.
				while($rowe = pg_fetch_array($rese)) {
					$diePerson="";
					if ($rowe["akademischergrad"] <> "") $diePerson=$rowe["akademischergrad"]." ";
					$diePerson.=$rowe["nachnameoderfirma"];
					if ($rowe["vorname"] <> "") $diePerson.=", ".$rowe["vorname"];
					if ($rowe["namensbestandteil"] <> "") $diePerson.=". ".$rowe["namensbestandteil"];
					if ($rowe["geburtsdatum"] <> "") $diePerson.=", geb. ".$rowe["geburtsdatum"];
					if ($rowe["geburtsname"] <> "") $diePerson.=", geb. ".$rowe["geburtsname"];
					$diePerson=htmlentities($diePerson, ENT_QUOTES, "UTF-8"); // Umlaute
					// Spalte 1 enthält die Namensnummer, nur in Zeile 0
					if ($i > 0) {echo "\n<tr>\n\t<td></td>\n\t<td>";}
					// Spalte 2 = Angaben
					echo "\n\t\t<p class='geig' title='Eigent&uuml;merart ".eigentuemerart($rown["eigentuemerart"])."'>".$diePerson."</p>\n\t</td>";
					// Spalte 3 = Link
					echo "\n\t<td>\n\t\t<p class='nwlink noprint'>\n\t\t\t<a href='alkisnamstruk.php?gkz=".$gkz."&amp;gmlid=".$rowe[0]."&amp;style=".$style;
					if ($idanzeige) { echo "&amp;id=j";}
					echo "' title='vollst&auml;ndiger Name und Adresse eines Eigent&uuml;mers'>Person</a>\n\t\t</p>";
					if ($idanzeige) { linkgml($gkz, $rowe["gml_id"], "Person");}
					echo "\n\t</td>\n</tr>";
					$i++; // Z. Person
					if ($rown["zaehler"] <> "") {
						echo "\n<tr>\n\t<td></td>\n\t<td><p class='avh' title='Anteil'>".$rown["zaehler"]."/".$rown["nenner"]." Anteil</p>";
						echo "\n</td>\n\t<td></td>\n</tr>";
					}
				}
				/* Wann warnen ?
				   Beispiel: NamNum mit "Erbengemeinschaft"  >bestehtAusRechtsverhaeltnissenZu>  andere NamNum
				if ($i == 0) { // keine Pers zur NamNum
					if ($rechtsg != 9999) { // Normal bei Sondereigentum
						echo "\n<tr>\n<td>";
						linkgml($gkz, $rown["gml_id"], "Namensnummer");
						echo "</td>\n<td>\n\t\t<p class='err'>Kein Eigent&uuml;mer gefunden.</p>";
						echo "\n\t\t\n\t</td>\n\t<td></td>\n<tr>";
					}
				}
				*/
				$n++; // Z.NamNum
			}
			echo "\n</table>\n";
			if ($n == 0) {
				if ($rowg["blattart"] == 1000) {
					echo "\n<p class='err'>Keine Namensnummer gefunden.</p>";
					linkgml($gkz, $rowg["gml_id"], "Buchungsblatt");
				} else {
					echo "\n<p>dazu keine Eigent&uuml;mer.</p>";
					linkgml($gkz, $rowg["gml_id"], "Buchungsblatt");
				}
			}
		} // Ende Option EigentuemerNW
		$bl++;
	}
	if ($bl == 0) {
		echo "\n<p class='err'>Kein Buchungsblatt gefunden.</p>";
		linkgml($gkz, $rows["gml_id"], "Buchungstelle");
	}
	// Test BEGINN
	//echo "\n<p>Buchungsstelle ".$rows["gml_id"]."</p>";
	//if ($idanzeige) {linkgml($gkz, $rows["gml_id"], "Buchungsstelle");}
	// Test ENDE

	// Buchungstelle  >an> Buchungstelle  >istBestandteilVon> BLATT -> Bezirk
	$sql ="SELECT s.gml_id AS s_gml, s.buchungsart, s.laufendenummer as lfd, ";
	// , s.beschreibungdesumfangsderbuchung as umf   ?
	$sql.="s.zaehler, s.nenner, s.nummerimaufteilungsplan as nrpl, s.beschreibungdessondereigentums as sond, ";
	$sql.="b.gml_id AS g_gml, b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung as blatt, b.blattart, ";
	$sql.="z.bezeichnung ";  // stelle -> amtsgericht
	$sql.="FROM  alkis_beziehungen     an "; // Bez. Stelle - Stelle
	$sql.="JOIN  ax_buchungsstelle      s ON an.beziehung_von=s.gml_id ";
	$sql.="JOIN  alkis_beziehungen      v ON s.gml_id=v.beziehung_von "; // Bez. Stelle - Blatt
	$sql.="JOIN  ax_buchungsblatt       b ON v.beziehung_zu=b.gml_id ";
	$sql.="JOIN  ax_buchungsblattbezirk z ON z.land=b.land AND z.bezirk=b.bezirk ";
	$sql.="WHERE an.beziehung_zu='".$rows["gml_id"]."' "; // id herrschende Buchungsstelle
	$sql.="AND   an.beziehungsart='an' ";
	$sql.="AND   v.beziehungsart='istBestandteilVon' ";
	$sql.="ORDER BY b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung ;";
	$resan=pg_query($con,$sql);
	if (!$resan) echo "\n<p class='err'>Keine weiteren Buchungsstellen.<br>\nSQL=<br>".$sql."</p>\n";
	$an=0; // Stelle an Stelle
	while($rowan = pg_fetch_array($resan)) {
		$beznam=$rowan["bezeichnung"];
		echo "\n<hr>\n<table class='outer'>\n<tr>\n<td>"; // link *neben* GB-Rahmen
		echo "\n\t<table class='kennz' title='Bestandskennzeichen'>\n\t<tr>\n\t\t<td class='head'>Bezirk</td>";
		echo "\n\t\t<td class='head'>".blattart($rowan["blattart"])."</td>\n\t\t<td class='head'>Lfd-Nr,</td>\n\t\t<td class='head'>Buchungsart</td>\n\t</tr>";
		echo "\n\t<tr>\n\t\t<td title='Grundbuchbezirk'>".$rowan["bezirk"]."<br>".$beznam."</td>";
		echo "\n\t\t<td title='Grundbuch-Blatt'>".$rowan["blatt"]."</td>";
		echo "\n\t\t<td title='Bestandsverzeichnis-Nummer (BVNR, Grundst&uuml;ck)'>".$rowan["lfd"]."</td>";
		echo "\n\t\t<td title='Buchungsart'>".$rowan["buchungsart"]."<br>".buchungsart($rowan["buchungsart"])."</td>\n\t</tr>\n\t</table>";
		if ($rowan["zaehler"] <> "") {
			echo "\n<p class='ant'>".$rowan["zaehler"]."/".$rowan["nenner"]."&nbsp;Anteil am Flurst&uuml;ck</p>";
		}
		echo "\n</td>\n<td>";
		if ($idanzeige) {
			linkgml($gkz, $rowan["s_gml"], "Buchungsstelle");
			linkgml($gkz, $rowan["g_gml"], "Buchungsblatt");
		}
		echo "<br>\n";
		echo "\n\t<p class='nwlink'>weitere Auskunft:<br>\n\t\t<a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$rowan["g_gml"]."&amp;style=".$style;
		if ($idanzeige) echo "&amp;id=j";
		echo "' title='Grundbuchnachweis mit kompletter Eigent&uuml;merangabe'>GB-Nachweis</a>\n\t</p>\n</td>\n";
		echo "</table>";

		if ($rowan["blattart"] <> "1000") {
			echo "\n<p>Blattart: ".blattart($rowan["blattart"])." (".$rowan["blattart"].").<br>\n"; 
		}

		// +++ Weitere Felder ausgeben oder in SQL weglassen??
		// +++ STYLE ?
		if ($rowan["sond"] != '') {echo "<p>Sondereigentum: ".$rowan["sond"]."</p>";}
		if ($rowan["nrpl"] != '') {echo "<p>Nr im A-Plan: ".$rowan["nrpl"]."</p>";}

		if ($eig=="j") {
			echo "\n<p>Eigent&uuml;mer vorläufig dem GB-Nachweis entnehmen.</p>";
		}
		// +++ Lösung: Den Teil Eigentümer (Namensnummer > Person, siehe oben) 
		//     als Funktion auslagern und hier erneut aufrufen

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

<?php footer($gkz, $gmlid, $idanzeige, $self, $hilfeurl,$style); ?>

</body>
</html>