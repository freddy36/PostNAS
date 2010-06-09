#!/bin/sh
# Konvertierung ALKIS NAS-Format nach PostGIS
# Stand 
#  2010-01-22
#  2010-01-26  postgreSQL 8.3 auf Port 5432
# PostNAS 
#  - Version    0.5 (12.2009)
#  - GeoInfoDoc 6.0
# Demo-Daten Rheinland-Pfalz
# mapserver = 10.0.1.46
/opt/gdal-1.7/bin/ogr2ogr -f "PostgreSQL" \
	PG:"dbname=alkis05rlp user=xxxx host=localhost port=5432 password=xxxx" \
	-a_srs EPSG:25832  -append \
	/data/konvert/nas_daten/rlp/gm2566-testdaten-gid60-2008-11-11.xml
#