Diese ReadMe-Datei soll Sie auf die zu ändernden Parameter 
hinweisen die umgebungsspezifisch gesetzt werden müssen.

Anmerkung:
Voraussetzung ist ein UMN MapServer ab der Version 6.2 

Umgebungsanpassungen:

#######################
# /data/umn/alkis/alkis_muster.map #
#######################

1. Die ONLINERESOURCEN müssen auf das eigene System umgestellt werden. 
- wms_onlineresource "..."

2. Der EXTENT (Ausdehnung) ist auf die Geodaten anzupassen, 
ggf. muss auch der Parameter UNIT verändert werden.   
- EXTENT <Xmin> <Ymin> <Xmax> <Ymax>
- UNITS <Einheit>


####################################################################################
# Layer
####################################################################################

1.  Der CONNECTION-String zu der Datenbank ist anzupassen.
- CONNECTION "host=<IP> dbname=<Datenbankname> user=<datenbankuser>"


  
######################################################
# /data/umn/alkis/cgi-bin/alkis.xml #
######################################################
1. Die Datei ist ausführbar zu machen
2. In der Datei ist der Pfad zum Mapfile und UMN-MapServer zu setzen:
- export MS_MAPFILE=<Pfad_zum_Mapfile>
- exec <Pfad_zum_UMN-MapServer>

Test-Aufruf: http://localhost/cgi-bin/alkis.xml?REQUEST=GetCapabilities&SERVICE=WMS&VERSION=1.1.1

Mehr Informationen unter (u.a. Windows):
 http://mapserver.gis.umn.edu/docs/howto/wms_server/#more-about-the-online-resource-url
  
  