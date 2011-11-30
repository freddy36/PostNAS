<?php
/*	Modul: alkisbestnw.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Bestandsnachweis fuer ein Grundbuch aus ALKIS PostNAS

	Version:	17.11.2011  Parameter der Functions geändert
	22.11.2011  Feldname land in ax_buchungsblattbezirk geändert
	30.11.2011  import_request_variables

	ToDo:
	Zahler fuer Anzahl GB und FS in der Liste (ausgeben wenn > 10)
*/
session_start();
import_request_variables("G");
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
	<meta name="author" content="F. Jaeger krz" >
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ALKIS Bestandsnachweis</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Grundbuch.ico">
	<style type='text/css' media='print'>
		.noprint {visibility: hidden;}
	</style>
</head>
<body>
<?php
$con = pg_connect("host=".$dbhost." port=".$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) echo "<p class='err'>Fehler beim Verbinden der DB</p>\n";

// G R U N D B U C H// Direkter JOIN zwischen den "ax_buchungsblattbezirk" und "ax_dienststelle".
// Ueber Feld "gehoertzu|ax_dienststelle_schluessel|land" und "stelle".
//	Bei JOIN ueber alkis_beziehungen entgegen Dokumentation keine Verbindung gefunden.
$sql ="SELECT g.gml_id, g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung AS nr, g.blattart, "; // GB-Blatt
$sql.="b.gml_id, b.bezirk, b.bezeichnung AS beznam, "; // Bezirk
$sql.="a.gml_id, a.land, a.bezeichnung, a.stelle, a.stellenart "; // Amtsgericht
$sql.="FROM ax_buchungsblatt g ";
$sql.="LEFT JOIN ax_buchungsblattbezirk b ON g.land=b.land AND g.bezirk=b.bezirk ";  // BBZ
//$sql.="LEFT JOIN ax_dienststelle a ON b.\"gehoertzu|ax_dienststelle_schluessel|land\"=a.land AND b.stelle=a.stelle ";
$sql.="LEFT JOIN ax_dienststelle a ON b.land = a.land AND b.stelle = a.stelle ";
$sql.="WHERE g.gml_id= $1 ";
$sql.="AND a.stellenart=1000;"; // Amtsgericht

$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);

if (!$res) {
	echo "<p class='err'>Fehler bei Grundbuchdaten.</p>";
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}
if ($row = pg_fetch_array($res)) {
	$blattkey=$row["blattart"]; // Schluessel
	$blattart=blattart($blattkey);
	echo "<p class='gbkennz'>ALKIS Bestand ".$row["bezirk"]." - ".$row["nr"]."&nbsp;</p>\n"; // Balken
	echo "\n<h2><img src='ico/Grundbuch.ico' width='16' height='16' alt=''> Grundbuch</h2>";	echo "\n<table class='outer'>\n<tr>\n\t<td>"; // Kennzeichen im Rahmen
		if ($blattkey == 1000) {
			echo "\n\t<table class='kennzgb' title='Bestandskennzeichen'>";
		} else {
			echo "\n\t<table class='kennzgbf' title='Bestandskennzeichen'>"; // dotted
		}
			echo "\n\t<tr>";
				echo "\n\t\t<td class='head'>".dienststellenart($row["stellenart"])."</td>";
				echo "\n\t\t<td class='head'>Bezirk</td>";
				echo "\n\t\t<td class='head'>".$blattart."</td>";
			echo "\n\t</tr>\n\t<tr>";
				echo "\n\t\t<td title='Amtsgerichtsbezirk'>";
				if ($showkey) {
					echo "<span class='key'>".$row["stelle"]."</span><br>";
				}
				echo htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8")."</td>";
				echo "\n\t\t<td title='Grundbuchbezirk'>";
				if ($showkey) {
					echo "<span class='key'>".$row["bezirk"]."</span><br>";
				}
				echo htmlentities($row["beznam"], ENT_QUOTES, "UTF-8")."</td>";
				echo "\n\t\t<td title='Grundbuch-Blatt'><span class='wichtig'>".$row["nr"]."</span></td>";
			echo "\n\t</tr>";
		echo "\n\t</table>";

		echo "\n\n\t</td>\n\t<td>";
		if ($idanzeige) {linkgml($gkz, $gmlid, "Buchungsblatt");}
	echo "\n\t</td>\n</tr>\n</table>";
}

