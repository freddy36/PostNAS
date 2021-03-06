<?php
/*	Modul: alkisbestnw.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Bestandsnachweis für ein Grundbuch aus ALKIS PostNAS

	Version:
	2011-11-17 Parameter der Functions geändert
	2011-11-22 Feldname land in ax_buchungsblattbezirk geändert
	2011-11-30 import_request_variables
	2012-07-24 Export CSV
	2013-04-08 deprecated "import_request_variables" ersetzt
	2014-09-10 PostNAS 0.8: ohne Tab. "alkis_beziehungen", mehr "endet IS NULL", Spalten varchar statt integer
	2014-09-15 Bei Relationen den Timestamp abschneiden
	2014-09-30 Rückbau substring(gml_id)
	2014-12-30 Berechtigte GB nach "an BVNR" dieses Bestandes sortieren
*/
session_start();
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
	<title>ALKIS Bestandsnachweis</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Grundbuch.ico">
	<script type="text/javascript">
		function ALKISexport() {
			window.open(<?php echo "'alkisexport.php?gkz=".$gkz."&tabtyp=grundbuch&gmlid=".$gmlid."'"; ?>);
		}
	</script>
	<style type='text/css' media='print'>
		.noprint {visibility: hidden;}
	</style>
</head>
<body>
<?php
$con = pg_connect("host=".$dbhost." port=".$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) echo "<p class='err'>Fehler beim Verbinden der DB</p>\n";

// G R U N D B U C H
$sql="SELECT g.gml_id, g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung AS nr, g.blattart, 
b.gml_id, b.bezirk, b.bezeichnung AS beznam, a.gml_id, a.land, a.bezeichnung, a.stelle, a.stellenart 
FROM ax_buchungsblatt g LEFT JOIN ax_buchungsblattbezirk b ON g.land=b.land AND g.bezirk=b.bezirk 
LEFT JOIN ax_dienststelle a ON b.land=a.land AND b.stelle=a.stelle 
WHERE g.gml_id= $1 AND a.stellenart=1000 AND g.endet IS NULL AND a.endet IS NULL;";

$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);

if (!$res) {
	echo "<p class='err'>Fehler bei Grundbuchdaten.</p>";
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}
if ($row = pg_fetch_array($res)) {
	$blattkey=$row["blattart"];
	$blattart=blattart($blattkey);
	echo "<p class='gbkennz'>ALKIS Bestand ".$row["bezirk"]." - ".$row["nr"]."&nbsp;</p>\n"; // Balken
	echo "\n<h2><img src='ico/Grundbuch.ico' width='16' height='16' alt=''> Grundbuch</h2>";
	echo "\n<table class='outer'>\n<tr>\n\t<td>"; // Kennz. im Rahmen
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
		if ($idanzeige) {linkgml($gkz, $gmlid, "Buchungsblatt", "");}
	echo "\n\t</td>\n</tr>\n</table>";
}

if ($blattkey == 5000) { // fikt. Blatt
	echo "\n<p>Keine Angaben zum Eigentum bei fiktivem Blatt.</p>\n";
} else {
	// E I G E N T U E M E R
	echo "\n<h3><img src='ico/Eigentuemer_2.ico' width='16' height='16' alt=''> Angaben zum Eigentum</h3>\n";
	$n = eigentuemer($con, $gmlid, true, ""); // MIT Adressen.
	if ($n == 0) { // keine NamensNr, kein Eigentuemer
		echo "\n<p class='err'>Keine Namensnummer gefunden.</p>";
		echo "\n<p>Bezirk: ".$row["bezirk"].", Blatt: ".$row["nr"].", Blattart ".$blattkey." (".$blattart.")</p>";
		linkgml($gkz, $gmlid, "Buchungsblatt", "");
	}
}

