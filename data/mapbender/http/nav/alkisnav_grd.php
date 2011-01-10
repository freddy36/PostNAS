<?php
// Version vom 10.01.2011  
$gkz = urldecode($_REQUEST["gkz"]); // Mandant
include("../../conf/alkisnav_conf.php");
import_request_variables("PG");

// Datenbank-Connection
$con_string = "host=".$host." port=".$port." dbname=".$dbname.$gkz." user=".$user." password=".$password;
$con = pg_connect ($con_string) or die ("Fehler bei der Verbindung zur Datenbank ".$dbname);

?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ALKIS-Suche Grundbuch</title>
	<link rel="stylesheet" type="text/css" href="alkisnav.css">
</head>
<body>

<?php
function is_ne_zahl($wert) {
	// Prueft, ob ein Wert ausschließlich aus den Zahlen 0 bis 9 besteht
	if (trim($wert, "0..9") == "") {return true;} else {return false;}
}

function is_blatt(&$wert) {
	// Prueft, ob eine Eingabe dem Format von Grundbuch-Blatt entspricht.
	// Die Blatt-Nummern wird dabei auf das Datenbank-Format mit fuehrenden Nullen ergaenzt (&).
	// +++ Nur ein Aufruf der Function. In aufrufendes Programm integrieren? 	
	$len=strlen($wert);
	if ($len < 1 or $len > 7) {return false;};
	if (trim($wert, "0..9") == "") { // Normalfall: nur Zahlen
		If (strlen($wert) < 6) {
			$wert = str_pad($wert, 6, "0", STR_PAD_LEFT);
		}	
		return true;
	} else { // Sonderfall Zusatz-Buchstabe am Ende 
		$zahl=substr($wert,0,$len-1);
		$zus=strtoupper(substr($wert,$len-1,1));
		if ( (trim($zahl, "0..9") == "") and (trim($zus, "A..Z") == "")) {
			If (strlen($zahl) < 6) {
				$zahl = str_pad($zahl, 6, "0", STR_PAD_LEFT);
			}
			$wert=$zahl.$zus;	
			return true;		
		} else {		
			return false;
		}
	}
}

function ZerlegungGBKennz($gbkennz) {
// Das eingegebene Grundbuch-Kennzeichen auseinander nehmen (gggg-999999z-BVNR)
// Return: 0=Fehler, 1=Such Bezirk-Name oder Listen alle Bezirke
//         2=Such Bezirk-Nummer $zgbbez, 3=Such Blatt $zblatt, 4=Such BVNR $zbvnr
	global $debug, $zgbbez, $zblatt, $zbvnr;		$arr = explode("-", $gbkennz, 3);
	$zgbbez=trim($arr[0]);
	$zblatt=trim($arr[1]);
	$zbvnr=trim($arr[2]);
	if ($zgbbez == "") { // keine Eingabe
		return 1; // alle Bezirke listen
	} elseif ( ! is_ne_zahl($zgbbez)) {
		return 1; // Such Bezirk-NAME
	} elseif ($zblatt == "") {
		return 2; // Such Bezirk-NUMMER
	} elseif (is_blatt($zblatt)) {
		if ($zbvnr == "") {
			return 3; // Such BLATT
		} elseif (is_ne_zahl($zbvnr)) {		
			// $zbvnr=ltrim($zbvnr,"0"); // DB-Format ist integer
			// Vorsicht, Wert "0" ist moeglich und gueltig
			return 4; // Such Grundstueck
		} else {
			echo "<p class='err>Die Buchungsstelle (BVNR) '".$zbvnr."' ist nicht numerisch</p>";
			return 0;
		}
	} else {
		echo "<p class='err>Das Grundbuch-Blatt '".$zblatt."' ist ung&uuml;ltig.</p>";
		return 0;
	}
}

