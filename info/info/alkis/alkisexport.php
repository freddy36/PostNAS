<?php
/*	Modul alkisexport.php
	CSV-Export von ALKIS-Daten zu einem Flurstueck, Grundbuch oder Eigentümer.
	Es wird eine GML-ID übergeben.
	Es wird ein gespeicherter View verwendet, der nach der gml_id gefiltert wird. 
	Der View verkettet Flurstueck - Buchungsstelle - Grundbuch - Eigentuemer
	Die Lagebezeichnung des Flurstücks wird in ein Feld komprimiert.
	Parameter: gkz=mandant&gmlid=DE...&tabtyp=flurstueck/grundbuch/person

	2014-01-17 krz f.j.
*/

function lage_zum_fs($gmlid) {
	// Zu einem Flurstück die Lagebezeichnungen (mit Hausnummer) so aufbereiten, 
	// dass ggf. mehrere Lagebezeichnungen in eine Zelle der Tabelle passen.
	$sql ="SELECT DISTINCT s.bezeichnung, l.hausnummer FROM alkis_beziehungen v ";
	$sql.="JOIN ax_lagebezeichnungmithausnummer l ON v.beziehung_zu=l.gml_id ";
	$sql.="JOIN ax_lagebezeichnungkatalogeintrag s ON l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND l.lage = s.lage ";
	$sql.="WHERE v.beziehung_von= $1 AND v.beziehungsart='weistAuf' ";
	$sql.="ORDER BY s.bezeichnung, l.hausnummer;";
	$v=array($gmlid);
	$res=pg_prepare("", $sql);
	$res=pg_execute("", $v);
	if (!$res) {
		echo "Fehler bei Lagebezeichnung \n";
		echo $sql."\n";
	}
	$j=0;
	$lagehsnr="";
	while($row = pg_fetch_array($res)) {
		if ($j > 0) {$lagehsnr.=", ";}
		$sneu=$row["bezeichnung"];
		if ($sneu == $salt) { // gleiche Str.
			$lagehsnr.=$row["hausnummer"]; // HsNr dran haengen
		} else { // Name UND HsNr dranhaengen
			$lagehsnr.=$sneu." ".$row["hausnummer"];
		}
		$salt=$sneu; // Name f. naechste Runde
		$j++;
	}
	pg_free_result($res);
	return($lagehsnr);
}

$cntget = extract($_GET); // Parameter aus URL lesen
header('Content-type: application/octet-stream');
header('Content-Disposition: attachment; filename="alkis_'.$tabtyp.'_'.$gmlid.'.csv"');
require_once("alkis_conf_location.php");

// CSV-Ausgabe: Kopfzeile mit Feldnamen
echo "FS-Kennzeichen;Gemarkung;Flur;Flurstueck;Flaeche;Adressen;GB-Bezirk;GB-Blatt;LfdNrName;Anteil_am_FS;Buchungsart;Namensnummer;AnteilDerPerson;Beschreibung;Name;Vorname;GebDatum";

// Datenbank-Verbindung
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) {
	exit("Fehler beim Verbinden der DB");
}
pg_set_client_encoding($con, LATIN1); // Für Excel kein UTF8 ausgeben

// Der Parameter "Tabellentyp" bestimmt den Namen des Filter-Feldes aus dem View
switch ($tabtyp) { // zulaessige Erte fuer &tabtyp=
	case 'flurstueck': $filter = "fsgml"; break;
	case 'grundbuch':  $filter = "gbgml"; break;
	case 'person':     $filter = "psgml"; break;
	default: exit("Falscher Parameter '".$tabtyp."'"); break;
}

// Daten aus gespeichertem View
$sql ="SELECT * FROM exp_csv WHERE ".$filter." = $1 ";
$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);
if (!$res) {
	exit("Fehler bei Datenbankabfrage");
}
$i=0;
$fsalt='';

// Datenfelder auslesen
while($row = pg_fetch_array($res)) {

	// Flurstueck
	$fsgml=$row["fsgml"];
	$fs_kennz=$row["fs_kennz"];
	$gmkgnr=$row["gemarkungsnummer"];
//	$gemkname=$row["bezeichnung"]; 
	$flurnummer=$row["flurnummer"];
	$flstnummer=$row["zaehler"];
	$nenner=$row["nenner"];
	if ($nenner > 0) {$flstnummer.="/".$nenner;} // BruchNr
	$fs_flae=$row["fs_flae"]; // amtliche Fl. aus DB-Feld

	// Grundbuch (Blatt)
	$gb_bezirk=$row["gb_bezirk"];
	$gb_blatt=$row["gb_blatt"];

	// Buchungsstelle (Grundstueck)
	$bu_lfd=$row["bu_lfd"];
	$bu_ant=$row["bu_ant"];
	$bu_art=$row["bu_art"];
	
	//	Namensnummer
	$nam_lfd=$row["nam_lfd"];
	$nam_ant=$row["nam_ant"];
	$nam_bes=$row["nam_bes"];
	
	// Person
	$naname=$row["nachnameoderfirma"];
	$vorname=$row["vorname"];
	$gebdat=$row["geburtsdatum"];

	// Adresse der Person
	//	-- fehlt noch

	// Adressen zum FS
	if($fsgml != $fsalt) { // bei geändertem Kennz.
		$lage=lage_zum_fs($fsgml); // die Lage neu ermitteln
		$fsalt=$fsgml;
	}

	// Den Ausgabe-Satz montieren aus Flurstücks-, Grundbuch- und Namens-Teil
	$fsteil=$fs_kennz.";".$gmkgnr.";".$flurnummer.";".$flstnummer.";".$fs_flae.";".$lage.";";
	$gbteil=$gb_bezirk.";".$gb_blatt.";".$bu_lfd.";".$bu_ant.";".$bu_art.";";
	$namteil=$nam_lfd.";".$nam_ant.";".$nam_bes.";".$naname.";".$vorname.";".$gebdat;

	// Ausgabe in CSV-Datei
	echo "\n".$fsteil.$gbteil.$namteil;
	$i++;
}
pg_free_result($res);
if ($i == 0) {exit ("Kein Treffer fuer gml_id=".$gmlid);}
pg_close($con);
exit(0);
?>