<?php
/*	alkisfkt.php
	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Functions z.B. zum Entschluesseln
	Version:
	26.01.2010	internet-Version  mit eigener conf´
*/

// Einen Seitenfuss ausgeben.
// Der URL-Parameter &id=j/n kann hinzugefuegt werden, solange die Parameter &gkz= &gmlid=
// in allen Modulen einheitlich und ausschlesslich vorkommen,
function footer($gkz, $gmlid, $idanzeige, $link, $hilfeurl, $style) {
	$customer=$_SESSION["mb_user_name"];
	echo "\n<div class='confbereich noprint'>";
	echo "\n<table class='outer'>\n<tr>";

	// Spalte 1
	echo "\n\t<td title='Info'><i>Benutzer:&nbsp;".$customer."</i></td>";

	// Spalte 2
	echo "\n\t<td title='Konfiguration'>";

	// Umschalter Testmodus (ID-Verfolgung)
	echo "\n\t\t<a href='".$link."gkz=".$gkz."&amp;gmlid=".$gmlid;
	if ($idanzeige) {
		echo "' title='Ohne Verfolgung der ALKIS-Beziehungen'>ID aus</a>";
	} else {
		
		echo "&amp;id=j' title='Verfolgung der GML-ID in den ALKIS-Beziehungen'>ID ein</a>";
	}
	echo "&nbsp;";

	// Umschalter fuer Darstellung der Daten
	echo "\n\t\t<a href='".$link."gkz=".$gkz."&amp;gmlid=".$gmlid;
	if ($idanzeige) {echo "&amp;id=j";}
	If ($style == "alkis") { 
		echo "&amp;style=kompakt' title='Kurze tabellarische Darstellung'>Kompakt</a>";
	} else { // kompakter Style
		echo "&amp;style=alkis' title='Beschreibende Darstellung'>ALKIS-Style</a>";
	}

	echo "\n\t</td>";

	// Spalte 3
	echo "\n\t<td title='Hilfe'>";
	echo "\n\t\t<p class='nwlink'>\n\t\t\t<a target='_blank' href='".$hilfeurl."' title='Dokumentation'>Hilfe zur ALKIS-Auskunft</a>\n\t\t</p>\n\t</td>";

	echo "\n</tr>\n</table>\n</div>\n";
	
	return 0;
}
// Einen Link zur Verfolgung der Beziehungen mit dem Prog alkisrelationen
function linkgml($gkz, $gml, $typ)  {
	$kurzid=substr($gml, 11); // kuerzen, der Anfang ist immer identisch
	echo "\n\t\t<div class='gmlid noprint' title='ID ".$typ."'>";
	echo "\n\t\t\t<a target='_blank' class='gmlid' href='alkisrelationen.php?gkz=".$gkz."&amp;gmlid=".$gml."&amp;otyp=".$typ."'>".$kurzid."</a>\n\t\t</div>";
	return 0;
}
// Namensnummer kuerzen, nicht benoetigte Stufen abschneiden
function kurz_namnr($lang) {
	$kurz=str_replace(".00","",$lang);		// leere Stufen (nur am Ende)
	$kurz=str_replace("0000","",$kurz);		// ganz leer (am Anfang)
	$kurz=ltrim($kurz, "0");				// fuehrende Nullen am Anfang
	$kurz=str_replace(".0",".",$kurz);		// fuehrende Null jeder Stufe
	return $kurz;
}

