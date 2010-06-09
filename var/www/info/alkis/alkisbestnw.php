<?php
/*	alkisbestnw.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Bestandsnachweis fuer ein Grundbuch aus ALKIS PostNAS
	Parameter:	&gkz= &gmlid

	Version:
	26.01.2010	internet-Version  mit eigener conf

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
	<title>ALKIS Bestandsnachweis</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<style type='text/css' media='print'>
		.noprint { visibility: hidden;}
	</style>
</head>
<body>
<?php
$gkz=urldecode($_REQUEST["gkz"]);
$gmlid=urldecode($_REQUEST["gmlid"]);
$id=isset($_GET["id"]) ? $_GET["id"] : "n";
$idanzeige=false;
if ($id == "j") {$idanzeige=true;}
$style=isset($_GET["style"]) ? $_GET["style"] : "kompakt";
$dbname = 'alkis05' . $gkz;
$con = pg_connect("host=".$dbhost." port=".$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) echo "<p class='err'>Fehler beim Verbinden der DB</p>\n";
// ** G R U N D B U C H **
/*	Bei JOIN ueber alkis_beziehungen. Entgegen Dokumentation keine Verbindung gefunden!
$sql.="FROM  ax_buchungsblatt g ";
$sql.="JOIN  ax_buchungsblattbezirk b ON g.land=b.land AND g.bezirk=b.bezirk "; // BBZ
$sql.="JOIN  alkis_beziehungen bba ON b.gml_id=bba.beziehung_von "; // Bez->AG
$sql.="JOIN  ax_dienststelle a ON bba.beziehung_zu=a.gml_id ";
$sql.="WHERE g.gml_id='".$gmlid."' ";
$sql.="AND   bba.beziehungsart='gehoertZu' ";
$sql.="AND   a.stellenart=1000;"; // Amtsgericht
*/
// Direkter JOIN zwischen den "ax_buchungsblattbezirk" und "ax_dienststelle".
// Ueber Feld "gehoertzu|ax_dienststelle_schluessel|land" und "stelle"
$sql ="SELECT g.gml_id, g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung AS nr, g.blattart, "; // GB-Blatt
$sql.="b.gml_id, b.bezirk, b.bezeichnung AS beznam, "; // Bezirk
$sql.="a.gml_id, a.land, a.bezeichnung, a.stelle, a.stellenart "; // Amtsgericht
$sql.="FROM  ax_buchungsblatt       g ";
$sql.="JOIN  ax_buchungsblattbezirk b   ON g.land=b.land AND g.bezirk=b.bezirk ";  // BBZ
$sql.="JOIN  ax_dienststelle        a   ON b.\"gehoertzu|ax_dienststelle_schluessel|land\"=a.land AND b.stelle=a.stelle ";
$sql.="WHERE g.gml_id='".$gmlid."' ";
$sql.="AND   a.stellenart=1000;"; // Amtsgericht
// echo "\n<p class='err'>".$sql."</p>\n";
$res=pg_query($con, $sql);
if (!$res) {echo "<p class='err'>Fehler bei Grundbuchdaten<br>\n".$sql."</p>";}
if ($row = pg_fetch_array($res)) {
	$blattart=blattart($row["blattart"]);
	echo "<p class='gbkennz'>Bestand ".$row["bezirk"]." - ".$row["nr"]."&nbsp;</p>\n";
	echo "\n<h2>Grundbuch ALKIS</h2>\n";

	echo "\n<table class='outer'>\n<tr>\n\t<td>";
	echo "\n\t<table class='kennz' title='Bestandskennzeichen'>\n\t<tr>";
	echo "\n\t\t<td class='head'>".dienststellenart($row["stellenart"])."</td>";
	echo "\n\t\t<td class='head'>Bezirk</td>";
	echo "\n\t\t<td class='head'>".$blattart."</td>\n\t</tr>";
	echo "\n\t<tr>";
	echo "\n\t\t<td title='Amtsgerichtsbezirk'>".$row["stelle"]."<br>".htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8")."</td>";
	echo "\n\t\t<td title='Grundbuchbezirk'>".$row["bezirk"]."<br>".htmlentities($row["beznam"], ENT_QUOTES, "UTF-8")."</td>";
	echo "\n\t\t<td title='Grundbuch-Blatt'>".$row["nr"]."</td>";
	echo "\n\t</tr>\n\t</table>\n";
	echo "\n\t</td>\n\t<td>";
	if ($idanzeige) {linkgml($gkz, $gmlid, "Buchungsblatt");}
	echo "\n\t</td>\n</tr>\n</table>";
}
$res="";
$row="";

