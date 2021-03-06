<?php
/*	Modul: alkisfsnw.php

	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Flurstücksnachweis fuer ein Flurstückskennzeichen aus ALKIS PostNAS

	Version:
	2011-11-16 Neuer Style class='dbg', Link Historie
	2011-11-17 Parameter der Functions geändert
	2011-11-30 import_request_variables, $dbvers PostNAS 0.5 entfernt
	2011-12-01 Summe der Abschnittsflächen (NUA) an amtl. Buchfläche des FS angleichen 
	2011-12-16 Zeilenumbruch in Nutzungsart, Spaltenbreite Link
	2012-07-24 Export als CSV, pg_free_result(), pg_close()
	2012-11-27 split deprecated, besser: explode
	2013-01-17 FS-Kennzeichen (ALB-Format) als Parameter statt gmlid möglich
	2013-04-08 deprecated "import_request_variables" ersetzt
	2013-04-11 ID-Links (im Testmodus) auch an Lagebezeichnung (mit/ohne HsNr) und an Nutzungs-Abschnitt
	2013-06-24 Unna: Bodenneuordnung, strittige Grenze
	2013-06-27 Bodenneuordnung u. stritt.Gr. in Tabellen-Struktur, Link zur Bodenerneuerung (neues Modul)
	2014-01-30 Korrektur Nutzungsart (z.B. Friedhof mit class=funktion=0 hatte Anzeige "unbekannt")
	2014-02-06 Korrektur
	2014-09-09 PostNAS 0.8: ohne Tab. "alkis_beziehungen", mehr "endet IS NULL", Spalten varchar statt integer
	2014-09-15 Bei Relationen den Timestamp abschneiden
	2014-09-23 Korrektur "IS NULL"
	2014-09-30 Umbenennung Schlüsseltabellen (Prefix), Rückbau substring(gml_id)
	2014-12-16 Zum Grundbuch einen Hinweis anzeigen, wenn es dazu berechtigte Buchungen gibt.

	ToDo:
	- Bodenschätzung anzeigen
	- Entschlüsseln "Bahnkategorie" bei Bahnverkehr, "Oberflächenmaterial" bei Unland
	  Dazu evtl. diese Felder ins Classfld verschieben (Meta-Tabellen!)
*/
session_start();
$cntget = extract($_GET);
require_once("alkis_conf_location.php");
if ($auth == "mapbender") {require_once($mapbender);}
include("alkisfkt.php");
if ($id == "j") {$idanzeige=true;} else {$idanzeige=false;}
$keys = isset($_GET["showkey"]) ? $_GET["showkey"] : "n";
if ($keys == "j") {$showkey=true;} else {$showkey=false;}
?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta name="author" content="b600352" >
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ALKIS Flurst&uuml;cksnachweis</title>
	<link rel="stylesheet" type="text/css" href="alkisauszug.css">
	<link rel="shortcut icon" type="image/x-icon" href="ico/Flurstueck.ico">
	<script type="text/javascript">
		function ALKISexport() {
			window.open(<?php echo "'alkisexport.php?gkz=".$gkz."&tabtyp=flurstueck&gmlid=".$gmlid."'"; ?>);
		}
	</script>
	<style type='text/css' media='print'>
		.noprint {visibility: hidden;}
	</style>
</head>
<body>

<?php

function ber_bs_hinw($gmls) {
	// Unter einem Grundbuch-Link den Hinweis auf "berechtigte Buchungssstellen" anzeigen
	// In FS-Nachweis wird nur der Eigentümer des direkt gebuchten Grundstücks angezeigt.
	// Den Erbbauberechtigten sieht man erst in der Grundbuch-Auskunft.
	global $debug, $showkey;

	// Buchungstelle dien. >an> Buchungstelle herr.
	$sql ="SELECT count(sh.gml_id) AS anz, sh.buchungsart, a.bezeichner
	FROM ax_buchungsstelle sd JOIN ax_buchungsstelle sh ON sd.gml_id=ANY(sh.an) 
	LEFT JOIN v_bs_buchungsart a ON sh.buchungsart=a.wert 
	WHERE sd.gml_id= $1 AND sh.endet IS NULL AND sd.endet IS NULL GROUP BY sh.buchungsart, a.bezeichner;";

	$v = array($gmls); // id dienende BS
	$resan = pg_prepare("", $sql);
	$resan = pg_execute("", $v);
	if (!$resan) {
		echo "\n<p class='err'>Fehler bei 'berechtigte Buchungsstellen'.</p>\n";
		//if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmls."'</p>";}
	}
	$an=0;
	while($rowan = pg_fetch_array($resan)) {
		$an++;
		if ($an == 1) {echo "\n\t<br>\n\t<p class='nwlink' title='Andere Grundst&uuml;cke mit Rechten an diesem.'>Berechtigte Buchungen:<br><b>";}
		if ($an > 1) {echo",<br>";} // kann es gemischste Buchungsarten geben?
		echo $rowan["anz"]." ".htmlentities($rowan["bezeichner"], ENT_QUOTES, "UTF-8");
		if ($showkey) {
			echo " <span class='key'>(".$rowan["buchungsart"].")</span>";
		}
	}
	if ($an == 0) {
		echo "<br><p class='nwlink' title='Kein anderes Grundst&uuml;ck hat ein Recht an diesem.'>Keine berechtigte Buchung</p>";
	} else {
		echo "</b></p>";
	}
	pg_free_result($resan);
}

// S t a r t
$con = pg_connect("host=".$dbhost." port=" .$dbport." dbname=".$dbname." user=".$dbuser." password=".$dbpass);
if (!$con) echo "<p class='err'>Fehler beim Verbinden der DB</p>\n";