function SuchGBBezName() {
// Grundbuch-Bezirk suchen nach Name(-nsanfang)
	global $con, $gkz, $gemeinde, $debug, $gbkennz;
	$linelimit=50;
	$sql ="SELECT a.bezeichnung AS ag, g.bezirk, g.bezeichnung FROM ax_buchungsblattbezirk g ";
	$sql.="JOIN ax_dienststelle a ON g.stelle=a.stelle ";
	$sql.="WHERE g.bezeichnung ILIKE $1 "; //	"AND a.stellenart=1000 " // Amtsgericht
	$sql.="ORDER BY g.bezeichnung LIMIT $2 ;";
	if ( $gbkennz == "") {
		$match = "%";
	} else {	
		if(preg_match("/\*/",$gbkennz)){
			$match = trim(preg_replace("/\*/i","%", strtoupper($gbkennz)));
		} else {
			$match = trim($gbkennz)."%";
		}	
	}
	$v = array($match, $linelimit);
	$res = pg_prepare("", $sql);
	$res = pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Grundbuch-Bezirk</p>";
		if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
		return 0;
	}
	$cnt = 0;
	// Loop  B E Z I R K	 
	// +++ Sortierung und Gruppierung nach Amtsgericht ??
	while($row = pg_fetch_array($res)) {
		$gnam=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
		$gnr=$row["bezirk"];
		$ag=htmlentities($row["ag"], ENT_QUOTES, "UTF-8");		
		echo "\n<div class='gk' title='GB-Bezirk'>";
			echo "\n\t\t<img class='nwlink' src='ico/Gericht.ico' width='16' height='16' alt='Gemkg'> ";
			echo "<a href='alkisnav_grd.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;gbkennz=".$gnr."'>";		
				echo $gnam."</a> (".$gnr.") AG ".$ag;
		echo "\n</div>";
		$cnt++;
	}
	if($cnt == 0){ 
		echo "\n<p class='err'>Kein Grundbuchbezirk.</p>";
	} elseif ($cnt >= $linelimit) {
		echo "\n<p title='Bitte eindeutiger qualifizieren'>... und weitere</p>";
	} elseif ($cnt == 1) {
		return $gnr; // Wenn eindeutig, gleich weiter
	}
	return 0;
}
 
