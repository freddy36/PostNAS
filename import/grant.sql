-- =====
-- ALKIS
-- =====

-- Berechtigungen zu ALKIS fuer Mapserver (WMS)

-- User
--  "ms6"  = User 'Mapserver, Version 6.x',   aus Mapfile = Karten-Rendering
--  "mb27" = User 'Mapbender, Version 2.7.x', aus Buchwerk-Navigation, PlugIn des Clients

--  2012-02-17  PostNAS 0.7, pp_Tabellen, ms5 -> ms6
--  2012-04-25  Tabelle pp_flurstueck_nr
--  2013-01-15  mehr Schlüsseltabellen rein
--  2013-03-05  View "s_beschriftung" wird durch "ap_pto_stra" und "ap_pto_rest" ersetzt.
--              View "s_nummer_nebengebaeude" wird durch "lfdnr_nebengebaeude" ersetzt.
--  2013-03-25  View "grenzpunkt" und "gebaeude_txt"
--  2013-04-19  Neues zum Thema "Bodenschätzung", Views entfallen
--  2013-10-24  Table "pp_strassenname" ersetzt View "ap_pto_stra" im WMS (ms6)
--  2014-01-22  Neue Views für CSV-Export, neue Schlüsseltabelle "ax_namensnummer_eigentuemerart"
--  2014-09-08  PostNAS 0.8 ohne "alkis_beziehungen"


-- Tabellen
-- ========

-- PostGIS
-- -------
  GRANT SELECT ON TABLE geometry_columns TO ms6;
  GRANT SELECT ON TABLE geometry_columns TO mb27;
  GRANT SELECT ON TABLE spatial_ref_sys  TO ms6;
  GRANT SELECT ON TABLE spatial_ref_sys  TO mb27;

