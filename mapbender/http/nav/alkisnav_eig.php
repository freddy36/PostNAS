<?php
/* Version vom
	2013-04-16 "import_request_variables" entfällt in PHP 5.4
	2013-04-26	Ersetzen View "gemeinde_gemarkung" durch Tabelle "pp_gemarkung".
				Stufe 2: GB *und* FS mit einem Klick anzeigen.
				Blätterfunktion (Folgeseiten) für lange Listen. 
				Function extern gemeinsam genutzt in _eig und _grd.
				Dazu Var-Namen harmonisieren: $gb wird $blattgml.
				Zurück-Link, Titel der Transaktion anzeigen.
	2013-04-29	Darstellung mit IE
	2013-05-07  Strukturierung des Programms, redundanten Code in Functions zusammen fassen
	2013-05-14  Hervorhebung aktuelles Objekt, Parameter "gbkennz" auswerten,
				Title auch auf Icon, IE zeigt sonst alt= als Title dar.
*/
$cntget = extract($_GET);
include("../../conf/alkisnav_conf.php"); // Konfigurations-Einstellungen
include("alkisnav_fkt.php"); // Funktionen
$con_string = "host=".$host." port=".$port." dbname=".$dbname.$dbvers.$gkz." user=".$user." password=".$password;
$con = pg_connect ($con_string) or die ("<p class='err'>Fehler bei der Verbindung zur Datenbank</p>".$dbname.$dbvers.$gkz);
echo <<<END
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ALKIS-Suche Eigent&uuml;mer</title>
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

// Einen Link generieren, um nach anderen Personen mit gleichem Familiennamen zu suchen
function familiensuche() {
	global $gkz, $gemeinde, $epsg, $name;
	if(isset($name)) { // Familiensuche
		echo "\n<div class='back' title='Andere Personen mit diesem Nachnamen'>";
			echo "\n\t\t<img class='nwlink' src='ico/Eigentuemer_2.ico' width='16' height='16' alt='FAM' title='Andere Personen mit diesem Nachnamen'> ";
			echo "\n<a class='back' href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;name=".$name."'>\"".$name."\"</a>";
		echo "\n</div>\n<br>";	
	}
	return;
}

function personendaten() { // Adresse und Geburtsdatum der aktuellen Person ausgeben
	global $gkz, $gemeinde, $epsg, $name, $person, $blattgml, $auskpath; // $debug
	$sql ="SELECT p.nachnameoderfirma, p.vorname, p.geburtsdatum, p.namensbestandteil, ";
	$sql.="a.ort_post, a.postleitzahlpostzustellung AS plz, a.strasse, a.hausnummer ";
	$sql.="FROM ax_person p LEFT JOIN alkis_beziehungen b ON p.gml_id=b.beziehung_von ";
	$sql.="LEFT JOIN ax_anschrift a ON a.gml_id=b.beziehung_zu WHERE p.gml_id= $1 ;";	
	$v=array($person);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {echo "\n<p class='err'>Fehler bei Name</p>\n";}
	$row = pg_fetch_array($res);
	$zeil1=$row["nachnameoderfirma"].", ".$row["vorname"];
	$gebdat=$row["geburtsdatum"];
	if ($gebdat != "") {$zeil1.= ", geb. ".$gebdat;}
	$best=$row["namensbestandteil"];
	if ($best != "") {$zeil1.= ", ".$best;}
	$zeil1=htmlentities($zeil1, ENT_QUOTES, "UTF-8");

	$zeil2=trim($row["plz"]." ".$row["ort_post"]);
	if ($zeil2 != "") {
		$zeil2="\n\t<br>".htmlentities($zeil2, ENT_QUOTES, "UTF-8");
	}

	$zeil3= trim($row["strasse"]." ".$row["hausnummer"]);
	if ($zeil3 != "") {
		$zeil3= "\n\t<br>".htmlentities($zeil3, ENT_QUOTES, "UTF-8");
	}

// Tabelle: Sp.1=Icon, Link zur Auskunft Person, Sp.2=Rahmen
echo "
<div class='pe aktuell'>
<table>
<tr>
	<td valign='top'>
		<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisnamstruk.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;gmlid=".$person."\")'>
			<img class='nwlink' src='ico/Eigentuemer.ico' width='16' height='16' alt='EIG' title='Nachweis'>
		</a>
	</td>
	<td>
		<p class='nam'>".$zeil1.$zeil2.$zeil3."</p>
	</td>
</tr>
</table>
</div>";
return;
}

