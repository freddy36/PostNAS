<?php
/* Version vom 
	2013-04-26	NEU Function "GB_Buchung_FS" ausgelagert.
					Code aus aus _eig soll auch in _grd verwendet werden
		Dazu Var-Namen harmonisieren:
		_eig    _grd     NEU
		$gb     $gblatt  $blattgml
*/

function GB_Buchung_FS ($linelimit) {
// Zu einem Grundbuch-Blatt (identifiziert über seine gml_id):
//  - suchen der Buchungen (Gruppenwechsel) 
//  - und Flurstücke (Links)
// Wird verwendet in den Modulen _eig und _grd.
// 2013-04-26	Noch kein Blättern und noch keine Berücksichtigung des Filters auf "Gemeinde"
// ToDo: Zähler für Blatt, Buchung, FS - am Ende ausgeben

	global $gkz, $gemeinde, $blattgml, $scalefs, $auskpath, $epsg, $gfilter, $debug;

	// SQL-Bausteine vorbereiten
	$sql1 ="SELECT s1.laufendenummer AS lfd, f.gml_id, f.flurnummer, f.zaehler, f.nenner, f.gemeinde, ";
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

	// Zwischen-JOIN (zusätzlich nur bei zweiter Abfrage)
	$sqlz ="JOIN alkis_beziehungen vss ON vss.beziehung_von = s1.gml_id ";
	$sqlz.="JOIN ax_buchungsstelle s2 ON vss.beziehung_zu = s2.gml_id ";

	$sqla1 ="JOIN alkis_beziehungen vfb ON s1.gml_id = vfb.beziehung_zu ";
	$sqla2 ="JOIN alkis_beziehungen vfb ON s2.gml_id = vfb.beziehung_zu ";

	$sql2.="JOIN ax_flurstueck f ON vfb.beziehung_von = f.gml_id ";
   $sql2.="JOIN pp_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkung ";
	$sql2.="WHERE vbg.beziehung_zu= $1 AND vbg.beziehungsart='istBestandteilVon' AND vfb.beziehungsart='istGebucht' ";
	switch ($gfilter) {
		case 1: // Einzelwert
			$sql2.="AND g.gemeinde=".$gemeinde." "; break;
		case 2: // Liste
			$sql2.="AND g.gemeinde in (".$gemeinde.") "; break;
	}
	$sql2.="ORDER BY s1.laufendenummer, f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner LIMIT $2 ;";

	// Blatt <vbg/istBestandteilVon<  Buchungsstelle <vfb/istGebucht< Flurstck.
	$sql=$sql1.$sqla1.$sql2; // Direkte Buchungen

	$v=array($blattgml, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Buchung und Flurst&uuml;ck.</p>";
		if ($debug >= 3) {echo "\n<p class='err'>".$sql."</p>";}
		return;
	}
	$zfs1=0;
	$gwbv="";
	while($row = pg_fetch_array($res)) {	

		// Gruppenwechsel auf Ebene Buchungs-Stelle (BVNR)
		$bvnr=$row["lfd"];
		if ($gwbv != $bvnr) {
			if ($bvnr == 0) {
				$bvnra = "-";
			} else {
				$bvnra = str_pad($bvnr, 4, "0", STR_PAD_LEFT); // auf 4 Stellen
			}
			$gwbv = $bvnr; // Steuerg GW BVNR
			echo "\n<div class='gs' title='Grundst&uuml;ck'>";
			echo "<img class='nwlink' src='ico/Grundstueck.ico' width='16' height='16' alt='GS'> ";
			echo "Buchung ".$bvnra."</div>";
		}

		$fs_gml=$row["gml_id"];
		$gmkg=$row["gemarkungsname"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // BruchNr
		$x=$row["x"];
		$y=$row["y"];
		echo "\n<div class='fs'>";
			echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$fs_gml."\")'>";
				echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Link.ico' width='16' height='16' alt='FS'>";
			echo "\n\t</a> ";	
			echo "\n\t".$gmkg." <a title='Flurst&uuml;ck positionieren 1:".$scalefs."' href='";
					echo "javascript:";
					echo "transtitle(\"auf Flurst&uuml;ck positioniert\"); ";
					echo "parent.parent.parent.mb_repaintScale(\"mapframe1\",".$x.",".$y.",".$scalefs."); ";
					echo "parent.parent.showHighlight(".$x.",".$y.");' ";
				echo "onmouseover='parent.parent.showHighlight(".$x.",".$y.")' ";
				echo "onmouseout='parent.parent.hideHighlight()'>";
			echo " Flur ".$flur." ".$fskenn."</a>";
		echo "\n</div>";
		$zfs1++;
	}
	if($zfs1 == 0) { 
		// "nichts gefunden" erst melden, wenn auch Teil 2 (Rechte an) nichts findet
	} elseif($zfs1 >= $linelimit) {
		echo "\n<p class='anz'>... und weitere</p>";
	// +++  Blättern einführen?
	} elseif($zfs1 > 1) { // ab 2
		echo "\n<p class='anz'>".$zfs1." Flurst&uuml;cke zum Grundbuch</p>";
	}

	if($zfs1 > 1) { // wenn's was zu trennen gibt
		echo "<hr>"; // Trennen
	}

	// Zweite Abfrage (Variante) aus den Bausteinen zusammen bauen
	// buchungsStelle2 < an < buchungsStelle1
	$sql=$sql1.$sqlz.$sqla2.$sql2; // Rechte an

	$v=array($blattgml, $linelimit);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "\n<p class='err'>Fehler bei Recht an Buchung.</p>";
		if ($debug >= 3) {echo "\n<p class='dbg'>".$sql."</p>";}
		return;
	}
	$zfs2=0;
	$gwbv="";
	while($row = pg_fetch_array($res)) {	

		// Gruppenwechsel auf Ebene Buchungs-Stelle (BVNR)
		$bvnr=$row["lfd"];
		if ($gwbv != $bvnr) {
			if ($bvnr == 0) {
				$bvnra = "-";
			} else {
				$bvnra = str_pad($bvnr, 4, "0", STR_PAD_LEFT); // auf 4 Stellen
			}
			$gwbv = $bvnr; // Steuerg GW BVNR
			echo "\n<div class='gs' title='Grundst&uuml;ck'>";
			echo "<img class='nwlink' src='ico/Grundstueck.ico' width='16' height='16' alt='GS'> ";
			echo "Buchung ".$bvnra."</div>";
		}

		$fs_gml=$row["gml_id"];
		$gmkg=$row["gemarkungsname"];
		$flur=$row["flurnummer"];
		$fskenn=$row["zaehler"];
		if ($row["nenner"] != "") {$fskenn.="/".$row["nenner"];} // Bruchnummer
		$x=$row["x"];
		$y=$row["y"];
		echo "\n<div class='fs'>";
			echo "\n\t<a title='Nachweis' href='javascript:imFenster(\"".$auskpath."alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$fs_gml."\")'>";
				echo "\n\t\t<img class='nwlink' src='ico/Flurstueck_Link.ico' width='16' height='16' alt='FS'>";
			echo "\n\t</a> ";	
			echo "\n\tRecht an ".$gmkg." <a title='Flurst&uuml;ck positionieren 1:".$scalefs."' href='";
					echo "javascript:";
					echo "transtitle(\"auf Flurst&uuml;ck positioniert\"); ";
					echo "parent.parent.parent.mb_repaintScale(\"mapframe1\",".$x.",".$y.",".$scalefs."); ";
					echo "parent.parent.showHighlight(".$x.",".$y.");' ";
				echo "onmouseover='parent.parent.showHighlight(".$x.",".$y.")' ";
				echo "onmouseout='parent.parent.hideHighlight()'>";
			echo " Flur ".$flur." ".$fskenn."</a>";
		echo "\n</div>";
		$zfs2++;
	}
	if($zfs1 + $zfs2 == 0) { 
		echo "\n<p class='anz'>Kein Flurst&uuml;ck im berechtigten Bereich.</p>";
	} elseif($zfs >= $linelimit) {
		echo "\n<p class='anz'>... und weitere</p>";
	// +++ Blättern einführen?
	} elseif($zfs2 > 1) { // keine Meldung "nichts gefunden - Rechte an" wenn Treffer in Teil 1
		echo "\n<p class='anz'>".$zfs2." Rechte an Flurst.</p>";
	}
	return;
}

?>
