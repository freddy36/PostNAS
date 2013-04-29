<?php
/* Version vom
	2011-10-24	Nach Pos-Klick Highlight erneuern statt hideHighlight
	2011-11-17	Nachweis-Links über javascript im neuen Hochformat-Fenster
	2011-12-14	"window.open(..,width=680"
	2012-01-16	Blattnummer in 2 Varianten suchen
	2012-01-17	Blattnummer ohne Buchstabe in 3 Varianten suchen
	2013-04-16	"import_request_variables" entfällt in PHP 5.4
	2013-04-26	Ersetzen View "gemeinde_gemarkung" durch Tabelle "pp_gemarkung"
					Code aus _eig nach_fkt ausgelegert, hier mit nutzen. 
					Dazu Var-Namen harmonisieren: $gblatt wird $blattgml
					Zurück-Link, Titel der Transaktion anzeigen.
	2013-04-29	Test mit IE
*/
$cntget = extract($_GET);

include("../../conf/alkisnav_conf.php"); // Konfigurations-Einstellungen
include("alkisnav_fkt.php"); // Funktionen

$con_string = "host=".$host." port=".$port." dbname=".$dbname.$dbvers.$gkz." user=".$user." password=".$password;
$con = pg_connect ($con_string) or die ("Fehler bei der Verbindung zur Datenbank ".$dbname.$dbvers.$gkz);
echo <<<END
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ALKIS-Suche Grundbuch</title>
	<link rel="stylesheet" type="text/css" href="alkisnav.css">
	<script type="text/javascript">
		function imFenster(dieURL) {
			var link = encodeURI(dieURL);
			window.open(link,'','left=10,top=10,width=680,height=800,resizable=yes,menubar=no,toolbar=no,location=no,status=no,scrollbars=yes');
		}
		function transtitle(trans) {
			document.getElementById('transaktiontitle').innerHTML = trans;
		}
	</script>
</head>
<body>
<a href='javascript:history.back()'>
	<img src="ico/zurueck.ico" width="16" height="16" alt="&lt;&lt;" title="zur&uuml;ck" />
</a>
<dfn class='title' id='transaktiontitle'></dfn>

END;

function is_ne_zahl($wert) {
	// Prueft, ob ein Wert ausschließlich aus den Zahlen 0 bis 9 besteht
	if (trim($wert, "0..9") == "") {return true;} else {return false;}
}

function ZerlegungGBKennz($gbkennz) {
	// Das eingegebene Grundbuch-Kennzeichen auseinander nehmen (gggg-999999z-BVNR)
	// Return: 9=Fehler, 0=Listen alle Bezirke 1=Such Bezirk-Name
	//         2=Such Bezirk-Nummer $zgbbez, 3=Such Blatt $zblatt, 4=Such BVNR $zbvnr
	global $debug, $zgbbez, $zblatt, $zblattn, $zblattz, $zbvnr;		$arr=explode("-", $gbkennz, 3);
	$zgbbez=trim($arr[0]);
	$zblatt=trim($arr[1]);
	$zbvnr=trim($arr[2]);
	if ($zgbbez == "") { // keine Eingabe
		return 0; // Amtsgerichte oder Bezirke listen
	} elseif ( ! is_ne_zahl($zgbbez)) { // Alphabetische Eingabe
		return 1; // Such Bezirk-NAME
	} elseif ($zblatt == "") {
		return 2; // Such Bezirk-NUMMER
	} else  { // Format von BlattNr pruefen
	//'19'       linksbündig
	//'000019 '  gefüllt 6 + blank
	//'000019A'  .. mit Zusatzbuchstabe
	//'0300001'  gefüllt 7, bei Blattart 5000 "fiktives Blatt"
		$len=strlen($zblatt);
		if ($len > 0 AND $len < 8) {		
			if (trim($zblatt, "0..9 ") == "") { // Normalfall: nur Zahlen (und Blank))
				$zblattn= rtrim(ltrim($zblatt, "0"), " ");
				$zblattz="";
			} else { // Sonderfall: Zusatz-Buchstabe am Ende
				$zblattn=substr($zblatt,0,$len-1);
				$zblattz=strtoupper(substr($zblatt,$len-1,1)); 
				if ((trim($zblattn, "0..9") == "") and (trim($zblattz, "A..Z") == "")) {
					$zblattn= ltrim($zblattn, "0"); // ohne fuehrende Nullen
				} else {
					echo "<p class='err>Format 'Blatt': bis zu 6 Zahlen und ggf. ein Buchstabe</p>";	
					return 9;
				}
			}
			if ($zbvnr == "") {
				return 3; // Such BLATT
			} elseif (is_ne_zahl($zbvnr)) {		
				// $zbvnr=ltrim($zbvnr,"0"); // DB-Format ist integer
				// Vorsicht, Wert "0" ist moeglich und gueltig
				return 4; // Such Grundstueck
			} else {
				echo "<p class='err>Die Buchungsstelle (BVNR) '".$zbvnr."' ist nicht numerisch</p>";
				return 9;
			}
		} else {
			echo "<p class='err>Das Grundbuch-Blatt '".$zblatt."' ist ung&uuml;ltig.</p>";
			return 9;
		}
	}
}

