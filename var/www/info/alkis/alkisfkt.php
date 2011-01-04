<?php
/*	Modul: alkisfkt.php
	ALKIS-Buchauskunft, Kommunales Rechenzentrum Minden-Ravensberg/Lippe (Lemgo).
	Functions

	Version:
	07.09.2010  Schluessel anschaltbar
	15.09.2010  Function "buchungsart" durch JOIN ersetzt
	09.11.2010  Functions, die nur einmal aufgerufen wurden, sequentiell in FS-Nachw. integriert
	17.12.2010  Astrid Emde: Prepared Statements (pg_query -> pg_prepare + pg_execute)
*/
function footer($gkz, $gmlid, $idumschalter, $idanzeige, $link, $hilfeurl, $append, $showkey) {
	// Einen Seitenfuss ausgeben.
	// Den URL-Parameter "&id=j/n" und "&showkey=j/n" in allen Kombinationen umschalten lassen.
	// Die Parameter &gkz= und &gmlid= kommen in allen Modulen einheitlich vor

	// Der Parameter $append wird angehaengt wenn gefuellt
	//  Anwendung: &eig=j bei FS-NW, &ltyp=m/p/o bei Lage

	$customer=$_SESSION["mb_user_name"];
	echo "\n<div class='confbereich noprint'>";

	echo "\n<table class='outer'>\n<tr>";

	// Spalte 1: Info Benutzerkennung
	echo "\n\t<td title='Info'><i>Benutzer:&nbsp;".$customer."</i></td>";

	// Spalte 2: Umschalter
	echo "\n\t<td title='Konfiguration'>";
		// Umschalter:
		// - Schluessel
		// - Testmodus ID-Anzeige

		// bei beiden
		$mylink ="\n\t\t<a class='gmlid' href='".$link."gkz=".$gkz."&amp;gmlid=".$gmlid.$append;

		if ($showkey) { // bleibt so
			$mykey = "&amp;showkey=j";
		} else {
			$mykey = "&amp;showkey=n";
		}

		if ($idumschalter) { // fuer Entwicklung ODER Test

			if ($idanzeige) { // bleibt so
				$myid = "&amp;id=j";
			} else {
				$myid = "&amp;id=n";
			}

			// Umschalter nur ausgeben, wenn in conf gesetzt
			if ($idanzeige) { // Umschalten ID ein/aus
				echo $mylink.$mykey."&amp;id=n' title='Ohne Verfolgung der ALKIS-Beziehungen'>";
				echo "<img src='ico/Beziehung_link.ico' width='16' height='16' alt=''> ID aus</a>";
			} else {
				echo $mylink.$mykey."&amp;id=j' title='Verfolgung der GML-ID in den ALKIS-Beziehungen'>";
				echo "<img src='ico/Beziehung_link.ico' width='16' height='16' alt=''> ID ein</a>";
			}
			echo " | ";
		} else { // keinen ID-Umschalter
			$myid = "";
		}

		if ($showkey) { // // Umschalten Schlüssel ein/aus
			echo $mylink.$myid."&amp;showkey=n' title='Verschl&uuml;sselungen ausblenden'>Schl&uuml;ssel aus</a>";
		} else {
			echo $mylink.$myid."&amp;showkey=j' title='Verschl&uuml;sselungen anzeigen'>Schl&uuml;ssel ein</a>";
		}

	echo "\n\t</td>";

	// Spalte 3
	echo "\n\t<td title='Hilfe'>";
	echo "\n\t\t<p class='nwlink'>\n\t\t\t<a target='_blank' href='".$hilfeurl."' title='Dokumentation'>Hilfe zur ALKIS-Auskunft</a>\n\t\t</p>\n\t</td>";

	echo "\n</tr>\n</table>\n</div>\n";

/*	echo "<br><p class='err'>";
	echo "gkz=".$gkz."<br>";
	echo "gmlid=".$gmlid."<br>";
	echo "idumschalter=".$idumschalter."<br>";
	echo "idanzeige=".$idanzeige."<br>";
	echo "link=".$link."<br>";
	echo "hilfeurl=".$hilfeurl."<br>";
	echo "append=".$append."<br>";
	echo "showkey=".$showkey;
	echo "</p>"; */
	return 0;
}

