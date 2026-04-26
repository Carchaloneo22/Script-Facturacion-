CREATE OR REPLACE FUNCTION fun_update_ciudad(wid_ciudad tab_ciudades.id_ciudad%TYPE,wnom_ciudad tab_ciudades.nom_ciudad%TYPE) RETURNS BOOLEAN AS
$$
    BEGIN
    -- validaciones 
         -- validacion de si ya existe el id de la ciudad
        IF fun_existe_reg_ciu(wid_ciudad) THEN
            RAISE NOTICE 'El Registro de la ciudad existe... Por fin hizo algo bueno...';
        ELSE
            RAISE NOTICE 'El Registro de la ciudad NO existe... Si es bruto.....';
			RETURN FALSE;
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
       
        -- SI PASÓ TODAS LAS VALIDACIONES, Actualiza:
		UPDATE tab_ciudades
		SET nom_ciudad  = wnom_ciudad
        WHERE id_ciudad = wid_ciudad;
		IF FOUND THEN
                RAISE NOTICE 'La Actualización fue exitosa';
            RETURN TRUE;
        ELSE
            RAISE NOTICE 'La Actualización NO fue exitosa';
            RETURN FALSE;
        END IF;
    END;
$$
LANGUAGE PLPGSQL;



