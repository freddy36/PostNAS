<?php
/* Version vom 
	2013-04-26	"import_request_variables" entfällt in PHP 5.4.
					Zurück-Link, Titel der Transaktion anzeigen
	2013-04-29	Test mit IE
	2013-05-07  Strukturierung des Programms
	2013-05-14  Feinkorrekturen
	2013-05-15  Gruppierung nach Gemeinde, mehrfache HsNr (ap_pto.advstandardmodell) unterdrücken, Icon f. Straße
	2014-01-23	Link zum Auskunft-Modul für Straße
	2014-09-03  PostNAS 0.8: ohne Tab. "alkis_beziehungen", mehr "endet IS NULL", Spalten varchar statt integer
	2014-09-15  Bei Relationen den Timestamp abschneiden, mehr "endet IS NULL"
	2014-09-30 Rückbau substring(gml_id)

	ToDo:
	-	Gruppierung (mit Zeile) der Straßenliste nach Gemeinde
	-	Eingabe aus "Balken" von Buchauskunft "Lage" zulassen: Numerisch: Gem-Str-Haus-lfd
		-- lfd (Nebengebäude) als Untergliederung der geklickten Haus-Nr anzeigen
		Analog zur Zerlegung des FS-Kennz in _fls
	-	Mouse-Over in Straßenliste soll Position zeigen.
		Dazu in der DB eine Tabelle mit Koordinate zum Straßenschlüssel aufbauen. 
*/
$cntget = extract($_GET);
include("../../conf/alkisnav_conf.php");
include("alkisnav_fkt.php"); // Funktionen
$con_string = "host=".$host." port=".$port." dbname=".$dbname.$dbvers.$gkz." user=".$user." password=".$password;
$con = pg_connect ($con_string) or die ("Fehler bei der Verbindung zur Datenbank ".$$dbname.$dbvers.$gkz);
echo <<<END

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ALKIS-Suche Adressen</title>
	<link rel="stylesheet" type="text/css" href="alkisnav.css">
	<script type='text/javascript'>
		function transtitle (trans) { // Titel der letzten Transaktion anzeigen
			document.getElementById('transaktiontitle').innerHTML = trans;
		}
		function imFenster(dieURL) {
			var link = encodeURI(dieURL);
			window.open(link,'','left=10,top=10,width=620,height=800,resizable=yes,menubar=no,toolbar=no,location=no,status=no,scrollbars=yes');
		}
	</script>
</head>
<body>
<a href='javascript:history.back()'>
	<img src="ico/zurueck.ico" width="16" height="16" alt="&lt;&lt;" title="zur&uuml;ck">
</a>
<dfn class='title' id='transaktiontitle'></dfn>

END;

function suchStrName() { // Strassen nach Name(-nsanfang)
	global $street, $scalestr, $str_schl, $gkz, $gemeinde, $epsg, $gfilter, $debug, $auskpath;
	$linelimit=120;  // -> in die Conf?
	preg_match("/^(\D+)(\d*)(\D*)/",$street,$matches); # 4 matches name/nr/zusatz echo "match: ".$matches[1].",".$matches[2].",".$matches[3];
	$matches[1] = preg_replace("/strasse/i","str", $matches[1]);
	$matches[1] = preg_replace("/str\./i","str", $matches[1]); 
	if(preg_match("/\*/",$matches[1])){
		$match=trim(preg_replace("/\*/i","%", strtoupper($matches[1])));
	} else {
		$match=trim($matches[1])."%";
	}
	$sql ="SELECT g.gemeinde, g.bezeichnung AS gemname, k.gml_id, k.bezeichnung, k.schluesselgesamt, k.lage 
	FROM ax_lagebezeichnungkatalogeintrag k 
	JOIN ax_gemeinde g ON k.land=g.land AND k.regierungsbezirk=g.regierungsbezirk AND k.kreis=g.kreis AND k.gemeinde=g.gemeinde 
	WHERE k.bezeichnung ILIKE $1 AND k.endet IS NULL AND g.endet IS NULL ";
	switch ($gfilter) {
		case 1: // Einzelwert
			$sql.="AND k.gemeinde='".$gemeinde."' ";
			break;
		case 2: // Liste
			$sql.="AND k.gemeinde in (".str_replace(",", "','", $gemeinde).") ";
			break;
		default: // kein Filter
			break;
	}
	$sql.="ORDER BY g.bezeichnung, k.bezeichnung, k.lage LIMIT $2 ;";
 	$v=array($match,$linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);

	if (!$res) {
		echo "\n<p class='err'>Fehler bei Name</p>";
		if ($debug > 2) {echo "<p class='dbg'>SQL = '".$sql."'<p>";}
		return;
	}

	$cnt = 0;
	$gwgem="";
	while($row = pg_fetch_array($res)) {
		$gemname=$row["gemname"];
		$gemnr=$row["gemeinde"] ;
		if ($gwgem != $gemname) {
			if ($gfilter != 1) {
				zeile_gemeinde($gemnr, $gemname, false); // ToDo: aber ohne Link oder Link verarbeiten können
			}
			$gwgem=$gemname;
		}
		$gkey=$row["schluesselgesamt"]; // Land-RegBez-Kreis-Gem-Strasse - für weitere Suche
		$skey=$row["lage"]; // Nur Str.-schl. daraus
		$kgml=$row["gml_id"]; // ID von Katalog

// +++ in function_zeile_strasse()
		$sname=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");	
		echo "\n\t<div class='stl' title='Stra&szlig;enschl&uuml;ssel ".$skey."'>";
		// Icon -> Buchnachweis
		echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisstrasse.php?gkz=".$gkz."&amp;gmlid=".$kgml."\")'>";
			echo "\n\t\t<img class='nwlink' src='ico/Lage_mit_Haus.ico' width='16' height='16' alt='STR' title='Stra&szlig;e'>";
		echo "\n\t</a>";
		echo "<a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;str_schl=".$gkey."'>".$sname."</a>";
		echo "</div>";
// +++ function ende
		$cnt++;
	}
	if($cnt == 0) {
		echo "<pclass='anz'>Keine Stra&szlig;e</p>";
	} elseif($cnt == 1) { // Eindeutig
		$str_schl=$gkey; // dann gleich weiter
	} elseif($cnt >= $linelimit) {
		echo "<p class='anz'>".$cnt." Stra&szlig;en ... und weitere</p>";			
	} elseif ($cnt > 1) {
		echo "\n<p class='anz'>".$cnt." Stra&szlig;en</p>";	
	}
	return;
}

