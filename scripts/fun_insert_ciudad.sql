CREATE OR REPLACE FUNCTION fun_insert_ciudad(wid_ciudad tab_ciudades.id_ciudad%TYPE,wnom_ciudad tab_ciudades.nom_ciudad%TYPE) RETURNS BOOLEAN AS
$$
    BEGIN
        -- Validación ID Ciudad: No nulo y máximo 5 caracteres
        IF wid_ciudad IS NULL THEN
            RAISE NOTICE 'El ID de la ciudad no puede ser nulo, arréglelo bestia...';        
            RETURN FALSE;
        ELSE IF LENGTH(wid_ciudad) > 5 THEN
            	RAISE NOTICE 'El ID no puede tener más de 5 caracteres... Sea serio calabazo';
            	RETURN FALSE;
			 END IF;
        END IF;

        -- Validación Nombre Ciudad: No nulo, no vacío y sin números
        IF wnom_ciudad IS NULL OR wnom_ciudad = '' THEN
            RAISE NOTICE 'El nombre de la ciudad no puede ser nulo ni estar vacío...';
            RETURN FALSE;
        -- El operador ~ '[0-9]' busca si hay algún número en el texto
        ELSE IF wnom_ciudad ~ '[0-9]' THEN
            	RAISE NOTICE 'El nombre de la ciudad no puede llevar números... ¡Póngase serio!';
            	RETURN FALSE;
			END IF;
        END IF;
        -- validacion de si ya existe el id de la ciudad
        IF fun_existe_reg_ciu(wid_ciudad) THEN
            RAISE NOTICE 'El Registro de la ciudad (%) ya existe... No lo puedes agregar', wid_ciudad;
			RETURN FALSE;
        END IF;
        -- SI PASÓ TODAS LAS VALIDACIONES, INSERTA:
        INSERT INTO tab_ciudades VALUES(wid_ciudad,wnom_ciudad);
        IF FOUND THEN
            RAISE NOTICE 'La inserción fue exitosa';
            RETURN TRUE;
        ELSE
            RAISE NOTICE 'La inserción NO fue exitosa';
            RETURN FALSE;
        END IF;
    END;
$$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION fun_existe_reg_ciu(wwid_ciudad tab_ciudades.id_ciudad%TYPE) RETURNS BOOLEAN AS
$$
    DECLARE wwwid_ciudad tab_ciudades.id_ciudad%TYPE;
    BEGIN
        SELECT a.id_ciudad INTO wwwid_ciudad FROM tab_ciudades a
        WHERE a.id_ciudad = wwid_ciudad;
        IF FOUND THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END;
$$
LANGUAGE PLPGSQL;