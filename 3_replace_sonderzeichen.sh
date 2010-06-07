--Select distinct atttypid from pg_attribute;

-- Tabelle mit den Typenummern
--Select * from pg_type

-- für replace relevante Felder
--18 char
--25 text
--1002 _char
--1043 varchar
--11329 charachter data


-- bef_01
-- pktnr character varying(16) - enthält keine Sonderzeichen
-- oska character varying(16) - enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE

Update bef_01 set ggartbez = replace(ggartbez,'','ä');
Update bef_01 set ggartbez = replace(ggartbez,'','ö');
Update bef_01 set ggartbez = replace(ggartbez,'','ü');
Update bef_01 set ggartbez = replace(ggartbez,'á','ß');
Update bef_01 set ggartbez = replace(ggartbez,'','Ö');
Update bef_01 set ggartbez = replace(ggartbez,'','Ü');

------------------

-- bef_05
-- oname character varying(254) - UPDATE
-- oska character varying(16), - enthält nur Zahlen
-- ggartbez character varying(254) - UPDATE
-- aktualit character varying(10), - leer
-- straschl character varying(5), - leer
-- bezeichn character varying(40), - leer
-- nutzung character varying(20), - leer
-- befestig character varying(10), - leer
-- bearbeit character varying(5), - leer
-- ursprung character varying(20), - leer
-- schlagwo character varying(80), - leer
-- verweis character varying(254), - leer

Update bef_05 set oname = replace(oname,'','ä');
Update bef_05 set oname = replace(oname,'','ö');
Update bef_05 set oname = replace(oname,'','ü');
Update bef_05 set oname = replace(oname,'á','ß');
Update bef_05 set oname = replace(oname,'','Ö');
Update bef_05 set oname = replace(oname,'','Ü');

Update bef_05 set ggartbez = replace(ggartbez,'','ä');
Update bef_05 set ggartbez = replace(ggartbez,'','ö');
Update bef_05 set ggartbez = replace(ggartbez,'','ü');
Update bef_05 set ggartbez = replace(ggartbez,'á','ß');
Update bef_05 set ggartbez = replace(ggartbez,'','Ö');
Update bef_05 set ggartbez = replace(ggartbez,'','Ü');

------------------------------------

-- bef_11
-- pktnr character varying(16), - Zahlen-Buchstabenkombinationen ohne Sonderzeichen
-- oska character varying(16), - enthält nur Zahlen
-- ggartbez character varying(254) - UPDATE

Update bef_11 set ggartbez = replace(ggartbez,'','ä');
Update bef_11 set ggartbez = replace(ggartbez,'','ö');
Update bef_11 set ggartbez = replace(ggartbez,'','ü');
Update bef_11 set ggartbez = replace(ggartbez,'á','ß');
Update bef_11 set ggartbez = replace(ggartbez,'','Ö');
Update bef_11 set ggartbez = replace(ggartbez,'','Ü');

------------------------------------

-- bef_15
-- oname character varying(254), - UPDATE
-- oska character varying(16), - enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE
-- aktualit character varying(10), - leer
-- straschl character varying(5), - leer
-- bezeichn character varying(40), - leer
-- nutzung character varying(20), - leer
-- befestig character varying(10), - leer
-- bearbeit character varying(5), - leer
-- ursprung character varying(20), - leer
-- schlagwo character varying(80), - leer
-- verweis character varying(254), - leer

Update bef_15 set oname = replace(oname,'','ä');
Update bef_15 set oname = replace(oname,'','ö');
Update bef_15 set oname = replace(oname,'','ü');
Update bef_15 set oname = replace(oname,'á','ß');
Update bef_15 set oname = replace(oname,'','Ö');
Update bef_15 set oname = replace(oname,'','Ü');