// **  E n t s c h l u e s s e l n  **
/*  MUSTER
// Entschluesslung AX_Tab.Feld
function fkt_name($key) {
	switch ($key) {
		case ___:
			$wert = "___"; 
			break;
		default:
			$wert = "";
			break;
	}
	return $wert;
}
*/
// Entschluesslung ax_person.anrede
function anrede($key) {
	switch ($key) {
		case 1000:
			$wert = "Frau";
			break;
		case 2000:
			$wert = "Herr";
			break;
		case 3000:
			$wert = "Firma";
			break;
		default:
			$wert = "";
			break;
	}
	return $wert;
}
// Entschluesslung buchungsart
// Die Buchungsarten mit Wertearten 1101, 1102, 1401 bis 1403, 2201 bis 2205 und 2401 bis 2404 können nur auf einem Fiktiven Blatt vorkommen. 
// Die Attributart 'Anteil' ist dann immer zu belegen.
function buchungsart($key) {
	switch ($key) {
		case 1100:
			$wert = "Grundst&uuml;ck"; 
			break;
		case 1101:
			$wert = "Aufgeteiltes Grundstück WEG";
			break;
		case 1102:
			$wert = "Aufgeteiltes Grundstück Par. 3 Abs. 4 GBO";
			break;
		case 1301:
			$wert = "Wohnungs-/Teileigentum";
			break;
		case 1302:
			$wert = "Miteigentum Par. 3 Abs. 4 GBO";
			break;
		case 2101:
			$wert = "Erbbaurecht";
			break;
		case 2102:
			$wert = "Untererbbaurecht";
			break;
		case 2201:
			$wert = "Aufgeteiltes Erbbaurecht WEG";
			break;
		case 2301:
			$wert = "Wohnungs-/Teilerbbaurecht";
			break;
		case 2302:
			$wert = "Wohnungs-/Teiluntererbbaurecht";
			break;
		case 5101:
			$wert = "Von Buchungspflicht befreit Par. 3 Abs. 2 GBO";
			break;
		default:
			$wert = "";
			break;
	}
	return $wert;
}
// Entschluesslung AX_Namensnummer.artDerRechtsgemeinschaft
function rechtsgemeinschaft($key) {
	switch ($key) {
		case 1000:
			$wert = "Erbengemeinschaft"; 
			break;
		case 2000:
			$wert = "Gütergemeinschaft"; 
			break;
		case 3000:
			$wert = "BGB-Gesellschaft"; 
			break;
		case 9999:
			$wert = "Sonstiges"; 
		// dann: beschriebDerRechtsgemeinschaft
			break;
		default:
			$wert = "";
			break;
	}
	return $wert;
}
// Entschluesslung AX_Namensnummer.eigentuemerart
function eigentuemerart($key) {
	switch ($key) {
		case 1000:
			$wert = "Nat&uuml;rliche Personen"; 
			break;

		case 2000:
			$wert = "Juristische Personen"; 
			break;

		case 3000:
			$wert = "K&ouml;rperschaften"; 
			break;
		default:
			$wert = "** Unbekannter Wert '".$key."'";;
			break;
	}
	return $wert;
}
// Entschluesslung ax_buchungsblatt.blattart
function blattart($key) {
	switch ($key) {
		case 1000:
			$wert = "Grundbuchblatt"; 
			// Ein Grundbuchblatt ist ein Buchungsblatt, das die Buchung im Grundbuch enthält.
			break;
		case 2000:
			$wert = "Katasterblatt";
			// Ein Katasterblatt ist ein Buchungsblatt, das die Buchung im Liegenschaftskataster enthält.
			break;
		case 3000:
			$wert = "Pseudoblatt";
			// Ein Pseudoblatt ist ein Buchungsblatt, das die Buchung, die bereits vor Eintrag im Grundbuch Rechtskraft erlangt hat, enthält 
			// (z.B. Übernahme von Flurbereinigungsverfahren, Umlegungsverfahren).
			break;
		case 5000:
			$wert = "Fiktives Blatt";
			// Das fiktive Blatt enthält die aufgeteilten Grundstücke und Rechte als Ganzes. 
			// Es bildet um die Miteigentumsanteile eine fachliche Klammer.
			break;
		default:
			$wert = "** Unbekannter Wert '".$key."'";;
			break;
	}
	return $wert;
}
// Entschluesslung ax_dienststelle.stellenart
function dienststellenart($key) {
	switch ($key) {
		case 1000:
			$wert = "Grundbuchamt";
			break;
		case 1100:
			$wert = "Katasteramt"; 
			break;
		case 1200:
			$wert = "Finanzamt"; 
			break;
		case 1300:
			$wert = "Flurbereinigungsbeh&ouml;rde"; 
			break;
		case 1400:
			$wert = "Forstamt"; 
			break;
		case 1500:
			$wert = "Wasserwirtschaftsamt"; 
			break;
		case 1600:
			$wert = "Straßenbauamt"; 
			break;
		case 1700:
			$wert = "Gemeindeamt"; 
			break;
		case 1900:
			$wert = "Kreis- oder Stadtverwaltung"; 
			break;
		case 2000:
			$wert = "Wasser- und Bodenverband"; 
			break;
		case 2100:
			$wert = "Umlegungsstelle"; 
			break;
		case 2200:
			$wert = "Landesvermessungsverwaltung"; 
			break;
		case 2300:
			$wert = "&Ouml;bVI"; 
			break;
		case 2400:
			$wert = "Bundeseisenbahnverm&ouml;gen"; 
			break;
		case 2500:
			$wert = "Landwirtschaftskammer"; 
			break;
		default:
			$wert = "** Unbekannter Wert '".$key."'";
			break;
	}
	return $wert;
}
?>