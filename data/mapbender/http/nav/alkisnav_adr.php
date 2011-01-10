<?php
// Version vom 10.01.2011

// ToDo: 
//  Auswahl oder Sortierung "Gemeinde" if ($gemeinde == 0)
//  Sortierung nach Nummer aus Hausnummer

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
	<title>ALKIS-Suche Adressen</title>
	<link rel="stylesheet" type="text/css" href="alkisnav.css">
</head>
<body>

<?php
function suchStrName() {
// ============================
// Straﬂen nach Name(-nsanfang)
// ============================
	global $con, $street, $scalestr, $str_schl, $gkz, $gemeinde, $debug;
	$linelimit=120;  // -> in die Conf?
	preg_match("/^(\D+)(\d*)(\D*)/",$street,$matches); # 4 matches name/nr/zusatz echo "match: ".$matches[1].",".$matches[2].",".$matches[3];
	$matches[1] = preg_replace("/strasse/i","str", $matches[1]);
	$matches[1] = preg_replace("/str\./i","str", $matches[1]); 
	if(preg_match("/\*/",$matches[1])){
		$match="'".trim(preg_replace("/\*/i","%", strtoupper($matches[1]))). "' ";
	} else {
		$match="'".trim($matches[1])."%' ";
	}
	$sql ="SELECT g.bezeichnung AS gemname, k.bezeichnung, k.schluesselgesamt, k.lage  ";
	$sql.="FROM ax_lagebezeichnungkatalogeintrag as k ";
	$sql.="JOIN ax_gemeinde g ";
	$sql.="ON k.land=g.land AND k.regierungsbezirk=g.regierungsbezirk AND k.kreis=g.kreis AND k.gemeinde=g.gemeinde ";
	$sql.="WHERE k.bezeichnung ILIKE ".$match." ";
 	if($gemeinde > 0) { // Filter Gemeinde?
		$sql.="AND k.gemeinde=".$gemeinde." ";
	}
	$sql.="ORDER BY k.bezeichnung, k.lage ";
	// +++  if ($gemeinde == 0) ORDER Gemeinde, Straﬂe?
	$sql.="LIMIT ".$linelimit;
	$res=pg_query($con, $sql);
	if (!$res) {
		return "\n<p class='err'>Fehler bei Name</p>";
	}
	$cnt = 0;
	while($row = pg_fetch_array($res)) {
		$sname=$row["bezeichnung"];
		$gkey=$row["schluesselgesamt"];
		$gemname=$row["gemname"];
		$skey=$row["lage"];
		echo "\n\t<div class='st' title='Stra&szlig;enschl&uuml;ssel ".$skey."'>";
			echo "<a class='st' href='alkisnav_adr.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;str_schl=".$gkey."'>".$sname;
			if ($gemeinde == 0) {
				echo " - ".$gemname;
			}
			echo "</a><br>";
		echo "</div>";
		$cnt++;
	}
	if($cnt == 0) {
		echo "<p>Keine Stra&szlig;e.</p>";
	} elseif($cnt == 1) { // Eindeutig
		$str_schl=$skey; // dann gleich weiter
	} elseif($cnt >= $linelimit) {
		echo "<p>.. und weitere</p>";			
	}	
	return;
}