-- ALKIS / PostNAS
-- ---------------
-- Berechtigung für Kartendarstellung
--GRANT SELECT ON TABLE alkis_beziehungen TO ms6;
  GRANT SELECT ON TABLE ap_darstellung TO ms6;
  GRANT SELECT ON TABLE ap_lpo TO ms6;
  GRANT SELECT ON TABLE ap_lto TO ms6;
  GRANT SELECT ON TABLE ap_ppo TO ms6;
  GRANT SELECT ON TABLE ap_pto TO ms6;
  GRANT SELECT ON TABLE ax_anderefestlegungnachwasserrecht TO ms6;
  GRANT SELECT ON TABLE ax_anschrift TO ms6;
  GRANT SELECT ON TABLE ax_aufnahmepunkt TO ms6;
  GRANT SELECT ON TABLE ax_bahnverkehr TO ms6;
  GRANT SELECT ON TABLE ax_bahnverkehrsanlage TO ms6;
  GRANT SELECT ON TABLE ax_baublock TO ms6;
  GRANT SELECT ON TABLE ax_bauraumoderbodenordnungsrecht TO ms6;
  GRANT SELECT ON TABLE ax_bauteil TO ms6;
  GRANT SELECT ON TABLE ax_bauwerkimgewaesserbereich TO ms6;
  GRANT SELECT ON TABLE ax_bauwerkimverkehrsbereich TO ms6;
  GRANT SELECT ON TABLE ax_bauwerkoderanlagefuerindustrieundgewerbe TO ms6;
  GRANT SELECT ON TABLE ax_bauwerkoderanlagefuersportfreizeitunderholung TO ms6;
  GRANT SELECT ON TABLE ax_bergbaubetrieb TO ms6;
  GRANT SELECT ON TABLE ax_besondereflurstuecksgrenze TO ms6;
  GRANT SELECT ON TABLE ax_besonderegebaeudelinie TO ms6;
  GRANT SELECT ON TABLE ax_besondererbauwerkspunkt TO ms6;
  GRANT SELECT ON TABLE ax_besonderergebaeudepunkt TO ms6;
  GRANT SELECT ON TABLE ax_besonderertopographischerpunkt TO ms6;
  GRANT SELECT ON TABLE ax_bewertung TO ms6;
  GRANT SELECT ON TABLE ax_bodenschaetzung TO ms6;
  GRANT SELECT ON TABLE ax_boeschungkliff TO ms6;
  GRANT SELECT ON TABLE ax_boeschungsflaeche TO ms6;
  GRANT SELECT ON TABLE ax_buchungsblatt TO ms6;
  GRANT SELECT ON TABLE ax_buchungsblattbezirk TO ms6;
  GRANT SELECT ON TABLE ax_buchungsstelle TO ms6;
  GRANT SELECT ON TABLE ax_bundesland TO ms6;
  GRANT SELECT ON TABLE ax_dammwalldeich TO ms6;
  GRANT SELECT ON TABLE ax_denkmalschutzrecht TO ms6;
  GRANT SELECT ON TABLE ax_dienststelle TO ms6;
  GRANT SELECT ON TABLE ax_felsenfelsblockfelsnadel TO ms6;
  GRANT SELECT ON TABLE ax_firstlinie TO ms6;
  GRANT SELECT ON TABLE ax_flaechebesondererfunktionalerpraegung TO ms6;
  GRANT SELECT ON TABLE ax_flaechegemischternutzung TO ms6;
  GRANT SELECT ON TABLE ax_fliessgewaesser TO ms6;
  GRANT SELECT ON TABLE ax_flugverkehr TO ms6;
  GRANT SELECT ON TABLE ax_flurstueck TO ms6;
  GRANT SELECT ON TABLE ax_friedhof TO ms6;
  GRANT SELECT ON TABLE ax_gebaeude TO ms6;
  GRANT SELECT ON TABLE ax_gehoelz TO ms6;
  GRANT SELECT ON TABLE ax_gemarkung TO ms6;
  GRANT SELECT ON TABLE ax_gemarkungsteilflur TO ms6;
  GRANT SELECT ON TABLE ax_gemeinde TO ms6;
  GRANT SELECT ON TABLE ax_georeferenziertegebaeudeadresse TO ms6;
  GRANT SELECT ON TABLE ax_gewaessermerkmal TO ms6;
  GRANT SELECT ON TABLE ax_gleis TO ms6;
  GRANT SELECT ON TABLE ax_grablochderbodenschaetzung TO ms6;
  GRANT SELECT ON TABLE ax_grenzpunkt TO ms6;
  GRANT SELECT ON TABLE ax_hafenbecken TO ms6;
  GRANT SELECT ON TABLE ax_halde TO ms6;
  GRANT SELECT ON TABLE ax_heide TO ms6;
  GRANT SELECT ON TABLE ax_historischesbauwerkoderhistorischeeinrichtung TO ms6;
  GRANT SELECT ON TABLE ax_historischesflurstueck TO ms6;
  GRANT SELECT ON TABLE ax_historischesflurstueckalb TO ms6;
  GRANT SELECT ON TABLE ax_historischesflurstueckohneraumbezug TO ms6;
  GRANT SELECT ON TABLE ax_hoehleneingang TO ms6;
  GRANT SELECT ON TABLE ax_industrieundgewerbeflaeche TO ms6;
  GRANT SELECT ON TABLE ax_klassifizierungnachstrassenrecht TO ms6;
  GRANT SELECT ON TABLE ax_klassifizierungnachwasserrecht TO ms6;
  GRANT SELECT ON TABLE ax_kleinraeumigerlandschaftsteil TO ms6;
  GRANT SELECT ON TABLE ax_kommunalesgebiet TO ms6;
  GRANT SELECT ON TABLE ax_kreisregion TO ms6;
  GRANT SELECT ON TABLE ax_lagebezeichnungkatalogeintrag TO ms6;
  GRANT SELECT ON TABLE ax_lagebezeichnungmithausnummer TO ms6;
  GRANT SELECT ON TABLE ax_lagebezeichnungmitpseudonummer TO ms6;
  GRANT SELECT ON TABLE ax_lagebezeichnungohnehausnummer TO ms6;
  GRANT SELECT ON TABLE ax_landwirtschaft TO ms6;
  GRANT SELECT ON TABLE ax_leitung TO ms6;
  GRANT SELECT ON TABLE ax_moor TO ms6;
  GRANT SELECT ON TABLE ax_musterlandesmusterundvergleichsstueck TO ms6;
  GRANT SELECT ON TABLE ax_namensnummer TO ms6;
  GRANT SELECT ON TABLE ax_naturumweltoderbodenschutzrecht TO ms6;
  GRANT SELECT ON TABLE ax_person TO ms6;
  GRANT SELECT ON TABLE ax_platz TO ms6;
  GRANT SELECT ON TABLE ax_punktortag TO ms6;
  GRANT SELECT ON TABLE ax_punktortau TO ms6;
  GRANT SELECT ON TABLE ax_punktortta TO ms6;
  GRANT SELECT ON TABLE ax_regierungsbezirk TO ms6;
  GRANT SELECT ON TABLE ax_schiffsverkehr TO ms6;
  GRANT SELECT ON TABLE ax_schutzgebietnachwasserrecht TO ms6;
  GRANT SELECT ON TABLE ax_schutzzone TO ms6;
  GRANT SELECT ON TABLE ax_sonstigervermessungspunkt TO ms6;
  GRANT SELECT ON TABLE ax_sonstigesbauwerkodersonstigeeinrichtung TO ms6;
  GRANT SELECT ON TABLE ax_sonstigesrecht TO ms6;
  GRANT SELECT ON TABLE ax_sportfreizeitunderholungsflaeche TO ms6;
  GRANT SELECT ON TABLE ax_stehendesgewaesser TO ms6;
  GRANT SELECT ON TABLE ax_strassenverkehr TO ms6;
  GRANT SELECT ON TABLE ax_strassenverkehrsanlage TO ms6;
  GRANT SELECT ON TABLE ax_sumpf TO ms6;
  GRANT SELECT ON TABLE ax_tagebaugrubesteinbruch TO ms6;
  GRANT SELECT ON TABLE ax_transportanlage TO ms6;
  GRANT SELECT ON TABLE ax_turm TO ms6;
  GRANT SELECT ON TABLE ax_unlandvegetationsloseflaeche TO ms6;
  GRANT SELECT ON TABLE ax_untergeordnetesgewaesser TO ms6;
  GRANT SELECT ON TABLE ax_vegetationsmerkmal TO ms6;
  GRANT SELECT ON TABLE ax_vorratsbehaelterspeicherbauwerk TO ms6;
  GRANT SELECT ON TABLE ax_wald TO ms6;
  GRANT SELECT ON TABLE ax_weg TO ms6;
  GRANT SELECT ON TABLE ax_wegpfadsteig TO ms6;
  GRANT SELECT ON TABLE ax_wohnbauflaeche TO ms6;
  GRANT SELECT ON TABLE ax_wohnplatz TO ms6;

