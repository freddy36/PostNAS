-- =====
-- ALKIS
-- =====

-- Berechtigungen zu ALKIS fuer Mapserver (WMS)


--  2011-07-25 PostNAS 0.6


--- Tabellen

GRANT SELECT ON TABLE alkis_beziehungen TO ms5;
GRANT SELECT ON TABLE ap_darstellung TO ms5;
GRANT SELECT ON TABLE ap_lpo TO ms5;
GRANT SELECT ON TABLE ap_lto TO ms5;
GRANT SELECT ON TABLE ap_ppo TO ms5;
GRANT SELECT ON TABLE ap_pto TO ms5;
GRANT SELECT ON TABLE ax_anderefestlegungnachwasserrecht TO ms5;
GRANT SELECT ON TABLE ax_anschrift TO ms5;
GRANT SELECT ON TABLE ax_aufnahmepunkt TO ms5;
GRANT SELECT ON TABLE ax_bahnverkehr TO ms5;
GRANT SELECT ON TABLE ax_bahnverkehrsanlage TO ms5;
GRANT SELECT ON TABLE ax_bauraumoderbodenordnungsrecht TO ms5;
GRANT SELECT ON TABLE ax_bauteil TO ms5;
GRANT SELECT ON TABLE ax_bauwerkimgewaesserbereich TO ms5;
GRANT SELECT ON TABLE ax_bauwerkimverkehrsbereich TO ms5;
GRANT SELECT ON TABLE ax_bauwerkoderanlagefuerindustrieundgewerbe TO ms5;
GRANT SELECT ON TABLE ax_bauwerkoderanlagefuersportfreizeitunderholung TO ms5;
GRANT SELECT ON TABLE ax_bergbaubetrieb TO ms5;
GRANT SELECT ON TABLE ax_besondereflurstuecksgrenze TO ms5;
GRANT SELECT ON TABLE ax_besonderegebaeudelinie TO ms5;
GRANT SELECT ON TABLE ax_besondererbauwerkspunkt TO ms5;
GRANT SELECT ON TABLE ax_besonderergebaeudepunkt TO ms5;
GRANT SELECT ON TABLE ax_besonderertopographischerpunkt TO ms5;
GRANT SELECT ON TABLE ax_bewertung TO ms5;
GRANT SELECT ON TABLE ax_bodenschaetzung TO ms5;
GRANT SELECT ON TABLE ax_boeschungkliff TO ms5;
GRANT SELECT ON TABLE ax_boeschungsflaeche TO ms5;
GRANT SELECT ON TABLE ax_buchungsblatt TO ms5;
GRANT SELECT ON TABLE ax_buchungsblattbezirk TO ms5;
GRANT SELECT ON TABLE ax_buchungsstelle TO ms5;
GRANT SELECT ON TABLE ax_bundesland TO ms5;
GRANT SELECT ON TABLE ax_dammwalldeich TO ms5;
GRANT SELECT ON TABLE ax_denkmalschutzrecht TO ms5;
GRANT SELECT ON TABLE ax_dienststelle TO ms5;
GRANT SELECT ON TABLE ax_felsenfelsblockfelsnadel TO ms5;
GRANT SELECT ON TABLE ax_firstlinie TO ms5;
GRANT SELECT ON TABLE ax_flaechebesondererfunktionalerpraegung TO ms5;
GRANT SELECT ON TABLE ax_flaechegemischternutzung TO ms5;
GRANT SELECT ON TABLE ax_fliessgewaesser TO ms5;
GRANT SELECT ON TABLE ax_flugverkehr TO ms5;
GRANT SELECT ON TABLE ax_flurstueck TO ms5;
GRANT SELECT ON TABLE ax_friedhof TO ms5;
GRANT SELECT ON TABLE ax_gebaeude TO ms5;
GRANT SELECT ON TABLE ax_gehoelz TO ms5;
GRANT SELECT ON TABLE ax_gemarkung TO ms5;
GRANT SELECT ON TABLE ax_gemarkungsteilflur TO ms5;
GRANT SELECT ON TABLE ax_gemeinde TO ms5;
GRANT SELECT ON TABLE ax_georeferenziertegebaeudeadresse TO ms5;
GRANT SELECT ON TABLE ax_gewaessermerkmal TO ms5;
GRANT SELECT ON TABLE ax_gleis TO ms5;
GRANT SELECT ON TABLE ax_grablochderbodenschaetzung TO ms5;
GRANT SELECT ON TABLE ax_grenzpunkt TO ms5;
GRANT SELECT ON TABLE ax_hafenbecken TO ms5;
GRANT SELECT ON TABLE ax_halde TO ms5;
GRANT SELECT ON TABLE ax_heide TO ms5;
GRANT SELECT ON TABLE ax_historischesbauwerkoderhistorischeeinrichtung TO ms5;
GRANT SELECT ON TABLE ax_historischesflurstueckalb TO ms5;
GRANT SELECT ON TABLE ax_industrieundgewerbeflaeche TO ms5;
GRANT SELECT ON TABLE ax_klassifizierungnachstrassenrecht TO ms5;
GRANT SELECT ON TABLE ax_klassifizierungnachwasserrecht TO ms5;
GRANT SELECT ON TABLE ax_kleinraeumigerlandschaftsteil TO ms5;
GRANT SELECT ON TABLE ax_kommunalesgebiet TO ms5;
GRANT SELECT ON TABLE ax_kreisregion TO ms5;
GRANT SELECT ON TABLE ax_lagebezeichnungkatalogeintrag TO ms5;
GRANT SELECT ON TABLE ax_lagebezeichnungmithausnummer TO ms5;
GRANT SELECT ON TABLE ax_lagebezeichnungmitpseudonummer TO ms5;
GRANT SELECT ON TABLE ax_lagebezeichnungohnehausnummer TO ms5;
GRANT SELECT ON TABLE ax_landwirtschaft TO ms5;
GRANT SELECT ON TABLE ax_leitung TO ms5;
GRANT SELECT ON TABLE ax_moor TO ms5;
GRANT SELECT ON TABLE ax_musterlandesmusterundvergleichsstueck TO ms5;
GRANT SELECT ON TABLE ax_namensnummer TO ms5;
GRANT SELECT ON TABLE ax_naturumweltoderbodenschutzrecht TO ms5;
GRANT SELECT ON TABLE ax_person TO ms5;
GRANT SELECT ON TABLE ax_platz TO ms5;
GRANT SELECT ON TABLE ax_punktortag TO ms5;
GRANT SELECT ON TABLE ax_punktortau TO ms5;
GRANT SELECT ON TABLE ax_punktortta TO ms5;
GRANT SELECT ON TABLE ax_regierungsbezirk TO ms5;
GRANT SELECT ON TABLE ax_schiffsverkehr TO ms5;
GRANT SELECT ON TABLE ax_schutzgebietnachwasserrecht TO ms5;
GRANT SELECT ON TABLE ax_schutzzone TO ms5;
GRANT SELECT ON TABLE ax_sonstigervermessungspunkt TO ms5;
GRANT SELECT ON TABLE ax_sonstigesbauwerkodersonstigeeinrichtung TO ms5;
GRANT SELECT ON TABLE ax_sonstigesrecht TO ms5;
GRANT SELECT ON TABLE ax_sportfreizeitunderholungsflaeche TO ms5;
GRANT SELECT ON TABLE ax_stehendesgewaesser TO ms5;
GRANT SELECT ON TABLE ax_strassenverkehr TO ms5;
GRANT SELECT ON TABLE ax_strassenverkehrsanlage TO ms5;
GRANT SELECT ON TABLE ax_sumpf TO ms5;
GRANT SELECT ON TABLE ax_tagebaugrubesteinbruch TO ms5;
GRANT SELECT ON TABLE ax_transportanlage TO ms5;
GRANT SELECT ON TABLE ax_turm TO ms5;
GRANT SELECT ON TABLE ax_unlandvegetationsloseflaeche TO ms5;
GRANT SELECT ON TABLE ax_untergeordnetesgewaesser TO ms5;
GRANT SELECT ON TABLE ax_vegetationsmerkmal TO ms5;
GRANT SELECT ON TABLE ax_vorratsbehaelterspeicherbauwerk TO ms5;
GRANT SELECT ON TABLE ax_wald TO ms5;
GRANT SELECT ON TABLE ax_weg TO ms5;
GRANT SELECT ON TABLE ax_wegpfadsteig TO ms5;
GRANT SELECT ON TABLE ax_wohnbauflaeche TO ms5;
GRANT SELECT ON TABLE ax_wohnplatz TO ms5;