function getEigByName() {
	// 1 // Eigentuemer nach Name(-nsanfang)
	global $gkz, $gemeinde, $epsg, $name, $person, $gfilter;
	$linelimit=150;
	$arr = explode(",", $name);
	$name0 = trim($arr[0]);
	$name1 = trim($arr[1]);
	if(preg_match("/\*/",$name0)){
		$match = trim(preg_replace("/\*/i","%", strtoupper($name0)));
	} else {
		$match = trim($name0)."%";
	}	
	if(preg_match("/\*/",$name1)){
		$match1 = trim(preg_replace("/\*/i","%", strtoupper($name1)));
	} else {
		$match1 = trim($name1)."%";
	}		
	$sql ="SELECT p.nachnameoderfirma, p.vorname, p.gml_id FROM ax_person p ";
	if ($gfilter > 0) {
		$sql.="JOIN gemeinde_person g ON p.gml_id = g.person WHERE ";
		switch ($gfilter) {
			case 1: // Einzelwert
				$sql.="g.gemeinde=".$gemeinde." AND "; break;
			case 2: // Liste
				$sql.="g.gemeinde in (".$gemeinde.") AND "; break;
		}
	} else {
		$sql.="WHERE ";
	}
	if($match1 != '%'){
		$sql.="nachnameoderfirma ILIKE $1 AND p.vorname ILIKE $2 ";		
		$sql.="ORDER BY p.nachnameoderfirma, p.vorname LIMIT $3 ;";
		$v=array($match, $match1, $linelimit);
	}else{
		$sql.="nachnameoderfirma ILIKE $1 ";		
		$sql.="ORDER BY p.nachnameoderfirma, p.vorname LIMIT $2 ;";
		$v=array($match, $linelimit);
	} 
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Eigent&uuml;mer</p>";
		return;
	}
	$cnt = 0;
	while($row = pg_fetch_array($res)) {
		$nachname=$row["nachnameoderfirma"];
		$vorname=$row["vorname"];
		$persongml=$row["gml_id"];
		zeile_person($persongml, $nachname, $vorname);
		$cnt++;
	}
	if($cnt == 0){ 
		echo "\n<p class='anz'>Kein Eigent&uuml;mer gefunden.</p>";
	} elseif($cnt >= $linelimit) { // das Limit war zu knapp
		echo "\n<p class='anz' title='Bitte den Namen eindeutiger qualifizieren'>... und weitere</p>";
	} elseif($cnt == 1){ // Eindeutig!
		$person = $persongml;
	} else {
		echo "\n<p class='anz'>".$cnt." Eigent&uuml;mer mit '".$name."'</p>";	// im Limit
	}
	return;
}