if ($blattkey == 5000) { // fikt. Blatt
	echo "\n<p>Keine Angaben zum Eigentum bei fiktivem Blatt.</p>\n";
} else { // E I G E N T U E M E R
	echo "\n<h3><img src='ico/Eigentuemer_2.ico' width='16' height='16' alt=''> Angaben zum Eigentum</h3>\n";
	$n = eigentuemer($con, $gmlid, true, ""); // MIT Adressen.
	if ($n == 0) { // keine Namensnummer, kein Eigentuemer
		echo "\n<p class='err'>Keine Namensnummer gefunden.</p>";
		echo "\n<p>Bezirk: ".$row["bezirk"].", Blatt: ".$row["nr"].", Blattart ".$blattkey." (".$blattart.")</p>";
		linkgml($gkz, $gmlid, "Buchungsblatt");
	}
}
// Vorab pruefen, ob Sonderfall "Rechte an .." vorliegt.
if ($blattkey == 1000) { // Grundbuchblatt
	$sql ="SELECT count(z.laufendenummer) AS anzahl ";
	$sql.="FROM alkis_beziehungen v ";
	$sql.="JOIN ax_buchungsstelle s ON v.beziehung_von=s.gml_id "; // Blatt
	$sql.="JOIN alkis_beziehungen x ON x.beziehung_von=s.gml_id "; 
	$sql.="JOIN ax_buchungsstelle z ON x.beziehung_zu=z.gml_id "; // andere B-Stelle
	$sql.="WHERE v.beziehung_zu= $1 AND v.beziehungsart='istBestandteilVon' AND (x.beziehungsart='an' OR x.beziehungsart='zu');";
	$v=array($gmlid);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) echo "<p class='err'>Fehler bei Suche nach Buchungen.</p>\n";	$row=pg_fetch_array($res);
	$anz=$row["anzahl"];
	//echo "<p>Zeilen : ".$anz." zu Blattart ".$blattkey."</p>";
} else { // 2000: Katasterblatt, 3000: Pseudoblatt, 5000: Fiktives Blatt
	$anz=0;
}
if ($anz > 0) {
	echo "\n<hr>\n\n<h3><img src='ico/Flurstueck.ico' width='16' height='16' alt=''> Rechte und Flurst&uuml;cke</h3>";
	echo "\n<table class='fs'>";
	echo "\n<tr>"; // 2 Kopfzeilen
		echo "\n\t<td>&nbsp;</td>";
		echo "\n\t<td class='dien' title='herrschendes Grundst&uuml;ck'>herrschende Buchungsart</td>";
		echo "\n\t<td>&nbsp;</td>";
		echo "\n\t<td class='dien'>Bezirk</td>";
		echo "\n\t<td class='dien'>Blatt</td>";
		echo "\n\t<td class='dien'>BVNR</td>";
		echo "\n\t<td class='dien' title='dienendes Grundst&uuml;ck'>Buchungsart</td>";
		echo "\n\t<td>&nbsp;</td>";
	echo "\n</tr>";
} else {
	echo "\n<hr>\n\n<h3><img src='ico/Flurstueck.ico' width='16' height='16' alt=''> Flurst&uuml;cke</h3>";
	echo "\n<table class='fs'>";
}

echo "\n<tr>";
	echo "\n\t<td class='head' title='laufende Nummer Bestandsverzeichnis (BVNR) = Grundst&uuml;ck'><span class='wichtig'>BVNR</span></td>";
	echo "\n\t<td class='head'>Buchungsart</td>";
	echo "\n\t<td class='head'>Anteil</td>";
	echo "\n\t<td class='head'>Gemarkung</td>";
	echo "\n\t<td class='head'>Flur</td>";
	echo "\n\t<td class='head' title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'><span class='wichtig'>Flurst.</span></td>";
	echo "\n\t<td class='head fla'>Fl&auml;che</td>"; // 7
	echo "\n\t<td class='head nwlink noprint' title='Link: weitere Auskunft'>weit. Auskunft</td>";
echo "\n</tr>";

