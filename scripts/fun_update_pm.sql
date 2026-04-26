--SELECT fun_update_pmtros('111','80000','10000','19','2','1000','1000');
CREATE OR REPLACE FUNCTION fun_update_pmtros(wid_empresa tab_pmtros.id_empresa%TYPE,wval_inifac tab_pmtros.val_inifac%TYPE,
                                             wval_finfac tab_pmtros.val_finfac%TYPE,wval_iva tab_pmtros.val_iva%TYPE,
                                             wval_pordesc tab_pmtros.val_pordesc%TYPE,wval_minpuntos tab_pmtros.val_minpuntos%TYPE,
                                             wval_ptosxpeso tab_pmtros.val_ptosxpeso%TYPE) RETURNS BOOLEAN AS
$$
    BEGIN
-- VALIDACIONES
        -- validacion de si ya existe el id de la empresa
        IF fun_existe_reg(wid_empresa) THEN
            RAISE NOTICE 'El Registro de pmtros existe... Por fin hizo algo bueno...';
        ELSE
            RAISE NOTICE 'El Registro de pmtros NO existe... So bruto.....';
			RETURN FALSE;
        END IF;
        -- Validación Inicio Factura
        IF fun_validar_num(wval_inifac,0,wval_finfac) THEN
            RAISE NOTICE 'si funciona';
        ELSE
            RAISE NOTICE 'el numero no cumple';
			RETURN FALSE;
        END IF;
 -- Validación Fin Factura
        CASE wval_finfac
            WHEN NULL THEN 
                RAISE NOTICE 'El valor Final de factura no puede ser NULO... Sea serio calabazo';
                RETURN FALSE;
            WHEN 0 THEN
                RAISE NOTICE 'El valor Final de factura no puede ser 0... Sea serio calabazo';
                RETURN FALSE;
            ELSE
                IF (wval_inifac < wval_finfac) THEN 
                    RAISE NOTICE 'No puede ser menor que  el valor inicial de la factura';
                    RETURN FALSE;
                END IF;   
        END CASE;
       -- Validación IVA
        CASE wval_iva
            WHEN NULL THEN 
                RAISE NOTICE 'El valor del iva no puede ser NULO... Sea serio calabazo';
                RETURN FALSE;
            WHEN  wval_iva < 0 OR wval_iva > 99 THEN
                RAISE NOTICE 'El valor del iva  no puede ser 0, ni mayor de 99... Sea serio calabazo';
                RETURN FALSE;
            ELSE 
        END CASE;
        --  Validación Porcentaje Descuento
        CASE wval_pordes
            WHEN  NULL THEN
                RAISE NOTICE 'El descuento no puede ser nulo...';
                RETURN FALSE;
            WHEN wval_pordes < 0 OR wval_pordes > 99 THEN
                RAISE NOTICE 'El descuento debe estar entre 0 y 99..';
                RETURN FALSE;
            ELSE
        END CASE;
        --  Validación Puntos
        CASE 
            WHEN wval_minpuntos IS NULL OR wval_ptosxpeso IS NULL THEN
                RAISE NOTICE 'Los campos de puntos no pueden ser nulos...';
                RETURN FALSE;
            WHEN wval_minpuntos < 0 OR wval_ptosxpeso < 0 THEN
                RAISE NOTICE 'Los puntos no pueden ser valores negativos...';
                RETURN FALSE;
            ELSE
        END CASE;
		--  -- SI PASÓ TODAS LAS VALIDACIONES, Actualiza:
		UPDATE tab_pmtros
		SET val_inifac    = wval_inifac,
            val_finfac    = wval_finfac,
            val_iva       = wval_iva,   
            val_pordesc   = wval_pordesc,
            val_minpuntos = wval_minpuntos,
            val_ptosxpeso = wval_ptosxpeso
        WHERE id_empresa = wid_empresa;
		IF FOUND THEN
            RAISE NOTICE 'REgistro actualizado';
            RETURN TRUE;
        END IF;
		RETURN FALSE;
    END;
$$
LANGUAGE PLPGSQL;

--SELECT fun_validar_num(5000,0,10000);
CREATE OR REPLACE FUNCTION fun_validar_num(w_num BIGINT,w_min BIGINT,w_max BIGINT) RETURNS BOOLEAN AS
$$
    BEGIN
        IF w_num BETWEEN w_min AND w_max THEN
            RETURN TRUE;
        END IF;
        RETURN FALSE;
    END;
$$
LANGUAGE PLPGSQL;