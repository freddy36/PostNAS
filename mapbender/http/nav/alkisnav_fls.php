<?php
/* Version vom
	2013-04-16	"import_request_variables" entfällt in PHP 5.4, 
					Fehlerkorrektur Komma in SQL bei FS-Suche.
	2013-04-26	Ersetzen View "gemeinde_gemarkung" durch Tabelle "pp_gemarkung"
					Zurück-Link, Titel der Transaktion anzeigen
	2013-04-29	Test mit IE
	2013-05-07  Strukturierung des Programms, redundanten Code in Functions zusammen fassen
	2013-05-14  Variablen-Namen geordnet, Hervorhebung aktuelles Objekt, Title auch auf Icon, IE zeigt sonst alt= als Title dar.
*/
$cntget = extract($_GET);
include("../../conf/alkisnav_conf.php");
include("alkisnav_fkt.php"); // Funktionen$con_string = "host=".$host." port=".$port." dbname=".$dbname.$dbvers.$gkz." user=".$user." password=".$password;
$con = pg_connect ($con_string) or die ("Fehler bei der Verbindung zur Datenbank ".$dbname.$dbvers.$gkz);
echo <<<END
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ALKIS-Suche Flurst&uuml;ck</title>
	<link rel="stylesheet" type="text/css" href="alkisnav.css">
	<script type="text/javascript">
		function imFenster(dieURL) {
			var link = encodeURI(dieURL);
			window.open(link,'','left=10,top=10,width=620,height=800,resizable=yes,menubar=no,toolbar=no,location=no,status=no,scrollbars=yes');
		}
		function transtitle(trans) {
			document.getElementById('transaktiontitle').innerHTML = trans;
		}
	</script>
</head>
<body>
<a href='javascript:history.back()'>
	<img src="ico/zurueck.ico" width="16" height="16" alt="&lt;&lt;" title="zur&uuml;ck">
</a>
<dfn class='title' id='transaktiontitle'></dfn>

END;

function h_hinten($zahl) {
	// Testen: Wurde an eine Zahl ein "h" angehängt?
	// Wenn ja, dann Schalter setzen und nur numerischen Teil zurück geben.
	global $phist, $debug;
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
	return $zahl;
}