// Blatt ->  B u c h u n g s s t e l l e
// ax_buchungsblatt <istBestandteilVon< ax_buchungsstelle 
$sql ="SELECT s.gml_id, s.buchungsart, s.laufendenummer AS lfd, s.beschreibungdesumfangsderbuchung AS udb, ";
$sql.="s.zaehler, s.nenner, s.nummerimaufteilungsplan AS nrap, s.beschreibungdessondereigentums AS sond, b.bezeichner as bart ";
$sql.="FROM ax_buchungsstelle s ";
$sql.="JOIN alkis_beziehungen v ON s.gml_id=v.beziehung_von "; 
$sql.="LEFT JOIN ax_buchungsstelle_buchungsart b ON s.buchungsart = b.wert ";
$sql.="WHERE v.beziehung_zu= $1 AND v.beziehungsart='istBestandteilVon' ";
$sql.="ORDER BY s.laufendenummer;";

$v=array($gmlid);
$res=pg_prepare("", $sql);
$res=pg_execute("", $v);

if (!$res) {
	echo "<p class='err'>Fehler bei Buchung.</p>\n";
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}
$i=0;
while($row = pg_fetch_array($res)) {
	$lfdnr  = $row["lfd"];
	$bvnr   = str_pad($lfdnr, 4, "0", STR_PAD_LEFT);
	$gml_bs = $row["gml_id"]; // id der buchungsstelle
	$ba     = $row["bart"]; // Buchungsart aus Schluesseltabelle

	if ($row["zaehler"] == "") {
		$anteil = "";
	} else {
		$anteil = $row["zaehler"]."/".$row["nenner"];
	}
	// F l u r s t u e c k s d a t e n  zur direkten Buchungsstelle   $j = bnw_fsdaten($con, $lfdnr, $gml_bs, $ba, $anteil, true); // return = Anzahl der FS
	if ($j == 0) { //  k e i n e  Flurstuecke gefunden (Miteigentumsnteil usw.)		// Bei "normalen" Grundstuecken wurden Flurstuecksdaten gefunden und ausgegeben.
		// Bei Miteigentumsanteil, Erbbaurecht usw. muss nach weiteren Buchungsstellen gesucht werden:
		//  Buchungsstelle >an/zu> (andere)Buchungsstelle >istBestandTeilVon>  "FiktivesBlatt (ohne) Eigentuemer"

		// andere Buchungsstellen
		//  ax_buchungsstelle  >zu>  ax_buchungsstelle (des gleichen Blattes)
		//  ax_buchungsstelle  >an>  ax_buchungsstelle (anderes Blatt, z.B Erbbaurecht an)

		// aktuelles Blatt (herrschendes GB) hat Recht "an" fiktives Blatt (dienendes GB-Blatt)
		// a n d e r e  Buchungsstelle
		$sql ="SELECT s.gml_id, s.buchungsart, s.laufendenummer AS lfd, s.beschreibungdesumfangsderbuchung AS udb, ";
		$sql.="v.beziehungsart, s.nummerimaufteilungsplan AS nrap, s.beschreibungdessondereigentums AS sond, b.bezeichner AS bart ";		$sql.="FROM ax_buchungsstelle s ";
		$sql.="JOIN alkis_beziehungen v ON s.gml_id=v.beziehung_zu "; 		$sql.="LEFT JOIN ax_buchungsstelle_buchungsart b ON s.buchungsart = b.wert ";
		$sql.="WHERE v.beziehung_von= $1 "; // id buchungsstelle (fiktives Blatt)		$sql.="AND (v.beziehungsart='an' OR v.beziehungsart='zu') ";
		$sql.="ORDER BY s.laufendenummer;";
		$v=array($gml_bs);
		$resan=pg_prepare("", $sql);
		$resan=pg_execute("", $v);
		//$resan=pg_query($con,$sql);
		if (!$resan) {
			echo "<p class='err'>Fehler bei 'andere Buchungsstelle'.</p>\n";
			if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."</p>";}
		}
		$a=0; // count: andere BS
		$altbvnr=""; // Gruppenwechsel
		while($rowan = pg_fetch_array($resan)) {
			$lfdnran = $rowan["lfd"];		// BVNR an
			$gml_bsan= $rowan["gml_id"];	// id der buchungsstelle an
			$baan= $rowan["bart"];  		// Buchungsart an, entschluesselt

			// a n d e r e s   B l a t t  (an dem das aktuelle Blatt Rechte hat)
			// dienendes Grundbuch
			$sql ="SELECT b.gml_id, b.land, b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung AS blatt, b.blattart, z.bezeichnung AS beznam ";
			$sql.="FROM ax_buchungsblatt  b ";
			$sql.="JOIN alkis_beziehungen v ON b.gml_id=v.beziehung_zu ";
			$sql.="LEFT JOIN ax_buchungsblattbezirk z ON b.land=z.land AND b.bezirk=z.bezirk ";
			$sql.="WHERE v.beziehung_von= $1 ";
			$sql.="AND v.beziehungsart='istBestandteilVon' ";
			$sql.="ORDER BY b.land, b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung;";
			$v=array($gml_bsan);
			$fbres=pg_prepare("", $sql);
			$fbres=pg_execute("", $v);
			//$fbres=pg_query($con,$sql);
			if (!$fbres) {
				echo "<p class='err'>Fehler bei fiktivem Blatt.</p>\n";
				if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."</p>";}			
			}
			$b=0;
			while($fbrow = pg_fetch_array($fbres)) { // genau 1
				$fbgml   = $fbrow["gml_id"];
				$fbland  = $fbrow["land"];
				$fbbez   = $fbrow["bezirk"];
				$fbblatt = $fbrow["blatt"];
				$fbbart  = blattart($fbrow["blattart"]);
				$beznam	= $fbrow["beznam"];
				$b++;
			}
			if ($b != 1) {
				echo "<p class='err'>Anzahl fiktive Bl&auml;tter zu anderer Buchungstelle = ".$b."</p>";
			}

			// G r u n d b u c h d a t e n  zur  a n d e r e n  Buchungsstelle
			echo "\n<tr>";
				echo"\n\t<td>";
					if($bvnr == $altbvnr) {	// gleiches Grundstueck
						echo "&nbsp;"; // Anzeige unterdruecken
					} else {
						echo "<a name='bvnr".$lfdnr."'></a>"; // Sprungmarke
						echo "<span class='wichtig'>".$bvnr."</span>"; // Sp.1 Erbbau BVNR
						if ($idanzeige) {linkgml($gkz, $gml_bs, "Buchungsstelle");}
						$altbvnr = $bvnr; // Gruppenwechsel merken
					}
				echo "</td>";
				echo "\n\t<td class='dien'>"; // Sp.2 Buchung
					if ($showkey) {
						echo "<span class='key'>".$row["buchungsart"]."</span> ";
					}
				echo $ba." an</td>";
				echo "\n\t<td>".$anteil."</td>"; // Sp.3 Anteil
				echo "\n\t<td class='dien'>"; // Sp.4 Gemarkg. hier Bezirk
					if ($showkey) {
						echo "<span class='key'>".$fbbez."</span> ";
					}
					echo $beznam;
				echo "</td>"; // Sp.4 hier Bezirk
				echo "\n\t<td class='dien'>"; // Sp. 5 Blatt
					echo $fbblatt; // Sp.6 BVNR
					if ($idanzeige) {
						linkgml($gkz, $fbgml, "Buchungsblatt");
					}
				echo "</td>";
				echo "\n\t<td class='dien'>"; // BVNR
					echo str_pad($lfdnran, 4, "0", STR_PAD_LEFT);
					if ($idanzeige) {
						linkgml($gkz, $gml_bsan, "Buchungsstelle");
					}

				echo "</td>"; 
				echo "\n\t<td class='dien'>"; // Sp.7 Buchungsart
					if ($showkey) {
						echo "<span class='key'>".$rowan["buchungsart"]."</span> ";
					}
					echo $baan." ";
				echo "</td>";
				echo "\n\t<td>";  // Sp.8 Link ("an" oder "zu" ?)
					echo "<p class='nwlink'>".$rowan["beziehungsart"];
					echo " <a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$fbgml;
						if ($idanzeige) {echo "&amp;id=j";}
						if ($showkey)   {echo "&amp;showkey=j";}
						echo "#bvnr".$lfdnran; // Sprungmarke auf der Seite
						echo "' title='Grundbuchnachweis des dienenden Blattes'>";
						echo $fbbart;
					echo " <img src='ico/GBBlatt_link.ico' width='16' height='16' alt=''></a></p>";
				echo "</td>";
			echo "\n</tr>"; 

			// F l u r s t u e c k s d a t e n  zur  a n d e r e n  Buchungsstelle
			// Buchungsart wird nur in erster Zeile ausgegeben, hier leer
		   $aj = bnw_fsdaten($con, $lfdnran, $gml_bsan, "", $anteil, false); // return = Anzahl der FS
		   		   
			// +++ Gibt es ueberhaupt Sondereigentum beim fiktiven Blatt??			if ($rowan["nrap"] != "") {
				echo "\n<tr>";
					echo "\n\t<td class='sond' colspan=8>Nr. im Aufteilungsplan: ".$rowan["nrap"]."</td>";
				echo "\n</tr>";
			}
			if ($rowan["sond"] != "") {
				echo "\n<tr>";
					echo "\n\t<td class='sond' colspan=8>Verbunden mit dem Sondereigentum an: ".$rowan["sond"]."</td>";
				echo "\n</tr>";
			}
			$a++;
		}
		if ($a == 0) {
			echo "\n<tr>";
				echo "\n\t<td><span class='wichtig'>".$bvnr."</span>";
				if ($idanzeige) {
					linkgml($gkz, $gml_bs, "Buchungsstelle");
				}
				echo "</td>";
				echo "\n\t<td colspan=7>";
					echo "<p class='warn'>Flurst&uuml;cke zu ".$bvnr." nicht im Datenbestand.</p>";
				echo "</td>";
			echo "\n</tr>";
		}
	}
	$i++; 	if ($row["nrap"] != "") { // Nummer im Aufteilungsplan
		echo "\n<tr>";
			echo "\n\t<td class='nrap' colspan=8>Nummer <span class='wichtig'>".$row["nrap"]."</span> im Aufteilungsplan.</td>";
		echo "\n</tr>";
	}
	if ($row["sond"] != "") { // Sondereigentumsbeschreibung
		echo "\n<tr>";
			echo "\n\t<td class='sond' colspan=8>Verbunden mit dem Sondereigentum an: ".$row["sond"]."</td>";
		echo "\n</tr>";
	}
} // Ende Buchungsstelle
echo "\n</table>";

