CREATE OR REPLACE FUNCTION fun_update_vendedor(wid_vendedor tab_vendedor.id_vendedor%TYPE,wnom_vendedor tab_vendedor.nom_vendedor%TYPE,
                                               wval_ventas tab_vendedor.val_ventas%TYPE, wval_porcomi tab_vendedor.val_porcomi%TYPE) RETURNS BOOLEAN AS
$$
    BEGIN
        -- validacion de si ya existe el id del vendedor
        IF fun_existe_reg_ven(wid_vendedor) THEN
            RAISE NOTICE 'El Registro del vendedor existe... Por fin hizo algo bueno...';
        ELSE
            RAISE NOTICE 'El Registro del vendedor NO existe... Si es bruto.....';
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
        IF wval_ventas IS NULL OR wval_ventas < 0 THEN
            RAISE NOTICE 'El valor de ventas no puede ser ni Nulo, ni negativo ...';
            RETURN FALSE;
        END IF;
		IF  wval_ventas >= 9999999999 THEN
            RAISE NOTICE 'El valor de ventas no puede ser mayor a 10 digitos ...';
            RETURN FALSE;
        END IF;
        -- Validación Porcentaje Comisión (Entre 0 y 99)
        IF wval_porcomi IS NULL THEN
            RAISE NOTICE 'La comisión no puede ser nula...';
            RETURN FALSE;
        ELSIF wval_porcomi < 0 OR wval_porcomi > 99 THEN
            RAISE NOTICE 'La comisión (%) debe estar entre 0 y 99... ¡No sea tan regalado!', wval_porcomi;
            RETURN FALSE;
        END IF;
        -- SI PASÓ TODAS LAS VALIDACIONES, Actualiza:
		UPDATE tab_vendedor
		SET nom_vendedor  = wnom_vendedor,
            val_ventas    =wval_ventas,
            val_porcomi   =wval_porcomi
        WHERE id_vendedor = wid_vendedor;
		IF FOUND THEN
                RAISE NOTICE 'La Actualización fue exitosa';
            RETURN TRUE;
        ELSE
            RAISE NOTICE 'La Actualización NO fue exitosa';
            RETURN FALSE;
        END IF;
    END;
$$
LANGUAGE PLPGSQL;