// ** E I G E N T U E M E R
echo "\n<hr>\n\n<h3>Angaben zum Eigentum</h3>\n";

// Schleife 1: N a m e n s n u m m e r
// Beziehung: ax_namensnummer  >istBestandteilVon>  ax_buchungsblatt
$sql="SELECT n.gml_id, n.laufendenummernachdin1421 AS lfd, n.zaehler, n.nenner, ";
$sql.="n.artderrechtsgemeinschaft AS adr, n.beschriebderrechtsgemeinschaft as beschr, n.eigentuemerart, n.anlass ";
$sql.="FROM  ax_namensnummer   n ";
$sql.="JOIN  alkis_beziehungen b ON b.beziehung_von=n.gml_id ";
$sql.="WHERE b.beziehung_zu='".$gmlid."' "; // id blatt
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
			echo "\n\t\t\t<p class='zus' title='Beschrieb der Rechtsgemeinschaft'>".htmlentities($rown["beschr"], ENT_QUOTES, "UTF-8")."</p>";
		} else {
			echo "\n\t\t\t<p class='zus' title='Art der Rechtsgemeinschaft'>".htmlentities(rechtsgemeinschaft($rown["adr"]), ENT_QUOTES, "UTF-8")."</p>";
		}
	}
	//if ($rown["anlass"] > 0 ) {echo "<p>Anlass=".$rown["anlass"]."</p>";} // TEST:

	//echo "\n\t\t</td>\n\t\t<td></td>\n</tr>";

	// Schleife Ebene 2: andere Namensnummern
	// Beziehung   ax_namensnummer >bestehtAusRechtsverhaeltnissenZu>  ax_namensnummer 

	// Die Relation 'Namensnummer' besteht aus Rechtsverhältnissen zu 'Namensnummer' sagt aus, 
	// dass mehrere Namensnummern zu einer Rechtsgemeinschaft gehören können. 
	// Die Rechtsgemeinschaft selbst steht unter einer eigenen AX_Namensnummer, 
	// die zu allen Namensnummern der Rechtsgemeinschaft eine Relation besitzt.

	// Die Relation 'Namensnummer' hat Vorgänger 'Namensnummer' gibt Auskunft darüber, 
	// aus welchen Namensnummern die aktuelle entstanden ist.

	// Schleife 2: P e r s o n  
	// Beziehung: ax_person  <benennt<  ax_namensnummer
	$sql="SELECT p.gml_id, p.nachnameoderfirma, p.vorname, p.geburtsname, p.geburtsdatum, p.namensbestandteil, p.akademischergrad ";
	$sql.="FROM  ax_person p ";
	$sql.="JOIN  alkis_beziehungen v ON v.beziehung_zu=p.gml_id ";
	$sql.="WHERE v.beziehung_von='".$rown["gml_id"]."' "; // id num
	$sql.="AND   v.beziehungsart='benennt';";
	//echo "\n\t<p class='err'>Schleife Person SQL=<br>".$sql."</p>"; // test

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
		if ($i > 0) {
			echo "\n<tr>\n\t<td></td>\n\t<td>";
		}
		// Spalte 2 = Angaben
		echo "\n\t\t<p class='geig' title='Eigent&uuml;merart ".eigentuemerart($rown["eigentuemerart"])."'>".$diePerson."</p>\n\t</td>";
		// Spalte 3 = Link
		echo "\n\t<td>\n\t\t<p class='nwlink noprint'>\n\t\t\t<a href='alkisnamstruk.php?gkz=".$gkz."&amp;gmlid=".$rowe[0]."&amp;style=".$style;
		if ($idanzeige) { echo "&amp;id=j";}
		echo "' title='vollst&auml;ndiger Name und Adresse eines Eigent&uuml;mers'>Person</a>\n\t\t</p>";
		if ($idanzeige) { linkgml($gkz, $rowe["gml_id"], "Person");}
		echo "\n\t</td>\n</tr>";

		// Schleife 3:  A d r e s s e
		$sql ="SELECT a.gml_id, a.ort_post, a.postleitzahlpostzustellung AS plz, a.strasse, a.hausnummer, a.bestimmungsland ";
		$sql.="FROM   ax_anschrift a ";
		$sql.="JOIN   alkis_beziehungen b ON a.gml_id=b.beziehung_zu ";
		$sql.="WHERE  b.beziehung_von='".$rowe["gml_id"]."' ";
		$sql.="AND    b.beziehungsart='hat';"; //"ORDER  BY ?;";
		//echo "\n<p class='err'>".$sql."</p>\n";
		$resa=pg_query($con,$sql);
		if (!$resa) echo "\n\t<p class='err'>Fehler bei Adressen.<br>\nSQL= ".$sql."</p>\n";
		$j=0;
		while($rowa = pg_fetch_array($resa)) {
			$gmla=$rowa["gml_id"];
			$plz=$rowa["plz"];
			$ort=htmlentities($rowa["ort_post"], ENT_QUOTES, "UTF-8");
			$str=htmlentities($rowa["strasse"], ENT_QUOTES, "UTF-8");
			$hsnr=$rowa["hausnummer"];
			$land=htmlentities($rowa["bestimmungsland"], ENT_QUOTES, "UTF-8");
			// Spalte 1
			echo "\n<tr>\n\t<td>&nbsp;</td>";
			//Spalte 2
			echo "\n\t<td>\n\t\t<p class='gadr'>"; 
			if ($str.$hsnr != "") echo $str." ".$hsnr."<br>";
			//if ($plz.$ort != "")
			echo $plz." ".$ort;
			if ($land != "" and $land != "DEUTSCHLAND") echo ", ".$land;
			echo "</p>\n\t</td>";
			// Spalte 3
			echo "\n\t<td>";
			if ($idanzeige) {linkgml($gkz, $gmla, "Adresse");}
			echo "\n\t</td>\n</tr>";
			$j++;
		}
		// 'keine Adresse' kann vorkommen, z.B. "Deutsche Telekom AG"
		//if ($j == 0) {
		//	echo "\n<tr>\n\t<td></td>";
		//	echo "\n\t<td>\n\t\t<p class='err'>Keine Adressen.</p></td>";
		//	echo "\n\t<td></td>\n<tr>";
		//}
		$i++; // Z. Person

		// als eigene Tab-Zeile?
		// 'Anteil' ist der Anteil der Berechtigten in Bruchteilen (Par. 47 GBO) 
		// an einem gemeinschaftlichen Eigentum (Grundstück oder Recht).
		if ($rown["zaehler"] <> "") {
			echo "\n<tr>\n\t<td></td>\n\t<td><p class='avh' title='Anteil'>".$rown["zaehler"]."/".$rown["nenner"]." Anteil</p>";
			echo "\n</td>\n\t<td></td>\n</tr>";
		}
	}
	/* Wann warnen?
	if ($i == 0) { // keine Pers zur NamNum
		if ($rechtsg != 9999) { // Art der Rechtsgemeinsachft, 0 Eigent. ist Normal bei Sondereigentum
			echo "\n<tr>\n<td>";
			linkgml($gkz, $rown["gml_id"], "Namensnummer");
			echo "</td>\n<td>\n\t\t<p class='err'>Kein Eigent&uuml;mer gefunden. (Rechtsgemeinschaft=".$rechtsg.")</p>";
			echo "\n\t\t\n\t</td>\n\t<td></td>\n<tr>";
		}
	}
	*/
	$n++; // Z.NamNum
}
echo "\n</table>\n";
if ($n == 0) {
	echo "\n<p class='err'>Keine Namensnummer gefunden.</p>";
	echo "\n<p>Bezirk: ".$row["bezirk"].", Blatt: ".$row["nr"].", Blattart ".$row["blattart"]." (".$blattart.")</p>";
	linkgml($gkz, $gmlid, "Buchungsblatt");
}