-- Berechtigung fuer Buchauskunft
--GRANT SELECT ON TABLE alkis_beziehungen TO mb27;
  GRANT SELECT ON TABLE ap_darstellung TO mb27;
  GRANT SELECT ON TABLE ap_lpo TO mb27;
  GRANT SELECT ON TABLE ap_lto TO mb27;
  GRANT SELECT ON TABLE ap_ppo TO mb27;
  GRANT SELECT ON TABLE ap_pto TO mb27;
  GRANT SELECT ON TABLE ax_anderefestlegungnachwasserrecht TO mb27;
  GRANT SELECT ON TABLE ax_anschrift TO mb27;
  GRANT SELECT ON TABLE ax_aufnahmepunkt TO mb27;
  GRANT SELECT ON TABLE ax_bahnverkehr TO mb27;
  GRANT SELECT ON TABLE ax_bahnverkehrsanlage TO mb27;
  GRANT SELECT ON TABLE ax_baublock TO mb27;
  GRANT SELECT ON TABLE ax_bauraumoderbodenordnungsrecht TO mb27;
  GRANT SELECT ON TABLE ax_bauteil TO mb27;
  GRANT SELECT ON TABLE ax_bauwerkimgewaesserbereich TO mb27;
  GRANT SELECT ON TABLE ax_bauwerkimverkehrsbereich TO mb27;
  GRANT SELECT ON TABLE ax_bauwerkoderanlagefuerindustrieundgewerbe TO mb27;
  GRANT SELECT ON TABLE ax_bauwerkoderanlagefuersportfreizeitunderholung TO mb27;
  GRANT SELECT ON TABLE ax_bergbaubetrieb TO mb27;
  GRANT SELECT ON TABLE ax_besondereflurstuecksgrenze TO mb27;
  GRANT SELECT ON TABLE ax_besonderegebaeudelinie TO mb27;
  GRANT SELECT ON TABLE ax_besondererbauwerkspunkt TO mb27;
  GRANT SELECT ON TABLE ax_besonderergebaeudepunkt TO mb27;
  GRANT SELECT ON TABLE ax_besonderertopographischerpunkt TO mb27;
  GRANT SELECT ON TABLE ax_bewertung TO mb27;
  GRANT SELECT ON TABLE ax_bodenschaetzung TO mb27;
  GRANT SELECT ON TABLE ax_boeschungkliff TO mb27;
  GRANT SELECT ON TABLE ax_boeschungsflaeche TO mb27;
  GRANT SELECT ON TABLE ax_buchungsblatt TO mb27;
  GRANT SELECT ON TABLE ax_buchungsblattbezirk TO mb27;
  GRANT SELECT ON TABLE ax_buchungsstelle TO mb27;
  GRANT SELECT ON TABLE ax_bundesland TO mb27;
  GRANT SELECT ON TABLE ax_dammwalldeich TO mb27;
  GRANT SELECT ON TABLE ax_denkmalschutzrecht TO mb27;
  GRANT SELECT ON TABLE ax_dienststelle TO mb27;
  GRANT SELECT ON TABLE ax_felsenfelsblockfelsnadel TO mb27;
  GRANT SELECT ON TABLE ax_firstlinie TO mb27;
  GRANT SELECT ON TABLE ax_flaechebesondererfunktionalerpraegung TO mb27;
  GRANT SELECT ON TABLE ax_flaechegemischternutzung TO mb27;
  GRANT SELECT ON TABLE ax_fliessgewaesser TO mb27;
  GRANT SELECT ON TABLE ax_flugverkehr TO mb27;
  GRANT SELECT ON TABLE ax_flurstueck TO mb27;
  GRANT SELECT ON TABLE ax_friedhof TO mb27;
  GRANT SELECT ON TABLE ax_gebaeude TO mb27;
  GRANT SELECT ON TABLE ax_gehoelz TO mb27;
  GRANT SELECT ON TABLE ax_gemarkung TO mb27;
  GRANT SELECT ON TABLE ax_gemarkungsteilflur TO mb27;
  GRANT SELECT ON TABLE ax_gemeinde TO mb27;
  GRANT SELECT ON TABLE ax_georeferenziertegebaeudeadresse TO mb27;
  GRANT SELECT ON TABLE ax_gewaessermerkmal TO mb27;
  GRANT SELECT ON TABLE ax_gleis TO mb27;
  GRANT SELECT ON TABLE ax_grablochderbodenschaetzung TO mb27;
  GRANT SELECT ON TABLE ax_grenzpunkt TO mb27;
  GRANT SELECT ON TABLE ax_hafenbecken TO mb27;
  GRANT SELECT ON TABLE ax_halde TO mb27;
  GRANT SELECT ON TABLE ax_heide TO mb27;
  GRANT SELECT ON TABLE ax_historischesbauwerkoderhistorischeeinrichtung TO mb27;
  GRANT SELECT ON TABLE ax_historischesflurstueck TO mb27;
  GRANT SELECT ON TABLE ax_historischesflurstueckalb TO mb27;
  GRANT SELECT ON TABLE ax_historischesflurstueckohneraumbezug TO mb27;
  GRANT SELECT ON TABLE ax_hoehleneingang TO mb27;
  GRANT SELECT ON TABLE ax_industrieundgewerbeflaeche TO mb27;
  GRANT SELECT ON TABLE ax_klassifizierungnachstrassenrecht TO mb27;
  GRANT SELECT ON TABLE ax_klassifizierungnachwasserrecht TO mb27;
  GRANT SELECT ON TABLE ax_kleinraeumigerlandschaftsteil TO mb27;
  GRANT SELECT ON TABLE ax_kommunalesgebiet TO mb27;
  GRANT SELECT ON TABLE ax_kreisregion TO mb27;
  GRANT SELECT ON TABLE ax_lagebezeichnungkatalogeintrag TO mb27;
  GRANT SELECT ON TABLE ax_lagebezeichnungmithausnummer TO mb27;
  GRANT SELECT ON TABLE ax_lagebezeichnungmitpseudonummer TO mb27;
  GRANT SELECT ON TABLE ax_lagebezeichnungohnehausnummer TO mb27;
  GRANT SELECT ON TABLE ax_landwirtschaft TO mb27;
  GRANT SELECT ON TABLE ax_leitung TO mb27;
  GRANT SELECT ON TABLE ax_moor TO mb27;
  GRANT SELECT ON TABLE ax_musterlandesmusterundvergleichsstueck TO mb27;
  GRANT SELECT ON TABLE ax_namensnummer TO mb27;
  GRANT SELECT ON TABLE ax_naturumweltoderbodenschutzrecht TO mb27;
  GRANT SELECT ON TABLE ax_person TO mb27;
  GRANT SELECT ON TABLE ax_platz TO mb27;
  GRANT SELECT ON TABLE ax_punktortag TO mb27;
  GRANT SELECT ON TABLE ax_punktortau TO mb27;
  GRANT SELECT ON TABLE ax_punktortta TO mb27;
  GRANT SELECT ON TABLE ax_regierungsbezirk TO mb27;
  GRANT SELECT ON TABLE ax_schiffsverkehr TO mb27;
  GRANT SELECT ON TABLE ax_schutzgebietnachwasserrecht TO mb27;
  GRANT SELECT ON TABLE ax_schutzzone TO mb27;
  GRANT SELECT ON TABLE ax_sonstigervermessungspunkt TO mb27;
  GRANT SELECT ON TABLE ax_sonstigesbauwerkodersonstigeeinrichtung TO mb27;
  GRANT SELECT ON TABLE ax_sonstigesrecht TO mb27;
  GRANT SELECT ON TABLE ax_sportfreizeitunderholungsflaeche TO mb27;
  GRANT SELECT ON TABLE ax_stehendesgewaesser TO mb27;
  GRANT SELECT ON TABLE ax_strassenverkehr TO mb27;
  GRANT SELECT ON TABLE ax_strassenverkehrsanlage TO mb27;
  GRANT SELECT ON TABLE ax_sumpf TO mb27;
  GRANT SELECT ON TABLE ax_tagebaugrubesteinbruch TO mb27;
  GRANT SELECT ON TABLE ax_transportanlage TO mb27;
  GRANT SELECT ON TABLE ax_turm TO mb27;
  GRANT SELECT ON TABLE ax_unlandvegetationsloseflaeche TO mb27;
  GRANT SELECT ON TABLE ax_untergeordnetesgewaesser TO mb27;
  GRANT SELECT ON TABLE ax_vegetationsmerkmal TO mb27;
  GRANT SELECT ON TABLE ax_vorratsbehaelterspeicherbauwerk TO mb27;
  GRANT SELECT ON TABLE ax_wald TO mb27;
  GRANT SELECT ON TABLE ax_weg TO mb27;
  GRANT SELECT ON TABLE ax_wegpfadsteig TO mb27;
  GRANT SELECT ON TABLE ax_wohnbauflaeche TO mb27;
  GRANT SELECT ON TABLE ax_wohnplatz TO mb27;