if ($i == 0) {
	echo "\n<p class='err'>Keine Buchung gefunden.</p>\n";
	linkgml($gkz, $gmlid, "Buchungsblatt");
}
	// b e r e c h t i g t e  Grundbuecher (Buchungsblatt) 
	// mit Recht "an"/"zu" dem aktuellen fiktiven GB

	// bf              vf          sf       vs   sb                 vb            bb
	// Blatt   <istBestandteilVon< Stelle  <an<  Stelle      >istBestandteilVon>  Blatt
	// Fiktiv                      Fiktiv  <zu<  Berechtigt                       Berechtigt
	$sql ="SELECT bb.gml_id, bb.land, bb.bezirk, bb.buchungsblattnummermitbuchstabenerweiterung AS blatt, bb.blattart, ";	$sql.="vs.beziehungsart, ";
	$sql.="sb.gml_id AS gml_s, sb.laufendenummer AS lfdnr, sb.buchungsart, ba.bezeichner AS bart, ";  // berechtigte Buchungsstelle
	$sql.=" bz.bezeichnung AS beznam, ag.bezeichnung, ag.stelle, ag.stellenart "; // Bezirk, Amtsgericht
	$sql.="FROM alkis_beziehungen vf ";	// Verbindung fiktiv
	$sql.="JOIN ax_buchungsstelle sf ON sf.gml_id = vf.beziehung_von ";	// Stelle fiktiv
	$sql.="JOIN alkis_beziehungen vs ON sf.gml_id = vs.beziehung_zu ";	// Verbindung Stellen
	$sql.="JOIN ax_buchungsstelle sb ON sb.gml_id = vs.beziehung_von ";	// Stelle berechtigt
	$sql.="JOIN alkis_beziehungen vb ON sb.gml_id = vb.beziehung_von ";	// Verbindung berechtigt
	$sql.="JOIN ax_buchungsblatt  bb ON bb.gml_id = vb.beziehung_zu ";	// Blatt berechtigt
	$sql.="LEFT JOIN ax_buchungsblattbezirk bz ON bb.land = bz.land AND bb.bezirk = bz.bezirk ";
