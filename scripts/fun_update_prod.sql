CREATE OR REPLACE FUNCTION fun_update_prod(wid_prod tab_prod.id_prod%TYPE,wnom_prod tab_prod.nom_prod%TYPE,
                                               wval_precio tab_prod.val_precio%TYPE, wind_estado tab_prod.ind_estado%TYPE,
                                               wind_iva tab_prod.ind_iva%TYPE, wind_descuento tab_prod.ind_descuento%TYPE) RETURNS BOOLEAN AS
$$
    BEGIN
        -- validacion de si ya existe el id del producto
        IF fun_existe_reg(wid_prod) THEN
            RAISE NOTICE 'El Registro del producto existe... Por fin hizo algo bueno...';
        ELSE
            RAISE NOTICE 'El Registro del producto  NO existe... Si es bruto.....';
			RETURN FALSE;
        END IF;
        -- Validación Nombre Producto 
        IF wnom_prod IS NULL OR TRIM(wnom_prod) = '' THEN
            RAISE NOTICE 'El nombre del producto no puede ser nulo... ¡Póngale algo, bestia!';
            RETURN FALSE;
        END IF;
        -- Validación de Precio 
        IF wval_precio IS NULL THEN
            RAISE NOTICE 'El precio no puede ser nulo...';
            RETURN FALSE;
        ELSIF wval_precio <= 0  OR wval_precio >= 99999999 THEN
            RAISE NOTICE 'El precio debe ser mayor a cero y menor a 8 digitos...  ¿Lo va a regalar o qué?';
            RETURN FALSE;
        END IF;
        -- Validación de Estado, IVA, Descuento
        IF wind_estado IS NULL OR wind_iva IS NULL OR wind_descuento IS NULL THEN
            RAISE NOTICE 'Los indicadores (Estado, IVA, Descuento) no pueden ser nulos...';
            RETURN FALSE;
        END IF;
        -- SI PASÓ TODAS LAS VALIDACIONES, Actualiza:
		UPDATE tab_prod
		SET nom_prod        = wnom_prod,
            val_precio      = wval_precio,
            ind_estado      = wind_estado,
            ind_iva         = wind_iva,
            ind_descuento   = wind_descuento
        WHERE id_prod = wid_prod;
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