function EinBezirk($showParent) {
	// Kennzeichen bestehend nur aus GB-Bezirk-Schlüssel wurde eingegeben
	global $con, $gkz, $gemeinde, $debug, $zgbbez, $auskpath;
	$linelimit=200; // max. Blatt je Bezirk
	// Dies linelimit nicht ausreichend fuer alle Blaetter eines Bezirks, aber ...
	//  Wenn man die Blatt-Nr nicht kennt, kommt man hier sowieso nicht weiter.
	//  Es nutzt also nichts, hier Tausende Nummern aufzulisten.
	// +++ Wildcard in Blatt zulassen? Schwiegig bei numerischem Wert mit fuehrenden Nullen.
	if ($showParent) {
		$sql ="SELECT a.bezeichnung AS ag, g.bezeichnung FROM ax_buchungsblattbezirk g ";
		$sql.="JOIN ax_dienststelle a ON g.stelle=a.stelle ";
		$sql.="WHERE g.bezirk= $1 ;";
		$v=array($zgbbez);
		$res=pg_prepare("", $sql);
		$res=pg_execute("", $v);
		if (!$res) {
			echo "\n<p class='err'>Fehler bei Brundbuchbezirk.</p>";
			if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
		}
		$zgmk=0;
		while($row = pg_fetch_array($res)) {	
			$gnam=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
			$gnr=$row["bezirk"];
			$ag=htmlentities($row["ag"], ENT_QUOTES, "UTF-8");	
			$zgmk++;
		}
		if ($zgmk == 0) {
			echo "\n<div class='gk' title='Grundbuchbezirk'>";
				echo "\n\t\t<p class='err'><img class='nwlink' src='ico/Gericht.ico' width='16' height='16' alt='Bez.'>";
					echo  " Bezirk ".$zgbbez." ist unbekannt.</p>";
			echo "\n</div>";
			return;
		}
		// > 1 auch möglich ???
		echo "\n<div class='gk' title='GB-Bezirk'>";
			echo "\n\t\t<img class='nwlink' src='ico/Gericht.ico' width='16' height='16' alt='Bez.'> ";
			echo "<a href='alkisnav_grd.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;gbkennz=".$zgbbez."'>";		
			echo $gnam."</a> (".$zgbbez.") AG ".$ag;
		echo "\n</div>";
	}
	$sql ="SELECT b.gml_id, b.buchungsblattnummermitbuchstabenerweiterung AS blatt FROM ax_buchungsblatt b ";
	$sql.="WHERE b.bezirk= $1 ORDER BY b.buchungsblattnummermitbuchstabenerweiterung LIMIT $2 ;";
	$v=array($zgbbez, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Bezirk.</p>";
		if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
	}
	$cntbl=0; // Counter Blatt/Bezirk
	// Loop  B L A T T	
	while($row = pg_fetch_array($res)) {	
		$blatt=$row["blatt"];
		$gml=$row["gml_id"];
		echo "\n<div class='gb' title='GB-Blatt'>";
			echo "\n\t<a title='Nachweis' target='_blank' href='".$auskpath."alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$gml."'>";
				echo "\n\t\t<img class='nwlink' src='ico/GBBlatt_link.ico' width='16' height='16' alt='Blatt'>";
			echo "\n\t</a> ";
			echo "Blatt <a href='alkisnav_grd.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;gblatt=".$gml."&amp;gbkennz=".$zgbbez."-".$blatt."'>&nbsp;".$blatt."&nbsp;</a>";
		echo "\n</div>";
		$cntbl++;
	}
	if($cntbl == 0) { 
		echo "\n<p class='err'>Kein Blatt im Bezirk.</p>";
	} else {
		if($cntbl >= $linelimit) {
			echo "\n<p>... und weitere</p>";
			echo "\n<p>Geben sie ein: '".$zgbbez."-999999A'<br>wobei '999999A' = gesuchtes GB-Blatt</p>";
		}
	}
	return;
}

function gml_blatt() {
	// Komplettes Kennzeichen "Bezirk + Blatt" wurde eingegeben.
	// Dazu die gml_id des GB-Blattes ermitteln.
	global $con, $gkz, $debug, $zgbbez, $zblatt;

	// Blatt ->  B u c h u n g s s t e l l e
	// ax_buchungsblatt   <istBestandteilVon<  ax_buchungsstelle 	
	$sql ="SELECT b.gml_id FROM ax_buchungsblatt b "; 
	$sql.="WHERE b.bezirk= $1 AND b.buchungsblattnummermitbuchstabenerweiterung= $2 ;";
	$v=array($zgbbez, $zblatt);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Blatt (Kennzeichen).</p>";
		return;
	}
	$cntbl=0; // Counter Blatt
	while($row = pg_fetch_array($res)) {	
		$bl_gml=$row["gml_id"];
		$cntbl++;
	}
	if($cntbl == 0) { 
		echo "\n<p class='err'>Grundbuchblatt '".$zgbbez."-".$zblatt."' nicht gefunden.</p>";
	} elseif($cntbl == 1) {
		return $bl_gml;
	}
	return;
}