function getGBbyPerson() {
	// 2 // Grundbücher zur gewählten Person
// Es wird in dieser Function nicht geprüft, ob die gefundenen Grundbücher auch Flurstücke
// haben, die im gefilterten Bereich (Gemeinde) liegen. Es können daher Sackgassen entstehen,
// also Grundbücher, die in der nächsten Stufe bei Filterung nicht zu Treffern führen.
// Das Joinen bis zum FS unter Berücksichtigung von speziellen Buchungen ist zu aufwändig.
// Dann kann entweder das FS gleich mit ausgegeben werden -> getGBuFSbyPerson.
// Alternativ würde eine Hilfstabelle benötigt, in der im PostProcessing 
// das GB-zu-Gemeinde-Verhältnis vorbereitet wird.
	global $gkz, $gemeinde, $epsg, $name, $person, $blattgml, $debug, $bltbez, $bltblatt, $bltseite, $kennztyp, $zgbbez;
	# $zblatt, $zblattn, $zblattz, $zbvnr;
	$linelimit=150;

	// Head
	familiensuche();
	personendaten();

	// Body
	// Suche nach Grundbüchern der Person
	$sql ="SELECT gb.gml_id AS gml_g, gb.buchungsblattnummermitbuchstabenerweiterung as blatt, b.bezirk, b.bezeichnung AS beznam ";
	$sql.="FROM alkis_beziehungen bpn ";
	$sql.="JOIN ax_namensnummer n ON bpn.beziehung_von=n.gml_id ";
	$sql.="JOIN alkis_beziehungen bng ON n.gml_id=bng.beziehung_von ";
	$sql.="JOIN ax_buchungsblatt gb ON bng.beziehung_zu=gb.gml_id ";
	$sql.="JOIN ax_buchungsblattbezirk b ON gb.land = b.land AND gb.bezirk = b.bezirk ";
	$sql.="WHERE bpn.beziehung_zu= $1 AND bpn.beziehungsart='benennt' AND bng.beziehungsart='istBestandteilVon' ";

	// Parameter $gbkennz, z.B. nach Klick auf Zeile "Bezirk"
	if ($kennztyp > 1) { // 2=Such Bezirk-Nummer, 3=Such Blatt, 4=Such Buchung BVNR
		#if ($debug > 0) {echo "<p class='dbg'>Filter Bezirk '".$zgbbez."'<p>";}
		$sql.="AND b.bezirk = ".$zgbbez." ";
		$bezirkaktuell = true;
	} else {
		$bezirkaktuell = false;
	}

	if ($bltbez.$bltblatt != "") { // Blättern, Fortsetzen bei ...
		$sql.="AND ((b.bezeichnung > '".$bltbez."') ";
		$sql.="OR (b.bezeichnung = '".$bltbez."' AND gb.buchungsblattnummermitbuchstabenerweiterung > '".$bltblatt."')) ";
	}

	$sql.="ORDER BY b.bezeichnung, gb.buchungsblattnummermitbuchstabenerweiterung LIMIT $2 ;";

	if ($bltseite == "") { // Seite 1
		$bltseite = 1;
	} else { // Folgeseite
		echo "\n<p class='ein'>Teil ".$bltseite;
	}
	$v=array($person, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Grundbuch</p>";
		return;
	}
	$cnt = 0;
	$gwbez="";
	while($row = pg_fetch_array($res)) {
		$beznr=$row["bezirk"];
		if ($gwbez != $beznr) { // Gruppenwechsel Bezirk
			$beznam=$row["beznam"];
			$gwbez=$beznr;
			zeile_gbbez ($beznam, $beznr, $bezirkaktuell);
		}
		$gml=$row["gml_g"];
		$blatt=$row["blatt"];
		zeile_blatt($zgbbez, $beznam, $gml, $blatt, false, $person, false);
		$cnt++;
	}

	// Foot
	if($cnt == 0) { 
		echo "\n<p class='anz'>Kein Grundbuch zum Eigent&uuml;mer</p>";
	} elseif($cnt >= $linelimit) {
		echo "\n<p class='blt'>".$cnt." Grundb. zum Eigent.";

		// Blättern
		$nxtbltbez=urlencode($beznam);
		$nxtbltblatt=urlencode($blatt);
		$nxtbltseite=$bltseite + 1;
		echo "\n - <a class='blt' href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;person=".$person."&amp;bltbez=".$nxtbltbez."&amp;bltblatt=".$nxtbltblatt."&amp;bltseite=".$nxtbltseite."' ";
		echo "title='Bl&auml;ttern ab ".htmlentities($beznam)." Blatt ".$blatt."'>weitere</a>";
		echo "</p>";
	} elseif($cnt == 1) { // Eindeutig!
		$blattgml=$gml; // dann Stufe 3 gleich nachschieben
	} else {
		echo "\n<p class='anz'>".$cnt." Grundb&uuml;cher zum Eigent&uuml;mer</p>";
	}
	return;
}

