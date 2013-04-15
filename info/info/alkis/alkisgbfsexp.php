<?php
/*	Modul alkisfsexp.php
	CSV-Export von Flurstücksdaten zu einem Grundbuch-Blatt
	2012-07-24 krz f.j.
	2013-04-08  deprecated "import_request_variables" ersetzt
	
++++ IN ARBEIT ++++   Zunächst Kopie von alkisgbexp.php

	Es wird die gml_id eines Bestandes übergeben (analog alkisgbexp.php).
	Dazu alle darauf gebuchten FS ermitteln.
	Dazu dann alle FS-DFaten ausgeben (analog alkisfsexp.php).	

*/

//import_request_variables("G"); // php 5.3 deprecated, php 5.4 entfernt
$cntget = extract($_GET); // gmlid

header('Content-type: application/octet-stream');
header('Content-Disposition: attachment; filename="alkis_grundbuch_'.$gmlid.'.csv"');

require_once("alkis_conf_location.php");

// Datenbank-Verbindung
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) {exit("Fehler beim Verbinden der DB");}
pg_set_client_encoding($con, LATIN1); 

// Brundbuch-Blatt
$sql ="SELECT g.buchungsblattnummermitbuchstabenerweiterung AS nr, g.blattart, "; // GB-Blatt
$sql.=" b.bezirk, b.bezeichnung AS beznam, "; // Bezirk
$sql.=" a.land, a.bezeichnung "; // Amtsgericht
$sql.="FROM ax_buchungsblatt g ";
$sql.="LEFT JOIN ax_buchungsblattbezirk b ON g.land=b.land AND g.bezirk=b.bezirk ";  // BBZ
$sql.="LEFT JOIN ax_dienststelle a ON b.land = a.land AND b.stelle = a.stelle ";
$sql.="WHERE g.gml_id= $1 AND a.stellenart=1000;"; // Amtsgericht
$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);
if (!$res) {exit("Fehler bei Grundbuchdaten");}
if ($row = pg_fetch_array($res)) {
	$agland=$row["land"]; // Amtsgericht	
	$agbez=$row["bezeichnung"];
	$bezirk=$row["bezirk"]; // Bezirk
	$beznam=$row["beznam"];
	$blattnr=$row["nr"]; // Blatt
	$blattart=$row["blattart"];
} else {
	exit("Kein Treffer fuer gml_id=".$gmlid);
}
//if ($blattkey == 5000) { // fikt. Blatt Keine Angaben zum Eigentum

// CSV-Ausgabe
echo "Land;Amtsgericht;Bezirk;Bezirksname;Blatt;Blattart";
echo "\n".$agland.";".$agbez.";".$bezirk.";".$beznam.";".$blattnr.";".$blattart;
exit();
?>