Update bef_15 set ggartbez = replace(ggartbez,'','ä');
Update bef_15 set ggartbez = replace(ggartbez,'','ö');
Update bef_15 set ggartbez = replace(ggartbez,'','ü');
Update bef_15 set ggartbez = replace(ggartbez,'á','ß');
Update bef_15 set ggartbez = replace(ggartbez,'','Ö');
Update bef_15 set ggartbez = replace(ggartbez,'','Ü');

---------------------------------------

-- geb_01
-- pktnr character varying(16), - Zahlen-Buchstabenkombinationen ohne Sonderzeichen
-- oska character varying(16), - enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE

Update geb_01 set ggartbez = replace(ggartbez,'','ä');
Update geb_01 set ggartbez = replace(ggartbez,'','ö');
Update geb_01 set ggartbez = replace(ggartbez,'','ü');
Update geb_01 set ggartbez = replace(ggartbez,'á','ß');
Update geb_01 set ggartbez = replace(ggartbez,'','Ö');
Update geb_01 set ggartbez = replace(ggartbez,'','Ü');

-----------------------------------------

-- geb_03
-- oname character varying(254), - keine Sonderzeichen
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE
-- aktualit character varying(10), - leer
-- straschl character varying(5), - leer
-- bezeichn character varying(40), - leer
-- nutzung character varying(20), - leer
-- befestig character varying(10), - leer
-- bearbeit character varying(5), - leer
-- ursprung character varying(20), - leer
-- schlagwo character varying(80), - leer
-- verweis character varying(254), - leer

Update geb_03 set ggartbez = replace(ggartbez,'','ä');
Update geb_03 set ggartbez = replace(ggartbez,'','ö');
Update geb_03 set ggartbez = replace(ggartbez,'','ü');
Update geb_03 set ggartbez = replace(ggartbez,'á','ß');
Update geb_03 set ggartbez = replace(ggartbez,'','Ö');
Update geb_03 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- geb_05
-- oname character varying(254), - keine Sonderzeichen
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE
-- aktualit character varying(10), - leer
-- straschl character varying(5), - leer
-- bezeichn character varying(40), - leer
-- nutzung character varying(20), - leer
-- befestig character varying(10), - leer
-- bearbeit character varying(5), - leer
-- ursprung character varying(20), - leer
-- schlagwo character varying(80), - leer
-- verweis character varying(254), - leer

Update geb_05 set ggartbez = replace(ggartbez,'','ä');
Update geb_05 set ggartbez = replace(ggartbez,'','ö');
Update geb_05 set ggartbez = replace(ggartbez,'','ü');
Update geb_05 set ggartbez = replace(ggartbez,'á','ß');
Update geb_05 set ggartbez = replace(ggartbez,'','Ö');
Update geb_05 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- geb_11
-- pktnr character varying(16), - Zahlen-Buchstabenkombinationen ohne Sonderzeichen
-- oska character varying(16), - enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE

Update geb_11 set ggartbez = replace(ggartbez,'','ä');
Update geb_11 set ggartbez = replace(ggartbez,'','ö');
Update geb_11 set ggartbez = replace(ggartbez,'','ü');
Update geb_11 set ggartbez = replace(ggartbez,'á','ß');
Update geb_11 set ggartbez = replace(ggartbez,'','Ö');
Update geb_11 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- geb_13
-- oska character varying(16), - enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE

Update geb_13 set ggartbez = replace(ggartbez,'','ä');
Update geb_13 set ggartbez = replace(ggartbez,'','ö');
Update geb_13 set ggartbez = replace(ggartbez,'','ü');
Update geb_13 set ggartbez = replace(ggartbez,'á','ß');
Update geb_13 set ggartbez = replace(ggartbez,'','Ö');
Update geb_13 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- geb_15
-- oname character varying(254), - keine Sonderzeichen
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE
-- aktualit character varying(10), - leer
-- straschl character varying(5), - leer
-- bezeichn character varying(40), - leer
-- nutzung character varying(20), - leer
-- befestig character varying(10), - leer
-- bearbeit character varying(5), - leer
-- ursprung character varying(20), - leer
-- schlagwo character varying(80), - leer
-- verweis character varying(254), - leer

