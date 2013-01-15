<?php
/*	Modul alkisfsgbexp.php
	CSV-Export von Grundbuch-Daten zum Flurstueck
	Es wird die GML-ID eines Flurstücks übergeben (analog alkisfsexp.php)
	Dazu sollen alle verbundenen Grundbücher gesucht werden.
	Zu diesen sollen die Eigentümerdaten exportiert werden (analog alkisbestexp.php)

+++ IN ARBEIT ++++  Zunächst Kopie von alkisfsexp.php
	
	2012-07-24 krz f.j.
*/
import_request_variables("G"); // gmlid
header('Content-type: application/octet-stream');
header('Content-Disposition: attachment; filename="alkis_flurstueck_'.$gmlid.'.csv"');
require_once("alkis_conf_location.php");

// CSV-Ausgabe
echo "Gemarkung;FS-Kennzeichen;Flaeche;Adressen;Buchungsart;GB-Bezirk;GB-Blatt;LfdNr;Anteil";

// Datenbank-Verbindung
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) {exit("Fehler beim Verbinden der DB");}
pg_set_client_encoding($con, LATIN1); 

// Flurstücksdaten
$sql ="SELECT f.flurnummer, f.zaehler, f.nenner, f.gemeinde, f.amtlicheflaeche, g.gemarkungsnummer, g.bezeichnung ";
$sql.="FROM ax_flurstueck f LEFT JOIN ax_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer ";
$sql.="WHERE f.gml_id= $1";
$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);
if (!$res) {exit("Fehler bei Flurstuecksdaten");}
if ($row = pg_fetch_array($res)) {
	$gemkname=$row["bezeichnung"];
	$gmkgnr=$row["gemarkungsnummer"];
	$flurnummer=$row["flurnummer"];
	$flstnummer=$row["zaehler"];
	$nenner=$row["nenner"];
	if ($nenner > 0) {$flstnummer.="/".$nenner;} // BruchNr
	$fsbuchflae=$row["amtlicheflaeche"]; // amtliche Fl. aus DB-Feld
} else {exit ("Kein Treffer fuer gml_id=".$gmlid);}
pg_free_result($res);

// Lagebezeichnung Mit Hausnummer
// Mehrere Lagebezeichnungen kommen in eine Zelle der Tabelle
$sql ="SELECT DISTINCT s.bezeichnung, l.hausnummer FROM alkis_beziehungen v ";
$sql.="JOIN ax_lagebezeichnungmithausnummer l ON v.beziehung_zu=l.gml_id ";
$sql.="JOIN ax_lagebezeichnungkatalogeintrag s ON l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND l.lage = s.lage ";
$sql.="WHERE v.beziehung_von= $1 AND v.beziehungsart='weistAuf' ";
$sql.="ORDER BY s.bezeichnung, l.hausnummer;";
$v=array($gmlid);
$res=pg_prepare("", $sql);
$res=pg_execute("", $v);
if (!$res) {
	echo "Fehler bei Lagebezeichnung mit Hausnummer\n";
	echo $sql."\n";
}
$j=0;
$lagehsnr=""; // mehrere ggf. in ein Feld
while($row = pg_fetch_array($res)) {
	if ($j > 0) {$lagehsnr.=", ";}
	$sneu=$row["bezeichnung"];
	if ($sneu == $salt) {
		$lagehsnr.=$row["hausnummer"];
	} else {
		$lagehsnr.=$sneu." ".$row["hausnummer"];
	}
	$salt=$sneu;
	$j++;
}
pg_free_result($res);

$fskennz='"'.$gmkgnr.'-'.$flurnummer.'-'.$flstnummer.'"'; // in "" einschließen, Excel macht sonst Datum daraus
$csvfs="\n".$gemkname.";".$fskennz.";".$fsbuchflae.";".$lagehsnr.";"; // Buchung anhängen
// Ende linearer Teil (eine Zeile je Flurstück))