// Ein (ALB- ?) Flurstücks-Kennzeichen wurde alternativ zur gml_id übermittelt
if ($gmlid == '' and $fskennz != '') {
	// Übergabe Format z.B. "llgggg-fff-nnnn/zz.nn" oder "gggg-ff-nnn/zz"
	$arr=explode("-", $fskennz, 4);
	$zgemkg=trim($arr[0]);
	if (strlen($zgemkg) == 20 and $arr[1] == "") { // Oh, ist wohl schon das Datenbank-Feldformat 
		$fskzdb=$zgemkg;
	} else { // Nö, ist wohl eher ALB-Format
		// Das Kennzeichen auseinander nehmen. 
		if (strlen($zgemkg) == 6) {
			$land=substr($zgemkg, 0, 2);
			$zgemkg=substr($zgemkg, 2, 4);
		} else { // kein schöner Land ..
			$land='05'; // NRW, ToDo: Default-Land aus config
		}
		$zflur=str_pad($arr[1], 3 , "0", STR_PAD_LEFT); // Flur-Nr
		$zfsnr=trim($arr[2]); // Flurstücke-Nr
		$zn=explode("/", $zfsnr, 2); // Bruch?
		$zzaehler=str_pad(trim($zn[0]), 5 , "0", STR_PAD_LEFT);	
		$znenner=trim($zn[1]);
		if (trim($znenner, " 0.") == "") { // kein Bruch oder nur Nullen
			$znenner="____"; // in DB-Spalte mit Tiefstrich aufgefüllt
		} else {
			$zn=explode(".", $znenner, 2); // .00 wegwerfen
			$znenner=str_pad($zn[0], 4 , "0", STR_PAD_LEFT);
		}
		// nun die Teile stellengerecht wieder zusammen setzen		
		$fskzdb=$land.$zgemkg.$zflur.$zzaehler.$znenner.'__'; // FS-Kennz. Format Datenbank
	}
	// Feld flurstueckskennzeichen ist in DB indiziert
	// Format z.B.'052647002001910013__' oder '05264700200012______'
	$sql ="SELECT gml_id FROM ax_flurstueck WHERE flurstueckskennzeichen= $1 AND endet IS NULL ;";

	$v = array($fskzdb);
	$res = pg_prepare("", $sql);
	$res = pg_execute("", $v);
	if ($row = pg_fetch_array($res)) {
		$gmlid=$row["gml_id"];
	} else {
		echo "<p class='err'>Fehler! Kein Treffer f&uuml;r Flurst&uuml;ckskennzeichen='".$fskennz."' (".$fskzdb.")</p>";
	}
	pg_free_result($res);
}

// F L U R S T U E C K
$sql ="SELECT f.name, f.flurnummer, f.zaehler, f.nenner, f.regierungsbezirk, f.kreis, f.gemeinde, f.amtlicheflaeche, st_area(f.wkb_geometry) AS fsgeomflae, f.zeitpunktderentstehung, g.gemarkungsnummer, g.bezeichnung 
FROM ax_flurstueck f LEFT JOIN ax_gemarkung g ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer 
WHERE f.gml_id= $1 AND f.endet IS NULL;";

$v = array($gmlid); // mit gml_id suchen
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);

if (!$res) {
	echo "\n<p class='err'>Fehler bei Flurstuecksdaten</p>\n";
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}
if ($row = pg_fetch_array($res)) {
	$gemkname=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
	$gmkgnr=$row["gemarkungsnummer"];
	$bezirk=$row["regierungsbezirk"];
	$kreis=$row["kreis"];
	$gemeinde=$row["gemeinde"];
	$flurnummer=$row["flurnummer"];
	$flstnummer=$row["zaehler"];
	$nenner=$row["nenner"];
	if ($nenner > 0) {$flstnummer.="/".$nenner;} // BruchNr
	$fsbuchflae=$row["amtlicheflaeche"]; // amtliche Fl. aus DB-Feld
	$fsgeomflae=$row["fsgeomflae"]; // aus Geometrie ermittelte Fläche
	$fsbuchflaed=number_format($fsbuchflae,0,",",".") . " m&#178;"; // Display-Format dazu
	$fsgeomflaed=number_format($fsgeomflae,0,",",".") . " m&#178;";
	$entsteh=$row["zeitpunktderentstehung"];
	$name=$row["name"]; // Fortfuehrungsnummer(n)
	$arrn = explode(",", trim($name, "{}") ); // PHP-Array
} else {
	echo "<p class='err'>Fehler! Kein Treffer f&uuml;r Flurst&uuml;ck mit gml_id=".$gmlid."</p>";
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
	echo "</body></html>";
	return;
}
pg_free_result($res);
// Balken
if ($eig=="j") {
	echo "<p class='fsei'>ALKIS Flurst&uuml;ck ".$gmkgnr."-".$flurnummer."-".$flstnummer."&nbsp;</p>\n";
	echo "\n<h2><img src='ico/Flurstueck.ico' width='16' height='16' alt=''> Flurst&uuml;ck mit Eigent&uuml;mer</h2>\n";
} else {
	echo "<p class='fskennz'>ALKIS Flurst&uuml;ck ".$gmkgnr."-".$flurnummer."-".$flstnummer."&nbsp;</p>\n";
	echo "\n<h2><img src='ico/Flurstueck.ico' width='16' height='16' alt=''> Flurst&uuml;ck</h2>\n";
}
echo "\n<table class='outer'>\n<tr>\n\t<td>"; // linke Seite
	// darin Tabelle Kennzeichen
	echo "\n\t<table class='kennzfs' title='Flurst&uuml;ckskennzeichen'>\n\t<tr>";
		echo "\n\t\t<td class='head'>Gmkg</td>\n\t\t<td class='head'>Flur</td>\n\t\t<td class='head'>Flurst-Nr.</td>\n\t</tr>";
		echo "\n\t<tr>\n\t\t<td title='Gemarkung'>";
		if ($showkey) {
			echo "<span class='key'>".$gmkgnr."</span><br>";
		}
		echo $gemkname."&nbsp;</td>";
		echo "\n\t\t<td title='Flurnummer'>".$flurnummer."</td>";
		echo "\n\t\t<td title='Flurst&uuml;cksnummer (Z&auml;hler / Nenner)'><span class='wichtig'>".$flstnummer."</span></td>\n\t</tr>";
	echo "\n\t</table>";