function suchStrKey() { // Strassen nach num. Schluessel
	global $street, $scalestr, $str_schl, $gkz, $gemeinde, $epsg, $gfilter, $debug, $auskpath;
	$linelimit=60;
	if(preg_match("/\*/",$street)) {
		$match=trim(preg_replace("/\*/i","%",$street));
		// fuehrende Nullen eingeben oder fuehrende Wildcard
	} else {
		$match=str_pad($street, 5, "0", STR_PAD_LEFT); // "Wie eine Zahl" verarbeiten 
	}
	$sql ="SELECT g.bezeichnung AS gemname, k.gml_id, k.bezeichnung, k.schluesselgesamt, k.lage 
	FROM ax_lagebezeichnungkatalogeintrag as k 
	JOIN ax_gemeinde g ON k.land=g.land AND k.regierungsbezirk=g.regierungsbezirk AND k.kreis=g.kreis AND k.gemeinde=g.gemeinde 
	WHERE k.lage LIKE $1 AND k.endet IS NULL AND g.endet IS NULL ";
	switch ($gfilter) {
		case 1: // Einzelwert
			$sql.="AND k.gemeinde='".$gemeinde."' ";
			break;
		case 2: // Liste
			$sql.="AND k.gemeinde in ('".str_replace(",", "','", $gemeinde)."') ";
			break;
	}
	$sql.="ORDER BY k.lage, k.bezeichnung LIMIT $2 ;";

 	$v=array($match,$linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Schl&uuml;ssel</p>";
		return;
	}
	$cnt = 0;
	while($row = pg_fetch_array($res)) {
		$sname=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");		
		$gkey=$row["schluesselgesamt"];
		$gemname=htmlentities($row["gemname"], ENT_QUOTES, "UTF-8");
		$skey=$row["lage"];
		$kgml=$row["gml_id"]; // ID von Katalog	
		
// +++ in function_zeile_strasse()
		echo "\n\t<div class='stl' title='Stra&szlig;enschl&uuml;ssel ".$skey."'>";

			// Icon -> Buchnachweis
			echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisstrasse.php?gkz=".$gkz."&amp;gmlid=".$kgml."\")'>";
				echo "\n\t\t<img class='nwlink' src='ico/Lage_mit_Haus.ico' width='16' height='16' alt='STR' title='Stra&szlig;e'>";
			echo "\n\t</a>";
		
			echo $skey." <a class='st' href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;str_schl=".$gkey."' title='".$gemname."'>".$sname;
			echo "</a>";
			switch ($gfilter) {
				case 0: // Kein Filter
					echo " in ".$gemname;
					break;
				case 2: // Liste
					echo " in ".$gemname;
					break;
			}
		echo "</div>";
// function ende

		$cnt++;
	}
	if($cnt == 0) {
		echo "\n<p class='anz'>Keine Stra&szlig;e mit Schl&uuml;ssel ".$match."</p>";
	} elseif($cnt == 1) { // Eindeutig
		$str_schl=$gkey; // dann gleich weiter
	} elseif ($cnt >= $linelimit) {
		echo "\n<p>".$cnt." Stra&szlig;en ... und weitere</p>";			
	} elseif ($cnt > 1) {
		echo "\n<p class='anz'>".$cnt." Stra&szlig;en</p>";	
	}	
	return;
}