function ListAG($liste_ag) {
	// Amtsgerichte (Grundbuch) auflisten, dazu als Filter eine AG-Liste aus conf
	global $con, $gkz, $gemeinde, $epsg, $debug, $gbkennz;
	$linelimit=40;
	$sql ="SELECT a.stelle, a.bezeichnung AS ag FROM ax_dienststelle a ";
	$sql.="WHERE a.stelle IN (".$liste_ag.") AND a.stellenart = 1000 "; // Amtsgerichte aus Liste
	$sql.="ORDER BY a.bezeichnung LIMIT $1 ;";
	$res = pg_prepare("", $sql);
	$res = pg_execute("", array($linelimit));
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Amtsgerichte</p>";
		if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
		return 0;
	}
	$cnt = 0;
	while($row = pg_fetch_array($res)) { // Loop AG 
		$anr=$row["stelle"];
		$ag=htmlentities($row["ag"], ENT_QUOTES, "UTF-8");		
		echo "\n<div class='ga' title='Amtsgricht'>";
			echo "\n\t\t<img class='nwlink' src='ico/Gericht.ico' width='16' height='16' alt='Amtsgericht'> ";
			echo "AG <a href='alkisnav_grd.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;ag=".$anr."'>";		
				echo $ag."</a> (".$anr.")";
		echo "\n</div>";
		$cnt++;
	}
	if($cnt == 0){ // falsch configuriert!
		echo "\n<p class='anz'>Kein Amtsgericht aus Liste ".$$liste_ag.".</p>";
	} elseif ($cnt >= $linelimit) {
		echo "\n<p title='Bitte eindeutiger qualifizieren'>".$cnt." Amtsgerichte ... und weitere</p>";
	} elseif ($cnt > 1) {
		echo "\n<p class='anz'>".$cnt." Amtsgerichte</p>";
	}
	return 0;
}

function ListGBBez($liste_ag, $mit_ag) {
	// Grundbuch-Bezirke auflisten.
	// +++ auch wenn Blätter da sind, kann es eine Sackgasse sein.
	// +++ manchmal haben die Blätter keine Flurstücke.
	global $con, $gkz, $gemeinde, $epsg, $debug, $gbkennz;
	$linelimit=90;
	$sql ="SELECT a.stelle, a.bezeichnung AS ag, g.bezirk, g.bezeichnung FROM ax_buchungsblattbezirk g ";
	$sql.="JOIN ax_dienststelle a ON g.stelle=a.stelle ";
	$sql.="WHERE a.stelle IN (".$liste_ag.") AND a.stellenart = 1000 "; // Amtsgericht aus Liste
	// Diese Subquery stellt sicher, dass nur Bezirke aufgelistett werden, die auch Blätter enthalten:
	$sql.="AND NOT (SELECT gml_id FROM ax_buchungsblatt b WHERE b.land=g.land and b.bezirk=g.bezirk LIMIT 1) IS NULL ";
	$sql.="ORDER BY g.bezeichnung LIMIT $1 ;";
	$res = pg_prepare("", $sql);
	$res = pg_execute("", array($linelimit));
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Grundbuch-Bezirk</p>";
		if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
		return 0;
	}
	$cnt = 0;
	while($row = pg_fetch_array($res)) { // Loop  B E Z I R K
		$gnam=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
		$gnr=$row["bezirk"];
		$ag=htmlentities($row["ag"], ENT_QUOTES, "UTF-8");
		$anr=$row["stelle"];
		echo "\n<div class='gk' title='GB-Bezirk'>";
			echo "\n\t\t<img class='nwlink' src='ico/GB-Bezirk.ico' width='16' height='16' alt='Gemkg'> ";
			echo "Bezirk <a href='alkisnav_grd.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;gbkennz=".$gnr."'>";		
				echo $gnam."</a> (".$gnr.")";
				if ($mit_ag) {
					echo " AG <a href='alkisnav_grd.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;ag=".$anr."'>".$ag."</a>";
				}
		echo "\n</div>";
		$cnt++;
	}
	if($cnt == 0){
		echo "\n<p class='anz'>Kein Bezirk mit Bl&auml;ttern.</p>";
	} elseif ($cnt >= $linelimit) {
		echo "\n<p class='anz' title='Bitte eindeutiger qualifizieren'>".$cnt." Bezirke ... und weitere</p>";
	} elseif($cnt > 1) {
		echo "\n<p class='anz'>".$cnt." Bezirke</p>"; // im Limit	
	}
	return 0;
}

