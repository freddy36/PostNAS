
-- ALKIS PostNAS 0.5

-- ======================================================
-- Zusammenfassung der Tabellen der tatsächlichen Nutzung
-- ======================================================

-- Um bei einer Feature.Info (Welche Nutzung an dieser Stelle?) 
-- oder einer Verschneidung (Welche Nutzungen auf dem Flurstück?) 
-- nicht 26 verschiedene Tabellen abfragen zu müssen, werden die wichtigsten 
-- Felder dieser Tabellen zusammen gefasst.

-- Teil 2: Laden der statischen Tabellen mit Metadaten und Schlüsseln (Classes)

-- Stand 
--  2010-11-10  In Arbeit ... 

SET client_encoding = 'UTF-8';


-- Tabellen  l e e r e n 
DELETE FROM nutzung_meta;
DELETE FROM nutzung_class;


-- Über die Tabelle "nutzung_meta" wird dokumentiert, welche Felder der Ursprungstabellen 
-- in die Zielfelder "class" und "info" der zusammen gefassten Tabelle "nutzung" geladen werden,


-- ****  Objektbereich: Tatsächliche Nutzung  ****

-- ** Objektartengruppe: Siedlung **

-- 01 REO: ax_Wohnbauflaeche

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (1, 'Siedlung','ax_wohnbauflaeche','Wohnbaufläche', 'Art der Bebauung', null);

-- Classes (artderbebauung):
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (1, 1000,'Offen',       '"Offen" beschreibt die Bebauung von "Wohnbaufläche", die vorwiegend durch einzelstehende Gebäude charakterisiert wird.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (1, 2000,'Geschlossen', '"Geschlossen" beschreibt die Bebauung von "Wohnbaufläche", die vorwiegend durch zusammenhängende Gebäude charakterisiert wird. Die Gebäudeabdeckung ist in der Regel >50 Prozent der Wohnbaufläche.');

-- Zustand: 2 Werte
-- 2100,'Außer Betrieb, stillgelegt, verlassen', '"Außer Betrieb, stillgelegt; verlassen" bedeutet, dass sich die Fläche nicht mehr in regelmäßiger, der Bestimmung entsprechenden Nutzung befindet.');
-- 8000,'Erweiterung, Neuansiedlung'


-- 02 REO: ax_IndustrieUndGewerbeflaeche
-- -------------------------------------
-- Metadaten
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (2, 'Siedlung','ax_industrieundgewerbeflaeche','Industrie- und Gewerbefläche', 'Funktion', null);

-- Classes (Funktion):
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 1700,'Industrie und Gewerbe', '"Industrie und Gewerbe" bezeichnet Flächen, auf denen vorwiegend Industrie- und Gewerbebetriebe vorhanden sind. Darin sind Gebäude- und Freiflächen und die Betriebsläche Lagerplatz enthalten.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1710,'Produktion');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1720,'Handwerk');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1730,'Tankstelle');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 1740,'Lagerplatz', '"Lagerplatz" bezeichnet Flächen, auf denen inner- und außerhalb von Gebäuden wirtschaftliche Güter gelagert werden.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1750,'Transport');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1760,'Forschung');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1770,'Grundstoff');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1780,'Betriebliche Sozialeinrichtung');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1790,'Werft');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 1400,'Handel und Dienstleistung', '"Handel und Dienstleistung" bezeichnet eine Fläche, auf der vorwiegend Gebäude stehen, in denen Handels- und/oder Dienstleistungsbetriebe ansässig sind.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1410,'Verwaltung, freie Berufe');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1420,'Bank, Kredit');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1430,'Versicherung');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1440,'Handel');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 1450,'Ausstellung, Messe', '"Ausstellung, Messe" bezeichnet eine Fläche mit Ausstellungshallen und sonstigen Einrichtungen zur Präsentation von Warenmustern.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1460,'Beherbergung');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1470,'Restauration');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 1480,'Vergnügung');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 1490,'Gärtnerei', '"Gärtnerei" bezeichnet eine Fläche mit Gebäuden, Gewächshäusern und sonstigen Einrichtungen, zur Aufzucht von Blumen und Gemüsepflanzen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 2500,'Versorgungsanlage', '"Versorgungsanlage" bezeichnet eine Fläche, auf der vorwiegend Anlagen und Gebäude zur Versorgung der Allgemeinheit mit Elektrizität, Wärme und Wasser vorhanden sind.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2501,'Gebäude- und Freifläche Versorgungsanlage');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2502,'Betriebsfläche Versorgungsanlage');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 2510,'Förderanlage', '"Förderanlage" bezeichnet eine Fläche mit Einrichtungen zur Förderung von Erdöl, Erdgas, Sole, Kohlensäure oder Erdwärme aus dem Erdinneren.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 2520,'Wasserwerk', '"Wasserwerk" bezeichnet eine Fläche mit Bauwerken und sonstigen Einrichtungen zur Gewinnung und/ oder zur Aufbereitung von (Trink-)wasser.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2521,'Gebäude- und Freifläche Versorgungsanlage, Wasser');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2522,'Betriebsfläche Versorgungsanlage, Wasser');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 2530,'Kraftwerk', '"Kraftwerk" bezeichnet eine Fläche mit Bauwerken und sonstigen Einrichtungen zur Erzeugung von elektrischer Energie.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2531,'Gebäude- und Freifläche Versorgungsanlage, Elektrizität');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2532,'Betriebsfläche Versorgungsanlage, Elektrizität');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 2540,'Umspannstation', '"Umspannstation" bezeichnet eine Fläche mit Gebäuden und sonstigen Einrichtungen, um Strom auf eine andere Spannungsebene zu transformieren.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 2550,'Raffinerie', '"Raffinerie" bezeichnet eine Fläche mit Bauwerken und sonstigen Einrichtungen zur Aufbereitung von Erdöl.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2551,'Gebäude- und Freifläche Versorgungsanlage, Öl');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2552,'Betriebsfläche Versorganlage, Öl');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2560,'Gaswerk');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2561,'Gebäude- und Freifläche Versorgungsanlage, Gas');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2562,'Betriebsfläche Versorgungsanlage, Gas');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 2570,'Heizwerk', '"Heizwerk" bezeichnet eine Fläche mit Bauwerken und sonstigen Einrichtungen zur Erzeugung von Wärmeenergie zu Heizzwecken.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2571,'Gebäude- und Freifläche Versorgungsanlage, Wärme');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2572,'Betriebsfläche Versorgungsanlage, Wärme');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 2580,'Funk- und Fernmeldeanlage', '"Funk- und Fernmeldeanlage" bezeichnet eine Fläche, auf der vorwiegend Anlagen und Gebäude zur elektronischen Informationenvermittlung stehen.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2581,'Gebäude- und Freifläche Versorgungsanlage, Funk- und Fernmeldewesen');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2582,'Betriebsfläche Versorgungsanlage, Funk- und Fernmeldewesen');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 2600,'Entsorgung', '"Entsorgung" bezeichnet eine Fläche, auf der vorwiegend Anlagen und Gebäude zur Verwertung und Entsorgung von Abwasser und festen Abfallstoffen vorhanden sind.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2601,'Gebäude- und Freifläche Entsorgungsanlage');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2602,'Betriebsfläche Entsorgungsanlage');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 2610,'Kläranlage, Klärwerk', '"Kläranlage, Klärwerk" bezeichnet eine Fläche mit Bauwerken und sonstigen Einrichtungen zur Reinigung von Abwasser.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2611,'Gebäude- und Freifläche Entsorgungsanlage, Abwasserbeseitigung');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2612,'Betriebsfläche Entsorgungsanlage, Abwasserbeseitigung');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 2620,'Abfallbehandlungsanlage', '"Abfallbehandlungsanlage" bezeichnet eine Fläche mit Bauwerken und sonstigen Einrichtungen, auf der Abfälle mit chemisch/physikalischen und biologischen oder thermischen Verfahren oder Kombinationen dieser Verfahren behandelt werden.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2621,'Gebäude- und Freifläche Entsorgungsanlage, Abfallbeseitigung');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2622,'Betriebsfläche Entsorgungsanlage, Abfallbeseitigung');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, 2623,'Betriebsfläche Entsorgungsanlage, Schlamm');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 2630,'Deponie (oberirdisch)', '"Deponie (oberirdisch)" bezeichnet eine Fläche, auf der oberirdisch Abfallstoffe gelagert werden.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, 2640,'Deponie (untertägig)', '"Deponie (untertägig)" bezeichnet eine oberirdische Betriebsfläche, unter der Abfallstoffe eingelagert werden (Untertagedeponie).');