-- Berechtigungen fuer optimierte Nutzungsarten
-- --------------------------------------------
  GRANT SELECT ON TABLE nutzung_meta                       TO ms6;
  GRANT SELECT ON TABLE nutzung_meta                       TO mb27;
  GRANT SELECT ON TABLE nutzung                            TO ms6;
  GRANT SELECT ON TABLE nutzung                            TO mb27;
  GRANT SELECT ON TABLE nutzung_class                      TO ms6;
  GRANT SELECT ON TABLE nutzung_class                      TO mb27;

-- Post-Processung
-- --------------------------------------------
--GRANT SELECT ON TABLE  gemarkung_in_gemeinde             TO ms6;
--GRANT SELECT ON TABLE  gemarkung_in_gemeinde             TO mb27;
  GRANT SELECT ON TABLE  gemeinde_gemarkung                TO ms6;
  GRANT SELECT ON TABLE  gemeinde_gemarkung                TO mb27;
  GRANT SELECT ON TABLE  pp_gemeinde                       TO ms6; 
  GRANT SELECT ON TABLE  pp_gemeinde                       TO mb27;
  GRANT SELECT ON TABLE  pp_gemarkung                      TO ms6;
  GRANT SELECT ON TABLE  pp_gemarkung                      TO mb27;
  GRANT SELECT ON TABLE  pp_flur                           TO ms6;
  GRANT SELECT ON TABLE  pp_flur                           TO mb27;
  GRANT SELECT ON TABLE  pp_flurstueck_nr                  TO ms6;

  GRANT SELECT ON TABLE  pp_strassenname_p                 TO ms6;
  GRANT SELECT ON TABLE  pp_strassenname_l                 TO ms6;

  GRANT SELECT ON TABLE  gemeinde_person                   TO ms6;
  GRANT SELECT ON TABLE  gemeinde_person                   TO mb27;