echo "\n\t</td>\n\t<td>"; // rechte Seite
	// FS-Daten 2 Spalten
	echo "\n\t<table class='fsd'>";
		echo "\n\t<tr>\n\t\t<td>Entstehung</td>";
		echo "\n\t\t<td>".$entsteh."</td>\n\t</tr>";
		echo "\n\t<tr>";
			echo "\n\t\t<td>letz. Fortf</td>";
			echo "\n\t\t<td title='Jahrgang / Fortf&uuml;hrungsnummer - Fortf&uuml;hrungsart'>";
				foreach($arrn AS $val) { // Zeile f. jedes Element des Array
					echo trim($val, '"')."<br>";
				}
			echo "</td>";
		echo "\n\t</tr>";

	echo "\n\t</table>";
	if ($idanzeige) {linkgml($gkz, $gmlid, "Flurst&uuml;ck", "ax_flurstueck"); }
echo "\n\t</td>\n</tr>\n</table>";
//	echo "\n<tr>\n\t<td>Finanzamt</td>\n\t<td>".$finanzamt." ".$finame  . "</td>\n</tr>";
// Ende Seitenkopf

echo "\n<hr>";
echo "\n<p class='nwlink noprint'>weitere Auskunft:</p>"; // oben rechts von der Tabelle
echo "\n<table class='fs'>";

// ** G e b i e t s z u g e h o e r i g k e i t **
// eine Tabellenzeile mit der Gebietszugehoerigkeit eines Flurstuecks wird ausgegeben
// Schluessel "land" wird nicht verwendet, gibt es Bestaende wo das nicht einheitlich ist?
echo "\n<tr>\n\t<td class='ll'><img title='Im Gebiet von' src='ico/Gemeinde.ico' width='16' height='16' alt=''> Gebiet:</td>";

// G e m e i n d e
$sql="SELECT bezeichnung FROM ax_gemeinde WHERE regierungsbezirk= $1 AND kreis= $2 AND gemeinde= $3 AND endet IS NULL;"; 

$v = array($bezirk,$kreis,$gemeinde);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);
if (!$res) {
	echo "\n<p class='err'>Fehler bei Gemeinde</p>\n";
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."</p>";}
}
$row = pg_fetch_array($res);
$gnam = htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
echo "\n\t<td class='lr'>Gemeinde</td><td class='lr'>";
if ($showkey) {
	echo "<span class='key'>(".$gemeinde.")</span> ";
}
echo $gnam."</td><td width='80'>";  // Mindest-Breite der Spalte fuer die Links 
	// Link zur Flurstücks-Historie (passt nicht ganz in die Zeile "Gemeinde", aber gut unter "weitere Auskunft")
	echo "\n<p class='nwlink noprint'>";
		echo "\n\t<a href='alkisfshist.php?gkz=".$gkz."&amp;gmlid=".$gmlid;
				if ($idanzeige) {echo "&amp;id=j";}
				if ($showkey)   {echo "&amp;showkey=j";}
			echo "' title='Vorg&auml;nger-Flurst&uuml;cke'>Historie ";
			echo "<img src='ico/Flurstueck_Historisch.ico' width='16' height='16' alt=''>";
		echo "</a>";
	echo "\n</p>";
echo "</td></tr>";
pg_free_result($res);

// K r e i s
$sql="SELECT bezeichnung FROM ax_kreisregion WHERE regierungsbezirk= $1 AND kreis= $2 AND endet IS NULL;"; 
$v = array($bezirk,$kreis);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);
if (!$res) {
	echo "\n<p class='err'>Fehler bei Kreis</p>\n";
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."</p>";}
}
$row = pg_fetch_array($res);
$knam = htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
echo "<tr><td>&nbsp;</td><td>Kreis</td><td>";
if ($showkey) {
	echo "<span class='key'>(".$kreis.")</span> ";
}
echo $knam."</td><td>&nbsp;</td></tr>";
pg_free_result($res);

// R e g - B e z
$sql="SELECT bezeichnung FROM ax_regierungsbezirk WHERE regierungsbezirk= $1 AND endet IS NULL;";
$v = array($bezirk);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);
if (!$res) {
	echo "<p class='err'>Fehler bei Regierungsbezirk</p>";
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."</p>";}
}
$row=pg_fetch_array($res);
$bnam=htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8");
echo "<tr><td>&nbsp;</td><td>Regierungsbezirk</td><td>";
if ($showkey) {
	echo "<span class='key'>(".$bezirk.")</span> ";
}
echo $bnam."</td><td>&nbsp;</td></tr>";
pg_free_result($res);
// ENDE G e b i e t s z u g e h o e r i g k e i t

// ** L a g e b e z e i c h n u n g **

// Lagebezeichnung MIT Hausnummer
// ax_flurstueck  >weistAuf>  AX_LagebezeichnungMitHausnummer
$sql="SELECT DISTINCT l.gml_id, l.gemeinde, l.lage, l.hausnummer, s.bezeichnung 
FROM ax_flurstueck f JOIN ax_lagebezeichnungmithausnummer l ON l.gml_id=ANY(f.weistauf)  
JOIN ax_lagebezeichnungkatalogeintrag s ON l.land=s.land AND l.regierungsbezirk=s.regierungsbezirk AND l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND l.lage=s.lage 
WHERE f.gml_id= $1 AND f.endet IS NULL AND l.endet IS NULL AND s.endet IS NULL    
ORDER BY l.gemeinde, l.lage, l.hausnummer;";