function suchHausZurStr(){
// =======================
// Haeuser zu einer Straﬂe
// =======================
	global $con, $str_schl, $gkz, $scalestr, $scalehs, $epsg, $gemeinde, $debug;
	
	// Strasse zum Strassenschluessel
	$sql ="SELECT k.bezeichnung, k.land, k.regierungsbezirk, k.kreis, k.gemeinde, k.lage ";
	$sql.="FROM ax_lagebezeichnungkatalogeintrag as k ";
	$sql.="WHERE schluesselgesamt = $1 LIMIT 1"; 
 	$v=array($str_schl);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);

	if($row = pg_fetch_array($res)) { // Strassenschluessel gefunden		$sname=$row["bezeichnung"];
		$land =$row["land"];
		$regb =$row["regierungsbezirk"];
		$kreis=$row["kreis"];
		$gemnd=$row["gemeinde"];
		//$lage=$row["lage"];
		$nr=ltrim($row["lage"], "0");

		// eine Koordinaten zur ausgew‰hlten Strasse besorgen
		// ax_Flurstueck  >zeigtAuf>  ax_LagebezeichnungOhneHausnummer
		$sqlko ="SELECT ";		
		$sqlko.="x(st_transform(st_Centroid(f.wkb_geometry), ".$epsg.")) AS x, ";
		$sqlko.="y(st_transform(st_Centroid(f.wkb_geometry), ".$epsg.")) AS y ";
		$sqlko.="FROM ax_lagebezeichnungohnehausnummer o ";
		$sqlko.="JOIN alkis_beziehungen v ON o.gml_id=v.beziehung_zu "; 
		$sqlko.="JOIN ax_flurstueck f ON v.beziehung_von=f.gml_id ";
		$sqlko.="WHERE o.land= $1 AND o.regierungsbezirk= $2 AND o.kreis= $3 AND o.gemeinde= $4 AND o.lage= $5 ";	
		$sqlko.="AND v.beziehungsart='zeigtAuf' LIMIT 1;";  // die erstbeste beliebige Koordinate
//		$resko=pg_query($con, $sqlko);
		$v=array($land,$regb,$kreis,$gemnd,$nr);
		$resko=pg_prepare("", $sqlko);
		$resko=pg_execute("", $v);
		if ($resko) {
			$rowko=pg_fetch_array($resko); 
			$x=$rowko["x"];
			$y=$rowko["y"];
		} else {		
			echo "\n<p class='err'>Fehler bei Koordinate zur Stra&szlig;e</p>";
		}
		$sqlko.="";
		//if ($debug >= 2) {echo "\n<p class='err'>Koord: '".$x."' '".$y."'</p>";}
		echo "\n<div class='st'>";		
		if ($x > 0) { // Koord. bekommen?
			echo "<a title='Positionieren 1:".$scalestr."' href='"; // mit Link
				echo "javascript:parent.parent.hideHighlight();";
				echo "parent.parent.parent.mb_repaintScale(\"mapframe1\",".$x.",".$y.",".$scalestr.");";
				echo " document.location.href=\"alkisnav_adr.php?gkz=".$gkz."&amp;str_schl=".$str_schl."\"' ";
				echo "onmouseover='parent.parent.showHighlight(" .$x. "," .$y. ")' ";
				echo "onmouseout='parent.parent.hideHighlight()'";
			echo ">".$sname." (".$nr.")</a>";
		} else { // keine Koord. dazu gefunden
			echo $sname." (".$nr.")"; // nur Anzeige, ohne Link
		}
		echo "\n</div><hr>";
		
		// Haeuser zum Strassenschluessel
		$sql ="SELECT h.hausnummer, ";
		$sql.="x(st_transform(st_Centroid(g.wkb_geometry), ".$epsg.")) AS x, ";
		$sql.="y(st_transform(st_Centroid(g.wkb_geometry), ".$epsg.")) AS y ";
		$sql.="FROM ax_lagebezeichnungmithausnummer h ";
		$sql.="JOIN alkis_beziehungen v ON h.gml_id=v.beziehung_zu ";
		$sql.="JOIN ax_gebaeude g ON v.beziehung_von=g.gml_id ";
		$sql.="WHERE h.land=".$land." AND h.regierungsbezirk=".$regb." AND h.kreis=".$kreis." AND h.lage=".$nr." "; // integer
		$sql.="AND v.beziehungsart='zeigtAuf' ";
		$sql.="ORDER BY hausnummer;";
		// Sortierproblem: Hausnummer, numerischer Teil sollte numerisch sortiert sein.
		//if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
		$resh=pg_query($con, $sql);
		$cnt=0;
		$count=0;		echo "<table>";

		// mehrere Hausnummern je Zeile ausgeben		while($rowh = pg_fetch_array($resh)) {
			if($count == 0){
				echo "\n<tr>";
			}
			$gml=$rowh["gml_id"];			
			$nr=$rowh["hausnummer"];			
			$x=$rowh["x"];
			$y=$rowh["y"];

			echo "\n\t<td class='hsnr'>";
				echo "<a href='";
					echo "javascript:parent.parent.parent.mb_repaintScale(\"mapframe1\",".$x.",".$y.",".$scalehs."); ";
					echo "parent.parent.hideHighlight();' ";
				echo "onmouseover='parent.parent.showHighlight(".$x.",".$y.")' ";
				echo "onmouseout='parent.parent.hideHighlight()";
				echo "'>".$nr."</a>";
			echo "\n\t</td>";
			$cnt++;
			$count++;
			if($count == 6) {
				echo "\n</tr>";
				$count = 0;
			}
		}
		if($count > 0) {echo "\n</tr>";}
		echo "\n</table>";
		echo "\n<p class='hilfe'>".$cnt." Hausnummern</p>";
	} else {
		echo "\n<p class='err'>Kein Haus.</p>";
	}
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

if(isset($street)) {
	// dies ist noch nicht mˆglich, es muesste der Gesamt-Keystring eingegeben werden	
	if (is_numeric($street)) {
		$str_schl = $street; // Schluessel (eindeutig) ist schon gesetzt
	} else {
		suchStrName(); // Suche nach Name
	}
} 
// Strassenschluessel suchen
// Verknuepfung zwischen "suchStrName" und "suchHausZurStr" uber Gesamt-Schluessel
// Alternative f¸r Eingabefeld (nur db-Feld "lage")?  
// z.B. HIER trennen zwischen Eingabe-Key und Result-Key

if(isset($str_schl)){
	suchHausZurStr();
}
?>

</body>
</html>