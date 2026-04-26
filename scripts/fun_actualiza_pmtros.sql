--SELECT * FROM tab_pmtros;
--SELECT fun_actualiza_pmtros(5001);
CREATE OR REPLACE FUNCTION fun_actualiza_pmtros(wwid_factura tab_enc_fac.id_factura%TYPE) RETURNS BOOLEAN AS
$$
    BEGIN
        wwid_factura = wwid_factura + 1;
        UPDATE tab_pmtros SET val_facactual = wwid_factura
        WHERE id_empresa = 111;
        IF FOUND THEN
            RAISE NOTICE 'La factura actual cambió en PMTROS, ahora es el No. %',wwid_factura;
            RETURN TRUE;
        ELSE
            RAISE NOTICE 'No se actualizó pmtros en la factura, Revise Llave';
            RETURN FALSE;
        END IF;
    END;
$$
LANGUAGE PLPGSQL;