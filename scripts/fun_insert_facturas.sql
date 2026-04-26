--DELETE FROM tab_enc_fac;
--SELECT fun_insert_facturas('1001','102',ARRAY['P01', 'P02', 'P03'],ARRAY[10,5,4]);
CREATE OR REPLACE FUNCTION fun_insert_facturas(wid_cliente tab_enc_fac.id_cliente%TYPE,
                                  wid_vendedor tab_enc_fac.id_vendedor%TYPE,
                                  wprod TEXT[], wcant INTEGER[]) RETURNS BOOLEAN AS
$$
    DECLARE wreg_pmtros RECORD;
	DECLARE wid_factura tab_enc_fac.id_factura%TYPE;
	DECLARE wind_estado tab_enc_fac.ind_estado%TYPE;
	DECLARE wval_total	tab_enc_fac.val_total%TYPE;
    BEGIN
-- EXTRAER LA FACTURA DE PARÁMETROS.
        SELECT a.id_empresa,a.id_ciudad,a.val_inifac,a.val_finfac,a.val_facactual,
               a.val_iva,a.val_pordesc,a.val_minpuntos,a.val_ptosxpeso
        INTO wreg_pmtros FROM tab_pmtros a
        WHERE a.id_empresa = 111;
        IF NOT FOUND THEN
            RAISE NOTICE 'Esta joda se TOTIÓ.. No hay nada en PMTROS';
            RETURN FALSE;
        END IF;
        IF wind_estado IS NULL THEN
            wind_estado = FALSE;
        END IF;
		wid_factura = wreg_pmtros.val_facactual;
		IF wid_factura > wreg_pmtros.val_finfac THEN
			RAISE NOTICE 'Pilas MIJOOOO, se alcanzó el límite de las facturas... Pida a la DIAN o NOS JODIMOS...';
			RETURN FALSE;
		END IF;
        wval_total = 0;
-- INSERCIÓN DE FILAS EN LA TABLA ENCABEZADO DE FACTURA
        INSERT INTO tab_enc_fac VALUES(wid_factura,wreg_pmtros.id_ciudad,wid_cliente,
                                       CURRENT_DATE,wid_vendedor,wind_estado,wval_total);
        IF FOUND THEN
            RAISE NOTICE 'La factura % se insertó... No es ni tan bruto... Ahora voy a hacer Detalle',wid_factura;
			IF NOT fun_actualiza_pmtros(wid_factura) THEN
				RETURN FALSE;
			END IF;
            IF fun_insert_detalle(wid_factura, wprod, wcant) THEN
				RAISE NOTICE 'Muy bien calabazo de la Damier... La factura % quedó grabada',wid_factura;
				RETURN TRUE;
			END IF;
        ELSE
            RAISE NOTICE 'This is a SHIT, go back to the elementary school %... brutation...',wid_factura;
            RETURN FALSE;
        END IF;
    END;
$$
LANGUAGE plpgsql;

--SELECT * FROM tab_enc_fac;