// Vorab pruefen, ob der Fall "Rechte an .." vorliegt.
if ($blattkey == 1000) { // GB-Blatt  <istBestandteilVon<  sh=herrschend  >an>  sd=dienend
	$sql="SELECT count(sd.laufendenummer) AS anzahl
	FROM ax_buchungsstelle sh JOIN ax_buchungsstelle sd ON (sd.gml_id=ANY(sh.an) OR sd.gml_id=ANY(sh.zu)) 
	WHERE sh.istbestandteilvon= $1 AND sd.endet IS NULL AND sh.endet IS NULL;";

	$v=array($gmlid); // GB-Blatt
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) echo "<p class='err'>Fehler bei Suche nach Buchungen.</p>\n";
	$row=pg_fetch_array($res);
	$anz=$row["anzahl"];
	//echo "<p>Zeilen : ".$anz." zu Blattart ".$blattkey."</p>";
} else { // 2000: Katasterblatt, 3000: Pseudoblatt, 5000: Fiktives Blatt
	$anz=0;
}
if ($anz > 0) {
	echo "\n<hr>\n\n<h3><img src='ico/Flurstueck.ico' width='16' height='16' alt=''> Rechte und Flurst&uuml;cke</h3>";
	echo "\n<table class='fs'>";
	echo "\n<tr>"; // zusätzliche Kopfzeile
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

echo "\n<tr>"; // gemeinsame Kopfzeile
	echo "\n\t<td class='head' title='laufende Nummer Bestandsverzeichnis (BVNR) = Grundst&uuml;ck'><span class='wichtig'>BVNR</span></td>";
	echo "\n\t<td class='head'>Buchungsart</td>";
	echo "\n\t<td class='head'>Anteil</td>";
	echo "\n\t<td class='head'>Gemarkung</td>";
	echo "\n\t<td class='head'>Flur</td>";
	echo "\n\t<td class='head fsnr' title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'><span class='wichtig'>Flurst.</span></td>";
	echo "\n\t<td class='head fla'>Fl&auml;che</td>"; // 7
	echo "\n\t<td class='head nwlink noprint' title='Link: weitere Auskunft'>weit. Auskunft</td>";
echo "\n</tr>";

// Blatt ->  B u c h u n g s s t e l l e
// aktuelles ax_buchungsblatt <istBestandteilVon< ax_buchungsstelle 
$sql ="SELECT s.gml_id, s.buchungsart, s.laufendenummer AS lfd, s.beschreibungdesumfangsderbuchung AS udb, s.zaehler, s.nenner, s.nummerimaufteilungsplan AS nrap, s.beschreibungdessondereigentums AS sond, b.bezeichner as bart 
FROM ax_buchungsstelle s LEFT JOIN v_bs_buchungsart b ON s.buchungsart=b.wert 
WHERE s.istbestandteilvon= $1 AND s.endet IS NULL ORDER BY cast(s.laufendenummer AS integer);";

$v=array($gmlid); // Rel. istBestandteilVon
$res=pg_prepare("", $sql);
$res=pg_execute("", $v);

if (!$res) {
	echo "<p class='err'>Fehler bei Buchung.</p>\n";
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '". $gmlid."'</p>";}
}
$i=0;
$fscnt=0;
while($row = pg_fetch_array($res)) { // Loop Buchungsstelle (Grundstück)
	$lfdnr=$row["lfd"];
	$bvnr=str_pad($lfdnr, 4, "0", STR_PAD_LEFT);
	$gml_bs= $row["gml_id"]; // id der buchungsstelle
	$ba=$row["bart"]; // Buchungsart aus Schluesseltabelle

	if ($row["zaehler"] == "") {
		$anteil = "";
	} else {
		$anteil = $row["zaehler"]."/".$row["nenner"];
	}
	// F l u r s t u e c k s d a t e n  zur direkten Buchungsstelle
	$j = bnw_fsdaten($con, $lfdnr, $gml_bs, $ba, $anteil, true); // return=Anzahl der FS
	$fscnt=$fscnt + $j;
	if ($j == 0) { //  k e i n e  Flurstuecke gefunden (Miteigentumsnteil usw.)
		// Bei "normalen" Grundstuecken wurden Flurstuecksdaten gefunden und ausgegeben.
		// Bei Miteigentumsanteil, Erbbaurecht usw. muss nach weiteren Buchungsstellen gesucht werden:
		//  Buchungsstelle >an/zu> (andere)Buchungsstelle >istBestandTeilVon> "FiktivesBlatt (ohne) Eigentuemer"

		// andere Buchungsstellen
		//  ax_buchungsstelle >zu> ax_buchungsstelle (des gleichen Blattes)
		//  ax_buchungsstelle >an> ax_buchungsstelle (anderes Blatt, z.B Erbbaurecht an)
		//  sh=herrschend          sd=dienend
		$sql ="SELECT sd.gml_id, sd.buchungsart, sd.laufendenummer AS lfd, sd.beschreibungdesumfangsderbuchung AS udb, sd.nummerimaufteilungsplan AS nrap, sd.beschreibungdessondereigentums AS sond, b.bezeichner AS bart 
	FROM ax_buchungsstelle sh JOIN ax_buchungsstelle sd ON (sd.gml_id=ANY(sh.an) OR sd.gml_id=ANY(sh.zu))  
	LEFT JOIN v_bs_buchungsart b ON sd.buchungsart=b.wert 
	WHERE sh.gml_id= $1 AND sh.endet IS NULL AND sd.endet IS NULL ORDER BY sd.laufendenummer;";

		$v=array($gml_bs);
		$resan=pg_prepare("", $sql);
		$resan=pg_execute("", $v);
		if (!$resan) {
			echo "<p class='err'>Fehler bei 'andere Buchungsstelle'.</p>\n";
			if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
		}
		$a=0; // count
		$altbvnr=""; // Gruppenwechsel
		while($rowan = pg_fetch_array($resan)) {
			$lfdnran = $rowan["lfd"];		// BVNR an
			$gml_bsan= $rowan["gml_id"];	// id der buchungsstelle an
			$baan= $rowan["bart"];  		// Buchungsart an, entschluesselt

			// a n d e r e s   B l a t t  (an dem das aktuelle Blatt Rechte hat)
			// dienendes Grundbuch
			$sql ="SELECT b.gml_id, b.land, b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung AS blatt, b.blattart, z.bezeichnung AS beznam 
	FROM ax_buchungsblatt b JOIN ax_buchungsstelle s ON b.gml_id=s.istbestandteilvon 
	LEFT JOIN ax_buchungsblattbezirk z ON b.land=z.land AND b.bezirk=z.bezirk 
	WHERE s.gml_id= $1 AND b.endet IS NULL ORDER BY b.land, b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung;";
			$v=array($gml_bsan);
			$fbres=pg_prepare("", $sql);
			$fbres=pg_execute("", $v);
			if (!$fbres) {
				echo "<p class='err'>Fehler bei fiktivem Blatt.</p>\n";
				if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}			
			}
			$b=0;
			while($fbrow = pg_fetch_array($fbres)) { // genau 1
				$fbgml  = $fbrow["gml_id"];
				$fbland = $fbrow["land"];
				$fbbez  = $fbrow["bezirk"];
				$fbblatt = $fbrow["blatt"];
				$fbbart = blattart($fbrow["blattart"]);
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
						if ($idanzeige) {linkgml($gkz, $gml_bs, "Buchungsstelle", "ax_buchungsstelle");}
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
						linkgml($gkz, $fbgml, "Buchungsblatt", "");
					}
				echo "</td>";
				echo "\n\t<td class='dien'>"; // BVNR
					echo str_pad($lfdnran, 4, "0", STR_PAD_LEFT);
					if ($idanzeige) {
						linkgml($gkz, $gml_bsan, "Buchungsstelle", "ax_buchungsstelle");
					}

				echo "</td>"; 
				echo "\n\t<td class='dien'>"; // Sp.7 Buchungsart
					if ($showkey) {
						echo "<span class='key'>".$rowan["buchungsart"]."</span> ";
					}
					echo $baan." ";
				echo "</td>";
				echo "\n\t<td>";  // Sp.8 Link ("an" oder "zu" ?)
					echo "<p class='nwlink noprint'>an/zu"; //.$rowan["beziehungsart"] Feld gibt es nicht mehr
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
			$aj = bnw_fsdaten($con, $lfdnran, $gml_bsan, "", $anteil, false); // return=Anz.FS
			$fscnt=$fscnt + $aj;
			// +++ Gibt es Sondereigentum beim fiktiven Blatt?
			if ($rowan["nrap"] != "") {
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
					linkgml($gkz, $gml_bs, "Buchungsstelle", "ax_buchungsstelle");
				}
				echo "</td>";
				echo "\n\t<td colspan=7>";
					echo "<p class='warn'>Flurst&uuml;cke zu ".$bvnr." nicht gefunden.</p>";
				echo "</td>";
			echo "\n</tr>";
		}
	}
	$i++; 
	if ($row["nrap"] != "") { // Nr im Auft.Plan
		echo "\n<tr>";
			echo "\n\t<td class='nrap' colspan=8>Nummer <span class='wichtig'>".$row["nrap"]."</span> im Aufteilungsplan.</td>";
		echo "\n</tr>";
	}
	if ($row["sond"] != "") { // Sondereigentumsbeschreibung
		echo "\n<tr>";
			echo "\n\t<td class='sond' colspan=8>Verbunden mit dem Sondereigentum an: ".$row["sond"]."</td>";
		echo "\n</tr>";
	} // Ende Buchungsstelle/BVNR
} // Ende Loop
echo "\n</table>";

