SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 2670 (class 1259 OID 5501058)
-- Dependencies: 3
-- Name: aa_aktivitaet; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE aa_aktivitaet (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    status character varying,
    art character(16)
);


ALTER TABLE public.aa_aktivitaet OWNER TO postgres;

--
-- TOC entry 2669 (class 1259 OID 5501056)
-- Dependencies: 3 2670
-- Name: aa_aktivitaet_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE aa_aktivitaet_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.aa_aktivitaet_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4017 (class 0 OID 0)
-- Dependencies: 2669
-- Name: aa_aktivitaet_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE aa_aktivitaet_ogc_fid_seq OWNED BY aa_aktivitaet.ogc_fid;


--
-- TOC entry 2672 (class 1259 OID 5501070)
-- Dependencies: 3
-- Name: aa_antrag; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE aa_antrag (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    art character(42),
    name character(15),
    kennzeichen character(15),
    antragunterbrochen character(5),
    verweistauf character varying,
    bearbeitungsstatus character varying,
    gebiet character varying,
    art_ character(16)
);


ALTER TABLE public.aa_antrag OWNER TO postgres;

--
-- TOC entry 2671 (class 1259 OID 5501068)
-- Dependencies: 3 2672
-- Name: aa_antrag_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE aa_antrag_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.aa_antrag_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4018 (class 0 OID 0)
-- Dependencies: 2671
-- Name: aa_antrag_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE aa_antrag_ogc_fid_seq OWNED BY aa_antrag.ogc_fid;