$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);

if (!$res) {
	echo "<p class='err'>Fehler bei Lagebezeichnung mit Hausnummer</p>";
	if ($debug > 1) {
		//echo "<p class='dbg'>Fehler:".pg_result_error($res)."</p>";
		echo "<p class='dbg'>Fehler:".pg_last_error()."</p>";
	}
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
} else {
	$j=0;
	while($row = pg_fetch_array($res)) {
		$sname = htmlentities($row["bezeichnung"], ENT_QUOTES, "UTF-8"); // Str.-Name
		echo "\n<tr>\n\t";
			if ($j == 0) {
				echo "<td class='ll'><img src='ico/Lage_mit_Haus.ico' width='16' height='16' alt=''> Adresse:</td>";
			} else {
				echo "<td>&nbsp;</td>";
			}
			echo "\n\t<td>&nbsp;</td>";
			echo "\n\t<td class='lr'>";
			if ($showkey) {
				echo "<span class='key' title='Straßenschl&uuml;ssel'>(".$row["lage"].")</span>&nbsp;";
			}
			echo $sname."&nbsp;".$row["hausnummer"];
			if ($idanzeige) {linkgml($gkz, $row["gml_id"], "Lagebezeichnung mit Hausnummer", "ax_lagebezeichnungmithausnummer");}
			echo "</td>";
			echo "\n\t<td>\n\t\t<p class='nwlink noprint'>";
				echo "\n\t\t\t<a title='Lagebezeichnung mit Hausnummer' href='alkislage.php?gkz=".$gkz."&amp;ltyp=m&amp;gmlid=".$row["gml_id"];
				if ($showkey) {echo "&amp;showkey=j";}
				echo "'>Lage ";
				echo "<img src='ico/Lage_mit_Haus.ico' width='16' height='16' alt=''></a>";
			echo "\n\t\t</p>\n\t</td>";
		echo "\n</tr>";
		$j++;
	}
	pg_free_result($res);
}
// Verbesserung: mehrere HsNr zur gleichen Straße als Liste?

// Lagebezeichnung OHNE Hausnummer  (Gewanne oder nur Strasse)
// ax_flurstueck  >zeigtAuf>  AX_LagebezeichnungOhneHausnummer
$sql ="SELECT l.gml_id, l.unverschluesselt, l.gemeinde, l.lage, s.bezeichnung 
FROM ax_flurstueck f JOIN ax_lagebezeichnungohnehausnummer l ON l.gml_id=ANY(f.zeigtauf) 
LEFT JOIN ax_lagebezeichnungkatalogeintrag s ON l.land=s.land AND l.regierungsbezirk=s.regierungsbezirk AND l.kreis=s.kreis AND l.gemeinde=s.gemeinde AND l.lage=s.lage 
WHERE f.gml_id = $1 AND f.endet IS NULL AND l.endet IS NULL AND s.endet IS NULL;";

$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);
if (!$res) {
	echo "<p class='err'>Fehler bei Lagebezeichnung ohne Hausnummer</p>";
	//if ($debug > 1) {echo "<p class='dbg'>Fehler:".pg_result_error($res)."</p>";}
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}
$j=0;
// Es wird auch eine Zeile ausgegeben, wenn kein Eintrag gefunden!
while($row = pg_fetch_array($res)) {
	$gewann = htmlentities($row["unverschluesselt"], ENT_QUOTES, "UTF-8");
	$skey=$row["lage"]; // Strassenschl.
	$lgml=$row["gml_id"]; // key der Lage
	if (!$gewann == "") {
		echo "\n<tr>";
			echo "\n\t<td class='ll' title='Lagebezeichnung'><img src='ico/Lage_Gewanne.ico' width='16' height='16' alt=''> Gewanne:</td>";
			echo "\n\t<td></td>";
			echo "\n\t<td class='lr'>".$gewann."</td>";
			echo "\n\t<td>\n\t\t<p class='nwlink noprint'>";
				echo "\n\t\t\t<a title='Lagebezeichnung Ohne Hausnummer' href='alkislage.php?gkz=".$gkz."&amp;ltyp=o&amp;gmlid=".$lgml;
				if ($showkey) {echo "&amp;showkey=j";}				
				echo "'>\n\t\t\tLage <img src='ico/Lage_Gewanne.ico' width='16' height='16' alt=''></a>";
			echo "\n\t\t</p>\n\t</td>";
		echo "\n</tr>";
	}
	// Gleicher DB-Eintrag in zwei HTML-Zeilen, besser nur ein Link
	if ($skey > 0) {
		echo "\n<tr>";
			echo "\n\t<td class='ll'><img src='ico/Lage_an_Strasse.ico' width='16' height='16' alt=''> Stra&szlig;e:</td>";
			echo "\n\t<td></td>";
			echo "\n\t<td class='lr'>";
			if ($showkey) {
				echo "<span class='key'>(".$skey.")</span>&nbsp;";
			}
			echo $row["bezeichnung"];
			if ($idanzeige) {linkgml($gkz, $lgml, "Lagebezeichnung o. HsNr.", "ax_lagebezeichnungohnehausnummer");}
			echo "</td>";
			echo "\n\t<td>\n\t\t<p class='nwlink noprint'>";
				echo "\n\t\t\t<a title='Lagebezeichnung Ohne Hausnummer' href='alkislage.php?gkz=".$gkz."&amp;ltyp=o&amp;gmlid=".$lgml;
				if ($showkey) {echo "&amp;showkey=j";}				
				echo "'>\n\t\t\tLage <img src='ico/Lage_an_Strasse.ico' width='16' height='16' alt=''>\n\t\t\t</a>";
			echo "\n\t\t</p>\n\t</td>";
		echo "\n</tr>";
	}
	$j++;
}
pg_free_result($res);
// ENDE  L a g e b e z e i c h n u n g