function SuchGBBezName() {
	// Grundbuch-Bezirk suchen nach Name(-nsanfang)
	global $con, $gkz, $gemeinde, $debug, $gbkennz;
	$linelimit=50;
	$sql ="SELECT a.stelle, a.bezeichnung AS ag, g.bezirk, g.bezeichnung FROM ax_buchungsblattbezirk g ";
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
	while($row = pg_fetch_array($res)) {
		$gnam=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
		$gnr=$row["bezirk"];
		$ag=htmlentities($row["ag"], ENT_QUOTES, "UTF-8");		
		$anr=$row["stelle"];
		echo "\n<div class='gk' title='Grundbuch-Bezirk'>";
			echo "\n\t\t<img class='nwlink' src='ico/GB-Bezirk.ico' width='16' height='16' alt='Gemkg'> ";
			echo "Bezirk <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;gbkennz=".$gnr."'>";		
				echo $gnam."</a> (".$gnr.")";
				echo " AG <a href='alkisnav_grd.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;ag=".$anr."'>".$ag."</a>";
		echo "\n</div>";
		$cnt++;
	}
	if($cnt == 0){ 
		echo "\n<p class='anz'>Kein Grundbuchbezirk.</p>";
	} elseif ($cnt >= $linelimit) {
		echo "\n<p title='Bitte eindeutiger qualifizieren'>".$cnt." Bezirke ... und weitere</p>";
	} elseif ($cnt == 1) {
		return $gnr; // Wenn eindeutig, gleich weiter
	} elseif ($cnt > 1) {
		echo "\n<p class='anz'>".$cnt." Bezirke</p>"; // im Limit	
	}
	return 0;
}
 
