<?php
/* Version vom
	13.01.2011
	25.03.2011 Filter als Gemeinde-Liste
	12.04.2011 epsg in Link, transform nur wenn notwendig
	12.05.2011 Syntaxfehler in SQL
	25.07.2011 PostNAS 0.5/0.6 Versionen unterscheiden
	24.10.2011 Nach Pos-Klick Highlight erneuern statt hideHighlight
	07.11.2011 optional auch Historische FS suchen, Link auf Buchauskunft-Modul alkisfshis.php
	09.11.2011 "h" hinter Flur oder Flurstück sucht sofort in Historie
					Ausgabe Flur in Varianten aktuell/historisch mit gegenseitigen Verweisen 
	ToDo:
		Hist: Gemarkung entschlüsseln
		Hist: die Nachfolger-Liste gleich in der DB nachschlagen, und aktuelle FS als solche anzeigen
		Hist: Icons für Link (mit Pfeil), Icons H/O unterscheiden
*/
import_request_variables("PG");
include("../../conf/alkisnav_conf.php");$con_string = "host=".$host." port=".$port." dbname=".$dbname.$dbvers.$gkz." user=".$user." password=".$password;
$con = pg_connect ($con_string) or die ("Fehler bei der Verbindung zur Datenbank ".$dbname.$dbvers.$gkz);
?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ALKIS-Suche Flurst&uuml;ck</title>
	<link rel="stylesheet" type="text/css" href="alkisnav.css">
</head>
<body>

<?php

function is_ne_zahl($wert) {
	// Prueft, ob ein Wert ausschließlich aus den Zahlen 0 bis 9 besteht
	if (trim($wert, "0..9") == "") {return true;} else {return false;}
}

function h_hinten($zahl) {
	// Testen: Wurde an eine Zahl ein "h" angehängt?
	// Wenn ja, dann Schalter setzen und nur numerischen Teil zurück geben.
	global $phist, $debug;
//	if ($debug >= 2) {echo "<p class='dbg'>Teilen '".$zahl."'</p>";}		
	$zahl=trim($zahl);	
	$zlen=strlen($zahl) - 1;
	if ($zlen > 0) { 
		$hinten = ucfirst(substr($zahl, $zlen, 1));
		if ($hinten == "H" ) {
			$vorn=trim(substr($zahl, 0, $zlen));
			if (is_ne_zahl($vorn)) { // Zahl *und* "H"
				$zahl = $vorn;
				$phist = true;
			}
		}
	}
//	if ($debug >= 2) {echo "<p class='dbg'>Teile '".$vorn."'/'".$hinten."'</p>";}	
	return $zahl;
}

function ZerlegungFsKennz($fskennz) {
// Das eingegebene Flurstücks-Kennzeichen auseinander nehmen. Erwartet wird gggg-fff-zzzz/nnn
	global $debug, $zgemkg, $zflur, $zzaehler, $znenner;	//	if ($debug > 1) {echo "<p class='dbg'>Zerlegen: '".$fskennz."'</p>";}
	$arr = explode("-", $fskennz, 4);
	$zgemkg=trim($arr[0]);
	$zflur=h_hinten($arr[1]);
	$zfsnr=trim($arr[2]);
	if ($debug > 1) {echo "<p class='dbg'>Gemkg: '".$zgemkg."' Flur: '".$zflur."' NR: '".$zfsnr."'</p>";}
	
	if ($zgemkg == "") {
		return 0; // Gemeinden oder Gemarkungen listen
	} elseif ( ! is_ne_zahl($zgemkg)) {
		return 1; // Such Name
	} elseif ($zflur == "") {
		return 2; // G-Nr
	} elseif ( ! is_ne_zahl($zflur)) {
		echo "<p class='err'>Die Flurnummer '".$zflur."' ist nicht numerisch</p>";
		return 9;
	} elseif ($zfsnr == "") {
		return 3; // Flur				
	} else {
		$zn=explode("/", $zfsnr, 2);
		$zzaehler=h_hinten(trim($zn[0]));
		$znenner =h_hinten(trim($zn[1]));
		if ( ! is_ne_zahl($zzaehler)) {
			echo "<p class='err'>Flurstücksnummer '".$zzaehler."' ist nicht numerisch</p>";
			return 9;
		} elseif ($znenner == "") {
			return 4;
		} elseif (is_ne_zahl($znenner)) {
			return 5;								
		} else {
			echo "<p class='err'>Flurstücks-Nenner '".$znenner."' ist nicht numerisch</p>";
			return 9;
		}
	}
}

