#!/bin/sh
# Konvertierung ALKIS NAS-Format nach PostGIS
# Datenbank fuer die ALKIS-Demo im Internet
#
# Stand:
#  2010-01-22
#  2010-01-26  postgreSQL 8.3 auf Port 5432
#  2010-10-14  gdal 1.8 compile aus svn gdal-trunk
#  2010-11-08  Nutzungsarten
#  2010-11-10  Eingebadatei
#
# PostNAS 
#  - Version    0.5 (11.2010)
#  - gdal       1.8
#  - GeoInfoDoc 6.0
# Demo-Daten Rheinland-Pfalz
# mapserver = 10.0.1.46
#
/opt/gdal-1.8/bin/ogr2ogr -f "PostgreSQL" \
	PG:"dbname=alkis05rlpneu user=b600352 host=localhost port=5432" \
	-a_srs EPSG:25832  -append \
	/data/konvert/nas_daten/rlp/Bestandsdatenauszug-Mustermonzel-06.05.2010.xml
## alt?
#	/data/konvert/nas_daten/rlp/gm2566-testdaten-gid60-2008-11-11.xml
#
echo "** Optimierte Tabellen neu Laden:"
psql -p 5432 -d alkis05rlpneu -U b600352 < /data/konvert/postnas_0.5/alkis_nutzungsart_laden.sql
psql -p 5432 -d alkis05rlpneu -U b600352 < /data/konvert/postnas_0.5/alkis_gemeinden_laden.sql
#