Update geb_15 set ggartbez = replace(ggartbez,'','ä');
Update geb_15 set ggartbez = replace(ggartbez,'','ö');
Update geb_15 set ggartbez = replace(ggartbez,'','ü');
Update geb_15 set ggartbez = replace(ggartbez,'á','ß');
Update geb_15 set ggartbez = replace(ggartbez,'','Ö');
Update geb_15 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- geb_99
-- txtinh character varying(254), - keine Sonderzeichen
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE

Update geb_99 set ggartbez = replace(ggartbez,'','ä');
Update geb_99 set ggartbez = replace(ggartbez,'','ö');
Update geb_99 set ggartbez = replace(ggartbez,'','ü');
Update geb_99 set ggartbez = replace(ggartbez,'á','ß');
Update geb_99 set ggartbez = replace(ggartbez,'','Ö');
Update geb_99 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- hoe_01
-- pktnr character varying(16), - keine Sonderzeichen
-- oska character varying(16),  -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE

Update hoe_01 set ggartbez = replace(ggartbez,'','ä');
Update hoe_01 set ggartbez = replace(ggartbez,'','ö');
Update hoe_01 set ggartbez = replace(ggartbez,'','ü');
Update hoe_01 set ggartbez = replace(ggartbez,'á','ß');
Update hoe_01 set ggartbez = replace(ggartbez,'','Ö');
Update hoe_01 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- hoe_03
-- oska character varying(16),  -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE

Update hoe_03 set ggartbez = replace(ggartbez,'','ä');
Update hoe_03 set ggartbez = replace(ggartbez,'','ö');
Update hoe_03 set ggartbez = replace(ggartbez,'','ü');
Update hoe_03 set ggartbez = replace(ggartbez,'á','ß');
Update hoe_03 set ggartbez = replace(ggartbez,'','Ö');
Update hoe_03 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- hoe_05
-- oname character varying(254), - UPDATE
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE
-- aktualit character varying(10), - leer
-- straschl character varying(5), - leer
-- bezeichn character varying(40), - leer
-- nutzung character varying(20), - leer
-- befestig character varying(10), - leer
-- bearbeit character varying(5), - leer
-- ursprung character varying(20), - leer
-- schlagwo character varying(80), - leer
-- verweis character varying(254), - leer

Update hoe_05 set oname = replace(oname,'','ä');
Update hoe_05 set oname = replace(oname,'','ö');
Update hoe_05 set oname = replace(oname,'','ü');
Update hoe_05 set oname = replace(oname,'á','ß');
Update hoe_05 set oname = replace(oname,'','Ö');
Update hoe_05 set oname = replace(oname,'','Ü');

Update hoe_05 set ggartbez = replace(ggartbez,'','ä');
Update hoe_05 set ggartbez = replace(ggartbez,'','ö');
Update hoe_05 set ggartbez = replace(ggartbez,'','ü');
Update hoe_05 set ggartbez = replace(ggartbez,'á','ß');
Update hoe_05 set ggartbez = replace(ggartbez,'','Ö');
Update hoe_05 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- hoe_11
-- pktnr character varying(16), - UPDATE
-- oska character varying(16),  -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE

Update hoe_11 set pktnr = replace(pktnr,'','ä');
Update hoe_11 set pktnr = replace(pktnr,'','ö');
Update hoe_11 set pktnr = replace(pktnr,'','ü');
Update hoe_11 set pktnr = replace(pktnr,'á','ß');
Update hoe_11 set pktnr = replace(pktnr,'','Ö');
Update hoe_11 set pktnr = replace(pktnr,'','Ü');