function ListGemeinden() {
	// bei Leereingabe die Gemeinden anlisten
	global $con, $gkz, $gemeinde, $epsg, $debug, $gfilter;
	$linelimit=50;
	$sql ="SELECT DISTINCT g.gemeinde AS key, g.bezeichnung FROM ax_gemeinde g ";
	$sql.="JOIN gemeinde_gemarkung v ON g.regierungsbezirk=v.regierungsbezirk AND g.kreis=v.kreis AND g.gemeinde=v.gemeinde ";
	// "ax_gemeinde" enthält mehrfache Gemeinde-Schluessel (Filtern regierungsbezirk, kreis)	
	// "gemeinde_gemarkung" enthaelt nur gefüllte Gemarkungen aber Gemeinde mehrfach
	switch ($gfilter) {
		case 1: // Einzelwert
			$sql.="WHERE g.gemeinde=".$gemeinde." ";
			break;
		case 2: // Liste
			$sql.="WHERE g.gemeinde in (".$gemeinde.") ";
			break;
		default: // kein Filter
			break;
	}
	$sql.=" ORDER BY g.bezeichnung LIMIT $1 ;";
	$res=pg_prepare("", $sql);
	$res=pg_execute("", array($linelimit));
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Gemeinde</p>";
		if ($debug >= 3) {echo "\n<p class='dbg'>".$sql."</p>";}
		return 0;
	}
	$cnt = 0;
	while($row = pg_fetch_array($res)) {
		$stadt=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
		$bez=urlencode($row["bezeichnung"]);  // Uebergeben an ListGmkgInGemeinde
		$gnr=$row["key"];		echo "\n<div class='gm' title='Gemeinde'>";
			echo "\n\t\t<img class='nwlink' src='ico/Gemeinde.ico' width='16' height='16' alt='Stadt'>";
			echo " Gem. <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;gm=".$gnr."&amp;bez=".$bez."'>";		
			echo  " ".$stadt."</a> (".$gnr.")";
		echo "\n</div>";
		$cnt++;
	}
	if($cnt == 0){ 
		echo "\n<p class='err'>Keine Gemeinde.</p>";
	} elseif($cnt >= $linelimit) {
		echo "\n<p title='Bitte eindeutiger qualifizieren'>... und weitere</p>";
	} elseif($cnt == 1) { // Eindeutig!
		return $gnr; 
	}
	return 0;
}

function ListGmkgInGemeinde($gkey) {
// Die (gefuellten) Gemarkungen zu einem Gemeinde-Key (aus Link) listen
	global $con, $gkz, $gemeinde, $epsg, $debug, $gfilter, $bez;
	$linelimit=70;
	$sql ="SELECT g.gemarkungsnummer, g.bezeichnung ";
	$sql.="FROM ax_gemarkung g JOIN gemeinde_gemarkung v ON g.gemarkungsnummer=v.gemarkung ";
   $sql.="WHERE v.gemeinde= $1 ORDER BY g.bezeichnung LIMIT $2 ;";
	$res=pg_prepare("", $sql);
	$res=pg_execute("", array($gkey, $linelimit));
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Gemarkungen</p>";
		if ($debug >= 3) {echo "\n<p class='dbg'>".$sql."</p>";}
		return 0;
	}
	// Hierarchie Dokumentieren, Gemeinde-Name?
	echo "\n<div class='gm' title='Gemeinde'>";
		echo "\n\t\t<img class='nwlink' src='ico/Gemeinde.ico' width='16' height='16' alt='Stadt'>";	
		echo  " Gem. ".$bez." (".$gkey.")"; // .urldecode($bez). ??
	echo "\n</div>";
	$cnt = 0;
	while($row = pg_fetch_array($res)) {
		$gnam=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
		$gnr=$row["gemarkungsnummer"];		echo "\n<div class='gk' title='Gemarkung'>";
			echo "\n\t\t<img class='nwlink' src='ico/Gemarkung.ico' width='16' height='16' alt='Gemarkung'>";
			echo " OT <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;fskennz=".$gnr."'>";		
			echo  " ".$gnam."</a> (".$gnr.")";
		echo "\n</div>";
		$cnt++;
	}
	if($cnt == 0){ 
		echo "\n<p class='err'>Keine Gemarkung.</p>";
	} elseif($cnt >= $linelimit) {
		echo "\n<p title='Bitte eindeutiger qualifizieren'>... und weitere</p>";
	} elseif($cnt == 1) { // Eindeutig!
		return $gnr; 
	}
	return 0;
}

