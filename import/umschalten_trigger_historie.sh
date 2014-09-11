#!/bin/bash
# Den Symlink in diesem Ordner so setzen, dass die neuen PostNAS-Datenbanken 
# mit dem Trigger MIT Historie angelegt werden

rm alkis-trigger.sql

#       Ziel                     Link-Name
ln -s   alkis-trigger-hist.sql   alkis-trigger.sql

echo "Die ab jetzt neu angelegten ALKIS PostNAS-Datenbanken werden  M I T  Historie getriggert."