//	$sql.="LEFT JOIN ax_dienststelle ag ON bz.\"gehoertzu|ax_dienststelle_schluessel|land\" = ag.land AND bz.stelle=ag.stelle ";
	$sql.="LEFT JOIN ax_dienststelle ag ON bz.land = ag.land AND bz.stelle=ag.stelle ";	
	$sql.="LEFT JOIN ax_buchungsstelle_buchungsart ba ON sb.buchungsart = ba.wert ";
	$sql.="WHERE vf.beziehung_zu= $1 ";
	$sql.="AND  vf.beziehungsart='istBestandteilVon' ";
	$sql.="AND (vs.beziehungsart='an' OR vs.beziehungsart='zu') ";
	$sql.="AND  vb.beziehungsart= 'istBestandteilVon' ";
	$sql.="ORDER BY bb.land, bb.bezirk, bb.buchungsblattnummermitbuchstabenerweiterung;";

	$v = array($gmlid);
	$resb = pg_prepare("", $sql);
	$resb = pg_execute("", $v);
	if (!$resb) {
		echo "<p class='err'>Fehler bei 'andere Berechtigte Bl&auml;tter:'<br>".$sql."</p>\n";
		if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
	}
	$b=0; // count: Blaetter
	while($rowb = pg_fetch_array($resb)) {
		if ($b == 0) { // Ueberschrift und Tabelle nur ausgeben, wenn etwas gefunden wurde
			echo "\n<h3><img src='ico/Grundbuch_zu.ico' width='16' height='16' alt=''> Berechtigte Grundb&uuml;cher</h3>\n";
			echo "\n<table class='outer'>";
			echo "\n<tr>"; // Tabelle Kopf
				echo "\n\t<td class='head'>Land</td>";
				echo "\n\t<td class='head'>Dienststelle</td>";
				echo "\n\t<td class='head'>Bezirk</td>";
				echo "\n\t<td class='head'>Blatt</td>";
				echo "\n\t<td class='head'>BVNR</td>"; // Neu
				echo "\n\t<td class='head'>Buchungsart</td>"; // Neu
				echo "\n\t<td class='head nwlink noprint'>Weitere Auskunft</td>";
			echo "\n</tr>";
		}
		$gml_b=$rowb["gml_id"];		// id des berechtigten Blattes
		$gml_s=$rowb["gml_s"];		// id der berechtigten Buchungsstelle
		$blart=$rowb["blattart"];
		$buch=$rowb["buchungsart"]; // Buchungsart Stelle berechtigt
		$bart=$rowb["bart"];			// Buchungsart entschluesselt
		$lfdnr=$rowb["lfdnr"];
		$bvnr   = str_pad($lfdnr, 4, "0", STR_PAD_LEFT);

		echo "\n<tr>";
			echo "\n\t<td>".$rowb["land"]."</td>";
			echo "\n\t<td>"; // Amtsgericht
				echo dienststellenart($rowb["stellenart"])." ";
				if ($showkey) {
					echo "<span class='key'>".$rowb["stelle"]."</span> ";
				}
				echo $rowb["bezeichnung"];
			echo "</td>";
			echo "\n\t<td>";
				if ($showkey) {
					echo "<span class='key'>".$rowb["bezirk"]."</span> ";
				}
				echo $rowb["beznam"];
			echo "</td>";
			echo "\n\t<td><span class='wichtig'>".$rowb["blatt"]."</span>";
				if ($idanzeige) {linkgml($gkz, $gml_b, "Buchungsblatt");}
			echo "</td>";
			echo "\n\t<td>".$bvnr;
				if ($idanzeige) {linkgml($gkz, $gml_s, "Buchungsstelle");}
			echo "</td>";
			echo "\n\t<td>";
				if ($showkey) {
					echo "<span class='key'>".$buch."</span> ";
				}
				echo $bart;
			echo "</td>";
			echo "\n\t<td>";
				echo "\n\t\t<p class='nwlink'>";
			//	echo $rowb["beziehungsart"]." "; // "an"/"zu" ?
				echo "\n\t\t\t<a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$gml_b."#bvnr".$lfdnr;
					if ($idanzeige) {echo "&amp;id=j";}
					if ($showkey)   {echo "&amp;showkey=j";}
					echo "' title='Nachweis des berechtigten Blattes ".$rowb["beziehungsart"]." ".$blattart."'>";
					echo blattart($blart);
					echo " \n\t\t\t<img src='ico/GBBlatt_link.ico' width='16' height='16' alt=''></a>";
				echo "\n\t\t</p>";
			echo "</td>";
		echo "\n</tr>";
		$b++;
	}
	if ($b == 0) {
		if ($blattkey > 2000 ) { // Warnung nicht bei Grundbuchblatt 1000 und Katasterblatt 2000
			echo "<p class='err'>Keine berechtigten Bl&auml;tter zu ".$blattart." (".$blattkey.") gefunden.</p>";
		}
	} else {
		echo "\n</table>";
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

<?php footer($gmlid, $_SERVER['PHP_SELF']."?", ""); ?>

</body>
</html>