Update hoe_11 set ggartbez = replace(ggartbez,'','ä');
Update hoe_11 set ggartbez = replace(ggartbez,'','ö');
Update hoe_11 set ggartbez = replace(ggartbez,'','ü');
Update hoe_11 set ggartbez = replace(ggartbez,'á','ß');
Update hoe_11 set ggartbez = replace(ggartbez,'','Ö');
Update hoe_11 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- hoe_13
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE

Update hoe_13 set ggartbez = replace(ggartbez,'','ä');
Update hoe_13 set ggartbez = replace(ggartbez,'','ö');
Update hoe_13 set ggartbez = replace(ggartbez,'','ü');
Update hoe_13 set ggartbez = replace(ggartbez,'á','ß');
Update hoe_13 set ggartbez = replace(ggartbez,'','Ö');
Update hoe_13 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- hoe_15
-- oname character varying(254), - UPDATE
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE
-- aktualit character varying(10), - leer
-- straschl character varying(5), - leer
-- bezeichn character varying(40), - leer
-- nutzung character varying(20), - leer
-- befestig character varying(10), - leer
-- bearbeit character varying(5), - leer
-- ursprung character varying(20), - leer
-- schlagwo character varying(80), - leer
-- verweis character varying(254), - leer

Update hoe_15 set oname = replace(oname,'','ä');
Update hoe_15 set oname = replace(oname,'','ö');
Update hoe_15 set oname = replace(oname,'','ü');
Update hoe_15 set oname = replace(oname,'á','ß');
Update hoe_15 set oname = replace(oname,'','Ö');
Update hoe_15 set oname = replace(oname,'','Ü');

Update hoe_15 set ggartbez = replace(ggartbez,'','ä');
Update hoe_15 set ggartbez = replace(ggartbez,'','ö');
Update hoe_15 set ggartbez = replace(ggartbez,'','ü');
Update hoe_15 set ggartbez = replace(ggartbez,'á','ß');
Update hoe_15 set ggartbez = replace(ggartbez,'','Ö');
Update hoe_15 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- nah_01
-- pktnr character varying(16), - UPDATE
-- oska character varying(16),  -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE

Update nah_01 set pktnr = replace(pktnr,'','ä');
Update nah_01 set pktnr = replace(pktnr,'','ö');
Update nah_01 set pktnr = replace(pktnr,'','ü');
Update nah_01 set pktnr = replace(pktnr,'á','ß');
Update nah_01 set pktnr = replace(pktnr,'','Ö');
Update nah_01 set pktnr = replace(pktnr,'','Ü');

Update nah_01 set ggartbez = replace(ggartbez,'','ä');
Update nah_01 set ggartbez = replace(ggartbez,'','ö');
Update nah_01 set ggartbez = replace(ggartbez,'','ü');
Update nah_01 set ggartbez = replace(ggartbez,'á','ß');
Update nah_01 set ggartbez = replace(ggartbez,'','Ö');
Update nah_01 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- nah_03
-- oname character varying(254), - UPDATE
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE
-- aktualit character varying(10), - leer
-- straschl character varying(5), - leer
-- bezeichn character varying(40), - leer
-- nutzung character varying(20), - leer
-- befestig character varying(10), - leer
-- bearbeit character varying(5), - leer
-- ursprung character varying(20), - leer
-- schlagwo character varying(80), - leer
-- verweis character varying(254), - leer

Update nah_03 set oname = replace(oname,'','ä');
Update nah_03 set oname = replace(oname,'','ö');
Update nah_03 set oname = replace(oname,'','ü');
Update nah_03 set oname = replace(oname,'á','ß');
Update nah_03 set oname = replace(oname,'','Ö');
Update nah_03 set oname = replace(oname,'','Ü');

