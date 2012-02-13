#!/bin/sh
## ------------------------------------------------------------------------------
## In einem Ordner wird jede NAS-Datei einzeln in ein Zip-Archiv komprimiert.
## Die ursprüngliche NAS-Datei wird dabei entfernt: Parameter "-m" (move).
## ------------------------------------------------------------------------------
## Stand: 
##  2011-07-25  PostNAS 07, Umbenennung
##
  echo "**************************************************"
  echo "**   NAS-Dateien in einem Ordner zippen         **"
  echo "**************************************************"
  ORDNER=$1
  if [ $ORDNER = '' ]
  then
    echo "Parameter 1 'Ordner' fehlt"
    $ORDNER = '.'
    exit 1
  fi
  echo "*** Ordner = '${ORDNER}'"
  cd ${ORDNER}
  echo " "
  ls
  for nasdatei in *.xml ; do 
    echo "  * Datei: " $nasdatei
    #      Archiv           NAS-datei
    zip -m ${nasdatei}.zip  ${nasdatei}
  done
  ls
  echo "** E n d e  -  Zippen des Ordners '${ORDNER}'"
##