Die plpgsql-Funktion grid() benötigt drei Parameter:

$1: Name (text) der neu zu erstellenden Tabelle, die die Geometrie der Kacheln enthalten wird (DROP IF EXISTS).
$2: Name der Geometriespalte (geometry), über deren Bounding Box die vier Eckkoordinaten für die Kachelung
	abgeleitet werden.
$3: Zahlenwert (integer), der angibt, wie groß eine Kantenlänge der Kachel sein soll (Angabe in Meter).

Beispielaufruf:
	SELECT grid('meine_kachel_2km', wkb_geometry, 2000) FROM map_landesflaeche 

Wichtig: 
	Sollen Kacheln für die Landesfläche erstellt werden, müssen die zugrunde liegenden Daten bereits
	zu einem Polygon zusammengefasst worden sein.

=> FALSCH:	
	SELECT grid('meine_kachel_2km', wkb_geometry, 2000) FROM ax_kommunalesgebiet

=> RICHTIG:
	SELECT grid('meine_kachel_2km', ST_Union(wkb_geometry), 2000) FROM ax_kommunalesgebiet