-- Schluesseltabellen
-- ------------------

-- Gebäude
GRANT SELECT ON TABLE ax_gebaeude_bauweise                 TO ms6;
GRANT SELECT ON TABLE ax_gebaeude_bauweise                 TO mb27;
GRANT SELECT ON TABLE ax_gebaeude_funktion                 TO ms6;
GRANT SELECT ON TABLE ax_gebaeude_funktion                 TO mb27;
GRANT SELECT ON TABLE ax_gebaeude_dachform                 TO ms6;
GRANT SELECT ON TABLE ax_gebaeude_dachform                 TO mb27;
GRANT SELECT ON TABLE ax_gebaeude_weiterefunktion          TO ms6;
GRANT SELECT ON TABLE ax_gebaeude_weiterefunktion          TO mb27;
GRANT SELECT ON TABLE ax_gebaeude_zustand                  TO ms6;
GRANT SELECT ON TABLE ax_gebaeude_zustand                  TO mb27;
GRANT SELECT ON TABLE ax_bauteil_bauart                    TO ms6;
GRANT SELECT ON TABLE ax_bauteil_bauart                    TO mb27;

-- Bodenschätzung
GRANT SELECT ON TABLE ax_bodenschaetzung_bodenart          TO ms6;
GRANT SELECT ON TABLE ax_bodenschaetzung_bodenart          TO mb27;
GRANT SELECT ON TABLE ax_bodenschaetzung_entstehungsartoderklimastufe  TO ms6;
GRANT SELECT ON TABLE ax_bodenschaetzung_entstehungsartoderklimastufe  TO mb27;
GRANT SELECT ON TABLE ax_bodenschaetzung_kulturart         TO ms6;
GRANT SELECT ON TABLE ax_bodenschaetzung_kulturart         TO mb27;
GRANT SELECT ON TABLE ax_bodenschaetzung_zustandsstufe     TO ms6;
GRANT SELECT ON TABLE ax_bodenschaetzung_zustandsstufe     TO mb27;
GRANT SELECT ON TABLE ax_bodenschaetzung_sonstigeangaben   TO ms6;
GRANT SELECT ON TABLE ax_bodenschaetzung_sonstigeangaben   TO mb27;
GRANT SELECT ON TABLE ax_grablochderbodenschaetzung_bedeutung          TO ms6;
GRANT SELECT ON TABLE ax_grablochderbodenschaetzung_bedeutung          TO mb27;
GRANT SELECT ON TABLE ax_musterlandesmusterundvergleichsstueck_merkmal TO ms6;
GRANT SELECT ON TABLE ax_musterlandesmusterundvergleichsstueck_merkmal TO mb27;
GRANT SELECT ON TABLE ax_bewertung_klassifizierung         TO ms6;
GRANT SELECT ON TABLE ax_bewertung_klassifizierung         TO mb27;