function EinBezirk($showParent) {
	// Kennzeichen bestehend nur aus GB-Bezirk-Schlüssel wurde eingegeben
	global $con, $gkz, $gemeinde, $epsg, $debug, $zgbbez, $auskpath;
	$linelimit=250; // max. Blatt je Bezirk
	// Dies Limit ist nicht ausreichend für alle Blätter eines Bezirks, aber ...
	// Wenn man die Blatt-Nr nicht kennt, kommt man hier sowieso nicht weiter.
	// Es nutzt also nichts, hier tausende Nummern aufzulisten.
	// +++ Blätter-Funktion einführen analog Modul _eig
	if ($showParent) {
		$sql ="SELECT a.stelle, a.bezeichnung AS ag, g.bezeichnung FROM ax_buchungsblattbezirk g ";
		$sql.="JOIN ax_dienststelle a ON g.stelle=a.stelle WHERE g.bezirk= $1 ;";
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
			$anr=$row["stelle"];
			$zgmk++;
		}
		if ($zgmk == 0) {
			echo "\n<div class='gk' title='Grundbuchbezirk'>";
				echo "\n\t\t<p class='err'><img class='nwlink' src='ico/GB-Bezirk.ico' width='16' height='16' alt='Bez.'>";
					echo  " Bezirk ".$zgbbez." ist unbekannt.</p>";
			echo "\n</div>";
			return;
		}

		// AG-Knoten davor setzen
		echo "\n<div class='ga' title='Amtsgricht'>";
			echo "\n\t\t<img class='nwlink' src='ico/Gericht.ico' width='16' height='16' alt='Amtsgericht'> ";
			echo "AG <a href='alkisnav_grd.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;ag=".$anr."'>";		
				echo $ag."</a> (".$anr.")";
		echo "\n</div>";
		echo "\n<div class='gk' title='GB-Bezirk'>";
			echo "\n\t\t<img class='nwlink' src='ico/GB-Bezirk.ico' width='16' height='16' alt='Bez.'> ";
			echo "<a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;gbkennz=".$zgbbez."'>";		
			echo $gnam."</a> (".$zgbbez.")";
			// alternativ AG-Link hinter dem Bezirk
		//	echo " des AG <a href='alkisnav_grd.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;ag=".$anr."'>".$ag."</a>";			
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
		$blattd=ltrim($blatt, "0");
		$gml=$row["gml_id"];
		echo "\n<div class='gb' title='GB-Blatt'>";
			echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$gml."\")'>";
				echo "\n\t\t<img class='nwlink' src='ico/GBBlatt_link.ico' width='16' height='16' alt='Blatt'>";
			echo "\n\t</a> ";
			echo "Blatt <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;blattgml=".$gml."&amp;gbkennz=".$zgbbez."-".$blatt."'>&nbsp;".$blattd."&nbsp;</a>";
		echo "\n</div>";
		$cntbl++;
	}
	if($cntbl == 0) { 
		echo "\n<p class='anz'>Kein Blatt im Bezirk.</p>";
	} elseif($cntbl >= $linelimit) {
		echo "\n<p class='anz'>".$cntbl." Bl&auml;tter ... und weitere</p>";
		// +++ Hier oft überschritten! Blätter-Funktion einführen
		echo "\n<p>Geben sie ein: '".$zgbbez."-999A'<br>wobei '999A' = gesuchtes GB-Blatt</p>";
	} elseif ($cntbl > 1) {
		echo "\n<p class='anz'>".$cntbl." Bl&auml;tter</p>"; // im Limit	
	}
	return;
}

function gml_blatt() {
	// Kennzeichen "Bezirk + Blatt" eingegeben. Dazu die gml_id des Blattes ermitteln.
	global $con, $gkz, $debug, $zgbbez, $zblatt, $zblattn, $zblattz;
	$sql ="SELECT b.gml_id, b.buchungsblattnummermitbuchstabenerweiterung AS blatt FROM ax_buchungsblatt b "; 
	$sql.="WHERE b.bezirk= $1 AND b.buchungsblattnummermitbuchstabenerweiterung ";

	if ($zblattz == "") { // Ohne Buchstabenerweiterung: Formate '123','000123 ','0000123'
		$sql.="IN ('".$zblattn."','".str_pad($zblattn, 6, "0", STR_PAD_LEFT)." ','".str_pad($zblattn, 7, "0", STR_PAD_LEFT)."');";
	} else { // Mit Buchstabenerweiterung: '000123A'
		$sql.="='".str_pad($zblattn, 6, "0", STR_PAD_LEFT).$zblattz."';";
	}
	$v=array($zgbbez);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Blatt (Kennzeichen).</p>";
		return;
	}
	$cntbl=0; // Counter Blatt
	while($row = pg_fetch_array($res)) {	
		$bl_gml=$row["gml_id"];
		$zblatt=$row["blatt"]; // das tatsaechliche Format (mit/ohne fuehrende 0)
		$cntbl++;
	}
	if($cntbl == 0) { 
		echo "\n<p class='err'>Grundbuchblatt '".$zgbbez."-".$zblatt."' nicht gefunden.</p>";
	} elseif ($cntbl == 1) {
		return $bl_gml;
	}
	return;
}

