-- Namens-Aenderung der Schluesseltabellen
-- Ändern Prefix "ax_" in "v_" für Tabellen, die nicht zum ALKIS-Schema gehören.

-- Version:
--	2014-09-30 Umbenennung Schlüsseltabellen (Prefix)

-- Das Neu-Einrichten der Schlüsseltabellen erfolgt über das 
--   geänderte Script "alkis_PostNAS_keytables.sql"


-- Alter Tabellen-Name                        ==> Neuer Tabellen-Name
-- ------------------------------------------     --------------------------------------------
-- ax_gebaeude_bauweise                       ==> v_geb_bauweise
-- ax_gebaeude_funktion                       ==> v_geb_funktion
-- ax_gebaeude_weiterefunktion                ==> v_geb_weiterefkt
-- ax_gebaeude_dachform                       ==> v_geb_dachform
-- ax_gebaeude_zustand                        ==> v_geb_zustand
-- ax_buchungsstelle_buchungsart              ==> v_bs_buchungsart
-- ax_namensnummer_eigentuemerart             ==> v_namnum_eigart
-- ax_bauraumoderbodenordnungsrecht_artderfestlegung ==> v_baurecht_adf
-- ax_bodenschaetzung_kulturart               ==> v_bschaetz_kulturart
-- ax_bodenschaetzung_bodenart                ==> v_bschaetz_bodenart
-- ax_bodenschaetzung_zustandsstufe           ==> v_bschaetz_zustandsstufe
-- ax_musterlandesmusterundvergleichsstueck_merkmal ==> v_muster_merkmal
-- ax_grablochderbodenschaetzung_bedeutung          ==> v_grabloch_bedeutg
-- ax_bodenschaetzung_entstehungsartoderklimastufe  ==> v_bschaetz_entsteh_klima
-- ax_bodenschaetzung_sonstigeangaben         ==> v_bschaetz_sonst
-- ax_bewertung_klassifizierung               ==> v_bewertg_klass
-- ax_forstrecht_artderfestlegung             ==> v_forstrecht_adf
-- ax_forstrecht_besonderefunktion            ==> v_forstrecht_besfkt
-- ax_datenerhebung                           ==> v_datenerhebung 
-- ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion ==> v_sbauwerk_bwfkt
-- ax_bauteil_bauart                          ==> v_bauteil_bauart
-- ax_klassifizierungnachstrassenrecht_artdf  ==> v_klass_strass_adf
-- ax_klassifizierungnachwasserrecht_artdf    ==> v_klass_wasser_adf
-- ax_anderefestlegungnachstrassenrecht_artdf ==> v_andstrass_adf
-- ax_naturumweltoderbodenschutzrecht_artdf   ==> v_umweltrecht_adf
-- ax_denkmalschutzrecht_artdf                ==> v_denkmal_adf
-- ax_sonstigesrecht_artdf                    ==> v_sonstrecht_adf


-- Nicht mehr benötigte alte Tabellen Löschen. 
-- Dies erfolgt NACH Einrichten der neuen Version und Anpassung aller Programme und Views,
-- die noch auf die alten Bezeichnungen zugreifen.

DROP TABLE ax_gebaeude_bauweise;

DROP TABLE ax_gebaeude_funktion;

DROP TABLE ax_gebaeude_weiterefunktion;

DROP TABLE ax_gebaeude_dachform;

DROP TABLE ax_gebaeude_zustand;

DROP TABLE ax_buchungsstelle_buchungsart;
-- Abhängig: View "st_flurst", Definiert in "staedtische_FS_aus_ALKIS_[gkz].sql"

DROP TABLE ax_namensnummer_eigentuemerart;

DROP TABLE ax_bauraumoderbodenordnungsrecht_artderfestlegung;

DROP TABLE ax_bodenschaetzung_kulturart;

DROP TABLE ax_bodenschaetzung_bodenart;

DROP TABLE ax_bodenschaetzung_zustandsstufe;

DROP TABLE ax_musterlandesmusterundvergleichsstueck_merkmal;

DROP TABLE ax_grablochderbodenschaetzung_bedeutung;

DROP TABLE ax_bodenschaetzung_entstehungsartoderklimastufe;

DROP TABLE ax_bodenschaetzung_sonstigeangaben;

DROP TABLE ax_bewertung_klassifizierung;

DROP TABLE ax_forstrecht_artderfestlegung;

DROP TABLE ax_forstrecht_besonderefunktion;

DROP TABLE ax_datenerhebung;

DROP TABLE ax_sonstigesbauwerkodersonstigeeinrichtung_bauwerksfunktion;

DROP TABLE ax_bauteil_bauart;

DROP TABLE ax_klassifizierungnachstrassenrecht_artdf;

DROP TABLE ax_klassifizierungnachwasserrecht_artdf;

DROP TABLE ax_anderefestlegungnachstrassenrecht_artdf;

DROP TABLE ax_naturumweltoderbodenschutzrecht_artdf;

DROP TABLE ax_denkmalschutzrecht_artdf;

DROP TABLE ax_sonstigesrecht_artdf;