-- MUSTER:
--INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (2, __,'__');
--INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (2, __,'__', '____');


-- Zustand als 2. Feld?


--*Fördergut:
-- 1000 Erdöl        'Erdöl' ist ein flüssiges und brennbares Kohlenwasserstoffgemisch, das gefördert wird.
-- 2000 Erdgas       'Erdgas' ist ein in der Erdkruste vorkommendes brennbares Naturgas, das gefördert wird.
-- 3000 Sole, Lauge  'Sole, Lauge' ist ein kochsalzhaltiges Wasser, das gefördert wird.
-- 4000 Kohlensäure  'Kohlensäure' ist eine schwache Säure, die durch Lösung von Kohlendioxid in Wasser entsteht und gefördert wird.
-- 5000 Erdwärme     'Erdwärme' ist eine auf natürlichem Wege sich erneuernde Wärmeenergie, die aus einer geothermisch geringen Tiefenstufe der Erdkruste gefördert wird.

--*Lagergut:
-- 7000 Abraum
-- 1000 Baustoffe
-- 4000 Erde
-- 2000 Kohle
-- 3000 Öl
-- 6000 Schlacke
-- 8000 Schrott, Altmaterial

--*Primärenergie:
-- 1000 Wasser    --'Wasser' bedeutet, dass das Kraftwerk potentielle und kinetische Energie des Wasserkreislaufs in elektrische Energie umwandelt.
-- 2000 Kernkraft --'Kernkraft' bedeutet, dass das Kraftwerk die durch Kernspaltung gewonnene Energie in eine andere Energieform umwandelt.
-- 3000 Sonne     --'Sonne' bedeutet, dass das Kraftwerk bzw. Heizwerk Sonnenenergie in eine andere Energieform umwandelt.
-- 4000 Wind      --'Wind' bedeutet, dass das Kraftwerk die Strömungsenergie des Windes in elektrische Energie umwandelt.
-- 5000 Gezeiten  --'Gezeiten' bedeutet, dass das Kraftwerk die kinetische Energie der Meeresgezeiten in elektrische Energie umwandelt.
-- 6000 Erdwärme  --'Erdwärme' bedeutet, dass das Heizwerk die geothermische Energie der Erde nutzt.
-- 7000 Verbrennung --'Verbrennung' bedeutet, dass das Kraftwerk bzw. Heizwerk die durch Verbrennung freiwerdende Energie in eine andere Energieform umwandelt.
-- 7100 Kohle     --'Kohle' bedeutet, dass das Kraftwerk bzw. Heizwerk die durch Verbrennung von Kohle freiwerdende Energie in eine andere Energieform umwandelt.
-- 7200 Öl        --'Öl' bedeutet, dass das Kraftwerk bzw. Heizwerk die durch Verbrennung von Öl freiwerdende Energie in eine andere Energieform umwandelt.
-- 7300 Gas       --'Gas' bedeutet, dass das Kraftwerk bzw. Heizwerk die durch Verbrennung von Gas freiwerdende Energie in eine andere Energieform umwandelt.
-- 7400 Müll, Abfall --'Müll, Abfall' bedeutet, dass das Kraftwerk bzw. Heizwerk die durch Verbrennung von Müll bzw. Abfall freiwerdende Energie in eine andere Energieform umwandelt.


-- 03 REO: ax_Halde
-- -------------------------------------
-- 'Halde' ist eine Fläche, auf der Material langfristig gelagert wird und beschreibt die auch im Relief 
-- zu modellierende tatsächliche Aufschüttung. 
-- Aufgeforstete Abraumhalden werden als Objekte der Objektart 'Wald' erfasst.

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (3, 'Siedlung','ax_halde','Halde', 'Lagergut', null);

-- Classes (Lagergut):
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (3, 1000,'Baustoffe');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (3, 2000,'Kohle');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (3, 4000,'Erde');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (3, 5000,'Schutt');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (3, 6000,'Schlacke');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (3, 7000,'Abraum');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (3, 8000,'Schrott, Altmaterial');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (3, 9999,'Sonstiges');

-- Zustand: 2 Werte


-- 04 ax_Bergbaubetrieb
-- -------------------------------------
-- 'Bergbaubetrieb' ist eine Fläche, die für die Förderung des Abbaugutes unter Tage genutzt wird.

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (4, 'Siedlung','ax_bergbaubetrieb','Bergbaubetrieb', 'Abbaugut', null);