function getFSbyGB($backlink) {
	// 3 // Flurstücke zum Grundbuch
// Zu einem Grundbuch (gml_id als Parameter) werden alle darauf gebuchten Flurstücke gesucht.
// Im ersten Schritt sind das direkt gebuchten Flurstücke.
// Im zweiten Schritt wird gesucht nach Rechten einer Buchungstelle des durchsuchten Blattes an anderen
// Buchungstellen.
	global $gkz, $gemeinde, $name, $person, $blattgml, $epsg, $gfilter, $debug;
	if($backlink) { // Erneuter Ansatz bei Person oder GB möglich.

		// Namen ermitteln
		$sql ="SELECT nachnameoderfirma, vorname FROM ax_person WHERE gml_id = $1 ";
		$v=array($person);
	 	$res=pg_prepare("", $sql);
		$res=pg_execute("", $v);
		if (!$res) {echo "\n<p class='err'>Fehler bei Eigent&uuml;mer</p>";}
		$row = pg_fetch_array($res); // nur eine Zeile
		zeile_person($person, $row["nachnameoderfirma"], $row["vorname"]);

		// Grundbuch-Daten ermitteln
		$sql ="SELECT gb.gml_id AS gml_g, gb.buchungsblattnummermitbuchstabenerweiterung as blatt, b.bezirk, b.bezeichnung AS beznam ";
		$sql.="FROM ax_buchungsblatt gb JOIN ax_buchungsblattbezirk b ON gb.land=b.land AND gb.bezirk=b.bezirk ";
		$sql.="WHERE gb.gml_id= $1 LIMIT 1 ;";
		$v=array($blattgml);
		$res=pg_prepare("", $sql);
		$res=pg_execute("", $v);
		if (!$res) {echo "\n<p class='err'>Fehler bei Grundbuch</p>";}
		$row = pg_fetch_array($res); // eine Zeile
		$gml=$row["gml_g"];
		$bezirk=$row["bezirk"];
		$beznam=$row["beznam"];
		$blatt=$row["blatt"];
		zeile_gbbez ($beznam, $bezirk, false);
		zeile_blatt($bezirk, $beznam, $blattgml, $blatt, false, $person, true);	
	}
	GB_Buchung_FS(250, ""); // Blatt > Grundst. > FS, max. 250, ohne Link "Buchung"
	return;
}