// ** N U T Z U N G ** Gemeinsame Fläche von NUA und FS
// Tabellenzeilen (3 Spalten) mit tats. Nutzung zu einem FS ausgeben
$sql ="SELECT m.title, m.fldclass, m.fldinfo, n.gml_id, n.nutz_id, n.class, n.info, n.zustand, n.name, n.bezeichnung, m.gruppe, 
st_area(st_intersection(n.wkb_geometry,f.wkb_geometry)) AS schnittflae, c.label, c.blabla 
FROM ax_flurstueck f, nutzung n JOIN nutzung_meta m ON m.nutz_id=n.nutz_id 
LEFT JOIN nutzung_class c ON c.nutz_id=n.nutz_id AND c.class=n.class 
WHERE f.gml_id= $1 AND st_intersects(n.wkb_geometry,f.wkb_geometry) = true 
AND st_area(st_intersection(n.wkb_geometry,f.wkb_geometry)) > 0.05 
AND f.endet IS NULL ORDER BY schnittflae DESC;";

$v = array($gmlid);
$res = pg_prepare("", $sql);
$res = pg_execute("", $v);
if (!$res) {
	echo "<p class='err'>Fehler bei Suche tats. Nutzung</p>\n";
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}
$the_Xfactor=$fsbuchflae / $fsgeomflae; // geom. ermittelte Fläche auf amtl. Buchfläche angleichen
$j=0;
while($row = pg_fetch_array($res)) {
	$grupp=$row["gruppe"]; // 4 Gruppen
	$nutzid=$row["nutz_id"]; // 27 Tabellen, num. Key
	$title=htmlentities($row["title"], ENT_QUOTES, "UTF-8"); // Titel der 27 Tabellen
	$fldclass=$row["fldclass"]; // Name 1. Zusatzfeld
	$fldinfo= $row["fldinfo"];  // Name 2. Zus.
	$gml=$row["gml_id"];
	$class=$row["class"]; // 1. Zusatzfeld verschlüsselt -> nutzung_class
	$info=$row["info"]; // 2. Zus. verschlüsselt (noch keine Info zum entschl.)
	$schnittflae=$row["schnittflae"];
	$label=$row["label"]; // Nutzungsart entschlüsselt
	$zus=$row["zustand"]; // im Bau
	$nam=$row["name"]; // Eigenname
	$bez=$row["bezeichnung"]; // weiterer Name (unverschl.)
	$blabla=htmlentities($row["blabla"], ENT_QUOTES, "UTF-8");
	$label=str_replace("/", "<br>", $label); // Ersetzt "/" durch html-Zeilenwechsel

	echo "\n<tr>\n\t";
		if ($j == 0) {
			echo "<td class='ll' title='Abschnitt der tats&auml;chlichen Nutzung'><img src='ico/Abschnitt.ico' width='16' height='16' alt=''> Nutzung:</td>";
		} else {
			echo "<td>&nbsp;</td>";
		}
		$absflaebuch = $schnittflae * $the_Xfactor; // angleichen geometrisch an amtliche Fläche
		$schnittflae = number_format($schnittflae,1,",",".") . " m&#178;"; // geometrisch
		$absflaebuch = number_format($absflaebuch,0,",",".") . " m&#178;"; // Abschnitt an Buchfläche angeglichen
		echo "\n\t<td class='fla' title='geometrisch berechnet: ".$schnittflae."'>".$absflaebuch."</td>";

		echo "\n\t<td class='lr'>";
			if ($class == 0) {
				if ($showkey) {echo "<span class='key'>(".$nutzid.")</span> ";}
				echo $title; // Name der Tabelle
			} elseif ( ($fldclass == "Funktion" OR $fldclass == "Vegetationsmerkmal") AND $label != "") { // Kurze Anzeige
				if ($showkey) {echo "<span class='key' title='".$fldclass."'>(".$nutzid."-".$class.")</span> ";}
				if ($blabla = "") {
					echo $label;
				} else {
					echo "<span title='".$blabla."'>".$label."</span>";
				}
			} else { // ausfuehrlichere Anzeige
				echo $title; // NUA-Tabelle
				if ($class != "") { // NUA-Schlüssel
					echo ", ".$fldclass.": "; // Feldname
					if ($showkey) {echo "<span class='key' title='".$fldclass."'>(".$nutzid."-".$class.")</span> ";}
					if ($label != "") { // Bedeutung dazu wurde erfasst
						if ($blabla = "") {
							echo $label;
						} else {
							echo "<span title='".$blabla."'>".$label."</span>";
						}
					} else { // muss noch erfasst werden
						echo $class." "; // Schlüssel als Ersatz für Bedeutung
					}
				}
			}

			if ($info != "") { // manchmal ein zweites Zusatzfeld (wie entschlüsseln?)
				echo ", ".$fldinfo."=".$info;
			}
			if ($zus != "") { // Zustand
				echo "\n\t\t<br>";
				if ($showkey) {echo "<span class='key'>(".$zus.")</span> ";}
				echo "<span title='Zustand'>";				
				switch ($zus) {
					case 2100: echo "Außer Betrieb, stillgelegt, verlassen"; break;
					case 4000: echo "Im Bau"; break;
					case 8000: echo "Erweiterung, Neuansiedlung"; break;
					default: echo "Zustand: ".$zus; break;
				}
				echo "</span>";
			}
			if ($nam != "") {echo "<br>Name: ".$nam;}
			if ($bez != "") {echo "<br>Bezeichnung: ".$bez;}
			if ($idanzeige) {linkgml($gkz, $gml, "Nutzungs-Abschnitt", "");}

		echo "</td>";
		echo "\n\t<td>";
			switch ($grupp) { // Icon nach 4 Objektartengruppen
				case "Siedlung":   $ico = "Abschnitt.ico"; break;
				case "Verkehr":	   $ico = "Strassen_Klassifikation.ico"; break;
				case "Vegetation": $ico = "Wald.ico"; break;
				case "Gewässer":   $ico = "Wasser.ico";	break;
				default:	$ico = "Abschnitt.ico";	break;
			}
			// Icon ist auch im Druck sichtbar, class='noprint' ?		
			echo "<p class='nwlink'><img title='".$title."' src='ico/".$ico."' width='16' height='16' alt='NUA'></p>";
		echo "</td>";
	echo "\n</tr>";
	$j++;
}
pg_free_result($res);
// ENDE  N U T Z U N G

