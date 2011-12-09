<?php
/* Version vom 
	24.10.2011	Nach Pos-Klick Highlight erneuern statt hideHighlight
	17.11.2011	Nachweis-Links über javascript im neuen Hochformat-Fenster
	02.12.2011	Suche nach Vorname Nachname oder Nachname
	09.12.2011	Filter "Gemeinde" für Ebene Flurstücke.
					Filter "Gemeinde" für Personen über neue Hilfstabelle "gemeinde_person".
					Format css Person (Rahmen).
	ToDo: Auf der Stufe 2 "getGBbyPerson" noch Filtern nach Gemeinde
*/
import_request_variables("PG");
include("../../conf/alkisnav_conf.php");
$con_string = "host=".$host." port=".$port." dbname=".$dbname.$dbvers.$gkz." user=".$user." password=".$password;
$con = pg_connect ($con_string) or die ("<p class='err'>Fehler bei der Verbindung zur Datenbank</p>".$dbname.$dbvers.$gkz);
?>

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
	</script>
</head>
<body>

<?php

function getEigByName() {
// 1 =============================
// Eigentuemer nach Name(-nsanfang)
// ===============================
	global $gkz, $gemeinde, $epsg, $con, $name, $person, $gb, $gfilter, $persfilter, $auskpath;
	$linelimit=120;
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

	if ($persfilter and ($gfilter > 0)) {
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
		$nnam=htmlentities($row["nachnameoderfirma"], ENT_QUOTES, "UTF-8");
		$vnam=htmlentities($row["vorname"], ENT_QUOTES, "UTF-8");
		$gml=$row["gml_id"];
		// Link zur Auskunft Person  +++ Icon differenzieren? Firma/Person
		echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisnamstruk.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;gmlid=".$gml."\")'>";
			echo "\n\t\t<img class='nwlink' src='ico/Eigentuemer.ico' width='16' height='16' alt='EIG'>";
		echo "\n\t</a> ";		
		echo "\n<a title='Person' href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;person=".$gml."&amp;name=".$nnam."'>".$nnam.", ".$vnam."</a>\n<br>";
		$cnt++;
	}
	if($cnt == 0){ 
		echo "\n<p class='err'>Keine Person.</p>";
	} elseif($cnt >= $linelimit) {
		echo "\n<p title='Bitte den Namen eindeutiger qualifizieren'>... und weitere</p>";
	} elseif($cnt == 1){ // Eindeutig!
		$person = $gml;
	}
	return;
}

