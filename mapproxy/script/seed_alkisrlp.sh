#!/bin/bash
# MapProxy-Kacheln auf Vorrat generieren
# 2011-09-06
# Doku: http://mapproxy.org/docs/1.1.1/seed.html
# Ausfuehren mit "sudo su www-data"
echo "MapProxy seeding ALKIS DEMO Mustermonzel"
echo "** Bitte ausfuehren als User www-data"
#
  mapproxy-seed --proxy-conf=/data/mapproxy/projects/alkisrlp.yaml  \
                --seed-conf=/data/mapproxy/seed/alkisrlp.yaml  \
                --concurrency 1  \
                --seed  alkisrlp 
#
  mapproxy-seed --proxy-conf=/data/mapproxy/projects/alkisrlp.yaml  \
                --seed-conf=/data/mapproxy/seed/alkisrlp.yaml  \
                --concurrency 1  \
                --seed  alkisrlp_nutzg 
#