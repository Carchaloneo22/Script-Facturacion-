CREATE OR REPLACE FUNCTION procesar_datos(nombres VARCHAR[])
RETURNS VOID AS $$
DECLARE
    nombre VARCHAR;
BEGIN
    -- Iterar sobre el arreglo
    FOREACH nombre IN ARRAY nombres
    LOOP
        RAISE NOTICE 'Nombre: %', nombre;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT procesar_datos(ARRAY['Carlos','Eduardo','Perez','Rueda','Laura','PAULITA','1']);