echo "\n<tr>"; // Summenzeile
	echo "\n\t<td class='ll' title='amtliche Fl&auml;che (Buchfl&auml;che)'>Fl&auml;che:</td>";
	echo "\n\t<td class='fla sum'>";
	echo "<span title='geometrisch berechnete Fl&auml;che = ".$fsgeomflaed."' class='flae'>".$fsbuchflaed."</span></td>";

	// Flaeche und Link auf Gebäude-Auswertung
	echo "\n\t<td>&nbsp;</td>\n\t<td>";
		echo "\n\t\t<p class='nwlink noprint'>"; // Gebaeude-Verschneidung
			echo "\n\t\t\t<a href='alkisgebaeudenw.php?gkz=".$gkz."&amp;gmlid=".$gmlid;
			if ($idanzeige) {echo "&amp;id=j";}
			if ($showkey) {echo "&amp;showkey=j";}
			echo "' title='Geb&auml;udenachweis'>Geb&auml;ude <img src='ico/Haus.ico' width='16' height='16' alt=''></a>";
		echo "\n\t\t</p>";
	echo "\n\t</td>";
echo "\n</tr>";

// H i n w e i s  auf Bodenneuordnung oder eine strittige Grenze
// b.name, b.artderfestlegung, 

$sql_boden ="SELECT a.wert, a.bezeichner AS art_verf, b.gml_id AS verf_gml, b.bezeichnung AS verf_bez, 
b.name AS verf_name, d.bezeichnung AS stelle_bez, d.stelle AS stelle_key 
FROM ax_bauraumoderbodenordnungsrecht b JOIN v_baurecht_adf a ON a.wert=b.artderfestlegung 
LEFT JOIN ax_dienststelle d ON b.stelle=d.stelle 
WHERE b.endet IS NULL AND d.endet IS NULL  
AND (ST_Within((SELECT wkb_geometry FROM ax_flurstueck WHERE gml_id = $1 AND endet IS NULL ), wkb_geometry) 
 OR ST_Overlaps((SELECT wkb_geometry FROM ax_flurstueck WHERE gml_id = $1 AND endet IS NULL), wkb_geometry))";

pg_prepare($con, "bodeneuordnung", $sql_boden);
$res_bodeneuordnung = pg_execute($con, "bodeneuordnung", array($gmlid));

$sql_str="SELECT gml_id 
FROM ax_besondereflurstuecksgrenze WHERE endet IS NULL AND 1000 = ANY(artderflurstuecksgrenze) 
AND ST_touches((SELECT wkb_geometry FROM ax_flurstueck WHERE gml_id = $1 AND endet IS NULL),wkb_geometry);";

pg_prepare($con, "strittigeGrenze", $sql_str);
$res_strittigeGrenze = pg_execute($con, "strittigeGrenze", array($gmlid));

if (pg_num_rows($res_bodeneuordnung) > 0 OR pg_num_rows($res_strittigeGrenze) > 0) {
	echo "\n<tr>";
	echo "\n\t<td title='Hinweise zum Flurst&uuml;ck'><h6><img src='ico/Hinweis.ico' width='16' height='16' alt=''> ";
	echo "Hinweise:</td></h6>\n\t<td colspan=3>&nbsp;</td>";
	echo "\n</tr>";

	if (pg_num_rows($res_bodeneuordnung) > 0) {

		while ($row = pg_fetch_array($res_bodeneuordnung)) { // 3 Zeilen je Verfahren

			// Zeile 1 - kommt immer, darum hier den Link
			echo "\n<tr title='Bau-, Raum- oder Bodenordnungsrecht'>";
				echo "\n\t<td>Bodenrecht:</td>";
				echo "\n\t<td>Festlegung</td>"; // "Art der Festlegung" zu lang
				echo "\n\t<td>";
					if ($showkey) {echo "<span class='key'>(".$row['wert'].")</span> ";}
					echo $row['art_verf'];
				echo "</td>";
				echo "\n\t<td>";
				// LINK:
				echo "\n\t\t<p class='nwlink noprint'>";
					echo "\n\t\t\t<a href='alkisbaurecht.php?gkz=".$gkz."&amp;gmlid=".$row['verf_gml'];
					if ($idanzeige) {echo "&amp;id=j";}
					if ($showkey) {echo "&amp;showkey=j";}
					echo "' title='Bau-, Raum- oder Bodenordnungsrecht'>Recht <img src='ico/Gericht.ico' width='16' height='16' alt=''></a>";
				echo "\n\t\t</p>";			
				echo "</td>";
			echo "\n</tr>";

			// Zeile 2
			$dstell=$row['stelle_key']; // LEFT JOIN
			if ($dstell != "") { // Kann auch leer sein
				echo "\n<tr title='Flurbereinigungsbeh&ouml;rde'>";
					echo "\n\t<td>&nbsp;</td>";
					echo "\n\t<td>Dienststelle</td>";
					echo "\n\t<td>";
						if ($showkey) {echo "<span class='key'>(".$dstell.")</span> ";}
						echo $row['stelle_bez'];
					echo "</td>";
					echo "\n\t<td>&nbsp;</td>";
				echo "\n</tr>";
			}

			// Zeile 3
			$vbez=$row['verf_bez']; // ist nicht immer gefüllt
			$vnam=$row['verf_name']; // noch seltener
			if ($vbez != "") {
				echo "\n<tr title='Verfahrensbezeichnung'>";
					echo "\n\t<td>&nbsp;</td>\n\t<td>Verfahren</td>";
					echo "\n\t<td>";
						if ($vnam == "") {
							echo $vbez; // nur die Nummer
						} else {	// Name oder beides
							if ($showkey) {echo "<span class='key'>(".$vbez.")</span> ";}
							echo $vnam;
						}
		 			echo "</td>";
					echo "\n\t<td>&nbsp;</td>";
				echo "\n</tr>";
			}
		}
	}

	if (pg_num_rows($res_strittigeGrenze) > 0) { // 1 Zeile
		echo "\n<tr>";
		echo "\n<td>Strittige Grenze:</td>";
		echo "<td colspan=2>Mindestens eine Flurst&uuml;cksgrenze ist als <b>strittig</b> zu bezeichnen. Sie kann nicht festgestellt werden, weil die Beteiligten sich nicht &uuml;ber den Verlauf einigen. Nach sachverst&auml;ndigem Ermessen der Katasterbeh&ouml;rde ist anzunehmen, dass das Liegenschaftskataster nicht die rechtm&auml;&szlig;ige Grenze nachweist.</td>";
		echo "\n<td>&nbsp;</td>";
		echo "\n</tr>";
	}
}