/*
function EinBlatt_ALT($showParent) {
	// Kennzeichen Bezirk + Blatt wurde eingegeben
	// Ursprüngliche Version bis 2013-04-24
	global $con, $gkz, $debug, $gemeinde, $epsg, $auskpath, $zgbbez, $zblatt, $zblattn, $zblattz, $blattgml, $zbvnr;

	if ($showParent) {
	// +++ nur der Schluessel ist bekannt. Bezirks-Namen und Amtsgericht noch ermitteln ++++
		echo "\n<div class='gk' title='Grundbuch-Bezirk'>";
			echo "\n\t\t<img class='nwlink' src='ico/GB-Bezirk.ico' width='16' height='16' alt='Bez.'> ";
			echo "Bezirk <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;gbkennz=".$zgbbez."'>";		
			echo $zgbbez."</a>";
		echo "\n</div>";
		echo "\n<div class='gb' title='GB-Blatt'>";
			echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$blattgml."\")'>";
				echo "\n\t\t<img class='nwlink' src='ico/GBBlatt_link.ico' width='16' height='16' alt='Blatt'>";
			echo "\n\t</a> ";
			echo "Blatt <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;blattgml=".$blattgml."&amp;gbkennz=".$zgbbez."-".$zblatt."'>&nbsp;".$zblattn.$zblattz."&nbsp;</a>";
		echo "\n</div>";
	}
	// Blatt ->  B u c h u n g s s t e l l e
	$sql ="SELECT s.gml_id, s.laufendenummer AS lfd FROM ax_buchungsstelle s ";
	$sql.="JOIN alkis_beziehungen v ON s.gml_id=v.beziehung_von "; 
	$sql.="JOIN ax_buchungsblatt b ON v.beziehung_zu=b.gml_id ";
	$sql.="WHERE v.beziehungsart='istBestandteilVon' AND b.gml_id= $1 ORDER BY s.laufendenummer;";
	// +++ Buchungen ohne FLST weglassen?
	// +++ Counter FLST ausgeben, Buchungen mit 0 weglassen 
	$v=array($blattgml);
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
			echo "Buchung <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;gbuchung=".$bs_gml."&amp;gbkennz=".$zgbbez."-".$zblatt."-".$lfd."'>&nbsp;".$lfd."&nbsp;</a>";
		echo "\n</div>";
		$cntbu++;
	}
	if($cntbu == 0) { 
		echo "\n<p class='anz'>Keine Buchung gefunden.</p>";
	} elseif($cntbu == 1) {
		$zbvnr=$lfd; // mit dieser BVNR gleich weiter machen
		// Blatt zerteilen (benoetigt in gml_buchungsstelle)
		if (trim($zblatt, "0..9") == "") { // Normalfall: nur Zahlen
			$zblattn= ltrim($zblatt, "0");
			$zblattz="";
		} else { // Sonderfall: Zusatz-Buchstabe am Ende
			$zblattn=ltrim(substr($zblatt,0,$len-1), "0"); // ohne fuehrende Nullen
			$zblattz=strtoupper(substr($zblatt,$len-1,1)); 
		}
	} else {
		echo "\n<p class='anz'>".$cntbu."Buchungen.</p>";
	}
	return $cntbu;
}
*/

function EinBlatt($showParent) {
	// Kennzeichen Bezirk + Blatt wurde eingegeben
	global $con, $gkz, $debug, $gemeinde, $epsg, $auskpath, $zgbbez, $zblatt, $zblattn, $zblattz, $blattgml, $zbvnr;

	if ($showParent) {
	// +++ nur der Schluessel ist bekannt. Bezirks-Namen und Amtsgericht noch ermitteln ++++
		echo "\n<div class='gk' title='Grundbuch-Bezirk'>";
			echo "\n\t\t<img class='nwlink' src='ico/GB-Bezirk.ico' width='16' height='16' alt='Bez.'> ";
			echo "Bezirk <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;gbkennz=".$zgbbez."'>";		
			echo $zgbbez."</a>";
		echo "\n</div>";
		echo "\n<div class='gb' title='GB-Blatt'>";
			echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$blattgml."\")'>";
				echo "\n\t\t<img class='nwlink' src='ico/GBBlatt_link.ico' width='16' height='16' alt='Blatt'>";
			echo "\n\t</a> ";
			echo "Blatt <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;blattgml=".$blattgml."&amp;gbkennz=".$zgbbez."-".$zblatt."'>&nbsp;".$zblattn.$zblattz."&nbsp;</a>";
		echo "\n</div>";
	}

	// Blatt -> Buchungsstelle -> Flurstueck
	$linelimit = 200; // Max. Anzahl FS
	GB_Buchung_FS($linelimit); // Externe Function

	return 0; 
	
}