function ZerlegungFsKennz($fskennz) {
	// Das eingegebene Flurstücks-Kennzeichen auseinander nehmen. Erwartet wird gggg-fff-zzzz/nnn
	// Teile der Zerlegung in global-Vars "$z..."
	global $debug, $zgemkg, $zflur, $zzaehler, $znenner;		$arr = explode("-", $fskennz, 4);
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

function flurstueckskoordinaten($gml) {
	// Die Koordinaten zu einem Flurstück aus der Datenbank liefern
	// Parameter: gml_id des Flurstücke
	// Return: Array(x,y)
	global $epsg;
	$sqlk ="SELECT ";
	if($epsg == "25832") { // Transform nicht notwendig
		$sqlk.="x(st_Centroid(wkb_geometry)) AS x, ";
		$sqlk.="y(st_Centroid(wkb_geometry)) AS y ";
	} else {  
		$sqlk.="x(st_transform(st_Centroid(wkb_geometry), ".$epsg.")) AS x, ";
		$sqlk.="y(st_transform(st_Centroid(wkb_geometry), ".$epsg.")) AS y ";			
	}
   $sqlk.="FROM ax_flurstueck WHERE gml_id= $1 ";
	$v=array($gml);
	$resk=pg_prepare("", $sqlk);
	$resk=pg_execute("", $v);
	if (!$resk) {echo "\n<p class='err'>Fehler bei Koordinate.</p>";}
	$rowk = pg_fetch_array($resk);
	$koor=array("x" => $rowk["x"], "y" => $rowk["y"]);
	return $koor;
}

function zeile_gemeinde ($gmdnr, $gmdname, $aktuell) {
	// Eine Zeile zu Gemeinde ausgeben, Schlüssel und Name wird übergeben
	global $gkz, $gemeinde, $epsg;
	$stadt=htmlentities($gmdname, ENT_QUOTES, "UTF-8");
	$bez=urlencode($gmdname);
	if ($aktuell) {$cls=" aktuell";}
	echo "\n<div class='gm".$cls."' title='Gemeinde'>";
		echo "\n\t\t<img class='nwlink' src='ico/Gemeinde.ico' width='16' height='16' alt='Stadt'>";
		echo " Gem. <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;gm=".$gmdnr."&amp;bez=".$bez."'>";		
		echo  " ".$stadt."</a> (".$gmdnr.")";
	echo "\n</div>";
	return;
}

function zeile_gemarkung($gkgnr, $gkgname, $aktuell) {
	// Eine Zeile zu Gemarkung ausgeben
	global $con, $gkz, $gemeinde, $epsg, $gfilter;
	if ($gkgname == "") { // Falls Gem.-Name fehlt, in DB nachschlagen
		$sql ="SELECT g.gemarkungsname FROM pp_gemarkung g WHERE g.gemarkung = $1 LIMIT 1;";
		$v=array($gnr);
		$res=pg_prepare("", $sql);
		$res=pg_execute("", $v);
		if (!$res) {echo "\n<p class='err'>Fehler bei Gemarkungsname.</p>";}
		$row = pg_fetch_array($res);
		$gkgname=$row["gemarkungsname"];
	}
	if ($gkgname == "") {$gkgname = "(unbekannt)";}
	$gnam=htmlentities($gkgname, ENT_QUOTES, "UTF-8");
	if ($aktuell) {$cls=" aktuell";}
	echo "\n<div class='gk".$cls."' title='Gemarkung'>";
	echo "\n\t\t<img class='nwlink' src='ico/Gemarkung.ico' width='16' height='16' alt='GKG' title='Gemarkung'>";
	echo " OT <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;fskennz=".$gkgnr."'>";		
	echo  " ".$gnam."</a> (".$gkgnr.")";
	echo "\n</div>";
	return;
}

function zeile_flur($gkgnr, $flurnr, $histlnk, $aktuell) { // Eine Zeile zur Flur ausgeben
	global $gkz, $gemeinde, $epsg;
	if ($aktuell) {$cls=" aktuell";}
	echo "\n<div class='fl".$cls."' title='Flur'>";
	echo "\n\t\t<img class='nwlink' src='ico/Flur.ico' width='16' height='16' alt='FL' title='Flur'> ";
	$url=$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;fskennz=".$gkgnr."-".$flurnr;
	echo "<a title='Aktuelle Flurst&uuml;cke suchen' href='".$url."'>Flur ".$flurnr." </a>"; 
	If ($histlnk) { // Link zur hist. Suche anbieten
		echo " <a class='hislnk' title='Historische Flurst&uuml;cke der Flur' href='".$url."&amp;hist=j'>Hist.</a>";
	}
	echo "\n</div>";	
	return;
}

function zeile_hist_fs($fs_gml, $fskenn, $ftyp, $gknr, $flur, $aktuell) {
	// Eine Zeile für ein historisches Flurstück ausgeben 
	global $gkz, $gemeinde, $epsg, $auskpath;
	if ($ftyp == "h") {
		$ico="Flurstueck_Historisch_Lnk.ico";
		$titl="Historisches Flurst&uuml;ck";
	} else {
		$ico="Flurstueck_Historisch_oR_Lnk.ico";
		$titl="Historisches Flurst&uuml;ck ohne Raumbezug";
	}
	if ($aktuell) {$cls=" aktuell";}
	echo "\n<div class='hi".$cls."' title='".$titl."'>";

	// Icon -> Buchnachweis
	echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisfshist.php?gkz=".$gkz."&amp;gmlid=".$fs_gml."\")'>";
		echo "\n\t\t<img class='nwlink' src='ico/".$ico."' width='16' height='16' alt='Hist' title='".$titl."'>";
	echo "\n\t</a>";

	// Zeile -> tiefer in die Historie
	$flurl =$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;hist=j";
	$flurl.="&amp;fskennz=".$gknr."-".$flur."-";
	echo "\n\thist. Flst. <a href='".$flurl.$fskenn."'>".$fskenn."</a>";		

	echo "\n</div>";
	return;
}

function zeile_nachf_fs($gml, $gknr, $flur, $fskenn, $ftyp) {
	// Eine Zeile für ein Nachfolger-Flurstück eines hist. Fs. ausgeben 
	global $gkz, $gemeinde, $epsg, $auskpath;
	$fs=$gknr."-".$flur."-".$fskenn;
	switch ($ftyp) {
	case "a": // eine FS-Zeile mit Link ausgeben (Einrückung css passt nicht)
		$koor=flurstueckskoordinaten($gml);
		zeile_flurstueck($gml, $fskenn, $koor["x"], $koor["y"], "", "", false);
		return;
		break;
	case "h":
		$ico="Flurstueck_Historisch_Lnk.ico";
		$titl="Historisches Flurst&uuml;ck";
		$hisparm="&amp;hist=j";
		$auskprog="alkisfshist";
		break;
	case "o":
		$ico="Flurstueck_Historisch_oR_Lnk.ico";
		$titl="Historisches Flurst&uuml;ck ohne Raumbezug";
		$hisparm="&amp;hist=j";
		$auskprog="alkisfshist";
		break;
	}
	// für die Hist.-Fälle:
	echo "\n<div class='hn' title='Nachfolger: ".$titl."'>";			
		echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath.$auskprog.".php?gkz=".$gkz."&amp;gmlid=".$gml."\")'>";
			echo "\n\t\t<img class='nwlink' src='ico/".$ico."' width='16' height='16' alt='FS' title='Nachweis'>";
		echo "\n\t</a> ";		
		echo "Flst. <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;fskennz=".$fs.$hisparm."'>".$fskenn."</a>";					
	echo "\n</div>";
	return;
}

function ListGemeinden() {
	// Bei Leereingabe im Formular die Gemeinden auflisten
	global $con, $gkz, $gemeinde, $epsg, $debug, $gfilter;
	$linelimit=60;
	$sql ="SELECT gemeinde, gemeindename FROM pp_gemeinde ";
	switch ($gfilter) {
		case 1: // Einzelwert
			$sql.="WHERE gemeinde=".$gemeinde." "; break;
		case 2: // Liste
			$sql.="WHERE gemeinde in (".$gemeinde.") "; break;
		default: break;
	}
	$sql.=" ORDER BY gemeindename LIMIT $1 ;";
	$res=pg_prepare("", $sql);
	$res=pg_execute("", array($linelimit));
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Gemeinde</p>";
		#if ($debug >= 3) {echo "\n<p class='dbg'>".$sql."</p>";}
		return 0;
	}
	$cnt = 0;
	while($row = pg_fetch_array($res)) {
		$gnr=$row["gemeinde"];
		$gemeindename=$row["gemeindename"];		zeile_gemeinde($gnr, $gemeindename);
		$cnt++;
	}
	// Foot
	if($cnt == 0) { 
		echo "\n<p class='anz'>Keine Gemeinde.</p>";
	} elseif($cnt >= $linelimit) {
		echo "\n<p class='anz' title='Bitte eindeutiger qualifizieren'>".$cnt." Gemeinden ... und weitere</p>";
	} elseif($cnt == 1) { // Eindeutig!
		return $gnr; 
	} else {
		echo "\n<p class='anz'>".$cnt." Gemeinden</p>";
	}
	return;
}