function linkgml($gkz, $gml, $typ)  {
	// Einen Link zur Verfolgung der Beziehungen mit dem Modul alkisrelationen.php
	$kurzid=substr($gml, 12); // ID in Anzeige kuerzen (4 Zeichen), der Anfang ist immer gleich	echo "\n\t\t<a target='_blank' title='ID ".$typ."' class='gmlid noprint' ";
	echo "href='alkisrelationen.php?gkz=".$gkz."&amp;gmlid=".$gml."&amp;otyp=".$typ."'>";
	echo "<img src='ico/Beziehung_link.ico' width='16' height='16' alt=''>".$kurzid."</a>";
	return 0;
}

function kurz_namnr($lang) {
	// Namensnummer kuerzen. Nicht benoetigte Stufen der Dezimalklassifikation abschneiden
	$kurz=str_replace(".00","",$lang);	// leere Stufen (nur am Ende)
	$kurz=str_replace("0000","",$kurz);	// ganz leer (am Anfang)
	$kurz=ltrim($kurz, "0");				// fuehrende Nullen am Anfang
	$kurz=str_replace(".0",".",$kurz);	// fuehrende Null jeder Stufe
	return $kurz;
}

function bnw_fsdaten($con, $gkz, $idanzeige, $lfdnr, $gml_bs, $ba, $anteil, $bvnraus, $showkey) {
/*	Bestandsnachweis - Flurstuecksdaten
	Die Tabellenzeilen mit den Flurstuecksdaten zu einer Buchungsstelle im Bestandsnachweis ausgeben.
	Die Funktion wird je einmal aufgerufen für die Buchungen direkt auf dem GB (Normalfall).
	Weiterere Aufrufe ggf. bei Erbbaurecht für die mit "an" verknuepften Buchungsstellen.
	Table-Tag und Kopfzeile im aufrufenden Programm. 
*/

	// F L U R S T U E C K
	$sql="SELECT g.gemarkungsnummer, g.bezeichnung, ";
	$sql.="f.gml_id, f.flurnummer, f.zaehler, f.nenner, f.regierungsbezirk, f.kreis, f.gemeinde, f.amtlicheflaeche ";
	$sql.="FROM ax_gemarkung g ";
	$sql.="JOIN ax_flurstueck f ON f.land=g.land AND f.gemarkungsnummer=g.gemarkungsnummer ";
	$sql.="JOIN alkis_beziehungen v ON f.gml_id=v.beziehung_von "; 
	$sql.="WHERE v.beziehung_zu= $1 "; // id buchungsstelle
	$sql.="AND   v.beziehungsart='istGebucht' ";
	$sql.="ORDER BY f.gemarkungsnummer, f.flurnummer, f.zaehler, f.nenner;";

	$v = array($gml_bs);
	$resf = pg_prepare("", $sql);
	$resf = pg_execute("", $v);

	if (!$resf) {echo "<p class='err'>Fehler bei Flurst&uuml;ck<br><br>".$sql."</p>\n";}

	if($bvnraus) { // nur bei direkten Buchungen die lfdNr ausgeben
		$bvnr=str_pad($lfdnr, 4, "0", STR_PAD_LEFT);
	}
	$altlfdnr="";
	$j=0;
	while($rowf = pg_fetch_array($resf)) {
		$flur=str_pad($rowf["flurnummer"], 3, "0", STR_PAD_LEFT);

/*		$fskenn=str_pad($rowf["zaehler"], 5, "0", STR_PAD_LEFT);
		if ($rowf["nenner"] != "") { // Bruchnummer
			$fskenn.="/".str_pad($rowf["nenner"], 3, "0", STR_PAD_LEFT);
		} */

		// ohne fuehrende Nullen?
		$fskenn=$rowf["zaehler"];
		if ($rowf["nenner"] != "") { // Bruchnummer
			$fskenn.="/".$rowf["nenner"];
		}

		$flae=number_format($rowf["amtlicheflaeche"],0,",",".") . " m&#178;";

		echo "\n<tr>"; // eine Zeile je Flurstueck
			// Sp. 1-3 der Tab. aus Buchungsstelle, nicht aus FS
			if($lfdnr == $altlfdnr) {	// gleiches Grundstueck
				echo "\n\t<td>&nbsp;</td>";
				echo "\n\t<td>&nbsp;</td>";
				echo "\n\t<td>&nbsp;</td>";
			} else {

				echo "\n\t<td>";
					echo "<a name='bvnr".$lfdnr."'></a>"; // Sprungmarke
					echo "<span class='wichtig'>".$bvnr."</span>";  // BVNR
					if ($idanzeige) {linkgml($gkz, $gml_bs, "Buchungsstelle");}
				echo "</td>";

				echo "\n\t<td>"; // Buchungsart 
					//	if ($showkey) {echo "<span class='key'>".$???."</span>&nbsp;";} // Schluessel
					echo $ba; // entschluesselt
				echo "</td>"; 
				echo "\n\t<td>&nbsp;</td>"; // Anteil
				$altlfdnr=$lfdnr;
			}
			//Sp. 4-7 aus Flurstueck
			echo "\n\t<td>";
			if ($showkey) {
				echo "<span class='key'>".$rowf["gemarkungsnummer"]."</span> ";
			}
			echo $rowf["bezeichnung"]."</td>";
			echo "\n\t<td>".$flur."</td>";
			echo "\n\t<td><span class='wichtig'>".$fskenn."</span>";
				if ($idanzeige) {linkgml($gkz, $rowf["gml_id"], "Flurst&uuml;ck");}
			echo "</td>";
			echo "\n\t<td class='fla'>".$flae."</td>";

			echo "\n\t<td><p class='nwlink noprint'>";
				echo "<a href='alkisfsnw.php?gkz=".$gkz."&amp;gmlid=".$rowf["gml_id"]."&amp;eig=n";
					if ($idanzeige) {echo "&amp;id=j";}
					if ($showkey)   {echo "&amp;showkey=j";}
					echo "' title='Flurst&uuml;cksnachweis'>Flurst&uuml;ck ";
					echo "<img src='ico/Flurstueck_Link.ico' width='16' height='16' alt=''>";
				echo "</a>";
			echo "</p></td>";
		echo "\n</tr>";

		$j++;
	} // Ende Flurstueck
	return $j;
}

