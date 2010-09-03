<?php
/*	Modul: alkisbestnw.php
	Version:
	31.08.2010	$style=ALKIS entfernt, alles Kompakt
	02.09.2010  Mit Icons

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Bestandsnachweis fuer ein Grundbuch aus ALKIS PostNAS
	Parameter:	&gkz= &gmlid
*/
//ini_set('error_reporting', 'E_ALL & ~ E_NOTICE');
ini_set('error_reporting', 'E_ALL');
session_start();
// Bindung an Mapbender-Authentifizierung
require_once("/data/mapwww/http/php/mb_validateSession.php");
require_once("/data/conf/alkis_www_conf.php");
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
	<title>ALKIS Bestandsnachweis</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Grundbuch.ico">
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
//$style=isset($_GET["style"]) ? $_GET["style"] : "kompakt";
$dbname = 'alkis05' . $gkz;
$con = pg_connect("host=".$dbhost." port=".$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) echo "<p class='err'>Fehler beim Verbinden der DB</p>\n";

// G R U N D B U C H// Direkter JOIN zwischen den "ax_buchungsblattbezirk" und "ax_dienststelle".
// Ueber Feld "gehoertzu|ax_dienststelle_schluessel|land" und "stelle".
//	Bei JOIN ueber alkis_beziehungen entgegen Dokumentation keine Verbindung gefunden.
$sql ="SELECT g.gml_id, g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung AS nr, g.blattart, "; // GB-Blatt
$sql.="b.gml_id, b.bezirk, b.bezeichnung AS beznam, "; // Bezirk
$sql.="a.gml_id, a.land, a.bezeichnung, a.stelle, a.stellenart "; // Amtsgericht
$sql.="FROM  ax_buchungsblatt  g ";
$sql.="JOIN  ax_buchungsblattbezirk b ON g.land=b.land AND g.bezirk=b.bezirk ";  // BBZ
$sql.="JOIN  ax_dienststelle a ON b.\"gehoertzu|ax_dienststelle_schluessel|land\"=a.land AND b.stelle=a.stelle ";
$sql.="WHERE g.gml_id='".$gmlid."' ";
$sql.="AND   a.stellenart=1000;"; // Amtsgericht
// echo "\n<p class='err'>".$sql."</p>\n";
$res=pg_query($con, $sql);
if (!$res) {echo "<p class='err'>Fehler bei Grundbuchdaten<br>\n".$sql."</p>";}
if ($row = pg_fetch_array($res)) {
	$blattart=blattart($row["blattart"]);

	// Balken	
	echo "<p class='gbkennz'>ALKIS Bestand ".$row["bezirk"]." - ".$row["nr"]."&nbsp;</p>\n";

	echo "\n<h2><img src='ico/Grundbuch.ico' width='16' height='16' alt=''> Grundbuch</h2>";

	// Kennzeichen im Rahmen
	echo "\n<table class='outer'>\n<tr>\n\t<td>";
		echo "\n\t<table class='kennz' title='Bestandskennzeichen'>";
			echo "\n\t<tr>";
				echo "\n\t\t<td class='head'>".dienststellenart($row["stellenart"])."</td>";
				echo "\n\t\t<td class='head'>Bezirk</td>";
				echo "\n\t\t<td class='head'>".$blattart."</td>";
			echo "\n\t</tr>\n\t<tr>";
				echo "\n\t\t<td title='Amtsgerichtsbezirk'><span class='key'>".$row["stelle"]."</span><br>".htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8")."</td>";
				echo "\n\t\t<td title='Grundbuchbezirk'><span class='key'>".$row["bezirk"]."</span><br>".htmlentities($row["beznam"], ENT_QUOTES, "UTF-8")."</td>";
				echo "\n\t\t<td title='Grundbuch-Blatt'><span class='wichtig'>".$row["nr"]."</span></td>";
			echo "\n\t</tr>";
		echo "\n\t</table>";
		echo "\n\n\t</td>\n\t<td>";
		if ($idanzeige) linkgml($gkz, $gmlid, "Buchungsblatt");
	echo "\n\t</td>\n</tr>\n</table>";
}

