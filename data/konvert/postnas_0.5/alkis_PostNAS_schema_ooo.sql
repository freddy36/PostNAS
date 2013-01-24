SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = true;

--
-- TOC entry 2446 (class 1259 OID 5511154)
-- Dependencies: 3
-- Name: alkis_beziehungen; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE alkis_beziehungen (
    ogc_fid integer NOT NULL,
    beziehung_von character varying,
    beziehungsart character varying,
    beziehung_zu character varying
);


--
-- TOC entry 2445 (class 1259 OID 5511152)
-- Dependencies: 2446 3
-- Name: alkis_beziehungen_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE alkis_beziehungen_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 2999 (class 0 OID 0)
-- Dependencies: 2445
-- Name: alkis_beziehungen_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE alkis_beziehungen_ogc_fid_seq OWNED BY alkis_beziehungen.ogc_fid;


--
-- TOC entry 2380 (class 1259 OID 5504868)
-- Dependencies: 2759 2760 2761 961 3
-- Name: ap_lpo; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ap_lpo (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(8),
    anlass integer,
    signaturnummer integer,
    dientzurdarstellungvon character varying,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2379 (class 1259 OID 5504866)
-- Dependencies: 2380 3
-- Name: ap_lpo_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ap_lpo_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3000 (class 0 OID 0)
-- Dependencies: 2379
-- Name: ap_lpo_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ap_lpo_ogc_fid_seq OWNED BY ap_lpo.ogc_fid;


--
-- TOC entry 2382 (class 1259 OID 5505030)
-- Dependencies: 2763 2764 2765 3 961
-- Name: ap_ppo; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ap_ppo (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(8),
    anlass integer,
    signaturnummer integer,
    dientzurdarstellungvon character varying,
    drehwinkel double precision,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2381 (class 1259 OID 5505028)
-- Dependencies: 3 2382
-- Name: ap_ppo_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ap_ppo_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3001 (class 0 OID 0)
-- Dependencies: 2381
-- Name: ap_ppo_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ap_ppo_ogc_fid_seq OWNED BY ap_ppo.ogc_fid;


--
-- TOC entry 2378 (class 1259 OID 5504177)
-- Dependencies: 2755 2756 2757 3 961
-- Name: ap_pto; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ap_pto (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(8),
    anlass integer,
    signaturnummer integer,
    dientzurdarstellungvon character varying,
    schriftinhalt character(25),
    fontsperrung double precision,
    skalierung double precision,
    horizontaleausrichtung character(13),
    vertikaleausrichtung character(5),
    hat character varying,
    drehwinkel double precision,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2377 (class 1259 OID 5504175)
-- Dependencies: 2378 3
-- Name: ap_pto_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ap_pto_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3002 (class 0 OID 0)
-- Dependencies: 2377
-- Name: ap_pto_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ap_pto_ogc_fid_seq OWNED BY ap_pto.ogc_fid;


--
-- TOC entry 2432 (class 1259 OID 5510360)
-- Dependencies: 3
-- Name: ax_aufnahmepunkt; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_aufnahmepunkt (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    punktkennung character(15),
    sonstigeeigenschaft character varying[],
    vermarkung_marke integer,
    hat character varying
);


--
-- TOC entry 2431 (class 1259 OID 5510358)
-- Dependencies: 3 2432
-- Name: ax_aufnahmepunkt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_aufnahmepunkt_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3003 (class 0 OID 0)
-- Dependencies: 2431
-- Name: ax_aufnahmepunkt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_aufnahmepunkt_ogc_fid_seq OWNED BY ax_aufnahmepunkt.ogc_fid;


--
-- TOC entry 2386 (class 1259 OID 5505350)
-- Dependencies: 2771 2772 2773 3 961
-- Name: ax_bahnverkehr; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_bahnverkehr (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    lage character(5),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2385 (class 1259 OID 5505348)
-- Dependencies: 3 2386
-- Name: ax_bahnverkehr_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_bahnverkehr_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3004 (class 0 OID 0)
-- Dependencies: 2385
-- Name: ax_bahnverkehr_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_bahnverkehr_ogc_fid_seq OWNED BY ax_bahnverkehr.ogc_fid;


--
-- TOC entry 2388 (class 1259 OID 5505368)
-- Dependencies: 2775 2776 2777 3 961
-- Name: ax_bauraumoderbodenordnungsrecht; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_bauraumoderbodenordnungsrecht (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    artderfestlegung integer,
    name character(18),
    bezeichnung character(7),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2387 (class 1259 OID 5505366)
-- Dependencies: 2388 3
-- Name: ax_bauraumoderbodenordnungsrecht_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_bauraumoderbodenordnungsrecht_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3005 (class 0 OID 0)
-- Dependencies: 2387
-- Name: ax_bauraumoderbodenordnungsrecht_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_bauraumoderbodenordnungsrecht_ogc_fid_seq OWNED BY ax_bauraumoderbodenordnungsrecht.ogc_fid;


--
-- TOC entry 2390 (class 1259 OID 5505413)
-- Dependencies: 2779 2780 2781 3 961
-- Name: ax_bauteil; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_bauteil (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    bauart integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2389 (class 1259 OID 5505411)
-- Dependencies: 2390 3
-- Name: ax_bauteil_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_bauteil_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3006 (class 0 OID 0)
-- Dependencies: 2389
-- Name: ax_bauteil_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_bauteil_ogc_fid_seq OWNED BY ax_bauteil.ogc_fid;


--
-- TOC entry 2384 (class 1259 OID 5505132)
-- Dependencies: 2767 2768 2769 3 961
-- Name: ax_besondereflurstuecksgrenze; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_besondereflurstuecksgrenze (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    artderflurstuecksgrenze integer[],
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2383 (class 1259 OID 5505130)
-- Dependencies: 2384 3
-- Name: ax_besondereflurstuecksgrenze_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_besondereflurstuecksgrenze_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3007 (class 0 OID 0)
-- Dependencies: 2383
-- Name: ax_besondereflurstuecksgrenze_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_besondereflurstuecksgrenze_ogc_fid_seq OWNED BY ax_besondereflurstuecksgrenze.ogc_fid;


--
-- TOC entry 2396 (class 1259 OID 5505479)
-- Dependencies: 2791 2792 2793 3 961
-- Name: ax_besonderegebaeudelinie; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_besonderegebaeudelinie (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    beschaffenheit integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2395 (class 1259 OID 5505477)
-- Dependencies: 2396 3
-- Name: ax_besonderegebaeudelinie_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_besonderegebaeudelinie_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3008 (class 0 OID 0)
-- Dependencies: 2395
-- Name: ax_besonderegebaeudelinie_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_besonderegebaeudelinie_ogc_fid_seq OWNED BY ax_besonderegebaeudelinie.ogc_fid;


--
-- TOC entry 2438 (class 1259 OID 5510550)
-- Dependencies: 3
-- Name: ax_besonderergebaeudepunkt; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_besonderergebaeudepunkt (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    punktkennung character(15),
    sonstigeeigenschaft character(10)
);


--
-- TOC entry 2437 (class 1259 OID 5510548)
-- Dependencies: 3 2438
-- Name: ax_besonderergebaeudepunkt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_besonderergebaeudepunkt_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3009 (class 0 OID 0)
-- Dependencies: 2437
-- Name: ax_besonderergebaeudepunkt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_besonderergebaeudepunkt_ogc_fid_seq OWNED BY ax_besonderergebaeudepunkt.ogc_fid;


--
-- TOC entry 2366 (class 1259 OID 5503222)
-- Dependencies: 2735 2736 2737 3 961
-- Name: ax_bewertung; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_bewertung (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    klassifizierung integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2365 (class 1259 OID 5503220)
-- Dependencies: 3 2366
-- Name: ax_bewertung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_bewertung_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3010 (class 0 OID 0)
-- Dependencies: 2365
-- Name: ax_bewertung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_bewertung_ogc_fid_seq OWNED BY ax_bewertung.ogc_fid;


--
-- TOC entry 2364 (class 1259 OID 5503202)
-- Dependencies: 2731 2732 2733 3 961
-- Name: ax_bodenschaetzung; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_bodenschaetzung (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    kulturart integer,
    bodenart integer,
    zustandsstufeoderbodenstufe integer,
    entstehungsartoderklimastufewasserverhaeltnisse integer[],
    bodenzahlodergruenlandgrundzahl integer,
    ackerzahlodergruenlandzahl integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2363 (class 1259 OID 5503200)
-- Dependencies: 3 2364
-- Name: ax_bodenschaetzung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_bodenschaetzung_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3011 (class 0 OID 0)
-- Dependencies: 2363
-- Name: ax_bodenschaetzung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_bodenschaetzung_ogc_fid_seq OWNED BY ax_bodenschaetzung.ogc_fid;


--
-- TOC entry 2394 (class 1259 OID 5505462)
-- Dependencies: 2787 2788 2789 3 961
-- Name: ax_flaechebesondererfunktionalerpraegung; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_flaechebesondererfunktionalerpraegung (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    funktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2393 (class 1259 OID 5505460)
-- Dependencies: 2394 3
-- Name: ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3012 (class 0 OID 0)
-- Dependencies: 2393
-- Name: ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq OWNED BY ax_flaechebesondererfunktionalerpraegung.ogc_fid;


--
-- TOC entry 2392 (class 1259 OID 5505434)
-- Dependencies: 2783 2784 2785 3 961
-- Name: ax_flaechegemischternutzung; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_flaechegemischternutzung (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    funktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2391 (class 1259 OID 5505432)
-- Dependencies: 2392 3
-- Name: ax_flaechegemischternutzung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_flaechegemischternutzung_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3013 (class 0 OID 0)
-- Dependencies: 2391
-- Name: ax_flaechegemischternutzung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_flaechegemischternutzung_ogc_fid_seq OWNED BY ax_flaechegemischternutzung.ogc_fid;


--
-- TOC entry 2362 (class 1259 OID 5503162)
-- Dependencies: 2727 2728 2729 961 3
-- Name: ax_fliessgewaesser; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_fliessgewaesser (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    funktion integer,
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    lage character(5),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2361 (class 1259 OID 5503160)
-- Dependencies: 3 2362
-- Name: ax_fliessgewaesser_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_fliessgewaesser_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3014 (class 0 OID 0)
-- Dependencies: 2361
-- Name: ax_fliessgewaesser_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_fliessgewaesser_ogc_fid_seq OWNED BY ax_fliessgewaesser.ogc_fid;


--
-- TOC entry 2368 (class 1259 OID 5503302)
-- Dependencies: 2739 2740 3 961
-- Name: ax_flurstueck; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_flurstueck (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    land integer,
    gemarkungsnummer integer,
    zaehler integer,
    flurstueckskennzeichen character(20),
    amtlicheflaeche double precision,
    flurnummer integer,
    angabenzumabschnittflurstueck character varying[],
    "gemeindezugehoerigkeit|ax_gemeindekennzeichen|land" integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    istgebucht character varying,
    zeigtauf character varying,
    nenner integer,
    kennungschluessel character varying[],
    flaechedesabschnitts double precision[],
    angabenzumabschnittnummeraktenzeichen integer[],
    angabenzumabschnittbemerkung character varying[],
    zeitpunktderentstehung character(10),
    weistauf character varying,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2367 (class 1259 OID 5503300)
-- Dependencies: 2368 3
-- Name: ax_flurstueck_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_flurstueck_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3015 (class 0 OID 0)
-- Dependencies: 2367
-- Name: ax_flurstueck_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_flurstueck_ogc_fid_seq OWNED BY ax_flurstueck.ogc_fid;


--
-- TOC entry 2398 (class 1259 OID 5505695)
-- Dependencies: 2795 2796 2797 3 961
-- Name: ax_gebaeude; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_gebaeude (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character varying[],
    anlass integer,
    gebaeudefunktion integer,
    description integer,
    zeigtauf character varying,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2397 (class 1259 OID 5505693)
-- Dependencies: 3 2398
-- Name: ax_gebaeude_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_gebaeude_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3016 (class 0 OID 0)
-- Dependencies: 2397
-- Name: ax_gebaeude_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_gebaeude_ogc_fid_seq OWNED BY ax_gebaeude.ogc_fid;


--
-- TOC entry 2402 (class 1259 OID 5506224)
-- Dependencies: 2803 2804 2805 3 961
-- Name: ax_gebaeudeausgestaltung; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_gebaeudeausgestaltung (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    darstellung integer,
    zeigtauf character varying,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2401 (class 1259 OID 5506222)
-- Dependencies: 2402 3
-- Name: ax_gebaeudeausgestaltung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_gebaeudeausgestaltung_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3017 (class 0 OID 0)
-- Dependencies: 2401
-- Name: ax_gebaeudeausgestaltung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_gebaeudeausgestaltung_ogc_fid_seq OWNED BY ax_gebaeudeausgestaltung.ogc_fid;


--
-- TOC entry 2400 (class 1259 OID 5506206)
-- Dependencies: 2799 2800 2801 3 961
-- Name: ax_gehoelz; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_gehoelz (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2399 (class 1259 OID 5506204)
-- Dependencies: 2400 3
-- Name: ax_gehoelz_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_gehoelz_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3018 (class 0 OID 0)
-- Dependencies: 2399
-- Name: ax_gehoelz_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_gehoelz_ogc_fid_seq OWNED BY ax_gehoelz.ogc_fid;


--
-- TOC entry 2442 (class 1259 OID 5511081)
-- Dependencies: 3
-- Name: ax_gemarkungsteilflur; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_gemarkungsteilflur (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    schluesselgesamt integer,
    bezeichnung integer,
    land integer,
    gemarkung integer,
    gemarkungsteilflur integer
);


--
-- TOC entry 2441 (class 1259 OID 5511079)
-- Dependencies: 3 2442
-- Name: ax_gemarkungsteilflur_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_gemarkungsteilflur_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3019 (class 0 OID 0)
-- Dependencies: 2441
-- Name: ax_gemarkungsteilflur_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_gemarkungsteilflur_ogc_fid_seq OWNED BY ax_gemarkungsteilflur.ogc_fid;


--
-- TOC entry 2430 (class 1259 OID 5508762)
-- Dependencies: 3
-- Name: ax_grenzpunkt; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_grenzpunkt (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    punktkennung character(15),
    abmarkung_marke integer,
    sonstigeeigenschaft character varying[]
);


--
-- TOC entry 2429 (class 1259 OID 5508760)
-- Dependencies: 2430 3
-- Name: ax_grenzpunkt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_grenzpunkt_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3020 (class 0 OID 0)
-- Dependencies: 2429
-- Name: ax_grenzpunkt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_grenzpunkt_ogc_fid_seq OWNED BY ax_grenzpunkt.ogc_fid;


--
-- TOC entry 2408 (class 1259 OID 5506800)
-- Dependencies: 2815 2816 2817 3 961
-- Name: ax_industrieundgewerbeflaeche; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_industrieundgewerbeflaeche (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    funktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2407 (class 1259 OID 5506798)
-- Dependencies: 2408 3
-- Name: ax_industrieundgewerbeflaeche_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_industrieundgewerbeflaeche_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3021 (class 0 OID 0)
-- Dependencies: 2407
-- Name: ax_industrieundgewerbeflaeche_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_industrieundgewerbeflaeche_ogc_fid_seq OWNED BY ax_industrieundgewerbeflaeche.ogc_fid;


--
-- TOC entry 2444 (class 1259 OID 5511093)
-- Dependencies: 2866 2867 2868 3 961
-- Name: ax_klassifizierungnachstrassenrecht; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_klassifizierungnachstrassenrecht (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    artderfestlegung integer,
    bezeichnung character(5),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2443 (class 1259 OID 5511091)
-- Dependencies: 2444 3
-- Name: ax_klassifizierungnachstrassenrecht_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_klassifizierungnachstrassenrecht_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3022 (class 0 OID 0)
-- Dependencies: 2443
-- Name: ax_klassifizierungnachstrassenrecht_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_klassifizierungnachstrassenrecht_ogc_fid_seq OWNED BY ax_klassifizierungnachstrassenrecht.ogc_fid;


--
-- TOC entry 2372 (class 1259 OID 5503988)
-- Dependencies: 2746 2747 2748 3 961
-- Name: ax_klassifizierungnachwasserrecht; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_klassifizierungnachwasserrecht (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    artderfestlegung integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2371 (class 1259 OID 5503986)
-- Dependencies: 2372 3
-- Name: ax_klassifizierungnachwasserrecht_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_klassifizierungnachwasserrecht_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3023 (class 0 OID 0)
-- Dependencies: 2371
-- Name: ax_klassifizierungnachwasserrecht_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_klassifizierungnachwasserrecht_ogc_fid_seq OWNED BY ax_klassifizierungnachwasserrecht.ogc_fid;


--
-- TOC entry 2436 (class 1259 OID 5510426)
-- Dependencies: 3
-- Name: ax_lagebezeichnungmithausnummer; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_lagebezeichnungmithausnummer (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    lage character(5),
    hausnummer character(3)
);


--
-- TOC entry 2435 (class 1259 OID 5510424)
-- Dependencies: 2436 3
-- Name: ax_lagebezeichnungmithausnummer_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_lagebezeichnungmithausnummer_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3024 (class 0 OID 0)
-- Dependencies: 2435
-- Name: ax_lagebezeichnungmithausnummer_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_lagebezeichnungmithausnummer_ogc_fid_seq OWNED BY ax_lagebezeichnungmithausnummer.ogc_fid;


--
-- TOC entry 2376 (class 1259 OID 5504095)
-- Dependencies: 3
-- Name: ax_lagebezeichnungohnehausnummer; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_lagebezeichnungohnehausnummer (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    lage character(5)
);


--
-- TOC entry 2375 (class 1259 OID 5504093)
-- Dependencies: 3 2376
-- Name: ax_lagebezeichnungohnehausnummer_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_lagebezeichnungohnehausnummer_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3025 (class 0 OID 0)
-- Dependencies: 2375
-- Name: ax_lagebezeichnungohnehausnummer_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_lagebezeichnungohnehausnummer_ogc_fid_seq OWNED BY ax_lagebezeichnungohnehausnummer.ogc_fid;


--
-- TOC entry 2370 (class 1259 OID 5503890)
-- Dependencies: 2742 2743 2744 3 961
-- Name: ax_landwirtschaft; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_landwirtschaft (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    vegetationsmerkmal integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2369 (class 1259 OID 5503888)
-- Dependencies: 2370 3
-- Name: ax_landwirtschaft_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_landwirtschaft_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3026 (class 0 OID 0)
-- Dependencies: 2369
-- Name: ax_landwirtschaft_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_landwirtschaft_ogc_fid_seq OWNED BY ax_landwirtschaft.ogc_fid;


--
-- TOC entry 2406 (class 1259 OID 5506781)
-- Dependencies: 2811 2812 2813 961 3
-- Name: ax_platz; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_platz (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    funktion integer,
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    lage character(5),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2405 (class 1259 OID 5506779)
-- Dependencies: 3 2406
-- Name: ax_platz_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_platz_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3027 (class 0 OID 0)
-- Dependencies: 2405
-- Name: ax_platz_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_platz_ogc_fid_seq OWNED BY ax_platz.ogc_fid;


--
-- TOC entry 2404 (class 1259 OID 5506252)
-- Dependencies: 2807 2808 2809 961 3
-- Name: ax_punktortag; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_punktortag (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    istteilvon character varying,
    kartendarstellung character(4),
    koordinatenstatus integer,
    description integer,
    genauigkeitsstufe integer,
    vertrauenswuerdigkeit integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2403 (class 1259 OID 5506250)
-- Dependencies: 2404 3
-- Name: ax_punktortag_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_punktortag_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3028 (class 0 OID 0)
-- Dependencies: 2403
-- Name: ax_punktortag_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_punktortag_ogc_fid_seq OWNED BY ax_punktortag.ogc_fid;


--
-- TOC entry 2410 (class 1259 OID 5506820)
-- Dependencies: 2819 2820 2821 3 961
-- Name: ax_punktortau; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_punktortau (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    istteilvon character varying,
    kartendarstellung character(5),
    koordinatenstatus integer,
    description integer,
    genauigkeitsstufe integer,
    vertrauenswuerdigkeit integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2409 (class 1259 OID 5506818)
-- Dependencies: 3 2410
-- Name: ax_punktortau_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_punktortau_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3029 (class 0 OID 0)
-- Dependencies: 2409
-- Name: ax_punktortau_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_punktortau_ogc_fid_seq OWNED BY ax_punktortau.ogc_fid;


--
-- TOC entry 2412 (class 1259 OID 5506885)
-- Dependencies: 2823 2824 2825 3 961
-- Name: ax_punktortta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_punktortta (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    istteilvon character varying,
    kartendarstellung character(4),
    koordinatenstatus integer,
    description integer,
    genauigkeitsstufe integer,
    vertrauenswuerdigkeit integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2411 (class 1259 OID 5506883)
-- Dependencies: 3 2412
-- Name: ax_punktortta_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_punktortta_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3030 (class 0 OID 0)
-- Dependencies: 2411
-- Name: ax_punktortta_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_punktortta_ogc_fid_seq OWNED BY ax_punktortta.ogc_fid;


--
-- TOC entry 2440 (class 1259 OID 5511071)
-- Dependencies: 3
-- Name: ax_sicherungspunkt; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_sicherungspunkt (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    punktkennung character(15),
    sonstigeeigenschaft character(10),
    vermarkung_marke integer
);


--
-- TOC entry 2439 (class 1259 OID 5511069)
-- Dependencies: 2440 3
-- Name: ax_sicherungspunkt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_sicherungspunkt_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3031 (class 0 OID 0)
-- Dependencies: 2439
-- Name: ax_sicherungspunkt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_sicherungspunkt_ogc_fid_seq OWNED BY ax_sicherungspunkt.ogc_fid;


--
-- TOC entry 2434 (class 1259 OID 5510414)
-- Dependencies: 3
-- Name: ax_sonstigervermessungspunkt; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_sonstigervermessungspunkt (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    punktkennung character(15),
    sonstigeeigenschaft character(10),
    vermarkung_marke integer
);


--
-- TOC entry 2433 (class 1259 OID 5510412)
-- Dependencies: 3 2434
-- Name: ax_sonstigervermessungspunkt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_sonstigervermessungspunkt_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3032 (class 0 OID 0)
-- Dependencies: 2433
-- Name: ax_sonstigervermessungspunkt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_sonstigervermessungspunkt_ogc_fid_seq OWNED BY ax_sonstigervermessungspunkt.ogc_fid;


--
-- TOC entry 2428 (class 1259 OID 5508741)
-- Dependencies: 2855 2856 2857 3 961
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_sonstigesbauwerkodersonstigeeinrichtung (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    bauwerksfunktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2427 (class 1259 OID 5508739)
-- Dependencies: 2428 3
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3033 (class 0 OID 0)
-- Dependencies: 2427
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq OWNED BY ax_sonstigesbauwerkodersonstigeeinrichtung.ogc_fid;


--
-- TOC entry 2424 (class 1259 OID 5508641)
-- Dependencies: 2847 2848 2849 3 961
-- Name: ax_sportfreizeitunderholungsflaeche; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_sportfreizeitunderholungsflaeche (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    funktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2423 (class 1259 OID 5508639)
-- Dependencies: 3 2424
-- Name: ax_sportfreizeitunderholungsflaeche_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_sportfreizeitunderholungsflaeche_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3034 (class 0 OID 0)
-- Dependencies: 2423
-- Name: ax_sportfreizeitunderholungsflaeche_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_sportfreizeitunderholungsflaeche_ogc_fid_seq OWNED BY ax_sportfreizeitunderholungsflaeche.ogc_fid;


--
-- TOC entry 2418 (class 1259 OID 5508567)
-- Dependencies: 2835 2836 2837 3 961
-- Name: ax_stehendesgewaesser; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_stehendesgewaesser (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    funktion integer,
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    lage character(5),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2417 (class 1259 OID 5508565)
-- Dependencies: 3 2418
-- Name: ax_stehendesgewaesser_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_stehendesgewaesser_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3035 (class 0 OID 0)
-- Dependencies: 2417
-- Name: ax_stehendesgewaesser_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_stehendesgewaesser_ogc_fid_seq OWNED BY ax_stehendesgewaesser.ogc_fid;


--
-- TOC entry 2422 (class 1259 OID 5508607)
-- Dependencies: 2843 2844 2845 3 961
-- Name: ax_strassenverkehr; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_strassenverkehr (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    lage character(5),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2421 (class 1259 OID 5508605)
-- Dependencies: 3 2422
-- Name: ax_strassenverkehr_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_strassenverkehr_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3036 (class 0 OID 0)
-- Dependencies: 2421
-- Name: ax_strassenverkehr_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_strassenverkehr_ogc_fid_seq OWNED BY ax_strassenverkehr.ogc_fid;


--
-- TOC entry 2426 (class 1259 OID 5508665)
-- Dependencies: 2851 2852 2853 3 961
-- Name: ax_topographischelinie; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_topographischelinie (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    liniendarstellung integer,
    sonstigeeigenschaft character(8),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2425 (class 1259 OID 5508663)
-- Dependencies: 2426 3
-- Name: ax_topographischelinie_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_topographischelinie_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3037 (class 0 OID 0)
-- Dependencies: 2425
-- Name: ax_topographischelinie_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_topographischelinie_ogc_fid_seq OWNED BY ax_topographischelinie.ogc_fid;


--
-- TOC entry 2420 (class 1259 OID 5508585)
-- Dependencies: 2839 2840 2841 961 3
-- Name: ax_unlandvegetationsloseflaeche; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_unlandvegetationsloseflaeche (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2419 (class 1259 OID 5508583)
-- Dependencies: 2420 3
-- Name: ax_unlandvegetationsloseflaeche_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_unlandvegetationsloseflaeche_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3038 (class 0 OID 0)
-- Dependencies: 2419
-- Name: ax_unlandvegetationsloseflaeche_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_unlandvegetationsloseflaeche_ogc_fid_seq OWNED BY ax_unlandvegetationsloseflaeche.ogc_fid;


--
-- TOC entry 2416 (class 1259 OID 5508536)
-- Dependencies: 2831 2832 2833 3 961
-- Name: ax_wald; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_wald (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    vegetationsmerkmal integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2415 (class 1259 OID 5508534)
-- Dependencies: 3 2416
-- Name: ax_wald_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_wald_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3039 (class 0 OID 0)
-- Dependencies: 2415
-- Name: ax_wald_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_wald_ogc_fid_seq OWNED BY ax_wald.ogc_fid;


--
-- TOC entry 2374 (class 1259 OID 5504021)
-- Dependencies: 2750 2751 2752 961 3
-- Name: ax_weg; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_weg (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    lage character(5),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2373 (class 1259 OID 5504019)
-- Dependencies: 2374 3
-- Name: ax_weg_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_weg_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3040 (class 0 OID 0)
-- Dependencies: 2373
-- Name: ax_weg_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_weg_ogc_fid_seq OWNED BY ax_weg.ogc_fid;


--
-- TOC entry 2414 (class 1259 OID 5508488)
-- Dependencies: 2827 2828 2829 961 3
-- Name: ax_wohnbauflaeche; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_wohnbauflaeche (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    artderbebauung integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2413 (class 1259 OID 5508486)
-- Dependencies: 2414 3
-- Name: ax_wohnbauflaeche_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_wohnbauflaeche_ogc_fid_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3041 (class 0 OID 0)
-- Dependencies: 2413
-- Name: ax_wohnbauflaeche_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_wohnbauflaeche_ogc_fid_seq OWNED BY ax_wohnbauflaeche.ogc_fid;


--
-- TOC entry 2360 (class 1259 OID 16784)
-- Dependencies: 3
-- Name: geometry_columns; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE geometry_columns (
    f_table_catalog character varying(256) NOT NULL,
    f_table_schema character varying(256) NOT NULL,
    f_table_name character varying(256) NOT NULL,
    f_geometry_column character varying(256) NOT NULL,
    coord_dimension integer NOT NULL,
    srid integer NOT NULL,
    type character varying(30) NOT NULL
);


SET default_with_oids = false;

--
-- TOC entry 2359 (class 1259 OID 16776)
-- Dependencies: 3
-- Name: spatial_ref_sys; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE spatial_ref_sys (
    srid integer NOT NULL,
    auth_name character varying(256),
    auth_srid integer,
    srtext character varying(2048),
    proj4text character varying(2048)
);


--
-- TOC entry 2869 (class 2604 OID 5511157)
-- Dependencies: 2446 2445 2446
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE alkis_beziehungen ALTER COLUMN ogc_fid SET DEFAULT nextval('alkis_beziehungen_ogc_fid_seq'::regclass);


--
-- TOC entry 2758 (class 2604 OID 5504871)
-- Dependencies: 2380 2379 2380
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ap_lpo ALTER COLUMN ogc_fid SET DEFAULT nextval('ap_lpo_ogc_fid_seq'::regclass);


--
-- TOC entry 2762 (class 2604 OID 5505033)
-- Dependencies: 2382 2381 2382
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ap_ppo ALTER COLUMN ogc_fid SET DEFAULT nextval('ap_ppo_ogc_fid_seq'::regclass);


--
-- TOC entry 2754 (class 2604 OID 5504180)
-- Dependencies: 2377 2378 2378
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ap_pto ALTER COLUMN ogc_fid SET DEFAULT nextval('ap_pto_ogc_fid_seq'::regclass);


--
-- TOC entry 2859 (class 2604 OID 5510363)
-- Dependencies: 2432 2431 2432
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_aufnahmepunkt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_aufnahmepunkt_ogc_fid_seq'::regclass);


--
-- TOC entry 2770 (class 2604 OID 5505353)
-- Dependencies: 2385 2386 2386
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_bahnverkehr ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bahnverkehr_ogc_fid_seq'::regclass);


--
-- TOC entry 2774 (class 2604 OID 5505371)
-- Dependencies: 2387 2388 2388
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_bauraumoderbodenordnungsrecht ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bauraumoderbodenordnungsrecht_ogc_fid_seq'::regclass);


--
-- TOC entry 2778 (class 2604 OID 5505416)
-- Dependencies: 2389 2390 2390
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_bauteil ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bauteil_ogc_fid_seq'::regclass);


--
-- TOC entry 2766 (class 2604 OID 5505135)
-- Dependencies: 2384 2383 2384
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_besondereflurstuecksgrenze ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_besondereflurstuecksgrenze_ogc_fid_seq'::regclass);


--
-- TOC entry 2790 (class 2604 OID 5505482)
-- Dependencies: 2396 2395 2396
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_besonderegebaeudelinie ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_besonderegebaeudelinie_ogc_fid_seq'::regclass);


--
-- TOC entry 2862 (class 2604 OID 5510553)
-- Dependencies: 2437 2438 2438
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_besonderergebaeudepunkt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_besonderergebaeudepunkt_ogc_fid_seq'::regclass);


--
-- TOC entry 2734 (class 2604 OID 5503225)
-- Dependencies: 2366 2365 2366
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_bewertung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bewertung_ogc_fid_seq'::regclass);


--
-- TOC entry 2730 (class 2604 OID 5503205)
-- Dependencies: 2364 2363 2364
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_bodenschaetzung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bodenschaetzung_ogc_fid_seq'::regclass);


--
-- TOC entry 2786 (class 2604 OID 5505465)
-- Dependencies: 2394 2393 2394
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_flaechebesondererfunktionalerpraegung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq'::regclass);


--
-- TOC entry 2782 (class 2604 OID 5505437)
-- Dependencies: 2391 2392 2392
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_flaechegemischternutzung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_flaechegemischternutzung_ogc_fid_seq'::regclass);


--
-- TOC entry 2726 (class 2604 OID 5503165)
-- Dependencies: 2362 2361 2362
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_fliessgewaesser ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_fliessgewaesser_ogc_fid_seq'::regclass);


--
-- TOC entry 2738 (class 2604 OID 5503305)
-- Dependencies: 2367 2368 2368
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_flurstueck ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_flurstueck_ogc_fid_seq'::regclass);


--
-- TOC entry 2794 (class 2604 OID 5505698)
-- Dependencies: 2398 2397 2398
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_gebaeude ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gebaeude_ogc_fid_seq'::regclass);


--
-- TOC entry 2802 (class 2604 OID 5506227)
-- Dependencies: 2402 2401 2402
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_gebaeudeausgestaltung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gebaeudeausgestaltung_ogc_fid_seq'::regclass);


--
-- TOC entry 2798 (class 2604 OID 5506209)
-- Dependencies: 2399 2400 2400
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_gehoelz ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gehoelz_ogc_fid_seq'::regclass);


--
-- TOC entry 2864 (class 2604 OID 5511084)
-- Dependencies: 2441 2442 2442
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_gemarkungsteilflur ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gemarkungsteilflur_ogc_fid_seq'::regclass);


--
-- TOC entry 2858 (class 2604 OID 5508765)
-- Dependencies: 2430 2429 2430
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_grenzpunkt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_grenzpunkt_ogc_fid_seq'::regclass);


--
-- TOC entry 2814 (class 2604 OID 5506803)
-- Dependencies: 2408 2407 2408
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_industrieundgewerbeflaeche ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_industrieundgewerbeflaeche_ogc_fid_seq'::regclass);


--
-- TOC entry 2865 (class 2604 OID 5511096)
-- Dependencies: 2443 2444 2444
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_klassifizierungnachstrassenrecht ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_klassifizierungnachstrassenrecht_ogc_fid_seq'::regclass);


--
-- TOC entry 2745 (class 2604 OID 5503991)
-- Dependencies: 2372 2371 2372
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_klassifizierungnachwasserrecht ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_klassifizierungnachwasserrecht_ogc_fid_seq'::regclass);


--
-- TOC entry 2861 (class 2604 OID 5510429)
-- Dependencies: 2436 2435 2436
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_lagebezeichnungmithausnummer ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_lagebezeichnungmithausnummer_ogc_fid_seq'::regclass);


--
-- TOC entry 2753 (class 2604 OID 5504098)
-- Dependencies: 2376 2375 2376
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_lagebezeichnungohnehausnummer ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_lagebezeichnungohnehausnummer_ogc_fid_seq'::regclass);


--
-- TOC entry 2741 (class 2604 OID 5503893)
-- Dependencies: 2370 2369 2370
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_landwirtschaft ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_landwirtschaft_ogc_fid_seq'::regclass);


--
-- TOC entry 2810 (class 2604 OID 5506784)
-- Dependencies: 2406 2405 2406
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_platz ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_platz_ogc_fid_seq'::regclass);


--
-- TOC entry 2806 (class 2604 OID 5506255)
-- Dependencies: 2403 2404 2404
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_punktortag ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_punktortag_ogc_fid_seq'::regclass);


--
-- TOC entry 2818 (class 2604 OID 5506823)
-- Dependencies: 2410 2409 2410
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_punktortau ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_punktortau_ogc_fid_seq'::regclass);


--
-- TOC entry 2822 (class 2604 OID 5506888)
-- Dependencies: 2411 2412 2412
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_punktortta ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_punktortta_ogc_fid_seq'::regclass);


--
-- TOC entry 2863 (class 2604 OID 5511074)
-- Dependencies: 2439 2440 2440
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_sicherungspunkt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_sicherungspunkt_ogc_fid_seq'::regclass);


--
-- TOC entry 2860 (class 2604 OID 5510417)
-- Dependencies: 2434 2433 2434
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_sonstigervermessungspunkt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_sonstigervermessungspunkt_ogc_fid_seq'::regclass);


--
-- TOC entry 2854 (class 2604 OID 5508744)
-- Dependencies: 2428 2427 2428
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_sonstigesbauwerkodersonstigeeinrichtung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq'::regclass);


--
-- TOC entry 2846 (class 2604 OID 5508644)
-- Dependencies: 2424 2423 2424
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_sportfreizeitunderholungsflaeche ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_sportfreizeitunderholungsflaeche_ogc_fid_seq'::regclass);


--
-- TOC entry 2834 (class 2604 OID 5508570)
-- Dependencies: 2417 2418 2418
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_stehendesgewaesser ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_stehendesgewaesser_ogc_fid_seq'::regclass);


--
-- TOC entry 2842 (class 2604 OID 5508610)
-- Dependencies: 2422 2421 2422
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_strassenverkehr ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_strassenverkehr_ogc_fid_seq'::regclass);


--
-- TOC entry 2850 (class 2604 OID 5508668)
-- Dependencies: 2425 2426 2426
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_topographischelinie ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_topographischelinie_ogc_fid_seq'::regclass);


--
-- TOC entry 2838 (class 2604 OID 5508588)
-- Dependencies: 2419 2420 2420
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_unlandvegetationsloseflaeche ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_unlandvegetationsloseflaeche_ogc_fid_seq'::regclass);


--
-- TOC entry 2830 (class 2604 OID 5508539)
-- Dependencies: 2415 2416 2416
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_wald ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_wald_ogc_fid_seq'::regclass);


--
-- TOC entry 2749 (class 2604 OID 5504024)
-- Dependencies: 2373 2374 2374
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_weg ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_weg_ogc_fid_seq'::regclass);


--
-- TOC entry 2826 (class 2604 OID 5508491)
-- Dependencies: 2413 2414 2414
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_wohnbauflaeche ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_wohnbauflaeche_ogc_fid_seq'::regclass);


--
-- TOC entry 2993 (class 2606 OID 5511159)
-- Dependencies: 2446 2446
-- Name: alkis_beziehungen_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY alkis_beziehungen
    ADD CONSTRAINT alkis_beziehungen_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2902 (class 2606 OID 5504873)
-- Dependencies: 2380 2380
-- Name: ap_lpo_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ap_lpo
    ADD CONSTRAINT ap_lpo_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2905 (class 2606 OID 5505035)
-- Dependencies: 2382 2382
-- Name: ap_ppo_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ap_ppo
    ADD CONSTRAINT ap_ppo_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2899 (class 2606 OID 5504182)
-- Dependencies: 2378 2378
-- Name: ap_pto_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ap_pto
    ADD CONSTRAINT ap_pto_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2978 (class 2606 OID 5510365)
-- Dependencies: 2432 2432
-- Name: ax_aufnahmepunkt_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_aufnahmepunkt
    ADD CONSTRAINT ax_aufnahmepunkt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2911 (class 2606 OID 5505355)
-- Dependencies: 2386 2386
-- Name: ax_bahnverkehr_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_bahnverkehr
    ADD CONSTRAINT ax_bahnverkehr_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2914 (class 2606 OID 5505373)
-- Dependencies: 2388 2388
-- Name: ax_bauraumoderbodenordnungsrecht_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_bauraumoderbodenordnungsrecht
    ADD CONSTRAINT ax_bauraumoderbodenordnungsrecht_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2917 (class 2606 OID 5505418)
-- Dependencies: 2390 2390
-- Name: ax_bauteil_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_bauteil
    ADD CONSTRAINT ax_bauteil_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2908 (class 2606 OID 5505137)
-- Dependencies: 2384 2384
-- Name: ax_besondereflurstuecksgrenze_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_besondereflurstuecksgrenze
    ADD CONSTRAINT ax_besondereflurstuecksgrenze_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2926 (class 2606 OID 5505484)
-- Dependencies: 2396 2396
-- Name: ax_besonderegebaeudelinie_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_besonderegebaeudelinie
    ADD CONSTRAINT ax_besonderegebaeudelinie_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2984 (class 2606 OID 5510555)
-- Dependencies: 2438 2438
-- Name: ax_besonderergebaeudepunkt_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_besonderergebaeudepunkt
    ADD CONSTRAINT ax_besonderergebaeudepunkt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2882 (class 2606 OID 5503227)
-- Dependencies: 2366 2366
-- Name: ax_bewertung_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_bewertung
    ADD CONSTRAINT ax_bewertung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2879 (class 2606 OID 5503207)
-- Dependencies: 2364 2364
-- Name: ax_bodenschaetzung_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_bodenschaetzung
    ADD CONSTRAINT ax_bodenschaetzung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2923 (class 2606 OID 5505467)
-- Dependencies: 2394 2394
-- Name: ax_flaechebesondererfunktionalerpraegung_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_flaechebesondererfunktionalerpraegung
    ADD CONSTRAINT ax_flaechebesondererfunktionalerpraegung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2920 (class 2606 OID 5505439)
-- Dependencies: 2392 2392
-- Name: ax_flaechegemischternutzung_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_flaechegemischternutzung
    ADD CONSTRAINT ax_flaechegemischternutzung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2876 (class 2606 OID 5503167)
-- Dependencies: 2362 2362
-- Name: ax_fliessgewaesser_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_fliessgewaesser
    ADD CONSTRAINT ax_fliessgewaesser_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2885 (class 2606 OID 5503307)
-- Dependencies: 2368 2368
-- Name: ax_flurstueck_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_flurstueck
    ADD CONSTRAINT ax_flurstueck_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2929 (class 2606 OID 5505700)
-- Dependencies: 2398 2398
-- Name: ax_gebaeude_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_gebaeude
    ADD CONSTRAINT ax_gebaeude_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2935 (class 2606 OID 5506229)
-- Dependencies: 2402 2402
-- Name: ax_gebaeudeausgestaltung_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_gebaeudeausgestaltung
    ADD CONSTRAINT ax_gebaeudeausgestaltung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2932 (class 2606 OID 5506211)
-- Dependencies: 2400 2400
-- Name: ax_gehoelz_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_gehoelz
    ADD CONSTRAINT ax_gehoelz_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2988 (class 2606 OID 5511086)
-- Dependencies: 2442 2442
-- Name: ax_gemarkungsteilflur_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_gemarkungsteilflur
    ADD CONSTRAINT ax_gemarkungsteilflur_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2976 (class 2606 OID 5508767)
-- Dependencies: 2430 2430
-- Name: ax_grenzpunkt_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_grenzpunkt
    ADD CONSTRAINT ax_grenzpunkt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2944 (class 2606 OID 5506805)
-- Dependencies: 2408 2408
-- Name: ax_industrieundgewerbeflaeche_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_industrieundgewerbeflaeche
    ADD CONSTRAINT ax_industrieundgewerbeflaeche_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2991 (class 2606 OID 5511098)
-- Dependencies: 2444 2444
-- Name: ax_klassifizierungnachstrassenrecht_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_klassifizierungnachstrassenrecht
    ADD CONSTRAINT ax_klassifizierungnachstrassenrecht_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2891 (class 2606 OID 5503993)
-- Dependencies: 2372 2372
-- Name: ax_klassifizierungnachwasserrecht_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_klassifizierungnachwasserrecht
    ADD CONSTRAINT ax_klassifizierungnachwasserrecht_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2982 (class 2606 OID 5510431)
-- Dependencies: 2436 2436
-- Name: ax_lagebezeichnungmithausnummer_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_lagebezeichnungmithausnummer
    ADD CONSTRAINT ax_lagebezeichnungmithausnummer_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2896 (class 2606 OID 5504100)
-- Dependencies: 2376 2376
-- Name: ax_lagebezeichnungohnehausnummer_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_lagebezeichnungohnehausnummer
    ADD CONSTRAINT ax_lagebezeichnungohnehausnummer_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2888 (class 2606 OID 5503895)
-- Dependencies: 2370 2370
-- Name: ax_landwirtschaft_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_landwirtschaft
    ADD CONSTRAINT ax_landwirtschaft_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2941 (class 2606 OID 5506786)
-- Dependencies: 2406 2406
-- Name: ax_platz_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_platz
    ADD CONSTRAINT ax_platz_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2938 (class 2606 OID 5506257)
-- Dependencies: 2404 2404
-- Name: ax_punktortag_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_punktortag
    ADD CONSTRAINT ax_punktortag_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2947 (class 2606 OID 5506825)
-- Dependencies: 2410 2410
-- Name: ax_punktortau_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_punktortau
    ADD CONSTRAINT ax_punktortau_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2950 (class 2606 OID 5506890)
-- Dependencies: 2412 2412
-- Name: ax_punktortta_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_punktortta
    ADD CONSTRAINT ax_punktortta_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2986 (class 2606 OID 5511076)
-- Dependencies: 2440 2440
-- Name: ax_sicherungspunkt_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_sicherungspunkt
    ADD CONSTRAINT ax_sicherungspunkt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2980 (class 2606 OID 5510419)
-- Dependencies: 2434 2434
-- Name: ax_sonstigervermessungspunkt_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_sonstigervermessungspunkt
    ADD CONSTRAINT ax_sonstigervermessungspunkt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2974 (class 2606 OID 5508746)
-- Dependencies: 2428 2428
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_sonstigesbauwerkodersonstigeeinrichtung
    ADD CONSTRAINT ax_sonstigesbauwerkodersonstigeeinrichtung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2968 (class 2606 OID 5508646)
-- Dependencies: 2424 2424
-- Name: ax_sportfreizeitunderholungsflaeche_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_sportfreizeitunderholungsflaeche
    ADD CONSTRAINT ax_sportfreizeitunderholungsflaeche_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2959 (class 2606 OID 5508572)
-- Dependencies: 2418 2418
-- Name: ax_stehendesgewaesser_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_stehendesgewaesser
    ADD CONSTRAINT ax_stehendesgewaesser_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2965 (class 2606 OID 5508612)
-- Dependencies: 2422 2422
-- Name: ax_strassenverkehr_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_strassenverkehr
    ADD CONSTRAINT ax_strassenverkehr_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2971 (class 2606 OID 5508670)
-- Dependencies: 2426 2426
-- Name: ax_topographischelinie_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_topographischelinie
    ADD CONSTRAINT ax_topographischelinie_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2962 (class 2606 OID 5508590)
-- Dependencies: 2420 2420
-- Name: ax_unlandvegetationsloseflaeche_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_unlandvegetationsloseflaeche
    ADD CONSTRAINT ax_unlandvegetationsloseflaeche_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2956 (class 2606 OID 5508541)
-- Dependencies: 2416 2416
-- Name: ax_wald_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_wald
    ADD CONSTRAINT ax_wald_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2894 (class 2606 OID 5504026)
-- Dependencies: 2374 2374
-- Name: ax_weg_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_weg
    ADD CONSTRAINT ax_weg_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2953 (class 2606 OID 5508493)
-- Dependencies: 2414 2414
-- Name: ax_wohnbauflaeche_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_wohnbauflaeche
    ADD CONSTRAINT ax_wohnbauflaeche_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 2873 (class 2606 OID 16791)
-- Dependencies: 2360 2360 2360 2360 2360
-- Name: geometry_columns_pk; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY geometry_columns
    ADD CONSTRAINT geometry_columns_pk PRIMARY KEY (f_table_catalog, f_table_schema, f_table_name, f_geometry_column);


--
-- TOC entry 2871 (class 2606 OID 16783)
-- Dependencies: 2359 2359
-- Name: spatial_ref_sys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY spatial_ref_sys
    ADD CONSTRAINT spatial_ref_sys_pkey PRIMARY KEY (srid);


--
-- TOC entry 2900 (class 1259 OID 5504881)
-- Dependencies: 1998 2380
-- Name: ap_lpo_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ap_lpo_geom_idx ON ap_lpo USING gist (wkb_geometry);


--
-- TOC entry 2903 (class 1259 OID 5505043)
-- Dependencies: 1998 2382
-- Name: ap_ppo_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ap_ppo_geom_idx ON ap_ppo USING gist (wkb_geometry);


--
-- TOC entry 2897 (class 1259 OID 5504190)
-- Dependencies: 2378 1998
-- Name: ap_pto_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ap_pto_geom_idx ON ap_pto USING gist (wkb_geometry);


--
-- TOC entry 2909 (class 1259 OID 5505363)
-- Dependencies: 1998 2386
-- Name: ax_bahnverkehr_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_bahnverkehr_geom_idx ON ax_bahnverkehr USING gist (wkb_geometry);


--
-- TOC entry 2912 (class 1259 OID 5505381)
-- Dependencies: 1998 2388
-- Name: ax_bauraumoderbodenordnungsrecht_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_bauraumoderbodenordnungsrecht_geom_idx ON ax_bauraumoderbodenordnungsrecht USING gist (wkb_geometry);


--
-- TOC entry 2915 (class 1259 OID 5505426)
-- Dependencies: 1998 2390
-- Name: ax_bauteil_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_bauteil_geom_idx ON ax_bauteil USING gist (wkb_geometry);


--
-- TOC entry 2906 (class 1259 OID 5505145)
-- Dependencies: 1998 2384
-- Name: ax_besondereflurstuecksgrenze_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_besondereflurstuecksgrenze_geom_idx ON ax_besondereflurstuecksgrenze USING gist (wkb_geometry);


--
-- TOC entry 2924 (class 1259 OID 5505492)
-- Dependencies: 1998 2396
-- Name: ax_besonderegebaeudelinie_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_besonderegebaeudelinie_geom_idx ON ax_besonderegebaeudelinie USING gist (wkb_geometry);


--
-- TOC entry 2880 (class 1259 OID 5503235)
-- Dependencies: 1998 2366
-- Name: ax_bewertung_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_bewertung_geom_idx ON ax_bewertung USING gist (wkb_geometry);


--
-- TOC entry 2877 (class 1259 OID 5503215)
-- Dependencies: 1998 2364
-- Name: ax_bodenschaetzung_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_bodenschaetzung_geom_idx ON ax_bodenschaetzung USING gist (wkb_geometry);


--
-- TOC entry 2921 (class 1259 OID 5505475)
-- Dependencies: 2394 1998
-- Name: ax_flaechebesondererfunktionalerpraegung_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_flaechebesondererfunktionalerpraegung_geom_idx ON ax_flaechebesondererfunktionalerpraegung USING gist (wkb_geometry);


--
-- TOC entry 2918 (class 1259 OID 5505447)
-- Dependencies: 1998 2392
-- Name: ax_flaechegemischternutzung_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_flaechegemischternutzung_geom_idx ON ax_flaechegemischternutzung USING gist (wkb_geometry);


--
-- TOC entry 2874 (class 1259 OID 5503175)
-- Dependencies: 2362 1998
-- Name: ax_fliessgewaesser_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_fliessgewaesser_geom_idx ON ax_fliessgewaesser USING gist (wkb_geometry);


--
-- TOC entry 2883 (class 1259 OID 5503314)
-- Dependencies: 1998 2368
-- Name: ax_flurstueck_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_flurstueck_geom_idx ON ax_flurstueck USING gist (wkb_geometry);


--
-- TOC entry 2927 (class 1259 OID 5505708)
-- Dependencies: 1998 2398
-- Name: ax_gebaeude_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_gebaeude_geom_idx ON ax_gebaeude USING gist (wkb_geometry);


--
-- TOC entry 2933 (class 1259 OID 5506237)
-- Dependencies: 1998 2402
-- Name: ax_gebaeudeausgestaltung_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_gebaeudeausgestaltung_geom_idx ON ax_gebaeudeausgestaltung USING gist (wkb_geometry);


--
-- TOC entry 2930 (class 1259 OID 5506219)
-- Dependencies: 1998 2400
-- Name: ax_gehoelz_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_gehoelz_geom_idx ON ax_gehoelz USING gist (wkb_geometry);


--
-- TOC entry 2942 (class 1259 OID 5506813)
-- Dependencies: 1998 2408
-- Name: ax_industrieundgewerbeflaeche_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_industrieundgewerbeflaeche_geom_idx ON ax_industrieundgewerbeflaeche USING gist (wkb_geometry);


--
-- TOC entry 2989 (class 1259 OID 5511106)
-- Dependencies: 1998 2444
-- Name: ax_klassifizierungnachstrassenrecht_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_klassifizierungnachstrassenrecht_geom_idx ON ax_klassifizierungnachstrassenrecht USING gist (wkb_geometry);


--
-- TOC entry 2889 (class 1259 OID 5504001)
-- Dependencies: 1998 2372
-- Name: ax_klassifizierungnachwasserrecht_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_klassifizierungnachwasserrecht_geom_idx ON ax_klassifizierungnachwasserrecht USING gist (wkb_geometry);


--
-- TOC entry 2886 (class 1259 OID 5503903)
-- Dependencies: 1998 2370
-- Name: ax_landwirtschaft_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_landwirtschaft_geom_idx ON ax_landwirtschaft USING gist (wkb_geometry);


--
-- TOC entry 2939 (class 1259 OID 5506794)
-- Dependencies: 1998 2406
-- Name: ax_platz_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_platz_geom_idx ON ax_platz USING gist (wkb_geometry);


--
-- TOC entry 2936 (class 1259 OID 5506265)
-- Dependencies: 1998 2404
-- Name: ax_punktortag_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_punktortag_geom_idx ON ax_punktortag USING gist (wkb_geometry);


--
-- TOC entry 2945 (class 1259 OID 5506833)
-- Dependencies: 2410 1998
-- Name: ax_punktortau_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_punktortau_geom_idx ON ax_punktortau USING gist (wkb_geometry);


--
-- TOC entry 2948 (class 1259 OID 5506898)
-- Dependencies: 2412 1998
-- Name: ax_punktortta_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_punktortta_geom_idx ON ax_punktortta USING gist (wkb_geometry);


--
-- TOC entry 2972 (class 1259 OID 5508754)
-- Dependencies: 1998 2428
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_sonstigesbauwerkodersonstigeeinrichtung_geom_idx ON ax_sonstigesbauwerkodersonstigeeinrichtung USING gist (wkb_geometry);


--
-- TOC entry 2966 (class 1259 OID 5508654)
-- Dependencies: 1998 2424
-- Name: ax_sportfreizeitunderholungsflaeche_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_sportfreizeitunderholungsflaeche_geom_idx ON ax_sportfreizeitunderholungsflaeche USING gist (wkb_geometry);


--
-- TOC entry 2957 (class 1259 OID 5508580)
-- Dependencies: 2418 1998
-- Name: ax_stehendesgewaesser_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_stehendesgewaesser_geom_idx ON ax_stehendesgewaesser USING gist (wkb_geometry);


--
-- TOC entry 2963 (class 1259 OID 5508620)
-- Dependencies: 2422 1998
-- Name: ax_strassenverkehr_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_strassenverkehr_geom_idx ON ax_strassenverkehr USING gist (wkb_geometry);


--
-- TOC entry 2969 (class 1259 OID 5508678)
-- Dependencies: 1998 2426
-- Name: ax_topographischelinie_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_topographischelinie_geom_idx ON ax_topographischelinie USING gist (wkb_geometry);


--
-- TOC entry 2960 (class 1259 OID 5508598)
-- Dependencies: 1998 2420
-- Name: ax_unlandvegetationsloseflaeche_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_unlandvegetationsloseflaeche_geom_idx ON ax_unlandvegetationsloseflaeche USING gist (wkb_geometry);


--
-- TOC entry 2954 (class 1259 OID 5508549)
-- Dependencies: 1998 2416
-- Name: ax_wald_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_wald_geom_idx ON ax_wald USING gist (wkb_geometry);


--
-- TOC entry 2892 (class 1259 OID 5504034)
-- Dependencies: 2374 1998
-- Name: ax_weg_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_weg_geom_idx ON ax_weg USING gist (wkb_geometry);


--
-- TOC entry 2951 (class 1259 OID 5508501)
-- Dependencies: 1998 2414
-- Name: ax_wohnbauflaeche_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ax_wohnbauflaeche_geom_idx ON ax_wohnbauflaeche USING gist (wkb_geometry);


--
-- TOC entry 2998 (class 0 OID 0)
-- Dependencies: 3
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2011-05-13 15:57:00 CEST

--
-- PostgreSQL database dump complete
--