if ($i == 0) {
	echo "\n<p class='err'>Keine Buchung gefunden.</p>\n";
	linkgml($gkz, $gmlid, "Buchungsblatt", "");
} else {
	if ($i > 5 and $fscnt > 5) { // nur wenn nicht auf einen Blick zu erkennen
		echo "\n<p class='cnt'>".$i." Buchungen mit ".$fscnt." Flurst&uuml;cken</p>\n";
	}
}

// B e r e c h t i g t e  Buchungsblaetter  mit Recht an/zu dem aktuellen (fiktiven?) Blatt

// bf                          sf            sb                               bb
// Blatt   <istBestandteilVon< Stelle  <an<  Stelle      >istBestandteilVon>  Blatt
// Fiktiv                      Fiktiv  <zu<  Berechtigt                       Berechtigt
$sql="SELECT sf.laufendenummer AS anlfdnr, bb.gml_id, bb.land, bb.bezirk, bb.buchungsblattnummermitbuchstabenerweiterung AS blatt, bb.blattart, 
sb.gml_id AS gml_s, sb.laufendenummer AS lfdnr, sb.buchungsart, ba.bezeichner AS bart, bz.bezeichnung AS beznam, ag.bezeichnung, ag.stelle, ag.stellenart 
FROM ax_buchungsstelle sf JOIN ax_buchungsstelle sb ON (sf.gml_id=ANY(sb.an) OR sf.gml_id=ANY(sb.zu)) 
JOIN ax_buchungsblatt bb ON bb.gml_id=sb.istbestandteilvon 
LEFT JOIN ax_buchungsblattbezirk bz ON bb.land=bz.land AND bb.bezirk=bz.bezirk 
LEFT JOIN ax_dienststelle ag ON bz.land=ag.land AND bz.stelle=ag.stelle 
LEFT JOIN v_bs_buchungsart ba ON sb.buchungsart=ba.wert 
WHERE sf.istbestandteilvon = $1 AND sf.endet IS NULL AND sb.endet IS NULL AND bb.endet IS NULL 
ORDER BY cast(sf.laufendenummer AS integer), bb.land, bb.bezirk, bb.buchungsblattnummermitbuchstabenerweiterung, cast(sb.laufendenummer AS integer);";
// Änd. 2014-12-30: Sort. wie im ersten Teil

