--
-- TOC entry 2670 (class 1259 OID 29899)
-- Dependencies: 3
-- Name: alkis_beziehungen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE alkis_beziehungen (
    ogc_fid integer NOT NULL,
    beziehung_von character varying,
    beziehungsart character varying,
    beziehung_zu character varying
);
-- keine Geometrie, daher ersatzweise: Dummy-Eintrag in Metatabelle - siehe ALKIS
INSERT INTO geometry_columns
   (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'alkis_beziehungen', 'dummy', 2, 25832, 'POINT');


--
-- TOC entry 2669 (class 1259 OID 29897)
-- Dependencies: 2670 3
-- Name: alkis_beziehungen_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE alkis_beziehungen_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 2669
-- Name: alkis_beziehungen_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE alkis_beziehungen_ogc_fid_seq OWNED BY alkis_beziehungen.ogc_fid;


--
-- TOC entry 2672 (class 1259 OID 29911)
-- Dependencies: 3132 3133 3134 3 1087
-- Name: ax_abschnitt; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_abschnitt (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(9),
    art character(16),
    name character(11),
    bezeichnung character(200), --16
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2671 (class 1259 OID 29909)
-- Dependencies: 2672 3
-- Name: ax_abschnitt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_abschnitt_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 2671
-- Name: ax_abschnitt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_abschnitt_ogc_fid_seq OWNED BY ax_abschnitt.ogc_fid;


--
-- TOC entry 2674 (class 1259 OID 29927)
-- Dependencies: 3136 3137 3138 1087 3
-- Name: ax_ast; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_ast (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(9),
    art character(16),
    name character(11),
    istteilvon character varying,
    bezeichnung character(200), --9
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2673 (class 1259 OID 29925)
-- Dependencies: 3 2674
-- Name: ax_ast_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_ast_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 2673
-- Name: ax_ast_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_ast_ogc_fid_seq OWNED BY ax_ast.ogc_fid;


--
-- TOC entry 2734 (class 1259 OID 30568)
-- Dependencies: 3248 3249 3250 1087 3
-- Name: ax_bahnstrecke; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_bahnstrecke (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    hatdirektunten character varying,
    bahnkategorie integer,
    elektrifizierung integer,
    anzahlderstreckengleise integer,
    nummerderbahnstrecke integer,
    spurweite integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2733 (class 1259 OID 30566)
-- Dependencies: 3 2734
-- Name: ax_bahnstrecke_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_bahnstrecke_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 2733
-- Name: ax_bahnstrecke_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_bahnstrecke_ogc_fid_seq OWNED BY ax_bahnstrecke.ogc_fid;


--
-- TOC entry 2770 (class 1259 OID 33469)
-- Dependencies: 3317 3318 3319 1087 3
-- Name: ax_bahnverkehr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_bahnverkehr (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2769 (class 1259 OID 33467)
-- Dependencies: 2770 3
-- Name: ax_bahnverkehr_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_bahnverkehr_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 2769
-- Name: ax_bahnverkehr_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_bahnverkehr_ogc_fid_seq OWNED BY ax_bahnverkehr.ogc_fid;


--
-- TOC entry 2732 (class 1259 OID 30552)
-- Dependencies: 3244 3245 3246 3 1087
-- Name: ax_bahnverkehrsanlage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_bahnverkehrsanlage (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    bahnhofskategorie integer,
    name_ character(200), --15
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2731 (class 1259 OID 30550)
-- Dependencies: 2732 3
-- Name: ax_bahnverkehrsanlage_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_bahnverkehrsanlage_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 2731
-- Name: ax_bahnverkehrsanlage_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_bahnverkehrsanlage_ogc_fid_seq OWNED BY ax_bahnverkehrsanlage.ogc_fid;


--
-- TOC entry 2676 (class 1259 OID 29943)
-- Dependencies: 3140 3141 3142 3 1087
-- Name: ax_bauwerkimgewaesserbereich; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_bauwerkimgewaesserbereich (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    bauwerksfunktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2675 (class 1259 OID 29941)
-- Dependencies: 2676 3
-- Name: ax_bauwerkimgewaesserbereich_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_bauwerkimgewaesserbereich_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 2675
-- Name: ax_bauwerkimgewaesserbereich_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_bauwerkimgewaesserbereich_ogc_fid_seq OWNED BY ax_bauwerkimgewaesserbereich.ogc_fid;


--
-- TOC entry 2680 (class 1259 OID 29975)
-- Dependencies: 3148 3149 3 1087
-- Name: ax_bauwerkimverkehrsbereich; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_bauwerkimverkehrsbereich (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    bauwerksfunktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2679 (class 1259 OID 29973)
-- Dependencies: 2680 3
-- Name: ax_bauwerkimverkehrsbereich_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_bauwerkimverkehrsbereich_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 2679
-- Name: ax_bauwerkimverkehrsbereich_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_bauwerkimverkehrsbereich_ogc_fid_seq OWNED BY ax_bauwerkimverkehrsbereich.ogc_fid;


--
-- TOC entry 2682 (class 1259 OID 29990)
-- Dependencies: 3151 3152 3153 1087 3
-- Name: ax_bauwerkoderanlagefuerindustrieundgewerbe; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_bauwerkoderanlagefuerindustrieundgewerbe (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    bauwerksfunktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2681 (class 1259 OID 29988)
-- Dependencies: 3 2682
-- Name: ax_bauwerkoderanlagefuerindustrieundgewerbe_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_bauwerkoderanlagefuerindustrieundgewerbe_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 2681
-- Name: ax_bauwerkoderanlagefuerindustrieundgewerbe_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_bauwerkoderanlagefuerindustrieundgewerbe_ogc_fid_seq OWNED BY ax_bauwerkoderanlagefuerindustrieundgewerbe.ogc_fid;


--
-- TOC entry 2678 (class 1259 OID 29959)
-- Dependencies: 3144 3145 3146 3 1087
-- Name: ax_bauwerkoderanlagefuersportfreizeitunderholung; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_bauwerkoderanlagefuersportfreizeitunderholung (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    bauwerksfunktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2677 (class 1259 OID 29957)
-- Dependencies: 2678 3
-- Name: ax_bauwerkoderanlagefuersportfreizeitunderholung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_bauwerkoderanlagefuersportfreizeitunderholung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 2677
-- Name: ax_bauwerkoderanlagefuersportfreizeitunderholung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_bauwerkoderanlagefuersportfreizeitunderholung_ogc_fid_seq OWNED BY ax_bauwerkoderanlagefuersportfreizeitunderholung.ogc_fid;


--
-- TOC entry 2796 (class 1259 OID 133065)
-- Dependencies: 3366 3367 3368 3 1087
-- Name: ax_bergbaubetrieb; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_bergbaubetrieb (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2795 (class 1259 OID 133063)
-- Dependencies: 3 2796
-- Name: ax_bergbaubetrieb_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_bergbaubetrieb_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 2795
-- Name: ax_bergbaubetrieb_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_bergbaubetrieb_ogc_fid_seq OWNED BY ax_bergbaubetrieb.ogc_fid;


--
-- TOC entry 2738 (class 1259 OID 30600)
-- Dependencies: 3256 3257 3258 1087 3
-- Name: ax_dammwalldeich; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_dammwalldeich (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    funktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2737 (class 1259 OID 30598)
-- Dependencies: 3 2738
-- Name: ax_dammwalldeich_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_dammwalldeich_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 2737
-- Name: ax_dammwalldeich_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_dammwalldeich_ogc_fid_seq OWNED BY ax_dammwalldeich.ogc_fid;


--
-- TOC entry 2758 (class 1259 OID 30998)
-- Dependencies: 3293 3294 3295 3 1087
-- Name: ax_denkmalschutzrecht; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_denkmalschutzrecht (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    artderfestlegung integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2757 (class 1259 OID 30996)
-- Dependencies: 3 2758
-- Name: ax_denkmalschutzrecht_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_denkmalschutzrecht_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 2757
-- Name: ax_denkmalschutzrecht_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_denkmalschutzrecht_ogc_fid_seq OWNED BY ax_denkmalschutzrecht.ogc_fid;


--
-- TOC entry 2736 (class 1259 OID 30584)
-- Dependencies: 3252 3253 3254 1087 3
-- Name: ax_einrichtungenfuerdenschiffsverkehr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_einrichtungenfuerdenschiffsverkehr (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    art_ integer,
    bezeichnung integer,
    kilometerangabe double precision,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2735 (class 1259 OID 30582)
-- Dependencies: 3 2736
-- Name: ax_einrichtungenfuerdenschiffsverkehr_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_einrichtungenfuerdenschiffsverkehr_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 2735
-- Name: ax_einrichtungenfuerdenschiffsverkehr_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_einrichtungenfuerdenschiffsverkehr_ogc_fid_seq OWNED BY ax_einrichtungenfuerdenschiffsverkehr.ogc_fid;


--
-- TOC entry 2684 (class 1259 OID 30006)
-- Dependencies: 3155 3156 3157 1087 3
-- Name: ax_fahrbahnachse; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_fahrbahnachse (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    istteilvon character varying,
    breitederfahrbahn double precision,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2683 (class 1259 OID 30004)
-- Dependencies: 2684 3
-- Name: ax_fahrbahnachse_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_fahrbahnachse_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 2683
-- Name: ax_fahrbahnachse_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_fahrbahnachse_ogc_fid_seq OWNED BY ax_fahrbahnachse.ogc_fid;


--
-- TOC entry 2652 (class 1259 OID 29719)
-- Dependencies: 3095 3096 3097 1087 3
-- Name: ax_fahrwegachse; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_fahrwegachse (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    befestigung integer,
    breitedesverkehrsweges integer,
    funktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2651 (class 1259 OID 29717)
-- Dependencies: 2652 3
-- Name: ax_fahrwegachse_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_fahrwegachse_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 2651
-- Name: ax_fahrwegachse_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_fahrwegachse_ogc_fid_seq OWNED BY ax_fahrwegachse.ogc_fid;


--
-- TOC entry 2760 (class 1259 OID 31044)
-- Dependencies: 3297 3298 3299 1087 3
-- Name: ax_felsenfelsblockfelsnadel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_felsenfelsblockfelsnadel (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    name_ character(200), --16
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2759 (class 1259 OID 31042)
-- Dependencies: 2760 3
-- Name: ax_felsenfelsblockfelsnadel_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_felsenfelsblockfelsnadel_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3607 (class 0 OID 0)
-- Dependencies: 2759
-- Name: ax_felsenfelsblockfelsnadel_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_felsenfelsblockfelsnadel_ogc_fid_seq OWNED BY ax_felsenfelsblockfelsnadel.ogc_fid;


--
-- TOC entry 2686 (class 1259 OID 30022)
-- Dependencies: 3159 3160 3161 1087 3
-- Name: ax_flaechebesondererfunktionalerpraegung; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_flaechebesondererfunktionalerpraegung (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    artderbebauung integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2685 (class 1259 OID 30020)
-- Dependencies: 2686 3
-- Name: ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3608 (class 0 OID 0)
-- Dependencies: 2685
-- Name: ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq OWNED BY ax_flaechebesondererfunktionalerpraegung.ogc_fid;


--
-- TOC entry 2688 (class 1259 OID 30038)
-- Dependencies: 3163 3164 3165 3 1087
-- Name: ax_flaechegemischternutzung; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_flaechegemischternutzung (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    artderbebauung integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2687 (class 1259 OID 30036)
-- Dependencies: 3 2688
-- Name: ax_flaechegemischternutzung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_flaechegemischternutzung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 2687
-- Name: ax_flaechegemischternutzung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_flaechegemischternutzung_ogc_fid_seq OWNED BY ax_flaechegemischternutzung.ogc_fid;


--
-- TOC entry 2740 (class 1259 OID 30616)
-- Dependencies: 3260 3261 3262 3 1087
-- Name: ax_flaechezurzeitunbestimmbar; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_flaechezurzeitunbestimmbar (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2739 (class 1259 OID 30614)
-- Dependencies: 3 2740
-- Name: ax_flaechezurzeitunbestimmbar_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_flaechezurzeitunbestimmbar_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 2739
-- Name: ax_flaechezurzeitunbestimmbar_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_flaechezurzeitunbestimmbar_ogc_fid_seq OWNED BY ax_flaechezurzeitunbestimmbar.ogc_fid;


--
-- TOC entry 2742 (class 1259 OID 30632)
-- Dependencies: 3264 3265 3266 3 1087
-- Name: ax_fliessgewaesser; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_fliessgewaesser (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    istteilvon character varying,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2741 (class 1259 OID 30630)
-- Dependencies: 2742 3
-- Name: ax_fliessgewaesser_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_fliessgewaesser_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3611 (class 0 OID 0)
-- Dependencies: 2741
-- Name: ax_fliessgewaesser_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_fliessgewaesser_ogc_fid_seq OWNED BY ax_fliessgewaesser.ogc_fid;


--
-- TOC entry 2766 (class 1259 OID 32182)
-- Dependencies: 3309 3310 3311 3 1087
-- Name: ax_flugverkehr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_flugverkehr (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    art_ integer,
    unverschluesselt character(18),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2765 (class 1259 OID 32180)
-- Dependencies: 2766 3
-- Name: ax_flugverkehr_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_flugverkehr_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 2765
-- Name: ax_flugverkehr_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_flugverkehr_ogc_fid_seq OWNED BY ax_flugverkehr.ogc_fid;


--
-- TOC entry 2768 (class 1259 OID 33034)
-- Dependencies: 3313 3314 3315 3 1087
-- Name: ax_flugverkehrsanlage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_flugverkehrsanlage (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    art_ integer,
    name_ character(200), --26
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2767 (class 1259 OID 33032)
-- Dependencies: 2768 3
-- Name: ax_flugverkehrsanlage_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_flugverkehrsanlage_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 2767
-- Name: ax_flugverkehrsanlage_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_flugverkehrsanlage_ogc_fid_seq OWNED BY ax_flugverkehrsanlage.ogc_fid;


--
-- TOC entry 2690 (class 1259 OID 30054)
-- Dependencies: 3167 3168 3169 3 1087
-- Name: ax_friedhof; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_friedhof (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2689 (class 1259 OID 30052)
-- Dependencies: 3 2690
-- Name: ax_friedhof_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_friedhof_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 2689
-- Name: ax_friedhof_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_friedhof_ogc_fid_seq OWNED BY ax_friedhof.ogc_fid;


--
-- TOC entry 2692 (class 1259 OID 30070)
-- Dependencies: 3171 3172 3173 1087 3
-- Name: ax_gebaeude; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_gebaeude (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    gebaeudefunktion integer,
    gebaeudekennzeichen character(27),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2691 (class 1259 OID 30068)
-- Dependencies: 3 2692
-- Name: ax_gebaeude_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_gebaeude_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 2691
-- Name: ax_gebaeude_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_gebaeude_ogc_fid_seq OWNED BY ax_gebaeude.ogc_fid;


--
-- TOC entry 2654 (class 1259 OID 29735)
-- Dependencies: 3099 3100 3101 1087 3
-- Name: ax_gebietsgrenze; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_gebietsgrenze (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    artdergebietsgrenze integer[],
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2653 (class 1259 OID 29733)
-- Dependencies: 2654 3
-- Name: ax_gebietsgrenze_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_gebietsgrenze_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 2653
-- Name: ax_gebietsgrenze_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_gebietsgrenze_ogc_fid_seq OWNED BY ax_gebietsgrenze.ogc_fid;


--
-- TOC entry 2694 (class 1259 OID 30128)
-- Dependencies: 3175 3176 3177 3 1087
-- Name: ax_gehoelz; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_gehoelz (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2693 (class 1259 OID 30126)
-- Dependencies: 3 2694
-- Name: ax_gehoelz_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_gehoelz_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 2693
-- Name: ax_gehoelz_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_gehoelz_ogc_fid_seq OWNED BY ax_gehoelz.ogc_fid;


--
-- TOC entry 2656 (class 1259 OID 29761)
-- Dependencies: 3103 3104 3105 3 1087
-- Name: ax_gewaesserachse; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_gewaesserachse (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    unverschluesselt character(200),
    istteilvon character varying,
    breitedesgewaessers integer,
    fliessrichtung character(5),
    hydrologischesmerkmal integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2655 (class 1259 OID 29759)
-- Dependencies: 2656 3
-- Name: ax_gewaesserachse_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_gewaesserachse_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3618 (class 0 OID 0)
-- Dependencies: 2655
-- Name: ax_gewaesserachse_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_gewaesserachse_ogc_fid_seq OWNED BY ax_gewaesserachse.ogc_fid;


--
-- TOC entry 2744 (class 1259 OID 30709)
-- Dependencies: 3268 3269 3270 3 1087
-- Name: ax_gewaessermerkmal; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_gewaessermerkmal (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    art_ integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2743 (class 1259 OID 30707)
-- Dependencies: 2744 3
-- Name: ax_gewaessermerkmal_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_gewaessermerkmal_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3619 (class 0 OID 0)
-- Dependencies: 2743
-- Name: ax_gewaessermerkmal_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_gewaessermerkmal_ogc_fid_seq OWNED BY ax_gewaessermerkmal.ogc_fid;


--
-- TOC entry 2748 (class 1259 OID 30743)
-- Dependencies: 3276 3277 3278 1087 3
-- Name: ax_gewaesserstationierungsachse; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_gewaesserstationierungsachse (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(9),
    art character(16),
    name character(11),
    artdergewaesserachse integer,
    name_ character(200), --20
    gewaesserkennzahl double precision,
    fliessrichtung character(5),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2747 (class 1259 OID 30741)
-- Dependencies: 2748 3
-- Name: ax_gewaesserstationierungsachse_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_gewaesserstationierungsachse_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3620 (class 0 OID 0)
-- Dependencies: 2747
-- Name: ax_gewaesserstationierungsachse_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_gewaesserstationierungsachse_ogc_fid_seq OWNED BY ax_gewaesserstationierungsachse.ogc_fid;


--
-- TOC entry 2774 (class 1259 OID 33730)
-- Dependencies: 3325 3326 3327 3 1087
-- Name: ax_hafen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_hafen (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    name_ character(200), --28
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2773 (class 1259 OID 33728)
-- Dependencies: 2774 3
-- Name: ax_hafen_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_hafen_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3621 (class 0 OID 0)
-- Dependencies: 2773
-- Name: ax_hafen_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_hafen_ogc_fid_seq OWNED BY ax_hafen.ogc_fid;


--
-- TOC entry 2772 (class 1259 OID 33706)
-- Dependencies: 3321 3322 3323 3 1087
-- Name: ax_hafenbecken; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_hafenbecken (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2771 (class 1259 OID 33704)
-- Dependencies: 2772 3
-- Name: ax_hafenbecken_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_hafenbecken_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3622 (class 0 OID 0)
-- Dependencies: 2771
-- Name: ax_hafenbecken_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_hafenbecken_ogc_fid_seq OWNED BY ax_hafenbecken.ogc_fid;


--
-- TOC entry 2780 (class 1259 OID 36945)
-- Dependencies: 3337 3338 3339 1087 3
-- Name: ax_halde; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_halde (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2779 (class 1259 OID 36943)
-- Dependencies: 2780 3
-- Name: ax_halde_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_halde_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3623 (class 0 OID 0)
-- Dependencies: 2779
-- Name: ax_halde_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_halde_ogc_fid_seq OWNED BY ax_halde.ogc_fid;


--
-- TOC entry 2792 (class 1259 OID 63873)
-- Dependencies: 3361 3362 3363 3 1087
-- Name: ax_heide; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_heide (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2791 (class 1259 OID 63871)
-- Dependencies: 3 2792
-- Name: ax_heide_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_heide_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 2791
-- Name: ax_heide_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_heide_ogc_fid_seq OWNED BY ax_heide.ogc_fid;


--
-- TOC entry 2658 (class 1259 OID 29777)
-- Dependencies: 3107 3108 3109 3 1087
-- Name: ax_historischesbauwerkoderhistorischeeinrichtung; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_historischesbauwerkoderhistorischeeinrichtung (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    archaeologischertyp integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2657 (class 1259 OID 29775)
-- Dependencies: 3 2658
-- Name: ax_historischesbauwerkoderhistorischeeinrichtung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_historischesbauwerkoderhistorischeeinrichtung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 2657
-- Name: ax_historischesbauwerkoderhistorischeeinrichtung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_historischesbauwerkoderhistorischeeinrichtung_ogc_fid_seq OWNED BY ax_historischesbauwerkoderhistorischeeinrichtung.ogc_fid;


--
-- TOC entry 2762 (class 1259 OID 31384)
-- Dependencies: 3301 3302 3303 3 1087
-- Name: ax_hoehleneingang; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_hoehleneingang (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2761 (class 1259 OID 31382)
-- Dependencies: 2762 3
-- Name: ax_hoehleneingang_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_hoehleneingang_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 2761
-- Name: ax_hoehleneingang_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_hoehleneingang_ogc_fid_seq OWNED BY ax_hoehleneingang.ogc_fid;


--
-- TOC entry 2696 (class 1259 OID 30185)
-- Dependencies: 3179 3180 3181 3 1087
-- Name: ax_industrieundgewerbeflaeche; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_industrieundgewerbeflaeche (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    funktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2695 (class 1259 OID 30183)
-- Dependencies: 2696 3
-- Name: ax_industrieundgewerbeflaeche_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_industrieundgewerbeflaeche_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 2695
-- Name: ax_industrieundgewerbeflaeche_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_industrieundgewerbeflaeche_ogc_fid_seq OWNED BY ax_industrieundgewerbeflaeche.ogc_fid;


--
-- TOC entry 2746 (class 1259 OID 30727)
-- Dependencies: 3272 3273 3274 3 1087
-- Name: ax_insel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_insel (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2745 (class 1259 OID 30725)
-- Dependencies: 3 2746
-- Name: ax_insel_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_insel_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 2745
-- Name: ax_insel_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_insel_ogc_fid_seq OWNED BY ax_insel.ogc_fid;


--
-- TOC entry 2794 (class 1259 OID 69842)
-- Dependencies: 3
-- Name: ax_kanal; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_kanal (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    name_ character(200), --9
    gewaesserkennzahl double precision,
    schifffahrtskategorie integer
);

-- keine Geometrie, daher ersatzweise: Dummy-Eintrag in Metatabelle - siehe ALKIS
INSERT INTO geometry_columns
   (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_kanal', 'dummy', 2, 25832, 'POINT');

--
-- TOC entry 2793 (class 1259 OID 69840)
-- Dependencies: 2794 3
-- Name: ax_kanal_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_kanal_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 2793
-- Name: ax_kanal_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_kanal_ogc_fid_seq OWNED BY ax_kanal.ogc_fid;


--
-- TOC entry 2660 (class 1259 OID 29793)
-- Dependencies: 3111 3112 3113 3 1087
-- Name: ax_kommunalesgebiet; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_kommunalesgebiet (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(9),
    art character(16),
    name character(11),
    schluesselgesamt integer,
    land integer,
    regierungsbezirk integer,
    kreis integer,
    gemeinde integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2659 (class 1259 OID 29791)
-- Dependencies: 3 2660
-- Name: ax_kommunalesgebiet_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_kommunalesgebiet_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 2659
-- Name: ax_kommunalesgebiet_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_kommunalesgebiet_ogc_fid_seq OWNED BY ax_kommunalesgebiet.ogc_fid;


--
-- TOC entry 2788 (class 1259 OID 61522)
-- Dependencies: 3353 3354 3355 3 1087
-- Name: ax_kondominium; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_kondominium (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(9),
    art character(16),
    name character(11),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2787 (class 1259 OID 61520)
-- Dependencies: 2788 3
-- Name: ax_kondominium_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_kondominium_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 2787
-- Name: ax_kondominium_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_kondominium_ogc_fid_seq OWNED BY ax_kondominium.ogc_fid;


--
-- TOC entry 2662 (class 1259 OID 29815)
-- Dependencies: 3115 3116 3117 3 1087
-- Name: ax_landwirtschaft; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_landwirtschaft (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    vegetationsmerkmal integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2661 (class 1259 OID 29813)
-- Dependencies: 3 2662
-- Name: ax_landwirtschaft_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_landwirtschaft_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3632 (class 0 OID 0)
-- Dependencies: 2661
-- Name: ax_landwirtschaft_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_landwirtschaft_ogc_fid_seq OWNED BY ax_landwirtschaft.ogc_fid;


--
-- TOC entry 2750 (class 1259 OID 30811)
-- Dependencies: 3280 3281 3282 3 1087
-- Name: ax_leitung; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_leitung (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    bauwerksfunktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2749 (class 1259 OID 30809)
-- Dependencies: 2750 3
-- Name: ax_leitung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_leitung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3633 (class 0 OID 0)
-- Dependencies: 2749
-- Name: ax_leitung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_leitung_ogc_fid_seq OWNED BY ax_leitung.ogc_fid;


--
-- TOC entry 2786 (class 1259 OID 51734)
-- Dependencies: 3349 3350 3351 3 1087
-- Name: ax_moor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_moor (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2785 (class 1259 OID 51732)
-- Dependencies: 3 2786
-- Name: ax_moor_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_moor_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3634 (class 0 OID 0)
-- Dependencies: 2785
-- Name: ax_moor_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_moor_ogc_fid_seq OWNED BY ax_moor.ogc_fid;


--
-- TOC entry 2664 (class 1259 OID 29835)
-- Dependencies: 3119 3120 3121 1087 3
-- Name: ax_naturumweltoderbodenschutzrecht; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_naturumweltoderbodenschutzrecht (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    artderfestlegung integer,
    name_ character(200), --15
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2663 (class 1259 OID 29833)
-- Dependencies: 2664 3
-- Name: ax_naturumweltoderbodenschutzrecht_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_naturumweltoderbodenschutzrecht_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3635 (class 0 OID 0)
-- Dependencies: 2663
-- Name: ax_naturumweltoderbodenschutzrecht_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_naturumweltoderbodenschutzrecht_ogc_fid_seq OWNED BY ax_naturumweltoderbodenschutzrecht.ogc_fid;


--
-- TOC entry 2730 (class 1259 OID 30544)
-- Dependencies: 3
-- Name: ax_netzknoten; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_netzknoten (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(9),
    art character(16),
    name character(7),
    bezeichnung integer
);

-- keine Geometrie, daher ersatzweise: Dummy-Eintrag in Metatabelle - siehe ALKIS
INSERT INTO geometry_columns
   (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_netzknoten', 'dummy', 2, 25832, 'POINT');

--
-- TOC entry 2729 (class 1259 OID 30542)
-- Dependencies: 2730 3
-- Name: ax_netzknoten_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_netzknoten_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3636 (class 0 OID 0)
-- Dependencies: 2729
-- Name: ax_netzknoten_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_netzknoten_ogc_fid_seq OWNED BY ax_netzknoten.ogc_fid;


--
-- TOC entry 2704 (class 1259 OID 30313)
-- Dependencies: 3195 3196 3197 3 1087
-- Name: ax_nullpunkt; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_nullpunkt (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(9),
    art character(16),
    name character(11),
    istteilvon character varying,
    artdesnullpunktes integer,
    bezeichnung character(200), --8
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2703 (class 1259 OID 30311)
-- Dependencies: 3 2704
-- Name: ax_nullpunkt_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_nullpunkt_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3637 (class 0 OID 0)
-- Dependencies: 2703
-- Name: ax_nullpunkt_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_nullpunkt_ogc_fid_seq OWNED BY ax_nullpunkt.ogc_fid;


--
-- TOC entry 2700 (class 1259 OID 30279)
-- Dependencies: 3187 3188 3189 1087 3
-- Name: ax_ortslage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_ortslage (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character(9),
    art character(16),
    name character(11),
    name_ character(200), --13
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2699 (class 1259 OID 30277)
-- Dependencies: 2700 3
-- Name: ax_ortslage_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_ortslage_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3638 (class 0 OID 0)
-- Dependencies: 2699
-- Name: ax_ortslage_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_ortslage_ogc_fid_seq OWNED BY ax_ortslage.ogc_fid;


--
-- TOC entry 2698 (class 1259 OID 30263)
-- Dependencies: 3183 3184 3185 1087 3
-- Name: ax_platz; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_platz (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    funktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2697 (class 1259 OID 30261)
-- Dependencies: 3 2698
-- Name: ax_platz_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_platz_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3639 (class 0 OID 0)
-- Dependencies: 2697
-- Name: ax_platz_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_platz_ogc_fid_seq OWNED BY ax_platz.ogc_fid;


--
-- TOC entry 2752 (class 1259 OID 30842)
-- Dependencies: 3284 3285 3286 3 1087
-- Name: ax_schifffahrtsliniefaehrverkehr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_schifffahrtsliniefaehrverkehr (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    art_ integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2751 (class 1259 OID 30840)
-- Dependencies: 2752 3
-- Name: ax_schifffahrtsliniefaehrverkehr_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_schifffahrtsliniefaehrverkehr_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3640 (class 0 OID 0)
-- Dependencies: 2751
-- Name: ax_schifffahrtsliniefaehrverkehr_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_schifffahrtsliniefaehrverkehr_ogc_fid_seq OWNED BY ax_schifffahrtsliniefaehrverkehr.ogc_fid;


--
-- TOC entry 2776 (class 1259 OID 33862)
-- Dependencies: 3329 3330 3331 3 1087
-- Name: ax_schiffsverkehr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_schiffsverkehr (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    funktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2775 (class 1259 OID 33860)
-- Dependencies: 3 2776
-- Name: ax_schiffsverkehr_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_schiffsverkehr_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3641 (class 0 OID 0)
-- Dependencies: 2775
-- Name: ax_schiffsverkehr_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_schiffsverkehr_ogc_fid_seq OWNED BY ax_schiffsverkehr.ogc_fid;


--
-- TOC entry 2790 (class 1259 OID 61541)
-- Dependencies: 3357 3358 3359 3 1087
-- Name: ax_schleuse; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_schleuse (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    konstruktionsmerkmalbauart integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2789 (class 1259 OID 61539)
-- Dependencies: 2790 3
-- Name: ax_schleuse_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_schleuse_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3642 (class 0 OID 0)
-- Dependencies: 2789
-- Name: ax_schleuse_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_schleuse_ogc_fid_seq OWNED BY ax_schleuse.ogc_fid;


--
-- TOC entry 2782 (class 1259 OID 40021)
-- Dependencies: 3341 3342 3343 3 1087
-- Name: ax_seilbahnschwebebahn; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_seilbahnschwebebahn (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    bahnkategorie integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2781 (class 1259 OID 40019)
-- Dependencies: 2782 3
-- Name: ax_seilbahnschwebebahn_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_seilbahnschwebebahn_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3643 (class 0 OID 0)
-- Dependencies: 2781
-- Name: ax_seilbahnschwebebahn_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_seilbahnschwebebahn_ogc_fid_seq OWNED BY ax_seilbahnschwebebahn.ogc_fid;


--
-- TOC entry 2702 (class 1259 OID 30297)
-- Dependencies: 3191 3192 3193 1087 3
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_sonstigesbauwerkodersonstigeeinrichtung (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    bauwerksfunktion integer,
    name_ character(200), --13
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2701 (class 1259 OID 30295)
-- Dependencies: 3 2702
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3644 (class 0 OID 0)
-- Dependencies: 2701
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq OWNED BY ax_sonstigesbauwerkodersonstigeeinrichtung.ogc_fid;


--
-- TOC entry 2784 (class 1259 OID 40092)
-- Dependencies: 3345 3346 3347 3 1087
-- Name: ax_sonstigesrecht; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_sonstigesrecht (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    artderfestlegung integer,
    name_ character(200), --12
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2783 (class 1259 OID 40090)
-- Dependencies: 3 2784
-- Name: ax_sonstigesrecht_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_sonstigesrecht_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3645 (class 0 OID 0)
-- Dependencies: 2783
-- Name: ax_sonstigesrecht_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_sonstigesrecht_ogc_fid_seq OWNED BY ax_sonstigesrecht.ogc_fid;


--
-- TOC entry 2706 (class 1259 OID 30329)
-- Dependencies: 3199 3200 3201 1087 3
-- Name: ax_sportfreizeitunderholungsflaeche; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_sportfreizeitunderholungsflaeche (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    funktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2705 (class 1259 OID 30327)
-- Dependencies: 3 2706
-- Name: ax_sportfreizeitunderholungsflaeche_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_sportfreizeitunderholungsflaeche_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3646 (class 0 OID 0)
-- Dependencies: 2705
-- Name: ax_sportfreizeitunderholungsflaeche_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_sportfreizeitunderholungsflaeche_ogc_fid_seq OWNED BY ax_sportfreizeitunderholungsflaeche.ogc_fid;


--
-- TOC entry 2708 (class 1259 OID 30345)
-- Dependencies: 3203 3204 3205 1087 3
-- Name: ax_stehendesgewaesser; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_stehendesgewaesser (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    name_ character(200),
    unverschluesselt character(200),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2707 (class 1259 OID 30343)
-- Dependencies: 3 2708
-- Name: ax_stehendesgewaesser_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_stehendesgewaesser_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3647 (class 0 OID 0)
-- Dependencies: 2707
-- Name: ax_stehendesgewaesser_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_stehendesgewaesser_ogc_fid_seq OWNED BY ax_stehendesgewaesser.ogc_fid;


--
-- TOC entry 2728 (class 1259 OID 30533)
-- Dependencies: 3
-- Name: ax_strasse; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_strasse (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character varying[],
    name character varying[],
    name_ character(200), --19
    widmung integer,
    strassenschluessel double precision,
    bezeichnung character(200), --4
    fahrbahntrennung integer
);

-- keine Geometrie, daher ersatzweise: Dummy-Eintrag in Metatabelle - siehe ALKIS
INSERT INTO geometry_columns
   (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_strasse', 'dummy', 2, 25832, 'POINT');



--
-- TOC entry 2727 (class 1259 OID 30531)
-- Dependencies: 2728 3
-- Name: ax_strasse_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_strasse_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3648 (class 0 OID 0)
-- Dependencies: 2727
-- Name: ax_strasse_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_strasse_ogc_fid_seq OWNED BY ax_strasse.ogc_fid;


--
-- TOC entry 2710 (class 1259 OID 30361)
-- Dependencies: 3207 3208 3209 1087 3
-- Name: ax_strassenachse; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_strassenachse (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    istteilvon character varying,
    hatdirektunten character varying,
    breitederfahrbahn double precision,
    anzahlderfahrstreifen integer,
    verkehrsbedeutunginneroertlich integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2709 (class 1259 OID 30359)
-- Dependencies: 2710 3
-- Name: ax_strassenachse_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_strassenachse_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3649 (class 0 OID 0)
-- Dependencies: 2709
-- Name: ax_strassenachse_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_strassenachse_ogc_fid_seq OWNED BY ax_strassenachse.ogc_fid;


--
-- TOC entry 2712 (class 1259 OID 30377)
-- Dependencies: 3211 3212 3213 1087 3
-- Name: ax_strassenverkehr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_strassenverkehr (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    funktion integer,
    hatdirektunten character varying,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2711 (class 1259 OID 30375)
-- Dependencies: 3 2712
-- Name: ax_strassenverkehr_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_strassenverkehr_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3650 (class 0 OID 0)
-- Dependencies: 2711
-- Name: ax_strassenverkehr_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_strassenverkehr_ogc_fid_seq OWNED BY ax_strassenverkehr.ogc_fid;


--
-- TOC entry 2720 (class 1259 OID 30441)
-- Dependencies: 3227 3228 3229 1087 3
-- Name: ax_strassenverkehrsanlage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_strassenverkehrsanlage (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    art_ integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2719 (class 1259 OID 30439)
-- Dependencies: 3 2720
-- Name: ax_strassenverkehrsanlage_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_strassenverkehrsanlage_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3651 (class 0 OID 0)
-- Dependencies: 2719
-- Name: ax_strassenverkehrsanlage_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_strassenverkehrsanlage_ogc_fid_seq OWNED BY ax_strassenverkehrsanlage.ogc_fid;


--
-- TOC entry 2778 (class 1259 OID 34082)
-- Dependencies: 3333 3334 3335 3 1087
-- Name: ax_sumpf; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_sumpf (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2777 (class 1259 OID 34080)
-- Dependencies: 3 2778
-- Name: ax_sumpf_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_sumpf_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3652 (class 0 OID 0)
-- Dependencies: 2777
-- Name: ax_sumpf_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_sumpf_ogc_fid_seq OWNED BY ax_sumpf.ogc_fid;


--
-- TOC entry 2754 (class 1259 OID 30887)
-- Dependencies: 3288 3289 3290 1087 3
-- Name: ax_tagebaugrubesteinbruch; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_tagebaugrubesteinbruch (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2753 (class 1259 OID 30885)
-- Dependencies: 2754 3
-- Name: ax_tagebaugrubesteinbruch_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_tagebaugrubesteinbruch_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3653 (class 0 OID 0)
-- Dependencies: 2753
-- Name: ax_tagebaugrubesteinbruch_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_tagebaugrubesteinbruch_ogc_fid_seq OWNED BY ax_tagebaugrubesteinbruch.ogc_fid;


--
-- TOC entry 2718 (class 1259 OID 30425)
-- Dependencies: 3223 3224 3225 3 1087
-- Name: ax_transportanlage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_transportanlage (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    bauwerksfunktion integer,
    produkt integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2717 (class 1259 OID 30423)
-- Dependencies: 3 2718
-- Name: ax_transportanlage_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_transportanlage_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3654 (class 0 OID 0)
-- Dependencies: 2717
-- Name: ax_transportanlage_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_transportanlage_ogc_fid_seq OWNED BY ax_transportanlage.ogc_fid;


--
-- TOC entry 2716 (class 1259 OID 30409)
-- Dependencies: 3219 3220 3221 3 1087
-- Name: ax_turm; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_turm (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    bauwerksfunktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    --CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2715 (class 1259 OID 30407)
-- Dependencies: 2716 3
-- Name: ax_turm_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_turm_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3655 (class 0 OID 0)
-- Dependencies: 2715
-- Name: ax_turm_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_turm_ogc_fid_seq OWNED BY ax_turm.ogc_fid;


--
-- TOC entry 2714 (class 1259 OID 30393)
-- Dependencies: 3215 3216 3217 1087 3
-- Name: ax_unlandvegetationsloseflaeche; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_unlandvegetationsloseflaeche (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    funktion integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2713 (class 1259 OID 30391)
-- Dependencies: 3 2714
-- Name: ax_unlandvegetationsloseflaeche_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_unlandvegetationsloseflaeche_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3656 (class 0 OID 0)
-- Dependencies: 2713
-- Name: ax_unlandvegetationsloseflaeche_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_unlandvegetationsloseflaeche_ogc_fid_seq OWNED BY ax_unlandvegetationsloseflaeche.ogc_fid;


--
-- TOC entry 2722 (class 1259 OID 30457)
-- Dependencies: 3231 3232 3 1087
-- Name: ax_vegetationsmerkmal; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_vegetationsmerkmal (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    bewuchs integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2721 (class 1259 OID 30455)
-- Dependencies: 3 2722
-- Name: ax_vegetationsmerkmal_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_vegetationsmerkmal_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3657 (class 0 OID 0)
-- Dependencies: 2721
-- Name: ax_vegetationsmerkmal_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_vegetationsmerkmal_ogc_fid_seq OWNED BY ax_vegetationsmerkmal.ogc_fid;


--
-- TOC entry 2666 (class 1259 OID 29861)
-- Dependencies: 3123 3124 3125 3 1087
-- Name: ax_wald; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_wald (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    vegetationsmerkmal integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2665 (class 1259 OID 29859)
-- Dependencies: 3 2666
-- Name: ax_wald_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_wald_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3658 (class 0 OID 0)
-- Dependencies: 2665
-- Name: ax_wald_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_wald_ogc_fid_seq OWNED BY ax_wald.ogc_fid;


--
-- TOC entry 2756 (class 1259 OID 30987)
-- Dependencies: 3
-- Name: ax_wasserlauf; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_wasserlauf (
    ogc_fid integer NOT NULL,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    name_ character(200), --20
    unverschluesselt character(200), --null
    gewaesserkennzahl double precision
);

-- keine Geometrie, daher ersatzweise: Dummy-Eintrag in Metatabelle - siehe ALKIS
INSERT INTO geometry_columns
   (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, type)
VALUES ('', 'public', 'ax_wasserlauf', 'dummy', 2, 25832, 'POINT');

--
-- TOC entry 2755 (class 1259 OID 30985)
-- Dependencies: 2756 3
-- Name: ax_wasserlauf_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_wasserlauf_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3659 (class 0 OID 0)
-- Dependencies: 2755
-- Name: ax_wasserlauf_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_wasserlauf_ogc_fid_seq OWNED BY ax_wasserlauf.ogc_fid;


--
-- TOC entry 2764 (class 1259 OID 32124)
-- Dependencies: 3305 3306 3307 3 1087
-- Name: ax_wasserspiegelhoehe; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_wasserspiegelhoehe (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    hoehedeswasserspiegels double precision,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2763 (class 1259 OID 32122)
-- Dependencies: 3 2764
-- Name: ax_wasserspiegelhoehe_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_wasserspiegelhoehe_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3660 (class 0 OID 0)
-- Dependencies: 2763
-- Name: ax_wasserspiegelhoehe_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_wasserspiegelhoehe_ogc_fid_seq OWNED BY ax_wasserspiegelhoehe.ogc_fid;


--
-- TOC entry 2668 (class 1259 OID 29883)
-- Dependencies: 3127 3128 3129 3 1087
-- Name: ax_wegpfadsteig; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_wegpfadsteig (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    art_ integer,
    breitedesverkehrsweges integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'LINESTRING'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2667 (class 1259 OID 29881)
-- Dependencies: 2668 3
-- Name: ax_wegpfadsteig_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_wegpfadsteig_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3661 (class 0 OID 0)
-- Dependencies: 2667
-- Name: ax_wegpfadsteig_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_wegpfadsteig_ogc_fid_seq OWNED BY ax_wegpfadsteig.ogc_fid;


--
-- TOC entry 2724 (class 1259 OID 30501)
-- Dependencies: 3234 3235 3236 1087 3
-- Name: ax_wohnbauflaeche; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_wohnbauflaeche (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    artderbebauung integer,
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2723 (class 1259 OID 30499)
-- Dependencies: 2724 3
-- Name: ax_wohnbauflaeche_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_wohnbauflaeche_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3662 (class 0 OID 0)
-- Dependencies: 2723
-- Name: ax_wohnbauflaeche_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_wohnbauflaeche_ogc_fid_seq OWNED BY ax_wohnbauflaeche.ogc_fid;


--
-- TOC entry 2726 (class 1259 OID 30517)
-- Dependencies: 3238 3239 3240 3 1087
-- Name: ax_wohnplatz; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ax_wohnplatz (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry,
    gml_id character(16),
    identifier character(28),
    beginnt character(20),
    advstandardmodell character varying[],
    art character(16),
    name character(11),
    bezeichnung double precision[],
    name_ character(200), --28
    CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)),
    CONSTRAINT enforce_geotype_wkb_geometry CHECK (((geometrytype(wkb_geometry) = 'POINT'::text) OR (wkb_geometry IS NULL))),
    CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 25832))
);


--
-- TOC entry 2725 (class 1259 OID 30515)
-- Dependencies: 2726 3
-- Name: ax_wohnplatz_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ax_wohnplatz_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 3663 (class 0 OID 0)
-- Dependencies: 2725
-- Name: ax_wohnplatz_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ax_wohnplatz_ogc_fid_seq OWNED BY ax_wohnplatz.ogc_fid;

--
-- TOC entry 3130 (class 2604 OID 29902)
-- Dependencies: 2669 2670 2670
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE alkis_beziehungen ALTER COLUMN ogc_fid SET DEFAULT nextval('alkis_beziehungen_ogc_fid_seq'::regclass);


--
-- TOC entry 3131 (class 2604 OID 29914)
-- Dependencies: 2672 2671 2672
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_abschnitt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_abschnitt_ogc_fid_seq'::regclass);


--
-- TOC entry 3135 (class 2604 OID 29930)
-- Dependencies: 2673 2674 2674
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_ast ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_ast_ogc_fid_seq'::regclass);


--
-- TOC entry 3247 (class 2604 OID 30571)
-- Dependencies: 2733 2734 2734
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_bahnstrecke ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bahnstrecke_ogc_fid_seq'::regclass);


--
-- TOC entry 3316 (class 2604 OID 33472)
-- Dependencies: 2770 2769 2770
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_bahnverkehr ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bahnverkehr_ogc_fid_seq'::regclass);


--
-- TOC entry 3243 (class 2604 OID 30555)
-- Dependencies: 2732 2731 2732
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_bahnverkehrsanlage ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bahnverkehrsanlage_ogc_fid_seq'::regclass);


--
-- TOC entry 3139 (class 2604 OID 29946)
-- Dependencies: 2675 2676 2676
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_bauwerkimgewaesserbereich ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bauwerkimgewaesserbereich_ogc_fid_seq'::regclass);


--
-- TOC entry 3147 (class 2604 OID 29978)
-- Dependencies: 2680 2679 2680
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_bauwerkimverkehrsbereich ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bauwerkimverkehrsbereich_ogc_fid_seq'::regclass);


--
-- TOC entry 3150 (class 2604 OID 29993)
-- Dependencies: 2682 2681 2682
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_bauwerkoderanlagefuerindustrieundgewerbe ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bauwerkoderanlagefuerindustrieundgewerbe_ogc_fid_seq'::regclass);


--
-- TOC entry 3143 (class 2604 OID 29962)
-- Dependencies: 2677 2678 2678
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_bauwerkoderanlagefuersportfreizeitunderholung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bauwerkoderanlagefuersportfreizeitunderholung_ogc_fid_seq'::regclass);


--
-- TOC entry 3365 (class 2604 OID 133068)
-- Dependencies: 2796 2795 2796
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_bergbaubetrieb ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_bergbaubetrieb_ogc_fid_seq'::regclass);


--
-- TOC entry 3255 (class 2604 OID 30603)
-- Dependencies: 2738 2737 2738
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_dammwalldeich ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_dammwalldeich_ogc_fid_seq'::regclass);


--
-- TOC entry 3292 (class 2604 OID 31001)
-- Dependencies: 2757 2758 2758
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_denkmalschutzrecht ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_denkmalschutzrecht_ogc_fid_seq'::regclass);


--
-- TOC entry 3251 (class 2604 OID 30587)
-- Dependencies: 2735 2736 2736
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_einrichtungenfuerdenschiffsverkehr ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_einrichtungenfuerdenschiffsverkehr_ogc_fid_seq'::regclass);


--
-- TOC entry 3154 (class 2604 OID 30009)
-- Dependencies: 2683 2684 2684
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_fahrbahnachse ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_fahrbahnachse_ogc_fid_seq'::regclass);


--
-- TOC entry 3094 (class 2604 OID 29722)
-- Dependencies: 2651 2652 2652
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_fahrwegachse ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_fahrwegachse_ogc_fid_seq'::regclass);


--
-- TOC entry 3296 (class 2604 OID 31047)
-- Dependencies: 2759 2760 2760
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_felsenfelsblockfelsnadel ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_felsenfelsblockfelsnadel_ogc_fid_seq'::regclass);


--
-- TOC entry 3158 (class 2604 OID 30025)
-- Dependencies: 2686 2685 2686
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_flaechebesondererfunktionalerpraegung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_flaechebesondererfunktionalerpraegung_ogc_fid_seq'::regclass);


--
-- TOC entry 3162 (class 2604 OID 30041)
-- Dependencies: 2688 2687 2688
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_flaechegemischternutzung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_flaechegemischternutzung_ogc_fid_seq'::regclass);


--
-- TOC entry 3259 (class 2604 OID 30619)
-- Dependencies: 2740 2739 2740
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_flaechezurzeitunbestimmbar ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_flaechezurzeitunbestimmbar_ogc_fid_seq'::regclass);


--
-- TOC entry 3263 (class 2604 OID 30635)
-- Dependencies: 2741 2742 2742
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_fliessgewaesser ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_fliessgewaesser_ogc_fid_seq'::regclass);


--
-- TOC entry 3308 (class 2604 OID 32185)
-- Dependencies: 2765 2766 2766
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_flugverkehr ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_flugverkehr_ogc_fid_seq'::regclass);


--
-- TOC entry 3312 (class 2604 OID 33037)
-- Dependencies: 2767 2768 2768
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_flugverkehrsanlage ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_flugverkehrsanlage_ogc_fid_seq'::regclass);


--
-- TOC entry 3166 (class 2604 OID 30057)
-- Dependencies: 2689 2690 2690
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_friedhof ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_friedhof_ogc_fid_seq'::regclass);


--
-- TOC entry 3170 (class 2604 OID 30073)
-- Dependencies: 2692 2691 2692
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_gebaeude ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gebaeude_ogc_fid_seq'::regclass);


--
-- TOC entry 3098 (class 2604 OID 29738)
-- Dependencies: 2653 2654 2654
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_gebietsgrenze ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gebietsgrenze_ogc_fid_seq'::regclass);


--
-- TOC entry 3174 (class 2604 OID 30131)
-- Dependencies: 2694 2693 2694
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_gehoelz ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gehoelz_ogc_fid_seq'::regclass);


--
-- TOC entry 3102 (class 2604 OID 29764)
-- Dependencies: 2656 2655 2656
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_gewaesserachse ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gewaesserachse_ogc_fid_seq'::regclass);


--
-- TOC entry 3267 (class 2604 OID 30712)
-- Dependencies: 2744 2743 2744
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_gewaessermerkmal ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gewaessermerkmal_ogc_fid_seq'::regclass);


--
-- TOC entry 3275 (class 2604 OID 30746)
-- Dependencies: 2748 2747 2748
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_gewaesserstationierungsachse ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_gewaesserstationierungsachse_ogc_fid_seq'::regclass);


--
-- TOC entry 3324 (class 2604 OID 33733)
-- Dependencies: 2774 2773 2774
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_hafen ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_hafen_ogc_fid_seq'::regclass);


--
-- TOC entry 3320 (class 2604 OID 33709)
-- Dependencies: 2771 2772 2772
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_hafenbecken ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_hafenbecken_ogc_fid_seq'::regclass);


--
-- TOC entry 3336 (class 2604 OID 36948)
-- Dependencies: 2779 2780 2780
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_halde ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_halde_ogc_fid_seq'::regclass);


--
-- TOC entry 3360 (class 2604 OID 63876)
-- Dependencies: 2791 2792 2792
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_heide ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_heide_ogc_fid_seq'::regclass);


--
-- TOC entry 3106 (class 2604 OID 29780)
-- Dependencies: 2658 2657 2658
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_historischesbauwerkoderhistorischeeinrichtung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_historischesbauwerkoderhistorischeeinrichtung_ogc_fid_seq'::regclass);


--
-- TOC entry 3300 (class 2604 OID 31387)
-- Dependencies: 2761 2762 2762
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_hoehleneingang ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_hoehleneingang_ogc_fid_seq'::regclass);


--
-- TOC entry 3178 (class 2604 OID 30188)
-- Dependencies: 2695 2696 2696
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_industrieundgewerbeflaeche ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_industrieundgewerbeflaeche_ogc_fid_seq'::regclass);


--
-- TOC entry 3271 (class 2604 OID 30730)
-- Dependencies: 2746 2745 2746
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_insel ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_insel_ogc_fid_seq'::regclass);


--
-- TOC entry 3364 (class 2604 OID 69845)
-- Dependencies: 2793 2794 2794
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_kanal ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_kanal_ogc_fid_seq'::regclass);


--
-- TOC entry 3110 (class 2604 OID 29796)
-- Dependencies: 2660 2659 2660
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_kommunalesgebiet ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_kommunalesgebiet_ogc_fid_seq'::regclass);


--
-- TOC entry 3352 (class 2604 OID 61525)
-- Dependencies: 2788 2787 2788
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_kondominium ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_kondominium_ogc_fid_seq'::regclass);


--
-- TOC entry 3114 (class 2604 OID 29818)
-- Dependencies: 2662 2661 2662
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_landwirtschaft ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_landwirtschaft_ogc_fid_seq'::regclass);


--
-- TOC entry 3279 (class 2604 OID 30814)
-- Dependencies: 2750 2749 2750
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_leitung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_leitung_ogc_fid_seq'::regclass);


--
-- TOC entry 3348 (class 2604 OID 51737)
-- Dependencies: 2785 2786 2786
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_moor ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_moor_ogc_fid_seq'::regclass);


--
-- TOC entry 3118 (class 2604 OID 29838)
-- Dependencies: 2664 2663 2664
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_naturumweltoderbodenschutzrecht ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_naturumweltoderbodenschutzrecht_ogc_fid_seq'::regclass);


--
-- TOC entry 3242 (class 2604 OID 30547)
-- Dependencies: 2730 2729 2730
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_netzknoten ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_netzknoten_ogc_fid_seq'::regclass);


--
-- TOC entry 3194 (class 2604 OID 30316)
-- Dependencies: 2703 2704 2704
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_nullpunkt ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_nullpunkt_ogc_fid_seq'::regclass);


--
-- TOC entry 3186 (class 2604 OID 30282)
-- Dependencies: 2699 2700 2700
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_ortslage ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_ortslage_ogc_fid_seq'::regclass);


--
-- TOC entry 3182 (class 2604 OID 30266)
-- Dependencies: 2697 2698 2698
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_platz ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_platz_ogc_fid_seq'::regclass);


--
-- TOC entry 3283 (class 2604 OID 30845)
-- Dependencies: 2752 2751 2752
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_schifffahrtsliniefaehrverkehr ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_schifffahrtsliniefaehrverkehr_ogc_fid_seq'::regclass);


--
-- TOC entry 3328 (class 2604 OID 33865)
-- Dependencies: 2775 2776 2776
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_schiffsverkehr ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_schiffsverkehr_ogc_fid_seq'::regclass);


--
-- TOC entry 3356 (class 2604 OID 61544)
-- Dependencies: 2790 2789 2790
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_schleuse ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_schleuse_ogc_fid_seq'::regclass);


--
-- TOC entry 3340 (class 2604 OID 40024)
-- Dependencies: 2782 2781 2782
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_seilbahnschwebebahn ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_seilbahnschwebebahn_ogc_fid_seq'::regclass);


--
-- TOC entry 3190 (class 2604 OID 30300)
-- Dependencies: 2701 2702 2702
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_sonstigesbauwerkodersonstigeeinrichtung ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_sonstigesbauwerkodersonstigeeinrichtung_ogc_fid_seq'::regclass);


--
-- TOC entry 3344 (class 2604 OID 40095)
-- Dependencies: 2783 2784 2784
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_sonstigesrecht ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_sonstigesrecht_ogc_fid_seq'::regclass);


--
-- TOC entry 3198 (class 2604 OID 30332)
-- Dependencies: 2706 2705 2706
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_sportfreizeitunderholungsflaeche ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_sportfreizeitunderholungsflaeche_ogc_fid_seq'::regclass);


--
-- TOC entry 3202 (class 2604 OID 30348)
-- Dependencies: 2707 2708 2708
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_stehendesgewaesser ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_stehendesgewaesser_ogc_fid_seq'::regclass);


--
-- TOC entry 3241 (class 2604 OID 30536)
-- Dependencies: 2727 2728 2728
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_strasse ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_strasse_ogc_fid_seq'::regclass);


--
-- TOC entry 3206 (class 2604 OID 30364)
-- Dependencies: 2710 2709 2710
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_strassenachse ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_strassenachse_ogc_fid_seq'::regclass);


--
-- TOC entry 3210 (class 2604 OID 30380)
-- Dependencies: 2712 2711 2712
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_strassenverkehr ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_strassenverkehr_ogc_fid_seq'::regclass);


--
-- TOC entry 3226 (class 2604 OID 30444)
-- Dependencies: 2720 2719 2720
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_strassenverkehrsanlage ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_strassenverkehrsanlage_ogc_fid_seq'::regclass);


--
-- TOC entry 3332 (class 2604 OID 34085)
-- Dependencies: 2777 2778 2778
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_sumpf ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_sumpf_ogc_fid_seq'::regclass);


--
-- TOC entry 3287 (class 2604 OID 30890)
-- Dependencies: 2753 2754 2754
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_tagebaugrubesteinbruch ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_tagebaugrubesteinbruch_ogc_fid_seq'::regclass);


--
-- TOC entry 3222 (class 2604 OID 30428)
-- Dependencies: 2717 2718 2718
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_transportanlage ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_transportanlage_ogc_fid_seq'::regclass);


--
-- TOC entry 3218 (class 2604 OID 30412)
-- Dependencies: 2715 2716 2716
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_turm ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_turm_ogc_fid_seq'::regclass);


--
-- TOC entry 3214 (class 2604 OID 30396)
-- Dependencies: 2713 2714 2714
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_unlandvegetationsloseflaeche ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_unlandvegetationsloseflaeche_ogc_fid_seq'::regclass);


--
-- TOC entry 3230 (class 2604 OID 30460)
-- Dependencies: 2722 2721 2722
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_vegetationsmerkmal ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_vegetationsmerkmal_ogc_fid_seq'::regclass);


--
-- TOC entry 3122 (class 2604 OID 29864)
-- Dependencies: 2666 2665 2666
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_wald ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_wald_ogc_fid_seq'::regclass);


--
-- TOC entry 3291 (class 2604 OID 30990)
-- Dependencies: 2756 2755 2756
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_wasserlauf ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_wasserlauf_ogc_fid_seq'::regclass);


--
-- TOC entry 3304 (class 2604 OID 32127)
-- Dependencies: 2764 2763 2764
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_wasserspiegelhoehe ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_wasserspiegelhoehe_ogc_fid_seq'::regclass);


--
-- TOC entry 3126 (class 2604 OID 29886)
-- Dependencies: 2667 2668 2668
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_wegpfadsteig ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_wegpfadsteig_ogc_fid_seq'::regclass);


--
-- TOC entry 3233 (class 2604 OID 30504)
-- Dependencies: 2724 2723 2724
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_wohnbauflaeche ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_wohnbauflaeche_ogc_fid_seq'::regclass);


--
-- TOC entry 3237 (class 2604 OID 30520)
-- Dependencies: 2725 2726 2726
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ax_wohnplatz ALTER COLUMN ogc_fid SET DEFAULT nextval('ax_wohnplatz_ogc_fid_seq'::regclass);


--
-- TOC entry 3401 (class 2606 OID 29904)
-- Dependencies: 2670 2670
-- Name: alkis_beziehungen_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY alkis_beziehungen
    ADD CONSTRAINT alkis_beziehungen_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3404 (class 2606 OID 29916)
-- Dependencies: 2672 2672
-- Name: ax_abschnitt_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_abschnitt
    ADD CONSTRAINT ax_abschnitt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3407 (class 2606 OID 29932)
-- Dependencies: 2674 2674
-- Name: ax_ast_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_ast
    ADD CONSTRAINT ax_ast_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3495 (class 2606 OID 30573)
-- Dependencies: 2734 2734
-- Name: ax_bahnstrecke_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_bahnstrecke
    ADD CONSTRAINT ax_bahnstrecke_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3548 (class 2606 OID 33474)
-- Dependencies: 2770 2770
-- Name: ax_bahnverkehr_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_bahnverkehr
    ADD CONSTRAINT ax_bahnverkehr_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3492 (class 2606 OID 30557)
-- Dependencies: 2732 2732
-- Name: ax_bahnverkehrsanlage_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_bahnverkehrsanlage
    ADD CONSTRAINT ax_bahnverkehrsanlage_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3410 (class 2606 OID 29948)
-- Dependencies: 2676 2676
-- Name: ax_bauwerkimgewaesserbereich_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_bauwerkimgewaesserbereich
    ADD CONSTRAINT ax_bauwerkimgewaesserbereich_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3416 (class 2606 OID 29980)
-- Dependencies: 2680 2680
-- Name: ax_bauwerkimverkehrsbereich_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_bauwerkimverkehrsbereich
    ADD CONSTRAINT ax_bauwerkimverkehrsbereich_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3419 (class 2606 OID 29995)
-- Dependencies: 2682 2682
-- Name: ax_bauwerkoderanlagefuerindustrieundgewerbe_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_bauwerkoderanlagefuerindustrieundgewerbe
    ADD CONSTRAINT ax_bauwerkoderanlagefuerindustrieundgewerbe_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3413 (class 2606 OID 29964)
-- Dependencies: 2678 2678
-- Name: ax_bauwerkoderanlagefuersportfreizeitunderholung_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_bauwerkoderanlagefuersportfreizeitunderholung
    ADD CONSTRAINT ax_bauwerkoderanlagefuersportfreizeitunderholung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3586 (class 2606 OID 133070)
-- Dependencies: 2796 2796
-- Name: ax_bergbaubetrieb_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_bergbaubetrieb
    ADD CONSTRAINT ax_bergbaubetrieb_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3501 (class 2606 OID 30605)
-- Dependencies: 2738 2738
-- Name: ax_dammwalldeich_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_dammwalldeich
    ADD CONSTRAINT ax_dammwalldeich_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3530 (class 2606 OID 31003)
-- Dependencies: 2758 2758
-- Name: ax_denkmalschutzrecht_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_denkmalschutzrecht
    ADD CONSTRAINT ax_denkmalschutzrecht_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3498 (class 2606 OID 30589)
-- Dependencies: 2736 2736
-- Name: ax_einrichtungenfuerdenschiffsverkehr_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_einrichtungenfuerdenschiffsverkehr
    ADD CONSTRAINT ax_einrichtungenfuerdenschiffsverkehr_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3422 (class 2606 OID 30011)
-- Dependencies: 2684 2684
-- Name: ax_fahrbahnachse_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_fahrbahnachse
    ADD CONSTRAINT ax_fahrbahnachse_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3375 (class 2606 OID 29724)
-- Dependencies: 2652 2652
-- Name: ax_fahrwegachse_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_fahrwegachse
    ADD CONSTRAINT ax_fahrwegachse_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3533 (class 2606 OID 31049)
-- Dependencies: 2760 2760
-- Name: ax_felsenfelsblockfelsnadel_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_felsenfelsblockfelsnadel
    ADD CONSTRAINT ax_felsenfelsblockfelsnadel_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3425 (class 2606 OID 30027)
-- Dependencies: 2686 2686
-- Name: ax_flaechebesondererfunktionalerpraegung_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_flaechebesondererfunktionalerpraegung
    ADD CONSTRAINT ax_flaechebesondererfunktionalerpraegung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3428 (class 2606 OID 30043)
-- Dependencies: 2688 2688
-- Name: ax_flaechegemischternutzung_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_flaechegemischternutzung
    ADD CONSTRAINT ax_flaechegemischternutzung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3504 (class 2606 OID 30621)
-- Dependencies: 2740 2740
-- Name: ax_flaechezurzeitunbestimmbar_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_flaechezurzeitunbestimmbar
    ADD CONSTRAINT ax_flaechezurzeitunbestimmbar_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3507 (class 2606 OID 30637)
-- Dependencies: 2742 2742
-- Name: ax_fliessgewaesser_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_fliessgewaesser
    ADD CONSTRAINT ax_fliessgewaesser_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3542 (class 2606 OID 32187)
-- Dependencies: 2766 2766
-- Name: ax_flugverkehr_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_flugverkehr
    ADD CONSTRAINT ax_flugverkehr_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3545 (class 2606 OID 33039)
-- Dependencies: 2768 2768
-- Name: ax_flugverkehrsanlage_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_flugverkehrsanlage
    ADD CONSTRAINT ax_flugverkehrsanlage_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3431 (class 2606 OID 30059)
-- Dependencies: 2690 2690
-- Name: ax_friedhof_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_friedhof
    ADD CONSTRAINT ax_friedhof_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3434 (class 2606 OID 30075)
-- Dependencies: 2692 2692
-- Name: ax_gebaeude_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_gebaeude
    ADD CONSTRAINT ax_gebaeude_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3378 (class 2606 OID 29740)
-- Dependencies: 2654 2654
-- Name: ax_gebietsgrenze_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_gebietsgrenze
    ADD CONSTRAINT ax_gebietsgrenze_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3437 (class 2606 OID 30133)
-- Dependencies: 2694 2694
-- Name: ax_gehoelz_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_gehoelz
    ADD CONSTRAINT ax_gehoelz_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3381 (class 2606 OID 29766)
-- Dependencies: 2656 2656
-- Name: ax_gewaesserachse_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_gewaesserachse
    ADD CONSTRAINT ax_gewaesserachse_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3510 (class 2606 OID 30714)
-- Dependencies: 2744 2744
-- Name: ax_gewaessermerkmal_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_gewaessermerkmal
    ADD CONSTRAINT ax_gewaessermerkmal_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3516 (class 2606 OID 30748)
-- Dependencies: 2748 2748
-- Name: ax_gewaesserstationierungsachse_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_gewaesserstationierungsachse
    ADD CONSTRAINT ax_gewaesserstationierungsachse_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3554 (class 2606 OID 33735)
-- Dependencies: 2774 2774
-- Name: ax_hafen_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_hafen
    ADD CONSTRAINT ax_hafen_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3551 (class 2606 OID 33711)
-- Dependencies: 2772 2772
-- Name: ax_hafenbecken_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_hafenbecken
    ADD CONSTRAINT ax_hafenbecken_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3563 (class 2606 OID 36950)
-- Dependencies: 2780 2780
-- Name: ax_halde_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_halde
    ADD CONSTRAINT ax_halde_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3581 (class 2606 OID 63878)
-- Dependencies: 2792 2792
-- Name: ax_heide_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_heide
    ADD CONSTRAINT ax_heide_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3384 (class 2606 OID 29782)
-- Dependencies: 2658 2658
-- Name: ax_historischesbauwerkoderhistorischeeinrichtung_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_historischesbauwerkoderhistorischeeinrichtung
    ADD CONSTRAINT ax_historischesbauwerkoderhistorischeeinrichtung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3536 (class 2606 OID 31389)
-- Dependencies: 2762 2762
-- Name: ax_hoehleneingang_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_hoehleneingang
    ADD CONSTRAINT ax_hoehleneingang_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3440 (class 2606 OID 30190)
-- Dependencies: 2696 2696
-- Name: ax_industrieundgewerbeflaeche_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_industrieundgewerbeflaeche
    ADD CONSTRAINT ax_industrieundgewerbeflaeche_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3513 (class 2606 OID 30732)
-- Dependencies: 2746 2746
-- Name: ax_insel_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_insel
    ADD CONSTRAINT ax_insel_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3583 (class 2606 OID 69847)
-- Dependencies: 2794 2794
-- Name: ax_kanal_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_kanal
    ADD CONSTRAINT ax_kanal_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3387 (class 2606 OID 29798)
-- Dependencies: 2660 2660
-- Name: ax_kommunalesgebiet_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_kommunalesgebiet
    ADD CONSTRAINT ax_kommunalesgebiet_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3575 (class 2606 OID 61527)
-- Dependencies: 2788 2788
-- Name: ax_kondominium_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_kondominium
    ADD CONSTRAINT ax_kondominium_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3390 (class 2606 OID 29820)
-- Dependencies: 2662 2662
-- Name: ax_landwirtschaft_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_landwirtschaft
    ADD CONSTRAINT ax_landwirtschaft_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3519 (class 2606 OID 30816)
-- Dependencies: 2750 2750
-- Name: ax_leitung_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_leitung
    ADD CONSTRAINT ax_leitung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3572 (class 2606 OID 51739)
-- Dependencies: 2786 2786
-- Name: ax_moor_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_moor
    ADD CONSTRAINT ax_moor_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3393 (class 2606 OID 29840)
-- Dependencies: 2664 2664
-- Name: ax_naturumweltoderbodenschutzrecht_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_naturumweltoderbodenschutzrecht
    ADD CONSTRAINT ax_naturumweltoderbodenschutzrecht_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3489 (class 2606 OID 30549)
-- Dependencies: 2730 2730
-- Name: ax_netzknoten_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_netzknoten
    ADD CONSTRAINT ax_netzknoten_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3452 (class 2606 OID 30318)
-- Dependencies: 2704 2704
-- Name: ax_nullpunkt_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_nullpunkt
    ADD CONSTRAINT ax_nullpunkt_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3446 (class 2606 OID 30284)
-- Dependencies: 2700 2700
-- Name: ax_ortslage_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_ortslage
    ADD CONSTRAINT ax_ortslage_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3443 (class 2606 OID 30268)
-- Dependencies: 2698 2698
-- Name: ax_platz_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_platz
    ADD CONSTRAINT ax_platz_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3522 (class 2606 OID 30847)
-- Dependencies: 2752 2752
-- Name: ax_schifffahrtsliniefaehrverkehr_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_schifffahrtsliniefaehrverkehr
    ADD CONSTRAINT ax_schifffahrtsliniefaehrverkehr_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3557 (class 2606 OID 33867)
-- Dependencies: 2776 2776
-- Name: ax_schiffsverkehr_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_schiffsverkehr
    ADD CONSTRAINT ax_schiffsverkehr_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3578 (class 2606 OID 61546)
-- Dependencies: 2790 2790
-- Name: ax_schleuse_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_schleuse
    ADD CONSTRAINT ax_schleuse_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3566 (class 2606 OID 40026)
-- Dependencies: 2782 2782
-- Name: ax_seilbahnschwebebahn_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_seilbahnschwebebahn
    ADD CONSTRAINT ax_seilbahnschwebebahn_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3449 (class 2606 OID 30302)
-- Dependencies: 2702 2702
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_sonstigesbauwerkodersonstigeeinrichtung
    ADD CONSTRAINT ax_sonstigesbauwerkodersonstigeeinrichtung_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3569 (class 2606 OID 40097)
-- Dependencies: 2784 2784
-- Name: ax_sonstigesrecht_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_sonstigesrecht
    ADD CONSTRAINT ax_sonstigesrecht_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3455 (class 2606 OID 30334)
-- Dependencies: 2706 2706
-- Name: ax_sportfreizeitunderholungsflaeche_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_sportfreizeitunderholungsflaeche
    ADD CONSTRAINT ax_sportfreizeitunderholungsflaeche_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3458 (class 2606 OID 30350)
-- Dependencies: 2708 2708
-- Name: ax_stehendesgewaesser_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_stehendesgewaesser
    ADD CONSTRAINT ax_stehendesgewaesser_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3487 (class 2606 OID 30538)
-- Dependencies: 2728 2728
-- Name: ax_strasse_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_strasse
    ADD CONSTRAINT ax_strasse_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3461 (class 2606 OID 30366)
-- Dependencies: 2710 2710
-- Name: ax_strassenachse_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_strassenachse
    ADD CONSTRAINT ax_strassenachse_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3464 (class 2606 OID 30382)
-- Dependencies: 2712 2712
-- Name: ax_strassenverkehr_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_strassenverkehr
    ADD CONSTRAINT ax_strassenverkehr_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3476 (class 2606 OID 30446)
-- Dependencies: 2720 2720
-- Name: ax_strassenverkehrsanlage_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_strassenverkehrsanlage
    ADD CONSTRAINT ax_strassenverkehrsanlage_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3560 (class 2606 OID 34087)
-- Dependencies: 2778 2778
-- Name: ax_sumpf_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_sumpf
    ADD CONSTRAINT ax_sumpf_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3525 (class 2606 OID 30892)
-- Dependencies: 2754 2754
-- Name: ax_tagebaugrubesteinbruch_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_tagebaugrubesteinbruch
    ADD CONSTRAINT ax_tagebaugrubesteinbruch_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3473 (class 2606 OID 30430)
-- Dependencies: 2718 2718
-- Name: ax_transportanlage_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_transportanlage
    ADD CONSTRAINT ax_transportanlage_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3470 (class 2606 OID 30414)
-- Dependencies: 2716 2716
-- Name: ax_turm_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_turm
    ADD CONSTRAINT ax_turm_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3467 (class 2606 OID 30398)
-- Dependencies: 2714 2714
-- Name: ax_unlandvegetationsloseflaeche_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_unlandvegetationsloseflaeche
    ADD CONSTRAINT ax_unlandvegetationsloseflaeche_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3479 (class 2606 OID 30462)
-- Dependencies: 2722 2722
-- Name: ax_vegetationsmerkmal_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_vegetationsmerkmal
    ADD CONSTRAINT ax_vegetationsmerkmal_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3396 (class 2606 OID 29866)
-- Dependencies: 2666 2666
-- Name: ax_wald_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_wald
    ADD CONSTRAINT ax_wald_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3527 (class 2606 OID 30992)
-- Dependencies: 2756 2756
-- Name: ax_wasserlauf_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_wasserlauf
    ADD CONSTRAINT ax_wasserlauf_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3539 (class 2606 OID 32129)
-- Dependencies: 2764 2764
-- Name: ax_wasserspiegelhoehe_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_wasserspiegelhoehe
    ADD CONSTRAINT ax_wasserspiegelhoehe_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3399 (class 2606 OID 29888)
-- Dependencies: 2668 2668
-- Name: ax_wegpfadsteig_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_wegpfadsteig
    ADD CONSTRAINT ax_wegpfadsteig_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3482 (class 2606 OID 30506)
-- Dependencies: 2724 2724
-- Name: ax_wohnbauflaeche_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_wohnbauflaeche
    ADD CONSTRAINT ax_wohnbauflaeche_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3485 (class 2606 OID 30522)
-- Dependencies: 2726 2726
-- Name: ax_wohnplatz_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ax_wohnplatz
    ADD CONSTRAINT ax_wohnplatz_pk PRIMARY KEY (ogc_fid);


--
-- TOC entry 3402 (class 1259 OID 29924)
-- Dependencies: 2672 2269
-- Name: ax_abschnitt_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_abschnitt_geom_idx ON ax_abschnitt USING gist (wkb_geometry);


--
-- TOC entry 3405 (class 1259 OID 29940)
-- Dependencies: 2674 2269
-- Name: ax_ast_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_ast_geom_idx ON ax_ast USING gist (wkb_geometry);


--
-- TOC entry 3493 (class 1259 OID 30581)
-- Dependencies: 2269 2734
-- Name: ax_bahnstrecke_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_bahnstrecke_geom_idx ON ax_bahnstrecke USING gist (wkb_geometry);


--
-- TOC entry 3546 (class 1259 OID 33482)
-- Dependencies: 2770 2269
-- Name: ax_bahnverkehr_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_bahnverkehr_geom_idx ON ax_bahnverkehr USING gist (wkb_geometry);


--
-- TOC entry 3490 (class 1259 OID 30565)
-- Dependencies: 2269 2732
-- Name: ax_bahnverkehrsanlage_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_bahnverkehrsanlage_geom_idx ON ax_bahnverkehrsanlage USING gist (wkb_geometry);


--
-- TOC entry 3408 (class 1259 OID 29956)
-- Dependencies: 2676 2269
-- Name: ax_bauwerkimgewaesserbereich_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_bauwerkimgewaesserbereich_geom_idx ON ax_bauwerkimgewaesserbereich USING gist (wkb_geometry);


--
-- TOC entry 3414 (class 1259 OID 29987)
-- Dependencies: 2680 2269
-- Name: ax_bauwerkimverkehrsbereich_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_bauwerkimverkehrsbereich_geom_idx ON ax_bauwerkimverkehrsbereich USING gist (wkb_geometry);


--
-- TOC entry 3417 (class 1259 OID 30003)
-- Dependencies: 2269 2682
-- Name: ax_bauwerkoderanlagefuerindustrieundgewerbe_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_bauwerkoderanlagefuerindustrieundgewerbe_geom_idx ON ax_bauwerkoderanlagefuerindustrieundgewerbe USING gist (wkb_geometry);


--
-- TOC entry 3411 (class 1259 OID 29972)
-- Dependencies: 2269 2678
-- Name: ax_bauwerkoderanlagefuersportfreizeitunderholung_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_bauwerkoderanlagefuersportfreizeitunderholung_geom_idx ON ax_bauwerkoderanlagefuersportfreizeitunderholung USING gist (wkb_geometry);


--
-- TOC entry 3584 (class 1259 OID 133078)
-- Dependencies: 2796 2269
-- Name: ax_bergbaubetrieb_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_bergbaubetrieb_geom_idx ON ax_bergbaubetrieb USING gist (wkb_geometry);


--
-- TOC entry 3499 (class 1259 OID 30613)
-- Dependencies: 2269 2738
-- Name: ax_dammwalldeich_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_dammwalldeich_geom_idx ON ax_dammwalldeich USING gist (wkb_geometry);


--
-- TOC entry 3528 (class 1259 OID 31012)
-- Dependencies: 2269 2758
-- Name: ax_denkmalschutzrecht_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_denkmalschutzrecht_geom_idx ON ax_denkmalschutzrecht USING gist (wkb_geometry);


--
-- TOC entry 3496 (class 1259 OID 30597)
-- Dependencies: 2269 2736
-- Name: ax_einrichtungenfuerdenschiffsverkehr_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_einrichtungenfuerdenschiffsverkehr_geom_idx ON ax_einrichtungenfuerdenschiffsverkehr USING gist (wkb_geometry);


--
-- TOC entry 3420 (class 1259 OID 30019)
-- Dependencies: 2684 2269
-- Name: ax_fahrbahnachse_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_fahrbahnachse_geom_idx ON ax_fahrbahnachse USING gist (wkb_geometry);


--
-- TOC entry 3373 (class 1259 OID 29732)
-- Dependencies: 2269 2652
-- Name: ax_fahrwegachse_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_fahrwegachse_geom_idx ON ax_fahrwegachse USING gist (wkb_geometry);


--
-- TOC entry 3531 (class 1259 OID 31057)
-- Dependencies: 2760 2269
-- Name: ax_felsenfelsblockfelsnadel_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_felsenfelsblockfelsnadel_geom_idx ON ax_felsenfelsblockfelsnadel USING gist (wkb_geometry);


--
-- TOC entry 3423 (class 1259 OID 30035)
-- Dependencies: 2269 2686
-- Name: ax_flaechebesondererfunktionalerpraegung_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_flaechebesondererfunktionalerpraegung_geom_idx ON ax_flaechebesondererfunktionalerpraegung USING gist (wkb_geometry);


--
-- TOC entry 3426 (class 1259 OID 30051)
-- Dependencies: 2269 2688
-- Name: ax_flaechegemischternutzung_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_flaechegemischternutzung_geom_idx ON ax_flaechegemischternutzung USING gist (wkb_geometry);


--
-- TOC entry 3502 (class 1259 OID 30629)
-- Dependencies: 2740 2269
-- Name: ax_flaechezurzeitunbestimmbar_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_flaechezurzeitunbestimmbar_geom_idx ON ax_flaechezurzeitunbestimmbar USING gist (wkb_geometry);


--
-- TOC entry 3505 (class 1259 OID 30645)
-- Dependencies: 2269 2742
-- Name: ax_fliessgewaesser_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_fliessgewaesser_geom_idx ON ax_fliessgewaesser USING gist (wkb_geometry);


--
-- TOC entry 3540 (class 1259 OID 32195)
-- Dependencies: 2766 2269
-- Name: ax_flugverkehr_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_flugverkehr_geom_idx ON ax_flugverkehr USING gist (wkb_geometry);


--
-- TOC entry 3543 (class 1259 OID 33047)
-- Dependencies: 2269 2768
-- Name: ax_flugverkehrsanlage_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_flugverkehrsanlage_geom_idx ON ax_flugverkehrsanlage USING gist (wkb_geometry);


--
-- TOC entry 3429 (class 1259 OID 30067)
-- Dependencies: 2269 2690
-- Name: ax_friedhof_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_friedhof_geom_idx ON ax_friedhof USING gist (wkb_geometry);


--
-- TOC entry 3432 (class 1259 OID 30083)
-- Dependencies: 2269 2692
-- Name: ax_gebaeude_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_gebaeude_geom_idx ON ax_gebaeude USING gist (wkb_geometry);


--
-- TOC entry 3376 (class 1259 OID 29748)
-- Dependencies: 2654 2269
-- Name: ax_gebietsgrenze_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_gebietsgrenze_geom_idx ON ax_gebietsgrenze USING gist (wkb_geometry);


--
-- TOC entry 3435 (class 1259 OID 30141)
-- Dependencies: 2269 2694
-- Name: ax_gehoelz_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_gehoelz_geom_idx ON ax_gehoelz USING gist (wkb_geometry);


--
-- TOC entry 3379 (class 1259 OID 29774)
-- Dependencies: 2656 2269
-- Name: ax_gewaesserachse_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_gewaesserachse_geom_idx ON ax_gewaesserachse USING gist (wkb_geometry);


--
-- TOC entry 3508 (class 1259 OID 30722)
-- Dependencies: 2269 2744
-- Name: ax_gewaessermerkmal_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_gewaessermerkmal_geom_idx ON ax_gewaessermerkmal USING gist (wkb_geometry);


--
-- TOC entry 3514 (class 1259 OID 30756)
-- Dependencies: 2748 2269
-- Name: ax_gewaesserstationierungsachse_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_gewaesserstationierungsachse_geom_idx ON ax_gewaesserstationierungsachse USING gist (wkb_geometry);


--
-- TOC entry 3552 (class 1259 OID 33743)
-- Dependencies: 2269 2774
-- Name: ax_hafen_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_hafen_geom_idx ON ax_hafen USING gist (wkb_geometry);


--
-- TOC entry 3549 (class 1259 OID 33719)
-- Dependencies: 2269 2772
-- Name: ax_hafenbecken_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_hafenbecken_geom_idx ON ax_hafenbecken USING gist (wkb_geometry);


--
-- TOC entry 3561 (class 1259 OID 36958)
-- Dependencies: 2780 2269
-- Name: ax_halde_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_halde_geom_idx ON ax_halde USING gist (wkb_geometry);


--
-- TOC entry 3579 (class 1259 OID 63886)
-- Dependencies: 2792 2269
-- Name: ax_heide_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_heide_geom_idx ON ax_heide USING gist (wkb_geometry);


--
-- TOC entry 3382 (class 1259 OID 29790)
-- Dependencies: 2269 2658
-- Name: ax_historischesbauwerkoderhistorischeeinrichtung_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_historischesbauwerkoderhistorischeeinrichtung_geom_idx ON ax_historischesbauwerkoderhistorischeeinrichtung USING gist (wkb_geometry);


--
-- TOC entry 3534 (class 1259 OID 31397)
-- Dependencies: 2762 2269
-- Name: ax_hoehleneingang_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_hoehleneingang_geom_idx ON ax_hoehleneingang USING gist (wkb_geometry);


--
-- TOC entry 3438 (class 1259 OID 30198)
-- Dependencies: 2696 2269
-- Name: ax_industrieundgewerbeflaeche_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_industrieundgewerbeflaeche_geom_idx ON ax_industrieundgewerbeflaeche USING gist (wkb_geometry);


--
-- TOC entry 3511 (class 1259 OID 30740)
-- Dependencies: 2746 2269
-- Name: ax_insel_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_insel_geom_idx ON ax_insel USING gist (wkb_geometry);


--
-- TOC entry 3385 (class 1259 OID 29806)
-- Dependencies: 2269 2660
-- Name: ax_kommunalesgebiet_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_kommunalesgebiet_geom_idx ON ax_kommunalesgebiet USING gist (wkb_geometry);


--
-- TOC entry 3573 (class 1259 OID 61535)
-- Dependencies: 2269 2788
-- Name: ax_kondominium_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_kondominium_geom_idx ON ax_kondominium USING gist (wkb_geometry);


--
-- TOC entry 3388 (class 1259 OID 29828)
-- Dependencies: 2662 2269
-- Name: ax_landwirtschaft_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_landwirtschaft_geom_idx ON ax_landwirtschaft USING gist (wkb_geometry);


--
-- TOC entry 3517 (class 1259 OID 30824)
-- Dependencies: 2269 2750
-- Name: ax_leitung_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_leitung_geom_idx ON ax_leitung USING gist (wkb_geometry);


--
-- TOC entry 3570 (class 1259 OID 51747)
-- Dependencies: 2786 2269
-- Name: ax_moor_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_moor_geom_idx ON ax_moor USING gist (wkb_geometry);


--
-- TOC entry 3391 (class 1259 OID 29848)
-- Dependencies: 2269 2664
-- Name: ax_naturumweltoderbodenschutzrecht_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_naturumweltoderbodenschutzrecht_geom_idx ON ax_naturumweltoderbodenschutzrecht USING gist (wkb_geometry);


--
-- TOC entry 3450 (class 1259 OID 30326)
-- Dependencies: 2269 2704
-- Name: ax_nullpunkt_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_nullpunkt_geom_idx ON ax_nullpunkt USING gist (wkb_geometry);


--
-- TOC entry 3444 (class 1259 OID 30292)
-- Dependencies: 2700 2269
-- Name: ax_ortslage_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_ortslage_geom_idx ON ax_ortslage USING gist (wkb_geometry);


--
-- TOC entry 3441 (class 1259 OID 30276)
-- Dependencies: 2698 2269
-- Name: ax_platz_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_platz_geom_idx ON ax_platz USING gist (wkb_geometry);


--
-- TOC entry 3520 (class 1259 OID 30855)
-- Dependencies: 2752 2269
-- Name: ax_schifffahrtsliniefaehrverkehr_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_schifffahrtsliniefaehrverkehr_geom_idx ON ax_schifffahrtsliniefaehrverkehr USING gist (wkb_geometry);


--
-- TOC entry 3555 (class 1259 OID 33875)
-- Dependencies: 2269 2776
-- Name: ax_schiffsverkehr_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_schiffsverkehr_geom_idx ON ax_schiffsverkehr USING gist (wkb_geometry);


--
-- TOC entry 3576 (class 1259 OID 61554)
-- Dependencies: 2790 2269
-- Name: ax_schleuse_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_schleuse_geom_idx ON ax_schleuse USING gist (wkb_geometry);


--
-- TOC entry 3564 (class 1259 OID 40034)
-- Dependencies: 2269 2782
-- Name: ax_seilbahnschwebebahn_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_seilbahnschwebebahn_geom_idx ON ax_seilbahnschwebebahn USING gist (wkb_geometry);


--
-- TOC entry 3447 (class 1259 OID 30310)
-- Dependencies: 2269 2702
-- Name: ax_sonstigesbauwerkodersonstigeeinrichtung_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_sonstigesbauwerkodersonstigeeinrichtung_geom_idx ON ax_sonstigesbauwerkodersonstigeeinrichtung USING gist (wkb_geometry);


--
-- TOC entry 3567 (class 1259 OID 40105)
-- Dependencies: 2784 2269
-- Name: ax_sonstigesrecht_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_sonstigesrecht_geom_idx ON ax_sonstigesrecht USING gist (wkb_geometry);


--
-- TOC entry 3453 (class 1259 OID 30342)
-- Dependencies: 2706 2269
-- Name: ax_sportfreizeitunderholungsflaeche_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_sportfreizeitunderholungsflaeche_geom_idx ON ax_sportfreizeitunderholungsflaeche USING gist (wkb_geometry);


--
-- TOC entry 3456 (class 1259 OID 30358)
-- Dependencies: 2708 2269
-- Name: ax_stehendesgewaesser_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_stehendesgewaesser_geom_idx ON ax_stehendesgewaesser USING gist (wkb_geometry);


--
-- TOC entry 3459 (class 1259 OID 30374)
-- Dependencies: 2269 2710
-- Name: ax_strassenachse_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_strassenachse_geom_idx ON ax_strassenachse USING gist (wkb_geometry);


--
-- TOC entry 3462 (class 1259 OID 30390)
-- Dependencies: 2269 2712
-- Name: ax_strassenverkehr_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_strassenverkehr_geom_idx ON ax_strassenverkehr USING gist (wkb_geometry);


--
-- TOC entry 3474 (class 1259 OID 30454)
-- Dependencies: 2269 2720
-- Name: ax_strassenverkehrsanlage_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_strassenverkehrsanlage_geom_idx ON ax_strassenverkehrsanlage USING gist (wkb_geometry);


--
-- TOC entry 3558 (class 1259 OID 34095)
-- Dependencies: 2778 2269
-- Name: ax_sumpf_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_sumpf_geom_idx ON ax_sumpf USING gist (wkb_geometry);


--
-- TOC entry 3523 (class 1259 OID 30900)
-- Dependencies: 2269 2754
-- Name: ax_tagebaugrubesteinbruch_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_tagebaugrubesteinbruch_geom_idx ON ax_tagebaugrubesteinbruch USING gist (wkb_geometry);


--
-- TOC entry 3471 (class 1259 OID 30438)
-- Dependencies: 2269 2718
-- Name: ax_transportanlage_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_transportanlage_geom_idx ON ax_transportanlage USING gist (wkb_geometry);


--
-- TOC entry 3468 (class 1259 OID 30422)
-- Dependencies: 2269 2716
-- Name: ax_turm_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_turm_geom_idx ON ax_turm USING gist (wkb_geometry);


--
-- TOC entry 3465 (class 1259 OID 30406)
-- Dependencies: 2269 2714
-- Name: ax_unlandvegetationsloseflaeche_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_unlandvegetationsloseflaeche_geom_idx ON ax_unlandvegetationsloseflaeche USING gist (wkb_geometry);


--
-- TOC entry 3477 (class 1259 OID 30469)
-- Dependencies: 2722 2269
-- Name: ax_vegetationsmerkmal_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_vegetationsmerkmal_geom_idx ON ax_vegetationsmerkmal USING gist (wkb_geometry);


--
-- TOC entry 3394 (class 1259 OID 29874)
-- Dependencies: 2666 2269
-- Name: ax_wald_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_wald_geom_idx ON ax_wald USING gist (wkb_geometry);


--
-- TOC entry 3537 (class 1259 OID 32137)
-- Dependencies: 2764 2269
-- Name: ax_wasserspiegelhoehe_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_wasserspiegelhoehe_geom_idx ON ax_wasserspiegelhoehe USING gist (wkb_geometry);


--
-- TOC entry 3397 (class 1259 OID 29896)
-- Dependencies: 2668 2269
-- Name: ax_wegpfadsteig_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_wegpfadsteig_geom_idx ON ax_wegpfadsteig USING gist (wkb_geometry);


--
-- TOC entry 3480 (class 1259 OID 30514)
-- Dependencies: 2724 2269
-- Name: ax_wohnbauflaeche_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_wohnbauflaeche_geom_idx ON ax_wohnbauflaeche USING gist (wkb_geometry);


--
-- TOC entry 3483 (class 1259 OID 30530)
-- Dependencies: 2726 2269
-- Name: ax_wohnplatz_geom_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ax_wohnplatz_geom_idx ON ax_wohnplatz USING gist (wkb_geometry);


-- Completed on 2011-07-07 07:43:06 CEST

--
-- PostgreSQL database dump complete
--


--create content of table geometry_columns
--
-- TOC entry 3087 (class 0 OID 16749)
-- Dependencies: 2640
-- Data for Name: geometry_columns; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO geometry_columns VALUES ('', 'public', 'ax_fahrwegachse', 'wkb_geometry', 2, 25832, 'LINESTRING');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_gebietsgrenze', 'wkb_geometry', 2, 25832, 'LINESTRING');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_gewaesserachse', 'wkb_geometry', 2, 25832, 'LINESTRING');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_historischesbauwerkoderhistorischeeinrichtung', 'wkb_geometry', 2, 25832, 'GEOMETRY');--LINESTRING
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_kommunalesgebiet', 'wkb_geometry', 2, 25832, 'GEOMETRY');--POLYGON
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_landwirtschaft', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_naturumweltoderbodenschutzrecht', 'wkb_geometry', 2, 25832, 'GEOMETRY');--POLYGON
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_wald', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_wegpfadsteig', 'wkb_geometry', 2, 25832, 'LINESTRING');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_abschnitt', 'wkb_geometry', 2, 25832, 'LINESTRING');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_ast', 'wkb_geometry', 2, 25832, 'LINESTRING');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_bauwerkimgewaesserbereich', 'wkb_geometry', 2, 25832, 'GEOMETRY');--LINESTRING
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_bauwerkoderanlagefuersportfreizeitunderholung', 'wkb_geometry', 2, 25832, 'GEOMETRY');--POLYGON
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_bauwerkimverkehrsbereich', 'wkb_geometry', 2, 25832, 'GEOMETRY');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_bauwerkoderanlagefuerindustrieundgewerbe', 'wkb_geometry', 2, 25832, 'GEOMETRY');--POINT
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_fahrbahnachse', 'wkb_geometry', 2, 25832, 'LINESTRING');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_flaechebesondererfunktionalerpraegung', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_flaechegemischternutzung', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_friedhof', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_gebaeude', 'wkb_geometry', 2, 25832, 'GEOMETRY');--POINT
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_gehoelz', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_industrieundgewerbeflaeche', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_platz', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_ortslage', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_sonstigesbauwerkodersonstigeeinrichtung', 'wkb_geometry', 2, 25832, 'GEOMETRY');--POINT
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_nullpunkt', 'wkb_geometry', 2, 25832, 'POINT');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_sportfreizeitunderholungsflaeche', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_stehendesgewaesser', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_strassenachse', 'wkb_geometry', 2, 25832, 'LINESTRING');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_strassenverkehr', 'wkb_geometry', 2, 25832, 'GEOMETRY');--POLYGON
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_unlandvegetationsloseflaeche', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_turm', 'wkb_geometry', 2, 25832, 'GEOMETRY');--POINT
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_transportanlage', 'wkb_geometry', 2, 25832, 'GEOMETRY');--POINT
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_strassenverkehrsanlage', 'wkb_geometry', 2, 25832, 'GEOMETRY');--POINT
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_vegetationsmerkmal', 'wkb_geometry', 2, 25832, 'GEOMETRY');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_wohnbauflaeche', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_wohnplatz', 'wkb_geometry', 2, 25832, 'POINT');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_bahnverkehrsanlage', 'wkb_geometry', 2, 25832, 'GEOMETRY');--POINT
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_bahnstrecke', 'wkb_geometry', 2, 25832, 'LINESTRING');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_einrichtungenfuerdenschiffsverkehr', 'wkb_geometry', 2, 25832, 'POINT');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_dammwalldeich', 'wkb_geometry', 2, 25832, 'GEOMETRY');--LINESTRING
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_flaechezurzeitunbestimmbar', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_fliessgewaesser', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_gewaessermerkmal', 'wkb_geometry', 2, 25832, 'GEOMETRY');--POINT
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_insel', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_gewaesserstationierungsachse', 'wkb_geometry', 2, 25832, 'LINESTRING');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_leitung', 'wkb_geometry', 2, 25832, 'LINESTRING');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_schifffahrtsliniefaehrverkehr', 'wkb_geometry', 2, 25832, 'LINESTRING');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_tagebaugrubesteinbruch', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_denkmalschutzrecht', 'wkb_geometry', 2, 25832, 'GEOMETRY');--LINESTRING
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_felsenfelsblockfelsnadel', 'wkb_geometry', 2, 25832, 'GEOMETRY');--LINESTRING
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_hoehleneingang', 'wkb_geometry', 2, 25832, 'POINT');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_wasserspiegelhoehe', 'wkb_geometry', 2, 25832, 'POINT');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_flugverkehr', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_flugverkehrsanlage', 'wkb_geometry', 2, 25832, 'GEOMETRY');--POINT
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_bahnverkehr', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_hafenbecken', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_hafen', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_schiffsverkehr', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_sumpf', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_halde', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_seilbahnschwebebahn', 'wkb_geometry', 2, 25832, 'LINESTRING');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_sonstigesrecht', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_moor', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_kondominium', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_schleuse', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_heide', 'wkb_geometry', 2, 25832, 'POLYGON');
INSERT INTO geometry_columns VALUES ('', 'public', 'ax_bergbaubetrieb', 'wkb_geometry', 2, 25832, 'POLYGON');


-- Completed on 2011-07-07 07:54:54 CEST

--
-- PostgreSQL database dump complete
--


--create indexes for identifier
CREATE INDEX ax_abschnitt_idx ON ax_abschnitt(gml_id);
CREATE INDEX ax_ast_idx ON ax_ast(gml_id);
CREATE INDEX ax_bahnstrecke_idx ON ax_bahnstrecke(gml_id);
CREATE INDEX ax_bahnverkehr_idx ON ax_bahnverkehr(gml_id);
CREATE INDEX ax_bahnverkehrsanlage_idx ON ax_bahnverkehrsanlage(gml_id);
CREATE INDEX ax_bauwerkimgewaesserbereich_idx ON ax_bauwerkimgewaesserbereich(gml_id);
CREATE INDEX ax_bauwerkimverkehrsbereich_idx ON ax_bauwerkimverkehrsbereich(gml_id);
CREATE INDEX ax_bauwerkoderanlagefuerindustrieundgewerbe_idx ON ax_bauwerkoderanlagefuerindustrieundgewerbe(gml_id);
CREATE INDEX ax_bauwerkoderanlagefuersportfreizeitunderholung_idx ON ax_bauwerkoderanlagefuersportfreizeitunderholung(gml_id);
CREATE INDEX ax_bergbaubetrieb_idx ON ax_bergbaubetrieb(gml_id);
CREATE INDEX ax_dammwalldeich_idx ON ax_dammwalldeich(gml_id);
CREATE INDEX ax_denkmalschutzrecht_idx ON ax_denkmalschutzrecht(gml_id);
CREATE INDEX ax_einrichtungenfuerdenschiffsverkehr_idx ON ax_einrichtungenfuerdenschiffsverkehr(gml_id);
CREATE INDEX ax_fahrbahnachse_idx ON ax_fahrbahnachse(gml_id);
CREATE INDEX ax_fahrwegachse_idx ON ax_fahrwegachse(gml_id);
CREATE INDEX ax_felsenfelsblockfelsnadel_idx ON ax_felsenfelsblockfelsnadel(gml_id);
CREATE INDEX ax_flaechebesondererfunktionalerpraegung_idx ON ax_flaechebesondererfunktionalerpraegung(gml_id);
CREATE INDEX ax_flaechegemischternutzung_idx ON ax_flaechegemischternutzung(gml_id);
CREATE INDEX ax_flaechezurzeitunbestimmbar_idx ON ax_flaechezurzeitunbestimmbar(gml_id);
CREATE INDEX ax_fliessgewaesser_idx ON ax_fliessgewaesser(gml_id);
CREATE INDEX ax_flugverkehr_idx ON ax_flugverkehr(gml_id);
CREATE INDEX ax_flugverkehrsanlage_idx ON ax_flugverkehrsanlage(gml_id);
CREATE INDEX ax_friedhof_idx ON ax_friedhof(gml_id);
CREATE INDEX ax_gebaeude_idx ON ax_gebaeude(gml_id);
CREATE INDEX ax_gebietsgrenze_idx ON ax_gebietsgrenze(gml_id);
CREATE INDEX ax_gehoelz_idx ON ax_gehoelz(gml_id);
CREATE INDEX ax_gewaesserachse_idx ON ax_gewaesserachse(gml_id);
CREATE INDEX ax_gewaessermerkmal_idx ON ax_gewaessermerkmal(gml_id);
CREATE INDEX ax_gewaesserstationierungsachse_idx ON ax_gewaesserstationierungsachse(gml_id);
CREATE INDEX ax_hafen_idx ON ax_hafen(gml_id);
CREATE INDEX ax_hafenbecken_idx ON ax_hafenbecken(gml_id);
CREATE INDEX ax_halde_idx ON ax_halde(gml_id);
CREATE INDEX ax_heide_idx ON ax_heide(gml_id);
CREATE INDEX ax_historischesbauwerkoderhistorischeeinrichtung_idx ON ax_historischesbauwerkoderhistorischeeinrichtung(gml_id);
CREATE INDEX ax_hoehleneingang_idx ON ax_hoehleneingang(gml_id);
CREATE INDEX ax_industrieundgewerbeflaeche_idx ON ax_industrieundgewerbeflaeche(gml_id);
CREATE INDEX ax_insel_idx ON ax_insel(gml_id);
CREATE INDEX ax_kanal_idx ON ax_kanal(gml_id);
CREATE INDEX ax_kommunalesgebiet_idx ON ax_kommunalesgebiet(gml_id);
CREATE INDEX ax_kondominium_idx ON ax_kondominium(gml_id);
CREATE INDEX ax_landwirtschaft_idx ON ax_landwirtschaft(gml_id);
CREATE INDEX ax_leitung_idx ON ax_leitung(gml_id);
CREATE INDEX ax_moor_idx ON ax_moor(gml_id);
CREATE INDEX ax_naturumweltoderbodenschutzrecht_idx ON ax_naturumweltoderbodenschutzrecht(gml_id);
CREATE INDEX ax_netzknoten_idx ON ax_netzknoten(gml_id);
CREATE INDEX ax_nullpunkt_idx ON ax_nullpunkt(gml_id);
CREATE INDEX ax_ortslage_idx ON ax_ortslage(gml_id);
CREATE INDEX ax_platz_idx ON ax_platz(gml_id);
CREATE INDEX ax_schifffahrtsliniefaehrverkehr_idx ON ax_schifffahrtsliniefaehrverkehr(gml_id);
CREATE INDEX ax_schiffsverkehr_idx ON ax_schiffsverkehr(gml_id);
CREATE INDEX ax_schleuse_idx ON ax_schleuse(gml_id);
CREATE INDEX ax_seilbahnschwebebahn_idx ON ax_seilbahnschwebebahn(gml_id);
CREATE INDEX ax_sonstigesbauwerkodersonstigeeinrichtung_idx ON ax_sonstigesbauwerkodersonstigeeinrichtung(gml_id);
CREATE INDEX ax_sonstigesrecht_idx ON ax_sonstigesrecht(gml_id);
CREATE INDEX ax_sportfreizeitunderholungsflaeche_idx ON ax_sportfreizeitunderholungsflaeche(gml_id);
CREATE INDEX ax_stehendesgewaesser_idx ON ax_stehendesgewaesser(gml_id);
CREATE INDEX ax_strasse_idx ON ax_strasse(gml_id);
CREATE INDEX ax_strassenachse_idx ON ax_strassenachse(gml_id);
CREATE INDEX ax_strassenverkehr_idx ON ax_strassenverkehr(gml_id);
CREATE INDEX ax_strassenverkehrsanlage_idx ON ax_strassenverkehrsanlage(gml_id);
CREATE INDEX ax_sumpf_idx ON ax_sumpf(gml_id);
CREATE INDEX ax_tagebaugrubesteinbruch_idx ON ax_tagebaugrubesteinbruch(gml_id);
CREATE INDEX ax_transportanlage_idx ON ax_transportanlage(gml_id);
CREATE INDEX ax_turm_idx ON ax_turm(gml_id);
CREATE INDEX ax_unlandvegetationsloseflaeche_idx ON ax_unlandvegetationsloseflaeche(gml_id);
CREATE INDEX ax_vegetationsmerkmal_idx ON ax_vegetationsmerkmal(gml_id);
CREATE INDEX ax_wald_idx ON ax_wald(gml_id);
CREATE INDEX ax_wasserlauf_idx ON ax_wasserlauf(gml_id);
CREATE INDEX ax_wasserspiegelhoehe_idx ON ax_wasserspiegelhoehe(gml_id);
CREATE INDEX ax_wegpfadsteig_idx ON ax_wegpfadsteig(gml_id);
CREATE INDEX ax_wohnbauflaeche_idx ON ax_wohnbauflaeche(gml_id);
CREATE INDEX ax_wohnplatz_idx ON ax_wohnplatz(gml_id);

CREATE INDEX alkis_beziehungen_von_idx ON alkis_beziehungen (beziehung_von);

CREATE INDEX alkis_beziehungen_zu_idx ON alkis_beziehungen (beziehung_zu);