function EinBlatt($showParent) {
	// Kennzeichen Bezirk + Blatt wurde eingegeben
	global $con, $gkz, $debug, $gemeinde, $auskpath, $zgbbez, $zblatt, $gblatt, $zbvnr;

	if ($showParent) {	
		echo "\n<div class='gb' title='GB-Blatt'>";
			echo "\n\t<a title='Nachweis' target='_blank' href='".$auskpath."alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$gblatt."'>";
				echo "\n\t\t<img class='nwlink' src='ico/GBBlatt_link.ico' width='16' height='16' alt='Blatt'>";
			echo "\n\t</a> ";
			echo "Blatt <a href='alkisnav_grd.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;gblatt=".$gblatt."&amp;gbkennz=".$zgbbez."-".$zblatt."'> ".$zblatt."</a>";
		echo "\n</div>";
	}
	// Blatt ->  B u c h u n g s s t e l l e
	// ax_buchungsblatt   <istBestandteilVon<  ax_buchungsstelle 
	$sql ="SELECT s.gml_id, s.laufendenummer AS lfd ";
	$sql.="FROM ax_buchungsstelle s ";
	$sql.="JOIN alkis_beziehungen v ON s.gml_id=v.beziehung_von "; 
	$sql.="JOIN ax_buchungsblatt b ON v.beziehung_zu=b.gml_id ";
	$sql.="WHERE v.beziehungsart='istBestandteilVon' AND b.gml_id= $1 ";
	$sql.="ORDER BY s.laufendenummer;";
	// +++ Buchungen ohne FLST weglassen ??
	// +++ Counter FLST ausgeben, Buchungen mit 0 weglassen 
	$v=array($gblatt);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Blatt.</p>";
		if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
	}
	$cntbu=0; // Counter Buchung/Blatt
	while($row = pg_fetch_array($res)) {	
		$bs_gml=$row["gml_id"];		
		$lfd=$row["lfd"];
		echo "\n<div class='gs'>";
			echo "\n\t\t<img class='nwlink' title='Grundst&uuml;ck' src='ico/Grundstueck.ico' width='16' height='16' alt='GS'> ";
			echo "Buchung <a href='alkisnav_grd.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;gbuchung=".$bs_gml."&amp;gbkennz=".$zgbbez."-".$zblatt."-".$lfd."'>".$lfd."</a>";
		echo "\n</div>";
		$cntbu++;
	}
	if($cntbu == 0) { 
		echo "\n<p class='err'>Keine Buchung gefunden.</p>";
	} elseif($cntbu = 1) {
		//echo "\n<p>genau EINE Buchung gefunden".$lfd."</p>";
		$zbvnr=$lfd; // mit dieser BVNR gleich weiter machen 
	}
	return $cntbu;
}

function gml_buchungsstelle() {
	// Komplettes Kennzeichen "Bezirk + Blatt + BVNR" wurde eingegeben.
	// Dazu die gml_id der Buchungsstelle ermitteln fuer die weitere Verfolgung der Beziehungen.
	global $con, $gkz, $debug, $zgbbez, $zblatt, $zbvnr;

	// Blatt ->  B u c h u n g s s t e l l e
	// ax_buchungsblatt   <istBestandteilVon<  ax_buchungsstelle 	
	$sql ="SELECT s.gml_id FROM ax_buchungsstelle s ";
	$sql.="JOIN alkis_beziehungen v ON s.gml_id=v.beziehung_von "; 
	$sql.="JOIN ax_buchungsblatt b ON b.gml_id=v.beziehung_zu "; 
	$sql.="WHERE v.beziehungsart='istBestandteilVon' ";
	$sql.="AND b.bezirk= $1 AND b.buchungsblattnummermitbuchstabenerweiterung= $2 AND s.laufendenummer= $3 ;";
	$v=array($zgbbez, $zblatt, $zbvnr);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Buchungsstelle (Kennzeichen).</p>";
		return;
	}
	$zbs=0;
	while($row = pg_fetch_array($res)) {	
		$bs_gml=$row["gml_id"];
		$zbs++;
	}
	if($zbs == 0) { 
		echo "\n<p class='err'>Die Buchungsstelle wurde nicht gefunden.</p>";
		return;
	} elseif($zbs > 1) { // nur TEST
		echo "\n<p class='err'>Buchungsstelle mehrfach gefunden.</p>";
		return;
	} else {
		return $bs_gml;
	}
}