echo "\n</table>";

// G R U N D B U C H
echo "\n<table class='outer'>";
	echo "\n<tr>";
		echo "\n\t<td>";
			echo "\n\t\t<a name='gb'></a>\n\t\t<h3><img src='ico/Grundbuch_zu.ico' width='16' height='16' alt=''> Grundb&uuml;cher</h3>";
		echo "\n\t</td>";
		echo "\n\t<td>";
			echo "\n\t\t<p class='nwlink noprint'>";
				echo "\n\t\t\t<a href='".$_SERVER['PHP_SELF']. "?gkz=".$gkz."&amp;gmlid=".$gmlid;
				if ($idanzeige) { echo "&amp;id=j";}
				if ($showkey)   {echo "&amp;showkey=j";}
				// Umschalter: FS-Nachw ruft sich selbst mit geaend. Param. auf. Posit. auf Marke #gb
				if ($eig=="j") {
					echo "&amp;eig=n#gb' title='Flurst&uuml;cksnachweis'>ohne Eigent&uuml;mer</a>";
				} else {
					echo "&amp;eig=j#gb' title='Flurst&uuml;cks- und Eigent&uuml;mernachweis'>mit Eigent&uuml;mer ";
					echo "<img src='ico/EigentuemerGBzeile.ico' width='16' height='16' alt=''></a>";
				}
			echo "\n\t\t</p>";
		echo "\n\t</td>";
	echo "\n</tr>";
echo "\n</table>\n";

// B U C H U N G S S T E L L E N  zum FS (istGebucht)
$sql ="SELECT s.gml_id, s.buchungsart, s.laufendenummer as lfd, s.zaehler, s.nenner, s.nummerimaufteilungsplan as nrpl, s.beschreibungdessondereigentums as sond, b.bezeichner AS bart 
FROM ax_flurstueck f JOIN ax_buchungsstelle s ON s.gml_id=f.istgebucht 
LEFT JOIN v_bs_buchungsart b ON s.buchungsart=b.wert 
WHERE f.gml_id= $1 AND f.endet IS NULL AND s.endet IS NULL ORDER BY s.laufendenummer;";