function ListGmkgInGemeinde($gkey, $bez) {
	// Die Gemarkungen zu einem Gemeinde-Key (aus Link) listen
	global $con, $gkz, $gemeinde, $epsg, $debug, $gfilter;
	$linelimit=70;

	// Head
	zeile_gemeinde($gkey, $bez, true);

	// Body
	$sql ="SELECT gemarkung, gemarkungsname FROM pp_gemarkung WHERE gemeinde= $1 ORDER BY gemarkungsname LIMIT $2 ;";
	$res=pg_prepare("", $sql);
	$res=pg_execute("", array($gkey, $linelimit));
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Gemarkungen</p>";
		return 1;
	}
	$cnt = 0;
	while($row = pg_fetch_array($res)) {
		$gnr=$row["gemarkung"];
		$gnam=$row["gemarkungsname"];
		zeile_gemarkung($gnr, $gnam, false);
		$cnt++;
	}
	// Foot
	if($cnt == 0){ 
		echo "\n<p class='anz'>Keine Gemarkung.</p>";
	} elseif($cnt >= $linelimit) {
		echo "\n<p class='anz' title='Bitte eindeutiger qualifizieren'>".$cnt." Gemarkungen ... und weitere</p>";
	} elseif($cnt == 1) { // Eindeutig!
		return $gnr; 
	} else {
		echo "\n<p class='anz'>".$cnt." Gemarkungen</p>";
	}
	return;
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
	$sql ="SELECT g.gemeinde, g.gemarkung, g.gemarkungsname, s.gemeindename ";
	$sql.="FROM pp_gemarkung g JOIN pp_gemeinde s ON g.gemeinde = s.gemeinde ";
	$sql.="WHERE g.gemarkungsname ILIKE $1 ";
	switch ($gfilter) {
		case 1: // Einzelwert
			$sql.="AND g.gemeinde = ".$gemeinde." "; break;
		case 2: // Liste
			$sql.="AND g.gemeinde in (".$gemeinde.") "; break;
	}
	$sql.=" ORDER BY s.gemeindename, g.gemarkungsname LIMIT $2 ;";
	$v=array($match, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Gemarkung</p>";
		return;
	}
	$cnt = 0;
	$gwgem="";
	while($row = pg_fetch_array($res)) {
		$gemeindename=$row["gemeindename"];
		if ($gwgem != $gemeindename) { // Gruppierung Gemeinde
			$gwgem = $gemeindename;
			$skey=$row["gemeinde"];
			zeile_gemeinde($skey, $gemeindename, false);
		}
		$gnam=$row["gemarkungsname"];
		$gnr=$row["gemarkung"];
		zeile_gemarkung($gnr, $gnam, false); // wenn am Ende nur ein Treffer, dann aktuell=true
		$cnt++;
	}
	// Foot
	if($cnt == 0){ 
		echo "\n<p class='anz'>Keine Gemarkung.</p>";
	} elseif($cnt >= $linelimit) {
		echo "\n<p class='anz' title='Bitte eindeutiger qualifizieren'>".$cnt." Gemarkungen ... und weitere</p>";
	} elseif($cnt == 1) { // Eindeutig!
		return $gnr; 
	} else {
		echo "\n<p class='anz'>".$cnt." Gemarkungen</p>";
	}
	return;
}

