
--SELECT fun_update_clientes('91423627','Carlos Eduardo Perez','01','Calle 20 32-41 apto 507','350342173','1964-01-14','0','0',CURRENT_DATE,'2027-03-27');
CREATE OR REPLACE FUNCTION fun_update_clientes(
    wid_cliente tab_clientes.id_cliente%TYPE,
    wnom_cliente tab_clientes.nom_cliente%TYPE,
    wid_ciudad tab_clientes.id_ciudad%TYPE,
    wdir_cliente DATOS_CLIENTE.dir_cliente%TYPE,
    wtel_cliente DATOS_CLIENTE.tel_cliente%TYPE,
    wfec_nacimi tab_clientes.fec_nacimi%TYPE,
    wval_puntos tab_clientes.val_puntos%TYPE,
    wval_compras tab_clientes.val_compras%TYPE,
    wfec_primcompra tab_clientes.fec_primcompra%TYPE,
    wfec_vencptos tab_clientes.fec_vencptos%TYPE) RETURNS BOOLEAN AS

$$
    DECLARE wwid_cliente tab_clientes.id_cliente%TYPE;
    DECLARE wdatos_cliente DATOS_CLIENTE;
    BEGIN
    --VALIDACIÓN DE LA EXISTENCIA DE LA LLAVE PRIMARIA
    SELECT a.id_cliente INTO wwid_cliente FROM tab_clientes a 
    WHERE a.id_cliente = wid_cliente;
    IF FOUND THEN
       RAISE NOTICE 'Funciona, sí existe el registro';
    ELSE
       RAISE NOTICE 'No funciona, el registro NO existe';
       RETURN FALSE;
    END IF;
    --VALIDACION NOMBRE DEL CLIENTE
    IF TRIM('wnom_cliente') IS NULL THEN
        RAISE NOTICE 'No sea bruto, el cliente no puede ser nulo';
        RETURN FALSE;
    END IF;
    wdatos_cliente = ROW(wdir_cliente, wtel_cliente);
    --Acá va el update
    UPDATE tab_clientes
    SET nom_cliente    = wnom_cliente, 
        id_ciudad      = wid_ciudad, 
        dat_cliente    = wdatos_cliente, 
        fec_nacimi     = wfec_nacimi, 
        val_puntos     = wval_puntos, 
        val_compras    = wval_compras, 
        fec_primcompra = wfec_primcompra,
        fec_vencptos   = wfec_vencptos
    WHERE id_cliente   = wid_cliente; 
    IF FOUND THEN
        RAISE NOTICE 'Registro actualizado';
        RETURN TRUE;
    ELSE
        RAISE NOTICE 'Registro no actualizado';
        RETURN FALSE;
    END IF;
    END;
$$
LANGUAGE PLPGSQL;