Update nah_03 set ggartbez = replace(ggartbez,'','ä');
Update nah_03 set ggartbez = replace(ggartbez,'','ö');
Update nah_03 set ggartbez = replace(ggartbez,'','ü');
Update nah_03 set ggartbez = replace(ggartbez,'á','ß');
Update nah_03 set ggartbez = replace(ggartbez,'','Ö');
Update nah_03 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- nah_05
-- oname character varying(254), - UPDATE
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE
-- aktualit character varying(10), - leer
-- straschl character varying(5), - leer
-- bezeichn character varying(40), - leer
-- nutzung character varying(20), - leer
-- befestig character varying(10), - leer
-- bearbeit character varying(5), - leer
-- ursprung character varying(20), - leer
-- schlagwo character varying(80), - leer
-- verweis character varying(254), - leer

Update nah_05 set oname = replace(oname,'','ä');
Update nah_05 set oname = replace(oname,'','ö');
Update nah_05 set oname = replace(oname,'','ü');
Update nah_05 set oname = replace(oname,'á','ß');
Update nah_05 set oname = replace(oname,'','Ö');
Update nah_05 set oname = replace(oname,'','Ü');

Update nah_05 set ggartbez = replace(ggartbez,'','ä');
Update nah_05 set ggartbez = replace(ggartbez,'','ö');
Update nah_05 set ggartbez = replace(ggartbez,'','ü');
Update nah_05 set ggartbez = replace(ggartbez,'á','ß');
Update nah_05 set ggartbez = replace(ggartbez,'','Ö');
Update nah_05 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- nah_11
-- pktnr character varying(16), - UPDATE
-- oska character varying(16),  -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE

Update nah_11 set pktnr = replace(pktnr,'','ä');
Update nah_11 set pktnr = replace(pktnr,'','ö');
Update nah_11 set pktnr = replace(pktnr,'','ü');
Update nah_11 set pktnr = replace(pktnr,'á','ß');
Update nah_11 set pktnr = replace(pktnr,'','Ö');
Update nah_11 set pktnr = replace(pktnr,'','Ü');

Update nah_11 set ggartbez = replace(ggartbez,'','ä');
Update nah_11 set ggartbez = replace(ggartbez,'','ö');
Update nah_11 set ggartbez = replace(ggartbez,'','ü');
Update nah_11 set ggartbez = replace(ggartbez,'á','ß');
Update nah_11 set ggartbez = replace(ggartbez,'','Ö');
Update nah_11 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- nah_13
-- oname character varying(254), - UPDATE
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE
-- aktualit character varying(10), - leer
-- straschl character varying(5), - leer
-- bezeichn character varying(40), - leer
-- nutzung character varying(20), - leer
-- befestig character varying(10), - leer
-- bearbeit character varying(5), - leer
-- ursprung character varying(20), - leer
-- schlagwo character varying(80), - leer
-- verweis character varying(254), - leer

Update nah_13 set oname = replace(oname,'','ä');
Update nah_13 set oname = replace(oname,'','ö');
Update nah_13 set oname = replace(oname,'','ü');
Update nah_13 set oname = replace(oname,'á','ß');
Update nah_13 set oname = replace(oname,'','Ö');
Update nah_13 set oname = replace(oname,'','Ü');

Update nah_13 set ggartbez = replace(ggartbez,'','ä');
Update nah_13 set ggartbez = replace(ggartbez,'','ö');
Update nah_13 set ggartbez = replace(ggartbez,'','ü');
Update nah_13 set ggartbez = replace(ggartbez,'á','ß');
Update nah_13 set ggartbez = replace(ggartbez,'','Ö');
Update nah_13 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- nah_15
-- oname character varying(254), - UPDATE
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE
-- aktualit character varying(10), - leer
-- straschl character varying(5), - leer
-- bezeichn character varying(40), - leer
-- nutzung character varying(20), - leer
-- befestig character varying(10), - leer
-- bearbeit character varying(5), - leer
-- ursprung character varying(20), - leer
-- schlagwo character varying(80), - leer
-- verweis character varying(254), - leer

Update nah_15 set oname = replace(oname,'','ä');
Update nah_15 set oname = replace(oname,'','ö');
Update nah_15 set oname = replace(oname,'','ü');
Update nah_15 set oname = replace(oname,'á','ß');
Update nah_15 set oname = replace(oname,'','Ö');
Update nah_15 set oname = replace(oname,'','Ü');