function SuchGmkgName() {
// Gemarkung suchen nach Name(-nsanfang)
	global $con, $gkz, $gemeinde, $epsg, $debug, $fskennz, $gfilter;
	$linelimit=120;
	if(preg_match("/\*/",$fskennz)){
		$match = trim(preg_replace("/\*/i","%", strtoupper($fskennz)));
	} else {
		$match = trim($fskennz)."%";
	}	
	$sql ="SELECT v.gemeindename, g.gemarkungsnummer, g.bezeichnung ";
	$sql.="FROM ax_gemarkung g JOIN gemeinde_gemarkung v ON g.gemarkungsnummer=v.gemarkung ";
   $sql.="WHERE bezeichnung ILIKE $1 ";
	switch ($gfilter) {
		case 1: // Einzelwert
			$sql.="AND v.gemeinde=".$gemeinde." ";
			break;
		case 2: // Liste
			$sql.="AND v.gemeinde in (".$gemeinde.") ";
			break;
		default: // kein Filter
			break;
	}
	$sql.=" ORDER BY g.bezeichnung LIMIT $2 ;";
	$v=array($match, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Gemarkung</p>";
		if ($debug >= 3) {echo "\n<p class='dbg'>".$sql."</p>";}
		return 0;
	}
	$cnt = 0;
	while($row = pg_fetch_array($res)) {
		$gnam=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
		$gnr=$row["gemarkungsnummer"];
		$stadt=$row["gemeindename"];		echo "\n<div class='gk' title='Gemarkung'>";
			echo "\n\t\t<img class='nwlink' src='ico/Gemarkung.ico' width='16' height='16' alt='Gemarkung'>";
			echo " OT <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;fskennz=".$gnr."'>";		
			echo  " ".$gnam."</a> (".$gnr.")";
			switch ($gfilter) {
				case 0: // Kein Filter
					echo " ".$stadt;
					break;
				case 2: // Liste
					echo " ".$stadt;
					break;
				default: // Einzelwert
					break;
			}
		echo "\n</div>";
		$cnt++;
	}
	if($cnt == 0){ 
		echo "\n<p class='err'>Keine Gemarkung.</p>";
	} elseif($cnt >= $linelimit) {
		echo "\n<p title='Bitte eindeutiger qualifizieren'>... und weitere</p>";
	} elseif($cnt == 1) { // Eindeutig!
		return $gnr; 
	}
	return 0;
}