function eigentuemer($con, $gkz, $idanzeige, $gmlid, $mitadresse, $showkey) {
	// Tabelle mit Eigentuemerdaten zu einem Grundbuchblatt ausgeben
	// Sp.1 = Namennummer, Sp. 2 = Name / Adresse, Sp. 3 = Link
	// Parameter:
	//		$gmlid = ID des GB-Blattes
	//		$mitadresse = Option (true/false) ob auch die Adresszeile ausgegeben werden soll
	// Return = Anzahl Namensnummern

	// Schleife 1: N a m e n s n u m m e r
	// Beziehung: ax_namensnummer  >istBestandteilVon>  ax_buchungsblatt

	$sql="SELECT n.gml_id, n.laufendenummernachdin1421 AS lfd, n.zaehler, n.nenner, ";
	$sql.="n.artderrechtsgemeinschaft AS adr, n.beschriebderrechtsgemeinschaft as beschr, n.eigentuemerart, n.anlass ";
	$sql.="FROM  ax_namensnummer n ";
	$sql.="JOIN  alkis_beziehungen b ON b.beziehung_von=n.gml_id ";
	$sql.="WHERE b.beziehung_zu= $1 "; // id blatt
	$sql.="AND   b.beziehungsart='istBestandteilVon' ";
	$sql.="ORDER BY laufendenummernachdin1421;";

	$v = array($gmlid);
	$resn = pg_prepare("", $sql);
	$resn = pg_execute("", $v);

	if (!$resn) {echo "<p class='err'>Fehler bei Eigentuemer<br>SQL= ".$sql."<br></p>\n";}

	//echo "<p class='nwlink noprint'>weitere Auskunft:</p>"; // oben rechts von der Tabelle
	echo "\n\n<table class='eig'>";
	$n=0; // Z.NamNum.

	//echo "\n\n<!-- vor Schleife 1 Namensnummer -->";
	while($rown = pg_fetch_array($resn)) {
		echo "\n<tr>";
			echo "\n\t<td class='nanu' title='Namens-Nummer'>\n\t\t<p>"; // Sp. 1
				// VOR die Tabelle: "Eigentümer"
				$namnum=kurz_namnr($rown["lfd"]);
				echo $namnum."&nbsp;";
				if ($idanzeige) {linkgml($gkz, $rown["gml_id"], "Namensnummer");}
			echo "</p>\n\t</td>";

			echo "\n\t<td>"; // Sp. 2
			$rechtsg=$rown["adr"];
			if ($rechtsg != "" ) {
				if ($rechtsg == 9999) { // sonstiges
					echo "\n\t\t<p class='zus' title='Beschrieb der Rechtsgemeinschaft'>".htmlentities($rown["beschr"], ENT_QUOTES, "UTF-8")."</p>";
				} else {
					echo "\n\t\t<p class='zus' title='Art der Rechtsgemeinschaft'>".htmlentities(rechtsgemeinschaft($rown["adr"]), ENT_QUOTES, "UTF-8")."</p>";
					// !! Feld /td und Zeile /tr nicht geschlossen
					//	echo "\n\t</td>\n</tr>"; // !!! IMMER? oder nur wenn letzte Zeile?
				}
			}
			//if ($rown["anlass"] > 0 ) {echo "<p>Anlass=".$rown["anlass"]."</p>";} // TEST:

			//echo "\n\t\t</td>\n\t\t<td></td>\n</tr>";

			// Schleife Ebene 2: andere Namensnummern
			// Beziehung   ax_namensnummer >bestehtAusRechtsverhaeltnissenZu>  ax_namensnummer 

			// Die Relation 'Namensnummer' besteht aus Rechtsverhältnissen zu 'Namensnummer' sagt aus, 
			// dass mehrere Namensnummern zu einer Rechtsgemeinschaft gehören können. 
			// Die Rechtsgemeinschaft selbst steht unter einer eigenen AX_Namensnummer, 
			// die zu allen Namensnummern der Rechtsgemeinschaft eine Relation besitzt.

			// Die Relation 'Namensnummer' hat Vorgänger 'Namensnummer' gibt Auskunft darüber, 
			// aus welchen Namensnummern die aktuelle entstanden ist.

		// Schleife 2: P e r s o n  
		// Beziehung: ax_person  <benennt<  ax_namensnummer
		$sql="SELECT p.gml_id, p.nachnameoderfirma, p.vorname, p.geburtsname, p.geburtsdatum, p.namensbestandteil, p.akademischergrad ";
		$sql.="FROM  ax_person p ";
		$sql.="JOIN  alkis_beziehungen v ON v.beziehung_zu=p.gml_id ";
		$sql.="WHERE v.beziehung_von= $1 "; // id num
		$sql.="AND   v.beziehungsart='benennt';";

		$v = array($rown["gml_id"]);
		$rese = pg_prepare("", $sql);
		$rese = pg_execute("", $v);

		if (!$rese) {echo "\n\t<p class='err'>Fehler bei Eigentuemer<br>SQL= ".$sql."<br></p>\n";}
		$i=0; // Z.Eig.
		//echo "\n<!-- vor Schleife 2 Person -->";
		while($rowe = pg_fetch_array($rese)) {
			$diePerson="";
			if ($rowe["akademischergrad"] <> "") {$diePerson=$rowe["akademischergrad"]." ";}
			$diePerson.=$rowe["nachnameoderfirma"];
			if ($rowe["vorname"] <> "") {$diePerson.=", ".$rowe["vorname"];}
			if ($rowe["namensbestandteil"] <> "") {$diePerson.=". ".$rowe["namensbestandteil"];}
			if ($rowe["geburtsdatum"] <> "") {$diePerson.=", geb. ".$rowe["geburtsdatum"];}
			if ($rowe["geburtsname"] <> "") {$diePerson.=", geb. ".$rowe["geburtsname"];}
			$diePerson=htmlentities($diePerson, ENT_QUOTES, "UTF-8"); // Umlaute

			// Spalte 1 enthält die Namensnummer, nur in Zeile 0
			if ($i > 0) {
				echo "\n<tr>\n\t<td>&nbsp;</td>\n\t<td>";
			}
			// Spalte 2 = Angaben
			$eiart=eigentuemerart($rown["eigentuemerart"]);
			echo "\n\t\t<p class='geig' title='Eigent&uuml;merart ".$eiart."'>".$diePerson."</p>\n\t</td>";

			// Spalte 3 = Link			echo "\n\t<td>\n\t\t<p class='nwlink noprint'>";
				if ($idanzeige) {linkgml($gkz, $rowe["gml_id"], "Person"); echo "&nbsp";}
				echo "\n\t\t<a href='alkisnamstruk.php?gkz=".$gkz."&amp;gmlid=".$rowe[0];
				if ($idanzeige) {echo "&amp;id=j";}
				if ($showkey)   {echo "&amp;showkey=j";}
				echo "' title='vollst&auml;ndiger Name und Adresse eines Eigent&uuml;mers'>".$eiart;
				echo " <img src='ico/Eigentuemer.ico' width='16' height='16' alt=''></a>\n\t\t</p>";
			echo "\n\t</td>\n</tr>";

			if ($mitadresse) {
				// Schleife 3:  A d r e s s e  (OPTIONAL)
				$sql ="SELECT a.gml_id, a.ort_post, a.postleitzahlpostzustellung AS plz, a.strasse, a.hausnummer, a.bestimmungsland ";
				$sql.="FROM ax_anschrift a ";
				$sql.="JOIN alkis_beziehungen b ON a.gml_id=b.beziehung_zu ";
				$sql.="WHERE b.beziehung_von= $1 ";
				$sql.="AND b.beziehungsart='hat';"; // ORDER?

				$v = array($rowe["gml_id"]);
				$resa = pg_prepare("", $sql);
				$resa = pg_execute("", $v);

				if (!$resa) {
					echo "\n\t<p class='err'>Fehler bei Adressen.<br>\nSQL= ".$sql."</p>\n";
				}
				$j=0;
				//echo "\n<!-- vor Schleife 3 Adresse -->";
				while($rowa = pg_fetch_array($resa)) {
					$gmla=$rowa["gml_id"];
					$plz=$rowa["plz"]; // integer
					if($plz == 0) {
						$plz="";
					} else {
						$plz=str_pad($plz, 5, "0", STR_PAD_LEFT);
					}
					$ort=htmlentities($rowa["ort_post"], ENT_QUOTES, "UTF-8");
					$str=htmlentities($rowa["strasse"], ENT_QUOTES, "UTF-8");
					$hsnr=$rowa["hausnummer"];
					$land=htmlentities($rowa["bestimmungsland"], ENT_QUOTES, "UTF-8");

					echo "\n<tr>\n\t<td>&nbsp;</td>"; // Spalte 1
					echo "\n\t<td><p class='gadr'>"; //Spalte 2
					if ($str.$hsnr != "") {
						echo $str." ".$hsnr."<br>";
					}
					if ($plz.$ort != "") {
						echo $plz." ".$ort;
					}
					if ($land != "" and $land != "DEUTSCHLAND") {
						echo ", ".$land;
					}
					echo "</p></td>";
					echo "\n\t<td>"; // Spalte 3
					if ($idanzeige) {
						echo "<p class='nwlink noprint'>";
						linkgml($gkz, $gmla, "Adresse");
						echo "</p>";
					} else { 
						echo "&nbsp;";
					}
					echo "</td>\n</tr>";
					$j++;
				}
				//echo "\n<!-- nach Schleife 3 Adresse -->";
			} // if
			// 'keine Adresse' kann vorkommen, z.B. "Deutsche Telekom AG"
			$i++; // Z. Person
			// als eigene Tab-Zeile?
			// 'Anteil' ist der Anteil der Berechtigten in Bruchteilen (Par. 47 GBO) 
			// an einem gemeinschaftlichen Eigentum (Grundstück oder Recht).
			if ($rown["zaehler"] != "") {
				echo "\n<tr>\n\t<td>&nbsp;</td>"; // Sp. 1
				echo "\n\t<td><p class='avh' title='Anteil'>".$rown["zaehler"]."/".$rown["nenner"]." Anteil</p></td>";
				echo "\n\t<td>&nbsp;</td>\n</tr>"; // Sp. 3
			}
		}
		//echo "\n<!-- nach Schleife 2 Person -->";

		if ($i == 0) { // keine Pers zur NamNum
			echo "\n<!-- Rechtsgemeinscahft='".$rechtsg."' -->";
			// Wann warnen?
			//if ($rechtsg != 9999) {
				// Art der Rechtsgemeinsachft, 0 Eigent. ist Normal bei Sondereigentum
				//echo "\n<tr>\n<td>";
				//linkgml($gkz, $rown["gml_id"], "Namensnummer");
				//echo "</td>\n<td>\n\t\t<p class='err'>Kein Eigent&uuml;mer gefunden. (Rechtsgemeinschaft=".$rechtsg.")</p>";
			//}
			echo "</td>\n\t<td>&nbsp;</td>\n<tr>";
		}
		$n++; // cnt NamNum
	} // End Loop NamNum
	//echo "\n<!-- nach Schleife 1 Namensnummer -->";
	echo "\n</table>\n";
	return $n; 
} // End Function eigentuemer

// **  Functions  zum   E n t s c h l u e s s e l n  **

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
// Abweichend hier in singular fuer Link-Text
function eigentuemerart($key) {
	switch ($key) {
		case 1000:
			$wert = "Nat&uuml;rliche Person"; 
			break;
		case 2000:
			$wert = "Juristische Person"; 
			break;
		case 3000:
			$wert = "K&ouml;rperschaft"; 
			break;
		case "": // falls (noch) nicht gefuellt
			$wert = "Person"; 
			break;
		default:
			$wert = "** Unbekannte Eigent&uuml;merart '".$key."' **";;
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