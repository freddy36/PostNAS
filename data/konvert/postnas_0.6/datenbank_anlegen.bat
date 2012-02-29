@echo off
REM ------------------------------------------------
REM Konvertierung von ALKIS NAS-Format nach PosGIS -
REM Teil 1: Eine neue PostGIS-Datenbank anlegen    -
REM ------------------------------------------------
REM
REM Delete old Logfiles
del ..\log_*.txt
del ..\err_*.txt

echo ==============================================================================
REM Disclaimer
echo.
echo DISCLAIMER: PostNAS Skript zum Anlegen einer Datenbank. USE AT YOUR OWN RISK!
echo Das Skript erzeigt eine Datenbank und spielt das PostNAS Schema ein
echo 
echo.
echo Voraussetzungen:
echo - laufenden PostgreSQL 8.x Datenbank
echo - Databankbenutzer mit Schreibzugriff 
echo - PATH Variable zu psql
echo.
echo Ist alles vorbereitet?
echo Diese Argumente müssen übergeben werden:
echo "%0 <HOST> <PORT> <DBNAME> <DBTEMPLATE> <DBUSER> <DropDB ja/nein>"
echo.
echo z. B.
echo %0 %DBHOST% %DBPORT% alkis_import template_postgis alkis_user ja

echo.
echo ==============================================================================
echo.
REM 5 Params expected
if not %5x==x goto ARGSSUPPLIED

echo Continue?
set /p PREPARED="(y)es or (n)o:"
if %PREPARED%x==x goto :PREP

if %PREPARED%==y goto :PREP_OK
if %PREPARED%==n goto :End
goto :PREP
:PREP_OK

:ARGSSUPPLIED
set DBHOST=%1
set DBPORT=%2
set DBNAME=%3
set DBTEMPLATE=%4
set DBUSER=%5
set DROPDB=%6
echo.

:CHOICES
REM dbtype and encoding are fixed
set USEDBTYPE=PostgreSQL
set USEDBENC=UTF-8
echo.
echo Ihre Angaben:
echo Databasetype: %USEDBTYPE%
echo Encoding: %USEDBENC%
echo Database Host: %DBHOST%
echo Database Port: %DBPORT%
echo Database Name: %DBNAME%
echo Database Template: %DBTEMPLATE%
echo Database User: %DBUSER%
echo Datenbank %DBNAME% löschen: %DROPDB%
echo.
echo Installation starten?
echo.
rem delete ARG#5
shift
set /p START_INSTALL="(y)es or (n)o? "
if %START_INSTALL%x==x goto CHOICES
if %START_INSTALL%==y goto START_INSTALL
goto PREP
:START_INSTALL
rem echo on

:INSTPOSTGRESQL
REM do these exist?
psql --version 2> nul 1> nul
if NOT %ERRORLEVEL% == 0 goto PGNOTFOUND

if %DROPDB%==ja goto START_DROPDB
if %DROPDB%==no goto START_CREATE
goto :START_CREATE
:START_DROPDB
echo dropdb
echo dropdb -U %DBUSER% -h %DBHOST% -p %DBPORT% %DBNAME%
dropdb -U %DBUSER% -h %DBHOST% -p %DBPORT% %DBNAME%


:START_CREATE
echo creatingdb
echo createdb -U %DBUSER% -h %DBHOST% -p %DBPORT% -T %DBTEMPLATE% -E UTF8 %DBNAME%
createdb -U %DBUSER% -h %DBHOST% -p %DBPORT% -T %DBTEMPLATE% -E UTF8 %DBNAME%
psql -U %DBUSER% -h %DBHOST% -p %DBPORT% -f alkis_PostNAS_0.6_schema.sql %DBNAME%  2>> ..\log_alkis_schema.txt
psql -U %DBUSER% -h %DBHOST% -p %DBPORT% -f alkis_PostNAS_0.6_keytables.sql %DBNAME%  2>> ..\log_alkis_keytables.txt
psql -U %DBUSER% -h %DBHOST% -p %DBPORT% -f nutzungsart_definition.sql %DBNAME%  2>> ..\log_alkis_nutzungsart_definition.txt
psql -U %DBUSER% -h %DBHOST% -p %DBPORT% -f nutzungsart_metadaten.sql %DBNAME%  2>> ..\log_alkis_nutzungsart_metadaten.txt
psql -U %DBUSER% -h %DBHOST% -p %DBPORT% -f gemeinden_definition.sql %DBNAME%  2>> ..\log_alkis_gemeinden_definition.txt
psql -U %DBUSER% -h %DBHOST% -p %DBPORT% -f sichten.sql %DBNAME%  2>> ..\log_alkis_sichten.txt
goto END:



:PGNOTFOUND
echo Sorry, psql not found, must be in PATH-Variable, exiting...
goto END

REM End, keep Terminal session open
:END

echo Die Datenbank wurde erzeugt. Prüfen Sie die Logdateien.
echo.
pause 