function gml_buchungsstelle() {
	// Kennzeichen "Bezirk + Blatt + BVNR" eingegeben. Dazu die gml_id der Buchungsstelle ermitteln.
	global $con, $gkz, $debug, $zgbbez, $zblatt, $zblattn, $zblattz, $zbvnr;
	// Blatt ->  B u c h u n g s s t e l l e
	$sql ="SELECT s.gml_id FROM ax_buchungsstelle s ";
	$sql.="JOIN alkis_beziehungen v ON s.gml_id=v.beziehung_von "; 
	$sql.="JOIN ax_buchungsblatt b ON b.gml_id=v.beziehung_zu "; 
	$sql.="WHERE v.beziehungsart='istBestandteilVon' ";
	$sql.="AND b.bezirk= $1 AND b.buchungsblattnummermitbuchstabenerweiterung ";
	if ($zblattz == "") { // Ohne Buchstabenerweiterung
		//Formate '123','000123 ','0000123'
		$sql.="IN ('".$zblattn."','".str_pad($zblattn, 6, "0", STR_PAD_LEFT)." ','".str_pad($zblattn, 7, "0", STR_PAD_LEFT)."')";
	} else { // Mit Buchstabenerweiterung: '000123A'
		$sql.="='".str_pad($zblattn, 6, "0", STR_PAD_LEFT).$zblattz."'";
	}
	$sql.=" AND s.laufendenummer= $2 ;";

	$v=array($zgbbez, $zbvnr);
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
		echo "\n<p class='err'>Buchung ".$zgbbez."-".$zblattn.$zblattz."-".$zbvnr." nicht gefunden.</p>";
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
	global $con, $gkz, $debug, $gemeinde, $epsg, $scalefs, $epsg, $auskpath, $gbuchung, $zgbbez, $zblatt, $zblattn, $zblattz, $zbvnr, $gfilter;
	// NoLimit?
	if ($showParent) { // wenn Kennzeichen bekannt ist, dann auch Blatt ausgeben

		if ($zgbbez.$zblatt != "") {
			// +++ Schlüssel ist bekannt. Namen und Amtsgericht dazu ermitteln
			// +++ oder Namen als &bez= übermitteln?
			echo "\n<div class='gk' title='GB-Bezirk'>";
				echo "\n\t\t<img class='nwlink' src='ico/GB-Bezirk.ico' width='16' height='16' alt='Bez.'> ";
				echo "<a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;gbkennz=".$zgbbez."'>";		
				echo "Bezirk ".$zgbbez."</a>";
			echo "\n</div>";			
			echo "\n<div class='gb' title='GB-Blatt'>";
				echo "\n\t\t<img class='nwlink' src='ico/GBBlatt.ico' width='16' height='16' alt='Blatt'> ";
				echo "Blatt <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;gbkennz=".$zgbbez."-".$zblatt."'>&nbsp;".$zblattn.$zblattz."&nbsp;</a>";
			echo "\n</div>";
		} else {
			echo "<p class='err'>Kennzeichen Bezirk und Blatt nicht gesetzt</p>";
		}

		echo "\n<div class='gs'>";
			echo "\n\t\t<img class='nwlink' title='Grundst&uuml;ck' src='ico/Grundstueck.ico' width='16' height='16' alt='GS'> ";
			echo "Buchung <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;gbuchung=".$gbuchung."&amp;gbkennz=".$zgbbez."-".$zblattn.$zblattz."-".$zbvnr."'>&nbsp;".$zbvnr."&nbsp;</a>";
		echo "\n</div>";
	}
	// +++ Ermitteln anderer Buchungsstellen mit Rechten an dieser
	// +++ Ermitteln anderer Buchungsstellen wo diese Rechte hat
	// +++ Filter "Gemeinde" berücksichtigt!! Wenn gesetzt.

	// SQL-Bausteine
	$sql1 ="SELECT g.gemeinde, g.gemarkungsname, f.gml_id, f.flurnummer, f.zaehler, f.nenner, ";
	if($epsg == "25832") { // Transform nicht notwendig
		$sql1.="st_x(st_Centroid(f.wkb_geometry)) AS x, ";
		$sql1.="st_y(st_Centroid(f.wkb_geometry)) AS y ";
	} else {  
		$sql1.="st_x(st_transform(st_Centroid(f.wkb_geometry),".$epsg.")) AS x, ";
		$sql1.="st_y(st_transform(st_Centroid(f.wkb_geometry),".$epsg.")) AS y ";			
	}
	$sql1.="FROM ";

	$sqla1 ="JOIN alkis_beziehungen vfb ON s1.gml_id = vfb.beziehung_zu ";
	$sqla2 ="JOIN alkis_beziehungen vfb ON s2.gml_id = vfb.beziehung_zu ";

	// Zwischen-JOIN (zusätzlich nur bei zweiter Abfrage)
	$sqlz ="JOIN alkis_beziehungen vss ON vss.beziehung_von = s1.gml_id ";
	$sqlz.="JOIN ax_buchungsstelle s2 ON vss.beziehung_zu = s2.gml_id ";

	$sql2 ="JOIN ax_flurstueck f ON ....  ";
	$sql2.="JOIN pp_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkung ";
	$sql2.="WHERE v.beziehungsart='istGebucht' AND v.beziehung_zu= $1 "; // id buchungsstelle
	switch ($gfilter) { // Filter Gemeinde
		case 1: // Einzelwert
			$sql2.="AND g.gemeinde=".$gemeinde." "; break;
		case 2: // Liste
			$sql2.="AND g.gemeinde in (".$gemeinde.") "; break;
	}
	$sql2.="ORDER BY f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner;";

	$sql=$sql1.$sqla1.$sql2; // Direkte Buchungen
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
		$gmkg=$row["gemarkungsname"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // Bruchnummer
		$x=$row["x"];
		$y=$row["y"];

		// FILTER OBEN, IN SQL - nicht HIER
		if($gemeinde > 0 and $gemeinde != $gemei and $gfilter == 1) { // ex-territorial 
			if ($debug >= 2) {
				echo "<p class='dbg'>Gemkg ".$gmkg." liegt in Gemeinde '".$gemei."' nicht '".$gemeinde."'</p>";
			}
			echo "\n<div class='fs' title='Kein Zugriff! Liegt au&szlig;erhalb des Gebietes.'>";
				echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Leer.ico' width='16' height='16' alt='FS'> (".$gmkg." ".$flur."-".$fskenn." )";
			echo "\n</div>";			
		} else {
			echo "\n<div class='fs'>";
				echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$fs_gml."\")'>";
					echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Link.ico' width='16' height='16' alt='FS'>";
				echo "\n\t</a> ";
				echo "\n\t".$gmkg." <a title='Flurst&uuml;ck positionieren 1:".$scalefs."' href='";
						echo "javascript:parent.parent.parent.mb_repaintScale(\"mapframe1\",".$x.",".$y.",".$scalefs."); ";						echo "parent.parent.showHighlight(".$x.",".$y.")' ";
					echo "onmouseover='parent.parent.showHighlight(".$x.",".$y.")' ";
					echo "onmouseout='parent.parent.hideHighlight()'>&nbsp;";
				echo $flur."-".$fskenn."&nbsp;</a>";
			echo "\n</div>";
		}
		$zfs++;
	}
	if($zfs == 0) {
		echo "\n<p class='anz'>Kein Flurst&uuml;ck.</p>";
	} elseif($zfs > 1) {
		echo "\n<p class='anz'>".$zfs." Flurst&uuml;ck.</p>";
	}
	return;
}