// E I G E N T U E M E R
if ($row["blattart"] == 5000) { 
	echo "\n<p>Keine Angaben zum Eigentum bei fiktivem Blatt</p>\n";
	echo "\n<p>Siehe weitere Grundbuchbl&auml;tter mit Rechten an dem fiktiven Blatt.</p>\n";
	// ++++  nuetzlich waere hier: Liste der Grundbuecher mit Recht ueber "an"-Beziehung	
	
} else {// kein Eigent. bei fiktiv. Blatt
	echo "\n<h3><img src='ico/Eigentuemer_2.ico' width='16' height='16' alt=''> Angaben zum Eigentum</h3>\n";
	$n = eigentuemer($con, $gkz, $idanzeige, $gmlid, true); // hier mit Adressen
	if ($n == 0) { // keine Namensnummer, kein Eigentuemer
		echo "\n<p class='err'>Keine Namensnummer gefunden.</p>";
		echo "\n<p>Bezirk: ".$row["bezirk"].", Blatt: ".$row["nr"].", Blattart ".$row["blattart"]." (".$blattart.")</p>";
		linkgml($gkz, $gmlid, "Buchungsblatt");
	}
}
$res="";
$row="";
echo "\n<hr>\n\n<h3><img src='ico/Flurstueck.ico' width='16' height='16' alt=''> Flurst&uuml;cke</h3>";
echo "\n<table class='fs'>";
// Kopf der Tabelle
echo "\n<tr>\n\t<td class='head' title='laufende Nummer Bestandsverzeichnis (BVNR) = Grundst&uuml;ck'>&nbsp;&nbsp;&nbsp;&nbsp;lfd.Nr</td>";
echo "\n\t<td class='head'>Buchungsart</td>";	//2
echo "\n\t<td class='head'>Anteil</td>";		//3
echo "\n\t<td class='head'>Gemarkung</td>";		//4
echo "\n\t<td class='head'>Flur</td>";			//5
echo "\n\t<td class='head' title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'>Flurst.</td>";
echo "\n\t<td class='head fla'>Fl&auml;che</td>";
echo "\n\t<td class='head nwlink' title='Link: weitere Auskunft'>weit. Auskunft</td>\n</tr>";