-- Classes (Abbaugut):
-- 'Abbaugut' gibt an, welches Material abgebaut wird.
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 1000,'Erden, Lockergestein', '"Erden, Lockergestein" bedeutet, dass feinkörnige Gesteine abgebaut werden.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 1001,'Ton', '"Ton" ist ein Abbaugut, das aus gelblichem bis grauem Lockergestein besteht und durch Verwitterung älterer Gesteine entsteht.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 1007,'Kalk, Kalktuff, Kreide', '"Kalk, Kalktuff, Kreide" ist ein Abbaugut, das aus erdigem weißen Kalkstein besteht.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 2000,'Steine, Gestein, Festgestein', '"Steine, Gestein, Festgestein" bedeutet, dass grobkörnige oder feste Gesteine abgebaut werden.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 2002,'Schiefer, Dachschiefer', '"Schiefer, Dachschiefer" ist ein toniges Abbaugut, das in dünne ebene Platten spaltbar ist.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 2003,'Metamorpher Schiefer', '"Metamorpher Schiefer" ist ein Abbaugut, dessen ursprüngliche Zusammensetzung und Struktur durch Wärme und Druck innerhalb der Erdkruste verändert worden ist.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 2005,'Kalkstein', '"Kalkstein" ist ein Abbaugut, das als weit verbreitetes Sedimentgestein überwiegend aus Calciumcarbonat besteht.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 2006,'Dolomitstein', '"Dolomitstein" ist ein Abbaugut, das überwiegend aus calcium- und magnesiumhaltigen Mineralien besteht.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 2013,'Basalt, Diabas', '"Basalt, Diabas" ist ein Abbaugut, das aus basischem Ergussgestein besteht.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 2021,'Talkschiefer, Speckstein', '"Talkschiefer, Speckstein" ist ein farbloses bis graugrünes, sich fettig anfühlendes Abbaugut, das aus dem weichen Mineral Talk besteht.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 3000,'Erze', '"Erze" bedeutet, dass die in der Natur vorkommenden, metallhaltigen Mineralien und Mineralgemische abgebaut oder gespeichert werden.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 3001,'Eisen', '"Eisen" wird als Eisenerz abgebaut und durch Verhüttung gewonnen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 3002,'Buntmetallerze', '"Buntmetallerze" ist das Abbaugut, das alle Nichteisenmetallerze als Sammelbegriff umfasst.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 3003,'Kupfer', '"Kupfer" wird als Kupfererz abgebaut und durch Verhüttung gewonnen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 3004,'Blei', '"Blei" wird als Bleierz abgebaut und durch spezielle Verfahren gewonnen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 3005,'Zink', '"Zink" wird als Zinkerz abgebaut und durch spezielle Verfahren gewonnen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 3006,'Zinn', '"Zinn" wird als Zinnerz abgebaut und durch spezielle Verfahren gewonnen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 3007,'Wismut, Kobalt, Nickel', '"Wismut, Kobalt, Nickel" werden als Erze abgebaut und durch spezielle Verfahren gewonnen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 3008,'Uran', '"Uran" wird als Uranerz abgebaut und durch spezielle Verfahren gewonnen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 3009,'Mangan', '"Mangan" wird als Manganerz abgebaut und durch spezielle Verfahren gewonnen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 3010,'Antimon', '"Antimon" wird als Antimonerz abgebaut und durch spezielle Verfahren gewonnen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 3011,'Edelmetallerze', '"Edelmetallerze" ist das Abbaugut, aus dem Edelmetalle (z. B. Gold, Silber) gewonnen werden.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 4000,'Treib- und Brennstoffe', '"Treib- und Brennstoffe" bedeutet, dass die in der Natur vorkommenden brennbaren organischen und anorganischen Substanzen abgebaut oder gewonnen werden.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 4020,'Kohle', '"Kohle" ist ein Abbaugut, das durch Inkohlung (Umwandlungsprozess pflanzlicher Substanzen) entstanden ist.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 4021,'Braunkohle', '"Braunkohle" ist ein Abbaugut, das durch einen bestimmten Grad von Inkohlung (Umwandlungsprozess pflanzlicher Substanzen) entstanden ist.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 4022,'Steinkohle', '"Steinkohle" ist ein Abbaugut, das durch vollständige Inkohlung (Umwandlungsprozess pflanzlicher Substanzen) entstanden ist.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 4030,'Ölschiefer', '"Ölschiefer" ist ein Abbaugut, das aus dunklem, bitumenhaltigem, tonigem Gestein besteht');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 5000,'Industrieminerale, Salze ', '"Industrieminerale, Salze" bedeutet, dass die in der Natur vorkommenden Mineralien abgebaut werden.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 5001,'Gipsstein', '"Gipsstein" ist ein natürliches Abbaugut.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 5002,'Anhydritstein', '"Anhydritstein" ist ein Abbaugut, das aus wasserfreiem Gips besteht.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 5003,'Steinsalz', '"Steinsalz" ist ein Abbaugut, das aus Salzstöcken gewonnen wird und aus Natriumchlorid besteht.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 5004,'Kalisalz', '"Kalisalz" ist ein Abbaugut, das aus Salzstöcken gewonnen wird und aus Chloriden und Sulfaten besteht.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 5005,'Kalkspat', '"Kalkspat" ist ein weißes oder hell gefärbtes Abbaugut (Calciumcarbonat).');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 5006,'Flussspat', '"Flussspat" ist ein Abbaugut, das aus Calciumfluorid besteht.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 5007,'Schwerspat', '"Schwerspat" ist ein formenreiches, rhombisches weißes bis farbiges Abbaugut.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (4, 5011,'Graphit', '"Graphit" ist ein bleigraues, weiches, metallglänzendes Abbaugut, das aus fast reinem Kohlenstoff besteht.');

-- Zustand: 2 Werte


-- 05 REO: ax_TagebauGrubeSteinbruch
-- -------------------------------------
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo) 
VALUES (5, 'Siedlung','ax_tagebaugrubesteinbruch','Tagebau, Grube, Steinbruch', 'Abbaugut', null);

-- Classes (Abbaugut):
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (5, 1000,'Erden, Lockergestein', '"Erden, Lockergestein" bedeutet, dass feinkörnige Gesteine abgebaut werden.');

--Ton 1001 --'Ton' ist ein Abbaugut, das aus gelblichem bis grauem Lockergestein besteht und durch Verwitterung älterer Gesteine entsteht.
--Bentonit 1002 --'Bentonit' ist ein tonartiges Abbaugut, das durch Verwitterung vulkanischer Asche (Tuffe) entstanden ist.
--Kaolin 1003 --'Kaolin' ist ein Abbaugut, das aus weißem, erdigem Gestein, fast reinem Aluminiumsilikat (kieselsaure Tonerde) besteht.
--Lehm 1004 --'Lehm' ist ein Abbaugut, das durch Verwitterung entstanden ist und aus gelb bis braun gefärbtem sandhaltigem Ton besteht.
--Löß, Lößlehm 1005 --'Löß, Lößlehm' ist ein Abbaugut das aus feinsten gelblichen Sedimenten besteht und eine hohe Wasserspeicherfähigkeit aufweist.
--Mergel 1006 --'Mergel' ist ein Abbaugut das aus kalk- und tonartigem Sedimentgestein besteht.
--Kalk, Kalktuff, Kreide 1007 --  'Kalk, Kalktuff, Kreide' ist ein Abbaugut, das aus erdigem weißen Kalkstein besteht.

INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (5, 1008,'Sand', '"Sand" ist ein Abbaugut, das aus kleinen, losen Mineralkörnern (häufig Quarz) besteht.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (5, 1009,'Kies, Kiessand', '"Kies, Kiessand" ist ein Abbaugut, das aus vom Wasser rund geschliffenen Gesteinsbrocken besteht.');

--Farberden 1011 --'Farberden' ist ein Abbaugut, das durch Verwitterung entstanden ist und vorrangig aus eisenhaltigem Gestein besteht.
--Quarzsand 1012 --'Quarzsand' ist ein Abbaugut, das vorwiegend aus kleinen, losen Quarzkörnern besteht.
--Kieselerde 1013 --'Kieselerde' ist ein Abbaugut, das durch tertiäre Binnenseeablagerungen aus Kieselschalen toter Kieselalgen entstanden ist.

INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (5, 2000,'Steine, Gestein, Festgestein', '"Steine, Gestein, Festgestein" bedeutet, dass grobkörnige oder feste Gesteine abgebaut werden.');

--Tonstein 2001 --'Tonstein' ist ein gelblich bis graues Abbaugut, das überwiegend aus Tonmineralien besteht.
--Schiefer, Dachschiefer 2002 --'Schiefer, Dachschiefer' ist ein toniges Abbaugut, das in dünne ebene Platten spaltbar ist.
--Metamorpher Schiefer 2003 --'Metamorpher Schiefer' ist ein Abbaugut, dessen ursprüngliche Zusammensetzung und Struktur durch Wärme und Druck innerhalb der Erdkruste verändert worden ist.
--Mergelstein 2004 --'Mergelstein' ist ein Abbaugut, das sich größtenteils aus Ton und Kalk zusammensetzt.
--Kalkstein 2005 --'Kalkstein' ist ein Abbaugut, das als weit verbreitetes Sedimentgestein überwiegend aus Calciumcarbonat besteht.
--Dolomitstein 2006 --'Dolomitstein' ist ein Abbaugut, das überwiegend aus calcium- und magnesiumhaltigen Mineralien besteht.
--Travertin 2007 --'Travertin' ist ein Abbaugut, das aus gelblichen Kiesel- oder Kalktuffen besteht.
--Marmor 2008 --'Marmor' ist ein Abbaugut, das als rein weißer kristalliner, körniger Kalkstein (Calciumcarbonat) vorkommt.
--Sandstein 2009 --'Sandstein' ist ein Abbaugut, das aus verfestigtem Sedimentgestein besteht.
--Grauwacke 2010 --'Grauwacke' ist ein Abbaugut, das aus tonhaltigem Sandstein besteht und mit Gesteinsbruchstücken angereichert sein kann.
--Quarzit 2011 --'Quarzit' ist ein sehr hartes metamorphes Abbaugut, das vorwiegend aus feinkörnigen Quarzmineralien besteht.
--Gneis 2012 --'Gneis' ist ein metamorphes Abbaugut mit Schieferung, das aus Feldspat, Quarz und Glimmer besteht.
--Basalt, Diabas 2013 --'Basalt, Diabas' ist ein Abbaugut, das aus basischem Ergussgestein besteht.
--Andesit 2014 --'Andesit' ist ein Abbaugut, das aus Ergussgestein besteht.
--Porphyr, Quarzporphyr 2015 --'Porphyr, Quarzporphyr' ist ein eruptiv entstandenes Abbaugut, das aus einer dichten Grundmasse und groben Einsprenglingen besteht.
--Granit 2016 --'Granit' ist ein eruptiv entstandenes Abbaugut, das aus körnigem Feldspat, Quarz, Glimmer besteht.
--Granodiorit 2017 --"Granodiorit" ist ein hell- bis dunkelgraues Abbaugut. Es ist ein mittelkörniges Tiefengestein mit den Hauptbestandteilen Feldspat, Quarz, Hornblende und Biotit.
--Tuff-, Bimsstein 2018 --'Tuff-, Bimsstein' ist ein helles, sehr poröses Abbaugut, das durch rasches Erstarren der Lava entstanden ist.
--Trass 2019 --'Trass' ist ein Abbaugut, das aus vulkanischem Aschentuff (Bimsstein) besteht.

INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (5, 2020,'Lavaschlacke', '"Lavaschlacke" ist ein Abbaugut, das aus ausgestoßenem, geschmolzenen Vulkangestein besteht.');

--Talkschiefer, Speckstein 2021
--'Talkschiefer, Speckstein' ist ein farbloses bis graugrünes, sich fettig anfühlendes Abbaugut, das aus dem weichen Mineral Talk besteht.

INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (5, 4000,'Treib- und Brennstoffe', '"Treib- und Brennstoffe" bedeutet, dass die in der Natur vorkommenden brennbaren organischen und anorganischen Substanzen abgebaut oder gewonnen werden.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (5, 4010,'Torf', '"Torf" ist ein Abbaugut, das aus der unvollkommenen Zersetzung abgestorbener pflanzlicher Substanz unter Luftabschluss in Mooren entstanden ist.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (5, 4020,'Kohle', '"Kohle" ist ein Abbaugut, das durch Inkohlung (Umwandlungsprozess pflanzlicher Substanzen) entstanden ist.');


--Braunkohle 4021 --'Braunkohle' ist ein Abbaugut, das durch einen bestimmten Grad von Inkohlung (Umwandlungsprozess pflanzlicher Substanzen) entstanden ist.
--Steinkohle 4022 --'Steinkohle' ist ein Abbaugut, das durch vollständige Inkohlung (Umwandlungsprozess pflanzlicher Substanzen) entstanden ist.
--Ölschiefer 4030 --'Ölschiefer' ist ein Abbaugut, das aus dunklem, bitumenhaltigen, tonigen Gestein besteht.
--Industrieminerale, Salze 5000 --'Industrieminerale, Salze' bedeutet, dass die in der Natur vorkommenden Mineralien abgebaut werden.
--Gipsstein 5001 --'Gipsstein' ist ein natürliches Abbaugut.
--Anhydritstein 5002 --'Anhydritstein' ist ein Abbaugut, das aus wasserfreiem Gips besteht.
--Kalkspat 5005 --'Kalkspat' ist ein weißes oder hell gefärbtes Abbaugut (Calciumcarbonat).
--Schwerspat 5007 --'Schwerspat' ist ein formenreiches, rhombisches weißes bis farbiges Abbaugut.
--Quarz 5008 --'Quarz' ist ein Abbaugut, das aus verschiedenen Gesteinsarten (Granit, Gneis, Sandstein) gewonnen wird.
--Feldspat 5009 --'Feldspat' ist ein weiß bis grauweißes gesteinsbildendes Mineral von blättrigem Bruch, das abgebaut wird.
--Pegmatitsand 5010 --'Pegmatitsand' ist ein Abbaugut, das durch Verwitterung von Granit und Gneis entstanden ist.
--Sonstiges 9999 --'Sonstiges' bedeutet, dass das Abbaugut bekannt, aber nicht in der Attributwertliste aufgeführt ist.



-- 2. Feld: "Zustand"
-- 2100   Außer Betrieb, stillgelegt, verlassen
-- "Außer Betrieb, stillgelegt; verlassen" bedeutet, dass sich 'Tagebau, Grube, Steinbruch' nicht mehr in regelmäßiger, der Bestimmung entsprechenden Nutzung befindet.


-- 06 REO: ax_FlaecheGemischterNutzung
-- -------------------------------------

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (6, 'Siedlung','ax_flaechegemischternutzung','Fläche gemischter Nutzung', 'Funktion', null);

-- Classes (Funktion):
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (6, 2100,'Gebäude- und Freifläche, Mischnutzung mit Wohnen');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (6, 2110,'Gebäude- und Freifläche, Mischnutzung mit Wohnen / Wohnen mit Öffentlich ');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (6, 2120,'Gebäude- und Freifläche, Mischnutzung mit Wohnen / Wohnen mit Handel und Dienstleistungen');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (6, 2130,'Gebäude- und Freifläche, Mischnutzung mit Wohnen / Wohnen mit Gewerbe und Industrie ');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (6, 2140,'Gebäude- und Freifläche, Mischnutzung mit Wohnen / Öffentlich mit Wohnen');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (6, 2150,'Gebäude- und Freifläche, Mischnutzung mit Wohnen / Handel und Dienstleistungen mit Wohnen');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (6, 2160,'Gebäude- und Freifläche, Mischnutzung mit Wohnen / Gewerbe und Industrie mit Wohnen');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (6, 2700,'Gebäude- und Freifläche Land- und Forstwirtschaft');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (6, 2710,'Gebäude- und Freifläche Land- und Forstwirtschaft / Wohnen');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (6, 2720,'Gebäude- und Freifläche Land- und Forstwirtschaft / Betrieb');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (6, 2730,'Gebäude- und Freifläche Land- und Forstwirtschaft / Wohnen und Betrieb');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (6, 6800,'Landwirtschaftliche Betriebsfläche');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (6, 7600,'Forstwirtschaftliche Betriebsfläche');

-- Art der Bebauung
-- Offen       1000 -- "Offen" beschreibt die Bebauung von 'Fläche gemischter Nutzung', die vorwiegend durch einzelstehende Gebäude charakterisiert wird.
-- Geschlossen 2000 -- "Geschlossen" beschreibt die Bebauung von 'Fläche gemischter Nutzung', die vorwiegend durch zusammenhängende Gebäude charakterisiert wird. Die Gebäudeabdeckung ist in der Regel > 50 Prozent der Fläche.


-- 07 REO: ax_FlaecheBesondererFunktionalerPraegung
-- -------------------------------------
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (7, 'Siedlung','ax_flaechebesondererfunktionalerpraegung','Fläche besonderer funktionaler Prägung', 'Funktion', 'Art der Bebauung');


-- Classes (Funktion):
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (7, 1100,'Öffentliche Zwecke');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (7, 1110,'Öffentliche Zwecke / Verwaltung', '"Verwaltung" bezeichnet eine Fläche auf der vorwiegend Gebäude der öffentlichen Verwaltung, z. B. Rathaus, Gericht, Kreisverwaltung stehen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (7, 1120,'Öffentliche Zwecke / Bildung und Forschung', '"Bildung und Forschung" bezeichnet eine Fläche, auf der vorwiegend Gebäude stehen, in denen geistige, kulturelle und soziale Fähigkeiten vermittelt werden und/oder wissenschaftliche Forschung betrieben wird (z.B. Schulen, Universitäten, Forschungsinstitute).');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (7, 1130,'Öffentliche Zwecke / Kultur', '"Kultur" bezeichnet eine Fläche auf der vorwiegend Anlagen und Gebäude für kulturelle Zwecke, z.B. Konzert- und Museumsgebäude, Bibliotheken, Theater, Schlösser und Burgen sowie Rundfunk- und Fernsehgebäude stehen.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (7, 1140,'Öffentliche Zwecke / Religiöse Einrichtung');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (7, 1150,'Öffentliche Zwecke / Gesundheit, Kur', '"Gesundheit, Kur" bezeichnet eine Fläche auf der vorwiegend Gebäude des Gesundheitswesens stehen, z.B. Krankenhäuser, Heil- und Pflegeanstalten.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (7, 1160,'Öffentliche Zwecke / Soziales', '"Soziales" bezeichnet eine Fläche auf der vorwiegend Gebäude des Sozialwesens stehen, z. B. Kindergärten, Jugend- und Senioreneinrichtungen, Freizeit-, Fremden- und Obdachlosenheime.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (7, 1170,'Öffentliche Zwecke / Sicherheit und Ordnung', '"Sicherheit und Ordnung" bezeichnet eine Fläche auf der vorwiegend Anlagen und Gebäude der Polizei, der Bundeswehr, der Feuerwehr und der Justizvollzugsbehörden stehen.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (7, 1200,'Parken');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (7, 1300,'Historische Anlage');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (7, 1310,'Historische Anlage / Burg-, Festungsanlage');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (7, 1320,'Historische Anlage / Schlossanlage');


--  ++++++  ERFASSUNG BIS HIER AM 09.11.2010 ++++++++


-- 08 REO: ax_SportFreizeitUndErholungsflaeche
-- -------------------------------------
-- 'Sport-, Freizeit- und Erholungsfläche' ist eine bebaute oder unbebaute Fläche, 
-- die dem Sport, der Freizeitgestaltung oder der Erholung dient.

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (8, 'Siedlung','ax_sportfreizeitunderholungsflaeche','Sport-, Freizeit- und Erholungsfläche', 'Funktion', null);

-- Classes:
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4100,'Sportanlage', '"Sportanlage" ist eine Fläche mit Bauwerken und Einrichtungen, die zur Ausübung von (Wettkampf-)sport und für Zuschauer bestimmt ist.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4101,'Gebäude- u. Freifläche Erholung, Sport');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4110,'Golfplatz', '"Golfplatz" ist eine Fläche mit Bauwerken und Einrichtungen, die zur Ausübung des Golfsports genutzt wird.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4120,'Sportplatz');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4130,'Rennbahn');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4140,'Reitplatz');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4150,'Schießanlage');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4160,'Eis-, Rollschuhbahn');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4170,'Tennisplatz');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4200,'Freizeitanlage', '"Freizeitanlage" ist eine Fläche mit Bauwerken und Einrichtungen, die zur Freizeitgestaltung bestimmt ist.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4210,'Zoo', '"Zoo" ist ein Gelände mit Tierschauhäusern und umzäunten Gehegen, auf dem Tiere gehalten und gezeigt werden.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4211,'Gebäude- u. Freifläche Erholung, Zoologie');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4220,'Safaripark, Wildpark', '"Safaripark, Wildpark", ist ein Gelände mit umzäunten Gehegen, in denen Tiere im Freien gehalten und gezeigt werden.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4230,'Freizeitpark', '"Freizeitpark" ist ein Gelände mit Karussells, Verkaufs- und Schaubuden und/oder Wildgattern, das der Freizeitgestaltung dient.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4240,'Freilichttheater', '"Freilichttheater" ist eine Anlage mit Bühne und Zuschauerbänken für Theateraufführungen im Freien.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4250,'Freilichtmuseum', '"Freilichtmuseum" ist eine volkskundliche Museumsanlage, in der Wohnformen oder historische Betriebsformen in ihrer natürlichen Umgebung im Freien dargestellt sind.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4260,'Autokino, Freilichtkino', '"Autokino, Freilichtkino" ist ein Lichtspieltheater im Freien, in dem der Film im Allgemeinen vom Auto aus angesehen wird.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4270,'Verkehrsübungsplatz');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4280,'Hundeübungsplatz');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4290,'Modellflugplatz', '"Modellflugplatz" ist eine Fläche, die zur Ausübung des Modellflugsports dient.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4300,'Erholungsfläche');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4301,'Gebäude- und Freifläche Erholung');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4310,'Wochenend- und Ferienhausfläche', '"Wochenend- und Ferienhausfläche" bezeichnet eine extra dafür ausgewiesene Fläche auf der vorwiegend Wochenend- und Ferienhäuser stehen dürfen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4320,'Schwimmbad, Freibad', '"Schwimmbad, Freibad" ist eine Anlage mit Schwimmbecken oder Anlage an Ufern von Gewässern für den Badebetrieb und Schwimmsport.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4321,'Gebäude- u. Freifläche Erholung, Bad');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4330,'Campingplatz', '"Campingplatz" ist eine Fläche für den Aufbau einer größeren Zahl von Zelten oder zum Abstellen und Benutzen von Wohnwagen mit ortsfesten Anlagen und Einrichtungen.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4331,'Gebäude- u. Freifläche Erholung, Camping');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4400,'Grünanlage', '"Grünanlage" ist eine Anlage mit Bäumen, Sträuchern, Rasenflächen, Blumenrabatten und Wegen, die vor allem der Erholung und Verschönerung des Stadtbildes dient.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4410,'Grünfläche');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4420,'Park', '"Park" ist eine landschaftsgärtnerisch gestaltete Grünanlage, die der Repräsentation und der Erholung dient.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4430,'Botanischer Garten');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4431,'Gebäude- u. Freifläche Erholung, Botanik');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (8, 4440,'Kleingarten', '"Kleingarten" (Schrebergarten) ist eine Anlage von Gartengrundstücken, die von Vereinen verwaltet und verpachtet werden.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4450,'Wochenendplatz');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4460,'Garten');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 4470,'Spielplatz, Bolzplatz');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (8, 9999,'Sonstiges');


