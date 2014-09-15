<?php
/* Version vom 
	2013-05-07  Strukturierung des Programms, redundanten Code in Functions zusammen fassen
	2013-05-14  Hervorhebung aktuelles Objekt, Title auch auf Icon, IE zeigt sonst alt= als Title dar.
	2013-05-15  Function verlegt
	2014-02-06  Korrektur zeile_person
	2014-09-03  PostNAS 0.8: ohne Tab. "alkis_beziehungen", mehr "endet IS NULL", Spalten varchar statt integer
	2014-09-15  Bei Relationen den Timestamp abschneiden, mehr "endet IS NULL"
*/

function is_ne_zahl($wert) {
	// Prüft, ob ein Wert ausschließlich aus den Zahlen 0 bis 9 besteht
	if (trim($wert, "0..9") == "") {return true;} else {return false;}
}

function ZerlegungGBKennz($gbkennz) {
	// Das eingegebene Grundbuch-Kennzeichen auseinander nehmen (gggg-999999z-BVNR)
	// Return: 9=Fehler, 0=Listen alle Bezirke 1=Such Bezirk-Name
	//  2=Such Bezirk-Nummer, 3=Such Blatt, 4=Such Buchung BVNR
	global $zgbbez, $zblatt, $zblattn, $zblattz, $zbvnr;
	$arr=explode("-", $gbkennz, 3);
	$zgbbez=trim($arr[0]);
	$zblatt=trim($arr[1]);
	$zbvnr=trim($arr[2]);
	if ($zgbbez == "") { // keine Eingabe
		return 0; // Amtsgerichte oder Bezirke listen
	} elseif ( ! is_ne_zahl($zgbbez)) { // Alphabetische Eingabe
		return 1; // Such Bezirk-NAME
	} elseif ($zblatt == "") {
		return 2; // Such Bezirk-NUMMER
	} else { // Format von BlattNr pruefen
	//'19'      linksbündig
	//'000019 ' gefüllt 6 + blank
	//'000019A' .. mit Zusatzbuchstabe
	//'0300001' gefüllt 7, bei Blattart 5000 "fiktives Blatt"
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

function suchfeld($suchstring) {	// Suchstring Ausgeben UND das Eingabeformular damit belegen
	$out="<a title='Dies als Suchbegriff setzen' href='javascript:formular_belegung(\"".$suchstring."-\")'>".$suchstring."</a>";
	return $out;
}

// function Typ "zeile_**"  = Ausgabe eines Knotens
// - Icon,  ggf. mit Link zur Buchauskunft
// - Zeile, ggf. mit Link zur weiteren Auflösung untergeordneter Knoten
// Hierin die Encodierung für url und HTML.

function zeile_ag ($ag, $anr, $aktuell) {	// Zeile  A m t s g e r i c h t
	global $gkz, $gemeinde, $epsg, $auskpath;
	if ($ag == "") {
		$agd=$anr; // Ersatz: Nummer statt Name. Besser: Name immer füllen
	} else {
		$agd=htmlentities($ag, ENT_QUOTES, "UTF-8");
	}
	if ($aktuell) {$cls=" aktuell";}
	echo "\n<div class='ga".$cls."' title='Amtsgericht'>";
		echo "\n\t\t<img class='nwlink' src='ico/Gericht.ico' width='16' height='16' alt='AG' title='Amtsgericht'> ";
		echo "AG <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;ag=".$anr."'>";		
		echo $agd."</a> (".$anr.")";
	echo "\n</div>";
	return;
}

function zeile_gbbez ($gnam, $zgbbez, $aktuell) {	// Zeile Grundbuch - B e z i r k
	// Parameter: aktuell = Bool für farbliche Markierung der Zeile als aktuell angeklicktes Obj.
	global $gkz, $gemeinde, $epsg, $person;
	$gnamd=htmlentities($gnam, ENT_QUOTES, "UTF-8");
	if ($aktuell) {$cls=" aktuell";}	
	echo "\n<div class='gk".$cls."' title='GB-Bezirk'>";
	echo "\n\t\t<img class='nwlink' src='ico/GB-Bezirk.ico' width='16' height='16' alt='Bez.' title='GB-Bezirk'> ";
	echo "<a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;gbkennz=".$zgbbez;
	echo "&amp;gbbeznam=".urlencode($gnam);
	if ($person != "") { // Eigentümer-Suche
		echo "&amp;person=".$person."'>";
		echo "Bezirk ".$gnamd."</a> (".$zgbbez.")";		
	} else {  // Grundbuch-Suche
		echo "'>";
		echo "Bezirk ".$gnamd."</a> (".suchfeld($zgbbez).")";		
	}
	echo "\n</div>";
	return;
}

function zeile_blatt ($bezirk, $beznam, $blattgml, $blatt, $dienend, $person, $aktuell) {
	global $gkz, $gemeinde, $epsg, $auskpath;
	// Zeile Grundbuch - B l a t t
	$blattd=ltrim($blatt, "0"); // Display-Version ohne führende Nullen
	if ( $dienend) {$dientxt="dienendes ";}
	$blattlnk=urlencode($blatt); // trailing Blank
	if ($beznam != "") {$nam = $beznam." ";}
	if ($aktuell) {$cls=" aktuell";}	

	echo "\n<div class='gb".$cls."' title='".$dientxt."GB-Blatt'>";

	// Icon / Nachweis
	if ($blattgml == "") { // Link zum Nachweis nur wenn GML bekannt
		echo "\n\t<img class='nwlink' src='ico/GBBlatt_link.ico' width='16' height='16' alt='Blatt' title='".$dientxt."GB-Blatt'>";
	} else {
		echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$blattgml."\")'>";
			echo "\n\t\t<img class='nwlink' src='ico/GBBlatt_link.ico' width='16' height='16' alt='Blatt' title='Nachweis'>";
		echo "\n\t</a> ";
	}

	// Text, Self-Link
	echo $nam." <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg;
	echo "&amp;blattgml=".$blattgml."&amp;gbkennz=".$bezirk."-".$blattlnk;

	echo "&amp;gbbeznam=".urlencode($beznam);

	if ($person != "") {echo "&amp;person=".$person;} // nur für Eigentümer-Suche
	echo "'>Blatt&nbsp;".$blattd."</a>\n</div>";
	return;
}

function zeile_buchung($buchunggml, $bvnr, $blattkennz, $dienend, $aktuell) {
	// Zeile  B u c h u n g s s t e l l e  -  Grundstück ausgeben
	global $gkz, $gemeinde, $epsg, $auskpath;
	if ($bvnr == 0) {
		$bvnra = "-";
	} else {
		$bvnra = str_pad($bvnr, 4, "0", STR_PAD_LEFT); // auf 4 Stellen
	}
	if ($diened) {
		$ti="dienendes&nbsp;";
		$re="Recht an ";
	} else {
		$ti="";
		$re="";
	}
	if ($aktuell) {$cls=" aktuell";}	
	echo "\n<div class='gs".$cls."' title='".$ti."Grundst&uuml;ck'>";
	echo "\n\t<img class='nwlink' src='ico/Grundstueck.ico' width='16' height='16' alt='GS'  title='".$ti."Grundst&uuml;ck'> ".$re;
	if ($blattkennz == "") { // ohne Link
		echo "Buchung ".$bvnra;
	} else {
		$gbkennlnk=urlencode($blattkennz."-".$bvnr); // Trailing Blanks!
		echo "<a href='".$_SERVER['SCRIPT_NAME']. "?gkz=". $gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;buchunggml=".$buchunggml;
		echo "&amp;gbkennz=".$gbkennlnk."'>Buchung ".$bvnra."</a>";
	}
	echo "\n</div>";
	return;
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

function zeile_flurstueck ($fs_gml, $fskenn, $x, $y, $gmkg, $flur, $aktuell) {
	// Zeile mit Icon (Link zum Buch-Nachweis) und Text (Link zum Positionieren)
	global $gkz, $gemeinde, $epsg, $auskpath, $scalefs;

	if ($aktuell) {$cls=" aktuell";}
	echo "\n<div class='fs".$cls."'>";
	echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$fs_gml."\")'>";
		echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Link.ico' width='16' height='16' alt='FS' title='Nachweis'>";
	echo "\n\t</a>\n\t";			

	echo "&nbsp;<a title='Flurst&uuml;ck positionieren 1:".$scalefs."' href='";
	echo "javascript:";
		echo "transtitle(\"auf Flurst&uuml;ck positioniert\"); ";
		echo "parent.parent.parent.mb_repaintScale(\"mapframe1\",".$x.",".$y.",".$scalefs."); ";
		echo "parent.parent.showHighlight(".$x.",".$y.");' ";
	echo "onmouseover='parent.parent.showHighlight(".$x.",".$y.")' ";
	echo "onmouseout='parent.parent.hideHighlight()'>";

	if ($gmkg == "" ) {
		echo "Flst. "; // Im FS-Teil: Gem+Flur als Knoten darüber ($gmkg und $flur leer)
	} else {
		echo $gmkg." "; // Im GB-und Nam-Teil in der Zeile angezeigt
	}
	if ($flur != "" ) {echo $flur."-";}
	echo $fskenn."</a>\n</div>";
	return;
}

function zeile_person ($persongml, $nachname, $vorname) {
	global $gkz, $gemeinde, $epsg, $auskpath;
	// Zeile  P e r s o n (oder Firma)
	$nnam=htmlentities($nachname, ENT_QUOTES, "UTF-8");
	$namlnk=urlencode($nachname);
	$vnam=htmlentities($vorname, ENT_QUOTES, "UTF-8");
	// Link zur Auskunft Person ++ Icon differenzieren nach Eigentuemerart?

echo "<div class='pe'>
	<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisnamstruk.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;gmlid=".$persongml."\")'>
		<img class='nwlink' src='ico/Eigentuemer.ico' width='16' height='16' alt='EIG' title='Nachweis'>
	</a> 		
	<a title='Person' href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;person=".$persongml."&amp;name=".$namlnk."'>".$nnam.", ".$vnam."</a>
</div>";
return;
}

function GB_Buchung_FS ($linelimit, $blattgbkenn) {
	// Zu einem Grundbuch-Blatt (identifiziert über seine gml_id) suchen der 
	// Buchungen (Gruppenwechsel) und Flurstücke (Links)
	global $gemeinde, $blattgml, $epsg, $gfilter, $debug;

	// SQL-Bausteine
	// vorne gleich
	$sql1 ="SELECT s1.laufendenummer AS lfd, s1.gml_id AS bsgml, f.gml_id, f.flurnummer, f.zaehler, f.nenner, f.gemeinde, ";
	if($epsg == "25832") { // Transform nicht notwendig
		$sql1.="st_x(st_centroid(f.wkb_geometry)) AS x, ";
		$sql1.="st_y(st_centroid(f.wkb_geometry)) AS y, ";
	} else {  
		$sql1.="st_x(st_transform(st_centroid(f.wkb_geometry), ".$epsg.")) AS x, ";
		$sql1.="st_y(st_transform(st_centroid(f.wkb_geometry), ".$epsg.")) AS y, ";			
	}
	$sql1.="g.gemarkung, g.gemarkungsname FROM ax_buchungsstelle s1 "; 

	// zwischen, Variante 1.
    $sqlz1="JOIN ax_flurstueck f ON f.istgebucht=substring(s1.gml_id,1,16) ";

	// zwischen, Variante 2. Nur an oder "an" und "zu"?
	$sqlz2 ="JOIN ax_buchungsstelle s2 ON substring(s2.gml_id,1,16)=ANY(s1.an) 
	JOIN ax_flurstueck f ON f.istgebucht=substring(s2.gml_id,1,16) ";

	// hinten gleich
	$sql2.="JOIN pp_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkung 
	WHERE s1.istbestandteilvon = $1 AND f.endet IS NULL AND s1.endet IS NULL ";
	switch ($gfilter) {
		case 1: // Einzelwert
			$sql2.="AND g.gemeinde='".$gemeinde."' "; break;
		case 2: // Liste
			$sql2.="AND g.gemeinde in ('".str_replace(",", "','", $gemeinde)."') "; break;
	}

	// WHERE-Zusatz bei 2
	$sqlw2=" AND s2.endet IS NULL ";

	$sqlord="ORDER BY cast(s1.laufendenummer AS integer), f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner LIMIT $2 ;";

	// d i r e k t e  B u c h u n g e n
	// Blatt <istBestandteilVon<  Buchungsstelle <istGebucht< Flurstück
	$v=array(substr($blattgml,0,16), $linelimit); // Rel. istBestandteilVon nur 16 Stellen
	$res=pg_prepare("", $sql1.$sqlz1.$sql2.$sqlord);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Buchung und Flurst&uuml;ck.</p>";
		if ($debug >= 3) {echo "\n<p class='err'>SQL='".$sql1.$sqlz1.$sql2.$sqlord."'<br>$1 = '".substr($blattgml,0,16)."'</p>";}
		return;
	}
	$zfs1=0;
	$gwbv="";
	while($row = pg_fetch_array($res)) {	
		$bvnr=$row["lfd"];
		$bsgml=$row["bsgml"]; // Buchungsstelle gml_id
		if ($gwbv != $bvnr) { // Gruppierung Buchungs-Stelle (BVNR)
			$gwbv = $bvnr;
			zeile_buchung($bsgml, $bvnr, $blattgbkenn, false, false);
		}
		$fs_gml=$row["gml_id"];
		$gmkg=$row["gemarkungsname"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // BruchNr
		$x=$row["x"];
		$y=$row["y"];
		zeile_flurstueck ($fs_gml, $fskenn, $x, $y, $gmkg, $flur, false);
		$zfs1++;
	}
	// "nichts gefunden" erst melden, wenn auch Teil 2 (Rechte an) nichts findet
	if($zfs1 > 1) { // ab 2
		echo "\n<p class='anz'>".$zfs1." Flurst&uuml;cke zum Grundbuch";
		if($zfs1 >= $linelimit) {
			echo "... und weitere"; //++ Blättern einführen?
		}
		echo "</p>";
	}
	if($zfs1 > 0) {echo "<hr>";} // Trennen

	// Rechte "an"  (dienende  Buchungen)
	$v=array($blattgml, $linelimit);
	$res=pg_prepare("", $sql1.$sqlz2.$sql2.$sqlw2.$sqlord);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Recht an Buchung.</p>";
		#if ($debug >= 3) {echo "\n<p class='dbg'>".$sql1.$sqlz2.$sql2.$sqlw2.$sqlord."</p>";}
		return;
	}
	$zfs2=0;
	$gwbv="";
	while($row = pg_fetch_array($res)) {	
		$bvnr=$row["lfd"];
		$bsgml=$row["bsgml"]; // Buchungsstelle gml_id
		if ($gwbv != $bvnr) { // Gruppierung Buchung (BVNR) - dienend
			$gwbv = $bvnr;
			zeile_buchung($bsgml, $bvnr, $blattgbkenn, true, false);
		}
		$fs_gml=$row["gml_id"];
		$gmkg=$row["gemarkungsname"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // Bruchnummer
		zeile_flurstueck ($fs_gml, $fskenn, $row["x"], $row["y"], $gmkg, $flur, false);
		$zfs2++;
	}
	// Foot
	if($zfs1 + $zfs2 == 0) { 
		echo "\n<p class='anz'>Kein Flurst&uuml;ck im berechtigten Bereich.</p>";
	} elseif($zfs2 > 1) { // keine Meldung "nichts gefunden - Rechte an" wenn Treffer in Teil 1
		echo "\n<p class='anz'>".$zfs2." Rechte an Flurst.";
		if($zfs2 >= $linelimit) {
			echo "... und weitere"; // Blättern einführen?
		}
		echo "</p>";
	}
	return;
}

?>
