-- ALKIS Navigation in eine MB-GUI einfuegen 
-- 2010-11-17


-- MB 2.6.2

INSERT INTO gui_element(fkey_gui_id, e_id, e_pos, e_public, e_comment, e_title, 
e_element, e_src, e_attributes, e_left, e_top, e_width, e_height, e_z_index, 
e_more_styles, e_content, e_closetag, e_js_file, e_mb_mod, e_target, e_requires, e_url) 
VALUES(
	'Lage_1',
	'gazetteer_alkis',
	2,1,
	'ALKIS-Navigation (in Tab)',
	'Liegenschaftskataster ALKIS',
	'iframe',
	'../nav/alkisnav.htm?gkz=150&gemeinde=40&sessionID',
	'frameborder = "0" onmouseover="this.style.zIndex=300;this.style.width=280;" onmouseout="this.style.zIndex=2;this.style.width=225"',1,1,1,1,1,'visibility:hidden; border: 1px solid #a19c8f;'
	,'','iframe','','','mapframe1','','');



-- MB 2.5

-- Lage 150  40
-- HBM  140  32
-- Leo  070  48

-- Demo rlp 103    epsg 25832

INSERT INTO gui_element(fkey_gui_id, e_id, e_pos, e_public, e_comment, 
e_title, e_element, e_src, e_attributes, e_left, e_top, 
e_width, e_height, e_z_index, e_more_styles, e_content, 
e_closetag, e_js_file, e_mb_mod, e_target, e_requires, e_url) 
VALUES(
	'Lage_1',   -- GUI-Name
	'gazetteer_alkis',
	2,1,
	'ALKIS-Navigation (in Tab)',
	'Liegenschaftskataster ALKIS',
	'iframe',
	'../nav/alkisnav.htm?gkz=150&gemeinde=40&sessionID',  -- GKZ, Gemeinde-Schluessel
	'frameborder = "1"',1,1,1,1,1,
	'visibility:hidden',
	'','iframe','','','mapframe1','','');


INSERT INTO gui_element(fkey_gui_id, e_id, e_pos, e_public, e_comment, 
e_title, e_element, e_src, e_attributes, e_left, e_top, 
e_width, e_height, e_z_index, e_more_styles, e_content, 
e_closetag, e_js_file, e_mb_mod, e_target, e_requires, e_url) 
VALUES(
	'Leopoldshoehe_1',   -- GUI-Name
	'gazetteer_alkis',
	2,1,
	'ALKIS-Navigation (in Tab)',
	'Liegenschaftskataster ALKIS',
	'iframe',
	'../nav/alkisnav.htm?gkz=070&gemeinde=&sessionID',  -- GKZ, Gemeinde-Schluessel
	'frameborder = "1"',1,1,1,1,1,
	'visibility:hidden',
	'','iframe','','','mapframe1','','');


-- WWW

INSERT INTO gui_element(fkey_gui_id, e_id, e_pos, e_public, e_comment, 
e_title, e_element, e_src, e_attributes, e_left, e_top, 
e_width, e_height, e_z_index, e_more_styles, e_content, 
e_closetag, e_js_file, e_mb_mod, e_target, e_requires, e_url) 
VALUES(
	'ALKIS_Demo',   -- GUI-Name
	'gazetteer_alkis',
	2,1,
	'ALKIS-Navigation (in Tab)',
	'Liegenschaftskataster ALKIS',
	'iframe',
	'../nav/alkisnav.htm?gkz=rlp&gemeinde=103&sessionID',  -- GKZ, Gemeinde-Schluessel
	'frameborder = "1"',1,1,1,1,1,
	'visibility:hidden',
	'','iframe','','','mapframe1','','');