-- 09 REO: ax_Friedhof
-- -------------------------------------
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass) -- kein info
VALUES (9, 'Siedlung','ax_friedhof','Friedhof', 'Funktion');

-- Class (Funktion):
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (9, 9401,'Gebäude- und Freifläche Friedhof');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (9, 9402,'Friedhof (ohne Gebäude)');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (9, 9403,'Friedhof (Park)');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (9, 9404,'Historischer Friedhof');


-- ** Verkehr **

-- 10 ax_Strassenverkehr
-- -------------------------------------
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (10, 'Verkehr','ax_strassenverkehr','Straßenverkehr', 'Funktion', 'Zweitname');

-- Class (Funktion):
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (10, 2311,'Gebäude- und Freifläche zu Verkehrsanlagen, Straße');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (10, 2312,'Verkehrsbegleitfläche Straße', '"Verkehrsbegleitfläche Straße" bezeichnet eine bebaute oder unbebaute Fläche, die einer Straße zugeordnet wird. Die "Verkehrsbegleitfläche Straße" ist nicht Bestandteil der Fahrbahn.');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (10, 2313,'Straßenentwässerungsanlage');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (10, 5130,'Fußgängerzone');


-- 11 ax_Weg
-- -------------------------------------

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (11, 'Verkehr','ax_weg','Weg', 'Funktion', 'Bezeichnung');