function gg_head($gkgnr, $gkgaktuell) {
	// Übergeordnete Zeilen (Head) für Gemeinde und Gemarkung ausgeben
	// Parameter = Gemarkungsnummer
	$sqlh ="SELECT g.gemarkungsname, s.gemeinde, s.gemeindename FROM pp_gemarkung g ";
	$sqlh.="JOIN pp_gemeinde s ON g.gemeinde=s.gemeinde AND g.land=s.land ";
	$sqlh.="WHERE g.gemarkung = $1 ;";
	$v=array($gkgnr);
	$resh=pg_prepare("", $sqlh);
	$resh=pg_execute("", $v);
	if (!$resh) {echo "\n<p class='err'>Fehler bei Gemeinde und Gemarkung.</p>";}
	$rowh = pg_fetch_array($resh);
	$gmkg=$rowh["gemarkungsname"];
	$skey=$rowh["gemeinde"];
	$snam=$rowh["gemeindename"];
	zeile_gemeinde($skey, $snam, false);
	zeile_gemarkung($gkgnr, $gmkg, $gkgaktuell);
	return;
}

function EineGemarkung($AuchGemkZeile) {
	// Kennzeichen bestehend nur aus Gemarkung-Schlüssel wurde eingegeben
	// Parameter = $zgemkg
	global $con, $gkz, $gemeinde, $epsg, $debug, $zgemkg;
	$linelimit=120; // max.Fluren/Gemkg

	// Head
	if ($AuchGemkZeile) {gg_head($zgemkg, true);}
	// Body
	$sql ="SELECT gemarkungsteilflur AS flur FROM ax_gemarkungsteilflur f ";
	$sql.="WHERE gemarkung= $1 ORDER BY gemarkungsteilflur LIMIT $2 ;"; //WHERE f.land=?
	$v=array($zgemkg, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {echo "\n<p class='err'>Fehler bei Flur.</p>";}
	$zfl=0;
	while($row = pg_fetch_array($res)) {	
		$zflur=$row["flur"];
		zeile_flur($zgemkg, $zflur, false, false);
		$zfl++;
	}
	// Foot
	if($zfl == 0) { 
		echo "\n<p class='anz'>Keine Flur.</p>";
	} elseif($zfl >= $linelimit) {
		echo "\n<p class='anz'>".$zfl." Fluren ... und weitere</p>";
	} elseif($zfl > 1) {
		echo "\n<p class='anz'>".$zfl." Fluren</p>";
	}
	return;
}

function EineFlur() {
	// Kennzeichen aus Gemarkung und FlurNr wurde eingegeben, dazu aktuelle Flurstücke suchen
	global $con, $gkz, $gemeinde, $epsg, $debug, $zgemkg, $zflur;
	$linelimit=600; // Wie groß kann eine Flur sein?

	// Head
	gg_head($zgemkg, false);
	zeile_flur($zgemkg, $zflur, true, true);

	// Body
	$sql ="SELECT f.gml_id, f.flurnummer, f.zaehler, f.nenner, f.gemeinde, ";
	if($epsg == "25832") { // Transform nicht notwendig
		$sql.="st_x(st_Centroid(f.wkb_geometry)) AS x, ";
		$sql.="st_y(st_Centroid(f.wkb_geometry)) AS y ";
	} else {  
		$sql.="st_x(st_transform(st_Centroid(f.wkb_geometry), ".$epsg.")) AS x, ";
		$sql.="st_y(st_transform(st_Centroid(f.wkb_geometry), ".$epsg.")) AS y ";			
	}
   $sql.="FROM ax_flurstueck f WHERE f.gemarkungsnummer= $1 AND f.flurnummer= $2 ";
	$sql.="ORDER BY f.zaehler, f.nenner LIMIT $3 ;"; // WHERE f.land=?
	$v=array($zgemkg, $zflur, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {echo "\n<p class='err'>Fehler bei Flur.</p>";}
	$zfs=0;
	while($row = pg_fetch_array($res)) {	
		$fs_gml=$row["gml_id"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];}
		zeile_flurstueck($fs_gml, $fskenn, $row["x"], $row["y"], "", "", false);
		$zfs++;
	}
	// Foot
	if($zfs == 0) {
		echo "\n<p class='anz'>Kein Flurst&uuml;ck.</p>";
	} elseif($zfs >= $linelimit) {
		echo "\n<p class='anz'>".$zfs." Flurst&uuml;cke... und weitere</p>";
	} elseif($zfs > 1) {
		echo "\n<p class='anz'>".$zfs." Flurst&uuml;cke</p>";
	}
	return;
}

function HistFlur() {
	// Kennzeichen aus Gemarkung und FlurNr wurde eingegeben.
	// Die Flur nach historischen Flurstücken durchsuchen
	global $con, $gkz, $gemeinde, $epsg, $debug, $scalefs, $auskpath, $land, $zgemkg, $zflur;
	$linelimit=500;

	// Head	
	gg_head($zgemkg, false);
	zeile_flur($zgemkg, $zflur, true, true);

	// Body
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
	while($row = pg_fetch_array($res)) {	
		$ftyp=$row["ftyp"];
		$fs_gml=$row["gml_id"];	// fuer Buchausk.
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // Bruchnummer
		zeile_hist_fs($fs_gml, $fskenn, $ftyp, $zgemkg, $zflur, false);
		$zfs++;
	}

	// Foot
	if($zfs == 0) { 
		echo "\n<p class='anz'>Kein historisches Flurst&uuml;ck.</p>";
		#if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = ".$fskzwhere."</p>";}
	} elseif ($zfs >= $linelimit) {
		echo "\n<p class='anz'>".$zfs." historische Flurst. ... und weitere</p>";
	} elseif($zfs > 1) {
		echo "\n<p class='anz'>".$zfs." historische Flurst&uuml;cke</p>";
	}
	return;
}

function EinFlurstueck() {
	// Flurstückskennzeichen wurde komplett bis zum Zaehler (oder Nenner) eingegeben
	// Sonderfall: bei Bruchnummer, mehrere Nenner zum Zaehler suchen wenn kein Nenner eingegeben wurde.
	global $con, $gkz, $debug, $epsg, $gemeinde, $fskennz, $zgemkg, $zflur, $zzaehler, $znenner;

	// Head
	gg_head($zgemkg, false);
	zeile_flur($zgemkg, $zflur, true);

	// Body
	$sql ="SELECT f.gml_id, f.flurnummer, f.zaehler, f.nenner, ";
	if($epsg == "25832") { // Transform nicht notwendig
		$sql.="x(st_Centroid(f.wkb_geometry)) AS x, ";
		$sql.="y(st_Centroid(f.wkb_geometry)) AS y ";
	} else {  
		$sql.="x(st_transform(st_Centroid(f.wkb_geometry), ".$epsg.")) AS x, ";
		$sql.="y(st_transform(st_Centroid(f.wkb_geometry), ".$epsg.")) AS y ";			
	}
   $sql.="FROM ax_flurstueck f ";
	$sql.="WHERE f.gemarkungsnummer= $1 AND f.flurnummer= $2 AND f.zaehler= $3 ";
	If ($znenner != "") {$sql.="AND f.nenner=".$znenner." ";} // wie prepared?
	$sql.="ORDER BY f.zaehler, f.nenner;";
	$v=array($zgemkg, $zflur, $zzaehler);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {echo "\n<p class='err'>Fehler bei Flurst&uuml;ck.</p>";}
	$zfs=0;
	while($row = pg_fetch_array($res)) {	
		$fs_gml=$row["gml_id"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];}
		zeile_flurstueck($fs_gml, $fskenn, $row["x"], $row["y"], "", "", true);
		$zfs++;
	}
	// Foot
	if($zfs == 0) {
		echo "\n<p class='anz'>Kein aktuelles Flurst&uuml;ck.</p>";
		echo "\n<div class='hi' title='in Historie suchen'>";
			echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Historisch.ico' width='16' height='16' alt='Historisches Flurst&uuml;ck'>&nbsp;";
			echo "<a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;fskennz=".$fskennz."&amp;hist=j'>";
			echo $zgemkg."-".$zflur."-".$zzaehler;
			if ($znenner != "") {echo "/".$znenner;}
			echo " h - suchen</a>";
		echo "\n</div>";		
	}
	return;
}