// Blatt ->  B u c h u n g s s t e l l e
// ax_buchungsblatt   >bestehtAus>         ax_buchungsstelle 
// ax_buchungsblatt   <istBestandteilVon<  ax_buchungsstelle 
$sql ="SELECT s.gml_id, s.buchungsart, s.laufendenummer AS lfd, s.beschreibungdesumfangsderbuchung AS udb, s.zaehler, s.nenner, s.nummerimaufteilungsplan AS nrap, s.beschreibungdessondereigentums AS sond ";
$sql.="FROM  ax_buchungsstelle  s ";
$sql.="JOIN  alkis_beziehungen  v ON s.gml_id=v.beziehung_von "; 
$sql.="WHERE v.beziehung_zu='".$gmlid."' ";
$sql.="AND   v.beziehungsart='istBestandteilVon' ";
$sql.="ORDER BY s.laufendenummer;";
$res=pg_query($con,$sql);
if (!$res) echo "<p class='err'>Fehler bei Buchung.</p>\n";
$i=0;
while($row = pg_fetch_array($res)) {	$lfdnr  = $row["lfd"];
	$bvnr   = str_pad($lfdnr, 4, "0", STR_PAD_LEFT);
	$gml_bs = $row["gml_id"]; // id der buchungsstelle
	$ba     = buchungsart($row["buchungsart"]);
	if ($row["zaehler"] == "") {
		$anteil = "";
	} else {
		$anteil = $row["zaehler"]."/".$row["nenner"];
	}

	// F l u r s t u e c k s d a t e n  zur direkten Buchungsstelle   $j = bnw_fsdaten($con, $gkz, $idanzeige, $lfdnr, $gml_bs, $ba, $anteil, true); // return = Anzahl der FS

	if ($row["nrap"] != "") {
		echo "\n<tr>\n\t<td class='sond' colspan=8>Nr. im Aufteilungsplan: ".$row["nrap"]."</td>\n<tr>";
	}
	if ($row["sond"] != "") {
		echo "\n<tr>\n\t<td class='sond' colspan=8>Verbunden mit dem Sondereigentum an: ".$row["sond"]."</td>\n<tr>";
	}

	if ($j == 0) { //  k e i n e  Flurstuecke gefunden (Miteigentumsnteil usw.)		// Bei "normalen" Grundstuecken wurden Flurstuecksdaten gefunden und ausgegeben.
		// Bei Miteigentumsanteil, Erbbaurecht usw. muss nach weiteren Buchungsstellen gesucht werden:
		//  Buchungsstelle >an> Buchungsstelle >istBestandTeilVon>  "FiktivesBlatt (ohne) Eigentuemer"

		// andere Buchungsstellen
		// ax_buchungsstelle  >zu>  ax_buchungsstelle (des gleichen Blattes)
		// ax_buchungsstelle  >an>  ax_buchungsstelle (anderes Blatt, z.B Erbbaurecht >an> )

		// a n d e r e  Buchungsstelle ("an"-Beziehung)
		$sql ="SELECT s.gml_id, s.buchungsart, s.laufendenummer AS lfd, s.beschreibungdesumfangsderbuchung AS udb, s.nummerimaufteilungsplan AS nrap, s.beschreibungdessondereigentums AS sond ";
		// , s.zaehler, s.nenner
		$sql.="FROM  ax_buchungsstelle  s ";
		$sql.="JOIN  alkis_beziehungen  v ON s.gml_id=v.beziehung_zu "; 
		$sql.="WHERE v.beziehung_von='".$gml_bs."' "; // id buchungsstelle (fiktives Blatt)
		//$sql.="AND   v.beziehungsart='an' ";
		$sql.="AND   (v.beziehungsart='an' OR v.beziehungsart='zu') ";
		$sql.="ORDER BY s.laufendenummer;";
		//echo "<br><p class='err'>".$sql."</p><br>";

		$resan=pg_query($con,$sql);
		if (!$resan) {echo "<p class='err'>Fehler bei andere Buchungsstelle<br><br>".$sql."</p>\n";}
		$a=0;
		while($rowan = pg_fetch_array($resan)) {
			// auch suchen?			// ax_buchungsstelle  >verweistAuf>           ax_flurstueck   
			// ax_buchungsstelle  >grundstueckBestehtAus> ax_flurstueck
			// ax_buchungsstelle  <istGebucht<            ax_flurstueck
			$lfdnran = $rowan["lfd"];
			$gml_bsan= $rowan["gml_id"]; // id der buchungsstelle
			$baan =	buchungsart($rowan["buchungsart"]);

			// Fiktives Blatt
			$sql ="SELECT b.gml_id, b.land, b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung AS blatt ";
			$sql.="FROM  ax_buchungsblatt   b ";
			$sql.="JOIN  alkis_beziehungen  v ON b.gml_id=v.beziehung_zu "; 
			$sql.="WHERE v.beziehung_von='".$gml_bsan."' ";
			$sql.="AND   v.beziehungsart='istBestandteilVon' ";
			$sql.="ORDER BY b.land, b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung;";
			
			$fbres=pg_query($con,$sql);
			if (!$fbres) {echo "<p class='err'>Fehler bei fiktivem Blatt<br><br>".$sql."</p>\n";}
			$b=0;
			while($fbrow = pg_fetch_array($fbres)) { // genau 1
				$fbgml   = $fbrow["gml_id"];
				$fbland  = $fbrow["land"];
				$fbbez   = $fbrow["bezirk"];
				$fbblatt = $fbrow["blatt"];
				$b++;
			}
			if ($b <> 1) echo "<p class='err'>Anzahl fiktive Bl&auml;tter zu anderer Buchungstelle = ".$b."</p>";

			// G r u n d b u c h d a t e n  zur  a n d e r e n  Buchungsstelle  (fiktives Blatt, Recht "an" ...)	
			//$bvnran=str_pad($lfdnran, 4, "0", STR_PAD_LEFT);
			// Kompakter Style			
			echo "\n<tr>\n\t<td>".$bvnr; // Sp.1 Erbbau BVNR
			if ($idanzeige) linkgml($gkz, $gml_bs, "Buchungsstelle");
			echo "</td>";
			echo "\n\t<td>".$ba." an</td>"; // Sp.2 Buchung
			echo "\n\t<td>".$anteil."</td>"; // Sp.3 Anteil   ++++ LEER !!?? Wieso
			echo "\n\t<td>Bezirk ".$fbbez."</td>"; // Sp.4 Gemkg, hier Bezirk ++++ entschluesseln?
			echo "\n\t<td></td>"; // Sp.5 Flur
			echo "\n\t<td>Blatt ".$fbblatt."</td>"; // Sp.6 Flurst
			echo "\n\t<td></td>"; // Sp.7 Flaeche
			echo "\n\t<td>";  // Sp.8 Link
			echo "<p class='nwlink'>an <a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$fbgml;
			if ($idanzeige) echo "&amp;id=j";
			echo "' title='Grundbuchnachweis fiktives Blatt'>GB</a></p></td>\n</tr>"; 

			// F l u r s t u e c k s d a t e n  zur  a n d e r e n  Buchungsstelle  (fiktives Blatt, Recht "an" ...)		   $aj = bnw_fsdaten($con, $gkz, $idanzeige, $lfdnran, $gml_bsan, $baan, $anteil, false); // return = Anzahl der FS
			// +++ Gibt es ueberhaupt Sondereigentum beim fiktiven Blatt??

			// Kompakter Style
			if ($rowan["nrap"] != "") {
				echo "\n<tr>\n\t<td class='sond' colspan=8>Nr. im Aufteilungsplan: ".$rowan["nrap"]."</td>\n<tr>";
			}
			if ($rowan["sond"] != "") {
				echo "\n<tr>\n\t<td class='sond' colspan=8>Verbunden mit dem Sondereigentum an: ".$rowan["sond"]."</td>\n<tr>";
			}

			$a++;
			if ($aj == 0) { // keine Flurstuecke gefunden
				echo "<p>keine Flurst&uuml;cke zu anderer Buchung gefunden</p>";
			}
		}
		if ($a == 0) {
			echo "\n<p class='err'>Keine andere Buchungstelle gefunden.</p>\n";
			linkgml($gkz, $$gml_bs, "Buchungsstelle");
		}
	}
	$i++; 
} // Ende Buchungsstelle

echo "\n</table>";
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
<?php footer($gkz, $gmlid, $idanzeige, $self, $hilfeurl, ""); ?>
</body>
</html>