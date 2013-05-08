<?php
/* Version vom 
	2013-05-07  Strukturierung des Programms, redundanten Code in Functions zusammen fassen
	2013-05-08  Hervorhebung aktuelles Objekt, in Arbeit ...
*/

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
		echo "\n\t\t<img class='nwlink' src='ico/Gericht.ico' width='16' height='16' alt='Amtsgericht'> ";
		echo "AG <a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;ag=".$anr."'>";		
		echo $agd."</a> (".$anr.")";
	echo "\n</div>";
	return;
}

function zeile_gbbez ($gnam, $zgbbez, $aktuell) {	// Zeile Grundbuch - B e z i r k
	global $gkz, $gemeinde, $epsg, $auskpath;
	$gnamd=htmlentities($gnam, ENT_QUOTES, "UTF-8");
	if ($aktuell) {$cls=" aktuell";}	
	echo "\n<div class='gk".$cls."' title='GB-Bezirk'>";
		echo "\n\t\t<img class='nwlink' src='ico/GB-Bezirk.ico' width='16' height='16' alt='Bez.'> ";
		echo "<a href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;gbkennz=".$zgbbez."'>";		
		echo "Bezirk ".$gnamd."</a> (".suchfeld($zgbbez).")";			
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
	if ($blattgml == "") { // Link zum Nachweis nur wenn GML bekannt
		echo "\n\t<img class='nwlink' src='ico/GBBlatt_link.ico' width='16' height='16' alt='Blatt'>";
	} else {
		echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$blattgml."\")'>";
			echo "\n\t\t<img class='nwlink' src='ico/GBBlatt_link.ico' width='16' height='16' alt='Blatt'>";
		echo "\n\t</a> ";
	}
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
	echo "\n\t<img class='nwlink' src='ico/Grundstueck.ico' width='16' height='16' alt='GS'> ".$re;
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

function zeile_flurstueck ($fs_gml, $fskenn, $x, $y, $gmkg, $flur, $aktuell) {
	// Zeile mit Icon (Link zum Buch-Nachweis) und Text (Link zum Positionieren)
	global $gkz, $gemeinde, $epsg, $auskpath, $scalefs;
	if ($aktuell) {$cls=" aktuell";}
	echo "\n<div class='fs".$cls."'>";
	echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$fs_gml."\")'>";
		echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Link.ico' width='16' height='16' alt='FS'>";
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
	// Zeile  P e r s o n   (oder Firma)
	$nnam=htmlentities($nachname, ENT_QUOTES, "UTF-8");
	$namlnk=urlencode($nachname);
	$vnam=htmlentities($vorname, ENT_QUOTES, "UTF-8");
	// Link zur Auskunft Person ++ Icon differenzieren? Firma/Person

// 2013-05-08 DIV statt br
echo "<div class='pe'>
	<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisnamstruk.php?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;gmlid=".$gml."\")'>
		<img class='nwlink' src='ico/Eigentuemer.ico' width='16' height='16' alt='EIG'>
	</a> 		
	<a title='Person' href='".$_SERVER['SCRIPT_NAME']."?gkz=".$gkz."&amp;gemeinde=".$gemeinde."&amp;epsg=".$epsg."&amp;person=".$persongml."&amp;name=".$namlnk."'>".$nnam.", ".$vnam."</a>
</div>";
return;
}

function GB_Buchung_FS ($linelimit, $blattgbkenn) {
// Zu einem Grundbuch-Blatt (identifiziert über seine gml_id) suchen der 
// Buchungen (Gruppenwechsel) und Flurstücke (Links)
	global $gemeinde, $blattgml, $epsg, $gfilter, $debug;

	// SQL-Bausteine vorbereiten
	// SQL vorne gleich
	$sql1 ="SELECT s1.laufendenummer AS lfd, s1.gml_id AS bsgml, f.gml_id, f.flurnummer, f.zaehler, f.nenner, f.gemeinde, ";
	if($epsg == "25832") { // Transform nicht notwendig
		$sql1.="st_x(st_centroid(f.wkb_geometry)) AS x, ";
		$sql1.="st_y(st_centroid(f.wkb_geometry)) AS y, ";
	} else {  
		$sql1.="st_x(st_transform(st_centroid(f.wkb_geometry), ".$epsg.")) AS x, ";
		$sql1.="st_y(st_transform(st_centroid(f.wkb_geometry), ".$epsg.")) AS y, ";			
	}
	$sql1.="g.gemarkung, g.gemarkungsname ";
	$sql1.="FROM alkis_beziehungen vbg ";
	$sql1.="JOIN ax_buchungsstelle s1 ON vbg.beziehung_von = s1.gml_id "; 

	// Zwischen-JOIN verschieden
	$sqlz1 ="JOIN alkis_beziehungen vfb ON s1.gml_id = vfb.beziehung_zu ";
	
	$sqlz2 ="JOIN alkis_beziehungen vss ON vss.beziehung_von = s1.gml_id ";
	$sqlz2.="JOIN ax_buchungsstelle s2 ON vss.beziehung_zu = s2.gml_id ";
	$sqlz2.="JOIN alkis_beziehungen vfb ON s2.gml_id = vfb.beziehung_zu ";

	// SQL hinten gleich
	$sql2 ="JOIN ax_flurstueck f ON vfb.beziehung_von = f.gml_id ";
	$sql2.="JOIN pp_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkung ";
	$sql2.="WHERE vbg.beziehung_zu= $1 AND vbg.beziehungsart='istBestandteilVon' AND vfb.beziehungsart='istGebucht' ";
	switch ($gfilter) {
		case 1: // Einzelwert
			$sql2.="AND g.gemeinde=".$gemeinde." "; break;
		case 2: // Liste
			$sql2.="AND g.gemeinde in (".$gemeinde.") "; break;
	}
	$sql2.="ORDER BY cast(s1.laufendenummer AS integer), f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner LIMIT $2 ;";

	// Abfrage:  d i r e k t e  B u c h u n g e n
	// Blatt <vbg/istBestandteilVon<  Buchungsstelle <vfb/istGebucht< Flurstück
	#$sql=$sql1.$sqlz1.$sql2; // Direkte Buchungen

	$v=array($blattgml, $linelimit);
	$res=pg_prepare("", $sql1.$sqlz1.$sql2);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Buchung und Flurst&uuml;ck.</p>";
		#if ($debug >= 3) {echo "\n<p class='err'>".$sql1.$sqlz1.$sql2."</p>";}
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
	#if($zfs1 == 0) { // "nichts gefunden" erst melden, wenn auch Teil 2 (Rechte an) nichts findet
	#} else
	if($zfs1 >= $linelimit) {
		echo "\n<p class='anz'>... und weitere</p>"; // +++  Blättern einführen?
	} elseif($zfs1 > 1) { // ab 2
		echo "\n<p class='anz'>".$zfs1." Flurst&uuml;cke zum Grundbuch</p>";
	}
	if($zfs1 > 0) {echo "<hr>";} // Trennen

	// Abfrage:  R e c h t e  a n   /   d i e n e n d e  B u c h u n g e n
	$v=array($blattgml, $linelimit);
	$res=pg_prepare("", $sql1.$sqlz2.$sql2);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Recht an Buchung.</p>";
		#if ($debug >= 3) {echo "\n<p class='dbg'>".$sql1.$sqlz2.$sql2."</p>";}
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
	} elseif($zfs >= $linelimit) {
		echo "\n<p class='anz'>... und weitere</p>"; // Blättern einführen?
	} elseif($zfs2 > 1) { // keine Meldung "nichts gefunden - Rechte an" wenn Treffer in Teil 1
		echo "\n<p class='anz'>".$zfs2." Rechte an Flurst.</p>";
	}
	return;
}

?>