function EineGemarkung($AuchGemkZeile) {
	// Kennzeichen bestehend nur aus Gemarkung-Schlüssel wurde eingegeben
	global $con, $gkz, $gemeinde, $epsg, $debug, $zgemkg;
	$linelimit=120; // max. Fluren je Gemarkung
	if ($AuchGemkZeile) {
		$sql ="SELECT bezeichnung FROM ax_gemarkung g WHERE g.gemarkungsnummer= $1 ;"; // WHERE f.land= ?
		$v=array($zgemkg);
		$res=pg_prepare("", $sql);
		$res=pg_execute("", $v);
		if (!$res) {echo "\n<p class='err'>Fehler bei Gemarkung.</p>";}
		$zgmk=0;
		while($row = pg_fetch_array($res)) {	
			$gmkg=$row["bezeichnung"];
			$zgmk++;
		}
		if ($zgmk == 0) {
			echo "\n<div class='gk' title='Gemarkung'>";
				echo "\n\t\t<p class='err'><img class='nwlink' src='ico/Gemarkung.ico' width='16' height='16' alt='Gemarkung'>";
					echo  " Gemarkung ".$zgemkg." ist unbekannt.</p>";
			echo "\n</div>";
			return;
		}
		// > 1 auch möglich?
		echo "\n<div class='gk' title='Gemarkung'>";
			echo "\n\t\t<img class='nwlink' src='ico/Gemarkung.ico' width='16' height='16' alt='Gemarkung'> ";
			echo " OT <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;fskennz=".$zgemkg."'>";		
			echo $gmkg."</a>  (".$zgemkg.")"; // in Gemeinde?
		echo "\n</div>";
	}
	$sql ="SELECT gemarkungsteilflur AS flur FROM ax_gemarkungsteilflur f ";
	$sql.="WHERE gemarkung= $1 ORDER BY gemarkungsteilflur LIMIT $2 ;"; 	// WHERE f.land= ?
	$v=array($zgemkg, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {echo "\n<p class='err'>Fehler bei Flur.</p>";}
	$zfl=0;
	while($row = pg_fetch_array($res)) {	
		$flur=$row["flur"];
		echo "\n<div class='fl' title='Flur'>";
			echo "\n\t\t<img class='nwlink' src='ico/Flur.ico' width='16' height='16' alt='Flur'>&nbsp;";
			echo "Flur<a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;fskennz=".$zgemkg."-".$flur."'>&nbsp;".$flur."&nbsp;</a>";
		echo "\n</div>";
		$zfl++;
	}
	if($zfl == 0) { 
		echo "\n<p class='err'>Keine Flur.</p>";
	} elseif($cnt >= $linelimit) {
		echo "\n<p>... und weitere</p>";
	}
	return;
}

function gemkg_zeile($zgemkg) {
// Zeile zu Gemarkung ausgeben, gkg-schlüssel übergeben

	global $con, $gkz, $gemeinde, $epsg;

	$sql ="SELECT bezeichnung FROM ax_gemarkung g WHERE g.gemarkungsnummer= $1 ;";
	$v=array($zgemkg);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {echo "\n<p class='err'>Fehler bei Gemarkung.</p>";}
	$zgmk=0;
	while($row = pg_fetch_array($res)) {	
		$gmkg=$row["bezeichnung"];
		$zgmk++;
	}
	if ($zgmk == 0) {
		echo "\n<div class='gk' title='Gemarkung'>";
			echo "\n\t\t<p class='err'><img class='nwlink' src='ico/Gemarkung.ico' width='16' height='16' alt='Gemarkung'>";
				echo  " Gemarkung ".$zgemkg." ist unbekannt.</p>";
		echo "\n</div>";
		return;
	}
	echo "\n<div class='gk' title='Gemarkung'>";
		echo "\n\t\t<img class='nwlink' src='ico/Gemarkung.ico' width='16' height='16' alt='Gemarkung'>";
		echo " OT <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;fskennz=".$zgemkg."'> ".$gmkg." (".$zgemkg.")</a>";
	echo "\n</div>";
	return 0;
}

function EineFlur() {
	// Kennzeichen aus Gemarkung und FlurNr wurde eingegeben, dazu aktuelle Flurstücke suchen
	global $con, $gkz, $gemeinde, $epsg, $debug, $scalefs, $auskpath, $zgemkg, $zflur;
	$linelimit=600; // Wie groß kann eine Flur sein?

	gemkg_zeile($zgemkg);
	echo "\n<div class='fl' title='Flur'>";
		echo "\n\t\t<img class='nwlink' src='ico/Flur.ico' width='16' height='16' alt='Flur'> ";
		$url=$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;fskennz=".$zgemkg."-".$zflur;
		echo "Flur <a href='".$url."'>".$zflur."</a>";
		//echo "<span class='hislnk'>";
		echo " <a class='hislnk' title='Historische Flurst&uuml;cke' href='".$url."&amp;hist=j'>Hist.</a>";		
	echo "\n</div>";

	$sql ="SELECT f.gml_id, f.flurnummer, f.zaehler, f.nenner, f.gemeinde, ";
	if($epsg == "25832") { // Transform nicht notwendig
		$sql.="x(st_Centroid(f.wkb_geometry)) AS x, ";
		$sql.="y(st_Centroid(f.wkb_geometry)) AS y ";
	}
	else {  
		$sql.="x(st_transform(st_Centroid(f.wkb_geometry), ".$epsg.")) AS x, ";
		$sql.="y(st_transform(st_Centroid(f.wkb_geometry), ".$epsg.")) AS y ";			
	}
   $sql.="FROM ax_flurstueck f WHERE f.gemarkungsnummer= $1 AND f.flurnummer= $2 ";
	$sql.="ORDER BY f.zaehler, f.nenner LIMIT $3 ;"; // WHERE f.land= ?
	$v=array($zgemkg, $zflur, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {echo "\n<p class='err'>Fehler bei Flur.</p>";}
	$zfs=0;
	while($row = pg_fetch_array($res)) {	
		$fs_gml=$row["gml_id"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // Bruchnummer
		$x=$row["x"];
		$y=$row["y"];
		echo "\n<div class='fs'>";
			echo "\n\t<a title='Nachweis' target='_blank' href='".$auskpath."alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$fs_gml."'>";
				echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Link.ico' width='16' height='16' alt='FS'>";
			echo "\n\t</a> ";			
			echo "\n\tFlst. <a title='Flurst&uuml;ck positionieren 1:".$scalefs."' href='";
					echo "javascript:parent.parent.parent.mb_repaintScale(\"mapframe1\",".$x.",".$y.",".$scalefs."); ";
					echo "parent.parent.showHighlight(".$x.",".$y.");' ";
				echo "onmouseover='parent.parent.showHighlight(".$x.",".$y.")' ";
				echo "onmouseout='parent.parent.hideHighlight()'>&nbsp;".$fskenn."&nbsp;</a>";
		echo "\n</div>";
		$zfs++;
	}
	if($zfs == 0) { 
		echo "\n<p class='err'>Kein Flurst&uuml;ck.</p>";
	} elseif($zfs >= $linelimit) {
		echo "\n<p>... und weitere</p>";
	}
	return;
}

function HistFlur() {
	// Kennzeichen aus Gemarkung und FlurNr wurde eingegeben
	// Die Flur nach Historischen Flurstücken durchsuchen
	global $con, $gkz, $gemeinde, $epsg, $debug, $scalefs, $auskpath, $land, $zgemkg, $zflur;
	$linelimit=400;

	gemkg_zeile($zgemkg);
	echo "\n<div class='fl' title='Flur'>";
		echo "\n\t\t<img class='nwlink' src='ico/Flur.ico' width='16' height='16' alt='Flur-Historie'> ";
		$url=$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;fskennz=".$zgemkg."-".$zflur;
		echo "Historie: Flur<a title='Aktuelle Flurst&uuml;cke suchen' href='".$url."'> ".$zflur." </a>"; 
	echo "\n</div>";

	$whcl.="WHERE flurstueckskennzeichen like $1 ";
	$sql ="SELECT 'h' AS ftyp, gml_id, zaehler, nenner, nachfolgerflurstueckskennzeichen as nachf FROM ax_historischesflurstueck ".$whcl;
	$sql.="UNION SELECT 'o' AS ftyp, gml_id, zaehler, nenner, nachfolgerflurstueckskennzeichen as nachf FROM ax_historischesflurstueckohneraumbezug ".$whcl;
	$sql.="ORDER BY zaehler, nenner LIMIT $2 ;"; 
	$fskzwhere =$land.$zgemkg.str_pad($zflur, 3, "0", $STR_PAD_LEFT)."%";
	$v=array($fskzwhere,   $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {echo "\n<p class='err'>Fehler bei Historie Flur.</p>";}
	$zfs=0;

	// Konst. Teil d.URL (Flur), FS anhängen
	$flurl=$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;hist=j&amp;fskennz=".$zgemkg."-".$zflur."-";

	while($row = pg_fetch_array($res)) {	
		$ftyp=$row["ftyp"];
		$fs_gml=$row["gml_id"];	// fuer Buchausk.
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // Bruchnummer

		//++	if ($ftyp == "h") { } else { }  // versch. Icons? h: Karte Pos.?
		echo "\n<div class='hi' title='Historisches Flurst&uuml;ck'>"; // Zeile
			// Icon -> Bauchauskunft
			echo "\n\t<a title='Nachweis' target='_blank' href='".$auskpath."alkisfshist.php?gkz=".$gkz."&amp;gmlid=".$fs_gml."'>";
				echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Historisch.ico' width='16' height='16' alt='Hist'>";
			echo "\n\t</a> ";		
			// Kennzeichen -> weiter in die Historie hinein
			echo "\n\tFlst. <a href='".$flurl.$fskenn."'>".$fskenn."</a>";					
		echo "\n</div>";
		$zfs++;
	}
	if($zfs == 0) { 
		echo "\n<p class='err'>Kein historisches Flurst&uuml;ck.</p>";
		if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = ".$fskzwhere."</p>";}
	} elseif($zfs >= $linelimit) {
		echo "\n<p>... und weitere</p>";
	}
	return;
}

function EinFlurstueck() {
	// Flurstückskennzeichen komplett bis zum Zaehler eingegeben
	// Sonderfall: bei Bruchnummer, mehrere Nenner zum Zaehler
	global $con, $gkz, $debug, $scalefs, $epsg, $auskpath, $fskennz, $zgemkg, $zflur, $zzaehler, $znenner;

	$sql ="SELECT f.gml_id, f.flurnummer, f.zaehler, f.nenner, ";
	if($epsg == "25832") { // Transform nicht notwendig
		$sql.="x(st_Centroid(f.wkb_geometry)) AS x, ";
		$sql.="y(st_Centroid(f.wkb_geometry)) AS y, ";
	}
	else {  
		$sql.="x(st_transform(st_Centroid(f.wkb_geometry), ".$epsg.")) AS x, ";
		$sql.="y(st_transform(st_Centroid(f.wkb_geometry), ".$epsg.")) AS y, ";			
	}

	$sql.="g.bezeichnung ";
   $sql.="FROM ax_flurstueck f JOIN ax_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer ";
	$sql.="WHERE f.gemarkungsnummer= $1 AND f.flurnummer= $2 AND f.zaehler= $3 ";
	If ($znenner != "") {$sql.="AND f.nenner=".$znenner." ";} // wie prepared?
	$sql.="ORDER BY f.zaehler, f.nenner;"; // WHERE f.land= ?
	$v=array($zgemkg, $zflur, $zzaehler);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {echo "\n<p class='err'>Fehler bei Flurst&uuml;ck.</p>";}
	$zfs=0;
	while($row = pg_fetch_array($res)) {	
		$fs_gml=$row["gml_id"];
		$gmkg=$row["bezeichnung"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // Bruchnummer
		$x=$row["x"];
		$y=$row["y"];
		echo "\n<div class='fs'>";
			echo "\n\t<a title='Nachweis' target='_blank' href='".$auskpath."alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$fs_gml."'>";
				echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Link.ico' width='16' height='16' alt='FS'>";
			echo "\n\t</a> ";		
			echo "\n\tFlst. <a title='Flurst&uuml;ck positionieren 1:".$scalefs."' href='";
					echo "javascript:parent.parent.parent.mb_repaintScale(\"mapframe1\",".$x.",".$y.",".$scalefs."); ";
					echo "parent.parent.showHighlight(".$x.",".$y.");' ";
				echo "onmouseover='parent.parent.showHighlight(".$x.",".$y.")' ";
				echo "onmouseout='parent.parent.hideHighlight()'>";
			echo $gmkg." ".$flur."-".$fskenn."</a>";
		echo "\n</div>";
		$zfs++;
	}
	if($zfs == 0) {
		echo "\n<p class='err'>Kein aktuelles Flurst&uuml;ck.</p>";

		// Soll in der Historie weiter gesucht werden?
		echo "\n<div class='hi' title='Historie'>";
			echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Historisch.ico' width='16' height='16' alt='Historisches Flurst&uuml;ck'>&nbsp;";
			echo "<a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;fskennz=".$fskennz."&amp;hist=j'>in Historie suchen</a>";
		echo "\n</div>";		
	}
	return;
}

function HistFlurstueck() {
	// Ein Nachfolger-FS-Kennzeichen soll recherchiert werden.
	// Es ist unbekannt, ob dies aktuell ist oder auch schon historisch.
	global $con, $gkz, $debug, $scalefs, $epsg, $auskpath, $land, $zgemkg, $zflur, $zzaehler, $znenner;

	// Suche ueber das Flurstueckskennzeichen, gml ist meist unbekannt
	$whcl.="WHERE flurstueckskennzeichen= $1 ";

	$sql ="SELECT 'a' AS ftyp, gml_id, gemarkungsnummer, flurnummer, zaehler, nenner, null as nachf FROM ax_flurstueck ".$whcl;
	$sql.="UNION SELECT 'h' AS ftyp, gml_id, gemarkungsnummer, flurnummer, zaehler, nenner, nachfolgerflurstueckskennzeichen as nachf FROM ax_historischesflurstueck ".$whcl;
	$sql.="UNION SELECT 'o' AS ftyp, gml_id, gemarkungsnummer, flurnummer, zaehler, nenner, nachfolgerflurstueckskennzeichen as nachf FROM ax_historischesflurstueckohneraumbezug ".$whcl;

	$fskzwhere =$land.$zgemkg; // Flurst-Kennz. f. Where
	$fskzwhere.=str_pad($zflur, 3, "0", $STR_PAD_LEFT);
	$fskzwhere.=str_pad($zzaehler, 5, "0", $STR_PAD_LEFT);
	if ($znenner == "") {$fskzwhere.="______";}
	else {$fskzwhere.=str_pad($znenner, 4, "0", $STR_PAD_LEFT)."__";}

	$v=array($fskzwhere);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {echo "\n<p class='err'>Fehler bei hist. Flurst&uuml;ck.</p>";}
	$zfs=0;
	while($row = pg_fetch_array($res)) {
		$ftyp=$row["ftyp"];
		$fs_gml=$row["gml_id"];
		$gknr=$row["gemarkungsnummer"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		$nachf=$row["nachf"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // Bruchnummer

		if ($ftyp == "a") { // aktuelles FS gefunden, Koordinate holen
			$sql ="SELECT ";
			if($epsg == "25832") { // Transform nicht notwendig
				$sql.="x(st_Centroid(wkb_geometry)) AS x, ";
				$sql.="y(st_Centroid(wkb_geometry)) AS y ";
			} else {  
				$sql.="x(st_transform(st_Centroid(wkb_geometry), ".$epsg.")) AS x, ";
				$sql.="y(st_transform(st_Centroid(wkb_geometry), ".$epsg.")) AS y ";			
			}
		   $sql.="FROM ax_flurstueck WHERE gml_id= $1 ";
			$v=array($fs_gml);
			$res=pg_prepare("", $sql);
			$res=pg_execute("", $v);
			if (!$res) {echo "\n<p class='err'>Fehler bei Koordinate.</p>";}
			$zfs=0;
			while($row = pg_fetch_array($res)) {	
				$x=$row["x"];
				$y=$row["y"];
				$zfs++;
			}
			if ($zfs == 0) {echo "\n<p class='err'>Kein Treffer bei Koordinate.</p>";}
			echo "\n<p>aktueller Nachfolger:</p>";	
			echo "\n<div class='fs' title='Aktuelles Nachfolger-Flurst&uuml;ck'>"; // Zeile

				// Icon -> Nachweis FS-Hist. in Buchauskunft
				echo "\n\t<a title='Nachweis' target='_blank' href='".$auskpath."alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$fs_gml."'>";
					echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Link.ico' width='16' height='16' alt='FS'>";
				echo "\n\t</a> ";	

				// Kennzeichen -> Karte positionieren
				echo "\n\tFlst. <a title='Flurst&uuml;ck positionieren 1:".$scalefs."' href='";
						echo "javascript:parent.parent.parent.mb_repaintScale(\"mapframe1\",".$x.",".$y.",".$scalefs."); ";
						echo "parent.parent.showHighlight(".$x.",".$y.");' ";
					echo "onmouseover='parent.parent.showHighlight(".$x.",".$y.")' ";
					echo "onmouseout='parent.parent.hideHighlight()'>";
				echo $gmkg." ".$flur."-".$fskenn."</a>";

			echo "\n</div>";

		} else { // Historisches FS gefunden (h oder o)
			echo "\n<p>Historisches Flurst&uuml;ck:</p>";

			// Zeile
			echo "\n<div class='hi' title='Historisches Flurst&uuml;ck'>";
				echo "\n\t<a title='Nachweis' target='_blank' href='".$auskpath."alkisfshist.php?gkz=".$gkz."&amp;gmlid=".$fs_gml."'>";
					echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Historisch.ico' width='16' height='16' alt='Hist'>";
				echo "\n\t</a> ";		
				echo "\n\t ".$gknr."-".$flur."-".$fskenn."</a>";
			echo "\n</div>";

			// Nachfolger ermitteln
			if ($nachf == "") {
				echo "\n<p class='err'>keine Nachfolger</p>";	
			} else {
				echo "\n<p>Nachfolger-Flurst&uuml;cke:</p>";	
				$stri=trim($nachf, "{}");
				$arr = split(",",$stri);
				foreach($arr AS $val){
					$fst=rtrim($val,"_");	
					$zer=substr ($fst, 2, 4)."-".ltrim(substr($fst, 6, 3), "0")."-".ltrim(substr($fst, 9, 5),"0");
					$nenn=ltrim(substr($fst, 14), "0");
					if ($nenn != "") {$zer.="/".$nenn;}

// +++ besser: array in Where kennz in ( , , ) umwandeln
// aktuelle FS gleich als solche anzeigen

					// Zeile Nachfolger
					echo "\n<div class='hn' title='Historie Nachfolger'>";

						// Icon -> Nachweis					
						echo "\n\t<a title='Nachweis' target='_blank' href='".$auskpath."alkisfshist.php?gkz=".$gkz."&amp;fskennz=".$val."'>";
							echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Historisch.ico' width='16' height='16' alt='Hist'>";
						echo "\n\t</a> ";		

						// Kennzeichen -> weiter in die Historie hinein
						echo "<a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;fskennz=".$zer."&amp;hist=j'>".$zer."</a>";					

					echo "\n</div><br>";
				}
			}
		}
		$zfs++;
	}
	if($zfs == 0) {
		echo "\n<p class='err'>Kein historisches Flurst&uuml;ck.</p>";
		if ($debug > 2) {echo "<p class='dbg'>".$sql."</p>";}
	}
	return;
}

// ===========
// Start hier!
// ===========
if(isset($epsg)) {
	//if ($debug >= 2) {echo "<p class='dbg'>aktueller EPSG='".$epsg."'</p>";} // aus MB
	$epsg = str_replace("EPSG:", "" , $_REQUEST["epsg"]);	
} else {
	if ($debug >= 1) {echo "<p class='dbg'>kein EPSG gesetzt</p>";}	
	$epsg=$gui_epsg; // aus Conf
}
//if ($debug >= 2) {echo "<p class='dbg'>Filter Gemeinde = ".$gemeinde."</p>";}
if ($gemeinde == "") {
	$gfilter = 0; // ungefiltert
} elseif(strpos($gemeinde, ",") === false) {
	$gfilter = 1; // Einzelwert
} else {
	$gfilter = 2; // Liste
}
if ($hist == "j") {$phist = true;} else {$phist = false;}

if(isset($gm)) { // Self-Link aus Gemeinde-Liste 
	$gnr=ListGmkgInGemeinde($gm); // Gemarkungen zu dieser Gemeinde listen
	if ($gnr > 0) {
		$zgemkg=$gnr;
		EineGemarkung(false);
	}
} else {
	// Die Formular-Eingabe interpretieren (kann auch ein Link sein)
	$retzer=ZerlegungFsKennz($fskennz);
//	if ($debug > 1) {echo "<p class='dbg'>Return Zerlegung (case) = '".$retzer."'</p>";}	
	switch ($retzer) {
	case 0: // leere Eingabe
		if ($gfilter == 1) { // Die GUI ist bereits auf eine Gemeinde gefiltert
			SuchGmkgName(); // Gemarkungen listen
		} else {
			ListGemeinden(); // alle Gemeinden Listen
		}
	break;
	case 1:
		if ($debug >= 2) {echo "<p class='dbg'>Gemarkungsname ".$zgemkg."</p>";}
		$gnr=SuchGmkgName();
		if ($gnr > 0) {
			$zgemkg=$gnr;
			EineGemarkung(false);
		}
	break;
	case 2:
		if ($debug >= 2) {echo "<p class='dbg'>Gemarkungsnummer ".$zgemkg."</p>";}	
		EineGemarkung(true);
	break;
	case 3:
		if ($debug >= 2) {echo "<p class='dbg'>Gemarkung ".$zgemkg." Flur ".$zflur."</p>";}
		if ($phist)	{HistFlur();} else {EineFlur();}
	break;
	case 4:
		if ($debug >= 2) {echo "<p class='dbg'>Gemarkung ".$zgemkg." Flur ".$zflur." Flurstück ".$zzaehler."</p>";}
		if ($phist)	{HistFlurstueck();} else {EinFlurstueck();}
	break;
	case 5:
		if ($debug >= 2) {echo "<p class='dbg'>Gemarkung ".$zgemkg." Flur ".$zflur." Flurstück ".$zzaehler."/".$znenner."</p>";}
		if ($phist) {HistFlurstueck();} else {EinFlurstueck();}		
	break;
	case 9:
		echo "<p class='err'>Bitte ein Flurst&uuml;ckskennzeichen eingegeben, Format 'gggg-fff-zzzz/nnn</p>";
	break;
	}
}
?>

</body>
</html>