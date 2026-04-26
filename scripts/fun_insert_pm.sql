--SELECT fun_insert_pmtros('111','68001','5000','10000',5000,'19','2','1000','1000');

CREATE OR REPLACE FUNCTION fun_insert_pmtros(wid_empresa tab_pmtros.id_empresa%TYPE,wid_ciudad tab_pmtros.id_ciudad%TYPE,
                                             wval_inifac tab_pmtros.val_inifac%TYPE,wval_finfac tab_pmtros.val_finfac%TYPE,
                                             wval_facactual tab_pmtros.val_finfac%TYPE,wval_iva tab_pmtros.val_iva%TYPE,
                                             wval_pordesc tab_pmtros.val_pordesc%TYPE,wval_minpuntos tab_pmtros.val_minpuntos%TYPE,
                                             wval_ptosxpeso tab_pmtros.val_ptosxpeso%TYPE) RETURNS BOOLEAN AS
$$
    BEGIN
-- VALIDACIONES
        IF wid_empresa IS NULL THEN
            RAISE NOTICE 'El ID de la empresa no puede ser nulo, arréglelo bestia...';        
            RETURN FALSE;
        END IF;
        CASE wval_inifac
            WHEN NULL THEN 
                RAISE NOTICE 'El valor inicial de factura no puede ser NULO... Sea serio calabazo';
                RETURN FALSE;
            WHEN 0 THEN
                RAISE NOTICE 'El valor inicial de factura no puede ser 0... Sea serio calabazo';
                RETURN FALSE;
            ELSE
                RAISE NOTICE 'El valor inicial de factura viene dañado y no soy adivino... Sea serio calabazo';
                RETURN FALSE;
        END CASE;
        INSERT INTO tab_pmtros VALUES(wid_empresa,wid_ciudad,wval_inifac,wval_finfac,wval_factual,wval_iva,
                                      wval_pordesc,wval_minpuntos,wval_ptosxpeso);
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