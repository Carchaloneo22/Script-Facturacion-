--SELECT fun_delete_vendedor('101');
--SELECT * FROM tab_vendedor;
CREATE OR REPLACE FUNCTION fun_delete_vendedor(wid_vendedor tab_vendedor.id_vendedor%TYPE) RETURNS BOOLEAN AS
$$
    BEGIN
-- Llamado a función que valida la existencia del registro
        IF fun_existe_reg_ven(wid_vendedor) THEN
            RAISE NOTICE 'El Registro del vendedor  existe... Por fin hizo algo bueno...';
            DELETE FROM tab_vendedor
            WHERE id_vendedor = wid_vendedor  ;
            IF FOUND THEN
                RAISE NOTICE 'El Registro del vendedor  %, fue borrado',wid_vendedor  ;
                RETURN TRUE;
            ELSE
                RAISE NOTICE 'Error al borra... animal, haga todo bien';
                RETURN FALSE;                
            END IF;
        ELSE
            RAISE NOTICE 'El Registro del vendedor  NO existe... Si es bruto.....';
			RETURN FALSE;
        END IF;
    END;
$$
LANGUAGE PLPGSQL;