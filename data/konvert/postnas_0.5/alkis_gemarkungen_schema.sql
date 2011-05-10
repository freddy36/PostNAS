CREATE TABLE gemarkungen (
  ogc_fid serial NOT NULL,
  land 			integer,
  regierungsbezirk	integer,
  kreis			integer,
  gemeinde		integer,
  gemarkung		integer NOT NULL,
  gemeindename		character varying(80), 
  gemarkungsname	character varying(80), 
  gkz			character varying(3), 
  CONSTRAINT gemarkungen_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('gemarkungen','wkb_geometry','25832','POLYGON',2);

CREATE INDEX gemarkungen_geom_idx ON gemarkungen USING gist (wkb_geometry);

INSERT INTO gemeinde (wkb_geometry,gemeinde) 
SELECT union(wkb_geometry),gemeinde from from ax_flurstuecke group by gemeinde;


---------------------------
CREATE TABLE gemeinden (
  ogc_fid serial NOT NULL,
  land 			integer,
  regierungsbezirk	integer,
  kreis			integer,
  gemeinde		integer,
  gemeindename		character varying(80), 
  gkz			character varying(3), 
  CONSTRAINT gemeinden_pk PRIMARY KEY (ogc_fid)
);

SELECT AddGeometryColumn('gemeinden','wkb_geometry','25832','POLYGON',2);

CREATE INDEX gemeinden_geom_idx ON gemeinden USING gist (wkb_geometry);
