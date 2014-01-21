<?php
/*	Modul alkisexport.php
	CSV-Export von ALKIS-Daten zu einem Flurstueck, Grundbuch oder Eigentümer.
	Es wird eine GML-ID übergeben.
	Es wird ein gespeicherter View verwendet, der nach der gml_id gefiltert wird. 
	Der View verkettet Flurstueck - Buchungsstelle - Grundbuch - Eigentuemer
	Die Lagebezeichnung des Flurstücks wird in ein Feld komprimiert.
	Parameter: gkz=mandant&gmlid=DE...&tabtyp=flurstueck/grundbuch/person

	2014-01-17 krz f.j.
	2014-01-20 weitere Spalten und verbesserte Formatierung
	2014-01-21 Der View liefert "Rechtsgemeinschaft" nun als Feld in allen Personen-Sätzen 
			eines GB-Blattes statt als eigenen "Satz ohne Person".
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
include("alkisfkt.php");

// CSV-Ausgabe: Kopfzeile mit Feldnamen
echo "FS-Kennzeichen;GmkgNr;Gemarkung;Flur;Flurstueck;Flaeche;Adressen;GB-BezNr;GB-Bezirk;GB-Blatt;BVNR;Anteil_am_FS;Buchungsart;Namensnummer;AnteilDerPerson;RechtsGemeinschaft;Person;GebDatum;Anschrift;Anteil(berechnet)";

// Datenbank-Verbindung
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) {
	exit("Fehler beim Verbinden der DB");
}
pg_set_client_encoding($con, LATIN1); // Für Excel kein UTF8 ausgeben

// Der Parameter "Tabellentyp" bestimmt den Namen des Filter-Feldes aus dem View "exp_csv".
switch ($tabtyp) { // zulaessige Werte fuer &tabtyp=
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
if (!$res) {exit("Fehler bei Datenbankabfrage");}
$i=1; // Kopfzeile zählt mit
$fsalt='';

// Datenfelder auslesen
while($row = pg_fetch_array($res)) {
	$i++; // Zeile der Tabelle
	$rechnen=true; // Formel in letzte Spalte?

	// Flurstueck
	$fsgml=$row["fsgml"];
	$fs_kennz=$row["fs_kennz"]; // Rechts Trim "_" ?
	$gmkgnr=$row["gemarkungsnummer"];
	$gemkname=$row["gemarkung"]; 
	$flurnummer=$row["flurnummer"];
	$flstnummer=$row["zaehler"];
	$nenner=$row["nenner"];
	if ($nenner > 0) {$flstnummer.="/".$nenner;} // BruchNr
	$fs_flae=$row["fs_flae"]; // amtliche Fl. aus DB-Feld

	// Grundbuch (Blatt)
	$gb_bezirk=$row["gb_bezirk"]; // Nummer des Bezirks
    $gb_beznam=$row["beznam"];    // Name des Bezirks
	$gb_blatt=$row["gb_blatt"];

	// Buchungsstelle (Grundstueck)
	$bu_lfd=$row["bu_lfd"]; // BVNR
	$bu_ant=$row["bu_ant"]; // '=zaehler/nenner' oder NULL
	$bu_key=$row["buchungsart"]; // Schlüssel
	$bu_art=$row["bu_art"]; // entschlüsselt (Umlaute in ANSI!)
	if($bu_ant == '') { // Keine Bruch-Zahl
		$bu_ant = '1'; // "voller Anteil" (Faktor 1)
	} else {
		$bu_ant=str_replace(".", ",", $bu_ant); // Dezimalkomma statt -punkt.		
	}

	// Namensnummer
	$nam_lfd="'".kurz_namnr($row["nam_lfd"])."'"; // In Hochkomma, sonst wie Datum dargestellt.
	$nam_ant=$row["nam_ant"];
	$nam_adr=$row["nam_adr"]; // Art der Rechtsgemeischaft (Schlüssel)
	if ($nam_adr == '') {     // keine Rechtsgemeinsachft
		if ($nam_ant == '') { // und kein Bruch-Anteil
			$nam_ant=1; // dann ganzer Anteil
		}
	} else {
		$rechnen=false; // bei Rechtsgemeinschaft manuell interpretieren
		if ($nam_adr == 9999) { // sonstiges
			$rechtsg=$row["nam_bes"]; // Beschrieb der Rechtsgemeinschaft
		} else {
			$rechtsg=rechtsgemeinschaft($nam_adr); // Entschlüsseln
		}
	}

	// Person
	$nana=$row["nachnameoderfirma"];
	if ($nana == "") {
		$name="";
	} else {
		$name=anrede($row["anrede"]);
		$namteil=$row["namensbestandteil"];
		if ($namteil != "") { // von und zu
			$name.=" ".$namteil;
		} 
		$name.=" ".$nana;
		$vnam=$row["vorname"];
		if ($vnam != "") { // keine Firma
			$name.=", ".$vnam;
		}
	}
	$gebdat=$row["geburtsdatum"];

	// Adresse der Person (Eigentuemer))
	$ort=$row["ort"];
	if ($ort == "") {
		$adresse="";
	} else { 
		$adresse=$row["strasse"]." ".$row["hausnummer"].", ".$row["plz"]." ".$ort;
		$land=$row["land"]; // nur andere Länder anzeigen
		if (($land != "DEUTSCHLAND") and ($land != "")) {
			$adresse.=" (".$land.")";
		}
	}

	// Adressen (Lage) zum FS
	if($fsgml != $fsalt) { // nur bei geändertem Kennz.
		$lage=lage_zum_fs($fsgml); // die Lage neu ermitteln
		$fsalt=$fsgml;
	}

	// Den Ausgabe-Satz montieren aus Flurstücks-, Grundbuch- und Namens-Teil
	//      A             B           C             D               E               F            G
	$fsteil=$fs_kennz.";".$gmkgnr.";".$gemkname.";".$flurnummer.";".$flstnummer.";".$fs_flae.";".$lage.";";
	//      H              I              J             K           L           M
	$gbteil=$gb_bezirk.";".$gb_beznam.";".$gb_blatt.";".$bu_lfd.";".$bu_ant.";".$bu_art.";";
	//       N            O            P            Q         R           S
	$namteil=$nam_lfd.";".$nam_ant.";".$rechtsg.";".$name.";".$gebdat.";".$adresse;

	// Anteile "GB am FS" und "Pers am GB" verrechnen
	if ($rechnen) { // beide Anteile verwertbar
		$formelteil=";=L".$i."*O".$i; // Spalte T
	} else {
		$formelteil=';';
	}

	// Ausgabe in CSV-Datei
	echo "\n".$fsteil.$gbteil.$namteil.$formelteil;
}
pg_free_result($res);
if ($i == 1) {exit ("Kein Treffer fuer gml_id=".$gmlid);} // nur Kopfzeile
pg_close($con);
exit(0);
?>