function HistFlurstueck() {
	// Die Nachfolger-FS-Kennzeichen zu einem Historischen FS sollen recherchiert werden.
	global $debug, $land, $zgemkg, $zflur, $zzaehler, $znenner;

	// Head
	gg_head($zgemkg, false);
	zeile_flur($zgemkg, $zflur, true, false);
	echo "\n<hr>";

	// Body
	// Suche ueber das Flurstueckskennzeichen, gml unbekannt
	$fskzwhere =$land.$zgemkg; // Flurst-Kennz. f. Where
	$fskzwhere.=str_pad($zflur, 3, "0", $STR_PAD_LEFT);
	$fskzwhere.=str_pad($zzaehler, 5, "0", $STR_PAD_LEFT);
	if ($znenner == "") {	// Wenn kein Nenner angegeben wurde, 
		//wird mit Wildcard und like nach allen Nennern gesucht.
		$fskzwhere.="____\_\_";	// für like 
		// Das Wildcard-Zeichen "_" ist dummerweise mit Füllzeichen im Feldinhalt identisch
		$whereop=" like ";
	} else { // Ein Nenner wurde angegeben
		$fskzwhere.=str_pad($znenner, 4, "0", $STR_PAD_LEFT)."__";
		$whereop=" = ";
	}
	$whcl.="WHERE flurstueckskennzeichen ".$whereop." $1 ";
	
	$fldlist=" AS ftyp, gml_id, gemarkungsnummer, flurnummer, zaehler, nenner, ";

	// NICHT in aktuell suchen wenn explizit historisch gesucht wird
	#$sql ="SELECT 'a'".$fldlist."null as nachf FROM ax_flurstueck ".$whcl." UNION ";
	$sql ="SELECT 'h'".$fldlist."nachfolgerflurstueckskennzeichen as nachf FROM ax_historischesflurstueck ".$whcl;
	$sql.="UNION SELECT 'o'".$fldlist."nachfolgerflurstueckskennzeichen as nachf FROM ax_historischesflurstueckohneraumbezug ".$whcl;

	$v=array($fskzwhere);
	#echo "<p class='dbg'>SQL=".$sql."<br>WHERE=".$fskzwhere."</p>";  // ++++ TEST

	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {echo "\n<p class='err'>Fehler bei hist. Flurst&uuml;ck.</p>";}
	$zfs=0;

	while($row = pg_fetch_array($res)) { // Schleife Hist-FS
		$ftyp=$row["ftyp"];
		$fs_gml=$row["gml_id"];
		$gknr=$row["gemarkungsnummer"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		$nachf=$row["nachf"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];}

		#if ($ftyp == "a") { // als aktuelles FS gefunden, das "h" war also unnötig!
		#	$koor=flurstueckskoordinaten($fs_gml);
		#	echo "\n<p>Flurst&uuml;ck ".$fskenn." ist aktuell, nicht historisch</p>";	
		#	zeile_flurstueck ($fs_gml, $fskenn, $koor["x"], $koor["y"], $gknr, $flur, true);
		#} else { // Historisches FS gefunden (h oder o)

		zeile_hist_fs($fs_gml, $fskenn, $ftyp, $gknr, $flur, true);
		if ($nachf == "") {
			echo "\n<p class='anz'>keine Nachfolger</p>";	
		} else {
			echo "\n<p class='hn'>Nachfolger-Flurst&uuml;cke:</p>";
			// Direkte Nachfolger ermitteln. In $nachf steht ein Array von FS-Kennzeichen.
			// Von den einzelnen Kennz. ist unbekannt, ob diese noch aktuell sind 
			// oder auch schon wieder historisch.
			// Nachfolger in DB suchen um den Status aktuell/historisch zu ermitteln
			$stri=trim($nachf, "{}");
			$stri="'".str_replace(",", "','", $stri)."'";

			$nawhcl="WHERE flurstueckskennzeichen IN ( ".$stri." ) ";

			$nasql ="SELECT 'a' AS ftyp, gml_id, gemarkungsnummer, flurnummer, zaehler, nenner FROM ax_flurstueck ".$nawhcl;
			$nasql.="UNION SELECT 'h' AS ftyp, gml_id, gemarkungsnummer, flurnummer, zaehler, nenner FROM ax_historischesflurstueck ".$nawhcl;
			$nasql.="UNION SELECT 'o' AS ftyp, gml_id, gemarkungsnummer, flurnummer, zaehler, nenner FROM ax_historischesflurstueckohneraumbezug ".$nawhcl;

			$v=array();
			$nares=pg_prepare("", $nasql);
			$nares=pg_execute("", $v);
			if (!$nares) {echo "\n<p class='err'>Fehler bei Nachfolger.</p>";}
			$zfsn=0;
			// inner Body
			while($narow = pg_fetch_array($nares)) {
				$naftyp=$narow["ftyp"];
				$nagml=$narow["gml_id"];
				$nagknr=$narow["gemarkungsnummer"];
				$naflur=$narow["flurnummer"];
				$nafskenn=$narow["zaehler"];
				if ($narow["nenner"] != "") {$nafskenn.="/".$narow["nenner"];}
				zeile_nachf_fs ($nagml, $nagknr, $naflur, $nafskenn, $naftyp);
				$zfsn++;
			}
			// inner Footer
			if ($zfsn == 0) {
				echo "\n<p class='anz'>keine Nachfolger</p>";
			} elseif ($zfsn > 1) {
				echo "\n<p class='anz'>".$zfsn." Nachfolger-Flst.</p>";
			}
			echo "\n<hr>";
		}
		#} // aktuell ...
		$zfs++;
	}
	// Foot
	if($zfs == 0) {
		echo "\n<p class='anz'>Kein historisches Flurst&uuml;ck.</p>";
		#if ($debug > 2) {echo  "\n<p class='dbg'> SQL= ".$sql."\n<br> $1 = FS-Kennz = '".$fskzwhere."'</p>";}
	}
	return;
}

