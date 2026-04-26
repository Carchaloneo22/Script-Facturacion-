--SELECT fun_delete_Ciudad('68001');
--SELECT * FROM tab_ciudades;
CREATE OR REPLACE FUNCTION fun_delete_Ciudad(wid_ciudad tab_ciudades.id_ciudad%TYPE) RETURNS BOOLEAN AS
$$
    BEGIN
-- Llamado a función que valida la existencia del registro
        IF fun_existe_reg_ciu(wid_ciudad) THEN
            RAISE NOTICE 'El Registro de la ciudad existe... Por fin hizo algo bueno...';
            DELETE FROM tab_ciudades
            WHERE id_ciudad = wid_ciudad  ;
            IF FOUND THEN
                RAISE NOTICE 'El Registro de la Ciudad %, fue borrado',wid_ciudad  ;
                RETURN TRUE;
            ELSE
                RAISE NOTICE 'Error al borra... animal, haga todo bien';
                RETURN FALSE;                
            END IF;
        ELSE
            RAISE NOTICE 'El Registro de la ciudad NO existe... Si es bruto.....';
			RETURN FALSE;
        END IF;
    END;
$$
LANGUAGE PLPGSQL;