$v = array($gmlid);
$ress = pg_prepare("", $sql);
$ress = pg_execute("", $v);
if (!$ress) {
	echo "\n<p class='err'>Keine Buchungsstelle.</p>\n";
	//if ($debug > 1) {echo "<p class='dbg'>Fehler:".pg_result_error($ress)."</p>";}
	if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmlid."'</p>";}
}
$bs=0; // Z.Buchungsstelle
while($rows = pg_fetch_array($ress)) {
	$gmls=$rows["gml_id"]; // gml b-Stelle
	$lfd=$rows["lfd"]; // BVNR

	// B U C H U N G S B L A T T  zur Buchungsstelle (istBestandteilVon)
	$sql ="SELECT b.gml_id, b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung as blatt, b.blattart, z.bezeichnung 
	FROM ax_buchungsstelle s JOIN ax_buchungsblatt b ON b.gml_id=s.istbestandteilvon 
	LEFT JOIN ax_buchungsblattbezirk z ON z.land=b.land AND z.bezirk=b.bezirk 
	WHERE s.gml_id = $1 AND s.endet IS NULL AND b.endet IS NULL AND z.endet IS NULL
	ORDER BY b.bezirk, b.buchungsblattnummermitbuchstabenerweiterung ;";

	$v = array($gmls);
	$resg = pg_prepare("", $sql);
	$resg = pg_execute("", $v);
	if (!$resg) {
		echo "\n<p class='err'>Kein Buchungsblatt.</p>\n";
		if ($debug > 2) {echo "<p class='dbg'>SQL=<br>".$sql."<br>$1 = gml_id = '".$gmls."'</p>";}
	}
	$bl=0; // Z.Blatt
	while($rowg = pg_fetch_array($resg)) {
		$gmlg=$rowg["gml_id"];
		$beznam=$rowg["bezeichnung"];
		$blattkeyg=$rowg["blattart"];
		$blattartg=blattart($blattkeyg);

		echo "\n<hr>";
		echo "\n<table class='outer'>";
		echo "\n<tr>"; // 1 row only
			echo "\n\t<td>"; // Outer linke Spalte:

				// Rahmen mit GB-Kennz
				if ($blattkeyg == 1000) {
					echo "\n\t<table class='kennzgb' title='Bestandskennzeichen'>";
				}else {
					echo "\n\t<table class='kennzgbf' title='Bestandskennzeichen'>"; // dotted
				}
					echo "\n\t<tr>\n\t\t<td class='head'>Bezirk</td>";
						echo "\n\t\t<td class='head'>".$blattartg."</td>";
						echo "\n\t\t<td class='head'>Lfd-Nr.</td>";
						echo "\n\t\t<td class='head'>Buchungsart</td>";
					echo "\n\t</tr>";
					echo "\n\t<tr>";
						echo "\n\t\t<td title='Grundbuchbezirk'>";
							if ($showkey) {
								echo "<span class='key'>".$rowg["bezirk"]."</span><br>";
							}
						echo $beznam."&nbsp;</td>";

						echo "\n\t\t<td title='Grundbuch-Blatt'><span class='wichtig'>".$rowg["blatt"]."</span></td>";

						echo "\n\t\t<td title='Bestandsverzeichnis-Nummer (BVNR, Grundst&uuml;ck)'>".$rows["lfd"]."</td>";

						echo "\n\t\t<td title='Buchungsart'>";
							if ($showkey) {
								echo "<span class='key'>".$rows["buchungsart"]."</span><br>";
							}
						echo $rows["bart"]."</td>";
					echo "\n\t</tr>";
				echo "\n\t</table>";

				// Miteigentumsanteil
				if ($rows["zaehler"] <> "") {
					echo "\n<p class='ant'>".$rows["zaehler"]."/".$rows["nenner"]."&nbsp;Anteil am Flurst&uuml;ck</p>";
				}
			echo "\n</td>";

			echo "\n<td>"; // Outer rechte Spalte: NW-Links
				if ($idanzeige) {
					linkgml($gkz, $gmls, "Buchungsstelle", "ax_buchungsstelle");
					echo "<br>";
					linkgml($gkz, $gmlg, "Buchungsblatt", ""); // ax_buchungsblatt keine Relationen
				}
				echo "\n\t<p class='nwlink noprint'>weitere Auskunft:<br>";
					echo "\n\t\t<a href='alkisbestnw.php?gkz=".$gkz."&amp;gmlid=".$gmlg."#bvnr".$lfd;
						if ($idanzeige) {echo "&amp;id=j";}
						if ($showkey)   {echo "&amp;showkey=j";}
						if ($blattkeyg == 1000) {
							echo "' title='Grundbuchnachweis mit kompletter Eigent&uuml;merangabe'>";
						} else {
							echo "' title='Grundbuchnachweis'>";
						}
						echo $blattartg." <img src='ico/GBBlatt_link.ico' width='16' height='16' alt=''>";
					echo "</a>";
				echo "\n\t</p>";

				ber_bs_hinw($gmls); // berechtigte Buchungstellen Hinweis

			echo "\n</td>";
		echo "\n</tr>";
		echo "\n</table>";

		// +++ Weitere Felder ausgeben? BeschreibungDesUmfangsDerBuchung
		if ($rows["sond"] != "") {
			echo "<p class='sond' title='Sondereigentum'>Verbunden mit dem Sondereigentum<br>".$rows["sond"]."</p>";
		}
		if ($rows["nrpl"] != "") {
			echo "<p class='nrap' title='Nummer im Aufteilungsplan'>Nummer <span class='wichtig'>".$rows["nrpl"]."</span> im Aufteilungsplan.</p>";
		}

		// E I G E N T U E M E R, zum GB
		// Person <-benennt< AX_Namensnummer  >istBestandteilVon-> AX_Buchungsblatt
		if ($eig=="j") { // Wahlweise mit/ohne Eigentümer
			echo "\n\n<h3><img src='ico/Eigentuemer_2.ico' width='16' height='16' alt=''> Angaben zum Eigentum</h3>\n";
			$n = eigentuemer($con, $gmlg, false, ""); // ohne Adresse
 			if ($n == 0) {
				if ($blattkeyg == 1000) {
					echo "\n<p class='err'>Keine Namensnummer gefunden.</p>";
					linkgml($gkz, $gmlg, "Buchungsblatt", "");
				} else {
					echo "\n<p>ohne Eigent&uuml;mer.</p>";
				}
			}
		}
		$bl++;
	}
	if ($bl == 0) {
		echo "\n<p class='err'>Kein Buchungsblatt gefunden.</p>";
		echo "\n<p class='err'>Parameter: gml_id= ".$gmls.", Beziehung='istBestandteilVon'</p>";
		linkgml($gkz, $gmls, "Buchungstelle", "ax_buchungsstelle");
	}
	$bs++;
}
pg_free_result($resg);
if ($bs == 0) {
	echo "\n<p class='err'>Keine Buchungstelle gefunden.</p>";
	linkgml($gkz, $gmlid, "Flurst&uuml;ck", "ax_flurstueck");
}
pg_close($con);
echo <<<END

<form action=''>
	<div class='buttonbereich noprint'>
	<hr>
		<a title="zur&uuml;ck" href='javascript:history.back()'><img src="ico/zurueck.ico" width="16" height="16" alt="zur&uuml;ck"></a>&nbsp;
		<a title="Drucken" href='javascript:window.print()'><img src="ico/print.ico" width="16" height="16" alt="Drucken"></a>&nbsp;
		<a title="Export als CSV" href='javascript:ALKISexport()'><img src="ico/download_fs.ico" width="32" height="16" alt="Export"></a>&nbsp;
	</div>
</form>
END;

footer($gmlid, $_SERVER['PHP_SELF']."?", "&amp;eig=".$eig);

?>

</body>
</html>