function getGBuFSbyPerson() {
	// 2 + 3 // Grundbücher UND Flurstücke zur gewählten Person
// Dies ist die Kombination von Stufe 2 (Grundbücher zur Person) und 3 (Flurstücke zum Grundbuch) 
// in einem einzelnen Schritt. Wenn auf Gemeinde gefiltert wird, dann können in Stufe 2 (noch ohne Filter)
// auch Grundbücher gefunden werden, die dann auf Stufe 3 (mit Filter) keine FS liefern ("Sackgasse"!).
// Wenn aber per JOIN "GB -> FS -> Gemarkung -> Gemeinde" geprüft wird, dann können 
// die Daten ja auch gleich ausgegeben werden.
// Für Fälle in denen nicht nach Gemeinde gefiltert wird (z.B. ganzer Kreis) kann weiter 
// Stufe 2 und 3 nacheinander verwendet werden. Dies ist wahrscheinlich übersichtlicher, 
// weil "ungefiltert" in "2+3" zu lange Listen entstehen würden, die durchblättert werden müssen. 
	global $gkz, $gemeinde, $epsg, $name, $person, $blattgml, $gfilter, $debug, $bltbez, $bltblatt, $bltbvnr, $bltseite, $bltrecht, $kennztyp, $zgbbez;
	$linelimit=80; // als Limit "Anzahl Flurstücke" in den beiden folgenden Abfragen
	// darf nun etwas knapper sein, weil man jetzt blättern kann
	familiensuche();
	personendaten();

	// Wenn das Limit überschritten wurde: zusätzliche Parameter "blt"=Blättern
	// $bltbez   = Bezirk-Name  
	// $bltblatt = BlattMitBuchstabe
	// $bltbvnr  = lfd.Nr der Buchungsstelle
	// $bltseite = fortlaufende Seiten-Nr
	// $bltrecht = "nur"/"ohne" liefert nur den abgebrochene Teil der Auflistung 

	// SQL-Bausteine vorbereiten
	//  Direkte Buchungen suchen mit:  $sql1 +         $sqla1 + $sql2
	//  Sonderfälle suchen mit:        $sql1 + $sqlz + $sqla2 + $sql2

	// Baustein: SQL-Anfang fuer beide Varianten
	$sql1 ="SELECT gb.gml_id AS gml_g, gb.buchungsblattnummermitbuchstabenerweiterung as blatt, b.bezirk, b.bezeichnung AS beznam, ";
	$sql1.="s1.gml_id as bsgml, s1.laufendenummer AS lfd, f.gml_id, f.flurnummer, f.zaehler, f.nenner, f.gemeinde, ot.gemarkung, ot.gemarkungsname, ";
	if($epsg == "25832") { // Transform nicht notwendig
		$sql1.="st_x(st_centroid(f.wkb_geometry)) AS x, ";
		$sql1.="st_y(st_centroid(f.wkb_geometry)) AS y ";
	} else {  
		$sql1.="st_x(st_transform(st_centroid(f.wkb_geometry), ".$epsg.")) AS x, ";
		$sql1.="st_y(st_transform(st_centroid(f.wkb_geometry), ".$epsg.")) AS y ";			
	}
	$sql1.="FROM alkis_beziehungen bpn ";
	$sql1.="JOIN ax_namensnummer nn ON bpn.beziehung_von=nn.gml_id ";
	$sql1.="JOIN alkis_beziehungen bng ON nn.gml_id=bng.beziehung_von ";
	$sql1.="JOIN ax_buchungsblatt gb ON bng.beziehung_zu=gb.gml_id ";
   $sql1.="JOIN alkis_beziehungen vbg ON gb.gml_id=vbg.beziehung_zu ";
	$sql1.="JOIN ax_buchungsstelle s1 ON vbg.beziehung_von=s1.gml_id ";
	$sql1.="JOIN ax_buchungsblattbezirk b ON gb.land=b.land AND gb.bezirk=b.bezirk "; // quer-ab

	// Baustein: Zwischen-JOIN (nur bei zweiter Abfrage)
	$sqlz ="JOIN alkis_beziehungen vss ON vss.beziehung_von=s1.gml_id ";
	$sqlz.="JOIN ax_buchungsstelle s2 ON vss.beziehung_zu=s2.gml_id ";

	// Baustein: Auswahl 1 oder 2
	$sqla1 ="JOIN alkis_beziehungen vfb ON s1.gml_id=vfb.beziehung_zu ";
	$sqla2 ="JOIN alkis_beziehungen vfb ON s2.gml_id=vfb.beziehung_zu ";

	// Baustein: SQL-Ende fuer beide Varianten
	$sql2.="JOIN ax_flurstueck f ON vfb.beziehung_von=f.gml_id ";
   $sql2.="JOIN pp_gemarkung ot ON f.land=ot.land AND f.gemarkungsnummer=ot.gemarkung "; // Ortsteil
	$sql2.="WHERE bpn.beziehung_zu= $1 AND bpn.beziehungsart='benennt' AND bng.beziehungsart='istBestandteilVon' ";
	$sql2.="AND vbg.beziehungsart='istBestandteilVon' AND vfb.beziehungsart='istGebucht' ";

	// Parameter $gbkennz nach Klick auf Zeile "Bezirk"
	if ($kennztyp > 1) { // 2=Such Bezirk-Nummer, 3=Such Blatt, 4=Such Buchung BVNR
		#if ($debug > 0) {echo "<p class='dbg'>Filter Bezirk '".$zgbbez."'<p>";}
		$sql2.="AND b.bezirk = ".$zgbbez." ";
		$bezirkaktuell = true;
	} else {
		$bezirkaktuell = false;
	}

	switch ($gfilter) { // Gemeinde-Filter
		case 1: // Einzelwert
			$sql2.="AND ot.gemeinde=".$gemeinde." "; break;
		case 2: // Liste
			$sql2.="AND ot.gemeinde in (".$gemeinde.") "; break;
	}
	$sql3 ="ORDER BY b.bezirk, gb.buchungsblattnummermitbuchstabenerweiterung, cast(s1.laufendenummer AS integer), f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner LIMIT $2 ;";
	// Sortier-Problem: laufendenummer in varchar linksbündig

	// Die Bausteine in 2 Varianten kombinieren

	// Blättern mit folgenden Parametern: $bltbez, $bltblatt, $bltbvnr, $bltseite, $bltrecht
	if ($bltbez.$bltblatt.$bltbvnr != "") { // Blättern, Fortsetzen bei ...
		$bltwhere ="AND ((b.bezeichnung > '".$bltbez."') ";
		$bltwhere.="OR (b.bezeichnung = '".$bltbez."' AND gb.buchungsblattnummermitbuchstabenerweiterung > '".$bltblatt."') ";
		$bltwhere.="OR (b.bezeichnung = '".$bltbez."' AND gb.buchungsblattnummermitbuchstabenerweiterung = '".$bltblatt."' AND cast(s1.laufendenummer AS integer) >= ".$bltbvnr." )) ";
	} // Flurstücke in der angeblätterten BVNR werden ggf. wiederholt

	if ($bltseite == "") { // auf Seite 1 beide Teile ausgegeben
		$bltseite = 1;
	} else { // Folgegeseite: nur Teil 1 *oder* 2
		echo "\n<p class='ein'>Teil ".$bltseite." - ";
		switch ($bltrecht) {
			case "nur":
				echo "nur Rechte an .. Buchungen</p>"; break;
			case "ohne":
				echo "nur direkte Buchungen</p>"; break;
			default:
				echo "</p>"; break;
		}
	}

	// Fälle ohne "Rechte an"
	if ($bltrecht != "nur") { // "nur"/"ohne" liefert nur den abgebrochene Teil der Auflistung
		// Blatt <vbg/istBestandteilVon<  Buchungsstelle <vfb/istGebucht< Flurstck.
		$sql=$sql1.$sqla1.$sql2.$bltwhere.$sql3; // Direkte Buchungen
		$v=array($person, $linelimit);
		$res=pg_prepare("", $sql);
		$res=pg_execute("", $v);
		if (!$res) {
			echo "\n<p class='err'>Fehler bei Buchung und Flurst&uuml;ck.</p>";
			return;
		}
		$zfs1=0;
		$gwbez="";
		while($row = pg_fetch_array($res)) {
			$bezirk=$row["bezirk"];
			if ($gwbez != $bezirk) { // Gruppierung Bezirk
				$gwbez=$bezirk;
				$beznam=$row["beznam"];
				$gwgb="";
				zeile_gbbez($beznam, $gwbez, $bezirkaktuell);
			}
			$gb_gml=$row["gml_g"];
			if ($gwgb != $gb_gml) { // Gruppierung Blatt (Grundbuch)
				$blatt=$row["blatt"];
				zeile_blatt($bezirk, $beznam, $gb_gml, $blatt, false, $person, false);
				$gwgb = $gb_gml;	// Steuerg GW GB
				$gwbv = ""; 		// Steuerg GW BVNR
			}
			$bvnr=$row["lfd"];
			if ($gwbv != $bvnr) { // Gruppierung Buchung (BVNR)
				$gwbv = $bvnr;
				$bsgml=$row["bsgml"];
				zeile_buchung($bsgml, $bvnr, "", false, false); //ohne Link
			}
			$fs_gml=$row["gml_id"];
			$gmkg=$row["gemarkungsname"];
			$flur=$row["flurnummer"];
			$fskenn=$row["zaehler"];
			if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // BruchNr
			zeile_flurstueck($fs_gml, $fskenn, $row["x"], $row["y"], $gmkg, $flur, false);
			$zfs1++;
		}
		if($zfs1 == 0) {
			if ($bltrecht == "ohne") {echo "\n<p class='anz'>Keine direkte Buchung gefunden.</p>";}
		} elseif($zfs1 >= $linelimit) { // das Limit war zu knapp
			echo "\n<p class='blt'>";
			if ($bltseite > 1) {echo "weitere ";}
			echo $zfs1." Flurst&uuml;cke";
			// B l ä t t e r n  (eine Folgeseite anbieten)
			$nxtbltbez=urlencode($beznam);
			$nxtbltblatt=urlencode($blatt);
			$nxtbltseite=$bltseite + 1;
			echo "\n - <a class='blt' href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;person=".$person;
			echo "&amp;gbkennz=".$zgbbez; // Filter Bezirk
			echo "&amp;bltbez=".$nxtbltbez."&amp;bltblatt=".$nxtbltblatt."&amp;bltbvnr=".$bvnr."&amp;bltseite=".$nxtbltseite."&amp;bltrecht=ohne' ";
			echo "title='Bl&auml;ttern ab ".htmlentities($beznam)." Blatt ".$blatt." BVNR ".$bvnr."'>weitere</a>";
			echo "</p>";
		} elseif($zfs1 > 1) { // Meldung (Plural) ab 2, im Limit
			echo "\n<p class='anz'>";
			if ($bltseite > 1) {echo "weitere ";}
			echo $zfs1;
			if ($kennztyp > 1) {
				echo " Flurst. zum Eigent. im GB-Bezirk</p>"; 
			} else {
				echo " Flurst&uuml;cke zum Eigent&uuml;mer</p>"; 
			}
		}
	}	
	if ($bltrecht == "" and $zfs1 > 0) { // beides
		echo "<hr>"; // dann Trenner
	}

	// Fälle mit "Rechte an"
	if ($bltrecht != "ohne") { // "nur"/"ohne" liefert nur den abgebrochene Teil der Auflistung 
		// Zweite Abfrage (Variante) aus den Bausteinen zusammen bauen
		// buchungsStelle2 < an < buchungsStelle1
		$sql=$sql1.$sqlz.$sqla2.$sql2.$bltwhere.$sql3; // Rechte an
		$v=array($person, $linelimit);
		$res=pg_prepare("", $sql);
		$res=pg_execute("", $v);
		if (!$res) {
			echo "\n<p class='err'>Fehler bei Recht an Buchung.</p>";
			return;
		}
		$zfs2=0;
		$gwbez="";
		#gwgb="";
		while($row = pg_fetch_array($res)) {	
			$bezirk=$row["bezirk"];
			if ($gwbez != $bezirk) { // Gruppierung Bezirk
				$gwbez=$bezirk;
				$beznam=$row["beznam"];
				$gwgb="";
				zeile_gbbez($beznam, $gwbez, $bezirkaktuell);
			}
			$gb_gml=$row["gml_g"];
			if ($gwgb != $gb_gml) {  // Gruppierung Blatt (Grundbuch)
				$beznam=$row["beznam"];
				$blatt=$row["blatt"];
				zeile_blatt ($bezirk, $beznam, $gb_gml, $blatt, false, $person, false);
				$gwgb = $gb_gml;	// Steuerg GW GB
				$gwbv = ""; 		// Steuerg GW BVNR
			}
			$bvnr=$row["lfd"];
			if ($gwbv != $bvnr) { // Gruppierung Buchungs (BVNR)
				$gwbv = $bvnr;
				$bsgml=$row["bsgml"];
				zeile_buchung($bsgml, $bvnr, "", true, false); // Recht an ...  // ohne Link!
			#	zeile_buchung($bsgml, $bvnr, $bezirk."-".$blatt, true, false); // Recht an ...
			}
			$fs_gml=$row["gml_id"];
			$gmkg=$row["gemarkungsname"];
			$flur=$row["flurnummer"];
			$fskenn=$row["zaehler"];
			if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];}
			$x=$row["x"];
			$y=$row["y"];
			zeile_flurstueck ($fs_gml, $fskenn, $x, $y, $gmkg, $flur, false);
			$zfs2++;
		}
		if($zfs2 == 0) {
			if ($zfs1 == 0 or $bltrecht == "nur") { // keine Meldung wenn schon in Teil 1 eine Ausgabe
				echo "\n<p class='anz'>Keine Rechte an Buchungen.</p>";
			}
		} elseif($zfs2 >= $linelimit) { // das Limit war zu knapp, das  B l ä t t e r n  anbieten
			echo "\n<p class='blt'>";
			if ($bltseite > 1) {echo "weitere ";}
			echo $zfs2." Rechte an Flurst.";
			$nxtbltbez=urlencode($beznam);
			$nxtbltblatt=urlencode($blatt);
			$nxtbltseite=$bltseite + 1;
			echo "\n - <a class='blt' href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;person=".$person;
			echo "&amp;gbkennz=".$zgbbez; // Filter Bezirk
			echo "&amp;bltbez=".$nxtbltbez."&amp;bltblatt=".$nxtbltblatt."&amp;bltbvnr=".$bvnr."&amp;bltseite=".$nxtbltseite."&amp;bltrecht=nur' ";
			echo "title='Bl&auml;ttern ab ".htmlentities($beznam)." Blatt ".$blatt." BVNR ".$bvnr."'>weitere</a>";
			echo "</p>";
		} elseif($zfs2 > 1) { // ab 2
			echo "\n<p class='anz'>";
			if ($bltseite > 1) {echo "weitere ";}
			echo $zfs2." Rechte an Flurst.</p>"; // im Limit		
		}
	} // ENDE Fälle mit "Rechte an"
	return;
}

