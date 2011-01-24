--
-- PostgreSQL database dump
--

-- Started on 2011-01-24 16:11:56 CET

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = true;

--
-- TOC entry 2403 (class 1259 OID 13453429)
-- Dependencies: 5
-- Name: ax_bauteil_bauart; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ax_bauteil_bauart (
    wert integer NOT NULL,
    bezeichner character varying,
    kennung integer,
    objektart character varying
);


--
-- TOC entry 3094 (class 0 OID 13453429)
-- Dependencies: 2403
-- Data for Name: ax_bauteil_bauart; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (1100, 'Geringergeschossiger Gebäudeteil', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (1200, 'Höhergeschossiger Gebäudeteil (nicht Hochhaus)', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (1300, 'Hochhausgebäudeteil', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (1400, 'Abweichende Geschosshöhe', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2000, 'Keller', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2100, 'Tiefgarage', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2300, 'Loggia', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2350, 'Wintergarten', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2400, 'Arkade', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2500, 'Auskragende/zurückspringende Geschosse', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2510, 'Auskragende Geschosse', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2520, 'Zurückspringende Geschosse', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2610, 'Durchfahrt im Gebäude', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2620, 'Durchfahrt an überbauter Verkehrsstraße', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2710, 'Schornstein im Gebäude', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (2720, 'Turm im Gebäude', 31002, 'ax_bauteil');
INSERT INTO ax_bauteil_bauart (wert, bezeichner, kennung, objektart) VALUES (9999, 'Sonstiges', 31002, 'ax_bauteil');


--
-- TOC entry 3093 (class 2606 OID 14077934)
-- Dependencies: 2403 2403
-- Name: pk_ax_bauteil_bauart_wert; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ax_bauteil_bauart
    ADD CONSTRAINT pk_ax_bauteil_bauart_wert PRIMARY KEY (wert);


-- Completed on 2011-01-24 16:11:58 CET

--
-- PostgreSQL database dump complete
--