Update nah_15 set ggartbez = replace(ggartbez,'','ä');
Update nah_15 set ggartbez = replace(ggartbez,'','ö');
Update nah_15 set ggartbez = replace(ggartbez,'','ü');
Update nah_15 set ggartbez = replace(ggartbez,'á','ß');
Update nah_15 set ggartbez = replace(ggartbez,'','Ö');
Update nah_15 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- pol_05
-- oname character varying(254), - keine Sonderzeichen
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - keine Sonderzeichen
-- aktualit character varying(10), - leer
-- straschl character varying(5), - leer
-- bezeichn character varying(40), - UPDATE
-- nutzung character varying(20), - leer
-- befestig character varying(10), - leer
-- bearbeit character varying(5), - leer
-- ursprung character varying(20), - leer
-- schlagwo character varying(80), - leer
-- verweis character varying(254), - leer

Update pol_05 set bezeichn = replace(bezeichn,'','ä');
Update pol_05 set bezeichn = replace(bezeichn,'','ö');
Update pol_05 set bezeichn = replace(bezeichn,'','ü');
Update pol_05 set bezeichn = replace(bezeichn,'á','ß');
Update pol_05 set bezeichn = replace(bezeichn,'','Ö');
Update pol_05 set bezeichn = replace(bezeichn,'','Ü');

-------------------------------------------

-- str_03
-- oname character varying(254), - UPDATE
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE
-- aktualit character varying(10), - leer
-- straschl character varying(5), - leer
-- bezeichn character varying(40), - leer
-- nutzung character varying(20), - leer
-- befestig character varying(10), - leer
-- bearbeit character varying(5), - leer
-- ursprung character varying(20), - leer
-- schlagwo character varying(80), - leer
-- verweis character varying(254), - leer

Update str_03 set oname = replace(oname,'','ä');
Update str_03 set oname = replace(oname,'','ö');
Update str_03 set oname = replace(oname,'','ü');
Update str_03 set oname = replace(oname,'á','ß');
Update str_03 set oname = replace(oname,'','Ö');
Update str_03 set oname = replace(oname,'','Ü');

Update str_03 set ggartbez = replace(ggartbez,'','ä');
Update str_03 set ggartbez = replace(ggartbez,'','ö');
Update str_03 set ggartbez = replace(ggartbez,'','ü');
Update str_03 set ggartbez = replace(ggartbez,'á','ß');
Update str_03 set ggartbez = replace(ggartbez,'','Ö');
Update str_03 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- str_05
-- oname character varying(254), - UPDATE
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE
-- aktualit character varying(10), - enthält nur Zahlen
-- straschl character varying(5), - enthält nur Zahlen
-- bezeichn character varying(40), - UPDATE
-- nutzung character varying(20), - UPDATE
-- befestig character varying(10), - UPDATE
-- bearbeit character varying(5), - UPDATE
-- ursprung character varying(20), - UPDATE
-- schlagwo character varying(80), - UPDATE
-- verweis character varying(254), - UPDATE

Update str_05 set oname = replace(oname,'','ä');
Update str_05 set oname = replace(oname,'','ö');
Update str_05 set oname = replace(oname,'','ü');
Update str_05 set oname = replace(oname,'á','ß');
Update str_05 set oname = replace(oname,'','Ö');
Update str_05 set oname = replace(oname,'','Ü');

Update str_05 set ggartbez = replace(ggartbez,'','ä');
Update str_05 set ggartbez = replace(ggartbez,'','ö');
Update str_05 set ggartbez = replace(ggartbez,'','ü');
Update str_05 set ggartbez = replace(ggartbez,'á','ß');
Update str_05 set ggartbez = replace(ggartbez,'','Ö');
Update str_05 set ggartbez = replace(ggartbez,'','Ü');

