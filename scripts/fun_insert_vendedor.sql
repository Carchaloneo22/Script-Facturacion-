CREATE OR REPLACE FUNCTION fun_insert_vendedor(wid_vendedor tab_vendedor.id_vendedor%TYPE,wnom_vendedor tab_vendedor.nom_vendedor%TYPE,
                                               wval_ventas tab_vendedor.val_ventas%TYPE, wval_porcomi tab_vendedor.val_porcomi%TYPE) RETURNS BOOLEAN AS
$$
    BEGIN
    --Validaciones 
        -- Validación ID Vendedor
        IF wid_vendedor IS NULL OR wid_vendedor <= 0 OR wid_vendedor >= 9999999999 THEN
            RAISE NOTICE 'El ID del vendedor debe ser un número positivo Y NO puede pasar de 10 digitos... Sea serio calabazo';
            RETURN FALSE;
        END IF;
        -- Validación Nombre Vendedor
        IF wnom_vendedor IS NULL OR TRIM(wnom_vendedor) = '' THEN
            RAISE NOTICE 'El nombre no puede estar vacío... ¡Póngale nombre al cristiano!';
            RETURN FALSE;
        ELSIF wnom_vendedor ~ '[0-9]' THEN
            RAISE NOTICE '¿Un vendedor con números en el nombre? Sea serio calabazo...';
            RETURN FALSE;
        END IF;
        -- Validación Valor Ventas 
        IF wval_ventas IS NULL OR wval_ventas < 0 OR wval_ventas >= 9999999999 THEN
            RAISE NOTICE 'El valor de ventas no puede ser negativo...';
            RETURN FALSE;
        END IF;
        -- Validación Porcentaje Comisión 
        IF wval_porcomi IS NULL THEN
            RAISE NOTICE 'La comisión no puede ser nula...';
            RETURN FALSE;
        ELSIF wval_porcomi < 0 OR wval_porcomi > 99 THEN
            RAISE NOTICE 'La comisión (%) debe estar entre 0 y 99... ¡No sea tan regalado!', wval_porcomi;
            RETURN FALSE;
        END IF;
        -- validacion de si ya existe el id del vendedor
        IF fun_existe_reg_ven(wid_vendedor) THEN
            RAISE NOTICE 'El vendedor con ID (%) ya existe... No se puede duplicar.', wid_vendedor;
			RETURN FALSE;
        END IF;
        -- SI PASÓ TODAS LAS VALIDACIONES, INSERTA:
        INSERT INTO tab_vendedor VALUES(wid_vendedor,wnom_vendedor,wval_ventas,wval_porcomi);
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

CREATE OR REPLACE FUNCTION fun_existe_reg_ven(wwid_vendedor tab_vendedor.id_vendedor%TYPE) RETURNS BOOLEAN AS
$$
    DECLARE wwwid_vendedor tab_vendedor.id_vendedor%TYPE;
    BEGIN
        SELECT a.id_vendedor INTO wwwid_vendedor FROM tab_vendedor a
        WHERE a.id_vendedor = wwid_vendedor;
        IF FOUND THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END;
$$
LANGUAGE PLPGSQL;