// ===========
// Start hier!
// ===========
if(isset($epsg)) {
	#if ($debug >= 2) {echo "<p class='dbg'>aktueller EPSG='".$epsg."'</p>";} // aus MB
	$epsg = str_replace("EPSG:", "" , $_REQUEST["epsg"]);	
} else {
	#if ($debug >= 1) {echo "<p class='err'>kein EPSG gesetzt</p>";}	
	$epsg=$gui_epsg; // aus Conf
}

if ($gemeinde == "") {
	$gfilter = 0; // ungefiltert
	#if ($debug >= 2) {echo "<p class='dbg'>Kein Filter Gemeinde</p>";}
} elseif(strpos($gemeinde, ",") === false) {
	$gfilter = 1; // Einzelwert
	#if ($debug >= 2) {echo "<p class='dbg'>Filter Gemeinde Einzelwert = '".$gemeinde."'</p>";}
} else {
	$gfilter = 2; // Liste
	#if ($debug >= 2) {echo "<p class='dbg'>Filter Gemeinde Liste = '".$gemeinde."'</p>";}
}

// Auch wenn redundant: Das Kennzeichen für Anzeige und weitere Links zerlegen
$kennztyp=ZerlegungGBKennz($gbkennz);
#if ($debug >= 2) {echo "<p class='dbg'>GB-Kennzeichen Typ=".$kennztyp."</p>";}

