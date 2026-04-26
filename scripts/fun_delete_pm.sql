--SELECT fun_delete_pmtros('111');
--SELECT * FROM tab_pmtros;
CREATE OR REPLACE FUNCTION fun_delete_pmtros(wid_empresa tab_pmtros.id_empresa%TYPE) RETURNS BOOLEAN AS
$$
    BEGIN
-- Llamado a función que valida la existencia del registro
        IF fun_existe_reg(wid_empresa) THEN
            RAISE NOTICE 'El Registro de pmtros existe... Por fin hizo algo bueno...';
            DELETE FROM tab_pmtros
            WHERE id_empresa = wid_empresa;
            IF FOUND THEN
                RAISE NOTICE 'El Registro de Parámetros %, fue borrado',wid_empresa;
                RETURN TRUE;
            ELSE
                RAISE NOTICE 'Error al borra... Snimal, haga todo bien';
                RETURN FALSE;                
            END IF;
        ELSE
            RAISE NOTICE 'El Registro de pmtros NO existe... So bruto.....';
			RETURN FALSE;
        END IF;
    END;
$$
LANGUAGE PLPGSQL;