function getGBbyPerson() {
// 2 =================================
// Grundbücher zur gewählten Person
// ===================================
	global $gkz, $gemeinde, $epsg, $con, $name, $person, $gb, $auskpath;
	$linelimit=120;
	if(isset($name)) { // Familiensuche
		echo "\n<div class='back' title='Andere Personen mit diesem Nachnamen'>";
			echo "\n\t\t<img class='nwlink' src='ico/Eigentuemer_2.ico' width='16' height='16' alt='FAM'> ";
			echo "\n<a class='back' href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;name=".$name."'>\"".$name."\"</a>";
		echo "\n</div>\n<br>";	
	}
	$sql="SELECT p.nachnameoderfirma, p.vorname, p.geburtsdatum, p.namensbestandteil, ";
	$sql.="a.ort_post, a.postleitzahlpostzustellung AS plz, a.strasse, a.hausnummer ";
	$sql.="FROM ax_person p ";
	$sql.="JOIN alkis_beziehungen b ON p.gml_id=b.beziehung_von ";
	$sql.="JOIN ax_anschrift a ON a.gml_id=b.beziehung_zu ";
	$sql.="WHERE p.gml_id= $1 AND b.beziehungsart='hat';";	
	$v=array($person);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {echo "\n<p class='err'>Fehler bei Name</p>\n";}
	// Daten der Person
	echo "\n\t<table>\n\t<tr>\n\t\t<td valign='top'>";
		// Sp. 1: Icon, Link zur Auskunft Person
		echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisnamstruk.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;gmlid=".$person."\")'>";
			echo "\n\t\t<img class='nwlink' src='ico/Eigentuemer.ico' width='16' height='16' alt='EIG'>";
		echo "\n\t</a></td>\n\t\t<td>";
		echo "\n\t<p class='nam'>"; // Sp. 2: Rahmen
		if ($row = pg_fetch_array($res)) {
			$namzeil=$row["nachnameoderfirma"].", ".$row["vorname"];
			$gebdat=$row["geburtsdatum"];
			if ($gebdat != "") {$namzeil.= ", geb. ".$gebdat;}
			$best=$row["namensbestandteil"];
			if ($best != "") {$namzeil.= ", ".$best;}
			echo htmlentities($namzeil, ENT_QUOTES, "UTF-8");
			$namzeil=$row["plz"]." ".$row["ort_post"];
			if (trim($namzeil) != "") {echo "\n\t<br>".htmlentities($namzeil, ENT_QUOTES, "UTF-8");}
			$namzeil=$row["strasse"]." ".$row["hausnummer"];
			if (trim($namzeil) != "") {echo "\n\t<br>".htmlentities($namzeil, ENT_QUOTES, "UTF-8");}
		}
	echo "\n\t</p></td></tr>\n\t</table>";

	// Suche nach Grundbüchern der Person
	$sql ="SELECT g.gml_id AS gml_g, g.buchungsblattnummermitbuchstabenerweiterung as nr, b.bezeichnung AS beznam ";
	$sql.="FROM alkis_beziehungen bpn ";
	$sql.="JOIN ax_namensnummer n ON bpn.beziehung_von=n.gml_id ";
	$sql.="JOIN alkis_beziehungen bng ON n.gml_id=bng.beziehung_von ";
	$sql.="JOIN ax_buchungsblatt g ON bng.beziehung_zu=g.gml_id ";
	$sql.="JOIN ax_buchungsblattbezirk b ON g.land = b.land AND g.bezirk = b.bezirk ";
	$sql.="WHERE bpn.beziehung_zu= $1 AND bpn.beziehungsart='benennt' AND bng.beziehungsart='istBestandteilVon' ";
	$sql.="ORDER BY g.bezirk, g.buchungsblattnummermitbuchstabenerweiterung LIMIT $2 ;";
	$v=array($person, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Grundbuch</p>";
		return;
	}
	$cnt = 0;
	while($row = pg_fetch_array($res)) {
		$gml=$row["gml_g"];
		$beznam=$row["beznam"];
		$nr=$row["nr"];
		echo "\n<div class='gb'>";
			echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisbestnw.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;gmlid=".$gml."\")'>";
				echo "\n\t\t<img class='nwlink' src='ico/GBBlatt_link.ico' width='16' height='16' alt='GB'>";
			echo "\n\t</a> ";		
			echo "\n\t".$beznam."<a title='Grundbuch' href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;gb=".$gml."&amp;person=".$person."'> Blatt ".$nr."&nbsp;</a>";
		echo "\n</div>";
		$cnt++;
	}
	if($cnt == 0){ 
		echo "\n<p class='err'>Kein Grundbuch.</p>";
	} elseif($cnt >= $linelimit) {
		echo "\n<p>... und weitere</p>";
	} elseif($cnt == 1){ // Eindeutig!
		$gb=$gml; // dann Stufe 3 gleich nachschieben
	}
	return;
}
	
