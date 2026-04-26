--SELECT fun_ejemplo3();
CREATE OR REPLACE FUNCTION fun_ejemplo3() RETURNS BOOLEAN AS
$BODY$
	DECLARE wreg_ciudades RECORD;
	DECLARE wcur_ciudades REFCURSOR;
	BEGIN
		OPEN wcur_ciudades FOR SELECT a.id_ciudad,a.nom_ciudad FROM tab_ciudades a;
			FETCH wcur_ciudades INTO wreg_ciudades;
			WHILE FOUND LOOP
				RAISE NOTICE 'Ciudad % - %',wreg_ciudades.id_ciudad,wreg_ciudades.nom_ciudad;
				FETCH wcur_ciudades INTO wreg_ciudades;
			END LOOP;
		CLOSE wcur_ciudades;
		RETURN TRUE;
	END;
$BODY$
LANGUAGE PLPGSQL;
--SELECT a.id_ciudad,a.nom_ciudad FROM tab_ciudades a;