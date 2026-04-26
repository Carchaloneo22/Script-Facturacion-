CREATE OR REPLACE FUNCTION fun_insert_prod(wid_prod tab_prod.id_prod%TYPE,wnom_prod tab_prod.nom_prod%TYPE,
                                            wval_precio tab_prod.val_precio%TYPE, wind_estado tab_prod.ind_estado%TYPE,
                                            wind_iva tab_prod.ind_iva%TYPE, wind_descuento tab_prod.ind_descuento%TYPE) RETURNS BOOLEAN AS
$$
    BEGIN
    -- validaciones 
        -- Validación ID Producto 
        IF wid_prod IS NULL OR wid_prod = '' THEN
            RAISE NOTICE 'El ID del producto no puede ser nulo ni vacío... Sea serio calabazo';
            RETURN FALSE;
        END IF;
        -- Validación Nombre Producto (No nulo y que no sea solo espacios)
        IF wnom_prod IS NULL OR TRIM(wnom_prod) = '' THEN
            RAISE NOTICE 'El nombre del producto no puede ser nulo... ¡Póngale algo, bestia!';
            RETURN FALSE;
        END IF;
        -- Validación de Precio 
        IF wval_precio IS NULL THEN
            RAISE NOTICE 'El precio no puede ser nulo...';
            RETURN FALSE;
        ELSIF wval_precio <= 0  OR wval_precio >= 99999999 THEN
            RAISE NOTICE 'El precio debe ser mayor a cero... ¿Lo va a regalar o qué?';
            RETURN FALSE;
        END IF;
        -- Validación de Booleanos 
        IF wind_estado IS NULL OR wind_iva IS NULL OR wind_descuento IS NULL THEN
            RAISE NOTICE 'Los indicadores (Estado, IVA, Descuento) no pueden ser nulos...';
            RETURN FALSE;
        END IF;
        -- validacion de si ya existe el id del producto
        IF fun_existe_reg(wid_prod) THEN
            RAISE NOTICE 'El producto con ID (%) ya existe... No se puede duplicar.', wid_prod;
			RETURN FALSE;
        END IF;
        -- SI PASÓ TODAS LAS VALIDACIONES, INSERTA:
        INSERT INTO tab_prod VALUES(wid_prod,wnom_prod,wval_precio,wind_estado,wind_iva,wind_descuento);
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

CREATE OR REPLACE FUNCTION fun_existe_reg(wwid_prod tab_prod.id_prod%TYPE) RETURNS BOOLEAN AS
$$
    DECLARE wwwid_prod tab_prod.id_prod%TYPE;
    BEGIN
        SELECT a.id_prod INTO wwwid_prod FROM tab_prod a
        WHERE a.id_prod = wwid_prod;
        IF FOUND THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END;
$$
LANGUAGE PLPGSQL;