// Wurde eine gml_id (internes Kennzeichen) aus einem Self-Link verwendet?
// Dann hat das Prioritaet, also *nicht* nach $gbkennz suchen.
if ($gbuchung != "") { // gml der Buchungsstelle
	$trans="Buchungsstelle";
	EinGrundstueck(true);

} elseif($blattgml != "") { // gml des GB-Blattes

	// neue Version -> function GB_Buchung_FS
	$trans="GB-Blatt mit Buchungen und Flst.";
	EinBlatt(true);

/*	alte Version (ohne die Function))
	if (EinBlatt(true) == 1) { // darauf genau eine Buchung
		$gbuchung=gml_buchungsstelle(); // gml_id zum Kennzeichen
		$trans="Grundbuch-Blatt und 1 Buchung";
		EinGrundstueck(false);
	}
*/

} elseif(isset($ag)) { // Key des Amtsgerichtes
	#if ($debug >= 2) {echo "<p class='dbg'>Link Amtsgericht=".$ag."</p>";}
	$trans="GB-Bezirke zum Amtsgericht";
	ListAG( "'".$ag."'" ); // noch mal Kopfzeile
	ListGBBez("'".$ag."'", false);

} else { // Kein Self-Link, Eingabe im Formular

	switch ($kennztyp) {
		case 0: // keine Eingabe
			$trans="Liste der Amtsgerichte";
			ListAG($ag_liste);
			break;
		case 1: // Eingabe Bezirk-Name (-Teil) -> gefilterte Liste der Bezirke
			$trans="Grundbuchbezirke gefiltert";
			$beznr=SuchGBBezName();
			if ($beznr > 0) {  // eindeutig
				$zgbbez=$beznr;
				$trans="Bezirk gefunden, Bl&auml;tter dazu";
				EinBezirk(false); // gleich weiter
			};
			break;
		case 2: // Eingabe Bezirk-Nummer -> Liste der Blätter
			$trans="Bl&auml;tter im GB-Bezirk";
			EinBezirk(true);
			break;
		case 3: // Eingabe Blatt -> Liste der Buchungen
			$trans="Buchungen auf GB-Blatt";
			$blattgml=gml_blatt(); // gml_id zum Blatt suchen
			if ($blattgml != "") { // gefunden		
				if (EinBlatt(true) == 1) { // darauf genau eine Buchung
					$trans="GB-Blatt und 1 Buchung";
					$gbuchung=gml_buchungsstelle(); // gml_id zum Kennzeichen
					EinGrundstueck(false);
				}
			}
			break;
		case 4: // Eingabe Buchung (Grundstueck) -> Liste der Flurstuecke
			$trans="Flurst. zur Buchungsstelle";
			$gbuchung=gml_buchungsstelle(); // gml_id zum Kennzeichen
			if ($gbuchung != "") { // .. wurde geliefert 
				$trans="Buchungsstelle und 1 Flurst.";
				EinGrundstueck(true);
			}
			break;
		case 9: // Fehler
			$trans="fehlerhafte Eingabe";
			echo "\n<p class='err'>Bitte ein g&uuml;ltiges Grundbuchkennzeichen eingegeben, Format 'gggg-999999A-llll</p>";
			break;
	}
}
// Titel im Kopf anzeigen
echo "\n<script type='text/javascript'>\n\ttranstitle('".$trans."')\n</script>";
?>

</body>
</html>