// BUCHUNGSSTELLEN zum FS
//  jede Buchung zu einem FS erzeugt eine neue FS-Zeile !!
$sql ="SELECT s.gml_id, s.buchungsart, s.laufendenummer as lfd, s.zaehler, s.nenner, b.bezeichner AS bart ";
$sql.="FROM alkis_beziehungen v "; // Bez Flurst.- Stelle.
$sql.="JOIN ax_buchungsstelle s ON v.beziehung_zu=s.gml_id ";
$sql.="LEFT JOIN ax_buchungsstelle_buchungsart b ON s.buchungsart = b.wert ";
$sql.="WHERE v.beziehung_von= $1 AND v.beziehungsart= $2 ORDER BY s.laufendenummer;";
$v = array($gmlid,'istGebucht');
$ress = pg_prepare("", $sql);
$ress = pg_execute("", $v);
if (!$ress) {echo "\nKeine Buchungsstelle";}
$bs=0; // Z.Buchungsstelle
while($rows = pg_fetch_array($ress)) {
	$gmls=$rows["gml_id"]; // gml b-Stelle	
	$lfd=$rows["lfd"]; // BVNR

	// BUCHUNGSBLATT zur Buchungsstelle
	$sql ="SELECT b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung as blatt, b.blattart, z.bezeichnung ";
	$sql.="FROM alkis_beziehungen v "; // Bez. Stelle - Blatt
	$sql.="JOIN ax_buchungsblatt b ON v.beziehung_zu=b.gml_id ";
	$sql.="LEFT JOIN ax_buchungsblattbezirk z ON z.land=b.land AND z.bezirk=b.bezirk ";
	$sql.="WHERE v.beziehung_von= $1 AND v.beziehungsart= $2 ";
	$sql.="ORDER BY b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung ;";
	$v=array($gmls,'istBestandteilVon');
	$resg=pg_prepare("", $sql);
	$resg=pg_execute("", $v);
	if (!$resg) {echo "\nKein Buchungsblatt";}
	$bl=0;
	while($rowg = pg_fetch_array($resg)) {
		echo $csvfs.$rows["bart"].";".$rowg["bezeichnung"].";".$rowg["blatt"].";".$rows["lfd"].";";
		if ($rowg["zaehler"] == "") {echo "1";}
		else {
			$zah=str_replace(".",",",$rowg["zaehler"]);
			$nen=str_replace(".",",",$rowg["nenner"]);		
			echo "=".$zah."/".$nen;
		}	
		$bl++;
	}
	pg_free_result($resg);
	if ($bl == 0) {echo "\nKein Buchungsblatt gefunden.";}

	// RECHT Stelle an Stelle - Kommentare siehe alkisfsnw.php
	$sql ="SELECT s.laufendenummer as lfd, s.zaehler, s.nenner, ";
	$sql.=" b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung as blatt, z.bezeichnung, a.bezeichner AS bart ";
	$sql.="FROM alkis_beziehungen an ";
	$sql.="JOIN ax_buchungsstelle s ON an.beziehung_von = s.gml_id ";
	$sql.="JOIN alkis_beziehungen v ON s.gml_id = v.beziehung_von ";
	$sql.="JOIN ax_buchungsblatt  b ON v.beziehung_zu = b.gml_id ";
	$sql.="LEFT JOIN ax_buchungsblattbezirk z ON z.land = b.land AND z.bezirk = b.bezirk ";
	$sql.="LEFT JOIN ax_buchungsstelle_buchungsart a ON s.buchungsart = a.wert ";
	$sql.="WHERE an.beziehung_zu = $1 ";
	$sql.="AND an.beziehungsart = 'an' ";
	$sql.="AND v.beziehungsart = 'istBestandteilVon' ";
	$sql.="ORDER BY b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung;";
	$v = array($gmls);
	$resan = pg_prepare("", $sql);
	$resan = pg_execute("", $v);
	if (!$resan) {echo "\nFehler bei weiteren Buchungsstellen";}
	while($rowan = pg_fetch_array($resan)) {
		echo $csvfs.$rowan["bart"].";".$rowan["bezeichnung"].";".$rowan["blatt"].";".$rowan["lfd"].";";
		if ($rowan["zaehler"] == "") {echo "1";}
		else {
			$zah=str_replace(".",",",$rowan["zaehler"]);
			$nen=str_replace(".",",",$rowan["nenner"]);		
			echo "=".$zah."/".$nen;
		}
	}
	pg_free_result($resan);
	$bs++;
}
if ($bs == 0) {echo "\nKeine Buchungstelle gefunden.";}
pg_close($con);
exit(0);
?>