--
-- TOC entry 2674 (class 1259 OID 5501082)
-- Dependencies: 3199 3200 3201 961 3
-- Name: aa_antragsgebiet; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE aa_antragsgebiet (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.aa_antragsgebiet OWNER TO postgres;

--
-- TOC entry 2673 (class 1259 OID 5501080)
-- Dependencies: 2674 3
-- Name: aa_antragsgebiet_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE aa_antragsgebiet_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.aa_antragsgebiet_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4019 (class 0 OID 0)
-- Dependencies: 2673
-- Name: aa_antragsgebiet_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE aa_antragsgebiet_ogc_fid_seq OWNED BY aa_antragsgebiet.ogc_fid;


--
-- TOC entry 2676 (class 1259 OID 5501098)
-- Dependencies: 3
-- Name: aa_meilenstein; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE aa_meilenstein (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    begonnen character(5),
    abgeschlossen character(5),
    erfolgreich character(5),
    vonantrag character varying,
    vonvorgang character varying,
    vonaktivitaet character varying
);


ALTER TABLE public.aa_meilenstein OWNER TO postgres;

--
-- TOC entry 2675 (class 1259 OID 5501096)
-- Dependencies: 2676 3
-- Name: aa_meilenstein_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE aa_meilenstein_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.aa_meilenstein_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4020 (class 0 OID 0)
-- Dependencies: 2675
-- Name: aa_meilenstein_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE aa_meilenstein_ogc_fid_seq OWNED BY aa_meilenstein.ogc_fid;


--
-- TOC entry 2678 (class 1259 OID 5501110)
-- Dependencies: 3
-- Name: aa_projektsteuerung; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE aa_projektsteuerung (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    anlassdesprozesses integer,
    enthaelt character varying,
    art character(16)
);


ALTER TABLE public.aa_projektsteuerung OWNER TO postgres;

--
-- TOC entry 2677 (class 1259 OID 5501108)
-- Dependencies: 3 2678
-- Name: aa_projektsteuerung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE aa_projektsteuerung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.aa_projektsteuerung_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4021 (class 0 OID 0)
-- Dependencies: 2677
-- Name: aa_projektsteuerung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE aa_projektsteuerung_ogc_fid_seq OWNED BY aa_projektsteuerung.ogc_fid;


--
-- TOC entry 2680 (class 1259 OID 5501122)
-- Dependencies: 3
-- Name: aa_vorgang; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE aa_vorgang (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    bearbeitbardurch character varying,
    enthaelt character varying,
    status character varying,
    art character(16)
);


ALTER TABLE public.aa_vorgang OWNER TO postgres;

--
-- TOC entry 2679 (class 1259 OID 5501120)
-- Dependencies: 2680 3
-- Name: aa_vorgang_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE aa_vorgang_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.aa_vorgang_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4022 (class 0 OID 0)
-- Dependencies: 2679
-- Name: aa_vorgang_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE aa_vorgang_ogc_fid_seq OWNED BY aa_vorgang.ogc_fid;


--
-- TOC entry 2694 (class 1259 OID 5501199)
-- Dependencies: 3
-- Name: alkis_beziehungen; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE alkis_beziehungen (
    ogc_fid integer NOT NULL,
    beziehung_von character(16),
    beziehungsart character varying(35),
    beziehung_zu character(16)
);


ALTER TABLE public.alkis_beziehungen OWNER TO postgres;

--
-- TOC entry 4023 (class 0 OID 0)
-- Dependencies: 2694
-- Name: TABLE alkis_beziehungen; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE alkis_beziehungen IS 'zentrale Multi-Verbindungstabelle';


--
-- TOC entry 4024 (class 0 OID 0)
-- Dependencies: 2694
-- Name: COLUMN alkis_beziehungen.beziehung_von; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN alkis_beziehungen.beziehung_von IS 'Join auf gml_id';


--
-- TOC entry 4025 (class 0 OID 0)
-- Dependencies: 2694
-- Name: COLUMN alkis_beziehungen.beziehungsart; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN alkis_beziehungen.beziehungsart IS 'Typ der Beziehung';


--
-- TOC entry 4026 (class 0 OID 0)
-- Dependencies: 2694
-- Name: COLUMN alkis_beziehungen.beziehung_zu; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN alkis_beziehungen.beziehung_zu IS 'Join auf gml_id';


--
-- TOC entry 2693 (class 1259 OID 5501197)
-- Dependencies: 2694 3
-- Name: alkis_beziehungen_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE alkis_beziehungen_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.alkis_beziehungen_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4027 (class 0 OID 0)
-- Dependencies: 2693
-- Name: alkis_beziehungen_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE alkis_beziehungen_ogc_fid_seq OWNED BY alkis_beziehungen.ogc_fid;


--
-- TOC entry 2732 (class 1259 OID 5501500)
-- Dependencies: 3
-- Name: ap_darstellung; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ap_darstellung (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    art character varying(40),
    signaturnummer integer
);


ALTER TABLE public.ap_darstellung OWNER TO postgres;

--
-- TOC entry 4028 (class 0 OID 0)
-- Dependencies: 2732
-- Name: TABLE ap_darstellung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ap_darstellung IS 'A P  D a r s t e l l u n g';


--
-- TOC entry 4029 (class 0 OID 0)
-- Dependencies: 2732
-- Name: COLUMN ap_darstellung.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ap_darstellung.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2731 (class 1259 OID 5501498)
-- Dependencies: 3 2732
-- Name: ap_darstellung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap_darstellung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ap_darstellung_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4030 (class 0 OID 0)
-- Dependencies: 2731
-- Name: ap_darstellung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap_darstellung_ogc_fid_seq OWNED BY ap_darstellung.ogc_fid;


--
-- TOC entry 2726 (class 1259 OID 5501448)
-- Dependencies: 3262 3263 3264 961 3
-- Name: ap_lpo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ap_lpo (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying[],
    anlass integer,
    signaturnummer integer,
    art character varying(5),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ap_lpo OWNER TO postgres;

--
-- TOC entry 4031 (class 0 OID 0)
-- Dependencies: 2726
-- Name: TABLE ap_lpo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ap_lpo IS 'LPO: Linienförmiges Präsentationsobjekt';


--
-- TOC entry 4032 (class 0 OID 0)
-- Dependencies: 2726
-- Name: COLUMN ap_lpo.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ap_lpo.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2725 (class 1259 OID 5501446)
-- Dependencies: 3 2726
-- Name: ap_lpo_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap_lpo_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ap_lpo_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4033 (class 0 OID 0)
-- Dependencies: 2725
-- Name: ap_lpo_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap_lpo_ogc_fid_seq OWNED BY ap_lpo.ogc_fid;


--
-- TOC entry 2730 (class 1259 OID 5501483)
-- Dependencies: 3270 3271 3272 3 961
-- Name: ap_lto; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ap_lto (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character varying(9),
    sonstigesmodell character varying(9),
    anlass integer,
    art character varying(3),
    schriftinhalt character varying(40),
    fontsperrung integer,
    skalierung integer,
    horizontaleausrichtung character varying(12),
    vertikaleausrichtung character varying(5),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ap_lto OWNER TO postgres;

--
-- TOC entry 4034 (class 0 OID 0)
-- Dependencies: 2730
-- Name: TABLE ap_lto; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ap_lto IS 'LTO: Textförmiges Präsentationsobjekt mit linienförmiger Textgeometrie';


--
-- TOC entry 4035 (class 0 OID 0)
-- Dependencies: 2730
-- Name: COLUMN ap_lto.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ap_lto.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2729 (class 1259 OID 5501481)
-- Dependencies: 2730 3
-- Name: ap_lto_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap_lto_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ap_lto_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4036 (class 0 OID 0)
-- Dependencies: 2729
-- Name: ap_lto_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap_lto_ogc_fid_seq OWNED BY ap_lto.ogc_fid;


--
-- TOC entry 2724 (class 1259 OID 5501431)
-- Dependencies: 3259 3260 3 961
-- Name: ap_ppo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ap_ppo (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying[],
    sonstigesmodell character varying(8),
    anlass integer,
    signaturnummer integer,
    art character varying(20),
    drehwinkel double precision,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ap_ppo OWNER TO postgres;

--
-- TOC entry 4037 (class 0 OID 0)
-- Dependencies: 2724
-- Name: TABLE ap_ppo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ap_ppo IS 'PPO: Punktförmiges Präsentationsobjekt';


--
-- TOC entry 4038 (class 0 OID 0)
-- Dependencies: 2724
-- Name: COLUMN ap_ppo.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ap_ppo.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2723 (class 1259 OID 5501429)
-- Dependencies: 3 2724
-- Name: ap_ppo_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap_ppo_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ap_ppo_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4039 (class 0 OID 0)
-- Dependencies: 2723
-- Name: ap_ppo_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap_ppo_ogc_fid_seq OWNED BY ap_ppo.ogc_fid;


--
-- TOC entry 2728 (class 1259 OID 5501465)
-- Dependencies: 3266 3267 3268 3 961
-- Name: ap_pto; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ap_pto (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying[],
    anlass integer,
    schriftinhalt character varying(50),
    fontsperrung double precision,
    skalierung double precision,
    horizontaleausrichtung character varying(13),
    vertikaleausrichtung character varying(5),
    signaturnummer integer,
    art character varying(40),
    drehwinkel double precision,
    "zeigtaufexternes|aa_fachdatenverbindung|art" character varying(40),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ap_pto OWNER TO postgres;

--
-- TOC entry 4040 (class 0 OID 0)
-- Dependencies: 2728
-- Name: TABLE ap_pto; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ap_pto IS 'PTO: Textförmiges Präsentationsobjekt mit punktförmiger Textgeometrie ';


--
-- TOC entry 4041 (class 0 OID 0)
-- Dependencies: 2728
-- Name: COLUMN ap_pto.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ap_pto.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4042 (class 0 OID 0)
-- Dependencies: 2728
-- Name: COLUMN ap_pto.schriftinhalt; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ap_pto.schriftinhalt IS 'Label: anzuzeigender Text';


--
-- TOC entry 2727 (class 1259 OID 5501463)
-- Dependencies: 2728 3
-- Name: ap_pto_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ap_pto_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ap_pto_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4043 (class 0 OID 0)
-- Dependencies: 2727
-- Name: ap_pto_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ap_pto_ogc_fid_seq OWNED BY ap_pto.ogc_fid;


--
-- TOC entry 2696 (class 1259 OID 5501210)
-- Dependencies: 3216 3217 3218 3 961
-- Name: ax_anderefestlegungnachwasserrecht; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_anderefestlegungnachwasserrecht (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    artderfestlegung integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_anderefestlegungnachwasserrecht OWNER TO postgres;

--
-- TOC entry 4044 (class 0 OID 0)
-- Dependencies: 2696
-- Name: TABLE ax_anderefestlegungnachwasserrecht; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_anderefestlegungnachwasserrecht IS 'Andere Festlegung nach  W a s s e r r e c h t';


--
-- TOC entry 4045 (class 0 OID 0)
-- Dependencies: 2696
-- Name: COLUMN ax_anderefestlegungnachwasserrecht.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_anderefestlegungnachwasserrecht.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2695 (class 1259 OID 5501208)
-- Dependencies: 3 2696
-- Name: ax_anderefestlegungnachwasserrecht_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_anderefestlegungnachwasserrecht_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_anderefestlegungnachwasserrecht_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4046 (class 0 OID 0)
-- Dependencies: 2695
-- Name: ax_anderefestlegungnachwasserrecht_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_anderefestlegungnachwasserrecht_ogc_fid_seq OWNED BY ax_anderefestlegungnachwasserrecht.ogc_fid;


--
-- TOC entry 2758 (class 1259 OID 5501676)
-- Dependencies: 3
-- Name: ax_anschrift; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_anschrift (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    ort_post character varying(30),
    postleitzahlpostzustellung integer,
    strasse character varying(40),
    hausnummer character varying(9),
    bestimmungsland character varying(30)
);


ALTER TABLE public.ax_anschrift OWNER TO postgres;

--
-- TOC entry 4047 (class 0 OID 0)
-- Dependencies: 2758
-- Name: TABLE ax_anschrift; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_anschrift IS 'A n s c h r i f t';


--
-- TOC entry 4048 (class 0 OID 0)
-- Dependencies: 2758
-- Name: COLUMN ax_anschrift.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_anschrift.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2757 (class 1259 OID 5501674)
-- Dependencies: 2758 3
-- Name: ax_anschrift_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_anschrift_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_anschrift_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4049 (class 0 OID 0)
-- Dependencies: 2757
-- Name: ax_anschrift_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_anschrift_ogc_fid_seq OWNED BY ax_anschrift.ogc_fid;


--
-- TOC entry 2746 (class 1259 OID 5501589)
-- Dependencies: 3
-- Name: ax_aufnahmepunkt; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_aufnahmepunkt (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    punktkennung character varying(15),
    land integer,
    stelle integer,
    sonstigeeigenschaft character varying[],
    vermarkung_marke integer
);


ALTER TABLE public.ax_aufnahmepunkt OWNER TO postgres;

--
-- TOC entry 4050 (class 0 OID 0)
-- Dependencies: 2746
-- Name: TABLE ax_aufnahmepunkt; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_aufnahmepunkt IS 'A u f n a h m e p u n k t';


--
-- TOC entry 4051 (class 0 OID 0)
-- Dependencies: 2746
-- Name: COLUMN ax_aufnahmepunkt.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_aufnahmepunkt.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2745 (class 1259 OID 5501587)
-- Dependencies: 3 2746
-- Name: ax_aufnahmepunkt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_aufnahmepunkt_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_aufnahmepunkt_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4052 (class 0 OID 0)
-- Dependencies: 2745
-- Name: ax_aufnahmepunkt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_aufnahmepunkt_ogc_fid_seq OWNED BY ax_aufnahmepunkt.ogc_fid;


--
-- TOC entry 2800 (class 1259 OID 5502007)
-- Dependencies: 3368 3369 3370 961 3
-- Name: ax_bahnverkehr; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_bahnverkehr (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    bahnkategorie integer,
    bezeichnung character varying(50),
    nummerderbahnstrecke character varying(20),
    zweitname character varying(50),
    zustand integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_bahnverkehr OWNER TO postgres;

--
-- TOC entry 4053 (class 0 OID 0)
-- Dependencies: 2800
-- Name: TABLE ax_bahnverkehr; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_bahnverkehr IS '"B a h n v e r k e h r"  umfasst alle für den Schienenverkehr erforderlichen Flächen.';


--
-- TOC entry 4054 (class 0 OID 0)
-- Dependencies: 2800
-- Name: COLUMN ax_bahnverkehr.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bahnverkehr.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4055 (class 0 OID 0)
-- Dependencies: 2800
-- Name: COLUMN ax_bahnverkehr.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bahnverkehr.funktion IS 'FKT "Funktion" ist die objektiv feststellbare Nutzung von "Bahnverkehr".';


--
-- TOC entry 4056 (class 0 OID 0)
-- Dependencies: 2800
-- Name: COLUMN ax_bahnverkehr.bahnkategorie; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bahnverkehr.bahnkategorie IS 'BKT "Bahnkategorie" beschreibt die Art des Verkehrsmittels.';


--
-- TOC entry 4057 (class 0 OID 0)
-- Dependencies: 2800
-- Name: COLUMN ax_bahnverkehr.bezeichnung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bahnverkehr.bezeichnung IS 'BEZ "Bezeichnung" ist die Angabe der Orte, in denen die Bahnlinie beginnt und endet (z. B. "Bahnlinie Frankfurt - Würzburg").';


--
-- TOC entry 4058 (class 0 OID 0)
-- Dependencies: 2800
-- Name: COLUMN ax_bahnverkehr.nummerderbahnstrecke; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bahnverkehr.nummerderbahnstrecke IS 'NRB "Nummer der Bahnstrecke" ist die von der Bahn AG festgelegte Verschlüsselung der Bahnstrecke.';


--
-- TOC entry 4059 (class 0 OID 0)
-- Dependencies: 2800
-- Name: COLUMN ax_bahnverkehr.zweitname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bahnverkehr.zweitname IS 'ZNM "Zweitname" ist der von der Lagebezeichnung abweichende Name von "Bahnverkehr" (z. B. "Höllentalbahn").';


--
-- TOC entry 4060 (class 0 OID 0)
-- Dependencies: 2800
-- Name: COLUMN ax_bahnverkehr.zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bahnverkehr.zustand IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Bahnverkehr".';


--
-- TOC entry 2799 (class 1259 OID 5502005)
-- Dependencies: 3 2800
-- Name: ax_bahnverkehr_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_bahnverkehr_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_bahnverkehr_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4061 (class 0 OID 0)
-- Dependencies: 2799
-- Name: ax_bahnverkehr_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_bahnverkehr_ogc_fid_seq OWNED BY ax_bahnverkehr.ogc_fid;


--
-- TOC entry 2856 (class 1259 OID 5502476)
-- Dependencies: 3470 3471 3472 3 961
-- Name: ax_bahnverkehrsanlage; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_bahnverkehrsanlage (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character varying(9),
    sonstigesmodell character varying[],
    anlass integer,
    bahnhofskategorie integer,
    bahnkategorie integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_bahnverkehrsanlage OWNER TO postgres;

--
-- TOC entry 4062 (class 0 OID 0)
-- Dependencies: 2856
-- Name: TABLE ax_bahnverkehrsanlage; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_bahnverkehrsanlage IS 'B a h n v e r k e h r s a n l a g e';


--
-- TOC entry 4063 (class 0 OID 0)
-- Dependencies: 2856
-- Name: COLUMN ax_bahnverkehrsanlage.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bahnverkehrsanlage.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2855 (class 1259 OID 5502474)
-- Dependencies: 2856 3
-- Name: ax_bahnverkehrsanlage_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_bahnverkehrsanlage_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_bahnverkehrsanlage_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4064 (class 0 OID 0)
-- Dependencies: 2855
-- Name: ax_bahnverkehrsanlage_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_bahnverkehrsanlage_ogc_fid_seq OWNED BY ax_bahnverkehrsanlage.ogc_fid;


--
-- TOC entry 2698 (class 1259 OID 5501227)
-- Dependencies: 3220 3221 3222 961 3
-- Name: ax_baublock; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_baublock (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    baublockbezeichnung integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'MULTIPOLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_baublock OWNER TO postgres;

--
-- TOC entry 4065 (class 0 OID 0)
-- Dependencies: 2698
-- Name: TABLE ax_baublock; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_baublock IS 'B a u b l o c k';


--
-- TOC entry 4066 (class 0 OID 0)
-- Dependencies: 2698
-- Name: COLUMN ax_baublock.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_baublock.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2697 (class 1259 OID 5501225)
-- Dependencies: 3 2698
-- Name: ax_baublock_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_baublock_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_baublock_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4067 (class 0 OID 0)
-- Dependencies: 2697
-- Name: ax_baublock_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_baublock_ogc_fid_seq OWNED BY ax_baublock.ogc_fid;


--
-- TOC entry 2886 (class 1259 OID 5502726)
-- Dependencies: 3522 3523 961 3
-- Name: ax_bauraumoderbodenordnungsrecht; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_bauraumoderbodenordnungsrecht (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    art character varying(40),
    name character varying(15),
    artderfestlegung integer,
    land integer,
    stelle character varying(7),
    bezeichnung character varying(24),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_bauraumoderbodenordnungsrecht OWNER TO postgres;

--
-- TOC entry 4068 (class 0 OID 0)
-- Dependencies: 2886
-- Name: TABLE ax_bauraumoderbodenordnungsrecht; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_bauraumoderbodenordnungsrecht IS 'REO: Bau-, Raum- oder Bodenordnungsrecht';


--
-- TOC entry 4069 (class 0 OID 0)
-- Dependencies: 2886
-- Name: COLUMN ax_bauraumoderbodenordnungsrecht.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bauraumoderbodenordnungsrecht.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4070 (class 0 OID 0)
-- Dependencies: 2886
-- Name: COLUMN ax_bauraumoderbodenordnungsrecht.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bauraumoderbodenordnungsrecht.name IS 'NAM, Eigenname von "Bau-, Raum- oder Bodenordnungsrecht"';


--
-- TOC entry 4071 (class 0 OID 0)
-- Dependencies: 2886
-- Name: COLUMN ax_bauraumoderbodenordnungsrecht.artderfestlegung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bauraumoderbodenordnungsrecht.artderfestlegung IS 'ADF';


--
-- TOC entry 4072 (class 0 OID 0)
-- Dependencies: 2886
-- Name: COLUMN ax_bauraumoderbodenordnungsrecht.bezeichnung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bauraumoderbodenordnungsrecht.bezeichnung IS 'BEZ, Amtlich festgelegte Verschlüsselung von "Bau-, Raum- oder Bodenordnungsrecht"';


--
-- TOC entry 2885 (class 1259 OID 5502724)
-- Dependencies: 2886 3
-- Name: ax_bauraumoderbodenordnungsrecht_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_bauraumoderbodenordnungsrecht_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_bauraumoderbodenordnungsrecht_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4073 (class 0 OID 0)
-- Dependencies: 2885
-- Name: ax_bauraumoderbodenordnungsrecht_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_bauraumoderbodenordnungsrecht_ogc_fid_seq OWNED BY ax_bauraumoderbodenordnungsrecht.ogc_fid;


--
-- TOC entry 2768 (class 1259 OID 5501739)
-- Dependencies: 3308 3309 3310 3 961
-- Name: ax_bauteil; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_bauteil (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character varying(9),
    sonstigesmodell character varying[],
    anlass integer,
    bauart integer,
    lagezurerdoberflaeche integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_bauteil OWNER TO postgres;

--
-- TOC entry 4074 (class 0 OID 0)
-- Dependencies: 2768
-- Name: TABLE ax_bauteil; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_bauteil IS 'B a u t e i l';


--
-- TOC entry 4075 (class 0 OID 0)
-- Dependencies: 2768
-- Name: COLUMN ax_bauteil.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bauteil.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2767 (class 1259 OID 5501737)
-- Dependencies: 3 2768
-- Name: ax_bauteil_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_bauteil_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_bauteil_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4076 (class 0 OID 0)
-- Dependencies: 2767
-- Name: ax_bauteil_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_bauteil_ogc_fid_seq OWNED BY ax_bauteil.ogc_fid;


--
-- TOC entry 2862 (class 1259 OID 5502527)
-- Dependencies: 3481 3482 3 961
-- Name: ax_bauwerkimgewaesserbereich; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_bauwerkimgewaesserbereich (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    bauwerksfunktion integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_bauwerkimgewaesserbereich OWNER TO postgres;

--
-- TOC entry 4077 (class 0 OID 0)
-- Dependencies: 2862
-- Name: TABLE ax_bauwerkimgewaesserbereich; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_bauwerkimgewaesserbereich IS 'B a u w e r k   i m   G e w a e s s e r b e r e i c h';


--
-- TOC entry 4078 (class 0 OID 0)
-- Dependencies: 2862
-- Name: COLUMN ax_bauwerkimgewaesserbereich.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bauwerkimgewaesserbereich.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2861 (class 1259 OID 5502525)
-- Dependencies: 2862 3
-- Name: ax_bauwerkimgewaesserbereich_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_bauwerkimgewaesserbereich_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_bauwerkimgewaesserbereich_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4079 (class 0 OID 0)
-- Dependencies: 2861
-- Name: ax_bauwerkimgewaesserbereich_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_bauwerkimgewaesserbereich_ogc_fid_seq OWNED BY ax_bauwerkimgewaesserbereich.ogc_fid;


--
-- TOC entry 2850 (class 1259 OID 5502425)
-- Dependencies: 3461 3462 961 3
-- Name: ax_bauwerkimverkehrsbereich; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_bauwerkimverkehrsbereich (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    bauwerksfunktion integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_bauwerkimverkehrsbereich OWNER TO postgres;

--
-- TOC entry 4080 (class 0 OID 0)
-- Dependencies: 2850
-- Name: TABLE ax_bauwerkimverkehrsbereich; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_bauwerkimverkehrsbereich IS 'B a u w e r k   i m  V e r k e h s b e r e i c h';


--
-- TOC entry 4081 (class 0 OID 0)
-- Dependencies: 2850
-- Name: COLUMN ax_bauwerkimverkehrsbereich.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bauwerkimverkehrsbereich.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2849 (class 1259 OID 5502423)
-- Dependencies: 2850 3
-- Name: ax_bauwerkimverkehrsbereich_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_bauwerkimverkehrsbereich_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_bauwerkimverkehrsbereich_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4082 (class 0 OID 0)
-- Dependencies: 2849
-- Name: ax_bauwerkimverkehrsbereich_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_bauwerkimverkehrsbereich_ogc_fid_seq OWNED BY ax_bauwerkimverkehrsbereich.ogc_fid;


--
-- TOC entry 2830 (class 1259 OID 5502262)
-- Dependencies: 3428 3429 3 961
-- Name: ax_bauwerkoderanlagefuerindustrieundgewerbe; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_bauwerkoderanlagefuerindustrieundgewerbe (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    bauwerksfunktion integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_bauwerkoderanlagefuerindustrieundgewerbe OWNER TO postgres;

--
-- TOC entry 4083 (class 0 OID 0)
-- Dependencies: 2830
-- Name: TABLE ax_bauwerkoderanlagefuerindustrieundgewerbe; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_bauwerkoderanlagefuerindustrieundgewerbe IS 'Bauwerk oder Anlage fuer Industrie und Gewerbe';


--
-- TOC entry 4084 (class 0 OID 0)
-- Dependencies: 2830
-- Name: COLUMN ax_bauwerkoderanlagefuerindustrieundgewerbe.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bauwerkoderanlagefuerindustrieundgewerbe.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2829 (class 1259 OID 5502260)
-- Dependencies: 2830 3
-- Name: ax_bauwerkoderanlagefuerindustrieundgewerbe_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_bauwerkoderanlagefuerindustrieundgewerbe_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_bauwerkoderanlagefuerindustrieundgewerbe_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4085 (class 0 OID 0)
-- Dependencies: 2829
-- Name: ax_bauwerkoderanlagefuerindustrieundgewerbe_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_bauwerkoderanlagefuerindustrieundgewerbe_ogc_fid_seq OWNED BY ax_bauwerkoderanlagefuerindustrieundgewerbe.ogc_fid;


--
-- TOC entry 2838 (class 1259 OID 5502330)
-- Dependencies: 3443 3444 961 3
-- Name: ax_bauwerkoderanlagefuersportfreizeitunderholung; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_bauwerkoderanlagefuersportfreizeitunderholung (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    bauwerksfunktion integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_bauwerkoderanlagefuersportfreizeitunderholung OWNER TO postgres;

--
-- TOC entry 4086 (class 0 OID 0)
-- Dependencies: 2838
-- Name: TABLE ax_bauwerkoderanlagefuersportfreizeitunderholung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_bauwerkoderanlagefuersportfreizeitunderholung IS 'Bauwerk oder Anlage fuer Sport, Freizeit und Erholung';


--
-- TOC entry 4087 (class 0 OID 0)
-- Dependencies: 2838
-- Name: COLUMN ax_bauwerkoderanlagefuersportfreizeitunderholung.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bauwerkoderanlagefuersportfreizeitunderholung.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2837 (class 1259 OID 5502328)
-- Dependencies: 3 2838
-- Name: ax_bauwerkoderanlagefuersportfreizeitunderholung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_bauwerkoderanlagefuersportfreizeitunderholung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_bauwerkoderanlagefuersportfreizeitunderholung_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4088 (class 0 OID 0)
-- Dependencies: 2837
-- Name: ax_bauwerkoderanlagefuersportfreizeitunderholung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_bauwerkoderanlagefuersportfreizeitunderholung_ogc_fid_seq OWNED BY ax_bauwerkoderanlagefuersportfreizeitunderholung.ogc_fid;


--
-- TOC entry 2682 (class 1259 OID 5501134)
-- Dependencies: 3
-- Name: ax_benutzer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_benutzer (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    profilkennung character(5),
    direkt character(4),
    ist character varying,
    gehoertzu character varying
);


ALTER TABLE public.ax_benutzer OWNER TO postgres;

--
-- TOC entry 2681 (class 1259 OID 5501132)
-- Dependencies: 3 2682
-- Name: ax_benutzer_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_benutzer_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_benutzer_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4089 (class 0 OID 0)
-- Dependencies: 2681
-- Name: ax_benutzer_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_benutzer_ogc_fid_seq OWNED BY ax_benutzer.ogc_fid;


--
-- TOC entry 2684 (class 1259 OID 5501145)
-- Dependencies: 3
-- Name: ax_benutzergruppemitzugriffskontrolle; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_benutzergruppemitzugriffskontrolle (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    bezeichnung character(5),
    land integer,
    stelle integer,
    bestehtaus character varying,
    query character varying,
    zugriffhistorie character(4)
);


ALTER TABLE public.ax_benutzergruppemitzugriffskontrolle OWNER TO postgres;

--
-- TOC entry 2683 (class 1259 OID 5501143)
-- Dependencies: 3 2684
-- Name: ax_benutzergruppemitzugriffskontrolle_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_benutzergruppemitzugriffskontrolle_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_benutzergruppemitzugriffskontrolle_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4090 (class 0 OID 0)
-- Dependencies: 2683
-- Name: ax_benutzergruppemitzugriffskontrolle_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_benutzergruppemitzugriffskontrolle_ogc_fid_seq OWNED BY ax_benutzergruppemitzugriffskontrolle.ogc_fid;


--
-- TOC entry 2686 (class 1259 OID 5501156)
-- Dependencies: 3
-- Name: ax_benutzergruppenba; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_benutzergruppenba (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    bezeichnung character(14),
    land integer,
    stelle integer,
    koordinatenreferenzsystem character varying,
    bestehtaus character varying,
    query character varying,
    art integer,
    ersterstichtag character(10),
    intervall character(14)
);


ALTER TABLE public.ax_benutzergruppenba OWNER TO postgres;

--
-- TOC entry 2685 (class 1259 OID 5501154)
-- Dependencies: 3 2686
-- Name: ax_benutzergruppenba_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_benutzergruppenba_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_benutzergruppenba_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4091 (class 0 OID 0)
-- Dependencies: 2685
-- Name: ax_benutzergruppenba_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_benutzergruppenba_ogc_fid_seq OWNED BY ax_benutzergruppenba.ogc_fid;


--
-- TOC entry 2782 (class 1259 OID 5501854)
-- Dependencies: 3332 3333 3334 961 3
-- Name: ax_bergbaubetrieb; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_bergbaubetrieb (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    abbaugut integer,
    name character varying(50),
    bezeichnung character varying(50),
    zustand integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_bergbaubetrieb OWNER TO postgres;

--
-- TOC entry 4092 (class 0 OID 0)
-- Dependencies: 2782
-- Name: TABLE ax_bergbaubetrieb; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_bergbaubetrieb IS '"Bergbaubetrieb" ist eine Fläche, die für die Förderung des Abbaugutes unter Tage genutzt wird.';


--
-- TOC entry 4093 (class 0 OID 0)
-- Dependencies: 2782
-- Name: COLUMN ax_bergbaubetrieb.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bergbaubetrieb.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4094 (class 0 OID 0)
-- Dependencies: 2782
-- Name: COLUMN ax_bergbaubetrieb.abbaugut; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bergbaubetrieb.abbaugut IS 'AGT "Abbaugut" gibt an, welches Material abgebaut wird.';


--
-- TOC entry 4095 (class 0 OID 0)
-- Dependencies: 2782
-- Name: COLUMN ax_bergbaubetrieb.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bergbaubetrieb.name IS 'NAM "Name" ist der Eigenname von "Bergbaubetrieb".';


--
-- TOC entry 4096 (class 0 OID 0)
-- Dependencies: 2782
-- Name: COLUMN ax_bergbaubetrieb.bezeichnung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bergbaubetrieb.bezeichnung IS 'BEZ "Bezeichnung" ist die von einer Fachstelle vergebene Kurzbezeichnung.';


--
-- TOC entry 4097 (class 0 OID 0)
-- Dependencies: 2782
-- Name: COLUMN ax_bergbaubetrieb.zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bergbaubetrieb.zustand IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Bergbaubetrieb".';


--
-- TOC entry 2781 (class 1259 OID 5501852)
-- Dependencies: 2782 3
-- Name: ax_bergbaubetrieb_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_bergbaubetrieb_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_bergbaubetrieb_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4098 (class 0 OID 0)
-- Dependencies: 2781
-- Name: ax_bergbaubetrieb_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_bergbaubetrieb_ogc_fid_seq OWNED BY ax_bergbaubetrieb.ogc_fid;


--
-- TOC entry 2736 (class 1259 OID 5501527)
-- Dependencies: 3278 3279 3280 961 3
-- Name: ax_besondereflurstuecksgrenze; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_besondereflurstuecksgrenze (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    artderflurstuecksgrenze integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_besondereflurstuecksgrenze OWNER TO postgres;

--
-- TOC entry 4099 (class 0 OID 0)
-- Dependencies: 2736
-- Name: TABLE ax_besondereflurstuecksgrenze; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_besondereflurstuecksgrenze IS 'B e s o n d e r e   F l u r s t u e c k s g r e n z e';


--
-- TOC entry 4100 (class 0 OID 0)
-- Dependencies: 2736
-- Name: COLUMN ax_besondereflurstuecksgrenze.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_besondereflurstuecksgrenze.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2735 (class 1259 OID 5501525)
-- Dependencies: 3 2736
-- Name: ax_besondereflurstuecksgrenze_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_besondereflurstuecksgrenze_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_besondereflurstuecksgrenze_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4101 (class 0 OID 0)
-- Dependencies: 2735
-- Name: ax_besondereflurstuecksgrenze_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_besondereflurstuecksgrenze_ogc_fid_seq OWNED BY ax_besondereflurstuecksgrenze.ogc_fid;


--
-- TOC entry 2770 (class 1259 OID 5501756)
-- Dependencies: 3312 3313 3314 3 961
-- Name: ax_besonderegebaeudelinie; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_besonderegebaeudelinie (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    beschaffenheit integer,
    anlass integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_besonderegebaeudelinie OWNER TO postgres;

--
-- TOC entry 4102 (class 0 OID 0)
-- Dependencies: 2770
-- Name: TABLE ax_besonderegebaeudelinie; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_besonderegebaeudelinie IS 'B e s o n d e r e   G e b a e u d e l i n i e';


--
-- TOC entry 4103 (class 0 OID 0)
-- Dependencies: 2770
-- Name: COLUMN ax_besonderegebaeudelinie.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_besonderegebaeudelinie.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2769 (class 1259 OID 5501754)
-- Dependencies: 2770 3
-- Name: ax_besonderegebaeudelinie_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_besonderegebaeudelinie_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_besonderegebaeudelinie_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4104 (class 0 OID 0)
-- Dependencies: 2769
-- Name: ax_besonderegebaeudelinie_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_besonderegebaeudelinie_ogc_fid_seq OWNED BY ax_besonderegebaeudelinie.ogc_fid;


--
-- TOC entry 2848 (class 1259 OID 5502415)
-- Dependencies: 3
-- Name: ax_besondererbauwerkspunkt; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_besondererbauwerkspunkt (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    punktkennung character varying(15),
    land integer,
    stelle integer
);


ALTER TABLE public.ax_besondererbauwerkspunkt OWNER TO postgres;

--
-- TOC entry 4105 (class 0 OID 0)
-- Dependencies: 2848
-- Name: TABLE ax_besondererbauwerkspunkt; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_besondererbauwerkspunkt IS 'B e s o n d e r e r   B a u w e r k s p u n k t';


--
-- TOC entry 4106 (class 0 OID 0)
-- Dependencies: 2848
-- Name: COLUMN ax_besondererbauwerkspunkt.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_besondererbauwerkspunkt.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2847 (class 1259 OID 5502413)
-- Dependencies: 2848 3
-- Name: ax_besondererbauwerkspunkt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_besondererbauwerkspunkt_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_besondererbauwerkspunkt_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4107 (class 0 OID 0)
-- Dependencies: 2847
-- Name: ax_besondererbauwerkspunkt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_besondererbauwerkspunkt_ogc_fid_seq OWNED BY ax_besondererbauwerkspunkt.ogc_fid;


--
-- TOC entry 2774 (class 1259 OID 5501790)
-- Dependencies: 3
-- Name: ax_besonderergebaeudepunkt; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_besonderergebaeudepunkt (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    land integer,
    stelle integer,
    punktkennung character varying(15),
    art character varying(40),
    name character varying[]
);


ALTER TABLE public.ax_besonderergebaeudepunkt OWNER TO postgres;

--
-- TOC entry 4108 (class 0 OID 0)
-- Dependencies: 2774
-- Name: TABLE ax_besonderergebaeudepunkt; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_besonderergebaeudepunkt IS 'B e s o n d e r e r   G e b a e u d e p u n k t';


--
-- TOC entry 4109 (class 0 OID 0)
-- Dependencies: 2774
-- Name: COLUMN ax_besonderergebaeudepunkt.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_besonderergebaeudepunkt.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2773 (class 1259 OID 5501788)
-- Dependencies: 2774 3
-- Name: ax_besonderergebaeudepunkt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_besonderergebaeudepunkt_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_besonderergebaeudepunkt_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4110 (class 0 OID 0)
-- Dependencies: 2773
-- Name: ax_besonderergebaeudepunkt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_besonderergebaeudepunkt_ogc_fid_seq OWNED BY ax_besonderergebaeudepunkt.ogc_fid;


--
-- TOC entry 2880 (class 1259 OID 5502676)
-- Dependencies: 3510 3511 3512 3 961
-- Name: ax_besondererhoehenpunkt; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_besondererhoehenpunkt (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    sonstigesmodell character(5),
    anlass integer,
    besonderebedeutung integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_besondererhoehenpunkt OWNER TO postgres;

--
-- TOC entry 4111 (class 0 OID 0)
-- Dependencies: 2880
-- Name: TABLE ax_besondererhoehenpunkt; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_besondererhoehenpunkt IS 'B e s o n d e r e r   H ö h e n - P u n k t';


--
-- TOC entry 4112 (class 0 OID 0)
-- Dependencies: 2880
-- Name: COLUMN ax_besondererhoehenpunkt.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_besondererhoehenpunkt.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2879 (class 1259 OID 5502674)
-- Dependencies: 3 2880
-- Name: ax_besondererhoehenpunkt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_besondererhoehenpunkt_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_besondererhoehenpunkt_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4113 (class 0 OID 0)
-- Dependencies: 2879
-- Name: ax_besondererhoehenpunkt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_besondererhoehenpunkt_ogc_fid_seq OWNED BY ax_besondererhoehenpunkt.ogc_fid;


--
-- TOC entry 2700 (class 1259 OID 5501244)
-- Dependencies: 3
-- Name: ax_besonderertopographischerpunkt; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_besonderertopographischerpunkt (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    land integer,
    stelle integer,
    punktkennung character varying(15)
);


ALTER TABLE public.ax_besonderertopographischerpunkt OWNER TO postgres;

--
-- TOC entry 4114 (class 0 OID 0)
-- Dependencies: 2700
-- Name: TABLE ax_besonderertopographischerpunkt; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_besonderertopographischerpunkt IS 'B e s o n d e r e r   T o p o g r a f i s c h e r   P u n k t';


--
-- TOC entry 4115 (class 0 OID 0)
-- Dependencies: 2700
-- Name: COLUMN ax_besonderertopographischerpunkt.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_besonderertopographischerpunkt.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2699 (class 1259 OID 5501242)
-- Dependencies: 2700 3
-- Name: ax_besonderertopographischerpunkt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_besonderertopographischerpunkt_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_besonderertopographischerpunkt_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4116 (class 0 OID 0)
-- Dependencies: 2699
-- Name: ax_besonderertopographischerpunkt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_besonderertopographischerpunkt_ogc_fid_seq OWNED BY ax_besonderertopographischerpunkt.ogc_fid;


--
-- TOC entry 2702 (class 1259 OID 5501254)
-- Dependencies: 3225 3226 3227 3 961
-- Name: ax_bewertung; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_bewertung (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    klassifizierung integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_bewertung OWNER TO postgres;

--
-- TOC entry 4117 (class 0 OID 0)
-- Dependencies: 2702
-- Name: TABLE ax_bewertung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_bewertung IS 'B e w e r t u n g';


--
-- TOC entry 4118 (class 0 OID 0)
-- Dependencies: 2702
-- Name: COLUMN ax_bewertung.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bewertung.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2701 (class 1259 OID 5501252)
-- Dependencies: 3 2702
-- Name: ax_bewertung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_bewertung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_bewertung_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4119 (class 0 OID 0)
-- Dependencies: 2701
-- Name: ax_bewertung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_bewertung_ogc_fid_seq OWNED BY ax_bewertung.ogc_fid;


--
-- TOC entry 2890 (class 1259 OID 5502760)
-- Dependencies: 3528 3529 3 961
-- Name: ax_bodenschaetzung; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_bodenschaetzung (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    art character varying(40),
    name character varying(33),
    kulturart integer,
    bodenart integer,
    zustandsstufeoderbodenstufe integer,
    entstehungsartoderklimastufewasserverhaeltnisse integer,
    bodenzahlodergruenlandgrundzahl integer,
    ackerzahlodergruenlandzahl integer,
    sonstigeangaben integer,
    jahreszahl integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_bodenschaetzung OWNER TO postgres;

--
-- TOC entry 4120 (class 0 OID 0)
-- Dependencies: 2890
-- Name: TABLE ax_bodenschaetzung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_bodenschaetzung IS 'B o d e n s c h a e t z u n g';


--
-- TOC entry 4121 (class 0 OID 0)
-- Dependencies: 2890
-- Name: COLUMN ax_bodenschaetzung.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bodenschaetzung.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2889 (class 1259 OID 5502758)
-- Dependencies: 3 2890
-- Name: ax_bodenschaetzung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_bodenschaetzung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_bodenschaetzung_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4122 (class 0 OID 0)
-- Dependencies: 2889
-- Name: ax_bodenschaetzung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_bodenschaetzung_ogc_fid_seq OWNED BY ax_bodenschaetzung.ogc_fid;


--
-- TOC entry 2870 (class 1259 OID 5502595)
-- Dependencies: 3
-- Name: ax_boeschungkliff; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_boeschungkliff (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character varying(9),
    sonstigesmodell character varying[],
    anlass integer
);


ALTER TABLE public.ax_boeschungkliff OWNER TO postgres;

--
-- TOC entry 4123 (class 0 OID 0)
-- Dependencies: 2870
-- Name: TABLE ax_boeschungkliff; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_boeschungkliff IS 'B o e s c h u n g s k l i f f';


--
-- TOC entry 4124 (class 0 OID 0)
-- Dependencies: 2870
-- Name: COLUMN ax_boeschungkliff.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_boeschungkliff.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2869 (class 1259 OID 5502593)
-- Dependencies: 3 2870
-- Name: ax_boeschungkliff_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_boeschungkliff_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_boeschungkliff_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4125 (class 0 OID 0)
-- Dependencies: 2869
-- Name: ax_boeschungkliff_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_boeschungkliff_ogc_fid_seq OWNED BY ax_boeschungkliff.ogc_fid;


--
-- TOC entry 2872 (class 1259 OID 5502608)
-- Dependencies: 3495 3496 3497 961 3
-- Name: ax_boeschungsflaeche; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_boeschungsflaeche (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character varying(9),
    sonstigesmodell character varying[],
    anlass integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_boeschungsflaeche OWNER TO postgres;

--
-- TOC entry 4126 (class 0 OID 0)
-- Dependencies: 2872
-- Name: TABLE ax_boeschungsflaeche; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_boeschungsflaeche IS 'B o e s c h u n g s f l a e c h e';


--
-- TOC entry 4127 (class 0 OID 0)
-- Dependencies: 2872
-- Name: COLUMN ax_boeschungsflaeche.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_boeschungsflaeche.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2871 (class 1259 OID 5502606)
-- Dependencies: 2872 3
-- Name: ax_boeschungsflaeche_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_boeschungsflaeche_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_boeschungsflaeche_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4128 (class 0 OID 0)
-- Dependencies: 2871
-- Name: ax_boeschungsflaeche_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_boeschungsflaeche_ogc_fid_seq OWNED BY ax_boeschungsflaeche.ogc_fid;


--
-- TOC entry 2762 (class 1259 OID 5501699)
-- Dependencies: 3
-- Name: ax_buchungsblatt; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_buchungsblatt (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    buchungsblattkennzeichen character(13),
    land integer,
    bezirk integer,
    buchungsblattnummermitbuchstabenerweiterung character(7),
    blattart integer,
    art character varying(15)
);


ALTER TABLE public.ax_buchungsblatt OWNER TO postgres;

--
-- TOC entry 4129 (class 0 OID 0)
-- Dependencies: 2762
-- Name: TABLE ax_buchungsblatt; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_buchungsblatt IS 'NREO "Buchungsblatt" enthält die Buchungen (Buchungsstellen und Namensnummern) des Grundbuchs und des Liegenschhaftskatasters (bei buchungsfreien Grundstücken).';


--
-- TOC entry 4130 (class 0 OID 0)
-- Dependencies: 2762
-- Name: COLUMN ax_buchungsblatt.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_buchungsblatt.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2761 (class 1259 OID 5501697)
-- Dependencies: 3 2762
-- Name: ax_buchungsblatt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_buchungsblatt_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_buchungsblatt_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4131 (class 0 OID 0)
-- Dependencies: 2761
-- Name: ax_buchungsblatt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_buchungsblatt_ogc_fid_seq OWNED BY ax_buchungsblatt.ogc_fid;


--
-- TOC entry 2906 (class 1259 OID 5502855)
-- Dependencies: 3
-- Name: ax_buchungsblattbezirk; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_buchungsblattbezirk (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    schluesselgesamt integer,
    bezeichnung character varying(26),
    land integer,
    bezirk integer,
    "gehoertzu|ax_dienststelle_schluessel|land" integer,
    stelle character varying(4)
);


ALTER TABLE public.ax_buchungsblattbezirk OWNER TO postgres;

--
-- TOC entry 4132 (class 0 OID 0)
-- Dependencies: 2906
-- Name: TABLE ax_buchungsblattbezirk; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_buchungsblattbezirk IS 'Buchungsblatt- B e z i r k';


--
-- TOC entry 4133 (class 0 OID 0)
-- Dependencies: 2906
-- Name: COLUMN ax_buchungsblattbezirk.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_buchungsblattbezirk.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2905 (class 1259 OID 5502853)
-- Dependencies: 3 2906
-- Name: ax_buchungsblattbezirk_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_buchungsblattbezirk_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_buchungsblattbezirk_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4134 (class 0 OID 0)
-- Dependencies: 2905
-- Name: ax_buchungsblattbezirk_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_buchungsblattbezirk_ogc_fid_seq OWNED BY ax_buchungsblattbezirk.ogc_fid;


--
-- TOC entry 2764 (class 1259 OID 5501709)
-- Dependencies: 3
-- Name: ax_buchungsstelle; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_buchungsstelle (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(8),
    anlass integer,
    buchungsart integer,
    laufendenummer integer,
    beschreibungdesumfangsderbuchung character(1),
    zaehler double precision,
    nenner integer,
    nummerimaufteilungsplan character varying(40),
    beschreibungdessondereigentums character varying(400)
);


ALTER TABLE public.ax_buchungsstelle OWNER TO postgres;

--
-- TOC entry 4135 (class 0 OID 0)
-- Dependencies: 2764
-- Name: TABLE ax_buchungsstelle; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_buchungsstelle IS 'NREO "Buchungsstelle" ist die unter einer laufenden Nummer im Verzeichnis des Buchungsblattes eingetragene Buchung.';


--
-- TOC entry 4136 (class 0 OID 0)
-- Dependencies: 2764
-- Name: COLUMN ax_buchungsstelle.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_buchungsstelle.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2763 (class 1259 OID 5501707)
-- Dependencies: 2764 3
-- Name: ax_buchungsstelle_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_buchungsstelle_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_buchungsstelle_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4137 (class 0 OID 0)
-- Dependencies: 2763
-- Name: ax_buchungsstelle_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_buchungsstelle_ogc_fid_seq OWNED BY ax_buchungsstelle.ogc_fid;


--
-- TOC entry 2894 (class 1259 OID 5502794)
-- Dependencies: 3
-- Name: ax_bundesland; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_bundesland (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    schluesselgesamt integer,
    bezeichnung character varying(30),
    land integer
);


ALTER TABLE public.ax_bundesland OWNER TO postgres;

--
-- TOC entry 4138 (class 0 OID 0)
-- Dependencies: 2894
-- Name: TABLE ax_bundesland; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_bundesland IS 'B u n d e s l a n d';


--
-- TOC entry 4139 (class 0 OID 0)
-- Dependencies: 2894
-- Name: COLUMN ax_bundesland.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_bundesland.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2893 (class 1259 OID 5502792)
-- Dependencies: 3 2894
-- Name: ax_bundesland_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_bundesland_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_bundesland_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4140 (class 0 OID 0)
-- Dependencies: 2893
-- Name: ax_bundesland_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_bundesland_ogc_fid_seq OWNED BY ax_bundesland.ogc_fid;


--
-- TOC entry 2874 (class 1259 OID 5502625)
-- Dependencies: 3499 3500 961 3
-- Name: ax_dammwalldeich; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_dammwalldeich (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    art integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_dammwalldeich OWNER TO postgres;

--
-- TOC entry 4141 (class 0 OID 0)
-- Dependencies: 2874
-- Name: TABLE ax_dammwalldeich; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_dammwalldeich IS 'D a m m  /  W a l l  /  D e i c h';


--
-- TOC entry 4142 (class 0 OID 0)
-- Dependencies: 2874
-- Name: COLUMN ax_dammwalldeich.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_dammwalldeich.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2873 (class 1259 OID 5502623)
-- Dependencies: 3 2874
-- Name: ax_dammwalldeich_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_dammwalldeich_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_dammwalldeich_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4143 (class 0 OID 0)
-- Dependencies: 2873
-- Name: ax_dammwalldeich_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_dammwalldeich_ogc_fid_seq OWNED BY ax_dammwalldeich.ogc_fid;


--
-- TOC entry 2704 (class 1259 OID 5501271)
-- Dependencies: 3229 3230 961 3
-- Name: ax_denkmalschutzrecht; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_denkmalschutzrecht (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    artderfestlegung integer,
    art character varying(40),
    name character varying(25),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_denkmalschutzrecht OWNER TO postgres;

--
-- TOC entry 4144 (class 0 OID 0)
-- Dependencies: 2704
-- Name: TABLE ax_denkmalschutzrecht; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_denkmalschutzrecht IS 'D e n k m a l s c h u t z r e c h t';


--
-- TOC entry 4145 (class 0 OID 0)
-- Dependencies: 2704
-- Name: COLUMN ax_denkmalschutzrecht.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_denkmalschutzrecht.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2703 (class 1259 OID 5501269)
-- Dependencies: 2704 3
-- Name: ax_denkmalschutzrecht_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_denkmalschutzrecht_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_denkmalschutzrecht_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4146 (class 0 OID 0)
-- Dependencies: 2703
-- Name: ax_denkmalschutzrecht_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_denkmalschutzrecht_ogc_fid_seq OWNED BY ax_denkmalschutzrecht.ogc_fid;


--
-- TOC entry 2908 (class 1259 OID 5502866)
-- Dependencies: 3
-- Name: ax_dienststelle; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_dienststelle (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    sonstigesmodell character varying(8),
    anlass integer,
    schluesselgesamt character varying(7),
    bezeichnung character varying(120),
    land integer,
    stelle character varying(5),
    stellenart integer
);


ALTER TABLE public.ax_dienststelle OWNER TO postgres;

--
-- TOC entry 4147 (class 0 OID 0)
-- Dependencies: 2908
-- Name: TABLE ax_dienststelle; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_dienststelle IS 'D i e n s t s t e l l e';


--
-- TOC entry 4148 (class 0 OID 0)
-- Dependencies: 2908
-- Name: COLUMN ax_dienststelle.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_dienststelle.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2907 (class 1259 OID 5502864)
-- Dependencies: 2908 3
-- Name: ax_dienststelle_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_dienststelle_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_dienststelle_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4149 (class 0 OID 0)
-- Dependencies: 2907
-- Name: ax_dienststelle_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_dienststelle_ogc_fid_seq OWNED BY ax_dienststelle.ogc_fid;


--
-- TOC entry 2846 (class 1259 OID 5502398)
-- Dependencies: 3456 3457 3458 961 3
-- Name: ax_einrichtunginoeffentlichenbereichen; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_einrichtunginoeffentlichenbereichen (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    sonstigesmodell character(6),
    anlass integer,
    art integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_einrichtunginoeffentlichenbereichen OWNER TO postgres;

--
-- TOC entry 4150 (class 0 OID 0)
-- Dependencies: 2846
-- Name: TABLE ax_einrichtunginoeffentlichenbereichen; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_einrichtunginoeffentlichenbereichen IS 'E i n r i c h t u n g   i n   O e f f e n t l i c h e n   B e r e i c h e n';


--
-- TOC entry 4151 (class 0 OID 0)
-- Dependencies: 2846
-- Name: COLUMN ax_einrichtunginoeffentlichenbereichen.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_einrichtunginoeffentlichenbereichen.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2845 (class 1259 OID 5502396)
-- Dependencies: 3 2846
-- Name: ax_einrichtunginoeffentlichenbereichen_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_einrichtunginoeffentlichenbereichen_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_einrichtunginoeffentlichenbereichen_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4152 (class 0 OID 0)
-- Dependencies: 2845
-- Name: ax_einrichtunginoeffentlichenbereichen_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_einrichtunginoeffentlichenbereichen_ogc_fid_seq OWNED BY ax_einrichtunginoeffentlichenbereichen.ogc_fid;


--
-- TOC entry 2876 (class 1259 OID 5502642)
-- Dependencies: 3502 3503 3504 3 961
-- Name: ax_felsenfelsblockfelsnadel; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_felsenfelsblockfelsnadel (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    name character varying(30),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_felsenfelsblockfelsnadel OWNER TO postgres;

--
-- TOC entry 4153 (class 0 OID 0)
-- Dependencies: 2876
-- Name: TABLE ax_felsenfelsblockfelsnadel; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_felsenfelsblockfelsnadel IS 'F e l s e n ,  F e l s b l o c k ,   F e l s n a d e l';


--
-- TOC entry 4154 (class 0 OID 0)
-- Dependencies: 2876
-- Name: COLUMN ax_felsenfelsblockfelsnadel.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_felsenfelsblockfelsnadel.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2875 (class 1259 OID 5502640)
-- Dependencies: 3 2876
-- Name: ax_felsenfelsblockfelsnadel_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_felsenfelsblockfelsnadel_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_felsenfelsblockfelsnadel_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4155 (class 0 OID 0)
-- Dependencies: 2875
-- Name: ax_felsenfelsblockfelsnadel_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_felsenfelsblockfelsnadel_ogc_fid_seq OWNED BY ax_felsenfelsblockfelsnadel.ogc_fid;


--
-- TOC entry 2772 (class 1259 OID 5501773)
-- Dependencies: 3316 3317 3318 961 3
-- Name: ax_firstlinie; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_firstlinie (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character varying(9),
    sonstigesmodell character varying(8),
    anlass integer,
    art character varying(40),
    uri character varying(28),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_firstlinie OWNER TO postgres;

--
-- TOC entry 4156 (class 0 OID 0)
-- Dependencies: 2772
-- Name: TABLE ax_firstlinie; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_firstlinie IS 'F i r s t l i n i e';


--
-- TOC entry 4157 (class 0 OID 0)
-- Dependencies: 2772
-- Name: COLUMN ax_firstlinie.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_firstlinie.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2771 (class 1259 OID 5501771)
-- Dependencies: 3 2772
-- Name: ax_firstlinie_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_firstlinie_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_firstlinie_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4158 (class 0 OID 0)
-- Dependencies: 2771
-- Name: ax_firstlinie_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_firstlinie_ogc_fid_seq OWNED BY ax_firstlinie.ogc_fid;


--
-- TOC entry 2788 (class 1259 OID 5501905)
-- Dependencies: 3344 3345 3346 3 961
-- Name: ax_flaechebesondererfunktionalerpraegung; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_flaechebesondererfunktionalerpraegung (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    artderbebauung integer,
    name character varying(50),
    zustand integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_flaechebesondererfunktionalerpraegung OWNER TO postgres;

--
-- TOC entry 4159 (class 0 OID 0)
-- Dependencies: 2788
-- Name: TABLE ax_flaechebesondererfunktionalerpraegung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_flaechebesondererfunktionalerpraegung IS '"Fläche besonderer funktionaler Prägung" ist eine baulich geprägte Fläche einschließlich der mit ihr im Zusammenhang stehenden Freifläche, auf denen vorwiegend Gebäude und/oder Anlagen zur Erfüllung öffentlicher Zwecke oder historische Anlagen vorhanden sind.';


--
-- TOC entry 4160 (class 0 OID 0)
-- Dependencies: 2788
-- Name: COLUMN ax_flaechebesondererfunktionalerpraegung.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flaechebesondererfunktionalerpraegung.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4161 (class 0 OID 0)
-- Dependencies: 2788
-- Name: COLUMN ax_flaechebesondererfunktionalerpraegung.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flaechebesondererfunktionalerpraegung.funktion IS 'FKT "Funktion" ist die zum Zeitpunkt der Erhebung vorherrschende Nutzung von "Fläche besonderer funktionaler Prägung".';


--
-- TOC entry 4162 (class 0 OID 0)
-- Dependencies: 2788
-- Name: COLUMN ax_flaechebesondererfunktionalerpraegung.artderbebauung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flaechebesondererfunktionalerpraegung.artderbebauung IS 'BEB "Art der Bebauung" differenziert nach offener und geschlossener Bauweise aus topographischer Sicht und nicht nach gesetzlichen Vorgaben (z.B. BauGB).';


--
-- TOC entry 4163 (class 0 OID 0)
-- Dependencies: 2788
-- Name: COLUMN ax_flaechebesondererfunktionalerpraegung.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flaechebesondererfunktionalerpraegung.name IS 'NAM "Name" ist der Eigenname von "Fläche besonderer funktionaler Prägung" insbesondere außerhalb von Ortslagen.';


--
-- TOC entry 4164 (class 0 OID 0)
-- Dependencies: 2788
-- Name: COLUMN ax_flaechebesondererfunktionalerpraegung.zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flaechebesondererfunktionalerpraegung.zustand IS 'ZUS  "Zustand" beschreibt die Betriebsbereitschaft von "Fläche funktionaler Prägung".';


--
-- TOC entry 2787 (class 1259 OID 5501903)
-- Dependencies: 3 2788
-- Name: ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4165 (class 0 OID 0)
-- Dependencies: 2787
-- Name: ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq OWNED BY ax_flaechebesondererfunktionalerpraegung.ogc_fid;


--
-- TOC entry 2786 (class 1259 OID 5501888)
-- Dependencies: 3340 3341 3342 3 961
-- Name: ax_flaechegemischternutzung; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_flaechegemischternutzung (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    artderbebauung integer,
    funktion integer,
    name character varying(50),
    zustand integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_flaechegemischternutzung OWNER TO postgres;

--
-- TOC entry 4166 (class 0 OID 0)
-- Dependencies: 2786
-- Name: TABLE ax_flaechegemischternutzung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_flaechegemischternutzung IS '"Fläche gemischter Nutzung" ist eine bebaute Fläche einschließlich der mit ihr im Zusammenhang stehenden Freifläche (Hofraumfläche, Hausgarten), auf der keine Art der baulichen Nutzung vorherrscht. Solche Flächen sind insbesondere ländlich-dörflich geprägte Flächen mit land- und forstwirtschaftlichen Betrieben, Wohngebäuden u.a. sowie städtisch geprägte Kerngebiete mit Handelsbetrieben und zentralen Einrichtungen für die Wirtschaft und die Verwaltung.';


--
-- TOC entry 4167 (class 0 OID 0)
-- Dependencies: 2786
-- Name: COLUMN ax_flaechegemischternutzung.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flaechegemischternutzung.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4168 (class 0 OID 0)
-- Dependencies: 2786
-- Name: COLUMN ax_flaechegemischternutzung.artderbebauung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flaechegemischternutzung.artderbebauung IS 'BEB "Art der Bebauung" differenziert nach offener und geschlossener Bauweise aus topographischer Sicht und nicht nach gesetzlichen Vorgaben (z.B. BauGB).';


--
-- TOC entry 4169 (class 0 OID 0)
-- Dependencies: 2786
-- Name: COLUMN ax_flaechegemischternutzung.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flaechegemischternutzung.funktion IS 'FKT "Funktion" ist die zum Zeitpunkt der Erhebung vorherrschende Nutzung (Dominanzprinzip).';


--
-- TOC entry 4170 (class 0 OID 0)
-- Dependencies: 2786
-- Name: COLUMN ax_flaechegemischternutzung.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flaechegemischternutzung.name IS 'NAM "Name" ist der Eigenname von "Fläche gemischter Nutzung" insbesondere bei Objekten außerhalb von Ortslagen.';


--
-- TOC entry 4171 (class 0 OID 0)
-- Dependencies: 2786
-- Name: COLUMN ax_flaechegemischternutzung.zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flaechegemischternutzung.zustand IS 'ZUS "Zustand" beschreibt, ob "Fläche gemischter Nutzung" ungenutzt ist.';


--
-- TOC entry 2785 (class 1259 OID 5501886)
-- Dependencies: 3 2786
-- Name: ax_flaechegemischternutzung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_flaechegemischternutzung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_flaechegemischternutzung_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4172 (class 0 OID 0)
-- Dependencies: 2785
-- Name: ax_flaechegemischternutzung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_flaechegemischternutzung_ogc_fid_seq OWNED BY ax_flaechegemischternutzung.ogc_fid;


--
-- TOC entry 2820 (class 1259 OID 5502177)
-- Dependencies: 3408 3409 3410 961 3
-- Name: ax_fliessgewaesser; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_fliessgewaesser (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    name character varying(50),
    zustand integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_fliessgewaesser OWNER TO postgres;

--
-- TOC entry 4173 (class 0 OID 0)
-- Dependencies: 2820
-- Name: TABLE ax_fliessgewaesser; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_fliessgewaesser IS '"F l i e s s g e w a e s s e r" ist ein geometrisch begrenztes, oberirdisches, auf dem Festland fließendes Gewässer, das die Wassermengen sammelt, die als Niederschläge auf die Erdoberfläche fallen oder in Quellen austreten, und in ein anderes Gewässer, ein Meer oder in einen See transportiert';


--
-- TOC entry 4174 (class 0 OID 0)
-- Dependencies: 2820
-- Name: COLUMN ax_fliessgewaesser.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_fliessgewaesser.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4175 (class 0 OID 0)
-- Dependencies: 2820
-- Name: COLUMN ax_fliessgewaesser.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_fliessgewaesser.funktion IS 'FKT "Funktion" ist die Art von "Fließgewässer".';


--
-- TOC entry 4176 (class 0 OID 0)
-- Dependencies: 2820
-- Name: COLUMN ax_fliessgewaesser.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_fliessgewaesser.name IS 'NAM "Name" ist die Bezeichnung oder der Eigenname von "Fließgewässer".';


--
-- TOC entry 4177 (class 0 OID 0)
-- Dependencies: 2820
-- Name: COLUMN ax_fliessgewaesser.zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_fliessgewaesser.zustand IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Fließgewässer" mit FKT=8300 (Kanal).';


--
-- TOC entry 2819 (class 1259 OID 5502175)
-- Dependencies: 3 2820
-- Name: ax_fliessgewaesser_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_fliessgewaesser_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_fliessgewaesser_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4178 (class 0 OID 0)
-- Dependencies: 2819
-- Name: ax_fliessgewaesser_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_fliessgewaesser_ogc_fid_seq OWNED BY ax_fliessgewaesser.ogc_fid;


--
-- TOC entry 2802 (class 1259 OID 5502024)
-- Dependencies: 3372 3373 3374 3 961
-- Name: ax_flugverkehr; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_flugverkehr (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    art integer,
    name character varying(50),
    bezeichnung character varying(50),
    nutzung integer,
    zustand integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_flugverkehr OWNER TO postgres;

--
-- TOC entry 4179 (class 0 OID 0)
-- Dependencies: 2802
-- Name: TABLE ax_flugverkehr; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_flugverkehr IS '"F l u g v e r k e h r"  umfasst die baulich geprägte Fläche und die mit ihr in Zusammenhang stehende Freifläche, die ausschließlich oder vorwiegend dem Flugverkehr dient.';


--
-- TOC entry 4180 (class 0 OID 0)
-- Dependencies: 2802
-- Name: COLUMN ax_flugverkehr.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flugverkehr.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4181 (class 0 OID 0)
-- Dependencies: 2802
-- Name: COLUMN ax_flugverkehr.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flugverkehr.funktion IS 'FKT "Funktion" ist die zum Zeitpunkt der Erhebung vorherrschende Nutzung (Dominanzprinzip).';


--
-- TOC entry 4182 (class 0 OID 0)
-- Dependencies: 2802
-- Name: COLUMN ax_flugverkehr.art; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flugverkehr.art IS 'ART "Art" ist Einstufung der Flugverkehrsfläche durch das Luftfahrtbundesamt.';


--
-- TOC entry 4183 (class 0 OID 0)
-- Dependencies: 2802
-- Name: COLUMN ax_flugverkehr.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flugverkehr.name IS 'NAM "Name" ist der Eigenname von "Flugverkehr".';


--
-- TOC entry 4184 (class 0 OID 0)
-- Dependencies: 2802
-- Name: COLUMN ax_flugverkehr.bezeichnung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flugverkehr.bezeichnung IS 'BEZ "Bezeichnung" ist die von einer Fachstelle vergebene Kennziffer von "Flugverkehr".';


--
-- TOC entry 4185 (class 0 OID 0)
-- Dependencies: 2802
-- Name: COLUMN ax_flugverkehr.nutzung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flugverkehr.nutzung IS 'NTZ "Nutzung" gibt den Nutzerkreis von "Flugverkehr" an.';


--
-- TOC entry 4186 (class 0 OID 0)
-- Dependencies: 2802
-- Name: COLUMN ax_flugverkehr.zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flugverkehr.zustand IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Flugverkehr".';


--
-- TOC entry 2801 (class 1259 OID 5502022)
-- Dependencies: 2802 3
-- Name: ax_flugverkehr_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_flugverkehr_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_flugverkehr_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4187 (class 0 OID 0)
-- Dependencies: 2801
-- Name: ax_flugverkehr_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_flugverkehr_ogc_fid_seq OWNED BY ax_flugverkehr.ogc_fid;


--
-- TOC entry 2860 (class 1259 OID 5502510)
-- Dependencies: 3477 3478 3479 3 961
-- Name: ax_flugverkehrsanlage; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_flugverkehrsanlage (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    sonstigesmodell character(5),
    anlass integer,
    art integer,
    oberflaechenmaterial integer,
    name character(20),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_flugverkehrsanlage OWNER TO postgres;

--
-- TOC entry 4188 (class 0 OID 0)
-- Dependencies: 2860
-- Name: TABLE ax_flugverkehrsanlage; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_flugverkehrsanlage IS 'F l u g v e r k e h r s a n l a g e';


--
-- TOC entry 4189 (class 0 OID 0)
-- Dependencies: 2860
-- Name: COLUMN ax_flugverkehrsanlage.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flugverkehrsanlage.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2859 (class 1259 OID 5502508)
-- Dependencies: 2860 3
-- Name: ax_flugverkehrsanlage_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_flugverkehrsanlage_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_flugverkehrsanlage_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4190 (class 0 OID 0)
-- Dependencies: 2859
-- Name: ax_flugverkehrsanlage_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_flugverkehrsanlage_ogc_fid_seq OWNED BY ax_flugverkehrsanlage.ogc_fid;


--
-- TOC entry 2734 (class 1259 OID 5501510)
-- Dependencies: 3275 3276 3 961
-- Name: ax_flurstueck; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_flurstueck (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(8),
    anlass integer,
    art character varying(80),
    name character varying(80),
    land integer,
    gemarkungsnummer integer,
    flurnummer integer,
    zaehler integer,
    nenner integer,
    flurstueckskennzeichen character(20),
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    amtlicheflaeche double precision,
    rechtsbehelfsverfahren integer,
    zeitpunktderentstehung character(10),
    "gemeindezugehoerigkeit|ax_gemeindekennzeichen|land" integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_flurstueck OWNER TO postgres;

--
-- TOC entry 4191 (class 0 OID 0)
-- Dependencies: 2734
-- Name: TABLE ax_flurstueck; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_flurstueck IS 'F l u r s t u e c k';


--
-- TOC entry 4192 (class 0 OID 0)
-- Dependencies: 2734
-- Name: COLUMN ax_flurstueck.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_flurstueck.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2733 (class 1259 OID 5501508)
-- Dependencies: 2734 3
-- Name: ax_flurstueck_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_flurstueck_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_flurstueck_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4193 (class 0 OID 0)
-- Dependencies: 2733
-- Name: ax_flurstueck_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_flurstueck_ogc_fid_seq OWNED BY ax_flurstueck.ogc_fid;


--
-- TOC entry 2792 (class 1259 OID 5501939)
-- Dependencies: 3352 3353 3354 961 3
-- Name: ax_friedhof; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_friedhof (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    name character(50),
    zustand integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_friedhof OWNER TO postgres;

--
-- TOC entry 4194 (class 0 OID 0)
-- Dependencies: 2792
-- Name: TABLE ax_friedhof; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_friedhof IS '"F r i e d h o f"  ist eine Fläche, auf der Tote bestattet sind.';


--
-- TOC entry 4195 (class 0 OID 0)
-- Dependencies: 2792
-- Name: COLUMN ax_friedhof.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_friedhof.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4196 (class 0 OID 0)
-- Dependencies: 2792
-- Name: COLUMN ax_friedhof.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_friedhof.funktion IS 'FKT "Funktion" ist die Art der Begräbnisstätte.';


--
-- TOC entry 4197 (class 0 OID 0)
-- Dependencies: 2792
-- Name: COLUMN ax_friedhof.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_friedhof.name IS 'NAM "Name" ist der Eigenname von "Friedhof".';


--
-- TOC entry 4198 (class 0 OID 0)
-- Dependencies: 2792
-- Name: COLUMN ax_friedhof.zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_friedhof.zustand IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Friedhof".';


--
-- TOC entry 2791 (class 1259 OID 5501937)
-- Dependencies: 3 2792
-- Name: ax_friedhof_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_friedhof_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_friedhof_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4199 (class 0 OID 0)
-- Dependencies: 2791
-- Name: ax_friedhof_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_friedhof_ogc_fid_seq OWNED BY ax_friedhof.ogc_fid;


--
-- TOC entry 2766 (class 1259 OID 5501722)
-- Dependencies: 3305 3306 3 961
-- Name: ax_gebaeude; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_gebaeude (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    gebaeudefunktion integer,
    description integer,
    name character varying(25),
    lagezurerdoberflaeche integer,
    art character varying(40),
    bauweise integer,
    anzahlderoberirdischengeschosse integer,
    grundflaeche integer,
    "qualitaetsangaben|ax_dqmitdatenerhebung|herkunft|li_lineage|pro" character varying(8),
    individualname character varying(7),
    zustand integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_gebaeude OWNER TO postgres;

--
-- TOC entry 4200 (class 0 OID 0)
-- Dependencies: 2766
-- Name: TABLE ax_gebaeude; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_gebaeude IS 'G e b a e u d e';


--
-- TOC entry 4201 (class 0 OID 0)
-- Dependencies: 2766
-- Name: COLUMN ax_gebaeude.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_gebaeude.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2765 (class 1259 OID 5501720)
-- Dependencies: 2766 3
-- Name: ax_gebaeude_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_gebaeude_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_gebaeude_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4202 (class 0 OID 0)
-- Dependencies: 2765
-- Name: ax_gebaeude_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_gebaeude_ogc_fid_seq OWNED BY ax_gebaeude.ogc_fid;


--
-- TOC entry 2706 (class 1259 OID 5501288)
-- Dependencies: 3232 3233 3234 3 961
-- Name: ax_gebaeudeausgestaltung; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_gebaeudeausgestaltung (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    darstellung integer,
    zeigtauf character varying,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_gebaeudeausgestaltung OWNER TO postgres;

--
-- TOC entry 4203 (class 0 OID 0)
-- Dependencies: 2706
-- Name: TABLE ax_gebaeudeausgestaltung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_gebaeudeausgestaltung IS 'G e b a e u d e a u s g e s t a l t u n g';


--
-- TOC entry 4204 (class 0 OID 0)
-- Dependencies: 2706
-- Name: COLUMN ax_gebaeudeausgestaltung.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_gebaeudeausgestaltung.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2705 (class 1259 OID 5501286)
-- Dependencies: 3 2706
-- Name: ax_gebaeudeausgestaltung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_gebaeudeausgestaltung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_gebaeudeausgestaltung_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4205 (class 0 OID 0)
-- Dependencies: 2705
-- Name: ax_gebaeudeausgestaltung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_gebaeudeausgestaltung_ogc_fid_seq OWNED BY ax_gebaeudeausgestaltung.ogc_fid;


--
-- TOC entry 2810 (class 1259 OID 5502092)
-- Dependencies: 3388 3389 3390 961 3
-- Name: ax_gehoelz; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_gehoelz (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    vegetationsmerkmal integer,
    name character varying(50),
    funktion integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_gehoelz OWNER TO postgres;

--
-- TOC entry 4206 (class 0 OID 0)
-- Dependencies: 2810
-- Name: TABLE ax_gehoelz; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_gehoelz IS '"G e h o e l z" ist eine Fläche, die mit einzelnen Bäumen, Baumgruppen, Büschen, Hecken und Sträuchern bestockt ist.';


--
-- TOC entry 4207 (class 0 OID 0)
-- Dependencies: 2810
-- Name: COLUMN ax_gehoelz.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_gehoelz.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4208 (class 0 OID 0)
-- Dependencies: 2810
-- Name: COLUMN ax_gehoelz.vegetationsmerkmal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_gehoelz.vegetationsmerkmal IS 'VEG "Vegetationsmerkmal" beschreibt den Bewuchs von "Gehölz".';


--
-- TOC entry 4209 (class 0 OID 0)
-- Dependencies: 2810
-- Name: COLUMN ax_gehoelz.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_gehoelz.name IS 'NAM "Name" ist der Eigenname von "Wald".';


--
-- TOC entry 4210 (class 0 OID 0)
-- Dependencies: 2810
-- Name: COLUMN ax_gehoelz.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_gehoelz.funktion IS 'FKT "Funktion" beschreibt, welchem Zweck "Gehölz" dient.';


--
-- TOC entry 2809 (class 1259 OID 5502090)
-- Dependencies: 3 2810
-- Name: ax_gehoelz_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_gehoelz_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_gehoelz_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4211 (class 0 OID 0)
-- Dependencies: 2809
-- Name: ax_gehoelz_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_gehoelz_ogc_fid_seq OWNED BY ax_gehoelz.ogc_fid;


--
-- TOC entry 2878 (class 1259 OID 5502659)
-- Dependencies: 3506 3507 3508 3 961
-- Name: ax_gelaendekante; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_gelaendekante (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    sonstigesmodell character(5),
    anlass integer,
    istteilvon character varying,
    artdergelaendekante integer,
    ax_dqerfassungsmethode integer,
    identifikation integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_gelaendekante OWNER TO postgres;

--
-- TOC entry 4212 (class 0 OID 0)
-- Dependencies: 2878
-- Name: TABLE ax_gelaendekante; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_gelaendekante IS 'G e l a e n d e k a n t e';


--
-- TOC entry 4213 (class 0 OID 0)
-- Dependencies: 2878
-- Name: COLUMN ax_gelaendekante.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_gelaendekante.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2877 (class 1259 OID 5502657)
-- Dependencies: 3 2878
-- Name: ax_gelaendekante_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_gelaendekante_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_gelaendekante_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4214 (class 0 OID 0)
-- Dependencies: 2877
-- Name: ax_gelaendekante_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_gelaendekante_ogc_fid_seq OWNED BY ax_gelaendekante.ogc_fid;


--
-- TOC entry 2902 (class 1259 OID 5502834)
-- Dependencies: 3
-- Name: ax_gemarkung; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_gemarkung (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    schluesselgesamt integer,
    bezeichnung character varying(23),
    land integer,
    gemarkungsnummer integer,
    "istamtsbezirkvon|ax_dienststelle_schluessel|land" integer,
    stelle integer
);


ALTER TABLE public.ax_gemarkung OWNER TO postgres;

--
-- TOC entry 4215 (class 0 OID 0)
-- Dependencies: 2902
-- Name: TABLE ax_gemarkung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_gemarkung IS 'G e m a r k u n g';


--
-- TOC entry 4216 (class 0 OID 0)
-- Dependencies: 2902
-- Name: COLUMN ax_gemarkung.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_gemarkung.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2901 (class 1259 OID 5502832)
-- Dependencies: 2902 3
-- Name: ax_gemarkung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_gemarkung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_gemarkung_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4217 (class 0 OID 0)
-- Dependencies: 2901
-- Name: ax_gemarkung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_gemarkung_ogc_fid_seq OWNED BY ax_gemarkung.ogc_fid;


--
-- TOC entry 2904 (class 1259 OID 5502845)
-- Dependencies: 3
-- Name: ax_gemarkungsteilflur; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_gemarkungsteilflur (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    schluesselgesamt integer,
    bezeichnung character varying(7),
    land integer,
    gemarkung integer,
    gemarkungsteilflur integer
);


ALTER TABLE public.ax_gemarkungsteilflur OWNER TO postgres;

--
-- TOC entry 4218 (class 0 OID 0)
-- Dependencies: 2904
-- Name: TABLE ax_gemarkungsteilflur; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_gemarkungsteilflur IS 'G e m a r k u n g s t e i l   /   F l u r';


--
-- TOC entry 4219 (class 0 OID 0)
-- Dependencies: 2904
-- Name: COLUMN ax_gemarkungsteilflur.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_gemarkungsteilflur.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2903 (class 1259 OID 5502843)
-- Dependencies: 3 2904
-- Name: ax_gemarkungsteilflur_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_gemarkungsteilflur_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_gemarkungsteilflur_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4220 (class 0 OID 0)
-- Dependencies: 2903
-- Name: ax_gemarkungsteilflur_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_gemarkungsteilflur_ogc_fid_seq OWNED BY ax_gemarkungsteilflur.ogc_fid;


--
-- TOC entry 2900 (class 1259 OID 5502824)
-- Dependencies: 3
-- Name: ax_gemeinde; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_gemeinde (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    schluesselgesamt integer,
    bezeichnung character varying(25),
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer
);


ALTER TABLE public.ax_gemeinde OWNER TO postgres;

--
-- TOC entry 4221 (class 0 OID 0)
-- Dependencies: 2900
-- Name: TABLE ax_gemeinde; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_gemeinde IS 'G e m e i n d e';


--
-- TOC entry 4222 (class 0 OID 0)
-- Dependencies: 2900
-- Name: COLUMN ax_gemeinde.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_gemeinde.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2899 (class 1259 OID 5502822)
-- Dependencies: 3 2900
-- Name: ax_gemeinde_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_gemeinde_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_gemeinde_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4223 (class 0 OID 0)
-- Dependencies: 2899
-- Name: ax_gemeinde_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_gemeinde_ogc_fid_seq OWNED BY ax_gemeinde.ogc_fid;


--
-- TOC entry 2708 (class 1259 OID 5501305)
-- Dependencies: 3236 3237 3238 3 961
-- Name: ax_georeferenziertegebaeudeadresse; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_georeferenziertegebaeudeadresse (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    qualitaetsangaben integer,
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    ortsteil integer,
    postleitzahl character varying(5),
    ortsnamepost character varying(40),
    zusatzortsname character varying(30),
    strassenname character varying(50),
    strassenschluessel integer,
    hausnummer integer,
    adressierungszusatz character(1),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_georeferenziertegebaeudeadresse OWNER TO postgres;

--
-- TOC entry 4224 (class 0 OID 0)
-- Dependencies: 2708
-- Name: TABLE ax_georeferenziertegebaeudeadresse; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_georeferenziertegebaeudeadresse IS 'Georeferenzierte  G e b ä u d e a d r e s s e';


--
-- TOC entry 4225 (class 0 OID 0)
-- Dependencies: 2708
-- Name: COLUMN ax_georeferenziertegebaeudeadresse.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_georeferenziertegebaeudeadresse.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2707 (class 1259 OID 5501303)
-- Dependencies: 2708 3
-- Name: ax_georeferenziertegebaeudeadresse_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_georeferenziertegebaeudeadresse_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_georeferenziertegebaeudeadresse_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4226 (class 0 OID 0)
-- Dependencies: 2707
-- Name: ax_georeferenziertegebaeudeadresse_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_georeferenziertegebaeudeadresse_ogc_fid_seq OWNED BY ax_georeferenziertegebaeudeadresse.ogc_fid;


--
-- TOC entry 2866 (class 1259 OID 5502561)
-- Dependencies: 3487 3488 3489 961 3
-- Name: ax_gewaessermerkmal; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_gewaessermerkmal (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    art integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_gewaessermerkmal OWNER TO postgres;

--
-- TOC entry 4227 (class 0 OID 0)
-- Dependencies: 2866
-- Name: TABLE ax_gewaessermerkmal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_gewaessermerkmal IS 'G e w a e s s e r m e r k m a l';


--
-- TOC entry 4228 (class 0 OID 0)
-- Dependencies: 2866
-- Name: COLUMN ax_gewaessermerkmal.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_gewaessermerkmal.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2865 (class 1259 OID 5502559)
-- Dependencies: 2866 3
-- Name: ax_gewaessermerkmal_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_gewaessermerkmal_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_gewaessermerkmal_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4229 (class 0 OID 0)
-- Dependencies: 2865
-- Name: ax_gewaessermerkmal_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_gewaessermerkmal_ogc_fid_seq OWNED BY ax_gewaessermerkmal.ogc_fid;


--
-- TOC entry 2858 (class 1259 OID 5502493)
-- Dependencies: 3474 3475 961 3
-- Name: ax_gleis; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_gleis (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    sonstigesmodell character varying[],
    anlass integer,
    bahnkategorie integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_gleis OWNER TO postgres;

--
-- TOC entry 4230 (class 0 OID 0)
-- Dependencies: 2858
-- Name: TABLE ax_gleis; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_gleis IS 'G l e i s';


--
-- TOC entry 4231 (class 0 OID 0)
-- Dependencies: 2858
-- Name: COLUMN ax_gleis.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_gleis.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2857 (class 1259 OID 5502491)
-- Dependencies: 2858 3
-- Name: ax_gleis_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_gleis_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_gleis_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4232 (class 0 OID 0)
-- Dependencies: 2857
-- Name: ax_gleis_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_gleis_ogc_fid_seq OWNED BY ax_gleis.ogc_fid;


--
-- TOC entry 2710 (class 1259 OID 5501323)
-- Dependencies: 3240 3241 3242 3 961
-- Name: ax_grablochderbodenschaetzung; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_grablochderbodenschaetzung (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    art character varying(40),
    name character varying(27),
    bedeutung integer,
    land integer,
    nummerierungsbezirk character varying(10),
    gemarkungsnummer integer,
    nummerdesgrablochs integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_grablochderbodenschaetzung OWNER TO postgres;

--
-- TOC entry 4233 (class 0 OID 0)
-- Dependencies: 2710
-- Name: TABLE ax_grablochderbodenschaetzung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_grablochderbodenschaetzung IS 'G r a b l o c h   d e r   B o d e n s c h a e t z u n g';


--
-- TOC entry 4234 (class 0 OID 0)
-- Dependencies: 2710
-- Name: COLUMN ax_grablochderbodenschaetzung.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_grablochderbodenschaetzung.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2709 (class 1259 OID 5501321)
-- Dependencies: 2710 3
-- Name: ax_grablochderbodenschaetzung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_grablochderbodenschaetzung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_grablochderbodenschaetzung_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4235 (class 0 OID 0)
-- Dependencies: 2709
-- Name: ax_grablochderbodenschaetzung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_grablochderbodenschaetzung_ogc_fid_seq OWNED BY ax_grablochderbodenschaetzung.ogc_fid;


--
-- TOC entry 2738 (class 1259 OID 5501544)
-- Dependencies: 3
-- Name: ax_grenzpunkt; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_grenzpunkt (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(8),
    anlass integer,
    punktkennung character varying(15),
    land integer,
    stelle integer,
    abmarkung_marke integer,
    festgestelltergrenzpunkt character varying(4),
    bemerkungzurabmarkung integer,
    sonstigeeigenschaft character varying[],
    art character varying(40),
    name character varying[],
    zeitpunktderentstehung integer
);


ALTER TABLE public.ax_grenzpunkt OWNER TO postgres;

--
-- TOC entry 4236 (class 0 OID 0)
-- Dependencies: 2738
-- Name: TABLE ax_grenzpunkt; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_grenzpunkt IS 'G r e n z p u n k t';


--
-- TOC entry 4237 (class 0 OID 0)
-- Dependencies: 2738
-- Name: COLUMN ax_grenzpunkt.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_grenzpunkt.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2737 (class 1259 OID 5501542)
-- Dependencies: 3 2738
-- Name: ax_grenzpunkt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_grenzpunkt_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_grenzpunkt_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4238 (class 0 OID 0)
-- Dependencies: 2737
-- Name: ax_grenzpunkt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_grenzpunkt_ogc_fid_seq OWNED BY ax_grenzpunkt.ogc_fid;


--
-- TOC entry 2822 (class 1259 OID 5502194)
-- Dependencies: 3412 3413 3414 961 3
-- Name: ax_hafenbecken; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_hafenbecken (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    name character varying(50),
    nutzung integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_hafenbecken OWNER TO postgres;

--
-- TOC entry 4239 (class 0 OID 0)
-- Dependencies: 2822
-- Name: TABLE ax_hafenbecken; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_hafenbecken IS '"H a f e n b e c k e n"  ist ein natürlicher oder künstlich angelegter oder abgetrennter Teil eines Gewässers, in dem Schiffe be- und entladen werden.';


--
-- TOC entry 4240 (class 0 OID 0)
-- Dependencies: 2822
-- Name: COLUMN ax_hafenbecken.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_hafenbecken.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4241 (class 0 OID 0)
-- Dependencies: 2822
-- Name: COLUMN ax_hafenbecken.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_hafenbecken.funktion IS 'FKT "Funktion" ist die objektiv erkennbare Nutzung von "Hafenbecken".';


--
-- TOC entry 4242 (class 0 OID 0)
-- Dependencies: 2822
-- Name: COLUMN ax_hafenbecken.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_hafenbecken.name IS 'NAM "Name" ist der Eigenname von "Hafenbecken".';


--
-- TOC entry 4243 (class 0 OID 0)
-- Dependencies: 2822
-- Name: COLUMN ax_hafenbecken.nutzung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_hafenbecken.nutzung IS 'NTZ "Nutzung" gibt den Nutzerkreis von "Hafenbecken" an.';


--
-- TOC entry 2821 (class 1259 OID 5502192)
-- Dependencies: 2822 3
-- Name: ax_hafenbecken_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_hafenbecken_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_hafenbecken_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4244 (class 0 OID 0)
-- Dependencies: 2821
-- Name: ax_hafenbecken_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_hafenbecken_ogc_fid_seq OWNED BY ax_hafenbecken.ogc_fid;


--
-- TOC entry 2780 (class 1259 OID 5501837)
-- Dependencies: 3328 3329 3330 961 3
-- Name: ax_halde; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_halde (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    lagergut integer,
    name character varying(50),
    zustand integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_halde OWNER TO postgres;

--
-- TOC entry 4245 (class 0 OID 0)
-- Dependencies: 2780
-- Name: TABLE ax_halde; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_halde IS 'H a l d e';


--
-- TOC entry 4246 (class 0 OID 0)
-- Dependencies: 2780
-- Name: COLUMN ax_halde.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_halde.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4247 (class 0 OID 0)
-- Dependencies: 2780
-- Name: COLUMN ax_halde.lagergut; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_halde.lagergut IS 'LGT "Lagergut" gibt an, welches Produkt gelagert wird.';


--
-- TOC entry 4248 (class 0 OID 0)
-- Dependencies: 2780
-- Name: COLUMN ax_halde.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_halde.name IS 'NAM "Name" ist die einer "Halde" zugehörige Bezeichnung oder deren Eigenname.';


--
-- TOC entry 4249 (class 0 OID 0)
-- Dependencies: 2780
-- Name: COLUMN ax_halde.zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_halde.zustand IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Halde".';


--
-- TOC entry 2779 (class 1259 OID 5501835)
-- Dependencies: 2780 3
-- Name: ax_halde_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_halde_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_halde_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4250 (class 0 OID 0)
-- Dependencies: 2779
-- Name: ax_halde_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_halde_ogc_fid_seq OWNED BY ax_halde.ogc_fid;


--
-- TOC entry 2812 (class 1259 OID 5502109)
-- Dependencies: 3392 3393 3394 961 3
-- Name: ax_heide; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_heide (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    name character varying(50),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_heide OWNER TO postgres;

--
-- TOC entry 4251 (class 0 OID 0)
-- Dependencies: 2812
-- Name: TABLE ax_heide; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_heide IS '"H e i d e"  ist eine meist sandige Fläche mit typischen Sträuchern, Gräsern und geringwertigem Baumbestand.';


--
-- TOC entry 4252 (class 0 OID 0)
-- Dependencies: 2812
-- Name: COLUMN ax_heide.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_heide.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4253 (class 0 OID 0)
-- Dependencies: 2812
-- Name: COLUMN ax_heide.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_heide.name IS 'NAM "Name" ist der Eigenname von "Heide".';


--
-- TOC entry 2811 (class 1259 OID 5502107)
-- Dependencies: 3 2812
-- Name: ax_heide_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_heide_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_heide_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4254 (class 0 OID 0)
-- Dependencies: 2811
-- Name: ax_heide_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_heide_ogc_fid_seq OWNED BY ax_heide.ogc_fid;


--
-- TOC entry 2842 (class 1259 OID 5502364)
-- Dependencies: 3449 3450 3451 3 961
-- Name: ax_heilquellegasquelle; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_heilquellegasquelle (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    sonstigesmodell character(5),
    anlass integer,
    art integer,
    name character(13),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_heilquellegasquelle OWNER TO postgres;

--
-- TOC entry 4255 (class 0 OID 0)
-- Dependencies: 2842
-- Name: TABLE ax_heilquellegasquelle; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_heilquellegasquelle IS 'H e i l q u e l l e  /  G a s q u e l l e';


--
-- TOC entry 4256 (class 0 OID 0)
-- Dependencies: 2842
-- Name: COLUMN ax_heilquellegasquelle.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_heilquellegasquelle.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2841 (class 1259 OID 5502362)
-- Dependencies: 3 2842
-- Name: ax_heilquellegasquelle_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_heilquellegasquelle_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_heilquellegasquelle_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4257 (class 0 OID 0)
-- Dependencies: 2841
-- Name: ax_heilquellegasquelle_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_heilquellegasquelle_ogc_fid_seq OWNED BY ax_heilquellegasquelle.ogc_fid;


--
-- TOC entry 2840 (class 1259 OID 5502347)
-- Dependencies: 3446 3447 961 3
-- Name: ax_historischesbauwerkoderhistorischeeinrichtung; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_historischesbauwerkoderhistorischeeinrichtung (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    sonstigesmodell character varying[],
    anlass integer,
    archaeologischertyp integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_historischesbauwerkoderhistorischeeinrichtung OWNER TO postgres;

--
-- TOC entry 4258 (class 0 OID 0)
-- Dependencies: 2840
-- Name: TABLE ax_historischesbauwerkoderhistorischeeinrichtung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_historischesbauwerkoderhistorischeeinrichtung IS 'Historisches Bauwerk oder historische Einrichtung';


--
-- TOC entry 4259 (class 0 OID 0)
-- Dependencies: 2840
-- Name: COLUMN ax_historischesbauwerkoderhistorischeeinrichtung.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_historischesbauwerkoderhistorischeeinrichtung.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2839 (class 1259 OID 5502345)
-- Dependencies: 2840 3
-- Name: ax_historischesbauwerkoderhistorischeeinrichtung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_historischesbauwerkoderhistorischeeinrichtung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_historischesbauwerkoderhistorischeeinrichtung_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4260 (class 0 OID 0)
-- Dependencies: 2839
-- Name: ax_historischesbauwerkoderhistorischeeinrichtung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_historischesbauwerkoderhistorischeeinrichtung_ogc_fid_seq OWNED BY ax_historischesbauwerkoderhistorischeeinrichtung.ogc_fid;


--
-- TOC entry 2714 (class 1259 OID 5501353)
-- Dependencies: 3245 3246 3 961
-- Name: ax_historischesflurstueck; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_historischesflurstueck (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(8),
    anlass integer,
    art character varying(40),
    name character varying(13),
    land integer,
    gemarkungsnummer integer,
    flurnummer integer,
    zaehler integer,
    flurstueckskennzeichen character(20),
    amtlicheflaeche double precision,
    abweichenderrechtszustand character(5),
    rechtsbehelfsverfahren character(5),
    zeitpunktderentstehung character(10),
    "gemeindezugehoerigkeit|ax_gemeindekennzeichen|land" integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    vorgaengerflurstueckskennzeichen character varying[],
    nachfolgerflurstueckskennzeichen character varying[],
    blattart integer,
    buchungsart integer,
    buchungsblattkennzeichen double precision,
    "buchung|ax_buchung_historischesflurstueck|buchungsblattbezirk|a" integer,
    bezirk integer,
    buchungsblattnummermitbuchstabenerweiterung character(7),
    laufendenummerderbuchungsstelle integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_historischesflurstueck OWNER TO postgres;

--
-- TOC entry 4261 (class 0 OID 0)
-- Dependencies: 2714
-- Name: TABLE ax_historischesflurstueck; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_historischesflurstueck IS 'Historisches Flurstück, ALKIS, MIT Geometrie';


--
-- TOC entry 4262 (class 0 OID 0)
-- Dependencies: 2714
-- Name: COLUMN ax_historischesflurstueck.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_historischesflurstueck.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2713 (class 1259 OID 5501351)
-- Dependencies: 3 2714
-- Name: ax_historischesflurstueck_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_historischesflurstueck_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_historischesflurstueck_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4263 (class 0 OID 0)
-- Dependencies: 2713
-- Name: ax_historischesflurstueck_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_historischesflurstueck_ogc_fid_seq OWNED BY ax_historischesflurstueck.ogc_fid;


--
-- TOC entry 2712 (class 1259 OID 5501340)
-- Dependencies: 3
-- Name: ax_historischesflurstueckalb; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_historischesflurstueckalb (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(8),
    anlass integer,
    art character varying(40),
    name character varying(13),
    land integer,
    gemarkungsnummer integer,
    flurnummer integer,
    zaehler integer,
    nenner integer,
    flurstueckskennzeichen character(20),
    amtlicheflaeche double precision,
    blattart integer,
    buchungsart character varying(11),
    buchungsblattkennzeichen integer,
    "buchung|ax_buchung_historischesflurstueck|buchungsblattbezirk|a" integer,
    bezirk integer,
    buchungsblattnummermitbuchstabenerweiterung character(7),
    laufendenummerderbuchungsstelle integer,
    zeitpunktderentstehungdesbezugsflurstuecks character varying(10),
    vorgaengerflurstueckskennzeichen character varying[],
    nachfolgerflurstueckskennzeichen character varying[]
);


ALTER TABLE public.ax_historischesflurstueckalb OWNER TO postgres;

--
-- TOC entry 4264 (class 0 OID 0)
-- Dependencies: 2712
-- Name: TABLE ax_historischesflurstueckalb; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_historischesflurstueckalb IS 'Historisches Flurstück ALB';


--
-- TOC entry 4265 (class 0 OID 0)
-- Dependencies: 2712
-- Name: COLUMN ax_historischesflurstueckalb.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_historischesflurstueckalb.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2711 (class 1259 OID 5501338)
-- Dependencies: 3 2712
-- Name: ax_historischesflurstueckalb_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_historischesflurstueckalb_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_historischesflurstueckalb_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4266 (class 0 OID 0)
-- Dependencies: 2711
-- Name: ax_historischesflurstueckalb_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_historischesflurstueckalb_ogc_fid_seq OWNED BY ax_historischesflurstueckalb.ogc_fid;


--
-- TOC entry 2778 (class 1259 OID 5501820)
-- Dependencies: 3325 3326 961 3
-- Name: ax_industrieundgewerbeflaeche; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_industrieundgewerbeflaeche (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    name character varying(50),
    zustand integer,
    foerdergut integer,
    primaerenergie integer,
    lagergut integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_industrieundgewerbeflaeche OWNER TO postgres;

--
-- TOC entry 4267 (class 0 OID 0)
-- Dependencies: 2778
-- Name: TABLE ax_industrieundgewerbeflaeche; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_industrieundgewerbeflaeche IS 'I n d u s t r i e -   u n d   G e w e r b e f l a e c h e';


--
-- TOC entry 4268 (class 0 OID 0)
-- Dependencies: 2778
-- Name: COLUMN ax_industrieundgewerbeflaeche.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_industrieundgewerbeflaeche.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4269 (class 0 OID 0)
-- Dependencies: 2778
-- Name: COLUMN ax_industrieundgewerbeflaeche.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_industrieundgewerbeflaeche.funktion IS 'FKT "Funktion" ist die zum Zeitpunkt der Erhebung vorherrschende Nutzung von "Industrie- und Gewerbefläche".';


--
-- TOC entry 4270 (class 0 OID 0)
-- Dependencies: 2778
-- Name: COLUMN ax_industrieundgewerbeflaeche.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_industrieundgewerbeflaeche.name IS 'NAM "Name" ist der Eigenname von "Industrie- und Gewerbefläche" insbesondere außerhalb von Ortslagen.';


--
-- TOC entry 4271 (class 0 OID 0)
-- Dependencies: 2778
-- Name: COLUMN ax_industrieundgewerbeflaeche.zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_industrieundgewerbeflaeche.zustand IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Industrie- und Gewerbefläche".';


--
-- TOC entry 4272 (class 0 OID 0)
-- Dependencies: 2778
-- Name: COLUMN ax_industrieundgewerbeflaeche.foerdergut; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_industrieundgewerbeflaeche.foerdergut IS 'FGT "Fördergut" gibt an, welches Produkt gefördert wird.';


--
-- TOC entry 4273 (class 0 OID 0)
-- Dependencies: 2778
-- Name: COLUMN ax_industrieundgewerbeflaeche.primaerenergie; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_industrieundgewerbeflaeche.primaerenergie IS 'PEG "Primärenergie" beschreibt die zur Strom- oder Wärmeerzeugung dienende Energieform oder den Energieträger.';


--
-- TOC entry 4274 (class 0 OID 0)
-- Dependencies: 2778
-- Name: COLUMN ax_industrieundgewerbeflaeche.lagergut; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_industrieundgewerbeflaeche.lagergut IS 'LGT "Lagergut" gibt an, welches Produkt gelagert wird. Diese Attributart kann nur in Verbindung mit der Attributart "Funktion" und der Werteart 1740 vorkommen.';


--
-- TOC entry 2777 (class 1259 OID 5501818)
-- Dependencies: 3 2778
-- Name: ax_industrieundgewerbeflaeche_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_industrieundgewerbeflaeche_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_industrieundgewerbeflaeche_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4275 (class 0 OID 0)
-- Dependencies: 2777
-- Name: ax_industrieundgewerbeflaeche_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_industrieundgewerbeflaeche_ogc_fid_seq OWNED BY ax_industrieundgewerbeflaeche.ogc_fid;


--
-- TOC entry 2882 (class 1259 OID 5502693)
-- Dependencies: 3514 3515 3516 961 3
-- Name: ax_klassifizierungnachstrassenrecht; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_klassifizierungnachstrassenrecht (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    qadvstandardmodell character varying(9),
    anlass integer,
    artderfestlegung integer,
    bezeichnung character varying(20),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_klassifizierungnachstrassenrecht OWNER TO postgres;

--
-- TOC entry 4276 (class 0 OID 0)
-- Dependencies: 2882
-- Name: TABLE ax_klassifizierungnachstrassenrecht; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_klassifizierungnachstrassenrecht IS 'K l a s s i f i z i e r u n g   n a c h   S t r a s s e n r e c h t';


--
-- TOC entry 4277 (class 0 OID 0)
-- Dependencies: 2882
-- Name: COLUMN ax_klassifizierungnachstrassenrecht.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_klassifizierungnachstrassenrecht.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2881 (class 1259 OID 5502691)
-- Dependencies: 2882 3
-- Name: ax_klassifizierungnachstrassenrecht_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_klassifizierungnachstrassenrecht_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_klassifizierungnachstrassenrecht_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4278 (class 0 OID 0)
-- Dependencies: 2881
-- Name: ax_klassifizierungnachstrassenrecht_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_klassifizierungnachstrassenrecht_ogc_fid_seq OWNED BY ax_klassifizierungnachstrassenrecht.ogc_fid;


--
-- TOC entry 2884 (class 1259 OID 5502710)
-- Dependencies: 3518 3519 3520 961 3
-- Name: ax_klassifizierungnachwasserrecht; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_klassifizierungnachwasserrecht (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    artderfestlegung integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_klassifizierungnachwasserrecht OWNER TO postgres;

--
-- TOC entry 4279 (class 0 OID 0)
-- Dependencies: 2884
-- Name: TABLE ax_klassifizierungnachwasserrecht; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_klassifizierungnachwasserrecht IS 'K l a s s i f i z i e r u n g   n a c h   W a s s e r r e c h t';


--
-- TOC entry 4280 (class 0 OID 0)
-- Dependencies: 2884
-- Name: COLUMN ax_klassifizierungnachwasserrecht.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_klassifizierungnachwasserrecht.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2883 (class 1259 OID 5502708)
-- Dependencies: 3 2884
-- Name: ax_klassifizierungnachwasserrecht_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_klassifizierungnachwasserrecht_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_klassifizierungnachwasserrecht_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4281 (class 0 OID 0)
-- Dependencies: 2883
-- Name: ax_klassifizierungnachwasserrecht_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_klassifizierungnachwasserrecht_ogc_fid_seq OWNED BY ax_klassifizierungnachwasserrecht.ogc_fid;


--
-- TOC entry 2912 (class 1259 OID 5502889)
-- Dependencies: 3543 3544 3545 3 961
-- Name: ax_kleinraeumigerlandschaftsteil; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_kleinraeumigerlandschaftsteil (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character varying(9),
    sonstigesmodell character varying[],
    anlass integer,
    landschaftstyp integer,
    name character varying(20),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_kleinraeumigerlandschaftsteil OWNER TO postgres;

--
-- TOC entry 4282 (class 0 OID 0)
-- Dependencies: 2912
-- Name: TABLE ax_kleinraeumigerlandschaftsteil; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_kleinraeumigerlandschaftsteil IS 'k l e i n r a e u m i g e r   L a n d s c h a f t s t e i l';


--
-- TOC entry 4283 (class 0 OID 0)
-- Dependencies: 2912
-- Name: COLUMN ax_kleinraeumigerlandschaftsteil.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_kleinraeumigerlandschaftsteil.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2911 (class 1259 OID 5502887)
-- Dependencies: 3 2912
-- Name: ax_kleinraeumigerlandschaftsteil_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_kleinraeumigerlandschaftsteil_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_kleinraeumigerlandschaftsteil_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4284 (class 0 OID 0)
-- Dependencies: 2911
-- Name: ax_kleinraeumigerlandschaftsteil_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_kleinraeumigerlandschaftsteil_ogc_fid_seq OWNED BY ax_kleinraeumigerlandschaftsteil.ogc_fid;


--
-- TOC entry 2916 (class 1259 OID 5502923)
-- Dependencies: 3551 3552 961 3
-- Name: ax_kommunalesgebiet; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_kommunalesgebiet (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    schluesselgesamt integer,
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_kommunalesgebiet OWNER TO postgres;

--
-- TOC entry 4285 (class 0 OID 0)
-- Dependencies: 2916
-- Name: TABLE ax_kommunalesgebiet; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_kommunalesgebiet IS 'K o m m u n a l e s   G e b i e t';


--
-- TOC entry 4286 (class 0 OID 0)
-- Dependencies: 2916
-- Name: COLUMN ax_kommunalesgebiet.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_kommunalesgebiet.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2915 (class 1259 OID 5502921)
-- Dependencies: 2916 3
-- Name: ax_kommunalesgebiet_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_kommunalesgebiet_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_kommunalesgebiet_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4287 (class 0 OID 0)
-- Dependencies: 2915
-- Name: ax_kommunalesgebiet_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_kommunalesgebiet_ogc_fid_seq OWNED BY ax_kommunalesgebiet.ogc_fid;


--
-- TOC entry 2898 (class 1259 OID 5502814)
-- Dependencies: 3
-- Name: ax_kreisregion; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_kreisregion (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    schluesselgesamt integer,
    bezeichnung character varying(20),
    land integer,
    regierungsbezirk integer,
    kreis integer
);


ALTER TABLE public.ax_kreisregion OWNER TO postgres;

--
-- TOC entry 4288 (class 0 OID 0)
-- Dependencies: 2898
-- Name: TABLE ax_kreisregion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_kreisregion IS 'K r e i s  /  R e g i o n';


--
-- TOC entry 4289 (class 0 OID 0)
-- Dependencies: 2898
-- Name: COLUMN ax_kreisregion.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_kreisregion.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2897 (class 1259 OID 5502812)
-- Dependencies: 2898 3
-- Name: ax_kreisregion_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_kreisregion_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_kreisregion_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4290 (class 0 OID 0)
-- Dependencies: 2897
-- Name: ax_kreisregion_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_kreisregion_ogc_fid_seq OWNED BY ax_kreisregion.ogc_fid;


--
-- TOC entry 2910 (class 1259 OID 5502876)
-- Dependencies: 3
-- Name: ax_lagebezeichnungkatalogeintrag; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_lagebezeichnungkatalogeintrag (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    schluesselgesamt character varying(13),
    bezeichnung character varying(28),
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    lage character varying(5)
);


ALTER TABLE public.ax_lagebezeichnungkatalogeintrag OWNER TO postgres;

--
-- TOC entry 4291 (class 0 OID 0)
-- Dependencies: 2910
-- Name: TABLE ax_lagebezeichnungkatalogeintrag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_lagebezeichnungkatalogeintrag IS 'Straßentabelle';


--
-- TOC entry 4292 (class 0 OID 0)
-- Dependencies: 2910
-- Name: COLUMN ax_lagebezeichnungkatalogeintrag.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_lagebezeichnungkatalogeintrag.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4293 (class 0 OID 0)
-- Dependencies: 2910
-- Name: COLUMN ax_lagebezeichnungkatalogeintrag.bezeichnung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_lagebezeichnungkatalogeintrag.bezeichnung IS 'Straßenname';


--
-- TOC entry 4294 (class 0 OID 0)
-- Dependencies: 2910
-- Name: COLUMN ax_lagebezeichnungkatalogeintrag.lage; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_lagebezeichnungkatalogeintrag.lage IS 'Straßenschlüssel';


--
-- TOC entry 2909 (class 1259 OID 5502874)
-- Dependencies: 3 2910
-- Name: ax_lagebezeichnungkatalogeintrag_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_lagebezeichnungkatalogeintrag_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_lagebezeichnungkatalogeintrag_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4295 (class 0 OID 0)
-- Dependencies: 2909
-- Name: ax_lagebezeichnungkatalogeintrag_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_lagebezeichnungkatalogeintrag_ogc_fid_seq OWNED BY ax_lagebezeichnungkatalogeintrag.ogc_fid;


--
-- TOC entry 2742 (class 1259 OID 5501568)
-- Dependencies: 3
-- Name: ax_lagebezeichnungmithausnummer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_lagebezeichnungmithausnummer (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    lage character varying(5),
    hausnummer character varying(6)
);


ALTER TABLE public.ax_lagebezeichnungmithausnummer OWNER TO postgres;

--
-- TOC entry 4296 (class 0 OID 0)
-- Dependencies: 2742
-- Name: TABLE ax_lagebezeichnungmithausnummer; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_lagebezeichnungmithausnummer IS 'L a g e b e z e i c h n u n g   m i t   H a u s n u m m e r';


--
-- TOC entry 4297 (class 0 OID 0)
-- Dependencies: 2742
-- Name: COLUMN ax_lagebezeichnungmithausnummer.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_lagebezeichnungmithausnummer.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2741 (class 1259 OID 5501566)
-- Dependencies: 3 2742
-- Name: ax_lagebezeichnungmithausnummer_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_lagebezeichnungmithausnummer_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_lagebezeichnungmithausnummer_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4298 (class 0 OID 0)
-- Dependencies: 2741
-- Name: ax_lagebezeichnungmithausnummer_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_lagebezeichnungmithausnummer_ogc_fid_seq OWNED BY ax_lagebezeichnungmithausnummer.ogc_fid;


--
-- TOC entry 2744 (class 1259 OID 5501579)
-- Dependencies: 3
-- Name: ax_lagebezeichnungmitpseudonummer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_lagebezeichnungmitpseudonummer (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    lage character varying(5),
    pseudonummer character varying(5),
    laufendenummer character varying(2)
);


ALTER TABLE public.ax_lagebezeichnungmitpseudonummer OWNER TO postgres;

--
-- TOC entry 4299 (class 0 OID 0)
-- Dependencies: 2744
-- Name: TABLE ax_lagebezeichnungmitpseudonummer; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_lagebezeichnungmitpseudonummer IS 'L a g e b e z e i c h n u n g   m i t  P s e u d o n u m m e r';


--
-- TOC entry 4300 (class 0 OID 0)
-- Dependencies: 2744
-- Name: COLUMN ax_lagebezeichnungmitpseudonummer.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_lagebezeichnungmitpseudonummer.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2743 (class 1259 OID 5501577)
-- Dependencies: 2744 3
-- Name: ax_lagebezeichnungmitpseudonummer_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_lagebezeichnungmitpseudonummer_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_lagebezeichnungmitpseudonummer_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4301 (class 0 OID 0)
-- Dependencies: 2743
-- Name: ax_lagebezeichnungmitpseudonummer_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_lagebezeichnungmitpseudonummer_ogc_fid_seq OWNED BY ax_lagebezeichnungmitpseudonummer.ogc_fid;


--
-- TOC entry 2740 (class 1259 OID 5501557)
-- Dependencies: 3
-- Name: ax_lagebezeichnungohnehausnummer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_lagebezeichnungohnehausnummer (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    unverschluesselt character varying(61),
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    lage character varying(5)
);


ALTER TABLE public.ax_lagebezeichnungohnehausnummer OWNER TO postgres;

--
-- TOC entry 4302 (class 0 OID 0)
-- Dependencies: 2740
-- Name: TABLE ax_lagebezeichnungohnehausnummer; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_lagebezeichnungohnehausnummer IS 'L a g e b e z e i c h n u n g   o h n e   H a u s n u m m e r';


--
-- TOC entry 4303 (class 0 OID 0)
-- Dependencies: 2740
-- Name: COLUMN ax_lagebezeichnungohnehausnummer.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_lagebezeichnungohnehausnummer.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2739 (class 1259 OID 5501555)
-- Dependencies: 2740 3
-- Name: ax_lagebezeichnungohnehausnummer_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_lagebezeichnungohnehausnummer_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_lagebezeichnungohnehausnummer_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4304 (class 0 OID 0)
-- Dependencies: 2739
-- Name: ax_lagebezeichnungohnehausnummer_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_lagebezeichnungohnehausnummer_ogc_fid_seq OWNED BY ax_lagebezeichnungohnehausnummer.ogc_fid;


--
-- TOC entry 2806 (class 1259 OID 5502058)
-- Dependencies: 3380 3381 3382 3 961
-- Name: ax_landwirtschaft; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_landwirtschaft (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    vegetationsmerkmal integer,
    name character varying(50),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_landwirtschaft OWNER TO postgres;

--
-- TOC entry 4305 (class 0 OID 0)
-- Dependencies: 2806
-- Name: TABLE ax_landwirtschaft; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_landwirtschaft IS '"L a n d w i r t s c h a f t"  ist eine Fläche für den Anbau von Feldfrüchten sowie eine Fläche, die beweidet und gemäht werden kann, einschließlich der mit besonderen Pflanzen angebauten Fläche. Die Brache, die für einen bestimmten Zeitraum (z. B. ein halbes oder ganzes Jahr) landwirtschaftlich unbebaut bleibt, ist als "Landwirtschaft" bzw. "Ackerland" zu erfassen';


--
-- TOC entry 4306 (class 0 OID 0)
-- Dependencies: 2806
-- Name: COLUMN ax_landwirtschaft.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_landwirtschaft.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4307 (class 0 OID 0)
-- Dependencies: 2806
-- Name: COLUMN ax_landwirtschaft.vegetationsmerkmal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_landwirtschaft.vegetationsmerkmal IS 'VEG "Vegetationsmerkmal" ist die zum Zeitpunkt der Erhebung erkennbare oder feststellbare vorherrschend vorkommende landwirtschaftliche Nutzung (Dominanzprinzip).';


--
-- TOC entry 4308 (class 0 OID 0)
-- Dependencies: 2806
-- Name: COLUMN ax_landwirtschaft.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_landwirtschaft.name IS 'NAM "Name" ist die Bezeichnung oder der Eigenname von "Landwirtschaft".';


--
-- TOC entry 2805 (class 1259 OID 5502056)
-- Dependencies: 3 2806
-- Name: ax_landwirtschaft_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_landwirtschaft_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_landwirtschaft_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4309 (class 0 OID 0)
-- Dependencies: 2805
-- Name: ax_landwirtschaft_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_landwirtschaft_ogc_fid_seq OWNED BY ax_landwirtschaft.ogc_fid;


--
-- TOC entry 2836 (class 1259 OID 5502313)
-- Dependencies: 3439 3440 3441 3 961
-- Name: ax_leitung; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_leitung (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    bauwerksfunktion integer,
    spannungsebene integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_leitung OWNER TO postgres;

--
-- TOC entry 4310 (class 0 OID 0)
-- Dependencies: 2836
-- Name: TABLE ax_leitung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_leitung IS 'L e i t u n g';


--
-- TOC entry 4311 (class 0 OID 0)
-- Dependencies: 2836
-- Name: COLUMN ax_leitung.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_leitung.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2835 (class 1259 OID 5502311)
-- Dependencies: 2836 3
-- Name: ax_leitung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_leitung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_leitung_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4312 (class 0 OID 0)
-- Dependencies: 2835
-- Name: ax_leitung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_leitung_ogc_fid_seq OWNED BY ax_leitung.ogc_fid;


--
-- TOC entry 2826 (class 1259 OID 5502228)
-- Dependencies: 3420 3421 3422 961 3
-- Name: ax_meer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_meer (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    name character varying(50),
    bezeichnung character varying(50),
    tidemerkmal integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_meer OWNER TO postgres;

--
-- TOC entry 4313 (class 0 OID 0)
-- Dependencies: 2826
-- Name: TABLE ax_meer; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_meer IS '"M e e r" ist die das Festland umgebende Wasserfläche.';


--
-- TOC entry 4314 (class 0 OID 0)
-- Dependencies: 2826
-- Name: COLUMN ax_meer.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_meer.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4315 (class 0 OID 0)
-- Dependencies: 2826
-- Name: COLUMN ax_meer.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_meer.funktion IS 'FKT "Funktion" ist die Art von "Meer".';


--
-- TOC entry 4316 (class 0 OID 0)
-- Dependencies: 2826
-- Name: COLUMN ax_meer.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_meer.name IS 'NAM "Name" ist der Eigenname von "Meer".';


--
-- TOC entry 4317 (class 0 OID 0)
-- Dependencies: 2826
-- Name: COLUMN ax_meer.bezeichnung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_meer.bezeichnung IS 'BEZ "Bezeichnung" ist die von der zuständigen Fachbehörde vergebene Verschlüsselung.';


--
-- TOC entry 4318 (class 0 OID 0)
-- Dependencies: 2826
-- Name: COLUMN ax_meer.tidemerkmal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_meer.tidemerkmal IS 'TID "Tidemerkmal" gibt an, ob "Meer" von den periodischen Wasserstandsänderungen beeinflusst wird.';


--
-- TOC entry 2825 (class 1259 OID 5502226)
-- Dependencies: 2826 3
-- Name: ax_meer_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_meer_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_meer_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4319 (class 0 OID 0)
-- Dependencies: 2825
-- Name: ax_meer_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_meer_ogc_fid_seq OWNED BY ax_meer.ogc_fid;


--
-- TOC entry 2814 (class 1259 OID 5502126)
-- Dependencies: 3396 3397 3398 961 3
-- Name: ax_moor; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_moor (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    name character varying(50),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_moor OWNER TO postgres;

--
-- TOC entry 4320 (class 0 OID 0)
-- Dependencies: 2814
-- Name: TABLE ax_moor; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_moor IS '"M o o r"  ist eine unkultivierte Fläche, deren obere Schicht aus vertorften oder zersetzten Pflanzenresten besteht.';


--
-- TOC entry 4321 (class 0 OID 0)
-- Dependencies: 2814
-- Name: COLUMN ax_moor.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_moor.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4322 (class 0 OID 0)
-- Dependencies: 2814
-- Name: COLUMN ax_moor.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_moor.name IS 'NAM "Name" ist der Eigenname von "Moor".';


--
-- TOC entry 2813 (class 1259 OID 5502124)
-- Dependencies: 3 2814
-- Name: ax_moor_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_moor_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_moor_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4323 (class 0 OID 0)
-- Dependencies: 2813
-- Name: ax_moor_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_moor_ogc_fid_seq OWNED BY ax_moor.ogc_fid;


--
-- TOC entry 2892 (class 1259 OID 5502777)
-- Dependencies: 3531 3532 961 3
-- Name: ax_musterlandesmusterundvergleichsstueck; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_musterlandesmusterundvergleichsstueck (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(8),
    anlass integer,
    merkmal integer,
    nummer integer,
    kulturart integer,
    bodenart integer,
    zustandsstufeoderbodenstufe integer,
    entstehungsartoderklimastufewasserverhaeltnisse integer,
    bodenzahlodergruenlandgrundzahl integer,
    ackerzahlodergruenlandzahl integer,
    art character varying(40),
    name character varying(27),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_musterlandesmusterundvergleichsstueck OWNER TO postgres;

--
-- TOC entry 4324 (class 0 OID 0)
-- Dependencies: 2892
-- Name: TABLE ax_musterlandesmusterundvergleichsstueck; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_musterlandesmusterundvergleichsstueck IS 'Muster-, Landesmuster- und Vergleichsstueck';


--
-- TOC entry 4325 (class 0 OID 0)
-- Dependencies: 2892
-- Name: COLUMN ax_musterlandesmusterundvergleichsstueck.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_musterlandesmusterundvergleichsstueck.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2891 (class 1259 OID 5502775)
-- Dependencies: 3 2892
-- Name: ax_musterlandesmusterundvergleichsstueck_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_musterlandesmusterundvergleichsstueck_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_musterlandesmusterundvergleichsstueck_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4326 (class 0 OID 0)
-- Dependencies: 2891
-- Name: ax_musterlandesmusterundvergleichsstueck_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_musterlandesmusterundvergleichsstueck_ogc_fid_seq OWNED BY ax_musterlandesmusterundvergleichsstueck.ogc_fid;


--
-- TOC entry 2760 (class 1259 OID 5501686)
-- Dependencies: 3
-- Name: ax_namensnummer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_namensnummer (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(8),
    anlass integer,
    laufendenummernachdin1421 character(16),
    zaehler double precision,
    nenner double precision,
    eigentuemerart integer,
    nummer character(6),
    artderrechtsgemeinschaft integer,
    beschriebderrechtsgemeinschaft character varying(1000)
);


ALTER TABLE public.ax_namensnummer OWNER TO postgres;

--
-- TOC entry 4327 (class 0 OID 0)
-- Dependencies: 2760
-- Name: TABLE ax_namensnummer; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_namensnummer IS 'NREO "Namensnummer" ist die laufende Nummer der Eintragung, unter welcher der Eigentümer oder Erbbauberechtigte im Buchungsblatt geführt wird. Rechtsgemeinschaften werden auch unter AX_Namensnummer geführt.';


--
-- TOC entry 4328 (class 0 OID 0)
-- Dependencies: 2760
-- Name: COLUMN ax_namensnummer.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_namensnummer.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2759 (class 1259 OID 5501684)
-- Dependencies: 2760 3
-- Name: ax_namensnummer_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_namensnummer_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_namensnummer_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4329 (class 0 OID 0)
-- Dependencies: 2759
-- Name: ax_namensnummer_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_namensnummer_ogc_fid_seq OWNED BY ax_namensnummer.ogc_fid;


--
-- TOC entry 2716 (class 1259 OID 5501370)
-- Dependencies: 3248 3249 3 961
-- Name: ax_naturumweltoderbodenschutzrecht; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_naturumweltoderbodenschutzrecht (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    artderfestlegung integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_naturumweltoderbodenschutzrecht OWNER TO postgres;

--
-- TOC entry 4330 (class 0 OID 0)
-- Dependencies: 2716
-- Name: TABLE ax_naturumweltoderbodenschutzrecht; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_naturumweltoderbodenschutzrecht IS 'N  a t u r -,  U m w e l t -   o d e r   B o d e n s c h u t z r e c h t';


--
-- TOC entry 4331 (class 0 OID 0)
-- Dependencies: 2716
-- Name: COLUMN ax_naturumweltoderbodenschutzrecht.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_naturumweltoderbodenschutzrecht.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2715 (class 1259 OID 5501368)
-- Dependencies: 2716 3
-- Name: ax_naturumweltoderbodenschutzrecht_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_naturumweltoderbodenschutzrecht_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_naturumweltoderbodenschutzrecht_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4332 (class 0 OID 0)
-- Dependencies: 2715
-- Name: ax_naturumweltoderbodenschutzrecht_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_naturumweltoderbodenschutzrecht_ogc_fid_seq OWNED BY ax_naturumweltoderbodenschutzrecht.ogc_fid;


--
-- TOC entry 2756 (class 1259 OID 5501666)
-- Dependencies: 3
-- Name: ax_person; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_person (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    nachnameoderfirma character varying(100),
    anrede integer,
    vorname character varying(40),
    geburtsname character varying(50),
    geburtsdatum character varying(10),
    namensbestandteil character varying(20),
    akademischergrad character varying(16),
    art character varying(40),
    uri character varying(28)
);


ALTER TABLE public.ax_person OWNER TO postgres;

--
-- TOC entry 4333 (class 0 OID 0)
-- Dependencies: 2756
-- Name: TABLE ax_person; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_person IS 'NREO "Person" ist eine natürliche oder juristische Person und kann z.B. in den Rollen Eigentümer, Erwerber, Verwalter oder Vertreter in Katasterangelegenheiten geführt werden.';


--
-- TOC entry 4334 (class 0 OID 0)
-- Dependencies: 2756
-- Name: COLUMN ax_person.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_person.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4335 (class 0 OID 0)
-- Dependencies: 2756
-- Name: COLUMN ax_person.namensbestandteil; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_person.namensbestandteil IS 'enthält z.B. Titel wie "Baron"';


--
-- TOC entry 2755 (class 1259 OID 5501664)
-- Dependencies: 3 2756
-- Name: ax_person_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_person_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_person_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4336 (class 0 OID 0)
-- Dependencies: 2755
-- Name: ax_person_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_person_ogc_fid_seq OWNED BY ax_person.ogc_fid;


--
-- TOC entry 2798 (class 1259 OID 5501990)
-- Dependencies: 3364 3365 3366 961 3
-- Name: ax_platz; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_platz (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    name character varying(50),
    zweitname character varying(50),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_platz OWNER TO postgres;

--
-- TOC entry 4337 (class 0 OID 0)
-- Dependencies: 2798
-- Name: TABLE ax_platz; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_platz IS 'P l a t z   ist eine Verkehrsfläche in Ortschaften oder eine ebene, befestigte oder unbefestigte Fläche, die bestimmten Zwecken dient (z. B. für Verkehr, Märkte, Festveranstaltungen).';


--
-- TOC entry 4338 (class 0 OID 0)
-- Dependencies: 2798
-- Name: COLUMN ax_platz.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_platz.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4339 (class 0 OID 0)
-- Dependencies: 2798
-- Name: COLUMN ax_platz.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_platz.funktion IS 'FKT "Funktion" ist die zum Zeitpunkt der Erhebung objektiv erkennbare oder feststellbare vorkommende Nutzung.';


--
-- TOC entry 4340 (class 0 OID 0)
-- Dependencies: 2798
-- Name: COLUMN ax_platz.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_platz.name IS 'NAM "Name" ist der Eigenname von "Platz".';


--
-- TOC entry 4341 (class 0 OID 0)
-- Dependencies: 2798
-- Name: COLUMN ax_platz.zweitname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_platz.zweitname IS 'ZNM "Zweitname" ist der touristische oder volkstümliche Name von "Platz".';


--
-- TOC entry 2797 (class 1259 OID 5501988)
-- Dependencies: 2798 3
-- Name: ax_platz_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_platz_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_platz_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4342 (class 0 OID 0)
-- Dependencies: 2797
-- Name: ax_platz_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_platz_ogc_fid_seq OWNED BY ax_platz.ogc_fid;


--
-- TOC entry 2688 (class 1259 OID 5501167)
-- Dependencies: 3
-- Name: ax_punktkennunguntergegangen; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_punktkennunguntergegangen (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    punktkennung double precision,
    art integer
);


ALTER TABLE public.ax_punktkennunguntergegangen OWNER TO postgres;

--
-- TOC entry 2687 (class 1259 OID 5501165)
-- Dependencies: 3 2688
-- Name: ax_punktkennunguntergegangen_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_punktkennunguntergegangen_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_punktkennunguntergegangen_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4343 (class 0 OID 0)
-- Dependencies: 2687
-- Name: ax_punktkennunguntergegangen_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_punktkennunguntergegangen_ogc_fid_seq OWNED BY ax_punktkennunguntergegangen.ogc_fid;


--
-- TOC entry 2750 (class 1259 OID 5501615)
-- Dependencies: 3288 3289 3290 3 961
-- Name: ax_punktortag; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_punktortag (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    art character varying[],
    name character varying[],
    kartendarstellung integer,
    "qualitaetsangaben|ax_dqpunktort|herkunft|li_lineage|processstep" integer,
    genauigkeitsstufe integer,
    vertrauenswuerdigkeit integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_punktortag OWNER TO postgres;

--
-- TOC entry 4344 (class 0 OID 0)
-- Dependencies: 2750
-- Name: TABLE ax_punktortag; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_punktortag IS 'P u n k t o r t   AG';


--
-- TOC entry 4345 (class 0 OID 0)
-- Dependencies: 2750
-- Name: COLUMN ax_punktortag.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_punktortag.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2749 (class 1259 OID 5501613)
-- Dependencies: 2750 3
-- Name: ax_punktortag_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_punktortag_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_punktortag_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4346 (class 0 OID 0)
-- Dependencies: 2749
-- Name: ax_punktortag_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_punktortag_ogc_fid_seq OWNED BY ax_punktortag.ogc_fid;


--
-- TOC entry 2752 (class 1259 OID 5501632)
-- Dependencies: 3292 3293 3294 961 3
-- Name: ax_punktortau; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_punktortau (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    kartendarstellung integer,
    art character varying(61),
    name character varying(26),
    "qualitaetsangaben|ax_dqpunktort|herkunft|li_lineage|processstep" integer,
    datetime character(20),
    individualname character(7),
    vertrauenswuerdigkeit integer,
    genauigkeitsstufe integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_punktortau OWNER TO postgres;

--
-- TOC entry 4347 (class 0 OID 0)
-- Dependencies: 2752
-- Name: TABLE ax_punktortau; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_punktortau IS 'P u n k t o r t   A U';


--
-- TOC entry 4348 (class 0 OID 0)
-- Dependencies: 2752
-- Name: COLUMN ax_punktortau.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_punktortau.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2751 (class 1259 OID 5501630)
-- Dependencies: 2752 3
-- Name: ax_punktortau_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_punktortau_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_punktortau_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4349 (class 0 OID 0)
-- Dependencies: 2751
-- Name: ax_punktortau_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_punktortau_ogc_fid_seq OWNED BY ax_punktortau.ogc_fid;


--
-- TOC entry 2754 (class 1259 OID 5501649)
-- Dependencies: 3296 3297 3298 961 3
-- Name: ax_punktortta; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_punktortta (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    kartendarstellung integer,
    description integer,
    art character varying[],
    name character varying[],
    "qualitaetsangaben|ax_dqpunktort|herkunft|li_lineage|source|li_s" integer,
    characterstring character varying(10),
    datetime character varying(20),
    genauigkeitsstufe integer,
    vertrauenswuerdigkeit integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_punktortta OWNER TO postgres;

--
-- TOC entry 4350 (class 0 OID 0)
-- Dependencies: 2754
-- Name: TABLE ax_punktortta; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_punktortta IS 'P u n k t o r t   T A';


--
-- TOC entry 4351 (class 0 OID 0)
-- Dependencies: 2754
-- Name: COLUMN ax_punktortta.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_punktortta.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2753 (class 1259 OID 5501647)
-- Dependencies: 3 2754
-- Name: ax_punktortta_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_punktortta_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_punktortta_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4352 (class 0 OID 0)
-- Dependencies: 2753
-- Name: ax_punktortta_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_punktortta_ogc_fid_seq OWNED BY ax_punktortta.ogc_fid;


--
-- TOC entry 2896 (class 1259 OID 5502804)
-- Dependencies: 3
-- Name: ax_regierungsbezirk; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_regierungsbezirk (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    schluesselgesamt integer,
    bezeichnung character varying(20),
    land integer,
    regierungsbezirk integer
);


ALTER TABLE public.ax_regierungsbezirk OWNER TO postgres;

--
-- TOC entry 4353 (class 0 OID 0)
-- Dependencies: 2896
-- Name: TABLE ax_regierungsbezirk; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_regierungsbezirk IS 'R e g i e r u n g s b e z i r k';


--
-- TOC entry 4354 (class 0 OID 0)
-- Dependencies: 2896
-- Name: COLUMN ax_regierungsbezirk.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_regierungsbezirk.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2895 (class 1259 OID 5502802)
-- Dependencies: 2896 3
-- Name: ax_regierungsbezirk_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_regierungsbezirk_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_regierungsbezirk_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4355 (class 0 OID 0)
-- Dependencies: 2895
-- Name: ax_regierungsbezirk_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_regierungsbezirk_ogc_fid_seq OWNED BY ax_regierungsbezirk.ogc_fid;


--
-- TOC entry 2690 (class 1259 OID 5501175)
-- Dependencies: 3
-- Name: ax_reservierung; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_reservierung (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    art integer,
    nummer character(20),
    land integer,
    stelle integer,
    ablaufderreservierung character(10),
    antragsnummer character(18),
    auftragsnummer character(18),
    "gebietskennung|ax_reservierungsauftrag_gebietskennung|gemarkung" integer,
    gemarkungsnummer integer,
    "gebietskennung|ax_reservierungsauftrag_gebietskennung|flur|ax_g" integer,
    gemarkung integer,
    gemarkungsteilflur integer,
    nummerierungsbezirk integer
);


ALTER TABLE public.ax_reservierung OWNER TO postgres;

--
-- TOC entry 2689 (class 1259 OID 5501173)
-- Dependencies: 3 2690
-- Name: ax_reservierung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_reservierung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_reservierung_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4356 (class 0 OID 0)
-- Dependencies: 2689
-- Name: ax_reservierung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_reservierung_ogc_fid_seq OWNED BY ax_reservierung.ogc_fid;


--
-- TOC entry 2804 (class 1259 OID 5502041)
-- Dependencies: 3376 3377 3378 3 961
-- Name: ax_schiffsverkehr; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_schiffsverkehr (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    name character varying(50),
    zustand integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_schiffsverkehr OWNER TO postgres;

--
-- TOC entry 4357 (class 0 OID 0)
-- Dependencies: 2804
-- Name: TABLE ax_schiffsverkehr; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_schiffsverkehr IS '"S c h i f f s v e r k e h r"  umfasst die baulich geprägte Fläche und die mit ihr in Zusammenhang stehende Freifläche, die ausschließlich oder vorwiegend dem Schiffsverkehr dient.';


--
-- TOC entry 4358 (class 0 OID 0)
-- Dependencies: 2804
-- Name: COLUMN ax_schiffsverkehr.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_schiffsverkehr.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4359 (class 0 OID 0)
-- Dependencies: 2804
-- Name: COLUMN ax_schiffsverkehr.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_schiffsverkehr.funktion IS 'FKT "Funktion" ist die zum Zeitpunkt der Erhebung vorherrschende Nutzung von "Schiffsverkehr".';


--
-- TOC entry 4360 (class 0 OID 0)
-- Dependencies: 2804
-- Name: COLUMN ax_schiffsverkehr.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_schiffsverkehr.name IS 'NAM "Name" ist der Eigenname von "Schiffsverkehr".';


--
-- TOC entry 4361 (class 0 OID 0)
-- Dependencies: 2804
-- Name: COLUMN ax_schiffsverkehr.zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_schiffsverkehr.zustand IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Schiffsverkehr".';


--
-- TOC entry 2803 (class 1259 OID 5502039)
-- Dependencies: 3 2804
-- Name: ax_schiffsverkehr_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_schiffsverkehr_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_schiffsverkehr_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4362 (class 0 OID 0)
-- Dependencies: 2803
-- Name: ax_schiffsverkehr_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_schiffsverkehr_ogc_fid_seq OWNED BY ax_schiffsverkehr.ogc_fid;


--
-- TOC entry 2718 (class 1259 OID 5501387)
-- Dependencies: 3
-- Name: ax_schutzgebietnachwasserrecht; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_schutzgebietnachwasserrecht (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    artderfestlegung integer,
    art character varying(40),
    name character varying(20),
    nummerdesschutzgebietes character varying(20)
);


ALTER TABLE public.ax_schutzgebietnachwasserrecht OWNER TO postgres;

--
-- TOC entry 4363 (class 0 OID 0)
-- Dependencies: 2718
-- Name: TABLE ax_schutzgebietnachwasserrecht; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_schutzgebietnachwasserrecht IS 'S c h u t z g e b i e t   n a c h   W a s s s e r r e c h t';


--
-- TOC entry 4364 (class 0 OID 0)
-- Dependencies: 2718
-- Name: COLUMN ax_schutzgebietnachwasserrecht.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_schutzgebietnachwasserrecht.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2717 (class 1259 OID 5501385)
-- Dependencies: 2718 3
-- Name: ax_schutzgebietnachwasserrecht_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_schutzgebietnachwasserrecht_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_schutzgebietnachwasserrecht_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4365 (class 0 OID 0)
-- Dependencies: 2717
-- Name: ax_schutzgebietnachwasserrecht_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_schutzgebietnachwasserrecht_ogc_fid_seq OWNED BY ax_schutzgebietnachwasserrecht.ogc_fid;


--
-- TOC entry 2720 (class 1259 OID 5501397)
-- Dependencies: 3252 3253 961 3
-- Name: ax_schutzzone; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_schutzzone (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    zone integer,
    art character varying(40),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_schutzzone OWNER TO postgres;

--
-- TOC entry 4366 (class 0 OID 0)
-- Dependencies: 2720
-- Name: TABLE ax_schutzzone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_schutzzone IS 'S c h u t z z o n e';


--
-- TOC entry 4367 (class 0 OID 0)
-- Dependencies: 2720
-- Name: COLUMN ax_schutzzone.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_schutzzone.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2719 (class 1259 OID 5501395)
-- Dependencies: 3 2720
-- Name: ax_schutzzone_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_schutzzone_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_schutzzone_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4368 (class 0 OID 0)
-- Dependencies: 2719
-- Name: ax_schutzzone_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_schutzzone_ogc_fid_seq OWNED BY ax_schutzzone.ogc_fid;


--
-- TOC entry 2748 (class 1259 OID 5501602)
-- Dependencies: 3
-- Name: ax_sonstigervermessungspunkt; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_sonstigervermessungspunkt (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    vermarkung_marke integer,
    punktkennung character varying(15),
    land integer,
    stelle integer,
    sonstigeeigenschaft character varying[]
);


ALTER TABLE public.ax_sonstigervermessungspunkt OWNER TO postgres;

--
-- TOC entry 4369 (class 0 OID 0)
-- Dependencies: 2748
-- Name: TABLE ax_sonstigervermessungspunkt; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_sonstigervermessungspunkt IS 's o n s t i g e r   V e r m e s s u n g s p u n k t';


--
-- TOC entry 4370 (class 0 OID 0)
-- Dependencies: 2748
-- Name: COLUMN ax_sonstigervermessungspunkt.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_sonstigervermessungspunkt.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2747 (class 1259 OID 5501600)
-- Dependencies: 2748 3
-- Name: ax_sonstigervermessungspunkt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_sonstigervermessungspunkt_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_sonstigervermessungspunkt_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4371 (class 0 OID 0)
-- Dependencies: 2747
-- Name: ax_sonstigervermessungspunkt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_sonstigervermessungspunkt_ogc_fid_seq OWNED BY ax_sonstigervermessungspunkt.ogc_fid;


--
-- TOC entry 2844 (class 1259 OID 5502381)
-- Dependencies: 3453 3454 3 961
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_sonstigesbauwerkodersonstigeeinrichtung (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    art character varying(40),
    name character varying(35),
    bauwerksfunktion integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_sonstigesbauwerkodersonstigeeinrichtung OWNER TO postgres;

--
-- TOC entry 4372 (class 0 OID 0)
-- Dependencies: 2844
-- Name: TABLE ax_sonstigesbauwerkodersonstigeeinrichtung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_sonstigesbauwerkodersonstigeeinrichtung IS 'sonstiges Bauwerk oder sonstige Einrichtung';


--
-- TOC entry 4373 (class 0 OID 0)
-- Dependencies: 2844
-- Name: COLUMN ax_sonstigesbauwerkodersonstigeeinrichtung.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_sonstigesbauwerkodersonstigeeinrichtung.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2843 (class 1259 OID 5502379)
-- Dependencies: 3 2844
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4374 (class 0 OID 0)
-- Dependencies: 2843
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq OWNED BY ax_sonstigesbauwerkodersonstigeeinrichtung.ogc_fid;


--
-- TOC entry 2888 (class 1259 OID 5502743)
-- Dependencies: 3525 3526 3 961
-- Name: ax_sonstigesrecht; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_sonstigesrecht (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    artderfestlegung integer,
    land integer,
    stelle character varying(5),
    bezeichnung character varying(20),
    characterstring integer,
    art character varying(40),
    name character varying(20),
    "qualitaetsangaben|ax_dqmitdatenerhebung|herkunft|li_lineage|pro" character varying(8),
    datetime character(20),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_sonstigesrecht OWNER TO postgres;

--
-- TOC entry 4375 (class 0 OID 0)
-- Dependencies: 2888
-- Name: TABLE ax_sonstigesrecht; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_sonstigesrecht IS 'S o n s t i g e s   R e c h t';


--
-- TOC entry 4376 (class 0 OID 0)
-- Dependencies: 2888
-- Name: COLUMN ax_sonstigesrecht.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_sonstigesrecht.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2887 (class 1259 OID 5502741)
-- Dependencies: 2888 3
-- Name: ax_sonstigesrecht_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_sonstigesrecht_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_sonstigesrecht_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4377 (class 0 OID 0)
-- Dependencies: 2887
-- Name: ax_sonstigesrecht_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_sonstigesrecht_ogc_fid_seq OWNED BY ax_sonstigesrecht.ogc_fid;


--
-- TOC entry 2790 (class 1259 OID 5501922)
-- Dependencies: 3348 3349 3350 3 961
-- Name: ax_sportfreizeitunderholungsflaeche; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_sportfreizeitunderholungsflaeche (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    zustand integer,
    name character varying(50),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_sportfreizeitunderholungsflaeche OWNER TO postgres;

--
-- TOC entry 4378 (class 0 OID 0)
-- Dependencies: 2790
-- Name: TABLE ax_sportfreizeitunderholungsflaeche; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_sportfreizeitunderholungsflaeche IS '"Sport-, Freizeit- und Erhohlungsfläche" ist eine bebaute oder unbebaute Fläche, die dem Sport, der Freizeitgestaltung oder der Erholung dient.';


--
-- TOC entry 4379 (class 0 OID 0)
-- Dependencies: 2790
-- Name: COLUMN ax_sportfreizeitunderholungsflaeche.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_sportfreizeitunderholungsflaeche.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4380 (class 0 OID 0)
-- Dependencies: 2790
-- Name: COLUMN ax_sportfreizeitunderholungsflaeche.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_sportfreizeitunderholungsflaeche.funktion IS 'FKT "Funktion" ist die Art der Nutzung von "Sport-, Freizeit- und Erholungsfläche".';


--
-- TOC entry 4381 (class 0 OID 0)
-- Dependencies: 2790
-- Name: COLUMN ax_sportfreizeitunderholungsflaeche.zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_sportfreizeitunderholungsflaeche.zustand IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "SportFreizeitUndErholungsflaeche ".';


--
-- TOC entry 4382 (class 0 OID 0)
-- Dependencies: 2790
-- Name: COLUMN ax_sportfreizeitunderholungsflaeche.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_sportfreizeitunderholungsflaeche.name IS 'NAM "Name" ist der Eigenname von "Sport-, Freizeit- und Erholungsfläche".';


--
-- TOC entry 2789 (class 1259 OID 5501920)
-- Dependencies: 3 2790
-- Name: ax_sportfreizeitunderholungsflaeche_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_sportfreizeitunderholungsflaeche_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_sportfreizeitunderholungsflaeche_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4383 (class 0 OID 0)
-- Dependencies: 2789
-- Name: ax_sportfreizeitunderholungsflaeche_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_sportfreizeitunderholungsflaeche_ogc_fid_seq OWNED BY ax_sportfreizeitunderholungsflaeche.ogc_fid;


--
-- TOC entry 2824 (class 1259 OID 5502211)
-- Dependencies: 3416 3417 3418 961 3
-- Name: ax_stehendesgewaesser; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_stehendesgewaesser (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    name character varying(50),
    gewaesserkennziffer character varying(30),
    hydrologischesmerkmal integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_stehendesgewaesser OWNER TO postgres;

--
-- TOC entry 4384 (class 0 OID 0)
-- Dependencies: 2824
-- Name: TABLE ax_stehendesgewaesser; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_stehendesgewaesser IS 's t e h e n d e s   G e w a e s s e r  ist eine natürliche oder künstliche mit Wasser gefüllte, allseitig umschlossene Hohlform der Landoberfläche ohne unmittelbaren Zusammenhang mit "Meer".';


--
-- TOC entry 4385 (class 0 OID 0)
-- Dependencies: 2824
-- Name: COLUMN ax_stehendesgewaesser.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_stehendesgewaesser.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4386 (class 0 OID 0)
-- Dependencies: 2824
-- Name: COLUMN ax_stehendesgewaesser.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_stehendesgewaesser.funktion IS 'FKT "Funktion" ist die Art von "Stehendes Gewässer".';


--
-- TOC entry 4387 (class 0 OID 0)
-- Dependencies: 2824
-- Name: COLUMN ax_stehendesgewaesser.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_stehendesgewaesser.name IS 'NAM "Name" ist der Eigenname von "Stehendes Gewässer".';


--
-- TOC entry 4388 (class 0 OID 0)
-- Dependencies: 2824
-- Name: COLUMN ax_stehendesgewaesser.gewaesserkennziffer; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_stehendesgewaesser.gewaesserkennziffer IS 'GWK  "Gewässerkennziffer" ist die von der zuständigen Fachstelle vergebene Verschlüsselung.';


--
-- TOC entry 4389 (class 0 OID 0)
-- Dependencies: 2824
-- Name: COLUMN ax_stehendesgewaesser.hydrologischesmerkmal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_stehendesgewaesser.hydrologischesmerkmal IS 'HYD  "Hydrologisches Merkmal" gibt die Wasserverhältnisse von "Stehendes Gewässer" an.';


--
-- TOC entry 2823 (class 1259 OID 5502209)
-- Dependencies: 2824 3
-- Name: ax_stehendesgewaesser_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_stehendesgewaesser_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_stehendesgewaesser_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4390 (class 0 OID 0)
-- Dependencies: 2823
-- Name: ax_stehendesgewaesser_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_stehendesgewaesser_ogc_fid_seq OWNED BY ax_stehendesgewaesser.ogc_fid;


--
-- TOC entry 2794 (class 1259 OID 5501956)
-- Dependencies: 3356 3357 3358 961 3
-- Name: ax_strassenverkehr; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_strassenverkehr (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    name character(50),
    zweitname character(50),
    zustand integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_strassenverkehr OWNER TO postgres;

--
-- TOC entry 4391 (class 0 OID 0)
-- Dependencies: 2794
-- Name: TABLE ax_strassenverkehr; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_strassenverkehr IS '"S t r a s s e n v e r k e h r" umfasst alle für die bauliche Anlage Straße erforderlichen sowie dem Straßenverkehr dienenden bebauten und unbebauten Flächen.';


--
-- TOC entry 4392 (class 0 OID 0)
-- Dependencies: 2794
-- Name: COLUMN ax_strassenverkehr.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_strassenverkehr.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4393 (class 0 OID 0)
-- Dependencies: 2794
-- Name: COLUMN ax_strassenverkehr.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_strassenverkehr.funktion IS 'FKT "Funktion" beschreibt die verkehrliche Nutzung von "Straßenverkehr".';


--
-- TOC entry 4394 (class 0 OID 0)
-- Dependencies: 2794
-- Name: COLUMN ax_strassenverkehr.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_strassenverkehr.name IS 'NAM "Name" ist der Eigenname von "Strassenverkehr".';


--
-- TOC entry 4395 (class 0 OID 0)
-- Dependencies: 2794
-- Name: COLUMN ax_strassenverkehr.zweitname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_strassenverkehr.zweitname IS 'ZNM "Zweitname" ist ein von der Lagebezeichnung abweichender Name von "Strassenverkehrsflaeche" (z.B. "Deutsche Weinstraße").';


--
-- TOC entry 4396 (class 0 OID 0)
-- Dependencies: 2794
-- Name: COLUMN ax_strassenverkehr.zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_strassenverkehr.zustand IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Strassenverkehrsflaeche".';


--
-- TOC entry 2793 (class 1259 OID 5501954)
-- Dependencies: 3 2794
-- Name: ax_strassenverkehr_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_strassenverkehr_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_strassenverkehr_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4397 (class 0 OID 0)
-- Dependencies: 2793
-- Name: ax_strassenverkehr_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_strassenverkehr_ogc_fid_seq OWNED BY ax_strassenverkehr.ogc_fid;


--
-- TOC entry 2852 (class 1259 OID 5502442)
-- Dependencies: 3464 3465 961 3
-- Name: ax_strassenverkehrsanlage; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_strassenverkehrsanlage (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    beginnt character(20),
    advstandardmodell character varying(9),
    sonstigesmodell character varying[],
    anlass integer,
    art integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_strassenverkehrsanlage OWNER TO postgres;

--
-- TOC entry 4398 (class 0 OID 0)
-- Dependencies: 2852
-- Name: TABLE ax_strassenverkehrsanlage; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_strassenverkehrsanlage IS 'S t r a s s e n v e r k e h r s a n l a g e';


--
-- TOC entry 4399 (class 0 OID 0)
-- Dependencies: 2852
-- Name: COLUMN ax_strassenverkehrsanlage.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_strassenverkehrsanlage.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2851 (class 1259 OID 5502440)
-- Dependencies: 3 2852
-- Name: ax_strassenverkehrsanlage_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_strassenverkehrsanlage_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_strassenverkehrsanlage_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4400 (class 0 OID 0)
-- Dependencies: 2851
-- Name: ax_strassenverkehrsanlage_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_strassenverkehrsanlage_ogc_fid_seq OWNED BY ax_strassenverkehrsanlage.ogc_fid;


--
-- TOC entry 2816 (class 1259 OID 5502143)
-- Dependencies: 3400 3401 3402 961 3
-- Name: ax_sumpf; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_sumpf (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    name character varying(50),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_sumpf OWNER TO postgres;

--
-- TOC entry 4401 (class 0 OID 0)
-- Dependencies: 2816
-- Name: TABLE ax_sumpf; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_sumpf IS '"S u m p f" ist ein wassergesättigtes, zeitweise unter Wasser stehendes Gelände. Nach Regenfällen kurzzeitig nasse Stellen im Boden werden nicht als "Sumpf" erfasst.';


--
-- TOC entry 4402 (class 0 OID 0)
-- Dependencies: 2816
-- Name: COLUMN ax_sumpf.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_sumpf.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4403 (class 0 OID 0)
-- Dependencies: 2816
-- Name: COLUMN ax_sumpf.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_sumpf.name IS 'NAM "Name" ist der Eigenname von "Sumpf".';


--
-- TOC entry 2815 (class 1259 OID 5502141)
-- Dependencies: 2816 3
-- Name: ax_sumpf_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_sumpf_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_sumpf_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4404 (class 0 OID 0)
-- Dependencies: 2815
-- Name: ax_sumpf_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_sumpf_ogc_fid_seq OWNED BY ax_sumpf.ogc_fid;


--
-- TOC entry 2784 (class 1259 OID 5501871)
-- Dependencies: 3336 3337 3338 961 3
-- Name: ax_tagebaugrubesteinbruch; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_tagebaugrubesteinbruch (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    abbaugut integer,
    name character varying(50),
    zustand integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_tagebaugrubesteinbruch OWNER TO postgres;

--
-- TOC entry 4405 (class 0 OID 0)
-- Dependencies: 2784
-- Name: TABLE ax_tagebaugrubesteinbruch; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_tagebaugrubesteinbruch IS '"T a g e b a u ,  G r u b e ,  S t e i n b r u c h"  ist eine Fläche, auf der oberirdisch Bodenmaterial abgebaut wird. Rekultivierte Tagebaue, Gruben, Steinbrüche werden als Objekte entsprechend der vorhandenen Nutzung erfasst.';


--
-- TOC entry 4406 (class 0 OID 0)
-- Dependencies: 2784
-- Name: COLUMN ax_tagebaugrubesteinbruch.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_tagebaugrubesteinbruch.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4407 (class 0 OID 0)
-- Dependencies: 2784
-- Name: COLUMN ax_tagebaugrubesteinbruch.abbaugut; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_tagebaugrubesteinbruch.abbaugut IS 'AGT "Abbaugut" gibt an, welches Material abgebaut wird.';


--
-- TOC entry 4408 (class 0 OID 0)
-- Dependencies: 2784
-- Name: COLUMN ax_tagebaugrubesteinbruch.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_tagebaugrubesteinbruch.name IS 'NAM "Name" ist der Eigenname von "Tagebau, Grube, Steinbruch".';


--
-- TOC entry 4409 (class 0 OID 0)
-- Dependencies: 2784
-- Name: COLUMN ax_tagebaugrubesteinbruch.zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_tagebaugrubesteinbruch.zustand IS 'ZUS "Zustand" beschreibt die Betriebsbereitschaft von "Tagebau, Grube, Steinbruch".';


--
-- TOC entry 2783 (class 1259 OID 5501869)
-- Dependencies: 3 2784
-- Name: ax_tagebaugrubesteinbruch_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_tagebaugrubesteinbruch_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_tagebaugrubesteinbruch_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4410 (class 0 OID 0)
-- Dependencies: 2783
-- Name: ax_tagebaugrubesteinbruch_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_tagebaugrubesteinbruch_ogc_fid_seq OWNED BY ax_tagebaugrubesteinbruch.ogc_fid;


--
-- TOC entry 2722 (class 1259 OID 5501414)
-- Dependencies: 3255 3256 3257 961 3
-- Name: ax_topographischelinie; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_topographischelinie (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(4),
    anlass integer,
    liniendarstellung integer,
    sonstigeeigenschaft character(21),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_topographischelinie OWNER TO postgres;

--
-- TOC entry 4411 (class 0 OID 0)
-- Dependencies: 2722
-- Name: TABLE ax_topographischelinie; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_topographischelinie IS 'T o p o g r a p h i s c h e   L i n i e';


--
-- TOC entry 4412 (class 0 OID 0)
-- Dependencies: 2722
-- Name: COLUMN ax_topographischelinie.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_topographischelinie.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2721 (class 1259 OID 5501412)
-- Dependencies: 2722 3
-- Name: ax_topographischelinie_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_topographischelinie_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_topographischelinie_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4413 (class 0 OID 0)
-- Dependencies: 2721
-- Name: ax_topographischelinie_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_topographischelinie_ogc_fid_seq OWNED BY ax_topographischelinie.ogc_fid;


--
-- TOC entry 2834 (class 1259 OID 5502296)
-- Dependencies: 3435 3436 3437 961 3
-- Name: ax_transportanlage; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_transportanlage (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    bauwerksfunktion integer,
    lagezurerdoberflaeche integer,
    art character varying(40),
    name character varying(20),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_transportanlage OWNER TO postgres;

--
-- TOC entry 4414 (class 0 OID 0)
-- Dependencies: 2834
-- Name: TABLE ax_transportanlage; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_transportanlage IS 'T r a n s p o r t a n l a g e';


--
-- TOC entry 4415 (class 0 OID 0)
-- Dependencies: 2834
-- Name: COLUMN ax_transportanlage.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_transportanlage.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2833 (class 1259 OID 5502294)
-- Dependencies: 2834 3
-- Name: ax_transportanlage_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_transportanlage_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_transportanlage_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4416 (class 0 OID 0)
-- Dependencies: 2833
-- Name: ax_transportanlage_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_transportanlage_ogc_fid_seq OWNED BY ax_transportanlage.ogc_fid;


--
-- TOC entry 2828 (class 1259 OID 5502245)
-- Dependencies: 3424 3425 3426 961 3
-- Name: ax_turm; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_turm (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    bauwerksfunktion integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_turm OWNER TO postgres;

--
-- TOC entry 4417 (class 0 OID 0)
-- Dependencies: 2828
-- Name: TABLE ax_turm; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_turm IS 'T u r m';


--
-- TOC entry 4418 (class 0 OID 0)
-- Dependencies: 2828
-- Name: COLUMN ax_turm.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_turm.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2827 (class 1259 OID 5502243)
-- Dependencies: 3 2828
-- Name: ax_turm_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_turm_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_turm_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4419 (class 0 OID 0)
-- Dependencies: 2827
-- Name: ax_turm_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_turm_ogc_fid_seq OWNED BY ax_turm.ogc_fid;


--
-- TOC entry 2818 (class 1259 OID 5502160)
-- Dependencies: 3404 3405 3406 961 3
-- Name: ax_unlandvegetationsloseflaeche; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_unlandvegetationsloseflaeche (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    oberflaechenmaterial integer,
    name character varying(50),
    funktion integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_unlandvegetationsloseflaeche OWNER TO postgres;

--
-- TOC entry 4420 (class 0 OID 0)
-- Dependencies: 2818
-- Name: TABLE ax_unlandvegetationsloseflaeche; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_unlandvegetationsloseflaeche IS '"Unland/Vegetationslose Fläche" ist eine Fläche, die dauerhaft landwirtschaftlich nicht genutzt wird, wie z.B. nicht aus dem Geländerelief herausragende Felspartien, Sand- oder Eisflächen, Uferstreifen längs von Gewässern und Sukzessionsflächen.';


--
-- TOC entry 4421 (class 0 OID 0)
-- Dependencies: 2818
-- Name: COLUMN ax_unlandvegetationsloseflaeche.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_unlandvegetationsloseflaeche.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4422 (class 0 OID 0)
-- Dependencies: 2818
-- Name: COLUMN ax_unlandvegetationsloseflaeche.oberflaechenmaterial; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_unlandvegetationsloseflaeche.oberflaechenmaterial IS 'OFM "Oberflächenmaterial" ist die Beschaffenheit des Bodens von "Unland/Vegetationslose Fläche".';


--
-- TOC entry 4423 (class 0 OID 0)
-- Dependencies: 2818
-- Name: COLUMN ax_unlandvegetationsloseflaeche.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_unlandvegetationsloseflaeche.name IS 'NAM "Name" ist die Bezeichnung oder der Eigenname von "Unland/ VegetationsloseFlaeche".';


--
-- TOC entry 4424 (class 0 OID 0)
-- Dependencies: 2818
-- Name: COLUMN ax_unlandvegetationsloseflaeche.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_unlandvegetationsloseflaeche.funktion IS 'FKT "Funktion" ist die erkennbare Art von "Unland/Vegetationslose Fläche".';


--
-- TOC entry 2817 (class 1259 OID 5502158)
-- Dependencies: 2818 3
-- Name: ax_unlandvegetationsloseflaeche_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_unlandvegetationsloseflaeche_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_unlandvegetationsloseflaeche_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4425 (class 0 OID 0)
-- Dependencies: 2817
-- Name: ax_unlandvegetationsloseflaeche_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_unlandvegetationsloseflaeche_ogc_fid_seq OWNED BY ax_unlandvegetationsloseflaeche.ogc_fid;


--
-- TOC entry 2868 (class 1259 OID 5502578)
-- Dependencies: 3491 3492 3 961
-- Name: ax_untergeordnetesgewaesser; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_untergeordnetesgewaesser (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_untergeordnetesgewaesser OWNER TO postgres;

--
-- TOC entry 4426 (class 0 OID 0)
-- Dependencies: 2868
-- Name: TABLE ax_untergeordnetesgewaesser; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_untergeordnetesgewaesser IS 'u n t e r g e o r d n e t e s   G e w a e s s e r';


--
-- TOC entry 4427 (class 0 OID 0)
-- Dependencies: 2868
-- Name: COLUMN ax_untergeordnetesgewaesser.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_untergeordnetesgewaesser.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2867 (class 1259 OID 5502576)
-- Dependencies: 2868 3
-- Name: ax_untergeordnetesgewaesser_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_untergeordnetesgewaesser_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_untergeordnetesgewaesser_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4428 (class 0 OID 0)
-- Dependencies: 2867
-- Name: ax_untergeordnetesgewaesser_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_untergeordnetesgewaesser_ogc_fid_seq OWNED BY ax_untergeordnetesgewaesser.ogc_fid;


--
-- TOC entry 2864 (class 1259 OID 5502544)
-- Dependencies: 3484 3485 3 961
-- Name: ax_vegetationsmerkmal; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_vegetationsmerkmal (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    bewuchs integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_vegetationsmerkmal OWNER TO postgres;

--
-- TOC entry 4429 (class 0 OID 0)
-- Dependencies: 2864
-- Name: TABLE ax_vegetationsmerkmal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_vegetationsmerkmal IS 'V e g a t a t i o n s m e r k m a l';


--
-- TOC entry 4430 (class 0 OID 0)
-- Dependencies: 2864
-- Name: COLUMN ax_vegetationsmerkmal.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_vegetationsmerkmal.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2863 (class 1259 OID 5502542)
-- Dependencies: 3 2864
-- Name: ax_vegetationsmerkmal_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_vegetationsmerkmal_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_vegetationsmerkmal_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4431 (class 0 OID 0)
-- Dependencies: 2863
-- Name: ax_vegetationsmerkmal_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_vegetationsmerkmal_ogc_fid_seq OWNED BY ax_vegetationsmerkmal.ogc_fid;


--
-- TOC entry 2832 (class 1259 OID 5502279)
-- Dependencies: 3431 3432 3433 961 3
-- Name: ax_vorratsbehaelterspeicherbauwerk; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_vorratsbehaelterspeicherbauwerk (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    speicherinhalt integer,
    bauwerksfunktion integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_vorratsbehaelterspeicherbauwerk OWNER TO postgres;

--
-- TOC entry 4432 (class 0 OID 0)
-- Dependencies: 2832
-- Name: TABLE ax_vorratsbehaelterspeicherbauwerk; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_vorratsbehaelterspeicherbauwerk IS 'V o r r a t s b e h a e l t e r  /  S p e i c h e r b a u w e r k';


--
-- TOC entry 4433 (class 0 OID 0)
-- Dependencies: 2832
-- Name: COLUMN ax_vorratsbehaelterspeicherbauwerk.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_vorratsbehaelterspeicherbauwerk.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2831 (class 1259 OID 5502277)
-- Dependencies: 3 2832
-- Name: ax_vorratsbehaelterspeicherbauwerk_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_vorratsbehaelterspeicherbauwerk_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_vorratsbehaelterspeicherbauwerk_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4434 (class 0 OID 0)
-- Dependencies: 2831
-- Name: ax_vorratsbehaelterspeicherbauwerk_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_vorratsbehaelterspeicherbauwerk_ogc_fid_seq OWNED BY ax_vorratsbehaelterspeicherbauwerk.ogc_fid;


--
-- TOC entry 2808 (class 1259 OID 5502075)
-- Dependencies: 3384 3385 3386 961 3
-- Name: ax_wald; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_wald (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    vegetationsmerkmal integer,
    name character varying(50),
    bezeichnung character varying(40),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_wald OWNER TO postgres;

--
-- TOC entry 4435 (class 0 OID 0)
-- Dependencies: 2808
-- Name: TABLE ax_wald; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_wald IS '"W a l d" ist eine Fläche, die mit Forstpflanzen (Waldbäume und Waldsträucher) bestockt ist.';


--
-- TOC entry 4436 (class 0 OID 0)
-- Dependencies: 2808
-- Name: COLUMN ax_wald.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_wald.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4437 (class 0 OID 0)
-- Dependencies: 2808
-- Name: COLUMN ax_wald.vegetationsmerkmal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_wald.vegetationsmerkmal IS 'VEG "Vegetationsmerkmal" beschreibt den Bewuchs von "Wald".';


--
-- TOC entry 4438 (class 0 OID 0)
-- Dependencies: 2808
-- Name: COLUMN ax_wald.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_wald.name IS 'NAM "Name" ist der Eigenname von "Wald".';


--
-- TOC entry 4439 (class 0 OID 0)
-- Dependencies: 2808
-- Name: COLUMN ax_wald.bezeichnung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_wald.bezeichnung IS 'BEZ "Bezeichnung" ist die von einer Fachstelle vergebene Kennziffer (Forstabteilungsnummer, Jagenzahl) von "Wald".';


--
-- TOC entry 2807 (class 1259 OID 5502073)
-- Dependencies: 3 2808
-- Name: ax_wald_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_wald_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_wald_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4440 (class 0 OID 0)
-- Dependencies: 2807
-- Name: ax_wald_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_wald_ogc_fid_seq OWNED BY ax_wald.ogc_fid;


--
-- TOC entry 2796 (class 1259 OID 5501973)
-- Dependencies: 3360 3361 3362 3 961
-- Name: ax_weg; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_weg (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    funktion integer,
    name character varying(50),
    bezeichnung character varying(50),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_weg OWNER TO postgres;

--
-- TOC entry 4441 (class 0 OID 0)
-- Dependencies: 2796
-- Name: TABLE ax_weg; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_weg IS '"W e g" umfasst alle Flächen, die zum Befahren und/oder Begehen vorgesehen sind. Zum "Weg" gehören auch Seitenstreifen und Gräben zur Wegentwässerung.';


--
-- TOC entry 4442 (class 0 OID 0)
-- Dependencies: 2796
-- Name: COLUMN ax_weg.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_weg.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4443 (class 0 OID 0)
-- Dependencies: 2796
-- Name: COLUMN ax_weg.funktion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_weg.funktion IS 'FKT "Funktion" ist die zum Zeitpunkt der Erhebung objektiv erkennbare oder feststellbare vorherrschend vorkommende Nutzung.';


--
-- TOC entry 4444 (class 0 OID 0)
-- Dependencies: 2796
-- Name: COLUMN ax_weg.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_weg.name IS 'NAM "Name" ist die Bezeichnung oder der Eigenname von "Wegflaeche".';


--
-- TOC entry 4445 (class 0 OID 0)
-- Dependencies: 2796
-- Name: COLUMN ax_weg.bezeichnung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_weg.bezeichnung IS 'BEZ "Bezeichnung" ist die amtliche Nummer des Weges.';


--
-- TOC entry 2795 (class 1259 OID 5501971)
-- Dependencies: 2796 3
-- Name: ax_weg_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_weg_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_weg_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4446 (class 0 OID 0)
-- Dependencies: 2795
-- Name: ax_weg_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_weg_ogc_fid_seq OWNED BY ax_weg.ogc_fid;


--
-- TOC entry 2854 (class 1259 OID 5502459)
-- Dependencies: 3467 3468 961 3
-- Name: ax_wegpfadsteig; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_wegpfadsteig (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    sonstigesmodell character varying[],
    anlass integer,
    art integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_wegpfadsteig OWNER TO postgres;

--
-- TOC entry 4447 (class 0 OID 0)
-- Dependencies: 2854
-- Name: TABLE ax_wegpfadsteig; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_wegpfadsteig IS 'W e g  /  P f a d  /  S t e i g';


--
-- TOC entry 4448 (class 0 OID 0)
-- Dependencies: 2854
-- Name: COLUMN ax_wegpfadsteig.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_wegpfadsteig.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2853 (class 1259 OID 5502457)
-- Dependencies: 2854 3
-- Name: ax_wegpfadsteig_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_wegpfadsteig_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_wegpfadsteig_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4449 (class 0 OID 0)
-- Dependencies: 2853
-- Name: ax_wegpfadsteig_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_wegpfadsteig_ogc_fid_seq OWNED BY ax_wegpfadsteig.ogc_fid;


--
-- TOC entry 2776 (class 1259 OID 5501803)
-- Dependencies: 3321 3322 3323 961 3
-- Name: ax_wohnbauflaeche; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_wohnbauflaeche (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    artderbebauung integer,
    zustand integer,
    name character(50),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_wohnbauflaeche OWNER TO postgres;

--
-- TOC entry 4450 (class 0 OID 0)
-- Dependencies: 2776
-- Name: TABLE ax_wohnbauflaeche; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_wohnbauflaeche IS 'W o h n b a u f l a e c h e  ist eine baulich geprägte Fläche einschließlich der mit ihr im Zusammenhang stehenden Freiflächen (z.B. Vorgärten, Ziergärten, Zufahrten, Stellplätze und Hofraumflächen), die ausschließlich oder vorwiegend dem Wohnen dient.';


--
-- TOC entry 4451 (class 0 OID 0)
-- Dependencies: 2776
-- Name: COLUMN ax_wohnbauflaeche.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_wohnbauflaeche.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 4452 (class 0 OID 0)
-- Dependencies: 2776
-- Name: COLUMN ax_wohnbauflaeche.artderbebauung; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_wohnbauflaeche.artderbebauung IS 'BEB "Art der Bebauung" differenziert nach offener und geschlossener Bauweise aus topographischer Sicht und nicht nach gesetzlichen Vorgaben (z.B. BauGB).';


--
-- TOC entry 4453 (class 0 OID 0)
-- Dependencies: 2776
-- Name: COLUMN ax_wohnbauflaeche.zustand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_wohnbauflaeche.zustand IS 'ZUS "Zustand" beschreibt, ob "Wohnbaufläche" ungenutzt ist oder ob eine Fläche als Wohnbaufläche genutzt werden soll.';


--
-- TOC entry 4454 (class 0 OID 0)
-- Dependencies: 2776
-- Name: COLUMN ax_wohnbauflaeche.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_wohnbauflaeche.name IS 'NAM "Name" ist der Eigenname von "Wohnbaufläche" insbesondere bei Objekten außerhalb von Ortslagen.';


--
-- TOC entry 2775 (class 1259 OID 5501801)
-- Dependencies: 3 2776
-- Name: ax_wohnbauflaeche_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_wohnbauflaeche_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_wohnbauflaeche_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4455 (class 0 OID 0)
-- Dependencies: 2775
-- Name: ax_wohnbauflaeche_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_wohnbauflaeche_ogc_fid_seq OWNED BY ax_wohnbauflaeche.ogc_fid;


--
-- TOC entry 2914 (class 1259 OID 5502906)
-- Dependencies: 3547 3548 3549 3 961
-- Name: ax_wohnplatz; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ax_wohnplatz (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character varying(28),
    beginnt character(20),
    advstandardmodell character varying(9),
    anlass integer,
    name character varying(20),
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ax_wohnplatz OWNER TO postgres;

--
-- TOC entry 4456 (class 0 OID 0)
-- Dependencies: 2914
-- Name: TABLE ax_wohnplatz; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE ax_wohnplatz IS 'W o h n p l a t z';


--
-- TOC entry 4457 (class 0 OID 0)
-- Dependencies: 2914
-- Name: COLUMN ax_wohnplatz.gml_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN ax_wohnplatz.gml_id IS 'Identifikator, global eindeutig';


--
-- TOC entry 2913 (class 1259 OID 5502904)
-- Dependencies: 2914 3
-- Name: ax_wohnplatz_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ax_wohnplatz_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ax_wohnplatz_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4458 (class 0 OID 0)
-- Dependencies: 2913
-- Name: ax_wohnplatz_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ax_wohnplatz_ogc_fid_seq OWNED BY ax_wohnplatz.ogc_fid;


SET default_with_oids = true;

--
-- TOC entry 2668 (class 1259 OID 16784)
-- Dependencies: 3
-- Name: geometry_columns; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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


ALTER TABLE public.geometry_columns OWNER TO postgres;

--
-- TOC entry 4459 (class 0 OID 0)
-- Dependencies: 2668
-- Name: TABLE geometry_columns; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE geometry_columns IS 'Metatabelle der Geometrie-Tabellen, Tabellen ohne Geometrie bekommen Dummy-Eintrag für PostNAS-Konverter (GDAL)';


SET default_with_oids = false;

--
-- TOC entry 2692 (class 1259 OID 5501183)
-- Dependencies: 3211 3212 3213 961 3
-- Name: ks_sonstigesbauwerk; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ks_sonstigesbauwerk (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    sonstigesmodell character(6),
    anlass integer,
    bauwerksfunktion integer,
    wkb_geometry geometry,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((srid(wkb_geometry) = 25832))
);


ALTER TABLE public.ks_sonstigesbauwerk OWNER TO postgres;

--
-- TOC entry 2691 (class 1259 OID 5501181)
-- Dependencies: 3 2692
-- Name: ks_sonstigesbauwerk_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ks_sonstigesbauwerk_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ks_sonstigesbauwerk_ogc_fid_seq OWNER TO postgres;

--
-- TOC entry 4460 (class 0 OID 0)
-- Dependencies: 2691
-- Name: ks_sonstigesbauwerk_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ks_sonstigesbauwerk_ogc_fid_seq OWNED BY ks_sonstigesbauwerk.ogc_fid;


--
-- TOC entry 2667 (class 1259 OID 16776)
-- Dependencies: 3
-- Name: spatial_ref_sys; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE spatial_ref_sys (
    srid integer NOT NULL,
    auth_name character varying(256),
    auth_srid integer,
    srtext character varying(2048),
    proj4text character varying(2048)
);


ALTER TABLE public.spatial_ref_sys OWNER TO postgres;

--
-- TOC entry 4461 (class 0 OID 0)
-- Dependencies: 2667
-- Name: TABLE spatial_ref_sys; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE spatial_ref_sys IS 'Koordinatensysteme und ihre Projektionssparameter';


--
-- TOC entry 3196 (class 2604 OID 5501061)
-- Dependencies: 2670 2669 2670
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE aa_aktivitaet ALTER COLUMN ogc_fid SET DEFAULT nextval('aa_aktivitaet_ogc_fid_seq'::regclass);


--
-- TOC entry 3197 (class 2604 OID 5501073)
-- Dependencies: 2671 2672 2672
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE aa_antrag ALTER COLUMN ogc_fid SET DEFAULT nextval('aa_antrag_ogc_fid_seq'::regclass);


--
-- TOC entry 3198 (class 2604 OID 5501085)
-- Dependencies: 2674 2673 2674
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE aa_antragsgebiet ALTER COLUMN ogc_fid SET DEFAULT nextval('aa_antragsgebiet_ogc_fid_seq'::regclass);


--
-- TOC entry 3202 (class 2604 OID 5501101)
-- Dependencies: 2676 2675 2676
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE aa_meilenstein ALTER COLUMN ogc_fid SET DEFAULT nextval('aa_meilenstein_ogc_fid_seq'::regclass);


--
-- TOC entry 3203 (class 2604 OID 5501113)
-- Dependencies: 2678 2677 2678
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE aa_projektsteuerung ALTER COLUMN ogc_fid SET DEFAULT nextval('aa_projektsteuerung_ogc_fid_seq'::regclass);


--
-- TOC entry 3204 (class 2604 OID 5501125)
-- Dependencies: 2680 2679 2680
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE aa_vorgang ALTER COLUMN ogc_fid SET DEFAULT nextval('aa_vorgang_ogc_fid_seq'::regclass);


--
-- TOC entry 3214 (class 2604 OID 5501202)
-- Dependencies: 2693 2694 2694
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE alkis_beziehungen ALTER COLUMN ogc_fid SET DEFAULT nextval('alkis_beziehungen_ogc_fid_seq'::regclass);


--
-- TOC entry 3273 (class 2604 OID 5501503)
-- Dependencies: 2731 2732 2732
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ap_darstellung ALTER COLUMN ogc_fid SET DEFAULT nextval('ap_darstellung_ogc_fid_seq'::regclass);


--
-- TOC entry 3261 (class 2604 OID 5501451)
-- Dependencies: 2726 2725 2726
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ap_lpo ALTER COLUMN ogc_fid SET DEFAULT nextval('ap_lpo_ogc_fid_seq'::regclass);


--
-- TOC entry 3269 (class 2604 OID 5501486)
-- Dependencies: 2730 2729 2730
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ap_lto ALTER COLUMN ogc_fid SET DEFAULT nextval('ap_lto_ogc_fid_seq'::regclass);


--
-- TOC entry 3258 (class 2604 OID 5501434)
-- Dependencies: 2723 2724 2724
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ap_ppo ALTER COLUMN ogc_fid SET DEFAULT nextval('ap_ppo_ogc_fid_seq'::regclass);


--
-- TOC entry 3265 (class 2604 OID 5501468)
-- Dependencies: 2728 2727 2728
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ap_pto ALTER COLUMN ogc_fid SET DEFAULT nextval('ap_pto_ogc_fid_seq'::regclass);


--
-- TOC entry 3215 (class 2604 OID 5501213)
-- Dependencies: 2695 2696 2696
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_anderefestlegungnachwasserrecht ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_anderefestlegungnachwasserrecht_ogc_fid_seq'::regclass);


--
-- TOC entry 3300 (class 2604 OID 5501679)
-- Dependencies: 2757 2758 2758
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_anschrift ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_anschrift_ogc_fid_seq'::regclass);


--
-- TOC entry 3285 (class 2604 OID 5501592)
-- Dependencies: 2746 2745 2746
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_aufnahmepunkt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_aufnahmepunkt_ogc_fid_seq'::regclass);


--
-- TOC entry 3367 (class 2604 OID 5502010)
-- Dependencies: 2799 2800 2800
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_bahnverkehr ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bahnverkehr_ogc_fid_seq'::regclass);


--
-- TOC entry 3469 (class 2604 OID 5502479)
-- Dependencies: 2856 2855 2856
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_bahnverkehrsanlage ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bahnverkehrsanlage_ogc_fid_seq'::regclass);


--
-- TOC entry 3219 (class 2604 OID 5501230)
-- Dependencies: 2697 2698 2698
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_baublock ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_baublock_ogc_fid_seq'::regclass);


--
-- TOC entry 3521 (class 2604 OID 5502729)
-- Dependencies: 2886 2885 2886
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_bauraumoderbodenordnungsrecht ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bauraumoderbodenordnungsrecht_ogc_fid_seq'::regclass);


--
-- TOC entry 3307 (class 2604 OID 5501742)
-- Dependencies: 2768 2767 2768
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_bauteil ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bauteil_ogc_fid_seq'::regclass);


--
-- TOC entry 3480 (class 2604 OID 5502530)
-- Dependencies: 2861 2862 2862
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_bauwerkimgewaesserbereich ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bauwerkimgewaesserbereich_ogc_fid_seq'::regclass);


--
-- TOC entry 3460 (class 2604 OID 5502428)
-- Dependencies: 2850 2849 2850
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_bauwerkimverkehrsbereich ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bauwerkimverkehrsbereich_ogc_fid_seq'::regclass);


--
-- TOC entry 3427 (class 2604 OID 5502265)
-- Dependencies: 2830 2829 2830
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_bauwerkoderanlagefuerindustrieundgewerbe ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bauwerkoderanlagefuerindustrieundgewerbe_ogc_fid_seq'::regclass);


--
-- TOC entry 3442 (class 2604 OID 5502333)
-- Dependencies: 2838 2837 2838
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_bauwerkoderanlagefuersportfreizeitunderholung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bauwerkoderanlagefuersportfreizeitunderholung_ogc_fid_seq'::regclass);


--
-- TOC entry 3205 (class 2604 OID 5501137)
-- Dependencies: 2681 2682 2682
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_benutzer ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_benutzer_ogc_fid_seq'::regclass);


--
-- TOC entry 3206 (class 2604 OID 5501148)
-- Dependencies: 2684 2683 2684
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_benutzergruppemitzugriffskontrolle ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_benutzergruppemitzugriffskontrolle_ogc_fid_seq'::regclass);


--
-- TOC entry 3207 (class 2604 OID 5501159)
-- Dependencies: 2685 2686 2686
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_benutzergruppenba ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_benutzergruppenba_ogc_fid_seq'::regclass);


--
-- TOC entry 3331 (class 2604 OID 5501857)
-- Dependencies: 2782 2781 2782
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_bergbaubetrieb ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bergbaubetrieb_ogc_fid_seq'::regclass);


--
-- TOC entry 3277 (class 2604 OID 5501530)
-- Dependencies: 2736 2735 2736
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_besondereflurstuecksgrenze ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_besondereflurstuecksgrenze_ogc_fid_seq'::regclass);


--
-- TOC entry 3311 (class 2604 OID 5501759)
-- Dependencies: 2770 2769 2770
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_besonderegebaeudelinie ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_besonderegebaeudelinie_ogc_fid_seq'::regclass);


--
-- TOC entry 3459 (class 2604 OID 5502418)
-- Dependencies: 2848 2847 2848
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_besondererbauwerkspunkt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_besondererbauwerkspunkt_ogc_fid_seq'::regclass);


--
-- TOC entry 3319 (class 2604 OID 5501793)
-- Dependencies: 2773 2774 2774
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_besonderergebaeudepunkt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_besonderergebaeudepunkt_ogc_fid_seq'::regclass);


--
-- TOC entry 3509 (class 2604 OID 5502679)
-- Dependencies: 2879 2880 2880
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_besondererhoehenpunkt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_besondererhoehenpunkt_ogc_fid_seq'::regclass);


--
-- TOC entry 3223 (class 2604 OID 5501247)
-- Dependencies: 2699 2700 2700
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_besonderertopographischerpunkt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_besonderertopographischerpunkt_ogc_fid_seq'::regclass);


--
-- TOC entry 3224 (class 2604 OID 5501257)
-- Dependencies: 2701 2702 2702
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_bewertung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bewertung_ogc_fid_seq'::regclass);


--
-- TOC entry 3527 (class 2604 OID 5502763)
-- Dependencies: 2890 2889 2890
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_bodenschaetzung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bodenschaetzung_ogc_fid_seq'::regclass);


--
-- TOC entry 3493 (class 2604 OID 5502598)
-- Dependencies: 2869 2870 2870
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_boeschungkliff ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_boeschungkliff_ogc_fid_seq'::regclass);


--
-- TOC entry 3494 (class 2604 OID 5502611)
-- Dependencies: 2872 2871 2872
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_boeschungsflaeche ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_boeschungsflaeche_ogc_fid_seq'::regclass);


--
-- TOC entry 3302 (class 2604 OID 5501702)
-- Dependencies: 2762 2761 2762
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_buchungsblatt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_buchungsblatt_ogc_fid_seq'::regclass);


--
-- TOC entry 3539 (class 2604 OID 5502858)
-- Dependencies: 2905 2906 2906
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_buchungsblattbezirk ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_buchungsblattbezirk_ogc_fid_seq'::regclass);


--
-- TOC entry 3303 (class 2604 OID 5501712)
-- Dependencies: 2764 2763 2764
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_buchungsstelle ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_buchungsstelle_ogc_fid_seq'::regclass);


--
-- TOC entry 3533 (class 2604 OID 5502797)
-- Dependencies: 2893 2894 2894
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_bundesland ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bundesland_ogc_fid_seq'::regclass);


--
-- TOC entry 3498 (class 2604 OID 5502628)
-- Dependencies: 2873 2874 2874
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_dammwalldeich ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_dammwalldeich_ogc_fid_seq'::regclass);


--
-- TOC entry 3228 (class 2604 OID 5501274)
-- Dependencies: 2703 2704 2704
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_denkmalschutzrecht ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_denkmalschutzrecht_ogc_fid_seq'::regclass);


--
-- TOC entry 3540 (class 2604 OID 5502869)
-- Dependencies: 2907 2908 2908
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_dienststelle ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_dienststelle_ogc_fid_seq'::regclass);


--
-- TOC entry 3455 (class 2604 OID 5502401)
-- Dependencies: 2845 2846 2846
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_einrichtunginoeffentlichenbereichen ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_einrichtunginoeffentlichenbereichen_ogc_fid_seq'::regclass);


--
-- TOC entry 3501 (class 2604 OID 5502645)
-- Dependencies: 2875 2876 2876
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_felsenfelsblockfelsnadel ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_felsenfelsblockfelsnadel_ogc_fid_seq'::regclass);


--
-- TOC entry 3315 (class 2604 OID 5501776)
-- Dependencies: 2772 2771 2772
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_firstlinie ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_firstlinie_ogc_fid_seq'::regclass);


--
-- TOC entry 3343 (class 2604 OID 5501908)
-- Dependencies: 2788 2787 2788
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_flaechebesondererfunktionalerpraegung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq'::regclass);


--
-- TOC entry 3339 (class 2604 OID 5501891)
-- Dependencies: 2785 2786 2786
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_flaechegemischternutzung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_flaechegemischternutzung_ogc_fid_seq'::regclass);


--
-- TOC entry 3407 (class 2604 OID 5502180)
-- Dependencies: 2820 2819 2820
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_fliessgewaesser ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_fliessgewaesser_ogc_fid_seq'::regclass);


--
-- TOC entry 3371 (class 2604 OID 5502027)
-- Dependencies: 2802 2801 2802
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_flugverkehr ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_flugverkehr_ogc_fid_seq'::regclass);


--
-- TOC entry 3476 (class 2604 OID 5502513)
-- Dependencies: 2860 2859 2860
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_flugverkehrsanlage ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_flugverkehrsanlage_ogc_fid_seq'::regclass);


--
-- TOC entry 3274 (class 2604 OID 5501513)
-- Dependencies: 2734 2733 2734
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_flurstueck ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_flurstueck_ogc_fid_seq'::regclass);


--
-- TOC entry 3351 (class 2604 OID 5501942)
-- Dependencies: 2791 2792 2792
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_friedhof ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_friedhof_ogc_fid_seq'::regclass);


--
-- TOC entry 3304 (class 2604 OID 5501725)
-- Dependencies: 2766 2765 2766
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_gebaeude ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gebaeude_ogc_fid_seq'::regclass);


--
-- TOC entry 3231 (class 2604 OID 5501291)
-- Dependencies: 2706 2705 2706
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_gebaeudeausgestaltung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gebaeudeausgestaltung_ogc_fid_seq'::regclass);


--
-- TOC entry 3387 (class 2604 OID 5502095)
-- Dependencies: 2810 2809 2810
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_gehoelz ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gehoelz_ogc_fid_seq'::regclass);


--
-- TOC entry 3505 (class 2604 OID 5502662)
-- Dependencies: 2877 2878 2878
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_gelaendekante ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gelaendekante_ogc_fid_seq'::regclass);


--
-- TOC entry 3537 (class 2604 OID 5502837)
-- Dependencies: 2902 2901 2902
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_gemarkung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gemarkung_ogc_fid_seq'::regclass);


--
-- TOC entry 3538 (class 2604 OID 5502848)
-- Dependencies: 2904 2903 2904
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_gemarkungsteilflur ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gemarkungsteilflur_ogc_fid_seq'::regclass);


--
-- TOC entry 3536 (class 2604 OID 5502827)
-- Dependencies: 2900 2899 2900
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_gemeinde ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gemeinde_ogc_fid_seq'::regclass);


--
-- TOC entry 3235 (class 2604 OID 5501308)
-- Dependencies: 2708 2707 2708
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_georeferenziertegebaeudeadresse ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_georeferenziertegebaeudeadresse_ogc_fid_seq'::regclass);


--
-- TOC entry 3486 (class 2604 OID 5502564)
-- Dependencies: 2865 2866 2866
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_gewaessermerkmal ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gewaessermerkmal_ogc_fid_seq'::regclass);


--
-- TOC entry 3473 (class 2604 OID 5502496)
-- Dependencies: 2857 2858 2858
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_gleis ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gleis_ogc_fid_seq'::regclass);


--
-- TOC entry 3239 (class 2604 OID 5501326)
-- Dependencies: 2709 2710 2710
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_grablochderbodenschaetzung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_grablochderbodenschaetzung_ogc_fid_seq'::regclass);


--
-- TOC entry 3281 (class 2604 OID 5501547)
-- Dependencies: 2737 2738 2738
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_grenzpunkt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_grenzpunkt_ogc_fid_seq'::regclass);


--
-- TOC entry 3411 (class 2604 OID 5502197)
-- Dependencies: 2821 2822 2822
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_hafenbecken ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_hafenbecken_ogc_fid_seq'::regclass);


--
-- TOC entry 3327 (class 2604 OID 5501840)
-- Dependencies: 2780 2779 2780
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_halde ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_halde_ogc_fid_seq'::regclass);


--
-- TOC entry 3391 (class 2604 OID 5502112)
-- Dependencies: 2811 2812 2812
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_heide ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_heide_ogc_fid_seq'::regclass);


--
-- TOC entry 3448 (class 2604 OID 5502367)
-- Dependencies: 2842 2841 2842
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_heilquellegasquelle ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_heilquellegasquelle_ogc_fid_seq'::regclass);


--
-- TOC entry 3445 (class 2604 OID 5502350)
-- Dependencies: 2840 2839 2840
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_historischesbauwerkoderhistorischeeinrichtung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_historischesbauwerkoderhistorischeeinrichtung_ogc_fid_seq'::regclass);


--
-- TOC entry 3244 (class 2604 OID 5501356)
-- Dependencies: 2714 2713 2714
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_historischesflurstueck ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_historischesflurstueck_ogc_fid_seq'::regclass);


--
-- TOC entry 3243 (class 2604 OID 5501343)
-- Dependencies: 2711 2712 2712
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_historischesflurstueckalb ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_historischesflurstueckalb_ogc_fid_seq'::regclass);


--
-- TOC entry 3324 (class 2604 OID 5501823)
-- Dependencies: 2777 2778 2778
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_industrieundgewerbeflaeche ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_industrieundgewerbeflaeche_ogc_fid_seq'::regclass);


--
-- TOC entry 3513 (class 2604 OID 5502696)
-- Dependencies: 2881 2882 2882
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_klassifizierungnachstrassenrecht ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_klassifizierungnachstrassenrecht_ogc_fid_seq'::regclass);


--
-- TOC entry 3517 (class 2604 OID 5502713)
-- Dependencies: 2883 2884 2884
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_klassifizierungnachwasserrecht ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_klassifizierungnachwasserrecht_ogc_fid_seq'::regclass);


--
-- TOC entry 3542 (class 2604 OID 5502892)
-- Dependencies: 2912 2911 2912
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_kleinraeumigerlandschaftsteil ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_kleinraeumigerlandschaftsteil_ogc_fid_seq'::regclass);


--
-- TOC entry 3550 (class 2604 OID 5502926)
-- Dependencies: 2915 2916 2916
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_kommunalesgebiet ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_kommunalesgebiet_ogc_fid_seq'::regclass);


--
-- TOC entry 3535 (class 2604 OID 5502817)
-- Dependencies: 2898 2897 2898
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_kreisregion ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_kreisregion_ogc_fid_seq'::regclass);


--
-- TOC entry 3541 (class 2604 OID 5502879)
-- Dependencies: 2910 2909 2910
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_lagebezeichnungkatalogeintrag ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_lagebezeichnungkatalogeintrag_ogc_fid_seq'::regclass);


--
-- TOC entry 3283 (class 2604 OID 5501571)
-- Dependencies: 2742 2741 2742
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_lagebezeichnungmithausnummer ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_lagebezeichnungmithausnummer_ogc_fid_seq'::regclass);


--
-- TOC entry 3284 (class 2604 OID 5501582)
-- Dependencies: 2743 2744 2744
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_lagebezeichnungmitpseudonummer ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_lagebezeichnungmitpseudonummer_ogc_fid_seq'::regclass);


--
-- TOC entry 3282 (class 2604 OID 5501560)
-- Dependencies: 2740 2739 2740
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_lagebezeichnungohnehausnummer ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_lagebezeichnungohnehausnummer_ogc_fid_seq'::regclass);


--
-- TOC entry 3379 (class 2604 OID 5502061)
-- Dependencies: 2805 2806 2806
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_landwirtschaft ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_landwirtschaft_ogc_fid_seq'::regclass);


--
-- TOC entry 3438 (class 2604 OID 5502316)
-- Dependencies: 2835 2836 2836
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_leitung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_leitung_ogc_fid_seq'::regclass);


--
-- TOC entry 3419 (class 2604 OID 5502231)
-- Dependencies: 2825 2826 2826
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_meer ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_meer_ogc_fid_seq'::regclass);


--
-- TOC entry 3395 (class 2604 OID 5502129)
-- Dependencies: 2813 2814 2814
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_moor ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_moor_ogc_fid_seq'::regclass);


--
-- TOC entry 3530 (class 2604 OID 5502780)
-- Dependencies: 2892 2891 2892
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_musterlandesmusterundvergleichsstueck ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_musterlandesmusterundvergleichsstueck_ogc_fid_seq'::regclass);


--
-- TOC entry 3301 (class 2604 OID 5501689)
-- Dependencies: 2760 2759 2760
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_namensnummer ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_namensnummer_ogc_fid_seq'::regclass);


--
-- TOC entry 3247 (class 2604 OID 5501373)
-- Dependencies: 2716 2715 2716
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_naturumweltoderbodenschutzrecht ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_naturumweltoderbodenschutzrecht_ogc_fid_seq'::regclass);


--
-- TOC entry 3299 (class 2604 OID 5501669)
-- Dependencies: 2756 2755 2756
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_person ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_person_ogc_fid_seq'::regclass);


--
-- TOC entry 3363 (class 2604 OID 5501993)
-- Dependencies: 2798 2797 2798
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_platz ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_platz_ogc_fid_seq'::regclass);


--
-- TOC entry 3208 (class 2604 OID 5501170)
-- Dependencies: 2688 2687 2688
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_punktkennunguntergegangen ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_punktkennunguntergegangen_ogc_fid_seq'::regclass);


--
-- TOC entry 3287 (class 2604 OID 5501618)
-- Dependencies: 2749 2750 2750
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_punktortag ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_punktortag_ogc_fid_seq'::regclass);


--
-- TOC entry 3291 (class 2604 OID 5501635)
-- Dependencies: 2751 2752 2752
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_punktortau ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_punktortau_ogc_fid_seq'::regclass);


--
-- TOC entry 3295 (class 2604 OID 5501652)
-- Dependencies: 2753 2754 2754
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_punktortta ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_punktortta_ogc_fid_seq'::regclass);


--
-- TOC entry 3534 (class 2604 OID 5502807)
-- Dependencies: 2895 2896 2896
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_regierungsbezirk ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_regierungsbezirk_ogc_fid_seq'::regclass);


--
-- TOC entry 3209 (class 2604 OID 5501178)
-- Dependencies: 2689 2690 2690
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_reservierung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_reservierung_ogc_fid_seq'::regclass);


--
-- TOC entry 3375 (class 2604 OID 5502044)
-- Dependencies: 2803 2804 2804
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_schiffsverkehr ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_schiffsverkehr_ogc_fid_seq'::regclass);


--
-- TOC entry 3250 (class 2604 OID 5501390)
-- Dependencies: 2718 2717 2718
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_schutzgebietnachwasserrecht ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_schutzgebietnachwasserrecht_ogc_fid_seq'::regclass);


--
-- TOC entry 3251 (class 2604 OID 5501400)
-- Dependencies: 2720 2719 2720
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_schutzzone ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_schutzzone_ogc_fid_seq'::regclass);


--
-- TOC entry 3286 (class 2604 OID 5501605)
-- Dependencies: 2747 2748 2748
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_sonstigervermessungspunkt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_sonstigervermessungspunkt_ogc_fid_seq'::regclass);


--
-- TOC entry 3452 (class 2604 OID 5502384)
-- Dependencies: 2844 2843 2844
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_sonstigesbauwerkodersonstigeeinrichtung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq'::regclass);


--
-- TOC entry 3524 (class 2604 OID 5502746)
-- Dependencies: 2887 2888 2888
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_sonstigesrecht ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_sonstigesrecht_ogc_fid_seq'::regclass);


--
-- TOC entry 3347 (class 2604 OID 5501925)
-- Dependencies: 2789 2790 2790
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_sportfreizeitunderholungsflaeche ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_sportfreizeitunderholungsflaeche_ogc_fid_seq'::regclass);


--
-- TOC entry 3415 (class 2604 OID 5502214)
-- Dependencies: 2823 2824 2824
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_stehendesgewaesser ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_stehendesgewaesser_ogc_fid_seq'::regclass);


--
-- TOC entry 3355 (class 2604 OID 5501959)
-- Dependencies: 2794 2793 2794
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_strassenverkehr ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_strassenverkehr_ogc_fid_seq'::regclass);


--
-- TOC entry 3463 (class 2604 OID 5502445)
-- Dependencies: 2852 2851 2852
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_strassenverkehrsanlage ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_strassenverkehrsanlage_ogc_fid_seq'::regclass);


--
-- TOC entry 3399 (class 2604 OID 5502146)
-- Dependencies: 2816 2815 2816
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_sumpf ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_sumpf_ogc_fid_seq'::regclass);


--
-- TOC entry 3335 (class 2604 OID 5501874)
-- Dependencies: 2783 2784 2784
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_tagebaugrubesteinbruch ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_tagebaugrubesteinbruch_ogc_fid_seq'::regclass);


--
-- TOC entry 3254 (class 2604 OID 5501417)
-- Dependencies: 2722 2721 2722
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_topographischelinie ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_topographischelinie_ogc_fid_seq'::regclass);


--
-- TOC entry 3434 (class 2604 OID 5502299)
-- Dependencies: 2833 2834 2834
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_transportanlage ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_transportanlage_ogc_fid_seq'::regclass);


--
-- TOC entry 3423 (class 2604 OID 5502248)
-- Dependencies: 2828 2827 2828
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_turm ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_turm_ogc_fid_seq'::regclass);


--
-- TOC entry 3403 (class 2604 OID 5502163)
-- Dependencies: 2818 2817 2818
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_unlandvegetationsloseflaeche ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_unlandvegetationsloseflaeche_ogc_fid_seq'::regclass);


--
-- TOC entry 3490 (class 2604 OID 5502581)
-- Dependencies: 2868 2867 2868
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_untergeordnetesgewaesser ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_untergeordnetesgewaesser_ogc_fid_seq'::regclass);


--
-- TOC entry 3483 (class 2604 OID 5502547)
-- Dependencies: 2864 2863 2864
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_vegetationsmerkmal ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_vegetationsmerkmal_ogc_fid_seq'::regclass);


--
-- TOC entry 3430 (class 2604 OID 5502282)
-- Dependencies: 2831 2832 2832
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_vorratsbehaelterspeicherbauwerk ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_vorratsbehaelterspeicherbauwerk_ogc_fid_seq'::regclass);


--
-- TOC entry 3383 (class 2604 OID 5502078)
-- Dependencies: 2807 2808 2808
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_wald ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_wald_ogc_fid_seq'::regclass);


--
-- TOC entry 3359 (class 2604 OID 5501976)
-- Dependencies: 2796 2795 2796
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_weg ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_weg_ogc_fid_seq'::regclass);


--
-- TOC entry 3466 (class 2604 OID 5502462)
-- Dependencies: 2854 2853 2854
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_wegpfadsteig ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_wegpfadsteig_ogc_fid_seq'::regclass);


--
-- TOC entry 3320 (class 2604 OID 5501806)
-- Dependencies: 2776 2775 2776
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_wohnbauflaeche ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_wohnbauflaeche_ogc_fid_seq'::regclass);


--
-- TOC entry 3546 (class 2604 OID 5502909)
-- Dependencies: 2913 2914 2914
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ax_wohnplatz ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_wohnplatz_ogc_fid_seq'::regclass);


--
-- TOC entry 3210 (class 2604 OID 5501186)
-- Dependencies: 2692 2691 2692
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ks_sonstigesbauwerk ALTER COLUMN ogc_fid SET DEFAULT nextval('ks_sonstigesbauwerk_ogc_fid_seq'::regclass);


--
-- TOC entry 3558 (class 2606 OID 5501066)
-- Dependencies: 2670 2670
-- Name: aa_aktivitaet_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY aa_aktivitaet
    ADD CONSTRAINT aa_aktivitaet_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3560 (class 2606 OID 5501078)
-- Dependencies: 2672 2672
-- Name: aa_antrag_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY aa_antrag
    ADD CONSTRAINT aa_antrag_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3563 (class 2606 OID 5501087)
-- Dependencies: 2674 2674
-- Name: aa_antragsgebiet_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY aa_antragsgebiet
    ADD CONSTRAINT aa_antragsgebiet_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3565 (class 2606 OID 5501106)
-- Dependencies: 2676 2676
-- Name: aa_meilenstein_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY aa_meilenstein
    ADD CONSTRAINT aa_meilenstein_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3567 (class 2606 OID 5501118)
-- Dependencies: 2678 2678
-- Name: aa_projektsteuerung_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY aa_projektsteuerung
    ADD CONSTRAINT aa_projektsteuerung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3569 (class 2606 OID 5501130)
-- Dependencies: 2680 2680
-- Name: aa_vorgang_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY aa_vorgang
    ADD CONSTRAINT aa_vorgang_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3584 (class 2606 OID 5501204)
-- Dependencies: 2694 2694
-- Name: alkis_beziehungen_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY alkis_beziehungen
    ADD CONSTRAINT alkis_beziehungen_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3660 (class 2606 OID 5501505)
-- Dependencies: 2732 2732
-- Name: ap_darstellung_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ap_darstellung
    ADD CONSTRAINT ap_darstellung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3648 (class 2606 OID 5501456)
-- Dependencies: 2726 2726
-- Name: ap_lpo_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ap_lpo
    ADD CONSTRAINT ap_lpo_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3657 (class 2606 OID 5501488)
-- Dependencies: 2730 2730
-- Name: ap_lto_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ap_lto
    ADD CONSTRAINT ap_lto_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3644 (class 2606 OID 5501439)
-- Dependencies: 2724 2724
-- Name: ap_ppo_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ap_ppo
    ADD CONSTRAINT ap_ppo_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3652 (class 2606 OID 5501473)
-- Dependencies: 2728 2728
-- Name: ap_pto_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ap_pto
    ADD CONSTRAINT ap_pto_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3590 (class 2606 OID 5501215)
-- Dependencies: 2696 2696
-- Name: ax_anderefestlegungnachwasserrecht_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_anderefestlegungnachwasserrecht
    ADD CONSTRAINT ax_anderefestlegungnachwasserrecht_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3706 (class 2606 OID 5501681)
-- Dependencies: 2758 2758
-- Name: ax_anschrift_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_anschrift
    ADD CONSTRAINT ax_anschrift_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3685 (class 2606 OID 5501597)
-- Dependencies: 2746 2746
-- Name: ax_aufnahmepunkt_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_aufnahmepunkt
    ADD CONSTRAINT ax_aufnahmepunkt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3786 (class 2606 OID 5502012)
-- Dependencies: 2800 2800
-- Name: ax_bahnverkehr_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_bahnverkehr
    ADD CONSTRAINT ax_bahnverkehr_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3897 (class 2606 OID 5502484)
-- Dependencies: 2856 2856
-- Name: ax_bahnverkehrsanlage_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_bahnverkehrsanlage
    ADD CONSTRAINT ax_bahnverkehrsanlage_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3594 (class 2606 OID 5501232)
-- Dependencies: 2698 2698
-- Name: ax_baublock_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_baublock
    ADD CONSTRAINT ax_baublock_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3955 (class 2606 OID 5502731)
-- Dependencies: 2886 2886
-- Name: ax_bauraumoderbodenordnungsrecht_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_bauraumoderbodenordnungsrecht
    ADD CONSTRAINT ax_bauraumoderbodenordnungsrecht_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3723 (class 2606 OID 5501747)
-- Dependencies: 2768 2768
-- Name: ax_bauteil_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_bauteil
    ADD CONSTRAINT ax_bauteil_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3909 (class 2606 OID 5502532)
-- Dependencies: 2862 2862
-- Name: ax_bauwerkimgewaesserbereich_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_bauwerkimgewaesserbereich
    ADD CONSTRAINT ax_bauwerkimgewaesserbereich_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3885 (class 2606 OID 5502430)
-- Dependencies: 2850 2850
-- Name: ax_bauwerkimverkehrsbereich_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_bauwerkimverkehrsbereich
    ADD CONSTRAINT ax_bauwerkimverkehrsbereich_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3846 (class 2606 OID 5502267)
-- Dependencies: 2830 2830
-- Name: ax_bauwerkoderanlagefuerindustrieundgewerbe_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_bauwerkoderanlagefuerindustrieundgewerbe
    ADD CONSTRAINT ax_bauwerkoderanlagefuerindustrieundgewerbe_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3862 (class 2606 OID 5502335)
-- Dependencies: 2838 2838
-- Name: ax_bauwerkoderanlagefuersportfreizeitunderholung_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_bauwerkoderanlagefuersportfreizeitunderholung
    ADD CONSTRAINT ax_bauwerkoderanlagefuersportfreizeitunderholung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3571 (class 2606 OID 5501142)
-- Dependencies: 2682 2682
-- Name: ax_benutzer_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_benutzer
    ADD CONSTRAINT ax_benutzer_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3573 (class 2606 OID 5501153)
-- Dependencies: 2684 2684
-- Name: ax_benutzergruppemitzugriffskontrolle_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_benutzergruppemitzugriffskontrolle
    ADD CONSTRAINT ax_benutzergruppemitzugriffskontrolle_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3575 (class 2606 OID 5501164)
-- Dependencies: 2686 2686
-- Name: ax_benutzergruppenba_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_benutzergruppenba
    ADD CONSTRAINT ax_benutzergruppenba_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3750 (class 2606 OID 5501859)
-- Dependencies: 2782 2782
-- Name: ax_bergbaubetrieb_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_bergbaubetrieb
    ADD CONSTRAINT ax_bergbaubetrieb_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3668 (class 2606 OID 5501532)
-- Dependencies: 2736 2736
-- Name: ax_besondereflurstuecksgrenze_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_besondereflurstuecksgrenze
    ADD CONSTRAINT ax_besondereflurstuecksgrenze_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3727 (class 2606 OID 5501761)
-- Dependencies: 2770 2770
-- Name: ax_besonderegebaeudelinie_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_besonderegebaeudelinie
    ADD CONSTRAINT ax_besonderegebaeudelinie_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3881 (class 2606 OID 5502420)
-- Dependencies: 2848 2848
-- Name: ax_besondererbauwerkspunkt_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_besondererbauwerkspunkt
    ADD CONSTRAINT ax_besondererbauwerkspunkt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3734 (class 2606 OID 5501798)
-- Dependencies: 2774 2774
-- Name: ax_besonderergebaeudepunkt_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_besonderergebaeudepunkt
    ADD CONSTRAINT ax_besonderergebaeudepunkt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3944 (class 2606 OID 5502681)
-- Dependencies: 2880 2880
-- Name: ax_besondererhoehenpunkt_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_besondererhoehenpunkt
    ADD CONSTRAINT ax_besondererhoehenpunkt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3597 (class 2606 OID 5501249)
-- Dependencies: 2700 2700
-- Name: ax_besonderertopographischerpunkt_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_besonderertopographischerpunkt
    ADD CONSTRAINT ax_besonderertopographischerpunkt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3601 (class 2606 OID 5501259)
-- Dependencies: 2702 2702
-- Name: ax_bewertung_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_bewertung
    ADD CONSTRAINT ax_bewertung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3963 (class 2606 OID 5502765)
-- Dependencies: 2890 2890
-- Name: ax_bodenschaetzung_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_bodenschaetzung
    ADD CONSTRAINT ax_bodenschaetzung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3924 (class 2606 OID 5502604)
-- Dependencies: 2870 2870
-- Name: ax_boeschungkliff_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_boeschungkliff
    ADD CONSTRAINT ax_boeschungkliff_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3928 (class 2606 OID 5502616)
-- Dependencies: 2872 2872
-- Name: ax_boeschungsflaeche_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_boeschungsflaeche
    ADD CONSTRAINT ax_boeschungsflaeche_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3712 (class 2606 OID 5501704)
-- Dependencies: 2762 2762
-- Name: ax_buchungsblatt_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_buchungsblatt
    ADD CONSTRAINT ax_buchungsblatt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3990 (class 2606 OID 5502860)
-- Dependencies: 2906 2906
-- Name: ax_buchungsblattbezirk_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_buchungsblattbezirk
    ADD CONSTRAINT ax_buchungsblattbezirk_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3715 (class 2606 OID 5501717)
-- Dependencies: 2764 2764
-- Name: ax_buchungsstelle_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_buchungsstelle
    ADD CONSTRAINT ax_buchungsstelle_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3970 (class 2606 OID 5502799)
-- Dependencies: 2894 2894
-- Name: ax_bundesland_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_bundesland
    ADD CONSTRAINT ax_bundesland_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3932 (class 2606 OID 5502630)
-- Dependencies: 2874 2874
-- Name: ax_dammwalldeich_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_dammwalldeich
    ADD CONSTRAINT ax_dammwalldeich_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3605 (class 2606 OID 5501276)
-- Dependencies: 2704 2704
-- Name: ax_denkmalschutzrecht_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_denkmalschutzrecht
    ADD CONSTRAINT ax_denkmalschutzrecht_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3993 (class 2606 OID 5502871)
-- Dependencies: 2908 2908
-- Name: ax_dienststelle_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_dienststelle
    ADD CONSTRAINT ax_dienststelle_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3878 (class 2606 OID 5502403)
-- Dependencies: 2846 2846
-- Name: ax_einrichtunginoeffentlichenbereichen_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_einrichtunginoeffentlichenbereichen
    ADD CONSTRAINT ax_einrichtunginoeffentlichenbereichen_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3936 (class 2606 OID 5502647)
-- Dependencies: 2876 2876
-- Name: ax_felsenfelsblockfelsnadel_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_felsenfelsblockfelsnadel
    ADD CONSTRAINT ax_felsenfelsblockfelsnadel_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3731 (class 2606 OID 5501778)
-- Dependencies: 2772 2772
-- Name: ax_firstlinie_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_firstlinie
    ADD CONSTRAINT ax_firstlinie_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3762 (class 2606 OID 5501910)
-- Dependencies: 2788 2788
-- Name: ax_flaechebesondererfunktionalerpraegung_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_flaechebesondererfunktionalerpraegung
    ADD CONSTRAINT ax_flaechebesondererfunktionalerpraegung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3758 (class 2606 OID 5501893)
-- Dependencies: 2786 2786
-- Name: ax_flaechegemischternutzung_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_flaechegemischternutzung
    ADD CONSTRAINT ax_flaechegemischternutzung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3826 (class 2606 OID 5502182)
-- Dependencies: 2820 2820
-- Name: ax_fliessgewaesser_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_fliessgewaesser
    ADD CONSTRAINT ax_fliessgewaesser_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3790 (class 2606 OID 5502029)
-- Dependencies: 2802 2802
-- Name: ax_flugverkehr_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_flugverkehr
    ADD CONSTRAINT ax_flugverkehr_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3905 (class 2606 OID 5502515)
-- Dependencies: 2860 2860
-- Name: ax_flugverkehrsanlage_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_flugverkehrsanlage
    ADD CONSTRAINT ax_flugverkehrsanlage_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3664 (class 2606 OID 5501515)
-- Dependencies: 2734 2734
-- Name: ax_flurstueck_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_flurstueck
    ADD CONSTRAINT ax_flurstueck_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3770 (class 2606 OID 5501944)
-- Dependencies: 2792 2792
-- Name: ax_friedhof_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_friedhof
    ADD CONSTRAINT ax_friedhof_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3719 (class 2606 OID 5501727)
-- Dependencies: 2766 2766
-- Name: ax_gebaeude_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_gebaeude
    ADD CONSTRAINT ax_gebaeude_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3609 (class 2606 OID 5501296)
-- Dependencies: 2706 2706
-- Name: ax_gebaeudeausgestaltung_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_gebaeudeausgestaltung
    ADD CONSTRAINT ax_gebaeudeausgestaltung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3806 (class 2606 OID 5502097)
-- Dependencies: 2810 2810
-- Name: ax_gehoelz_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_gehoelz
    ADD CONSTRAINT ax_gehoelz_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3940 (class 2606 OID 5502667)
-- Dependencies: 2878 2878
-- Name: ax_gelaendekante_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_gelaendekante
    ADD CONSTRAINT ax_gelaendekante_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3983 (class 2606 OID 5502839)
-- Dependencies: 2902 2902
-- Name: ax_gemarkung_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_gemarkung
    ADD CONSTRAINT ax_gemarkung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3986 (class 2606 OID 5502850)
-- Dependencies: 2904 2904
-- Name: ax_gemarkungsteilflur_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_gemarkungsteilflur
    ADD CONSTRAINT ax_gemarkungsteilflur_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3979 (class 2606 OID 5502829)
-- Dependencies: 2900 2900
-- Name: ax_gemeinde_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_gemeinde
    ADD CONSTRAINT ax_gemeinde_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3614 (class 2606 OID 5501310)
-- Dependencies: 2708 2708
-- Name: ax_georeferenziertegebaeudeadresse_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_georeferenziertegebaeudeadresse
    ADD CONSTRAINT ax_georeferenziertegebaeudeadresse_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3917 (class 2606 OID 5502566)
-- Dependencies: 2866 2866
-- Name: ax_gewaessermerkmal_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_gewaessermerkmal
    ADD CONSTRAINT ax_gewaessermerkmal_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3901 (class 2606 OID 5502501)
-- Dependencies: 2858 2858
-- Name: ax_gleis_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_gleis
    ADD CONSTRAINT ax_gleis_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3618 (class 2606 OID 5501328)
-- Dependencies: 2710 2710
-- Name: ax_grablochderbodenschaetzung_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_grablochderbodenschaetzung
    ADD CONSTRAINT ax_grablochderbodenschaetzung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3671 (class 2606 OID 5501552)
-- Dependencies: 2738 2738
-- Name: ax_grenzpunkt_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_grenzpunkt
    ADD CONSTRAINT ax_grenzpunkt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3830 (class 2606 OID 5502199)
-- Dependencies: 2822 2822
-- Name: ax_hafenbecken_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_hafenbecken
    ADD CONSTRAINT ax_hafenbecken_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3746 (class 2606 OID 5501842)
-- Dependencies: 2780 2780
-- Name: ax_halde_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_halde
    ADD CONSTRAINT ax_halde_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3810 (class 2606 OID 5502114)
-- Dependencies: 2812 2812
-- Name: ax_heide_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_heide
    ADD CONSTRAINT ax_heide_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3870 (class 2606 OID 5502369)
-- Dependencies: 2842 2842
-- Name: ax_heilquellegasquelle_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_heilquellegasquelle
    ADD CONSTRAINT ax_heilquellegasquelle_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3866 (class 2606 OID 5502355)
-- Dependencies: 2840 2840
-- Name: ax_historischesbauwerkoderhistorischeeinrichtung_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_historischesbauwerkoderhistorischeeinrichtung
    ADD CONSTRAINT ax_historischesbauwerkoderhistorischeeinrichtung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3625 (class 2606 OID 5501361)
-- Dependencies: 2714 2714
-- Name: ax_historischesflurstueck_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_historischesflurstueck
    ADD CONSTRAINT ax_historischesflurstueck_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3621 (class 2606 OID 5501348)
-- Dependencies: 2712 2712
-- Name: ax_historischesflurstueckalb_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_historischesflurstueckalb
    ADD CONSTRAINT ax_historischesflurstueckalb_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3742 (class 2606 OID 5501825)
-- Dependencies: 2778 2778
-- Name: ax_industrieundgewerbeflaeche_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_industrieundgewerbeflaeche
    ADD CONSTRAINT ax_industrieundgewerbeflaeche_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3948 (class 2606 OID 5502698)
-- Dependencies: 2882 2882
-- Name: ax_klassifizierungnachstrassenrecht_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_klassifizierungnachstrassenrecht
    ADD CONSTRAINT ax_klassifizierungnachstrassenrecht_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3951 (class 2606 OID 5502715)
-- Dependencies: 2884 2884
-- Name: ax_klassifizierungnachwasserrecht_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_klassifizierungnachwasserrecht
    ADD CONSTRAINT ax_klassifizierungnachwasserrecht_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 4003 (class 2606 OID 5502901)
-- Dependencies: 2912 2912
-- Name: ax_kleinraeumigerlandschaftsteil_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_kleinraeumigerlandschaftsteil
    ADD CONSTRAINT ax_kleinraeumigerlandschaftsteil_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 4011 (class 2606 OID 5502928)
-- Dependencies: 2916 2916
-- Name: ax_kommunalesgebiet_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_kommunalesgebiet
    ADD CONSTRAINT ax_kommunalesgebiet_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3976 (class 2606 OID 5502819)
-- Dependencies: 2898 2898
-- Name: ax_kreisregion_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_kreisregion
    ADD CONSTRAINT ax_kreisregion_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3999 (class 2606 OID 5502881)
-- Dependencies: 2910 2910
-- Name: ax_lagebezeichnungkatalogeintrag_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_lagebezeichnungkatalogeintrag
    ADD CONSTRAINT ax_lagebezeichnungkatalogeintrag_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3679 (class 2606 OID 5501573)
-- Dependencies: 2742 2742
-- Name: ax_lagebezeichnungmithausnummer_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_lagebezeichnungmithausnummer
    ADD CONSTRAINT ax_lagebezeichnungmithausnummer_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3682 (class 2606 OID 5501584)
-- Dependencies: 2744 2744
-- Name: ax_lagebezeichnungmitpseudonummer_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_lagebezeichnungmitpseudonummer
    ADD CONSTRAINT ax_lagebezeichnungmitpseudonummer_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3675 (class 2606 OID 5501562)
-- Dependencies: 2740 2740
-- Name: ax_lagebezeichnungohnehausnummer_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_lagebezeichnungohnehausnummer
    ADD CONSTRAINT ax_lagebezeichnungohnehausnummer_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3798 (class 2606 OID 5502063)
-- Dependencies: 2806 2806
-- Name: ax_landwirtschaft_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_landwirtschaft
    ADD CONSTRAINT ax_landwirtschaft_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3858 (class 2606 OID 5502318)
-- Dependencies: 2836 2836
-- Name: ax_leitung_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_leitung
    ADD CONSTRAINT ax_leitung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3838 (class 2606 OID 5502233)
-- Dependencies: 2826 2826
-- Name: ax_meer_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_meer
    ADD CONSTRAINT ax_meer_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3814 (class 2606 OID 5502131)
-- Dependencies: 2814 2814
-- Name: ax_moor_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_moor
    ADD CONSTRAINT ax_moor_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3967 (class 2606 OID 5502782)
-- Dependencies: 2892 2892
-- Name: ax_musterlandesmusterundvergleichsstueck_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_musterlandesmusterundvergleichsstueck
    ADD CONSTRAINT ax_musterlandesmusterundvergleichsstueck_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3709 (class 2606 OID 5501694)
-- Dependencies: 2760 2760
-- Name: ax_namensnummer_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_namensnummer
    ADD CONSTRAINT ax_namensnummer_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3629 (class 2606 OID 5501375)
-- Dependencies: 2716 2716
-- Name: ax_naturumweltoderbodenschutzrecht_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_naturumweltoderbodenschutzrecht
    ADD CONSTRAINT ax_naturumweltoderbodenschutzrecht_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3702 (class 2606 OID 5501671)
-- Dependencies: 2756 2756
-- Name: ax_person_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_person
    ADD CONSTRAINT ax_person_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3782 (class 2606 OID 5501995)
-- Dependencies: 2798 2798
-- Name: ax_platz_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_platz
    ADD CONSTRAINT ax_platz_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3577 (class 2606 OID 5501172)
-- Dependencies: 2688 2688
-- Name: ax_punktkennunguntergegangen_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_punktkennunguntergegangen
    ADD CONSTRAINT ax_punktkennunguntergegangen_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3692 (class 2606 OID 5501623)
-- Dependencies: 2750 2750
-- Name: ax_punktortag_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_punktortag
    ADD CONSTRAINT ax_punktortag_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3696 (class 2606 OID 5501637)
-- Dependencies: 2752 2752
-- Name: ax_punktortau_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_punktortau
    ADD CONSTRAINT ax_punktortau_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3700 (class 2606 OID 5501657)
-- Dependencies: 2754 2754
-- Name: ax_punktortta_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_punktortta
    ADD CONSTRAINT ax_punktortta_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3973 (class 2606 OID 5502809)
-- Dependencies: 2896 2896
-- Name: ax_regierungsbezirk_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_regierungsbezirk
    ADD CONSTRAINT ax_regierungsbezirk_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3579 (class 2606 OID 5501180)
-- Dependencies: 2690 2690
-- Name: ax_reservierung_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_reservierung
    ADD CONSTRAINT ax_reservierung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3794 (class 2606 OID 5502046)
-- Dependencies: 2804 2804
-- Name: ax_schiffsverkehr_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_schiffsverkehr
    ADD CONSTRAINT ax_schiffsverkehr_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3632 (class 2606 OID 5501392)
-- Dependencies: 2718 2718
-- Name: ax_schutzgebietnachwasserrecht_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_schutzgebietnachwasserrecht
    ADD CONSTRAINT ax_schutzgebietnachwasserrecht_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3636 (class 2606 OID 5501402)
-- Dependencies: 2720 2720
-- Name: ax_schutzzone_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_schutzzone
    ADD CONSTRAINT ax_schutzzone_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3688 (class 2606 OID 5501610)
-- Dependencies: 2748 2748
-- Name: ax_sonstigervermessungspunkt_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_sonstigervermessungspunkt
    ADD CONSTRAINT ax_sonstigervermessungspunkt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3874 (class 2606 OID 5502386)
-- Dependencies: 2844 2844
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_sonstigesbauwerkodersonstigeeinrichtung
    ADD CONSTRAINT ax_sonstigesbauwerkodersonstigeeinrichtung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3959 (class 2606 OID 5502748)
-- Dependencies: 2888 2888
-- Name: ax_sonstigesrecht_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_sonstigesrecht
    ADD CONSTRAINT ax_sonstigesrecht_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3766 (class 2606 OID 5501927)
-- Dependencies: 2790 2790
-- Name: ax_sportfreizeitunderholungsflaeche_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_sportfreizeitunderholungsflaeche
    ADD CONSTRAINT ax_sportfreizeitunderholungsflaeche_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3834 (class 2606 OID 5502216)
-- Dependencies: 2824 2824
-- Name: ax_stehendesgewaesser_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_stehendesgewaesser
    ADD CONSTRAINT ax_stehendesgewaesser_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3774 (class 2606 OID 5501961)
-- Dependencies: 2794 2794
-- Name: ax_strassenverkehr_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_strassenverkehr
    ADD CONSTRAINT ax_strassenverkehr_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3889 (class 2606 OID 5502454)
-- Dependencies: 2852 2852
-- Name: ax_strassenverkehrsanlage_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_strassenverkehrsanlage
    ADD CONSTRAINT ax_strassenverkehrsanlage_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3818 (class 2606 OID 5502148)
-- Dependencies: 2816 2816
-- Name: ax_sumpf_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_sumpf
    ADD CONSTRAINT ax_sumpf_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3753 (class 2606 OID 5501876)
-- Dependencies: 2784 2784
-- Name: ax_tagebaugrubesteinbruch_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_tagebaugrubesteinbruch
    ADD CONSTRAINT ax_tagebaugrubesteinbruch_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3640 (class 2606 OID 5501419)
-- Dependencies: 2722 2722
-- Name: ax_topographischelinie_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_topographischelinie
    ADD CONSTRAINT ax_topographischelinie_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3854 (class 2606 OID 5502301)
-- Dependencies: 2834 2834
-- Name: ax_transportanlage_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_transportanlage
    ADD CONSTRAINT ax_transportanlage_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3842 (class 2606 OID 5502250)
-- Dependencies: 2828 2828
-- Name: ax_turm_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_turm
    ADD CONSTRAINT ax_turm_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3822 (class 2606 OID 5502165)
-- Dependencies: 2818 2818
-- Name: ax_unlandvegetationsloseflaeche_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_unlandvegetationsloseflaeche
    ADD CONSTRAINT ax_unlandvegetationsloseflaeche_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3921 (class 2606 OID 5502583)
-- Dependencies: 2868 2868
-- Name: ax_untergeordnetesgewaesser_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_untergeordnetesgewaesser
    ADD CONSTRAINT ax_untergeordnetesgewaesser_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3913 (class 2606 OID 5502549)
-- Dependencies: 2864 2864
-- Name: ax_vegetationsmerkmal_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_vegetationsmerkmal
    ADD CONSTRAINT ax_vegetationsmerkmal_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3850 (class 2606 OID 5502284)
-- Dependencies: 2832 2832
-- Name: ax_vorratsbehaelterspeicherbauwerk_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_vorratsbehaelterspeicherbauwerk
    ADD CONSTRAINT ax_vorratsbehaelterspeicherbauwerk_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3802 (class 2606 OID 5502080)
-- Dependencies: 2808 2808
-- Name: ax_wald_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_wald
    ADD CONSTRAINT ax_wald_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3778 (class 2606 OID 5501978)
-- Dependencies: 2796 2796
-- Name: ax_weg_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_weg
    ADD CONSTRAINT ax_weg_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3893 (class 2606 OID 5502467)
-- Dependencies: 2854 2854
-- Name: ax_wegpfadsteig_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_wegpfadsteig
    ADD CONSTRAINT ax_wegpfadsteig_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3738 (class 2606 OID 5501808)
-- Dependencies: 2776 2776
-- Name: ax_wohnbauflaeche_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_wohnbauflaeche
    ADD CONSTRAINT ax_wohnbauflaeche_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 4007 (class 2606 OID 5502911)
-- Dependencies: 2914 2914
-- Name: ax_wohnplatz_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ax_wohnplatz
    ADD CONSTRAINT ax_wohnplatz_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3556 (class 2606 OID 16791)
-- Dependencies: 2668 2668 2668 2668 2668
-- Name: geometry_columns_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY geometry_columns
    ADD CONSTRAINT geometry_columns_pk PRIMARY KEY (f_table_catalog, f_table_schema, f_table_name, f_geometry_column);


--
-- TOC entry 3582 (class 2606 OID 5501188)
-- Dependencies: 2692 2692
-- Name: ks_sonstigesbauwerk_pk; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ks_sonstigesbauwerk
    ADD CONSTRAINT ks_sonstigesbauwerk_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3554 (class 2606 OID 16783)
-- Dependencies: 2667 2667
-- Name: spatial_ref_sys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY spatial_ref_sys
    ADD CONSTRAINT spatial_ref_sys_pkey PRIMARY KEY (srid);


--
-- TOC entry 3561 (class 1259 OID 5501095)
-- Dependencies: 2306 2674
-- Name: aa_antragsgebiet_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX aa_antragsgebiet_geom_idx ON aa_antragsgebiet USING gist (wkb_geometry);


--
-- TOC entry 3658 (class 1259 OID 5501507)
-- Dependencies: 2732
-- Name: ap_darstellung_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ap_darstellung_gml ON ap_darstellung USING btree (gml_id);


--
-- TOC entry 3645 (class 1259 OID 5501461)
-- Dependencies: 2306 2726
-- Name: ap_lpo_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_lpo_geom_idx ON ap_lpo USING gist (wkb_geometry);


--
-- TOC entry 3646 (class 1259 OID 5501462)
-- Dependencies: 2726
-- Name: ap_lpo_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ap_lpo_gml ON ap_lpo USING btree (gml_id);


--
-- TOC entry 3654 (class 1259 OID 5501496)
-- Dependencies: 2306 2730
-- Name: ap_lto_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_lto_geom_idx ON ap_lto USING gist (wkb_geometry);


--
-- TOC entry 3655 (class 1259 OID 5501497)
-- Dependencies: 2730
-- Name: ap_lto_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_lto_gml ON ap_lto USING btree (gml_id);


--
-- TOC entry 3641 (class 1259 OID 5501444)
-- Dependencies: 2724 2306
-- Name: ap_ppo_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_ppo_geom_idx ON ap_ppo USING gist (wkb_geometry);


--
-- TOC entry 3642 (class 1259 OID 5501445)
-- Dependencies: 2724
-- Name: ap_ppo_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_ppo_gml ON ap_ppo USING btree (gml_id);


--
-- TOC entry 3649 (class 1259 OID 5501478)
-- Dependencies: 2306 2728
-- Name: ap_pto_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_pto_geom_idx ON ap_pto USING gist (wkb_geometry);


--
-- TOC entry 3650 (class 1259 OID 5501479)
-- Dependencies: 2728
-- Name: ap_pto_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ap_pto_gml ON ap_pto USING btree (gml_id);


--
-- TOC entry 3653 (class 1259 OID 5501480)
-- Dependencies: 2728
-- Name: art_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX art_idx ON ap_pto USING btree (art);


--
-- TOC entry 4462 (class 0 OID 0)
-- Dependencies: 3653
-- Name: INDEX art_idx; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX art_idx IS 'Suchindex auf häufig benutztem Filterkriterium';


--
-- TOC entry 3587 (class 1259 OID 5501223)
-- Dependencies: 2696 2306
-- Name: ax_anderefestlegungnachwasserrecht_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_anderefestlegungnachwasserrecht_geom_idx ON ax_anderefestlegungnachwasserrecht USING gist (wkb_geometry);


--
-- TOC entry 3588 (class 1259 OID 5501224)
-- Dependencies: 2696
-- Name: ax_anderefestlegungnachwasserrecht_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_anderefestlegungnachwasserrecht_gml ON ax_anderefestlegungnachwasserrecht USING btree (gml_id);


--
-- TOC entry 3704 (class 1259 OID 5501683)
-- Dependencies: 2758
-- Name: ax_anschrift_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_anschrift_gml ON ax_anschrift USING btree (gml_id);


--
-- TOC entry 3683 (class 1259 OID 5501599)
-- Dependencies: 2746
-- Name: ax_aufnahmepunkt_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_aufnahmepunkt_gml ON ax_aufnahmepunkt USING btree (gml_id);


--
-- TOC entry 3783 (class 1259 OID 5502020)
-- Dependencies: 2800 2306
-- Name: ax_bahnverkehr_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_bahnverkehr_geom_idx ON ax_bahnverkehr USING gist (wkb_geometry);


--
-- TOC entry 3784 (class 1259 OID 5502021)
-- Dependencies: 2800
-- Name: ax_bahnverkehr_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_bahnverkehr_gml ON ax_bahnverkehr USING btree (gml_id);


--
-- TOC entry 3894 (class 1259 OID 5502489)
-- Dependencies: 2856 2306
-- Name: ax_bahnverkehrsanlage_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_bahnverkehrsanlage_geom_idx ON ax_bahnverkehrsanlage USING gist (wkb_geometry);


--
-- TOC entry 3895 (class 1259 OID 5502490)
-- Dependencies: 2856
-- Name: ax_bahnverkehrsanlage_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_bahnverkehrsanlage_gml ON ax_bahnverkehrsanlage USING btree (gml_id);


--
-- TOC entry 3591 (class 1259 OID 5501240)
-- Dependencies: 2306 2698
-- Name: ax_baublock_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_baublock_geom_idx ON ax_baublock USING gist (wkb_geometry);


--
-- TOC entry 3592 (class 1259 OID 5501241)
-- Dependencies: 2698
-- Name: ax_baublock_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_baublock_gml ON ax_baublock USING btree (gml_id);


--
-- TOC entry 3952 (class 1259 OID 5502739)
-- Dependencies: 2306 2886
-- Name: ax_bauraumoderbodenordnungsrecht_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_bauraumoderbodenordnungsrecht_geom_idx ON ax_bauraumoderbodenordnungsrecht USING gist (wkb_geometry);


--
-- TOC entry 3953 (class 1259 OID 5502740)
-- Dependencies: 2886
-- Name: ax_bauraumoderbodenordnungsrecht_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_bauraumoderbodenordnungsrecht_gml ON ax_bauraumoderbodenordnungsrecht USING btree (gml_id);


--
-- TOC entry 3720 (class 1259 OID 5501752)
-- Dependencies: 2768 2306
-- Name: ax_bauteil_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_bauteil_geom_idx ON ax_bauteil USING gist (wkb_geometry);


--
-- TOC entry 3721 (class 1259 OID 5501753)
-- Dependencies: 2768
-- Name: ax_bauteil_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_bauteil_gml ON ax_bauteil USING btree (gml_id);


--
-- TOC entry 3906 (class 1259 OID 5502540)
-- Dependencies: 2306 2862
-- Name: ax_bauwerkimgewaesserbereich_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_bauwerkimgewaesserbereich_geom_idx ON ax_bauwerkimgewaesserbereich USING gist (wkb_geometry);


--
-- TOC entry 3907 (class 1259 OID 5502541)
-- Dependencies: 2862
-- Name: ax_bauwerkimgewaesserbereich_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_bauwerkimgewaesserbereich_gml ON ax_bauwerkimgewaesserbereich USING btree (gml_id);


--
-- TOC entry 3882 (class 1259 OID 5502438)
-- Dependencies: 2850 2306
-- Name: ax_bauwerkimverkehrsbereich_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_bauwerkimverkehrsbereich_geom_idx ON ax_bauwerkimverkehrsbereich USING gist (wkb_geometry);


--
-- TOC entry 3883 (class 1259 OID 5502439)
-- Dependencies: 2850
-- Name: ax_bauwerkimverkehrsbereich_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_bauwerkimverkehrsbereich_gml ON ax_bauwerkimverkehrsbereich USING btree (gml_id);


--
-- TOC entry 3843 (class 1259 OID 5502275)
-- Dependencies: 2830 2306
-- Name: ax_bauwerkoderanlagefuerindustrieundgewerbe_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_bauwerkoderanlagefuerindustrieundgewerbe_geom_idx ON ax_bauwerkoderanlagefuerindustrieundgewerbe USING gist (wkb_geometry);


--
-- TOC entry 3844 (class 1259 OID 5502276)
-- Dependencies: 2830
-- Name: ax_bauwerkoderanlagefuerindustrieundgewerbe_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_bauwerkoderanlagefuerindustrieundgewerbe_gml ON ax_bauwerkoderanlagefuerindustrieundgewerbe USING btree (gml_id);


--
-- TOC entry 3859 (class 1259 OID 5502343)
-- Dependencies: 2306 2838
-- Name: ax_bauwerkoderanlagefuersportfreizeitunderholung_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_bauwerkoderanlagefuersportfreizeitunderholung_geom_idx ON ax_bauwerkoderanlagefuersportfreizeitunderholung USING gist (wkb_geometry);


--
-- TOC entry 3860 (class 1259 OID 5502344)
-- Dependencies: 2838
-- Name: ax_bauwerkoderanlagefuersportfreizeitunderholung_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_bauwerkoderanlagefuersportfreizeitunderholung_gml ON ax_bauwerkoderanlagefuersportfreizeitunderholung USING btree (gml_id);


--
-- TOC entry 3747 (class 1259 OID 5501867)
-- Dependencies: 2782 2306
-- Name: ax_bergbaubetrieb_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_bergbaubetrieb_geom_idx ON ax_bergbaubetrieb USING gist (wkb_geometry);


--
-- TOC entry 3748 (class 1259 OID 5501868)
-- Dependencies: 2782
-- Name: ax_bergbaubetrieb_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_bergbaubetrieb_gml ON ax_bergbaubetrieb USING btree (gml_id);


--
-- TOC entry 3665 (class 1259 OID 5501540)
-- Dependencies: 2736 2306
-- Name: ax_besondereflurstuecksgrenze_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_besondereflurstuecksgrenze_geom_idx ON ax_besondereflurstuecksgrenze USING gist (wkb_geometry);


--
-- TOC entry 3666 (class 1259 OID 5501541)
-- Dependencies: 2736
-- Name: ax_besondereflurstuecksgrenze_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_besondereflurstuecksgrenze_gml ON ax_besondereflurstuecksgrenze USING btree (gml_id);


--
-- TOC entry 3724 (class 1259 OID 5501769)
-- Dependencies: 2306 2770
-- Name: ax_besonderegebaeudelinie_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_besonderegebaeudelinie_geom_idx ON ax_besonderegebaeudelinie USING gist (wkb_geometry);


--
-- TOC entry 3725 (class 1259 OID 5501770)
-- Dependencies: 2770
-- Name: ax_besonderegebaeudelinie_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_besonderegebaeudelinie_gml ON ax_besonderegebaeudelinie USING btree (gml_id);


--
-- TOC entry 3879 (class 1259 OID 5502422)
-- Dependencies: 2848
-- Name: ax_besondererbauwerkspunkt_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_besondererbauwerkspunkt_gml ON ax_besondererbauwerkspunkt USING btree (gml_id);


--
-- TOC entry 3732 (class 1259 OID 5501800)
-- Dependencies: 2774
-- Name: ax_besonderergebaeudepunkt_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_besonderergebaeudepunkt_gml ON ax_besonderergebaeudepunkt USING btree (gml_id);


--
-- TOC entry 3941 (class 1259 OID 5502689)
-- Dependencies: 2880 2306
-- Name: ax_besondererhoehenpunkt_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_besondererhoehenpunkt_geom_idx ON ax_besondererhoehenpunkt USING gist (wkb_geometry);


--
-- TOC entry 3942 (class 1259 OID 5502690)
-- Dependencies: 2880
-- Name: ax_besondererhoehenpunkt_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_besondererhoehenpunkt_gml ON ax_besondererhoehenpunkt USING btree (gml_id);


--
-- TOC entry 3595 (class 1259 OID 5501251)
-- Dependencies: 2700
-- Name: ax_besonderertopographischerpunkt_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_besonderertopographischerpunkt_gml ON ax_besonderertopographischerpunkt USING btree (gml_id);


--
-- TOC entry 3598 (class 1259 OID 5501267)
-- Dependencies: 2306 2702
-- Name: ax_bewertung_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_bewertung_geom_idx ON ax_bewertung USING gist (wkb_geometry);


--
-- TOC entry 3599 (class 1259 OID 5501268)
-- Dependencies: 2702
-- Name: ax_bewertung_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_bewertung_gml ON ax_bewertung USING btree (gml_id);


--
-- TOC entry 3960 (class 1259 OID 5502773)
-- Dependencies: 2306 2890
-- Name: ax_bodenschaetzung_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_bodenschaetzung_geom_idx ON ax_bodenschaetzung USING gist (wkb_geometry);


--
-- TOC entry 3961 (class 1259 OID 5502774)
-- Dependencies: 2890
-- Name: ax_bodenschaetzung_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_bodenschaetzung_gml ON ax_bodenschaetzung USING btree (gml_id);


--
-- TOC entry 3922 (class 1259 OID 5502605)
-- Dependencies: 2870
-- Name: ax_boeschungkliff_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_boeschungkliff_gml ON ax_boeschungkliff USING btree (gml_id);


--
-- TOC entry 3925 (class 1259 OID 5502621)
-- Dependencies: 2872 2306
-- Name: ax_boeschungsflaeche_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_boeschungsflaeche_geom_idx ON ax_boeschungsflaeche USING gist (wkb_geometry);


--
-- TOC entry 3926 (class 1259 OID 5502622)
-- Dependencies: 2872
-- Name: ax_boeschungsflaeche_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_boeschungsflaeche_gml ON ax_boeschungsflaeche USING btree (gml_id);


--
-- TOC entry 3710 (class 1259 OID 5501706)
-- Dependencies: 2762
-- Name: ax_buchungsblatt_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_buchungsblatt_gml ON ax_buchungsblatt USING btree (gml_id);


--
-- TOC entry 3987 (class 1259 OID 5502863)
-- Dependencies: 2906 2906
-- Name: ax_buchungsblattbez_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_buchungsblattbez_key ON ax_buchungsblattbezirk USING btree (land, bezirk);


--
-- TOC entry 3988 (class 1259 OID 5502862)
-- Dependencies: 2906
-- Name: ax_buchungsblattbezirk_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_buchungsblattbezirk_gml ON ax_buchungsblattbezirk USING btree (gml_id);


--
-- TOC entry 3713 (class 1259 OID 5501719)
-- Dependencies: 2764
-- Name: ax_buchungsstelle_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_buchungsstelle_gml ON ax_buchungsstelle USING btree (gml_id);


--
-- TOC entry 3968 (class 1259 OID 5502801)
-- Dependencies: 2894
-- Name: ax_bundesland_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_bundesland_gml ON ax_bundesland USING btree (gml_id);


--
-- TOC entry 3929 (class 1259 OID 5502638)
-- Dependencies: 2874 2306
-- Name: ax_dammwalldeich_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_dammwalldeich_geom_idx ON ax_dammwalldeich USING gist (wkb_geometry);


--
-- TOC entry 3930 (class 1259 OID 5502639)
-- Dependencies: 2874
-- Name: ax_dammwalldeich_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_dammwalldeich_gml ON ax_dammwalldeich USING btree (gml_id);


--
-- TOC entry 3602 (class 1259 OID 5501284)
-- Dependencies: 2704 2306
-- Name: ax_denkmalschutzrecht_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_denkmalschutzrecht_geom_idx ON ax_denkmalschutzrecht USING gist (wkb_geometry);


--
-- TOC entry 3603 (class 1259 OID 5501285)
-- Dependencies: 2704
-- Name: ax_denkmalschutzrecht_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_denkmalschutzrecht_gml ON ax_denkmalschutzrecht USING btree (gml_id);


--
-- TOC entry 3991 (class 1259 OID 5502873)
-- Dependencies: 2908
-- Name: ax_dienststelle_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_dienststelle_gml ON ax_dienststelle USING btree (gml_id);


--
-- TOC entry 3875 (class 1259 OID 5502411)
-- Dependencies: 2846 2306
-- Name: ax_einrichtunginoeffentlichenbereichen_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_einrichtunginoeffentlichenbereichen_geom_idx ON ax_einrichtunginoeffentlichenbereichen USING gist (wkb_geometry);


--
-- TOC entry 3876 (class 1259 OID 5502412)
-- Dependencies: 2846
-- Name: ax_einrichtunginoeffentlichenbereichen_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_einrichtunginoeffentlichenbereichen_gml ON ax_einrichtunginoeffentlichenbereichen USING btree (gml_id);


--
-- TOC entry 3933 (class 1259 OID 5502655)
-- Dependencies: 2306 2876
-- Name: ax_felsenfelsblockfelsnadel_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_felsenfelsblockfelsnadel_geom_idx ON ax_felsenfelsblockfelsnadel USING gist (wkb_geometry);


--
-- TOC entry 3934 (class 1259 OID 5502656)
-- Dependencies: 2876
-- Name: ax_felsenfelsblockfelsnadel_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_felsenfelsblockfelsnadel_gml ON ax_felsenfelsblockfelsnadel USING btree (gml_id);


--
-- TOC entry 3728 (class 1259 OID 5501786)
-- Dependencies: 2306 2772
-- Name: ax_firstlinie_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_firstlinie_geom_idx ON ax_firstlinie USING gist (wkb_geometry);


--
-- TOC entry 3729 (class 1259 OID 5501787)
-- Dependencies: 2772
-- Name: ax_firstlinie_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_firstlinie_gml ON ax_firstlinie USING btree (gml_id);


--
-- TOC entry 3759 (class 1259 OID 5501918)
-- Dependencies: 2788 2306
-- Name: ax_flaechebesondererfunktionalerpraegung_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_flaechebesondererfunktionalerpraegung_geom_idx ON ax_flaechebesondererfunktionalerpraegung USING gist (wkb_geometry);


--
-- TOC entry 3760 (class 1259 OID 5501919)
-- Dependencies: 2788
-- Name: ax_flaechebesondererfunktionalerpraegung_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_flaechebesondererfunktionalerpraegung_gml ON ax_flaechebesondererfunktionalerpraegung USING btree (gml_id);


--
-- TOC entry 3755 (class 1259 OID 5501901)
-- Dependencies: 2306 2786
-- Name: ax_flaechegemischternutzung_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_flaechegemischternutzung_geom_idx ON ax_flaechegemischternutzung USING gist (wkb_geometry);


--
-- TOC entry 3756 (class 1259 OID 5501902)
-- Dependencies: 2786
-- Name: ax_flaechegemischternutzung_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_flaechegemischternutzung_gml ON ax_flaechegemischternutzung USING btree (gml_id);


--
-- TOC entry 3823 (class 1259 OID 5502190)
-- Dependencies: 2820 2306
-- Name: ax_fliessgewaesser_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_fliessgewaesser_geom_idx ON ax_fliessgewaesser USING gist (wkb_geometry);


--
-- TOC entry 3824 (class 1259 OID 5502191)
-- Dependencies: 2820
-- Name: ax_fliessgewaesser_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_fliessgewaesser_gml ON ax_fliessgewaesser USING btree (gml_id);


--
-- TOC entry 3787 (class 1259 OID 5502037)
-- Dependencies: 2306 2802
-- Name: ax_flugverkehr_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_flugverkehr_geom_idx ON ax_flugverkehr USING gist (wkb_geometry);


--
-- TOC entry 3788 (class 1259 OID 5502038)
-- Dependencies: 2802
-- Name: ax_flugverkehr_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_flugverkehr_gml ON ax_flugverkehr USING btree (gml_id);


--
-- TOC entry 3902 (class 1259 OID 5502523)
-- Dependencies: 2306 2860
-- Name: ax_flugverkehrsanlage_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_flugverkehrsanlage_geom_idx ON ax_flugverkehrsanlage USING gist (wkb_geometry);


--
-- TOC entry 3903 (class 1259 OID 5502524)
-- Dependencies: 2860
-- Name: ax_flugverkehrsanlage_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_flugverkehrsanlage_gml ON ax_flugverkehrsanlage USING btree (gml_id);


--
-- TOC entry 3661 (class 1259 OID 5501523)
-- Dependencies: 2734 2306
-- Name: ax_flurstueck_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_flurstueck_geom_idx ON ax_flurstueck USING gist (wkb_geometry);


--
-- TOC entry 3662 (class 1259 OID 5501524)
-- Dependencies: 2734
-- Name: ax_flurstueck_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_flurstueck_gml ON ax_flurstueck USING btree (gml_id);


--
-- TOC entry 3767 (class 1259 OID 5501952)
-- Dependencies: 2792 2306
-- Name: ax_friedhof_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_friedhof_geom_idx ON ax_friedhof USING gist (wkb_geometry);


--
-- TOC entry 3768 (class 1259 OID 5501953)
-- Dependencies: 2792
-- Name: ax_friedhof_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_friedhof_gml ON ax_friedhof USING btree (gml_id);


--
-- TOC entry 3716 (class 1259 OID 5501735)
-- Dependencies: 2306 2766
-- Name: ax_gebaeude_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_gebaeude_geom_idx ON ax_gebaeude USING gist (wkb_geometry);


--
-- TOC entry 3717 (class 1259 OID 5501736)
-- Dependencies: 2766
-- Name: ax_gebaeude_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_gebaeude_gml ON ax_gebaeude USING btree (gml_id);


--
-- TOC entry 3606 (class 1259 OID 5501301)
-- Dependencies: 2306 2706
-- Name: ax_gebaeudeausgestaltung_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_gebaeudeausgestaltung_geom_idx ON ax_gebaeudeausgestaltung USING gist (wkb_geometry);


--
-- TOC entry 3607 (class 1259 OID 5501302)
-- Dependencies: 2706
-- Name: ax_gebaeudeausgestaltung_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_gebaeudeausgestaltung_gml ON ax_gebaeudeausgestaltung USING btree (gml_id);


--
-- TOC entry 3803 (class 1259 OID 5502105)
-- Dependencies: 2810 2306
-- Name: ax_gehoelz_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_gehoelz_geom_idx ON ax_gehoelz USING gist (wkb_geometry);


--
-- TOC entry 3804 (class 1259 OID 5502106)
-- Dependencies: 2810
-- Name: ax_gehoelz_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_gehoelz_gml ON ax_gehoelz USING btree (gml_id);


--
-- TOC entry 3937 (class 1259 OID 5502672)
-- Dependencies: 2306 2878
-- Name: ax_gelaendekante_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_gelaendekante_geom_idx ON ax_gelaendekante USING gist (wkb_geometry);


--
-- TOC entry 3938 (class 1259 OID 5502673)
-- Dependencies: 2878
-- Name: ax_gelaendekante_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_gelaendekante_gml ON ax_gelaendekante USING btree (gml_id);


--
-- TOC entry 3980 (class 1259 OID 5502841)
-- Dependencies: 2902
-- Name: ax_gemarkung_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_gemarkung_gml ON ax_gemarkung USING btree (gml_id);


--
-- TOC entry 3981 (class 1259 OID 5502842)
-- Dependencies: 2902 2902
-- Name: ax_gemarkung_nr; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_gemarkung_nr ON ax_gemarkung USING btree (land, gemarkungsnummer);


--
-- TOC entry 3984 (class 1259 OID 5502852)
-- Dependencies: 2904
-- Name: ax_gemarkungsteilflur_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_gemarkungsteilflur_gml ON ax_gemarkungsteilflur USING btree (gml_id);


--
-- TOC entry 3977 (class 1259 OID 5502831)
-- Dependencies: 2900
-- Name: ax_gemeinde_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_gemeinde_gml ON ax_gemeinde USING btree (gml_id);


--
-- TOC entry 3610 (class 1259 OID 5501320)
-- Dependencies: 2708 2708 2708
-- Name: ax_georeferenziertegebaeudeadresse_adr; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_georeferenziertegebaeudeadresse_adr ON ax_georeferenziertegebaeudeadresse USING btree (strassenschluessel, hausnummer, adressierungszusatz);


--
-- TOC entry 3611 (class 1259 OID 5501318)
-- Dependencies: 2306 2708
-- Name: ax_georeferenziertegebaeudeadresse_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_georeferenziertegebaeudeadresse_geom_idx ON ax_georeferenziertegebaeudeadresse USING gist (wkb_geometry);


--
-- TOC entry 3612 (class 1259 OID 5501319)
-- Dependencies: 2708
-- Name: ax_georeferenziertegebaeudeadresse_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_georeferenziertegebaeudeadresse_gml ON ax_georeferenziertegebaeudeadresse USING btree (gml_id);


--
-- TOC entry 3914 (class 1259 OID 5502574)
-- Dependencies: 2306 2866
-- Name: ax_gewaessermerkmal_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_gewaessermerkmal_geom_idx ON ax_gewaessermerkmal USING gist (wkb_geometry);


--
-- TOC entry 3915 (class 1259 OID 5502575)
-- Dependencies: 2866
-- Name: ax_gewaessermerkmal_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_gewaessermerkmal_gml ON ax_gewaessermerkmal USING btree (gml_id);


--
-- TOC entry 3898 (class 1259 OID 5502506)
-- Dependencies: 2306 2858
-- Name: ax_gleis_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_gleis_geom_idx ON ax_gleis USING gist (wkb_geometry);


--
-- TOC entry 3899 (class 1259 OID 5502507)
-- Dependencies: 2858
-- Name: ax_gleis_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_gleis_gml ON ax_gleis USING btree (gml_id);


--
-- TOC entry 3615 (class 1259 OID 5501336)
-- Dependencies: 2306 2710
-- Name: ax_grablochderbodenschaetzung_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_grablochderbodenschaetzung_geom_idx ON ax_grablochderbodenschaetzung USING gist (wkb_geometry);


--
-- TOC entry 3616 (class 1259 OID 5501337)
-- Dependencies: 2710
-- Name: ax_grablochderbodenschaetzung_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_grablochderbodenschaetzung_gml ON ax_grablochderbodenschaetzung USING btree (gml_id);


--
-- TOC entry 3669 (class 1259 OID 5501554)
-- Dependencies: 2738
-- Name: ax_grenzpunkt_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_grenzpunkt_gml ON ax_grenzpunkt USING btree (gml_id);


--
-- TOC entry 3827 (class 1259 OID 5502207)
-- Dependencies: 2822 2306
-- Name: ax_hafenbecken_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_hafenbecken_geom_idx ON ax_hafenbecken USING gist (wkb_geometry);


--
-- TOC entry 3828 (class 1259 OID 5502208)
-- Dependencies: 2822
-- Name: ax_hafenbecken_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_hafenbecken_gml ON ax_hafenbecken USING btree (gml_id);


--
-- TOC entry 3743 (class 1259 OID 5501850)
-- Dependencies: 2306 2780
-- Name: ax_halde_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_halde_geom_idx ON ax_halde USING gist (wkb_geometry);


--
-- TOC entry 3744 (class 1259 OID 5501851)
-- Dependencies: 2780
-- Name: ax_halde_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_halde_gml ON ax_halde USING btree (gml_id);


--
-- TOC entry 3807 (class 1259 OID 5502122)
-- Dependencies: 2812 2306
-- Name: ax_heide_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_heide_geom_idx ON ax_heide USING gist (wkb_geometry);


--
-- TOC entry 3808 (class 1259 OID 5502123)
-- Dependencies: 2812
-- Name: ax_heide_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_heide_gml ON ax_heide USING btree (gml_id);


--
-- TOC entry 3867 (class 1259 OID 5502377)
-- Dependencies: 2306 2842
-- Name: ax_heilquellegasquelle_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_heilquellegasquelle_geom_idx ON ax_heilquellegasquelle USING gist (wkb_geometry);


--
-- TOC entry 3868 (class 1259 OID 5502378)
-- Dependencies: 2842
-- Name: ax_heilquellegasquelle_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_heilquellegasquelle_gml ON ax_heilquellegasquelle USING btree (gml_id);


--
-- TOC entry 3863 (class 1259 OID 5502360)
-- Dependencies: 2840 2306
-- Name: ax_historischesbauwerkoderhistorischeeinrichtung_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_historischesbauwerkoderhistorischeeinrichtung_geom_idx ON ax_historischesbauwerkoderhistorischeeinrichtung USING gist (wkb_geometry);


--
-- TOC entry 3864 (class 1259 OID 5502361)
-- Dependencies: 2840
-- Name: ax_historischesbauwerkoderhistorischeeinrichtung_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_historischesbauwerkoderhistorischeeinrichtung_gml ON ax_historischesbauwerkoderhistorischeeinrichtung USING btree (gml_id);


--
-- TOC entry 3622 (class 1259 OID 5501366)
-- Dependencies: 2306 2714
-- Name: ax_historischesflurstueck_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_historischesflurstueck_geom_idx ON ax_historischesflurstueck USING gist (wkb_geometry);


--
-- TOC entry 3623 (class 1259 OID 5501367)
-- Dependencies: 2714
-- Name: ax_historischesflurstueck_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_historischesflurstueck_gml ON ax_historischesflurstueck USING btree (gml_id);


--
-- TOC entry 3619 (class 1259 OID 5501350)
-- Dependencies: 2712
-- Name: ax_historischesflurstueckalb_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_historischesflurstueckalb_gml ON ax_historischesflurstueckalb USING btree (gml_id);


--
-- TOC entry 3739 (class 1259 OID 5501833)
-- Dependencies: 2306 2778
-- Name: ax_industrieundgewerbeflaeche_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_industrieundgewerbeflaeche_geom_idx ON ax_industrieundgewerbeflaeche USING gist (wkb_geometry);


--
-- TOC entry 3740 (class 1259 OID 5501834)
-- Dependencies: 2778
-- Name: ax_industrieundgewerbeflaeche_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_industrieundgewerbeflaeche_gml ON ax_industrieundgewerbeflaeche USING btree (gml_id);


--
-- TOC entry 3945 (class 1259 OID 5502706)
-- Dependencies: 2306 2882
-- Name: ax_klassifizierungnachstrassenrecht_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_klassifizierungnachstrassenrecht_geom_idx ON ax_klassifizierungnachstrassenrecht USING gist (wkb_geometry);


--
-- TOC entry 3946 (class 1259 OID 5502707)
-- Dependencies: 2882
-- Name: ax_klassifizierungnachstrassenrecht_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_klassifizierungnachstrassenrecht_gml ON ax_klassifizierungnachstrassenrecht USING btree (gml_id);


--
-- TOC entry 3949 (class 1259 OID 5502723)
-- Dependencies: 2306 2884
-- Name: ax_klassifizierungnachwasserrecht_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_klassifizierungnachwasserrecht_geom_idx ON ax_klassifizierungnachwasserrecht USING gist (wkb_geometry);


--
-- TOC entry 4000 (class 1259 OID 5502902)
-- Dependencies: 2912 2306
-- Name: ax_kleinraeumigerlandschaftsteil_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_kleinraeumigerlandschaftsteil_geom_idx ON ax_kleinraeumigerlandschaftsteil USING gist (wkb_geometry);


--
-- TOC entry 4001 (class 1259 OID 5502903)
-- Dependencies: 2912
-- Name: ax_kleinraeumigerlandschaftsteil_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_kleinraeumigerlandschaftsteil_gml ON ax_kleinraeumigerlandschaftsteil USING btree (gml_id);


--
-- TOC entry 4008 (class 1259 OID 5502936)
-- Dependencies: 2916 2306
-- Name: ax_kommunalesgebiet_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_kommunalesgebiet_geom_idx ON ax_kommunalesgebiet USING gist (wkb_geometry);


--
-- TOC entry 4009 (class 1259 OID 5502937)
-- Dependencies: 2916
-- Name: ax_kommunalesgebiet_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_kommunalesgebiet_gml ON ax_kommunalesgebiet USING btree (gml_id);


--
-- TOC entry 3974 (class 1259 OID 5502821)
-- Dependencies: 2898
-- Name: ax_kreisregion_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_kreisregion_gml ON ax_kreisregion USING btree (gml_id);


--
-- TOC entry 3994 (class 1259 OID 5502886)
-- Dependencies: 2910
-- Name: ax_lagebezeichnungkatalogeintrag_bez; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_lagebezeichnungkatalogeintrag_bez ON ax_lagebezeichnungkatalogeintrag USING btree (bezeichnung);


--
-- TOC entry 3995 (class 1259 OID 5502885)
-- Dependencies: 2910
-- Name: ax_lagebezeichnungkatalogeintrag_gesa; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_lagebezeichnungkatalogeintrag_gesa ON ax_lagebezeichnungkatalogeintrag USING btree (schluesselgesamt);


--
-- TOC entry 3996 (class 1259 OID 5502883)
-- Dependencies: 2910
-- Name: ax_lagebezeichnungkatalogeintrag_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_lagebezeichnungkatalogeintrag_gml ON ax_lagebezeichnungkatalogeintrag USING btree (gml_id);


--
-- TOC entry 3997 (class 1259 OID 5502884)
-- Dependencies: 2910 2910
-- Name: ax_lagebezeichnungkatalogeintrag_lage; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_lagebezeichnungkatalogeintrag_lage ON ax_lagebezeichnungkatalogeintrag USING btree (gemeinde, lage);


--
-- TOC entry 3676 (class 1259 OID 5501575)
-- Dependencies: 2742
-- Name: ax_lagebezeichnungmithausnummer_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_lagebezeichnungmithausnummer_gml ON ax_lagebezeichnungmithausnummer USING btree (gml_id);


--
-- TOC entry 3677 (class 1259 OID 5501576)
-- Dependencies: 2742 2742
-- Name: ax_lagebezeichnungmithausnummer_lage; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_lagebezeichnungmithausnummer_lage ON ax_lagebezeichnungmithausnummer USING btree (gemeinde, lage);


--
-- TOC entry 3680 (class 1259 OID 5501586)
-- Dependencies: 2744
-- Name: ax_lagebezeichnungmitpseudonummer_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_lagebezeichnungmitpseudonummer_gml ON ax_lagebezeichnungmitpseudonummer USING btree (gml_id);


--
-- TOC entry 3672 (class 1259 OID 5501564)
-- Dependencies: 2740
-- Name: ax_lagebezeichnungohnehausnummer_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_lagebezeichnungohnehausnummer_gml ON ax_lagebezeichnungohnehausnummer USING btree (gml_id);


--
-- TOC entry 3673 (class 1259 OID 5501565)
-- Dependencies: 2740 2740 2740 2740 2740
-- Name: ax_lagebezeichnungohnehausnummer_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_lagebezeichnungohnehausnummer_key ON ax_lagebezeichnungohnehausnummer USING btree (land, regierungsbezirk, kreis, gemeinde, lage);


--
-- TOC entry 3795 (class 1259 OID 5502071)
-- Dependencies: 2306 2806
-- Name: ax_landwirtschaft_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_landwirtschaft_geom_idx ON ax_landwirtschaft USING gist (wkb_geometry);


--
-- TOC entry 3796 (class 1259 OID 5502072)
-- Dependencies: 2806
-- Name: ax_landwirtschaft_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_landwirtschaft_gml ON ax_landwirtschaft USING btree (gml_id);


--
-- TOC entry 3855 (class 1259 OID 5502326)
-- Dependencies: 2306 2836
-- Name: ax_leitung_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_leitung_geom_idx ON ax_leitung USING gist (wkb_geometry);


--
-- TOC entry 3856 (class 1259 OID 5502327)
-- Dependencies: 2836
-- Name: ax_leitung_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_leitung_gml ON ax_leitung USING btree (gml_id);


--
-- TOC entry 3835 (class 1259 OID 5502241)
-- Dependencies: 2826 2306
-- Name: ax_meer_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_meer_geom_idx ON ax_meer USING gist (wkb_geometry);


--
-- TOC entry 3836 (class 1259 OID 5502242)
-- Dependencies: 2826
-- Name: ax_meer_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_meer_gml ON ax_meer USING btree (gml_id);


--
-- TOC entry 3811 (class 1259 OID 5502139)
-- Dependencies: 2814 2306
-- Name: ax_moor_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_moor_geom_idx ON ax_moor USING gist (wkb_geometry);


--
-- TOC entry 3812 (class 1259 OID 5502140)
-- Dependencies: 2814
-- Name: ax_moor_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_moor_gml ON ax_moor USING btree (gml_id);


--
-- TOC entry 3964 (class 1259 OID 5502790)
-- Dependencies: 2306 2892
-- Name: ax_musterlandesmusterundvergleichsstueck_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_musterlandesmusterundvergleichsstueck_geom_idx ON ax_musterlandesmusterundvergleichsstueck USING gist (wkb_geometry);


--
-- TOC entry 3965 (class 1259 OID 5502791)
-- Dependencies: 2892
-- Name: ax_musterlandesmusterundvergleichsstueck_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_musterlandesmusterundvergleichsstueck_gml ON ax_musterlandesmusterundvergleichsstueck USING btree (gml_id);


--
-- TOC entry 3707 (class 1259 OID 5501696)
-- Dependencies: 2760
-- Name: ax_namensnummer_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_namensnummer_gml ON ax_namensnummer USING btree (gml_id);


--
-- TOC entry 3626 (class 1259 OID 5501383)
-- Dependencies: 2306 2716
-- Name: ax_naturumweltoderbodenschutzrecht_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_naturumweltoderbodenschutzrecht_geom_idx ON ax_naturumweltoderbodenschutzrecht USING gist (wkb_geometry);


--
-- TOC entry 3627 (class 1259 OID 5501384)
-- Dependencies: 2716
-- Name: ax_naturumweltoderbodenschutzrecht_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_naturumweltoderbodenschutzrecht_gml ON ax_naturumweltoderbodenschutzrecht USING btree (gml_id);


--
-- TOC entry 3779 (class 1259 OID 5502003)
-- Dependencies: 2798 2306
-- Name: ax_platz_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_platz_geom_idx ON ax_platz USING gist (wkb_geometry);


--
-- TOC entry 3780 (class 1259 OID 5502004)
-- Dependencies: 2798
-- Name: ax_platz_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_platz_gml ON ax_platz USING btree (gml_id);


--
-- TOC entry 3689 (class 1259 OID 5501628)
-- Dependencies: 2750 2306
-- Name: ax_punktortag_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_punktortag_geom_idx ON ax_punktortag USING gist (wkb_geometry);


--
-- TOC entry 3690 (class 1259 OID 5501629)
-- Dependencies: 2750
-- Name: ax_punktortag_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_punktortag_gml ON ax_punktortag USING btree (gml_id);


--
-- TOC entry 3693 (class 1259 OID 5501645)
-- Dependencies: 2306 2752
-- Name: ax_punktortau_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_punktortau_geom_idx ON ax_punktortau USING gist (wkb_geometry);


--
-- TOC entry 3694 (class 1259 OID 5501646)
-- Dependencies: 2752
-- Name: ax_punktortau_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_punktortau_gml ON ax_punktortau USING btree (gml_id);


--
-- TOC entry 3697 (class 1259 OID 5501662)
-- Dependencies: 2754 2306
-- Name: ax_punktortta_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_punktortta_geom_idx ON ax_punktortta USING gist (wkb_geometry);


--
-- TOC entry 3698 (class 1259 OID 5501663)
-- Dependencies: 2754
-- Name: ax_punktortta_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_punktortta_gml ON ax_punktortta USING btree (gml_id);


--
-- TOC entry 3971 (class 1259 OID 5502811)
-- Dependencies: 2896
-- Name: ax_regierungsbezirk_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_regierungsbezirk_gml ON ax_regierungsbezirk USING btree (gml_id);


--
-- TOC entry 3791 (class 1259 OID 5502054)
-- Dependencies: 2306 2804
-- Name: ax_schiffsverkehr_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_schiffsverkehr_geom_idx ON ax_schiffsverkehr USING gist (wkb_geometry);


--
-- TOC entry 3792 (class 1259 OID 5502055)
-- Dependencies: 2804
-- Name: ax_schiffsverkehr_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_schiffsverkehr_gml ON ax_schiffsverkehr USING btree (gml_id);


--
-- TOC entry 3630 (class 1259 OID 5501394)
-- Dependencies: 2718
-- Name: ax_schutzgebietnachwasserrecht_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_schutzgebietnachwasserrecht_gml ON ax_schutzgebietnachwasserrecht USING btree (gml_id);


--
-- TOC entry 3633 (class 1259 OID 5501410)
-- Dependencies: 2306 2720
-- Name: ax_schutzzone_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_schutzzone_geom_idx ON ax_schutzzone USING gist (wkb_geometry);


--
-- TOC entry 3634 (class 1259 OID 5501411)
-- Dependencies: 2720
-- Name: ax_schutzzone_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_schutzzone_gml ON ax_schutzzone USING btree (gml_id);


--
-- TOC entry 3686 (class 1259 OID 5501612)
-- Dependencies: 2748
-- Name: ax_sonstigervermessungspunkt_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_sonstigervermessungspunkt_gml ON ax_sonstigervermessungspunkt USING btree (gml_id);


--
-- TOC entry 3871 (class 1259 OID 5502394)
-- Dependencies: 2306 2844
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_sonstigesbauwerkodersonstigeeinrichtung_geom_idx ON ax_sonstigesbauwerkodersonstigeeinrichtung USING gist (wkb_geometry);


--
-- TOC entry 3872 (class 1259 OID 5502395)
-- Dependencies: 2844
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_sonstigesbauwerkodersonstigeeinrichtung_gml ON ax_sonstigesbauwerkodersonstigeeinrichtung USING btree (gml_id);


--
-- TOC entry 3956 (class 1259 OID 5502756)
-- Dependencies: 2888 2306
-- Name: ax_sonstigesrecht_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_sonstigesrecht_geom_idx ON ax_sonstigesrecht USING gist (wkb_geometry);


--
-- TOC entry 3957 (class 1259 OID 5502757)
-- Dependencies: 2888
-- Name: ax_sonstigesrecht_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_sonstigesrecht_gml ON ax_sonstigesrecht USING btree (gml_id);


--
-- TOC entry 3763 (class 1259 OID 5501935)
-- Dependencies: 2790 2306
-- Name: ax_sportfreizeitunderholungsflaeche_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_sportfreizeitunderholungsflaeche_geom_idx ON ax_sportfreizeitunderholungsflaeche USING gist (wkb_geometry);


--
-- TOC entry 3764 (class 1259 OID 5501936)
-- Dependencies: 2790
-- Name: ax_sportfreizeitunderholungsflaeche_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_sportfreizeitunderholungsflaeche_gml ON ax_sportfreizeitunderholungsflaeche USING btree (gml_id);


--
-- TOC entry 3831 (class 1259 OID 5502224)
-- Dependencies: 2824 2306
-- Name: ax_stehendesgewaesser_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_stehendesgewaesser_geom_idx ON ax_stehendesgewaesser USING gist (wkb_geometry);


--
-- TOC entry 3832 (class 1259 OID 5502225)
-- Dependencies: 2824
-- Name: ax_stehendesgewaesser_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_stehendesgewaesser_gml ON ax_stehendesgewaesser USING btree (gml_id);


--
-- TOC entry 3771 (class 1259 OID 5501969)
-- Dependencies: 2306 2794
-- Name: ax_strassenverkehr_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_strassenverkehr_geom_idx ON ax_strassenverkehr USING gist (wkb_geometry);


--
-- TOC entry 3772 (class 1259 OID 5501970)
-- Dependencies: 2794
-- Name: ax_strassenverkehr_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_strassenverkehr_gml ON ax_strassenverkehr USING btree (gml_id);


--
-- TOC entry 3886 (class 1259 OID 5502455)
-- Dependencies: 2306 2852
-- Name: ax_strassenverkehrsanlage_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_strassenverkehrsanlage_geom_idx ON ax_strassenverkehrsanlage USING gist (wkb_geometry);


--
-- TOC entry 3887 (class 1259 OID 5502456)
-- Dependencies: 2852
-- Name: ax_strassenverkehrsanlage_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_strassenverkehrsanlage_gml ON ax_strassenverkehrsanlage USING btree (gml_id);


--
-- TOC entry 3815 (class 1259 OID 5502156)
-- Dependencies: 2816 2306
-- Name: ax_sumpf_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_sumpf_geom_idx ON ax_sumpf USING gist (wkb_geometry);


--
-- TOC entry 3816 (class 1259 OID 5502157)
-- Dependencies: 2816
-- Name: ax_sumpf_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_sumpf_gml ON ax_sumpf USING btree (gml_id);


--
-- TOC entry 3751 (class 1259 OID 5501884)
-- Dependencies: 2784 2306
-- Name: ax_tagebaugrubesteinbruch_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_tagebaugrubesteinbruch_geom_idx ON ax_tagebaugrubesteinbruch USING gist (wkb_geometry);


--
-- TOC entry 3754 (class 1259 OID 5501885)
-- Dependencies: 2784
-- Name: ax_tagebaugrubesteinbruchb_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_tagebaugrubesteinbruchb_gml ON ax_tagebaugrubesteinbruch USING btree (gml_id);


--
-- TOC entry 3637 (class 1259 OID 5501427)
-- Dependencies: 2722 2306
-- Name: ax_topographischelinie_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_topographischelinie_geom_idx ON ax_topographischelinie USING gist (wkb_geometry);


--
-- TOC entry 3638 (class 1259 OID 5501428)
-- Dependencies: 2722
-- Name: ax_topographischelinie_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_topographischelinie_gml ON ax_topographischelinie USING btree (gml_id);


--
-- TOC entry 3851 (class 1259 OID 5502309)
-- Dependencies: 2306 2834
-- Name: ax_transportanlage_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_transportanlage_geom_idx ON ax_transportanlage USING gist (wkb_geometry);


--
-- TOC entry 3852 (class 1259 OID 5502310)
-- Dependencies: 2834
-- Name: ax_transportanlage_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_transportanlage_gml ON ax_transportanlage USING btree (gml_id);


--
-- TOC entry 3839 (class 1259 OID 5502258)
-- Dependencies: 2828 2306
-- Name: ax_turm_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_turm_geom_idx ON ax_turm USING gist (wkb_geometry);


--
-- TOC entry 3840 (class 1259 OID 5502259)
-- Dependencies: 2828
-- Name: ax_turm_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_turm_gml ON ax_turm USING btree (gml_id);


--
-- TOC entry 3819 (class 1259 OID 5502173)
-- Dependencies: 2818 2306
-- Name: ax_unlandvegetationsloseflaeche_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_unlandvegetationsloseflaeche_geom_idx ON ax_unlandvegetationsloseflaeche USING gist (wkb_geometry);


--
-- TOC entry 3820 (class 1259 OID 5502174)
-- Dependencies: 2818
-- Name: ax_unlandvegetationsloseflaeche_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_unlandvegetationsloseflaeche_gml ON ax_unlandvegetationsloseflaeche USING btree (gml_id);


--
-- TOC entry 3918 (class 1259 OID 5502591)
-- Dependencies: 2306 2868
-- Name: ax_untergeordnetesgewaesser_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_untergeordnetesgewaesser_geom_idx ON ax_untergeordnetesgewaesser USING gist (wkb_geometry);


--
-- TOC entry 3919 (class 1259 OID 5502592)
-- Dependencies: 2868
-- Name: ax_untergeordnetesgewaesser_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_untergeordnetesgewaesser_gml ON ax_untergeordnetesgewaesser USING btree (gml_id);


--
-- TOC entry 3910 (class 1259 OID 5502557)
-- Dependencies: 2864 2306
-- Name: ax_vegetationsmerkmal_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_vegetationsmerkmal_geom_idx ON ax_vegetationsmerkmal USING gist (wkb_geometry);


--
-- TOC entry 3911 (class 1259 OID 5502558)
-- Dependencies: 2864
-- Name: ax_vegetationsmerkmal_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_vegetationsmerkmal_gml ON ax_vegetationsmerkmal USING btree (gml_id);


--
-- TOC entry 3847 (class 1259 OID 5502292)
-- Dependencies: 2832 2306
-- Name: ax_vorratsbehaelterspeicherbauwerk_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_vorratsbehaelterspeicherbauwerk_geom_idx ON ax_vorratsbehaelterspeicherbauwerk USING gist (wkb_geometry);


--
-- TOC entry 3848 (class 1259 OID 5502293)
-- Dependencies: 2832
-- Name: ax_vorratsbehaelterspeicherbauwerk_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_vorratsbehaelterspeicherbauwerk_gml ON ax_vorratsbehaelterspeicherbauwerk USING btree (gml_id);


--
-- TOC entry 3799 (class 1259 OID 5502088)
-- Dependencies: 2808 2306
-- Name: ax_wald_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_wald_geom_idx ON ax_wald USING gist (wkb_geometry);


--
-- TOC entry 3800 (class 1259 OID 5502089)
-- Dependencies: 2808
-- Name: ax_wald_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_wald_gml ON ax_wald USING btree (gml_id);


--
-- TOC entry 3775 (class 1259 OID 5501986)
-- Dependencies: 2306 2796
-- Name: ax_weg_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_weg_geom_idx ON ax_weg USING gist (wkb_geometry);


--
-- TOC entry 3776 (class 1259 OID 5501987)
-- Dependencies: 2796
-- Name: ax_weg_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_weg_gml ON ax_weg USING btree (gml_id);


--
-- TOC entry 3890 (class 1259 OID 5502472)
-- Dependencies: 2854 2306
-- Name: ax_wegpfadsteig_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_wegpfadsteig_geom_idx ON ax_wegpfadsteig USING gist (wkb_geometry);


--
-- TOC entry 3891 (class 1259 OID 5502473)
-- Dependencies: 2854
-- Name: ax_wegpfadsteig_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_wegpfadsteig_gml ON ax_wegpfadsteig USING btree (gml_id);


--
-- TOC entry 3735 (class 1259 OID 5501816)
-- Dependencies: 2306 2776
-- Name: ax_wohnbauflaeche_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_wohnbauflaeche_geom_idx ON ax_wohnbauflaeche USING gist (wkb_geometry);


--
-- TOC entry 3736 (class 1259 OID 5501817)
-- Dependencies: 2776
-- Name: ax_wohnbauflaeche_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_wohnbauflaeche_gml ON ax_wohnbauflaeche USING btree (gml_id);


--
-- TOC entry 4004 (class 1259 OID 5502919)
-- Dependencies: 2914 2306
-- Name: ax_wohnplatz_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ax_wohnplatz_geom_idx ON ax_wohnplatz USING gist (wkb_geometry);


--
-- TOC entry 4005 (class 1259 OID 5502920)
-- Dependencies: 2914
-- Name: ax_wohnplatz_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX ax_wohnplatz_gml ON ax_wohnplatz USING btree (gml_id);


--
-- TOC entry 3585 (class 1259 OID 5501205)
-- Dependencies: 2694
-- Name: id_alkis_beziehungen_von; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX id_alkis_beziehungen_von ON alkis_beziehungen USING btree (beziehung_von);


--
-- TOC entry 3586 (class 1259 OID 5501206)
-- Dependencies: 2694
-- Name: id_alkis_beziehungen_zu; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX id_alkis_beziehungen_zu ON alkis_beziehungen USING btree (beziehung_zu);


--
-- TOC entry 3703 (class 1259 OID 5501673)
-- Dependencies: 2756
-- Name: id_ax_person_gml; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX id_ax_person_gml ON ax_person USING btree (gml_id);


--
-- TOC entry 3580 (class 1259 OID 5501196)
-- Dependencies: 2692 2306
-- Name: ks_sonstigesbauwerk_geom_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX ks_sonstigesbauwerk_geom_idx ON ks_sonstigesbauwerk USING gist (wkb_geometry);


--
-- TOC entry 4016 (class 0 OID 0)
-- Dependencies: 3
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2011-05-13 15:53:40 CEST

--
-- PostgreSQL database dump complete
--