function EinGrundstueck($showParent) {
	// Die gml_id der Buchungsstelle ist bekannt.
	global $con, $gkz, $debug, $gemeinde, $scalefs, $epsg, $auskpath, $gbuchung, $zgbbez, $zblatt, $zbvnr;

	if ($showParent) {	
		// wenn Kennzeichen bekannt ist, dann auch Blatt ausgeben
		if (isset($zgbbez) and isset($zblatt)) {
			echo "\n<div class='gb' title='GB-Blatt'>";
				echo "\n\t\t<img class='nwlink' src='ico/GBBlatt.ico' width='16' height='16' alt='Blatt'>";
				echo "Blatt <a href='alkisnav_grd.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;gbkennz=".$zgbbez."-".$zblatt."'>&nbsp;".$zblatt."&nbsp;</a>";
			echo "\n</div>";
		} else {
			echo "<p class='err'>Kennzeichen Bezirk und Blatt nicht gesetzt</p>";
		}
		echo "\n<div class='gs'>";
			echo "\n\t\t<img class='nwlink' title='Grundst&uuml;ck' src='ico/Grundstueck.ico' width='16' height='16' alt='GS'> ";
			echo "Buchung <a href='alkisnav_grd.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;gbuchung=".$gbuchung."&amp;gbkennz=".$zgbbez."-".$zblatt."-".$zbvnr."'>&nbsp;".$zbvnr."&nbsp;</a>";
		echo "\n</div>";
	}
	// +++ Ermitteln anderer Buchungsstellen mit Rechten an dieser
	// +++ Ermitteln anderer Buchungsstellen wo diese Rechte hat

	// +++ Filter "Gemeinde" berücksichtigt!! Wenn gesetzt.

	// Buchungsstelle -> Flurstueck
	$sql ="SELECT t.gemeinde, g.bezeichnung, f.gml_id, f.flurnummer, f.zaehler, f.nenner, ";
	$sql.="x(st_transform (st_centroid(f.wkb_geometry),".$epsg.")) AS x, ";
	$sql.="y(st_transform (st_centroid(f.wkb_geometry),".$epsg.")) AS y ";
	$sql.="FROM ax_gemarkung g ";
	$sql.="JOIN ax_flurstueck f ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer ";
	$sql.="JOIN alkis_beziehungen v ON f.gml_id=v.beziehung_von "; 
	$sql.="LEFT JOIN gemeinde_gemarkung t ON g.gemarkungsnummer=t.gemarkung ";
	$sql.="WHERE v.beziehungsart='istGebucht' AND v.beziehung_zu= $1 "; // id buchungsstelle
	$sql.="ORDER BY f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner;";
	$v=array($gbuchung);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Buchungsstelle (gml).</p>";
		if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
	}
	$zfs=0;
	while($row = pg_fetch_array($res)) {	
		$fs_gml=$row["gml_id"];
		$gemei=$row["gemeinde"];
		$gmkg=$row["bezeichnung"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // Bruchnummer
		$x=$row["x"];
		$y=$row["y"];
		if($gemeinde > 0 and $gemeinde != $gemei) { // ex-territorial
			echo "\n<div class='fs' title='Kein Zugriff! Liegt au&szlig;erhalb des Gebietes.'>";
				echo "\n\t\t<img class='nwlink' src='ico/Flurstueck.ico' width='16' height='16' alt='FS'> ".$gmkg." ".$flur."-".$fskenn;
			echo "\n</div>";			
		} else {
			echo "\n<div class='fs'>";
				echo "\n\t<a title='Nachweis' target='_blank' href='".$auskpath."alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$fs_gml."'>";
					echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Link.ico' width='16' height='16' alt='FS'>";
				echo "\n\t</a>";
				echo "\n\t<a title='Flurst&uuml;ck positionieren 1:".$scalefs."' href='";
					echo "javascript:parent.parent.parent.mb_repaintScale(\"mapframe1\",".$x.",".$y.",".$scalefs."); ";
					echo "parent.parent.hideHighlight();' ";
					echo "onmouseover='parent.parent.showHighlight(".$x.",".$y.")' ";
					echo "onmouseout='parent.parent.hideHighlight()'>";
				echo $gmkg." ".$flur."-".$fskenn."</a>";
			echo "\n</div>";
		}
		$zfs++;
	}
	if($zfs == 0) {echo "\n<p class='err'>Kein Flurst&uuml;ck.</p>";}
	return;
}