GRANT SELECT ON TABLE geometry_columns TO ms5;
GRANT SELECT ON TABLE spatial_ref_sys  TO ms5;



-- VIEWS

--GRANT SELECT ON TABLE s_flurstuecksnummer_flurstueck    TO ms5;

  GRANT SELECT ON TABLE s_hausnummer_gebaeude             TO ms5;

  GRANT SELECT ON TABLE s_zugehoerigkeitshaken_flurstueck TO ms5;

  GRANT SELECT ON TABLE s_zuordungspfeil_flurstueck       TO ms5;
  
  GRANT SELECT ON TABLE s_flurstueck_nr                   TO ms5;

  GRANT SELECT ON TABLE s_beschriftung                    TO ms5;


-- Berechtigungen fuer optimierte Nutzungsarten
-- --------------------------------------------
  GRANT SELECT ON TABLE nutzung_meta                      TO ms5;
  GRANT SELECT ON TABLE nutzung                           TO ms5;
  GRANT SELECT ON TABLE nutzung_class                     TO ms5;


-- Beziehung: "Gemarkung liegt in Gemeinde"
-- ----------------------------------------
  GRANT SELECT ON TABLE  gemeinde_in_gemarkung TO ms5;  -- View
  GRANT SELECT ON TABLE  gemeinde_gemarkung    TO ms5; 
  
  GRANT SELECT ON TABLE  gemeinde_gemarkung    TO mb27; -- Navigation
  

-- Schluesseltabellen
-- ------------------

-- Buchauskunft - Interne Version:
GRANT SELECT ON TABLE ax_gebaeude_bauweise          TO ms5;
GRANT SELECT ON TABLE ax_gebaeude_funktion          TO ms5;
GRANT SELECT ON TABLE ax_buchungsstelle_buchungsart TO ms5;

-- Buchauskunft in WWW-Version:
GRANT SELECT ON TABLE ax_gebaeude_bauweise          TO alkisbuch;
GRANT SELECT ON TABLE ax_gebaeude_funktion          TO alkisbuch;
GRANT SELECT ON TABLE ax_buchungsstelle_buchungsart TO alkisbuch;


-- END --