$v = array($gmlid);
$resb = pg_prepare("", $sql);
$resb = pg_execute("", $v);
if (!$resb) {
	echo "<p class='err'>Fehler bei 'Berechtigte Bl&auml;tter.</p>\n";
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}
$b=0; // count: Buchungen / Blätter
while($rowb = pg_fetch_array($resb)) {
	if ($b == 0) { // Ueberschrift und Tabelle nur ausgeben, wenn etwas gefunden wurde
		echo "\n<h3><img src='ico/Grundbuch_zu.ico' width='16' height='16' alt=''> Berechtigte Grundb&uuml;cher</h3>\n";
		echo "\n<table class='outer'>";
		echo "\n<tr>"; // Tab Kopf
			echo "\n\t<td class='head' title='lfd. Nr. auf diesem Blatt, wie im Teil Flurst&uuml;cke'>an <span class='wichtig'>BVNR</span></td>"; // wie oben
			echo "\n\t<td class='head'>Land</td>";
			echo "\n\t<td class='head'>Dienststelle</td>";
			echo "\n\t<td class='head'>Bezirk</td>";
			echo "\n\t<td class='head'><span class='wichtig'>Blatt</span></td>";
			echo "\n\t<td class='head'>BVNR</td>";
			echo "\n\t<td class='head'>Buchungsart</td>";
			echo "\n\t<td class='head nwlink noprint'>Weitere Auskunft</td>";
		echo "\n</tr>";
	}

	$anlfdnr=$rowb["anlfdnr"]; // an BVNR
	$anlfdnr0=str_pad($anlfdnr, 4, "0", STR_PAD_LEFT); // mit führ.0
	$gml_b=$rowb["gml_id"]; // id des ber. Blattes
	$gml_s=$rowb["gml_s"]; // id der ber. B-Stelle
	$blart=$rowb["blattart"];
	$buch=$rowb["buchungsart"]; // Buchungsart Stelle berechtigt
	$bart=$rowb["bart"]; // BA entschl.
	$lfdnr=$rowb["lfdnr"]; // BVNR ber.
	$bvnr=str_pad($lfdnr, 4, "0", STR_PAD_LEFT);

	echo "\n<tr>";
		// Teil berechtigte Grundbücher ist sortiert wie oberer Teil "Flurstücke"
		echo "\n\t<td><span class='wichtig'>".$anlfdnr0."</span>";
		// Link "nach oben" - bringt das Nutzen? Nur bei ganz langen Beständen.
/*			echo "\n\t\t<p class='noprint'>&nbsp;";
			echo "\n\t\t\t<a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$gmlid."#bvnr".$anlfdnr;
				if ($idanzeige) {echo "&amp;id=j";}
				if ($showkey)   {echo "&amp;showkey=j";}
				echo "' title='Sprung nach oben zum Grundst&uuml;ck'>hoch</a>";
			echo "\n\t\t</p>";
	++ <p> auflösen, sonst 2 Zeilen im <td> ++
*/
		echo "</td>";
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
			if ($idanzeige) {linkgml($gkz, $gml_b, "Buchungsblatt", "");}
		echo "</td>";
		echo "\n\t<td>".$bvnr;
			if ($idanzeige) {linkgml($gkz, $gml_s, "Buchungsstelle", "ax_buchungssstelle");}
		echo "</td>";
		echo "\n\t<td>";
			if ($showkey) {
				echo "<span class='key'>".$buch."</span> ";
			}
			echo $bart;
		echo "</td>";
		echo "\n\t<td>";
			echo "\n\t\t<p class='nwlink noprint'>";
			echo "\n\t\t\t<a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$gml_b."#bvnr".$lfdnr;
				if ($idanzeige) {echo "&amp;id=j";}
				if ($showkey)   {echo "&amp;showkey=j";}
				echo "' title='Nachweis des berechtigten Blattes an ".$blattart."'>"; // oder "zu" statt "an"
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
	if ($i > 1) {
		echo "\n<p class='cnt'>Rechte anderer Buchungsstellen an ".$b." der ".$i." Buchungen</p>\n";
	}
}
?>

<form action=''>
	<div class='buttonbereich noprint'>
	<hr>
		<a title="zur&uuml;ck" href='javascript:history.back()'><img src="ico/zurueck.ico" width="16" height="16" alt="zur&uuml;ck"></a>&nbsp;
		<a title="Drucken" href='javascript:window.print()'><img src="ico/print.ico" width="16" height="16" alt="Drucken"></a>&nbsp;
	 	<a title="Export als CSV" href='javascript:ALKISexport()'><img src="ico/download_gb.ico" width="32" height="16" alt="Export"></a>&nbsp;
	</div>
</form>

<?php footer($gmlid, $_SERVER['PHP_SELF']."?", ""); ?>

</body>
</html>