function suchHausZurStr($showParent) { // Haeuser zu einer Strasse
	global $str_schl, $gkz, $scalestr, $scalehs, $epsg, $gemeinde, $epsg, $gfilter, $debug, $auskpath;

	// Head
	// Strasse zum Strassenschluessel
	$sql ="SELECT g.bezeichnung AS gemname, k.gml_id AS kgml, k.bezeichnung, k.land, k.regierungsbezirk, k.kreis, k.gemeinde, k.lage 
	FROM ax_lagebezeichnungkatalogeintrag as k 
	JOIN ax_gemeinde g ON k.land=g.land AND k.regierungsbezirk=g.regierungsbezirk AND k.kreis=g.kreis AND k.gemeinde=g.gemeinde 
	WHERE k.schluesselgesamt = $1 AND k.endet IS NULL AND g.endet IS NULL LIMIT 1"; 

  	$v=array($str_schl);	// Schluessel-Gesamt ..
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Name zum Stra&szlig;enschl&uuml;ssel</p>";
		if ($debug > 2) {echo "<p class='dbg'>SQL = '".$sql."'<p>";}
		return;
	}

	if($row = pg_fetch_array($res)) { // .. gefunden
		$kgml=$row["kgml"]; // ID aus Katalog
		$sname=$row["bezeichnung"];
		$land =$row["land"];	// Einzel-Felder für JOIN _lagebezeichnung_
		$regb =$row["regierungsbezirk"];
		$kreis=$row["kreis"];
		$gemnd=$row["gemeinde"];
		$nr=$row["lage"];
		$gemname=htmlentities($row["gemname"], ENT_QUOTES, "UTF-8");
		if ($showParent) {
			// EINE Koordinate zur Strasse besorgen
			// ax_Flurstueck >zeigtAuf> ax_LagebezeichnungOhneHausnummer
			$sqlko ="SELECT ";
			if($epsg == "25832") { // Transform nicht notwendig
				$sqlko.="st_x(st_Centroid(f.wkb_geometry)) AS x, ";
				$sqlko.="st_y(st_Centroid(f.wkb_geometry)) AS y ";
			} else {
				$sqlko.="st_x(st_transform(st_Centroid(f.wkb_geometry), ".$epsg.")) AS x, ";
				$sqlko.="st_y(st_transform(st_Centroid(f.wkb_geometry), ".$epsg.")) AS y ";
			}
			$sqlko.="FROM ax_lagebezeichnungohnehausnummer o ";
			$sqlko.="JOIN ax_flurstueck f ON o.gml_id=ANY(f.zeigtauf) ";
			$sqlko.="WHERE o.land= $1 AND o.regierungsbezirk= $2 AND o.kreis= $3 AND o.gemeinde= $4 AND o.lage= $5 ";	
			$sqlko.="LIMIT 1;"; // die erstbeste Koordinate
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

// +++ IN ARBEIT:
			echo "\n\t<div class='stu' title='Stra&szlig;enschl&uuml;ssel ".$skey."'>";
			// Icon -> Buchnachweis
			echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisstrasse.php?gkz=".$gkz."&amp;gmlid=".$kgml."\")'>";
				echo "\n\t\t<img class='nwlink' src='ico/Lage_mit_Haus.ico' width='16' height='16' alt='STR' title='Stra&szlig;e'>";
			echo "\n\t</a>";

			if ($x > 0) { // Koord. bekommen?
				echo "\n\t<a title='Positionieren 1:".$scalestr."' href='javascript:"; // mit Link
						echo "transtitle(\"auf Stra&szlig;e positioniert\"); ";
						echo "parent.parent.parent.mb_repaintScale(\"mapframe1\",".$x.",".$y.",".$scalestr."); ";
						echo "parent.parent.showHighlight(".$x.",".$y."); ";
					//	echo "document.location.href=\"".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;str_schl=".$str_schl."\"";
					echo "' "; // end href
					echo "\n\t\tonmouseover='parent.parent.showHighlight(" .$x. "," .$y. ")' ";
					echo "\n\t\tonmouseout='parent.parent.hideHighlight()'";
				echo ">\n\t\t".$sname." (".$nr.")\n\t</a>";
			} else { // keine Koord. gefunden
				echo $sname." (".$nr.")"; // nur Anzeige, ohne Link
			}
			switch ($gfilter) {
				case 0: // Kein Filter
					echo " in ".$gemname;
					break;
				case 2: // Liste
					echo " in ".$gemname;
					break;
			}			
			echo "\n</div>";
		}
		echo "\n<hr>";

		// Body
		// Haeuser zum Strassenschluessel
		$sql="SELECT min(replace(h.hausnummer,' ','')) AS hsnr, ";
		if($epsg == "25832") { // Transform nicht notwendig
			$sql.="avg (st_x(p.wkb_geometry)) AS x, ";
			$sql.="avg (st_y(p.wkb_geometry)) AS y ";		
		} else {  
			$sql.="avg (st_x(st_transform(p.wkb_geometry,".$epsg."))) AS x, ";
			$sql.="avg (st_y(st_transform(p.wkb_geometry,".$epsg."))) AS y ";		
		}
		$sql.="FROM ap_pto p JOIN ax_lagebezeichnungmithausnummer h ON h.gml_id=ANY(p.dientzurdarstellungvon) 
		WHERE p.art='HNR' AND h.land= $1 AND h.regierungsbezirk= $2 AND h.kreis= $3 AND h.gemeinde= $4 AND h.lage= $5 
		AND p.endet IS NULL AND h.endet IS NULL
		GROUP BY lpad(split_part(hausnummer,' ',1), 4, '0'), split_part(hausnummer,' ',2) 
		ORDER BY lpad(split_part(hausnummer,' ',1), 4, '0'), split_part(hausnummer,' ',2);";
		// Problem: mehrere Koordinaten für verschiedene Maßstäbe der Kartendarstellung
		// Diese sollten nicht mehrfach gelistet werden. Für Positionierung "irgendeine" nehmen.
		// Lösung: über GROUP BY in SQL. Alternative Lösungen wären: 
		//  1. Gruppenwechsel bei Abarbeitung des Result
		//  2. Subquery mit LIMIT 1 statt JOIN
		//  3. Geometrie aus Gebäude-Mittelpunkt statt aus Präsentationsobjekt der Hausnummer

 		$v=array($land,$regb,$kreis,$gemnd,$nr);
		$resh=pg_prepare("", $sql);
		$resh=pg_execute("", $v);
		if (!$resh) {
			echo "\n<p class='err'>Fehler bei H&auml;user zum Stra&szlig;enschl&uuml;ssel</p>";
			if ($debug > 2) {echo "<p class='dbg'>SQL='".$sql."'<br>Array=".$v."</p>";}
			return;
		}

		$cnt=0;
		$count=0;
		echo "\n<table>";
		while($rowh = pg_fetch_array($resh)) { // mehrere HsNr je Zeile
			if($count == 0){echo "\n<tr>";}	
			$hsnr=$rowh["hsnr"];
			$x=$rowh["x"];
			$y=$rowh["y"];
			echo "\n\t<td class='hsnr'>";
				echo "<a href='";
					echo "javascript:";
					echo "transtitle(\"auf Haus ".$hsnr." positioniert\"); ";
					echo "parent.parent.parent.mb_repaintScale(\"mapframe1\",".$x.",".$y.",".$scalehs."); ";
					echo "parent.parent.showHighlight(".$x.",".$y.");' ";
				echo "onmouseover='parent.parent.showHighlight(".$x.",".$y.")' ";
				echo "onmouseout='parent.parent.hideHighlight()";
				echo "'>".$hsnr."</a>";
			echo "</td>";
			$cnt++;
			$count++;
			if($count == 6) {
				echo "\n</tr>";
				$count = 0;
			}
		}
		if($count > 0) {echo "\n</tr>";}
		echo "\n</table>";
		if ($cnt > 1) {
			echo "\n<p class='anz'>".$cnt." Hausnummern</p>";
		}
	} else {
		echo "\n<p class='anz'>Keine Stra&szlig;e</p>";
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
}

// +++	Zerlegung Eingabe aus "Balken" von Buchauskunft "Lage":
//		Numerisch: Gem-Str-Haus-lfd

if ($str_schl != "") { // aus Link
	$trans="Hausnummern zur Stra&szlig;e";
	suchHausZurStr(true);
} elseif($street != "") { // Eingabe in Form
	if (trim($street, "*,0..9") == "") { // Zahl, ggf. mit Wildcard
		$trans="Suche Stra&szlig;enschl&uuml;ssel \"".$street."\"";
		suchStrKey();
	} else {
		$trans="Suche Stra&szlig;enname \"".$street."\"";
		suchStrName();
	}
	if(isset($str_schl)) { // Eindeutiges Ergebnis
		$trans="1 Stra&szlig;e gefunden, Hausnummern";
		suchHausZurStr(false);
	}
}
// Titel im Kopf anzeigen
echo "
<script type='text/javascript'>
	transtitle ('".$trans."') ; 
</script>";

?>

</body>
</html>