If ($style == "alkis") { 
} else { // kompakter Style, alles in eine Tabelle quetschen
	echo "\n<hr>\n\n<h3>Flurst&uuml;cke</h3>";
	echo "\n<table class='fs'>";

	echo "\n<tr>";
		echo "\n\t<td class='head' title='laufende Nummer Bestandsverzeichnis (BVNR) = Grundst&uuml;ck'>lfd.Nr</td>";
		echo "\n\t<td class='head'>Buchungsart</td>";	//2
		echo "\n\t<td class='head'>Anteil</td>";		//3
		echo "\n\t<td class='head'>Gemarkung</td>";		//4
		echo "\n\t<td class='head'>Flur</td>";			//5
		echo "\n\t<td class='head' title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'>Flurst.</td>";
		echo "\n\t<td class='head'>Fl&auml;che</td>";
		echo "\n\t<td class='head' title='Link: weitere Auskunft'>weit. Ausk.</td>";

	echo "\n</tr>";
}

// Schleife 1:  B u c h u n g s s t e l l e
// ax_buchungsblatt   >bestehtAus>          ax_buchungsstelle 
//                    <istBestandteilVon<
$sql ="SELECT s.gml_id, s.buchungsart, s.laufendenummer AS lfd, s.beschreibungdesumfangsderbuchung AS udb, s.zaehler, s.nenner, s.nummerimaufteilungsplan AS nrap, s.beschreibungdessondereigentums AS sond ";
$sql.="FROM  ax_buchungsstelle  s ";
$sql.="JOIN  alkis_beziehungen  v ON s.gml_id=v.beziehung_von "; 
$sql.="WHERE v.beziehung_zu='".$gmlid."' ";
$sql.="AND   v.beziehungsart='istBestandteilVon' ";
$sql.="ORDER BY s.laufendenummer;";
$res=pg_query($con,$sql);
if (!$res) echo "<p class='err'>Fehler bei Buchung.</p>\n";
$i=0;
while($row = pg_fetch_array($res)) {

	If ($style == "alkis") { // Ausgabe im ALKIS-Style
		echo "\n\n<h3>Laufende Nummer: ".$row["lfd"]."</h3>";
		echo "\n<p>".buchungsart($row["buchungsart"])."</p>";

		if ($idanzeige) {linkgml($gkz, $row["gml_id"], "Buchungsstelle");}
		if ($row["udb"] != "") {echo "<br>Umfang der Buchung: ".$row["udb"];} // beschreibungdesumfangsderbuchung
		if ($row["zaehler"] != "") {echo "<br>Anteil ".$row["zaehler"]."/".$row["nenner"];}
		if ($row["nrap"] != "") {
			echo "\n<br>Nr. im Aufteilungsplan: ".$row["nrap"]; // nummerimaufteilungsplan
		}
		if ($row["sond"] != "") {
			echo "\n<br>Verbunden mit dem Sondereigentum an: ".$row["sond"]; //beschreibungdessondereigentums
		}

		//echo "\n<h4>Das ".buchungsart($row["buchungsart"])." besteht aus:</h4>";
		echo "\n<h4>Das Grundst&uuml;ck besteht aus:</h4>";

	//} else { // Kompakter Style
	}

	// Schleife 2a: andere Buchungsstellen
	// ax_buchungsstelle  >zu>  ax_buchungsstelle (des gleichen Blattes)
	//                    >an>  ax_buchungsstelle (anderes Blatt, z.B Erbbaurecht >an> )

	// ++++ To Do:  auch suchen?
	// Schleife 2b: Flurstueck
	// ax_buchungsstelle   >verweistAuf>            ax_flurstueck   

	// ax_buchungsstelle   >grundstueckBestehtAus>  ax_flurstueck
	//                     <istGebucht<           

	// F L U R S T U E C K
	$sql="SELECT g.gemarkungsnummer, g.bezeichnung, ";
	$sql.="f.gml_id, f.flurnummer, f.zaehler, f.nenner, f.regierungsbezirk, f.kreis, f.gemeinde, f.amtlicheflaeche ";
	$sql.="FROM ax_gemarkung g ";
	$sql.="JOIN ax_flurstueck f ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer ";
	$sql.="JOIN alkis_beziehungen v ON f.gml_id=v.beziehung_von "; 
	$sql.="WHERE v.beziehung_zu='".$row["gml_id"]."' "; // id buchungsstelle
	$sql.="AND   v.beziehungsart='istGebucht' ";
	$sql.="ORDER BY f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner;";

	$resf=pg_query($con,$sql);
	if (!$resf) {echo "<p class='err'>Fehler bei Flurst&uuml;ck<br><br>".$sql."</p>\n";}
	$j=0;
	while($rowf = pg_fetch_array($resf)) {
		$fskenn=$rowf["zaehler"];
		if ($rowf["nenner"] != "") {$fskenn.="/".$rowf["nenner"];}
		$flae=number_format($rowf["amtlicheflaeche"],0,",",".") . " m&#178;";

		If ($style == "alkis") { // Darstellung ALKIS-Like
	
			echo "\n<table class='outer'>\n<tr>";
			echo "\n\t<td>";
			echo "\n\t\t<h6>Flurst&uuml;ck ".$fskenn.", Flur ".$rowf["flurnummer"].", Gemarkung ".$rowf["gemarkungsnummer"]." ".$rowf["bezeichnung"]."</h6>";
			echo "\n\t</td>";
	
			echo "\n\t<td>";
			echo "\n\t\t<p class='nwlink noprint'><a  href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$rowf["gml_id"]."&amp;eig=n"."&amp;style=".$style;
			if ($idanzeige) { echo "&amp;id=j";}
			echo "' title='Flurst&uuml;cksnachweis'>FS-Nachweis</a></p>";
			if ($idanzeige) {linkgml($gkz, $rowf["gml_id"], "Flurst&uuml;ck");}
			echo "\n\t</td>\n</tr>\n</table>";

			//echo "\n</tr>\n<table>";
	
	/*		echo "\n<tr>\n\t<td>Gebietszugeh&ouml;rigkeit:</td>";
			echo "\n\t<td>Gemeinde ".$rowf["gemeinde"]."<br>";
			echo "Kreis ".$rowf["kreis"]."<br>";
			echo "Regierungsbezirk ".$rowf["regierungsbezirk"]."</td>\n</tr>";
	
			echo "\n<tr>\n\t<td>Lage:</td>";
			echo "\n\t<td>(noch in Arbeit)</td>\n</tr>";
	
			echo "\n<tr>\n\t<td>Tats&auml;chliche Nutzung:</td>";
			echo "\n\t<td>(noch in Arbeit)</td>\n</tr>";
	*/
			//echo "\n<tr>\n\t<td>";
	
			echo "\n<p>Fl&auml;che: ";
			//echo "</td>\n\t<td>";
			echo $flae."</p>";
			//echo "</td>\n</tr>";
		//echo "\n</table>";
	
		} else { // kompakter Style
			echo "\n<tr>"; // eine Zeile je Flurstueck
				// Sp. 1-3 aus Buchungsstelle
				echo "\n\t<td>".$row["lfd"];
				if ($idanzeige) {linkgml($gkz, $row["gml_id"], "Buchungsstelle");}
				echo "</td>";

				echo "\n\t<td>".buchungsart($row["buchungsart"])."</td>";

				echo "\n\t<td>";
				if ($row["zaehler"] != "") {echo $row["zaehler"]."/".$row["nenner"];}
				echo "</td>";

				//Sp. 4-7 aus Flurstueck
				echo "\n\t<td>".$rowf["gemarkungsnummer"]." ".$rowf["bezeichnung"]."</td>";

				echo "\n\t<td>".$rowf["flurnummer"]."</td>";

				echo "\n\t<td>".$fskenn."</a>";

				if ($idanzeige) {linkgml($gkz, $rowf["gml_id"], "Flurst&uuml;ck");}
				echo "</td>";

				echo "\n\t<td class='fla'>".$flae."</td>";

				echo "\n\t<td><p class='nwlink noprint'>";
				echo "\n\t\t<a  href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$rowf["gml_id"]."&amp;eig=n"."&amp;style=".$style;
				if ($idanzeige) { echo "&amp;id=j";}
				echo "' title='Flurst&uuml;cksnachweis'>FS-Nachw.</a>";
				echo "</p></td>";

			echo "\n</tr>";
		}
		$j++;
	} // Ende Schleife Flurstueck
	if ($j == 0) {
		echo "\n<p class='err'>Kein Flurst&uuml;ck gefunden.</p>";
		linkgml($gkz, $row["gml_id"], "Buchungststelle");
	}
	If ($style == "alkis") {
	} else { // Kompakter Style
		if ($row["nrap"] != "") {
			echo "\n<tr>\n\t<td></td>\n\t<td colspan=6>Nr. im Aufteilungsplan: ".$row["nrap"]."</td>\n<tr>"; // nummerimaufteilungsplan
		}
		if ($row["sond"] != "") { // ++ style-class ?
			echo "\n<tr>\n\t<td></td>\n\t<td colspan=6>Verbunden mit dem Sondereigentum an: ".$row["sond"]."</td>\n<tr>"; //beschreibungdessondereigentums
		}
	}
	$i++; 
} // Ende Schleife Buchungsstelle

If ($style == "alkis") { 
} else { // kompakter Style
	echo "\n</table>";
}

if ($i == 0) {
	echo "\n<p class='err'>Keine Buchung gefunden.</p>\n";
	linkgml($gkz, $gmlid, "Buchungsblatt");
}
?>

<form action=''>
	<div class='buttonbereich noprint'>
	<hr>
		<input type='button' name='back'  value='&lt;&lt;' title='Zur&uuml;ck'             onClick='javascript:history.back()'>&nbsp;
		<input type='button' name='print' value='Druck'    title='Seite Drucken'           onClick='window.print()'>&nbsp;
		<input type='button' name='close' value='X'        title='Fenster schlie&szlig;en' onClick='window.close()'>
	</div>
</form>
<?php footer($gkz, $gmlid, $idanzeige, $self, $hilfeurl, $style); ?>
</body>
</html>