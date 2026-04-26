SELECT fun_delete_cliente('91423627');
CREATE OR REPLACE FUNCTION fun_delete_cliente(
    wid_cliente tab_clientes.id_cliente%TYPE
) 
RETURNS BOOLEAN AS
$$
DECLARE 
    wwid_cliente tab_clientes.id_cliente%TYPE;
BEGIN
    -- Validar existencia
    SELECT a.id_cliente INTO wwid_cliente
    FROM tab_clientes a
    WHERE a.id_cliente = wid_cliente;

    IF NOT FOUND THEN
        RAISE NOTICE 'No funciona, el registro NO existe';
        RETURN FALSE;
    END IF;

    -- Eliminar
    DELETE FROM tab_clientes
    WHERE id_cliente = wid_cliente;

    IF FOUND THEN
        RAISE NOTICE 'Registro eliminado correctamente';
        RETURN TRUE;
    ELSE
        RAISE NOTICE 'No se pudo eliminar el registro';
        RETURN FALSE;
    END IF;

END;
$$
LANGUAGE plpgsql;