-- Bodenschätzung Views
GRANT SELECT ON TABLE s_bodensch_wms                       TO ms6;
GRANT SELECT ON TABLE s_bodensch_ent                       TO ms6;
GRANT SELECT ON TABLE s_bodensch_po                        TO ms6;
GRANT SELECT ON TABLE s_bodensch_tx                        TO ms6;
GRANT SELECT ON TABLE s_zuordungspfeilspitze_bodensch      TO ms6;
GRANT SELECT ON TABLE s_zuordungspfeil_bodensch            TO ms6;

-- Recht
GRANT SELECT ON TABLE ax_denkmalschutzrecht_artdf          TO ms6;
GRANT SELECT ON TABLE ax_denkmalschutzrecht_artdf          TO mb27;
GRANT SELECT ON TABLE ax_forstrecht_artderfestlegung       TO ms6;
GRANT SELECT ON TABLE ax_forstrecht_artderfestlegung       TO mb27;
GRANT SELECT ON TABLE ax_forstrecht_besonderefunktion      TO ms6;
GRANT SELECT ON TABLE ax_forstrecht_besonderefunktion      TO mb27;
GRANT SELECT ON TABLE ax_bauraumoderbodenordnungsrecht_artderfestlegung TO ms6;
GRANT SELECT ON TABLE ax_bauraumoderbodenordnungsrecht_artderfestlegung TO mb27;
GRANT SELECT ON TABLE ax_anderefestlegungnachstrassenrecht_artdf  TO ms6;
GRANT SELECT ON TABLE ax_anderefestlegungnachstrassenrecht_artdf  TO mb27;
GRANT SELECT ON TABLE ax_klassifizierungnachstrassenrecht_artdf   TO ms6;
GRANT SELECT ON TABLE ax_klassifizierungnachstrassenrecht_artdf   TO mb27;
GRANT SELECT ON TABLE ax_klassifizierungnachwasserrecht_artdf     TO ms6;
GRANT SELECT ON TABLE ax_klassifizierungnachwasserrecht_artdf     TO mb27;
GRANT SELECT ON TABLE ax_naturumweltoderbodenschutzrecht_artdf    TO ms6;
GRANT SELECT ON TABLE ax_naturumweltoderbodenschutzrecht_artdf    TO mb27;
GRANT SELECT ON TABLE ax_sonstigesrecht_artdf              TO ms6;
GRANT SELECT ON TABLE ax_sonstigesrecht_artdf              TO mb27;

