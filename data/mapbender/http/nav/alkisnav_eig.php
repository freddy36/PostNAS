<?php
/* Version vom 
	13.01.2011 
	11.04.2011 epsg in Link, transform nur wenn notwendig
	25.07.2011 PostNAS 0.5/0.6 Versionen unterscheiden
	24.10.2011 Nach Pos-Klick Highlight erneuern statt hideHighlight
	17.11.2011 Nachweis-Links über javascript im neuen Hochformat-Fenster
	02.12.2011 Suche nach Vorname Nachname oder Nachname
*/
import_request_variables("PG");
include("../../conf/alkisnav_conf.php");
$con_string = "host=".$host." port=".$port." dbname=".$dbname.$dbvers.$gkz." user=".$user." password=".$password;
$con = pg_connect ($con_string) or die ("<p class='err'>Fehler bei der Verbindung zur Datenbank</p>".$dbname.$dbvers.$gkz);
// ToDo: Buchung zwischen Blatt und Flst?
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
	global $gkz, $gemeinde, $epsg, $con, $name, $person, $gb;
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
	
	$sql ="SELECT p.nachnameoderfirma, p.vorname, p.gml_id FROM ax_person as p ";
	if($match1 != '%'){
		$sql.="WHERE nachnameoderfirma ILIKE $1 AND p.vorname ILIKE $2 ";		
		$sql.="ORDER BY p.nachnameoderfirma, p.vorname LIMIT $3 ;";
		$v=array($match, $match1, $linelimit);
	}else{
		$sql.="WHERE nachnameoderfirma ILIKE $1 ";		
		$sql.="ORDER BY p.nachnameoderfirma, p.vorname LIMIT $2 ;";
		$v=array($match, $linelimit);
	} 
	// +++ Adresse der Person zur eindeutigen Bestimmung?
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Eigent&uuml;mer</p>";
		return;
	}
	$cnt = 0;
	// einfache Liste ohne div und Icon	
	while($row = pg_fetch_array($res)) {
		$nnam=htmlentities($row["nachnameoderfirma"], ENT_QUOTES, "UTF-8");
		$vnam=htmlentities($row["vorname"], ENT_QUOTES, "UTF-8");
		$gml=$row["gml_id"];
		// +++ Icon mit Link auf Person-Auskunft, über gml_id	
		// Zur Zeit siehe unten: erst nach Auswahl einer einzelnen Person
		echo "\n<a class='nam' title='Person' href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;person=".$gml."&amp;name=".$nnam."'>".$nnam.", ".$vnam."</a>\n<br>";
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
	echo "\n<div class='nam'>";
		// Link zur Auskunft Person
		echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisnamstruk.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;gmlid=".$person."\")'>";
			echo "\n\t\t<img class='nwlink' src='ico/Eigentuemer.ico' width='16' height='16' alt='EIG'>";
		echo "\n\t</a> ";
		echo "\n\t<p class='nam'>";		
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
		echo "\n\t</p>";
	echo "\n</div>";

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
	global $gkz, $gemeinde, $con, $name, $person, $gb, $scalefs, $auskpath, $epsg;
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

	// Blatt <vbg/istBestandteilVon<  Buchungsstelle <vfb/istGebucht< Flurstck.
	$sql ="SELECT s.laufendenummer AS lfd, f.gml_id, f.flurnummer, f.zaehler, f.nenner, f.gemeinde, ";
	if($epsg == "25832") { // Transform nicht notwendig
		$sql.="x(st_centroid(f.wkb_geometry)) AS x, ";
		$sql.="y(st_centroid(f.wkb_geometry)) AS y, ";
	} else {  
		$sql.="x(st_transform(st_centroid(f.wkb_geometry), ".$epsg.")) AS x, ";
		$sql.="y(st_transform(st_centroid(f.wkb_geometry), ".$epsg.")) AS y, ";			
	}
	$sql.="g.gemarkungsnummer, g.bezeichnung ";
   $sql.="FROM alkis_beziehungen vbg ";
	$sql.="JOIN ax_buchungsstelle s ON vbg.beziehung_von = s.gml_id "; 
	$sql.="JOIN alkis_beziehungen vfb ON s.gml_id = vfb.beziehung_zu "; 
	$sql.="JOIN ax_flurstueck f  ON vfb.beziehung_von = f.gml_id ";
   $sql.="JOIN ax_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer ";
	$sql.="WHERE vbg.beziehung_zu= $1 AND vbg.beziehungsart='istBestandteilVon' AND vfb.beziehungsart='istGebucht' ";
	$sql.="ORDER BY s.laufendenummer, f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner LIMIT $2 ;";

	// +++ Sonderfall Fehlt noch: Blatt -> Buchung -> (Recht an) Buchung -> Flurstück
	// +++ Ebene Buchung dazwischen wie im Teil 'Grundbuch' ?
	$v=array($gb, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Buchung und Flurst&uuml;ck.</p>";
		if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
		return;
	}
	$zfs=0;
	while($row = pg_fetch_array($res)) {	
		$fs_gml=$row["gml_id"];
		$bvnr=$row["lfd"];
		if ($bvnr > 0) {		
			$bvnr=str_pad($bvnr, 4, "0", STR_PAD_LEFT);
		} else {
			$bvnr="";
		}
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
		$zfs++;
	}
	if($zfs == 0) { 
		echo "\n<p class='err'>Kein Flurst&uuml;ck.</p>";
		echo "\n<p class='hilfe'>Hinweis: Sonderf&auml;lle wie 'Erbbaurecht' sind noch nicht umgesetzt.</p>";
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