CREATE OR REPLACE FUNCTION fun_insert_detalle(wwid_factura tab_det_fac.id_factura%TYPE, wwprod TEXT[], wwcant INTEGER[]) RETURNS BOOLEAN AS
$$
    DECLARE wreg_prod       RECORD;
    DECLARE prod            tab_prod.id_prod%TYPE;
    DECLARE wreg_clientes   RECORD;
    DECLARE i               SMALLINT;
    BEGIN
-- CICLO PARA RECORRER EL ARREGLO DE PRODUCTOS Y CANTIDADES PARA INSERTAR
        FOR i IN 1..ARRAY_LENGTH(wwprod,1) LOOP
            SELECT a.id_prod,a.nom_prod,a.val_precio,a.ind_iva,a.ind_descuento
            INTO wreg_prod FROM tab_prod a
            WHERE a.id_prod = wwprod[i];
            RAISE NOTICE 'Producto: %-% Cant:%',wreg_prod.id_prod,wreg_prod.nom_prod,wwcant[i];
        END LOOP;
        RETURN TRUE;
    END;
$$
LANGUAGE PLPGSQL;