-- Sonstige Schlüsseltabellen
GRANT SELECT ON TABLE ax_buchungsstelle_buchungsart        TO ms6;
GRANT SELECT ON TABLE ax_buchungsstelle_buchungsart        TO mb27;
GRANT SELECT ON TABLE ax_namensnummer_eigentuemerart       TO ms6;
GRANT SELECT ON TABLE ax_namensnummer_eigentuemerart       TO mb27;
GRANT SELECT ON TABLE ax_datenerhebung                     TO ms6;
GRANT SELECT ON TABLE ax_datenerhebung                     TO mb27;


-- VIEWS
-- =====
  GRANT SELECT ON TABLE s_hausnummer_gebaeude              TO ms6;
--GRANT SELECT ON TABLE s_nummer_nebengebaeude             TO ms6;
  GRANT SELECT ON TABLE lfdnr_nebengebaeude                TO ms6;
  GRANT SELECT ON TABLE s_zugehoerigkeitshaken_flurstueck  TO ms6;
  GRANT SELECT ON TABLE s_zuordungspfeil_flurstueck        TO ms6;
  GRANT SELECT ON TABLE s_zuordungspfeilspitze_flurstueck  TO ms6;
  GRANT SELECT ON TABLE s_zuordungspfeil_bodensch          TO ms6;
  GRANT SELECT ON TABLE s_zuordungspfeilspitze_bodensch    TO ms6;
  GRANT SELECT ON TABLE s_zuordungspfeil_gebaeude          TO ms6;
--GRANT SELECT ON TABLE s_flurstueck_nr                    TO ms6;
--GRANT SELECT ON TABLE s_beschriftung                     TO ms6;
--GRANT SELECT ON TABLE ap_pto_stra                        TO ms6;
  GRANT SELECT ON TABLE ap_pto_rest                        TO ms6;
  GRANT SELECT ON TABLE grenzpunkt                         TO ms6;
  GRANT SELECT ON TABLE gebaeude_txt                       TO ms6;
-- VIEWS wie OBK
  GRANT SELECT ON TABLE sk2012_flurgrenze                  TO ms6;
  GRANT SELECT ON TABLE sk2014_gemarkungsgrenze            TO ms6;
  GRANT SELECT ON TABLE sk2018_bundeslandgrenze            TO ms6;
  GRANT SELECT ON TABLE sk2020_regierungsbezirksgrenze     TO ms6;
  GRANT SELECT ON TABLE sk2022_gemeindegrenze              TO ms6;
  GRANT SELECT ON TABLE sk201x_politische_grenze           TO ms6;

  GRANT SELECT ON TABLE doppelverbindung                   TO mb27;
  GRANT SELECT ON TABLE exp_csv                            TO mb27;
  GRANT SELECT ON TABLE exp_csv_str                        TO mb27;

-- END --