function getFSbyGB($backlink) {
// 3 =================================
// Flurstücke zum gewählten Grundbuch
// ===================================
	global $gkz, $gemeinde, $con, $name, $person, $gb, $scalefs, $auskpath, $epsg, $gfilter, $persfilter;
	$linelimit=120;

	if($backlink) {	
		echo "\n\t<div class='back' title='zur&uuml;ck zur Person'>";
			echo "\n\t\t<img class='nwlink' src='ico/Eigentuemer.ico' width='16' height='16' alt='EIG'> ";
			echo "\n\t<a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;person=".$person."'>";
			echo "zur&uuml;ck</a><br>";		
		echo "</div>";
		echo "<div class='gb'>";
			echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$gb."\")'>";
				echo "\n\t\t<img class='nwlink' src='ico/GBBlatt_link.ico' width='16' height='16' alt='GB'>";
			echo "\n\t</a> Grundbuch";
		echo "</div>";	
	}

	// SQL-Bausteine vorbereiten
	$sql1 ="SELECT s1.laufendenummer AS lfd, f.gml_id, f.flurnummer, f.zaehler, f.nenner, f.gemeinde, ";
	if($epsg == "25832") { // Transform nicht notwendig
		$sql1.="x(st_centroid(f.wkb_geometry)) AS x, ";
		$sql1.="y(st_centroid(f.wkb_geometry)) AS y, ";
	} else {  
		$sql1.="x(st_transform(st_centroid(f.wkb_geometry), ".$epsg.")) AS x, ";
		$sql1.="y(st_transform(st_centroid(f.wkb_geometry), ".$epsg.")) AS y, ";			
	}
	$sql1.="g.gemarkungsnummer, g.bezeichnung ";
   $sql1.="FROM alkis_beziehungen vbg ";
	$sql1.="JOIN ax_buchungsstelle s1 ON vbg.beziehung_von = s1.gml_id "; 

	// Zwischen-JOIN (zusätzlich nur bei zweiter Abfrage)
	$sqlz ="JOIN alkis_beziehungen vss ON vss.beziehung_von = s1.gml_id ";
	$sqlz.="JOIN ax_buchungsstelle s2 ON vss.beziehung_zu = s2.gml_id ";

	$sqla1 ="JOIN alkis_beziehungen vfb ON s1.gml_id = vfb.beziehung_zu ";
	$sqla2 ="JOIN alkis_beziehungen vfb ON s2.gml_id = vfb.beziehung_zu ";

	$sql2.="JOIN ax_flurstueck f  ON vfb.beziehung_von = f.gml_id ";
   $sql2.="JOIN ax_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer ";

	if ($persfilter and ($gfilter > 0)) {
		$sql2.="JOIN gemeinde_gemarkung v ON g.land=v.land AND g.gemarkungsnummer=v.gemarkung ";
	}

	$sql2.="WHERE vbg.beziehung_zu= $1 AND vbg.beziehungsart='istBestandteilVon' AND vfb.beziehungsart='istGebucht' ";

	if ($persfilter and ($gfilter > 0)) {
		switch ($gfilter) {
			case 1: // Einzelwert
				$sql2.="AND v.gemeinde=".$gemeinde." "; break;
			case 2: // Liste
				$sql2.="AND v.gemeinde in (".$gemeinde.") "; break;
		}
	}
	$sql2.="ORDER BY s1.laufendenummer, f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner LIMIT $2 ;";

	// Blatt <vbg/istBestandteilVon<  Buchungsstelle <vfb/istGebucht< Flurstck.
	$sql=$sql1.$sqla1.$sql2; // Direkte Buchungen

	$v=array($gb, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Buchung und Flurst&uuml;ck.</p>";
		if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
		return;
	}
	$zfs1=0;
	while($row = pg_fetch_array($res)) {	
		$fs_gml=$row["gml_id"];
		$bvnr=$row["lfd"];
		if ($bvnr > 0) {$bvnr=str_pad($bvnr, 4, "0", STR_PAD_LEFT);} else {$bvnr="";}
		$gmkg=$row["bezeichnung"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // Bruchnummer
		$x=$row["x"];
		$y=$row["y"];
		echo "\n<div class='fs'>";
			echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$fs_gml."\")'>";
				echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Link.ico' width='16' height='16' alt='FS'>";
			echo "\n\t</a> ";	
			echo "\n\tFlst. <a title='Flurst&uuml;ck positionieren 1:".$scalefs."' href='";
					echo "javascript:parent.parent.parent.mb_repaintScale(\"mapframe1\",".$x.",".$y.",".$scalefs."); ";
					echo "parent.parent.showHighlight(".$x.",".$y.");' ";
				echo "onmouseover='parent.parent.showHighlight(".$x.",".$y.")' ";
				echo "onmouseout='parent.parent.hideHighlight()'>";
			echo $bvnr." ".$gmkg." ".$flur."-".$fskenn."</a>";
		echo "\n</div>";
		$zfs1++;
	}

	// Zweite Abfrage (Variante) aus den Bausteinen zusammen bauen
	// buchungsStelle2 < an < buchungsStelle1
	$sql=$sql1.$sqlz.$sqla2.$sql2; // Rechte an

	$v=array($gb, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Recht an Buchung.</p>";
		if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
		return;
	}
	$zfs2=0;
	while($row = pg_fetch_array($res)) {	
		$fs_gml=$row["gml_id"];
		$bvnr=$row["lfd"];
		if ($bvnr > 0) {$bvnr=str_pad($bvnr, 4, "0", STR_PAD_LEFT);} else {$bvnr="";}
		$gmkg=$row["bezeichnung"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // Bruchnummer
		$x=$row["x"];
		$y=$row["y"];
		echo "\n<div class='fs'>";
			echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$fs_gml."\")'>";
				echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Link.ico' width='16' height='16' alt='FS'>";
			echo "\n\t</a> ";	
			echo "\n\tRecht an <a title='Flurst&uuml;ck positionieren 1:".$scalefs."' href='";
					echo "javascript:parent.parent.parent.mb_repaintScale(\"mapframe1\",".$x.",".$y.",".$scalefs."); ";
					echo "parent.parent.showHighlight(".$x.",".$y.");' ";
				echo "onmouseover='parent.parent.showHighlight(".$x.",".$y.")' ";
				echo "onmouseout='parent.parent.hideHighlight()'>";
			echo $bvnr." ".$gmkg." ".$flur."-".$fskenn."</a>";
		echo "\n</div>";
		$zfs2++;
	}

	if($zfs1 + $zfs2 == 0) { 
		echo "\n<p class='err'>Kein Flurst&uuml;ck im berechtigten Bereich.</p>";
	//	echo "\n<p class='hilfe'>Hinweis: Sonderf&auml;lle wie 'Erbbaurecht' sind noch nicht umgesetzt.</p>";
	} elseif($zfs >= $linelimit) {
		echo "\n<p>... und weitere</p>"; 
	}
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
	if ($debug >= 2) {echo "<p>aktueller EPSG='".$epsg."'</p>";} // aus MB
	$epsg = str_replace("EPSG:", "" , $_REQUEST["epsg"]);	
} else {
	if ($debug >= 1) {echo "<p class='err'>kein EPSG gesetzt</p>";}	
	$epsg=$gui_epsg; // aus Conf
}
if ($debug >= 2) {echo "<p>Filter Gemeinde = ".$gemeinde."</p>";}
if ($gemeinde == "") {
	$gfilter = 0; // ungefiltert
} elseif(strpos($gemeinde, ",") === false) {
	$gfilter = 1; // Einzelwert
} else {
	$gfilter = 2; // Liste
}

// Welche Parameter?
// 3. Stufe: Flurstücke zum Grundbuch
if(isset($gb)) { // gml_id
	// Das Programm hat sich selbst verlinkt aus einer Liste der GB zu einem Eigentümer.
	// Wenn Parameter mitgegeben wurden, können diese für einen "Link zurück" verwendet werden.
	getFSbyGB(true);
} elseif(isset($person)) { // gml_id - 2. Stufe: Grundbücher zur Person
	// Das Programm hat sich selbst verlinkt aus einer Liste der Personen zu einer Suchmaske.
	getGBbyPerson(); 
	if(isset($gb) ) { getFSbyGB(false);} // Es wurde nur EIN Grundbuch zu der Person gefunden.
} elseif(isset($name)) { // Suchbegriff aus Form - 1. Stufe: Suche nach Name
	getEigByName(); 
	if(isset($person)) { getGBbyPerson();}
} elseif ($debug >= 2) {
	echo "\n<p>Parameter?</p>"; // Programmfehler
}
?>

</body>
</html>