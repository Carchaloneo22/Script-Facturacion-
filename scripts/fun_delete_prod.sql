--SELECT fun_delete_prod('P01');
--SELECT * FROM tab_prod;
CREATE OR REPLACE FUNCTION fun_delete_prod(wid_prod tab_prod.id_prod%TYPE) RETURNS BOOLEAN AS
$$
    BEGIN
-- Llamado a función que valida la existencia del registro
        IF fun_existe_reg(wid_prod) THEN
            RAISE NOTICE 'El Registro del producto  existe... por lo tanto se procede a Borrarse...';
            DELETE FROM tab_prod
            WHERE id_prod = wid_prod  ;
            IF FOUND THEN
                RAISE NOTICE 'El Registro del producto  %, fue borrado',wid_prod  ;
                RETURN TRUE;
            ELSE
                RAISE NOTICE 'Error al borra... animal, haga todo bien';
                RETURN FALSE;                
            END IF;
        ELSE
            RAISE NOTICE 'El Registro del producto  NO existe... Si es bruto.....';
			RETURN FALSE;
        END IF;
    END;
$$
LANGUAGE PLPGSQL;