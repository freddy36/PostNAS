<?php
/* Version vom
	2013-04-16	"import_request_variables" entfällt in PHP 5.4
	2013-04-26	Ersetzen View "gemeinde_gemarkung" durch Tabelle "pp_gemarkung"
				Code aus _eig nach_fkt ausgelegert, hier mit nutzen. 
				Dazu Var-Namen harmonisieren: $gblatt wird $blattgml
				Zurück-Link, Titel der Transaktion anzeigen.
	2013-04-29	Test mit IE
	2013-05-07  Strukturierung des Programms, redundanten Code in Functions zusammen fassen
	2013-05-14  Hervorhebung aktuelles Objekt. Title "Nachweis" auch auf Icon.
	2013-12-12	Limit in EinBlatt von 200 weit hoch gesetzt (bis Blättern möglich wird)
	2014-09-03  PostNAS 0.8: ohne Tab. "alkis_beziehungen", mehr "endet IS NULL", Spalten varchar statt integer
	2014-09-15  Bei Relationen den Timestamp abschneiden
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
		function formular_belegung(suchMich) {
			parent.GrdGazetteerFrame.gbkennz.value=suchMich;
		}
	</script>
</head>
<body>
<a href='javascript:history.back()'>
	<img src="ico/zurueck.ico" width="16" height="16" alt="&lt;&lt;" title="zur&uuml;ck">
</a>
<dfn class='title' id='transaktiontitle'></dfn>

END;

function ListAG($liste_ag, $aktuell) {
	// Amtsgerichte (Grundbuch) auflisten, dazu als Filter eine AG-Liste
	global $debug;
	$linelimit=40;

	$sql ="SELECT stelle, bezeichnung AS ag FROM ax_dienststelle 
	WHERE stelle IN (".$liste_ag.") AND stellenart = 1000 AND endet IS NULL 
	ORDER BY bezeichnung LIMIT $1 ;";
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
		$ag=$row["ag"];		
		zeile_ag ($ag, $anr, $aktuell);
		$cnt++;
	}
	// Foot
	if($cnt == 0){
		echo "\n<p class='anz'>Kein Amtsgericht aus Liste ".$$liste_ag.".</p>";
	} elseif ($cnt >= $linelimit) {
		echo "\n<p title='Bitte eindeutiger qualifizieren'>".$cnt." Amtsgerichte ... und weitere</p>";
	} elseif ($cnt > 1) {
		echo "\n<p class='anz'>".$cnt." Amtsgerichte</p>";
	}
	return 0;
}

function ListGBBez($agkey) {
	// Grundbuch-Bezirke zu einem Amtsgericht auflisten.
	// Auch wenn Blätter da sind, kann es eine Sackgasse sein. 
	// Manchmal haben die Blätter keine Flurstücke im Filter-Bereich
	global $debug;
	$linelimit=100; // Bezirke/AG

	// Head
	ListAG("'".$agkey."'", true); // hier nur für 1

	// Body
	// Die Subquery stellt sicher, dass nur Bezirke aufgelistet werden, die auch Blätter enthalten
	$sql ="SELECT g.bezirk, g.bezeichnung FROM ax_buchungsblattbezirk g 
	JOIN ax_dienststelle a ON g.stelle=a.stelle 
	WHERE a.stelle = $1 AND a.stellenart = 1000 AND a.endet IS NULL AND g.endet IS NULL 
	AND NOT (SELECT gml_id FROM ax_buchungsblatt b WHERE b.land=g.land AND b.bezirk=g.bezirk AND b.endet IS NULL LIMIT 1) IS NULL 
	ORDER BY g.bezeichnung LIMIT $2 ;";

	$v = array($agkey, $linelimit);
	$res = pg_prepare("", $sql);
	$res = pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Grundbuch-Bezirk</p>";
		#if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
		return 0;
	}
	$cnt = 0;
	while($row = pg_fetch_array($res)) { // Loop BEZIRK
		$gnam=$row["bezeichnung"];
		$gnr=$row["bezirk"];
		zeile_gbbez($gnam, $gnr, false);
		$cnt++;
	}
	// Foot
	if($cnt == 0){
		echo "\n<p class='anz'>Kein Bezirk mit Bl&auml;ttern.</p>";
	} elseif ($cnt >= $linelimit) {
		echo "\n<p class='anz' title='Bitte Name des Bezirks suchen lassen'>".$cnt." Bezirke ... und weitere</p>";
	} elseif($cnt > 1) {
		echo "\n<p class='anz'>".$cnt." Bezirke</p>"; // im Limit	
	}
	return;
}

function ag_bez_head($gbbez, $bezaktuell) {
	// Zu einem Grundbuchbezirks-Schlüssel die Zeilen AG und Bezirk ausgeben
	// Parameter = Schlüssel des Bezirks
	#global $debug;
	$sql ="SELECT a.stelle, a.bezeichnung AS ag, g.bezeichnung FROM ax_buchungsblattbezirk g 
	JOIN ax_dienststelle a ON g.stelle=a.stelle WHERE g.bezirk= $1 AND g.endet IS NULL AND a.endet IS NULL LIMIT 1;";
	$v=array($gbbez);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Amtsgericht und Grundbuchbezirk.</p>";
		#if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
	}
	$row = pg_fetch_array($res);
	if ($row) {
		$gnam=$row["bezeichnung"]; // GB-Bezirk Bezeichnung
		$ag=$row["ag"]; // AG Bezeichnung
		$anr=$row["stelle"]; // AG Key
		zeile_ag($ag, $anr, false); // Amtsgericht
		zeile_gbbez($gnam, $gbbez, $bezaktuell); // Bezirk
	} else {
  		echo "\n<div class='gk' title='Grundbuchbezirk'>";
			echo "\n\t\t<p class='err'><img class='nwlink' src='ico/GB-Bezirk.ico' width='16' height='16' alt='Bez.'>";
				echo  " Bezirk '".$gbbez."' ist unbekannt.</p>";
		echo "\n</div>";
		return;
	}
	return;
}

function SuchGBBezName() {
	// Grundbuch-Bezirk suchen nach Name(-nsanfang)
	global $gkz, $gemeinde, $debug, $gbkennz;
	$linelimit=80;

	$sql ="SELECT a.stelle, a.bezeichnung AS ag, g.bezirk, g.bezeichnung FROM ax_buchungsblattbezirk g 
	JOIN ax_dienststelle a ON g.stelle=a.stelle 
	WHERE g.bezeichnung ILIKE $1 AND g.endet IS NULL AND a.endet IS NULL 
	ORDER BY a.bezeichnung, g.bezeichnung LIMIT $2 ;";// "AND a.stellenart=1000 " Amtsgericht
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
		return 1;
	}
	$cnt=0;
	$gwag="";
	while($row = pg_fetch_array($res)) { // Loop BEZIRK
		$anr=$row["stelle"]; // Gruppierung AG
		if ($gwag != $anr) {
			$gwag = $anr;
			$ag=$row["ag"];
			zeile_ag($ag, $anr, false);
		}
		$gnam=$row["bezeichnung"];
		$gnr=$row["bezirk"];
		zeile_gbbez ($gnam, $gnr, false);
		$cnt++;
	}
	// Foot
	if($cnt == 0){ 
		echo "\n<p class='anz'>Kein Grundbuchbezirk.</p>";
	} elseif ($cnt >= $linelimit) {
		echo "\n<p title='Bitte eindeutiger qualifizieren'>".$cnt." Bezirke ... und weitere</p>";
	} elseif ($cnt == 1) {
		return $gnr; // Wenn eindeutig, gleich weiter
	} elseif ($cnt > 1) {
		echo "\n<p class='anz'>".$cnt." Bezirke</p>"; // im Limit	
	}
	return;
}
 
function EinBezirk($showParent) {
	// Kennzeichen bestehend nur aus GB-Bezirk-Schlüssel wurde eingegeben
	global $gemeinde, $debug, $zgbbez, $auskpath;
	$linelimit=300; // max. Blatt je Bezirk
	// Dies Limit ist nicht ausreichend für alle Blätter eines Bezirks, aber ...
	// Wenn man die Blatt-Nr nicht kennt, kommt man hier sowieso nicht weiter.
	// Es nutzt also nichts, hier tausende Nummern aufzulisten.
	// +++ Blätter-Funktion einführen analog Modul _eig

	// Head
	if ($showParent) {
		ag_bez_head($zgbbez, true); // AG und BEZ ausgeben
	}
	// Body
	$sql ="SELECT b.gml_id, b.buchungsblattnummermitbuchstabenerweiterung AS blatt FROM ax_buchungsblatt b 
	WHERE b.bezirk= $1 AND b.endet IS NULL ORDER BY b.buchungsblattnummermitbuchstabenerweiterung LIMIT $2 ;";
	$v=array($zgbbez, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Bezirk.</p>";
		#if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
	}
	$cntbl=0; // Counter Blatt/Bezirk
	while($row = pg_fetch_array($res)) { // Loop BLATT	
		$blatt=$row["blatt"];
		$blattgml=$row["gml_id"];
		zeile_blatt($zgbbez, $gnam, $blattgml, $blatt, false, "", false);
		$cntbl++;
	}
	// Foot
	if($cntbl == 0) { 
		echo "\n<p class='anz'>Kein Blatt im Bezirk.</p>";
	} elseif($cntbl >= $linelimit) {
		echo "\n<p class='anz'>".$cntbl." Bl&auml;tter ... und weitere</p>";
		// +++ Hier oft überschritten! Blätter-Funktion einführen
		echo "\n<p>Geben sie ein: '".$zgbbez."-999A'<br>wobei '999A' = gesuchtes GB-Blatt</p>";
		// Vorbelegen des Eingabefeldes für neue Suche
		echo "<script type='text/javascript'>parent.GrdGazetteerFrame.gbkennz.value='".$zgbbez."-?';</script>";
	} elseif ($cntbl > 1) {
		echo "\n<p class='anz'>".$cntbl." Bl&auml;tter</p>"; // im Limit	
	}
	return;
}

function gml_blatt() {
	// Kennzeichen "Bezirk + Blatt" eingegeben. Dazu die gml_id des Blattes ermitteln.
	global $debug, $zgbbez, $zblatt, $zblattn, $zblattz;
	$sql ="SELECT b.gml_id, b.buchungsblattnummermitbuchstabenerweiterung AS blatt FROM ax_buchungsblatt b 
	WHERE b.bezirk= $1 AND b.endet IS NULL AND b.buchungsblattnummermitbuchstabenerweiterung ";

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

function EinBlatt($showParent) {
	// Kennzeichen Bezirk + Blatt wurde eingegeben oder verlinkt
	global $debug, $gemeinde, $zgbbez, $zblatt, $blattgml, $gbbeznam;
	// Head
	if ($showParent) {
		ag_bez_head($zgbbez, false); // AG + BEZ
		zeile_blatt ($zgbbez, $gbbeznam, $blattgml, $zblatt, false, "", true);
	}
	// Body
	GB_Buchung_FS(1000, $zgbbez."-".$zblatt); // Blatt -> Buchung -> Flurstueck (Limitiert)
	// ++ besser Limit runter und "Blättern"-Funktion einführen
	return; 
}

function gml_buchungsstelle() {
	// Kennzeichen "Bezirk + Blatt + BVNR" wurde eingegeben.
	// Dazu die gml_id der Buchungsstelle ermitteln, um "function EinGrundstueck" benutzen zu können.
	global $debug, $zgbbez, $zblatt, $zblattn, $zblattz, $zbvnr;

	// Blatt ->  B u c h u n g s s t e l l e
	$sql ="SELECT s.gml_id FROM ax_buchungsstelle s 
	JOIN ax_buchungsblatt b ON s.istbestandteilvon=substring(b.gml_id,1,16)
	WHERE b.bezirk= $1 AND s.endet IS NULL AND b.endet IS NULL AND b.buchungsblattnummermitbuchstabenerweiterung ";

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
	} else {
		return $bs_gml;
	}
}

function EinGrundstueck($showParent) {
	// Die gml_id der Buchungsstelle (BVNR, Grundstück) ist bekannt = $buchunggml
	// Die gebuchten Flurstücke und dienende/herrschenden Buchungen werden ausgegeben.
	global $debug, $gemeinde, $epsg, $buchunggml, $zgbbez, $zblatt, $zblattn, $zblattz, $zbvnr, $gfilter;
	// NoLimit?

	// Head
	if ($showParent) { // wenn Kennzeichen bekannt ist, dann auch Blatt ausgeben
		if ($zgbbez.$zblatt != "") {
			ag_bez_head($zgbbez, false); // AG + BEZ
			zeile_blatt ($zgbbez, $gnam, "", $zblatt, false, "", false);
			// $gnam leer lassen Knoten "Bezirk" steht drüber
		} else {
			echo "<p class='err'>Kennzeichen Bezirk und Blatt nicht gesetzt</p>";
		} // ++ suchen!
		zeile_buchung($buchunggml, $zbvnr, $zgbbez."-".$zblattn.$zblattz, false, true);
	}

// dienend $1 gml_id von
//         Buchungsstelle  <an<  Buchungsstelle sh
//         (dienend)                (herrschend)

// direkt  $1 gml_id von 
//         Buchungsstelle                           <istGebucht< Flurstück >> Gemarkung

// Recht   $1 gml_id von 
//         Buchungsstelle  >an>  Buchungsstelle sd  <istGebucht< Flurstück >> Gemarkung
//         (herrschend)             (dienend)   sd  >istBestandteilVon> bd >> gd

	// Body
	// Anfang (Select-Liste) gleich 
	$sqlanf ="SELECT g.gemeinde, g.gemarkungsname, f.gml_id, f.flurnummer, f.zaehler, f.nenner, ";
	if($epsg == "25832") { // Transform nicht notwendig
		$sqlanf.="st_x(st_Centroid(f.wkb_geometry)) AS x, ";
		$sqlanf.="st_y(st_Centroid(f.wkb_geometry)) AS y ";
	} else {  
		$sqlanf.="st_x(st_transform(st_Centroid(f.wkb_geometry),".$epsg.")) AS x, ";
		$sqlanf.="st_y(st_transform(st_Centroid(f.wkb_geometry),".$epsg.")) AS y ";			
	}
	// Filter gleich
	switch ($gfilter) { // Filter Gemeinde
		case 1: // Einzel
			$sqlfitler="AND g.gemeinde='".$gemeinde."' "; break;
		case 2: // Liste
			$sqlfilter="AND g.gemeinde in ('".str_replace(",", "','", $gemeinde)."') "; break;
	}

	// Direkte Buchungen (Flurst.)
	$sql =$sqlanf."FROM ax_flurstueck f JOIN pp_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkung ";
	$sql.="WHERE f.istgebucht = $1 AND f.endet IS NULL ".$sqlfilter."ORDER BY f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner;";

	$v=array($buchunggml);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Buchungsstelle (gml, direkt).</p>";
		if ($debug >= 3) {
			echo "\n<p class='err'>'".$sql."'<br>\nmit $1 ='".$buchunggml."'</p>";
		}
	}
	$zfs1=0;
	while($row = pg_fetch_array($res)) {	
		$fs_gml=$row["gml_id"];
		$gemei=$row["gemeinde"];
		$gmkg=$row["gemarkungsname"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // BruchNr
		zeile_flurstueck ($fs_gml, $fskenn, $row["x"], $row["y"], $gmkg, $flur, false);
		$zfs1++;
	}
	// Zwischen-Foot
	if($zfs1 == 0) {
		echo "\n<p class='anz'>Kein Flurst&uuml;ck direkt</p>";
	} elseif($zfs1 > 1) {
		echo "\n<p class='anz'>".$zfs1." Flurst&uuml;cke</p>";
	}
	if($zfs1 > 0) { // wenn's was zu trennen gibt
		echo "<hr>"; // Trennen
	}

	// Recht "an" (dienende Buchungen und ihre Flurst.)
$sql =$sqlanf.", sd.gml_id AS diengml, sd.laufendenummer AS dienlfd, 
bd.gml_id AS dienbltgml, bd.buchungsblattnummermitbuchstabenerweiterung AS dienblatt, 
gd.stelle, gd.gml_id AS dienbezgml, gd.bezirk, gd.bezeichnung AS diengbbez 
FROM ax_buchungsstelle sh 
JOIN ax_buchungsstelle sd ON substring(sd.gml_id,1,16)=ANY(sh.an) 
JOIN ax_flurstueck f ON f.istgebucht=substring(sd.gml_id,1,16) 
JOIN pp_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkung 
JOIN ax_buchungsblatt bd ON sd.istbestandteilvon=substring(bd.gml_id,1,16) 
JOIN ax_buchungsblattbezirk gd ON bd.land=gd.land AND bd.bezirk=gd.bezirk 
WHERE sh.gml_id = $1 AND sh.endet IS NULL AND sd.endet IS NULL AND f.endet IS NULL AND bd.endet IS NULL AND gd.endet IS NULL "
.$sqlfilter."ORDER BY gd.bezeichnung, bd.buchungsblattnummermitbuchstabenerweiterung, cast(sd.laufendenummer AS integer), f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner;";

	$v=array($buchunggml);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Buchungsstelle (gml, Recht an).</p>";
		if ($debug >= 3) {
			echo "\n<p class='err'>'".$sql."'<br>\nmit $1 ='".$buchunggml."'</p>";
		}
	}
	$zfs2=0;
	$gwblatt="";
	while($row = pg_fetch_array($res)) {
		$dienstelle=$row["stelle"];	// Stelle (AG) des dienenden Grundstücks
		$dienbezgml=$row["dienbezgml"];	// Bezirks des dien. GS: gml, Nr. und Bezeichnung
		$diengbbez=$row["diengbbez"];	// Bezeichnung
		$dienbezirk=$row["bezirk"];	// Key
		$dienbltgml=$row["dienbltgml"];	// dienendes Blatt, gml und Nr
		$dienblatt=$row["dienblatt"];
		$diengml=$row["diengml"];	// gml_id des dienenden Grundstücks
		$dienlfd=$row["dienlfd"];	// BVNR (laufendNr) des dien. GS
		if ($gwblatt != $dienblatt) { // Gruppierung Blatt - dienend
			$gwblatt = $dienblatt; // Steuerg GW Blatt
			zeile_blatt($dienbezirk, $diengbbez, $dienbltgml, $dienblatt, true, "");
			$gwbvnr="";
		}
		if ($gwbvnr != $dienlfd) { // Gruppierung Buchung (BVNR) - dienend
			$gwbvnr = $dienlfd; // Steuerg GW BVNR
			zeile_buchung($diengml, $dienlfd, $dienbezirk."-".$dienblatt, true);
		} // ++ Buchungsart? Welches Recht?
		$fs_gml=$row["gml_id"];
		$gemei=$row["gemeinde"];
		$gmkg=$row["gemarkungsname"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // BruchNr
		zeile_flurstueck ($fs_gml, $fskenn, $row["x"],$row["y"], $gmkg, $flur, false);
		$zfs2++;
	}

// Teil 3 - noch nicht umgesetzt
// ToDo: Wenn nur 1 Grundstück untersucht wird, dann dazu auch die berechtigten (herrschenden) Grundbücher anzeigen und verlinken (ohne FS)

	// Foot
	if($zfs2 == 0 AND $zfs1 == 0) {
		echo "\n<p class='anz'>Kein Recht an Flst.</p>";
	} elseif($zfs2 > 1) {
		echo "\n<p class='anz'>".$zfs2." Rechte an Flurst.</p>";
	}
	return;
}

// ===========
// Start hier!
// ===========
if(isset($epsg)) {
	$epsg = str_replace("EPSG:", "" , $_REQUEST["epsg"]);	
} else {
	$epsg=$gui_epsg; // aus Conf
}

if ($gemeinde == "") {
	$gfilter = 0; // ungefiltert
} elseif(strpos($gemeinde, ",") === false) {
	$gfilter = 1; // Einzelwert
} else {
	$gfilter = 2; // Liste
//	$gemeinde = "'".str_replace(",", "','", $gemeinde)."'"; // Jedes Element in ''
}

// Auch wenn redundant: Das Kennzeichen für Anzeige und weitere Links zerlegen
$kennztyp=ZerlegungGBKennz($gbkennz);

// Wurde eine gml_id (internes Kennzeichen) aus einem Self-Link verwendet?
// Dann hat das Prioritaet, also *nicht* nach $gbkennz suchen.
if ($buchunggml != "") { // gml der Buchungsstelle
	$trans="Flurst&uuml;cke zur Buchungsstelle"; // Link
	EinGrundstueck(true);

} elseif($blattgml != "") { // gml des GB-Blattes
	$trans="GB-Blatt mit Buchungen und Flst.";
	EinBlatt(true);

} elseif($ag != "") { // Key des Amtsgerichtes
	$trans="GB-Bezirke zum Amtsgericht";
	ListGBBez($ag);

} else { // Eingabe im Formular

	switch ($kennztyp) {
		case 0: // keine Eingabe
			$trans="Liste der Amtsgerichte";
			ListAG($ag_liste, false);
			break;
		case 1: // Eingabe Bezirk-Name (-Teil) -> gefilterte Liste der Bezirke
			$trans="Bezirke suchen \"".$gbkennz."\"";
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
					$buchunggml=gml_buchungsstelle(); // gml_id zum Kennzeichen
					EinGrundstueck(false);
				}
			}
			break;
		case 4: // Eingabe Buchung (Grundstück) -> Liste der Flurstücke
			$buchunggml=gml_buchungsstelle(); // gml_id zum Kennzeichen
			if ($buchunggml != "") { 		// .. wurde geliefert 
				$trans="Flurst&uuml;cke zur Buchungsstelle"; // Eingabe
				EinGrundstueck(true);	// mit Backlink
			} else{
				$trans="Suche Buchungsstelle";
			}
			break;
		case 9: // Fehler
			$trans="fehlerhafte Eingabe";
			echo "\n<p class='err'>Bitte ein g&uuml;ltiges Grundbuchkennzeichen eingegeben, Format 'gggg-999999A-llll</p>";
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