// ===========
// Start hier!
// ===========
if(isset($epsg)) {
	$epsg = str_replace("EPSG:", "" , $_REQUEST["epsg"]);	
} else {
	#if ($debug >= 1) {echo "\n<p class='dbg'>kein EPSG gesetzt</p>";}	
	$epsg=$gui_epsg; // Conf
}
if ($gemeinde == "") {
	$gfilter = 0;
} elseif(strpos($gemeinde, ",") === false) {
	$gfilter = 1; // Einzelwert
} else {
	$gfilter = 2; // Liste
}
if ($hist == "j") {$phist = true;} else {$phist = false;}

if($gm != "") { // Self-Link aus Gemeinde-Liste
	$trans="Gemarkungen zur Gemeinde";
	$gnr=ListGmkgInGemeinde($gm, $bez);
	if ($gnr > 0) {
		$zgemkg=$gnr;
		EineGemarkung(false);
	}
} else { // Die Formular-Eingabe interpretieren (kann auch ein Link sein)
	$retzer=ZerlegungFsKennz($fskennz);
	switch ($retzer) {
	case 0: // leere Eingabe
		if ($gfilter == 1) { // Die GUI ist bereits auf EINE Gemeinde gefiltert
			$trans="Liste der Gemarkungen";
			SuchGmkgName();
		} else {
			$trans="Liste der Gemeinden";
			ListGemeinden();
		}
		break;
	case 1:
		$trans="Suche Gemarkungsname";
		$gnr=SuchGmkgName();
		if ($gnr > 0) {
			$trans="1 Gemarkung, Fluren dazu";
			$zgemkg=$gnr;
			EineGemarkung(false);
		}
		break;
	case 2:
		$trans="Fluren in Gemarkung";
		EineGemarkung(true);
		break;
	case 3:
		if ($phist)	{
			$trans="historische Flurst. in Flur";
			HistFlur();
		} else {
			$trans="Flurst&uuml;cke in Flur";
			EineFlur();
		}
		break;
	case 4:
		if ($phist)	{
			$trans="historisches Flurst&uuml;ck";
			HistFlurstueck();
		} else {
			$trans="Flurst&uuml;ck";
			EinFlurstueck();
		}
		break;
	case 5:
		if ($phist) {
			$trans="historisches Flurst&uuml;ck";
			HistFlurstueck();
		} else {
			$trans="Flurst&uuml;ck";
			EinFlurstueck();
		}	
		break;
	case 9:
		$trans="falsche Eingabe";
		echo "\n<p class='err'>Bitte ein Flurst&uuml;ckskennzeichen eingegeben, Format 'gggg-fff-zzzz/nnn</p>";
		break;
	}
}

// Titel im Kopf anzeigen
echo "
<script type='text/javascript'>
	transtitle('".$trans."'); 
</script>";

?>

</body>
</html>