-- Classes (Funktion):
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (11, 5210,'Fahrweg');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (11, 5211,'Hauptwirtschaftsweg');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (11, 5212,'Wirtschaftsweg');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (11, 5220,'Fußweg');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (11, 5230,'Gang');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (11, 5240,'Radweg');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (11, 5250,'Rad- und Fußweg');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (11, 5260,'Reitweg');
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (11, 9999,'Sonstiges');


-- 12 ax_Platz
-- -------------------------------------

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (12, 'Verkehr','ax_platz','Platz', 'Funktion', 'Zweitname');

-- Classes (Funktion):
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (12, 5130,'Fußgängerzone', '"Fußgängerzone" ist ein dem Fußgängerverkehr vorbehaltener Bereich, in dem ausnahmsweise öffentlicher Personenverkehr, Lieferverkehr oder Fahrradverkehr zulässig sein kann.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (12, 5310,'Parkplatz', '"Parkplatz" ist eine zum vorübergehenden Abstellen von Fahrzeugen bestimmte Fläche.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (12, 5320,'Rastplatz', '"Rastplatz" ist eine Anlage zum Halten, Parken oder Rasten der Verkehrsteilnehmer mit unmittelbarem Anschluss zur Straße ohne Versorgungseinrichtung, ggf. mit Toiletten.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (12, 5330,'Raststätte', '"Raststätte" ist eine Anlage an Verkehrsstraßen mit Bauwerken und Einrichtungen zur Versorgung und Erholung von Reisenden.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (12, 5340,'Marktplatz');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (12, 5350,'Festplatz', '"Festplatz" ist eine Fläche, auf der zeitlich begrenzte Festveranstaltungen stattfinden');


-- 13 ax_Bahnverkehr
-- -------------------------------------

--Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (13, 'Verkehr','ax_bahnverkehr','Bahnverkehr', 'Funktion', 'Bahnkategorie');

-- Classes (Funktion):)
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (13, 2321,'Gebäude- und Freifläche zu Verkehrsanlagen, Schiene');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (13, 2322,'Verkehrsbegleitfläche Bahnverkehr', '"Verkehrsbegleitfläche Bahnverkehr" bezeichnet eine bebaute oder unbebaute, an den Bahnkörper angrenzende Fläche, die dem Schienenverkehr dient.');

-- alternative Kategorie:

-- Bahnkategorie

--Eisenbahn 1100
-- 'Eisenbahn' ist die Bezeichnung für einen schienengebundenen Verkehrsweg, auf dem im Nah- und Fernverkehr Personen befördert und Güter transportiert werden.
--Güterverkehr 1102
-- 'Güterverkehr' ist die Bezeichnung für einen schienengebundenen Verkehrsweg, auf dem im Nah- und Fernverkehr ausschließlich Güter transportiert werden.
--S-Bahn 1104
-- 'S-Bahn' ist die Bezeichnung für einen schienengebundenen Verkehrsweg, der zur schnellen Personenbeförderung in Ballungsräumen dient und meist auf eigenen Gleisen verläuft.
--Stadtbahn 1200
-- 'Stadtbahn' ist die Bezeichnung für einen schienengebundenen Verkehrsweg, auf dem eine elektrisch betriebene Schienenbahn zur Personenbeförderung im öffentlichen Nahverkehr fährt. Sie kann sowohl ober- als auch unterirdisch verlaufen.
--Straßenbahn 1201
-- 'Straßenbahn' ist die Bezeichnung für einen schienengebundenen Verkehrsweg, auf dem eine elektrisch betriebene Schienbahn zur Personenbeförderung fährt. Sie verläuft i. d. R. oberirdisch.
--U-Bahn 1202
-- 'U-Bahn' ist die Bezeichnung für einen schienengebundenen Verkehrsweg, auf dem eine elektrisch betriebene Schienenbahn zur Personenbeförderung in Großstädten fährt. Sie verläuft i. d. R. unterirdisch.
--Seilbahn, Bergbahn 1300
-- 'Seilbahn, Bergbahn' ist die Bezeichnung für einen schienengebundenen Verkehrsweg, auf dem eine Schienenbahn große Höhenunterschiede überwindet.
--Zahnradbahn 1301
-- 'Zahnradbahn' ist die Bezeichnung für einen schienengebundenen Verkehrsweg, auf dem eine Schienenbahn mittels Zahnradantrieb große Höhenunterschiede in stark geneigtem Gelände überwindet.
--Standseilbahn 1302
-- 'Standseilbahn' ist die Bezeichnung für einen schienengebundenen Verkehrsweg, auf dem eine Schienenbahn auf einer stark geneigten, meist kurzen und geraden Strecke verläuft. Mit Hilfe eines oder mehrerer Zugseile wird ein Schienenfahrzeug bergauf gezogen und gleichzeitig ein zweites bergab gelassen.
--Museumsbahn 1400
-- 'Museumsbahn' ist die Bezeichnung für einen schienengebundenen Verkehrsweg, auf dem ausschließlich Touristen in alten, meist restaurierten Zügen befördert werden.
--Magnetschwebebahn 1600
-- 'Magnetschwebebahn' ist die Bezeichnung für einen schienengebundenen Verkehrsweg, auf dem räderlose Schienenfahrzeuge mit Hilfe von Magnetfeldern an oder auf einer Fahrschiene schwebend entlanggeführt werden.


-- 14 ax_Flugverkehr
-- -------------------------------------

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (14, 'Verkehr','ax_flugverkehr','Flugverkehr', 'Art', 'Bezeichnung');

-- Classes (Funktion):
--INSERT INTO nutzung_class (nutz_id, class, label) VALUES (14, 5501,'Gebäude- und Freifläche zu Verkehrsanlagen, Luftfahrt');

-- Classes (Art):
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (14, 5510,'Flughafen', '"Flughafen" ist eine Anlage mit Gebäuden, Bauwerken, Start- und Landebahnen sowie sonstigen flugtechnischen Einrichtungen zur Abwicklung des Flugverkehrs.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (14, 5511,'Internationaler Flughafen', '"Internationaler Flughafen" ist ein Flughafen, der in der Luftfahrtkarte 1 : 500000 (ICAO) als solcher ausgewiesen ist.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (14, 5512,'Regionalflughafen', '"Regionalflughafen" ist ein Flughafen der gemäß Raumordnungsgesetz als Regionalflughafen eingestuft ist.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (14, 5520,'Verkehrslandeplatz', '"Verkehrslandeplatz" ist ein Flugplatz, der in der Luftfahrtkarte 1:500000 (ICAO) als solcher ausgewiesen ist.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (14, 5530,'Hubschrauberflugplatz', '"Hubschrauberflugplatz" ist ein Flugplatz, der in der Luftfahrtkarte 1:500000 (ICAO) als solcher ausgewiesen ist.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (14, 5540,'Landeplatz, Sonderlandeplatz', '"Landeplatz, Sonderlandeplatz" ist eine Fläche, die in der Luftfahrtkarte 1:500000 (ICAO) als Landeplatz, Sonderlandeplatz ausgewiesen ist.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (14, 5550,'Segelfluggelände', '"Segelfluggelände" ist eine Fläche, die in der Luftfahrtkarte 1:500000 (ICAO) als Segelfluggelände ausgewiesen ist.');


-- Nutzung:

--Zivil 1000
-- "Zivil" bedeutet, dass 'Flugverkehr' privaten, öffentlichen oder religiösen Zwecken dient und nicht militärisch genutzt wird.
--Militärisch 2000
-- "Militärisch" bedeutet, dass 'Flugverkehr' nur von Streitkräften genutzt wird.
--Teils zivil, teils militärisch 3000
-- "Teils zivil, teils militärisch" bedeutet dass ''Flugverkehr' sowohl zivil als auch militärisch genutzt wird.



-- 15 ax_Schiffsverkehr
-- -------------------------------------

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass)  -- keine info
VALUES (15, 'Verkehr','ax_schiffsverkehr','Schiffsverkehr', 'Funktion');

-- Classes (Funktion):
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (15, 2341,'Gebäude und Freifläche zu Verkehrsanlagen, Schifffahrt');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (15, 5610,'Hafenanlage (Landfläche)', '"Hafenanlage (Landfläche)" bezeichnet die Fläche innerhalb von "Hafen", die nicht von Wasser bedeckt ist und die ausschließlich zum Betrieb des Hafens dient.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (15, 5620,'Schleuse (Landfläche)', '"Schleuse (Landfläche)" bezeichnet die Fläche innerhalb von "Schleuse", die nicht von Wasser bedeckt ist und die ausschließlich zum Betrieb der Schleuse dient..');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (15, 5630,'Anlegestelle');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (15, 5640,'Fähranlage');


-- ** Objektartengruppe: Vegetation **

-- Die Objektartengruppe mit der Bezeichnung 'Vegetation' und der Kennung '43000' 
-- umfasst die Flächen außerhalb der Ansiedlungen, die durch land- oder forstwirtschaftliche Nutzung, 
-- durch natürlichen Bewuchs oder dessen Fehlen geprägt werden.


-- 16 ax_Landwirtschaft
-- -------------------------------------
-- 'Landwirtschaft' ist eine Fläche für den Anbau von Feldfrüchten sowie eine Fläche, 
-- die beweidet und gemäht werden kann, einschließlich der mit besonderen Pflanzen angebauten Fläche. 
-- Die Brache, die für einen bestimmten Zeitraum (z. B. ein halbes oder ganzes Jahr) landwirtschaftlich unbebaut bleibt, 
-- ist als 'Landwirtschaft' bzw. 'Ackerland' zu erfassen.

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass)
VALUES (16, 'Vegetation','ax_landwirtschaft','Landwirtschaft', 'Vegetationsmerkmal');

-- Classes:
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (16, 1010,'Ackerland', '"Ackerland" ist eine Fläche für den Anbau von Feldfrüchten (z.B. Getreide, Hülsenfrüchte, Hackfrüchte) und Beerenfrüchten (z.B. Erdbeeren). Zum Ackerland gehören auch die Rotationsbrachen, Dauerbrachen sowie Flächen, die zur Erlangung der Ausgleichszahlungen der EU stillgelegt worden sind.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (16, 1011,'Streuobstacker', '"Streuobstacker" beschreibt den Bewuchs einer Ackerfläche mit Obstbäumen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (16, 1012,'Hopfen', '"Hopfen" ist eine mit speziellen Vorrichtungen ausgestattete Agrarfläche für den Anbau von Hopfen.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (16, 1013,'Spargel');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (16, 1020,'Grünland', '"Grünland" ist eine Grasfläche, die gemäht oder beweidet wird.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (16, 1021,'Streuobstwiese', '"Streuobstwiese" beschreibt den Bewuchs einer Grünlandfläche mit Obstbäumen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (16, 1030,'Gartenland', '"Gartenland" ist eine Fläche für den Anbau von Gemüse, Obst und Blumen sowie für die Aufzucht von Kulturpflanzen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (16, 1031,'Baumschule', '"Baumschule" ist eine Fläche, auf der Holzgewächse aus Samen, Ablegern oder Stecklingen unter mehrmaligem Umpflanzen (Verschulen) gezogen werden.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (16, 1040,'Weingarten', '"Weingarten" ist eine mit speziellen Vorrichtungen ausgestattete Agrarfläche auf der Weinstöcke angepflanzt sind.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (16, 1050,'Obstplantage', '"Obstplantage" ist eine landwirtschaftliche Fläche, die mit Obstbäumen und Obststräuchern bepflanzt ist');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (16, 1051,'Obstbaumplantage', '"Obstbaumplantage" ist eine landwirtschaftliche Fläche, die ausschließlich mit Obstbäumen bepflanzt ist.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (16, 1052,'Obststrauchplantage');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (16, 1200,'Brachland', '"Brachland" ist eine Fläche der Landwirtschaft, die seit längerem nicht mehr zu Produktionszwecken genutzt wird.');


-- 17 ax_Wald
-- -------------------------------------
-- 'Wald' ist eine Fläche, die mit Forstpflanzen (Waldbäume und Waldsträucher) bestockt ist.

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (17, 'Vegetation','ax_wald','Wald', 'Vegetationsmerkmal', 'Bezeichnung');

-- Classes (Vegetationsmerkmal):
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (17, 1100,'Laubholz', '"Laubholz" beschreibt den Bewuchs einer Vegetationsfläche mit Laubbäumen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (17, 1200,'Nadelholz', '"Nadelholz" beschreibt den Bewuchs einer Vegetationsfläche mit Nadelbäumen.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (17, 1300,'Laub- und Nadelholz', '"Laub- und Nadelholz" beschreibt den Bewuchs einer Vegetationsfläche mit Laub- und Nadelbäumen.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (17, 1310,'Laubwald mit Nadelholz');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (17, 1320,'Nadelwald mit Laubholz');


-- 18 ax_Gehoelz
-- -------------------------------------

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (18, 'Vegetation','ax_gehoelz','Gehölz','Funktion', 'Vegetationsmerkmal');

-- Classes (VEG)
--INSERT INTO nutzung_class (nutz_id, class, label) VALUES (18, 1400,'Latschenkiefer');

-- Classes (Funktion)
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (18, 1000,'Windschutz');


-- 19 ax_Heide
-- -------------------------------------
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title)
VALUES (19, 'Vegetation','ax_heide','Heide');

-- Keine Classes


-- 20 ax_Moor
-- -------------------------------------
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title)
VALUES (20, 'Vegetation','ax_moor','Moor');

-- Keine Classes


-- 21 ax_Sumpf
-- -------------------------------------
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title)
VALUES (21, 'Vegetation','ax_sumpf','Sumpf');

-- Keine Classes


-- 22 ax_UnlandVegetationsloseFlaeche
-- -------------------------------------

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (22, 'Vegetation','ax_unlandvegetationsloseflaeche','Unland, vegetationslose Fläche', 'Funktion', 'Oberflächenmaterial');

-- Classes (Funktion):
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (22, 1000,'Vegetationslose Fläche', '"Vegetationslose Fläche" ist eine Fläche ohne nennenswerten Bewuchs aufgrund besonderer Bodenbeschaffenheit.');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (22, 1100,'Gewässerbegleitfläche', '"Gewässerbegleitfläche" bezeichnet eine bebaute oder unbebaute Fläche, die einem Fließgewässer zugeordnet wird. Die Gewässerbegleitfläche ist nicht Bestandteil der Gewässerfläche.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (22, 1110,'Bebaute Gewässerbegleitfläche');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (22, 1120,'Unbebaute Gewässerbegleitfläche');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (22, 1200,'Sukzessionsfläche', '"Sukzessionsfläche" ist eine Fläche, die dauerhaft aus der landwirtschaftlichen oder sonstigen bisherigen Nutzung herausgenommen ist und die in den Urzustand z. B. Gehölz, Moor, Heide übergeht.');

-- Info (Oberflächenmaterial)
--INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (22, 1010,'Fels',             '"Fels" bedeutet, dass die Erdoberfläche aus einer festen Gesteinsmasse besteht.');
--INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (22, 1020,'Steine, Schotter', '"Steine, Schotter" bedeutet, dass die Erdoberfläche mit zerkleinertem Gestein unterschiedlicher Größe bedeckt ist.');
--INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (22, 1030,'Geröll',           '"Geröll" bedeutet, dass die Erdoberfläche mit durch fließendes Wasser abgerundeten Gesteinen bedeckt ist.');
--INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (22, 1040,'Sand',             '"Sand" bedeutet, dass die Erdoberfläche mit kleinen, losen Gesteinskörnern bedeckt ist.');
--INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (22, 1110,'Schnee',           '"Schnee" bedeutet, dass die Erdoberfläche für die größte Zeit des Jahres mit Schnee bedeckt ist.');
--INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (22, 1120,'Eis, Firn',        '"Eis, Firn" bedeutet, dass die Erdoberfläche mit altem, grobkörnigem, mehrjährigem Schnee im Hochgebirge bedeckt ist, der unter zunehmendem Druck zu Gletschereis wird.');


-- ** Gewässer **

-- 24 ax_Fliessgewaesser
-- -------------------------------------
-- 'Fließgewässer' ist ein geometrisch begrenztes, oberirdisches, auf dem Festland fließendes Gewässer, 
-- das die Wassermengen sammelt, die als Niederschläge auf die Erdoberfläche fallen oder in Quellen austreten, 
-- und in ein anderes Gewässer, ein Meer oder in einen See transportiert
--   oder
-- in einem System von natürlichen oder künstlichen Bodenvertiefungen verlaufendes Wasser, 
-- das zur Be- und Entwässerung an- oder abgeleitet wird
--   oder
-- ein geometrisch begrenzter, für die Schifffahrt angelegter künstlicher Wasserlauf, 
-- der in einem oder in mehreren Abschnitten die jeweils gleiche Höhe des Wasserspiegels besitzt.

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass)
VALUES (24, 'Gewässer','ax_fliessgewaesser','Fließgewässer', 'Funktion');

-- Classes (Funktion):
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (24, 8200,'Fluss');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (24, 8210,'Altwasser');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (24, 8220,'Altarm');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (24, 8230,'Flussmündungstrichter', '"Flussmündungstrichter" ist der Bereich des Flusses im Übergang zum Meer. Er beginnt dort, wo die bis dahin etwa parallel verlaufenden Ufer des Flusses sich trichterförmig zur offenen See hin erweitern. Die Abgrenzungen der Flussmündungstrichter ergeben sich aus dem Bundeswasserstraßengesetz (meerseitig) und den Bekanntmachungen der Wasser- und Schifffahrtsverwaltung sowie höchst-richterlicher Rechtsprechung (binnenseitig).');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (24, 8300,'Kanal', '"Kanal" ist ein für die Schifffahrt angelegter, künstlicher Wasserlauf.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (24, 8400,'Graben');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (24, 8410,'Fleet');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (24, 8500,'Bach');


-- 25 ax_Hafenbecken
-- -------------------------------------

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (25, 'Gewässer','ax_hafenbecken','Hafenbecken', 'Funktion', 'Nutzung');

-- Classes (Funktion):
INSERT INTO nutzung_class (nutz_id, class, label) VALUES (25, 8810,'Sportboothafenbecken');

-- Nutzung:

-- Zivil 1000
-- 'Zivil' bedeutet, dass 'Hafenbecken' privaten oder öffentlichen Zwecken dient und nicht militärisch genutzt wird.
-- Militärisch 2000
-- 'Militärisch' bedeutet, dass 'Hafenbecken' nur von Streitkräften genutzt wird.
-- Teils zivil, teils militärisch 3000
-- 'Teils zivil, teils militärisch' bedeutet, dass 'Hafenbecken' sowohl zivil als auch militärisch genutzt wird.


-- 26 ax_StehendesGewaesser
-- -------------------------------------

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (26, 'Gewässer','ax_stehendesgewaesser','stehendes Gewässer', 'Funktion', 'Gewässerkennziffer');

-- Classes (Funktion):
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (26, 8610,'See');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (26, 8620,'Teich');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (26, 8630,'Stausee');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (26, 8631,'Speicherbecken');
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (26, 8640,'Baggersee', '"Baggersee" ist ein künstlich geschaffenes Gewässer, aus dem Bodenmaterial gefördert wird.');
INSERT INTO nutzung_class (nutz_id, class, label)         VALUES (26, 9999,'Sonstiges');

-- hydrologischesMerkmal
--  2000   Nicht ständig Wasser führend
--  "Nicht ständig Wasser führend" heißt, dass ein Gewässer nicht ganzjährig Wasser führt.


-- 27 ax_meer
-- -------------------------------------

-- Metadaten:
INSERT INTO nutzung_meta (nutz_id, gruppe, source_table, title, fldclass, fldinfo)
VALUES (27, 'Gewässer','ax_meer','Meer', 'Funktion', 'Bezeichnung');

-- Classes (Funktion):
INSERT INTO nutzung_class (nutz_id, class, label, blabla) VALUES (27, 8710,'Küstengewässer', '"Küstengewässer" ist die Fläche zwischen der Küstenlinie bei mittlerem Hochwasser oder der seewärtigen Begrenzung der oberirdischen Gewässer und der seewärtigen Begrenzung des deutschen Hoheitsgebietes. Dem mittleren Hochwasser ist der mittlere Wasserstand der Ostsee gleichzusetzen.');


--tidemerkmal:

-- Mit Tideeinfluss 1000
-- "Mit Tideeinfluss" sind periodische Änderungen des Wasserspiegels und horizontale Bewegungen des Wassers, hervorgerufen durch die Massenanziehungs- und Fliehkräfte des Systems Sonne, Mond und Erde in Verbindung mit der Erdrotation.


-- END --