// ===========
// Start hier!
// ===========
if(isset($epsg)) {
	if ($debug >= 2) {echo "<p>aktueller EPSG='".$epsg."'</p>";} // aus MB
	If (substr($epsg, 0, 5) == "EPSG:") {$epsg=substr($epsg, 5);}
} else {
	if ($debug >= 2) {echo "<p class='err'>kein EPSG gesetzt</p>";}	
	$epsg=$gui_epsg; // aus Conf
}
if ($debug >= 2) {
	if(isset($gemeinde)) {echo "<p>Filter Gemeinde = ".$gemeinde."</p>";
	} else {echo "<p>Kein Filter Gemeinde</p>";}
}

// Auch wenn redundant: Das Kennzeichen für Anzeige und weitere Links zerlegen
$kennztyp=ZerlegungGBKennz($gbkennz);
if ($debug >= 2) {echo "<p>GB-Kennzeichen Typ=".$kennztyp."</p>";}
// Wurde eine gml_id (internes Kennzeichen) aus einem Link verwendet?
If (isset($gbuchung)) { // gml der Buchungsstelle
	if ($debug >= 2) {echo "<p>Link Buchung(gml)=".$gbuchung."</p>";}
	EinGrundstueck(true);
} elseif(isset($gblatt)) { // gml des GB-Blattes
	if ($debug >= 2) {echo "<p>Link Blatt(gml)=".$gblatt."</p>";}
	if (EinBlatt(true) == 1) { // darauf genau eine Buchung
		$gbuchung=gml_buchungsstelle(); // gml_id zum Kennzeichen
		EinGrundstueck(false);
	};
} else {
	// Kein internes Kennzeichen (gml_id), also nur die (manuelle) Eingabe interpretieren.
	switch ($kennztyp) {
	// +++ Ersten Schritt "Suche Amtsgericht" voranstellen?
	// +++ Wie kann Filter "Gemeinde" berücksichtigt werden?
	case 0: // Fehler
		echo "<p class='err'>Bitte ein Grundbuchkennzeichen eingegeben, Format 'gggg-999999A-llll</p>";
		break;
	case 1: // Eingabe Bezirk-Name (-Teil) -> Liste der Bezirke
		if ($debug >= 2) {echo "<p>Eingabe Bez. ".$zgbbez."</p>";}
		$beznr=SuchGBBezName();
		if ($beznr > 0) {
			$zgbbez=$beznr;
			EinBezirk(false);
		};	
		break;
	case 2: // Eingabe Bezirk-Nummer -> Liste der Blätter
		if ($debug >= 2) {echo "<p>Eingabe Bez. ".$zgbbez."</p>";}	
		EinBezirk(true);
		break;
	case 3: // Eingabe Blatt -> Liste der Buchungen
		if ($debug >= 2) {echo "<p>Eingabe Bez. ".$zgbbez." Blatt ".$zblatt."</p>";}
		$gblatt=gml_blatt(); // gml_id zum Blatt suchen
		if ($gblatt != "") { // gefunden		
			if (EinBlatt(true) == 1) { // darauf genau eine Buchung
				$gbuchung=gml_buchungsstelle(); // gml_id zum Kennzeichen
				EinGrundstueck(false);
			}
		}
		break;
	case 4: // Eingabe Buchung (Grundstueck) -> Liste der Flurstuecke
		if ($debug >= 2) {echo "<p>Eingabe Bez. ".$zgbbez." Blatt ".$zblatt." BVNR ".$zbvnr."</p>";}
		$gbuchung=gml_buchungsstelle(); // gml_id zum Kennzeichen
		EinGrundstueck(true);
		break;
	}
}
?>
</body>
</html>