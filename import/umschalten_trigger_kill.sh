#!/bin/bash
# Den Symlink in diesem Ordner so setzen, dass die neuen PostNAS-Datenbanken 
# mit dem Trigger OHNE Historie angelegt werden

rm alkis-trigger.sql

#       Ziel                     Link-Name                
ln -s   alkis-trigger-kill.sql   alkis-trigger.sql

echo "Die ab jetzt neu angelegten ALKIS PostNAS-Datenbanken werden  O H N E  Historie getriggert."