Update str_05 set bezeichn = replace(bezeichn,'','ä');
Update str_05 set bezeichn = replace(bezeichn,'','ö');
Update str_05 set bezeichn = replace(bezeichn,'','ü');
Update str_05 set bezeichn = replace(bezeichn,'á','ß');
Update str_05 set bezeichn = replace(bezeichn,'','Ö');
Update str_05 set bezeichn = replace(bezeichn,'','Ü');

Update str_05 set nutzung = replace(nutzung,'','ä');
Update str_05 set nutzung = replace(nutzung,'','ö');
Update str_05 set nutzung = replace(nutzung,'','ü');
Update str_05 set nutzung = replace(nutzung,'á','ß');
Update str_05 set nutzung = replace(nutzung,'','Ö');

Update str_05 set befestig = replace(befestig,'','ä');
Update str_05 set befestig = replace(befestig,'','ö');
Update str_05 set befestig = replace(befestig,'','ü');
Update str_05 set befestig = replace(befestig,'á','ß');
Update str_05 set befestig = replace(befestig,'','Ö');

Update str_05 set bearbeit = replace(bearbeit,'','ä');
Update str_05 set bearbeit = replace(bearbeit,'','ö');
Update str_05 set bearbeit = replace(bearbeit,'','ü');
Update str_05 set bearbeit = replace(bearbeit,'á','ß');
Update str_05 set bearbeit = replace(bearbeit,'','Ö');
Update str_05 set bearbeit = replace(bearbeit,'','Ü');

Update str_05 set ursprung = replace(ursprung,'','ä');
Update str_05 set ursprung = replace(ursprung,'','ö');
Update str_05 set ursprung = replace(ursprung,'','ü');
Update str_05 set ursprung = replace(ursprung,'á','ß');
Update str_05 set ursprung = replace(ursprung,'','Ö');
Update str_05 set ursprung = replace(ursprung,'','Ü');

Update str_05 set schlagwo = replace(schlagwo,'','ä');
Update str_05 set schlagwo = replace(schlagwo,'','ö');
Update str_05 set schlagwo = replace(schlagwo,'','ü');
Update str_05 set schlagwo = replace(schlagwo,'á','ß');
Update str_05 set schlagwo = replace(schlagwo,'','Ö');
Update str_05 set schlagwo = replace(schlagwo,'','Ü');

Update str_05 set verweis = replace(verweis,'','ä');
Update str_05 set verweis = replace(verweis,'','ö');
Update str_05 set verweis = replace(verweis,'','ü');
Update str_05 set verweis = replace(verweis,'á','ß');
Update str_05 set verweis = replace(verweis,'','Ö');
Update str_05 set verweis = replace(verweis,'','Ü');

-------------------------------------------

-- str_13
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE

Update str_13 set ggartbez = replace(ggartbez,'','ä');
Update str_13 set ggartbez = replace(ggartbez,'','ö');
Update str_13 set ggartbez = replace(ggartbez,'','ü');
Update str_13 set ggartbez = replace(ggartbez,'á','ß');
Update str_13 set ggartbez = replace(ggartbez,'','Ö');
Update str_13 set ggartbez = replace(ggartbez,'','Ü');

-------------------------------------------

-- str_15
-- oname character varying(254), - UPDATE
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE
-- aktualit character varying(10), - enthält nur Zahlen
-- straschl character varying(5), - enthält nur Zahlen
-- bezeichn character varying(40), - UPDATE
-- nutzung character varying(20), - UPDATE
-- befestig character varying(10), - UPDATE
-- bearbeit character varying(5), - UPDATE
-- ursprung character varying(20), - UPDATE
-- schlagwo character varying(80), - UPDATE
-- verweis character varying(254), - UPDATE

Update str_15 set oname = replace(oname,'','ä');
Update str_15 set oname = replace(oname,'','ö');
Update str_15 set oname = replace(oname,'','ü');
Update str_15 set oname = replace(oname,'á','ß');
Update str_15 set oname = replace(oname,'','Ö');
Update str_15 set oname = replace(oname,'','Ü');

