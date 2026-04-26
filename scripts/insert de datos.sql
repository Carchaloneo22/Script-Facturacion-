--INSERT DE CIUDADES
SELECT fun_insert_ciudad('68001', 'Bucaramanga');
SELECT fun_insert_ciudad('68276', 'Floridablanca');
SELECT fun_insert_ciudad('68307', 'Giron');
SELECT fun_insert_ciudad('68547', 'Piedecuesta');
SELECT fun_insert_ciudad('05001', 'Medellin');
--INSERT DE VENDEDORES
SELECT fun_insert_vendedor(101, 'Silvia Juliana Lucuara', 5000000, 10);
SELECT fun_insert_vendedor(102, 'Pedro Perez', 2500000, 5);
SELECT fun_insert_vendedor(103, 'Maria Rodriguez', 8000000, 12);
SELECT fun_insert_vendedor(104, 'Carlos Ruiz', 0, 8);
SELECT fun_insert_vendedor(105, 'Ana Suarez', 4200000, 7);
--INSERT DE PRODUCTOS
SELECT fun_insert_prod('P01', 'Detergente Liquido', 15000, TRUE, TRUE, FALSE);
SELECT fun_insert_prod('P02', 'Esponja de Brillo', 2500, TRUE, TRUE, FALSE);
SELECT fun_insert_prod('P03', 'Jabón de Loza', 4500, TRUE, TRUE, TRUE);
SELECT fun_insert_prod('P04', 'Limpiavidrios', 8900, TRUE, TRUE, FALSE);
SELECT fun_insert_prod('P05', 'Desinfectante Pino', 6700, TRUE, TRUE, FALSE);
SELECT fun_insert_prod('P06', 'Escoba Multiuso', 12000, TRUE, TRUE, FALSE);
SELECT fun_insert_prod('P07', 'Trapero Microfibra', 18500, TRUE, TRUE, TRUE);
SELECT fun_insert_prod('P08', 'Bolsas de Basura x10', 5000, TRUE, TRUE, FALSE);
SELECT fun_insert_prod('P09', 'Ambientador Spray', 9200, TRUE, TRUE, FALSE);
SELECT fun_insert_prod('P10', 'Suavizante Telas', 14000, TRUE, TRUE, TRUE);
SELECT fun_insert_prod('P11', 'Arroz Premium 1kg', 4200, TRUE, FALSE, FALSE);
SELECT fun_insert_prod('P12', 'Aceite Vegetal 900ml', 11500, TRUE, FALSE, TRUE);
SELECT fun_insert_prod('P13', 'Pasta Spaghetti', 3200, TRUE, FALSE, FALSE);
SELECT fun_insert_prod('P14', 'Café Molido 500g', 16000, TRUE, FALSE, FALSE);
SELECT fun_insert_prod('P15', 'Azúcar Blanca', 3800, TRUE, FALSE, FALSE);
SELECT fun_insert_prod('P16', 'Sal Marina', 2100, TRUE, FALSE, FALSE);
SELECT fun_insert_prod('P17', 'Leche Entera 1L', 4500, TRUE, FALSE, FALSE);
SELECT fun_insert_prod('P18', 'Atún en Aceite', 6800, TRUE, TRUE, TRUE);
SELECT fun_insert_prod('P19', 'Lentejas 500g', 3500, TRUE, FALSE, FALSE);
SELECT fun_insert_prod('P20', 'Harina de Maíz', 4100, TRUE, FALSE, FALSE);
SELECT fun_insert_prod('P21', 'Shampoo Anticaspa', 22000, TRUE, TRUE, TRUE);
SELECT fun_insert_prod('P22', 'Crema Dental', 7500, TRUE, TRUE, FALSE);
SELECT fun_insert_prod('P23', 'Jabón de Tocador', 3200, TRUE, TRUE, FALSE);
SELECT fun_insert_prod('P24', 'Desodorante Roll-on', 12500, TRUE, TRUE, FALSE);
SELECT fun_insert_prod('P25', 'Papel Higiénico x4', 8000, TRUE, TRUE, TRUE);
SELECT fun_insert_prod('P26', 'Cepillo Dental Medium', 5500, TRUE, TRUE, FALSE);
SELECT fun_insert_prod('P27', 'Acondicionador', 21000, TRUE, TRUE, FALSE);
SELECT fun_insert_prod('P28', 'Crema para Manos', 13200, TRUE, TRUE, TRUE);
SELECT fun_insert_prod('P29', 'Gel para Cabello', 6400, TRUE, TRUE, FALSE);
SELECT fun_insert_prod('P30', 'Cuchilla de Afeitar', 4800, TRUE, TRUE, FALSE);


--INSERT DE CLIENTES 
SELECT fun_insert_clientes('1001','Carlos Perez','68001','Calle 20 32-41','3503421731','2001-01-14','0','0',CURRENT_DATE,'2027-03-27');
SELECT fun_insert_clientes('1002','Julio Jaramillo','68276','Calle 02 22-81','3503421732','2002-02-22','0','0',CURRENT_DATE,'2027-03-27');
SELECT fun_insert_clientes('1003','Jesus Romero','68001','Calle 32 67-55','3503421733','2003-03-13','0','0',CURRENT_DATE,'2027-03-27');
SELECT fun_insert_clientes('1004','Sebastian Padilla','68276','Calle 10 43-11','3503421734','2004-04-16','0','0',CURRENT_DATE,'2027-03-27');
SELECT fun_insert_clientes('1005','Nancy Ramos','68001','Calle 15 86-09','3503421735','2005-05-24','0','0',CURRENT_DATE,'2027-03-27');
SELECT fun_insert_clientes('1006','Nelly Padilla','68547','Calle 17 32-53','3503421736','2006-06-26','0','0',CURRENT_DATE,'2027-03-27');
SELECT fun_insert_clientes('1007','Paula Jaimes','05001','Calle 16 16-65','3503421737','2007-07-28','0','0',CURRENT_DATE,'2027-03-27');
SELECT fun_insert_clientes('1008','Martin Rodriguez','05001','Calle 22 33-45','3503421738','2008-06-14','0','0',CURRENT_DATE,'2027-03-27');
SELECT fun_insert_clientes('1009','Paola Vargas','68547','Calle 11 13-70','3503421739','2009-09-04','0','0',CURRENT_DATE,'2027-03-27');
SELECT fun_insert_clientes('2000','Manuel Caicedo','68276','Calle 9 55-93','3503421740','2010-10-18','0','0',CURRENT_DATE,'2027-03-27');

--Actualizaciones de los datos
-- vendedor
SELECT * FROM tab_vendedor;
SELECT fun_update_vendedor(101, 'Silvia Juliana Lucuara Ardila', 5000000, 10);

--Producto
SELECT * FROM tab_prod;
SELECT fun_update_prod('P01', 'Detergente Liquido', 15000, TRUE, TRUE, TRUE);


--Ciudad
SELECT fun_update_ciudad('68001', 'Bucamanga');