// ===========
// Start hier!
// ===========
// Parameter:  
// 1. name   = Suche nach Namensanfang oder -bestandteil.
// 2. person = gml_id der Person      -> Suche nach Grundbüchern
// 3. gb     = gml_id des Grundbuches -> Suche nach Flurstücken

if(isset($epsg)) {
	$epsg = str_replace("EPSG:", "" , $_REQUEST["epsg"]);	
} else {
	$epsg=$gui_epsg; // aus Conf
}
if ($gemeinde == "") {
	$gfilter = 0; // Gemeinde ungefiltert
} elseif(strpos($gemeinde, ",") === false) {
	$gfilter = 1; // Gemeinde Einzelwert
} else {
	$gfilter = 2; // Gemeinde Filter-Liste
}

$kennztyp=ZerlegungGBKennz($gbkennz); // Grundbuch-Kennzeichen aus Parameter zerlegen: $z__ 
// 2=Such Bezirk-Nummer, 3=Such Blatt, 4=Such Buchung BVNR

// Quo Vadis?
if($blattgml != "") { // Flurstücke zum Grundbuch

	// Das Programm hat sich selbst verlinkt aus einer Liste der GB zu einem Eigentümer.
	// Wenn Parameter mitgegeben wurden, können diese für einen "Link zurück" verwendet werden.
	$trans="Flurst&uuml;cke zum Grundbuch";
	getFSbyGB(true); // mit BackLink

} elseif($person != "") { // Grundbücher zur Person
	// Das Programm hat sich selbst verlinkt aus einer Liste der Personen zu einer Suchmaske.
	if ($debug >= 2) {echo "\n<p class='dbg'>Gemeinde-Filter-Steuerung = '".$gfilter."'</p>";}

	// Die Filtereinstellung beeinflusst die Such-Strategie:
	if ($gfilter == 0) { // Keine Filterung auf "Gemeinde": große Datenmenge
		if ($kennztyp > 1) {
			$trans = "Grundb&uuml;cher in ".$zgbbez." von .."; // Filter GB-Bez
		} else {
			$trans = "Grundb&uuml;cher von .."; // Name steht darunter
		}
		getGBbyPerson();
		// Also schrittweise erst mal Stufe 2 = Grundbücher zur Person suchen.
		if(isset($blattgml) ) {	// Es wurde nur EIN Grundbuch zu der Person gefunden.
			$trans = "1 Blatt zum Eigent&uuml;mer";
			getFSbyGB(false); 	// Dann dazu auch gleich die Stufe 3 hinterher, aber ohne Backlink.
		}
	} else { // mit Filter auf Gemeinde: weniger Daten?
		if ($kennztyp > 1) {
			#trans="Grundb. und Flurst. in ".$zgbbez." von .. "; // zu lang
			$trans="Grdb. und Flst. von .. in .."; // Filter GB-Bez,
			// darunter sind dann Name und Bezirk farblich markiert
		} else {
			$trans="Grundb. und Flurst. von .."; // der Eigentümer steht darunter
		}
		getGBuFSbyPerson(); // Schritte 2+3 gleichzeitig, dabei Gemeinde-Filter auf Stufe 3
	}

} elseif(isset($name)) { // Suchbegriff aus Form: Suche nach Name

	$trans="Namensuche \"".$name."\"";
	getEigByName(); // Suchen nach Namensanfang

	if($person != "") { // genau EIN Treffer zum Namen
		if ($gfilter == 0) {
			$trans="Grundb&uuml;cher zum Namen";
			getGBbyPerson(); // Dann gleich das Grundbuch hinterher
		} else {
			$trans="Grdb. und Flst. zum Namen";
			getGBuFSbyPerson();	// .. oder auch GB + FS
		}
	}

} elseif ($debug >= 1) {
	$trans="falscher Aufruf";
	echo "\n<p class='dbg'>Parameter?</p>"; // sollte nicht vorkommen
}
// Titel im Kopf anzeigen
echo "
<script type='text/javascript'>
	transtitle('".$trans."'); 
</script>";

?>

</body>
</html>