Update str_15 set ggartbez = replace(ggartbez,'','ä');
Update str_15 set ggartbez = replace(ggartbez,'','ö');
Update str_15 set ggartbez = replace(ggartbez,'','ü');
Update str_15 set ggartbez = replace(ggartbez,'á','ß');
Update str_15 set ggartbez = replace(ggartbez,'','Ö');
Update str_15 set ggartbez = replace(ggartbez,'','Ü');

Update str_15 set bezeichn = replace(bezeichn,'','ä');
Update str_15 set bezeichn = replace(bezeichn,'','ö');
Update str_15 set bezeichn = replace(bezeichn,'','ü');
Update str_15 set bezeichn = replace(bezeichn,'á','ß');
Update str_15 set bezeichn = replace(bezeichn,'','Ö');
Update str_15 set bezeichn = replace(bezeichn,'','Ü');

Update str_15 set nutzung = replace(nutzung,'','ä');
Update str_15 set nutzung = replace(nutzung,'','ö');
Update str_15 set nutzung = replace(nutzung,'','ü');
Update str_15 set nutzung = replace(nutzung,'á','ß');
Update str_15 set nutzung = replace(nutzung,'','Ö');

Update str_15 set befestig = replace(befestig,'','ä');
Update str_15 set befestig = replace(befestig,'','ö');
Update str_15 set befestig = replace(befestig,'','ü');
Update str_15 set befestig = replace(befestig,'á','ß');
Update str_15 set befestig = replace(befestig,'','Ö');

Update str_15 set bearbeit = replace(bearbeit,'','ä');
Update str_15 set bearbeit = replace(bearbeit,'','ö');
Update str_15 set bearbeit = replace(bearbeit,'','ü');
Update str_15 set bearbeit = replace(bearbeit,'á','ß');
Update str_15 set bearbeit = replace(bearbeit,'','Ö');
Update str_15 set bearbeit = replace(bearbeit,'','Ü');

Update str_15 set ursprung = replace(ursprung,'','ä');
Update str_15 set ursprung = replace(ursprung,'','ö');
Update str_15 set ursprung = replace(ursprung,'','ü');
Update str_15 set ursprung = replace(ursprung,'á','ß');
Update str_15 set ursprung = replace(ursprung,'','Ö');
Update str_15 set ursprung = replace(ursprung,'','Ü');

Update str_15 set schlagwo = replace(schlagwo,'','ä');
Update str_15 set schlagwo = replace(schlagwo,'','ö');
Update str_15 set schlagwo = replace(schlagwo,'','ü');
Update str_15 set schlagwo = replace(schlagwo,'á','ß');
Update str_15 set schlagwo = replace(schlagwo,'','Ö');
Update str_15 set schlagwo = replace(schlagwo,'','Ü');

Update str_15 set verweis = replace(verweis,'','ä');
Update str_15 set verweis = replace(verweis,'','ö');
Update str_15 set verweis = replace(verweis,'','ü');
Update str_15 set verweis = replace(verweis,'á','ß');
Update str_15 set verweis = replace(verweis,'','Ö');
Update str_15 set verweis = replace(verweis,'','Ü');

-------------------------------------------

-- str_99
-- txtinh character varying(254),
-- oska character varying(16), -  enthält nur Zahlen
-- ggartbez character varying(254), - UPDATE

Update str_15 set ggartbez = replace(ggartbez,'','ä');
Update str_15 set ggartbez = replace(ggartbez,'','ö');
Update str_15 set ggartbez = replace(ggartbez,'','ü');
Update str_15 set ggartbez = replace(ggartbez,'á','ß');
Update str_15 set ggartbez = replace(ggartbez,'','Ö');
Update str_15 set ggartbez = replace(ggartbez,'','Ü');