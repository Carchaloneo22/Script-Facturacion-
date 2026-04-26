--INSERT INTO tab_ciudades VALUES('11001','Bogotá D.C.');
--INSERT INTO tab_ciudades VALUES('05001','Medellín');
--INSERT INTO tab_ciudades VALUES('68001','Bucaramanga');

--DELETE FROM tab_clientes;
--SELECT fun_insert_clientes('91423627','Carlos Perez','11001','Calle 20 32-41','3503421739','1964-01-14','0','0',CURRENT_DATE,'2027-03-27');
--SELECT * FROM tab_clientes;

CREATE OR REPLACE FUNCTION fun_insert_clientes(wid_cliente tab_clientes.id_cliente%TYPE,wnom_cliente tab_clientes.nom_cliente%TYPE,
                                               wid_ciudad tab_clientes.id_ciudad%TYPE,wdir_cliente DATOS_CLIENTE.dir_cliente%TYPE,wtel_cliente DATOS_CLIENTE.tel_cliente%TYPE,
                                               wfec_nacimi tab_clientes.fec_nacimi%TYPE,wval_puntos tab_clientes.val_puntos%TYPE,
                                               wval_compras tab_clientes.val_compras%TYPE,wfec_primcompra tab_clientes.fec_primcompra%TYPE,
                                               wfec_vencptos tab_clientes.fec_vencptos%TYPE) RETURNS BOOLEAN AS
$$
    DECLARE wtab_clientes tab_clientes;
    BEGIN
        wtab_clientes := ROW(wid_cliente,wnom_cliente,ROW(wdir_cliente, wtel_cliente)::DATOS_CLIENTE,wid_ciudad,wfec_nacimi,wval_puntos,wval_compras,
                             COALESCE(wfec_primcompra, CURRENT_DATE),COALESCE(wfec_vencptos, CURRENT_DATE + INTERVAL '1 YEAR'))::tab_clientes;
        INSERT INTO tab_clientes VALUES (wtab_clientes.*);
        IF FOUND THEN
            RAISE NOTICE 'Cliente % insertado bien, va funcionando y vamos bien', wid_cliente;
            RETURN TRUE;
        ELSE
            RAISE NOTICE 'No le funcionó la vuelta, arréglelo o deserte. El cliente % no se insertó.. PAILAS', wid_cliente;
            RETURN FALSE;
        END IF;
    END;
$$
LANGUAGE PLPGSQL; 