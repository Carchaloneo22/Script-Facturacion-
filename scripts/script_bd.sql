DROP TABLE tab_det_fac;
DROP TABLE tab_enc_fac;
DROP TABLE tab_clientes;
DROP TABLE tab_vendedor;
DROP TABLE tab_prod;
DROP TYPE DATOS_CLIENTE;
DROP TABLE tab_pmtros;
DROP TABLE tab_ciudades;

CREATE TABLE tab_ciudades
(
    id_ciudad       VARCHAR(5)      NOT NULL,
    nom_ciudad      VARCHAR         NOT NULL DEFAULT 'Sin Nombre Ciudad',
    PRIMARY KEY(id_ciudad)
);

CREATE TABLE tab_pmtros
(
    id_empresa      DECIMAL(3,0)    NOT NULL,
    id_ciudad       VARCHAR(5)      NOT NULL,
	val_inifac      BIGINT          NOT NULL DEFAULT 0,
    val_finfac      BIGINT          NOT NULL DEFAULT 0,
    val_facactual   BIGINT          NOT NULL,
    val_iva         DECIMAL(2,0)    NOT NULL DEFAULT 19,
    val_pordesc     DECIMAL(2,0)    NOT NULL DEFAULT 0,
    val_minpuntos   DECIMAL(8,0)    NOT NULL DEFAULT 1000,
    val_ptosxpeso   SMALLINT        NOT NULL DEFAULT 1000, --Por cada K, un punto
    PRIMARY KEY(id_empresa),
    FOREIGN KEY(id_ciudad)      REFERENCES tab_ciudades(id_ciudad)
);

CREATE TYPE DATOS_CLIENTE AS
(
    dir_cliente     VARCHAR,
    tel_cliente     DECIMAL(10,0)
);

CREATE TABLE tab_clientes
(
    id_cliente      DECIMAL(10,0)   NOT NULL,
    nom_cliente     VARCHAR         NOT NULL DEFAULT 'Sin Nombre',
    dat_cliente     DATOS_CLIENTE,
    id_ciudad       VARCHAR(5)      NOT NULL,
    fec_nacimi      DATE            NOT NULL,
    val_puntos      BIGINT          NOT NULL DEFAULT 0,
    val_compras     DECIMAL(10,0)   NOT NULL DEFAULT 0,
	fec_primcompra	DATE	        NOT NULL DEFAULT CURRENT_DATE,
	fec_vencptos	DATE			NOT NULL DEFAULT (CURRENT_DATE + INTERVAL '1 YEAR'),
    PRIMARY KEY(id_cliente),
    FOREIGN KEY(id_ciudad)          REFERENCES tab_ciudades(id_ciudad)
);

CREATE TABLE tab_vendedor
(
    id_vendedor     DECIMAL(10,0)   NOT NULL,
    nom_vendedor    VARCHAR         NOT NULL DEFAULT 'Sin Nombre vendedor',
    val_ventas      DECIMAL(10,0)   NOT NULL DEFAULT 0,
    val_porcomi     DECIMAL(2,0)    NOT NULL DEFAULT 0,
    PRIMARY KEY(id_vendedor)
);

CREATE TABLE tab_prod
(
    id_prod         VARCHAR         NOT NULL,
    nom_prod        VARCHAR         NOT NULL DEFAULT 'Sin Nombre Producto',
    val_precio      DECIMAL(8,0)    NOT NULL,
    ind_estado      BOOLEAN         NOT NULL DEFAULT TRUE, -- TRUE=Disponible / FALSE= No Disponible
    ind_iva         BOOLEAN         NOT NULL DEFAULT TRUE, -- Indicador de IVA
    ind_descuento   BOOLEAN         NOT NULL DEFAULT FALSE, -- TRUE Tiene descuento y se aplica el de PMTROS    
    PRIMARY KEY(id_prod)
);

CREATE TABLE tab_enc_fac
(
    id_factura      BIGINT          NOT NULL DEFAULT 0,
    id_ciudad       VARCHAR(5)      NOT NULL,
    id_cliente      DECIMAL(10,0)   NOT NULL,
    fec_factura     DATE            NOT NULL DEFAULT CURRENT_DATE,
    id_vendedor     DECIMAL(10,0)   NOT NULL,
    ind_estado      BOOLEAN         NOT NULL DEFAULT FALSE, -- TRUE=Cerrada
    val_total       DECIMAL(10,0)   NOT NULL DEFAULT 0,
    PRIMARY KEY(id_factura),
    FOREIGN KEY(id_ciudad)      REFERENCES tab_ciudades(id_ciudad),
    FOREIGN KEY(id_cliente)     REFERENCES tab_clientes(id_cliente),
    FOREIGN KEY(id_vendedor)    REFERENCES tab_vendedor(id_vendedor)
);

CREATE TABLE tab_det_fac
(
    id_factura      BIGINT          NOT NULL DEFAULT 0,
    id_prod         VARCHAR         NOT NULL,
    val_cant        SMALLINT        NOT NULL,
    val_bruto       DECIMAL(10,0)   NOT NULL,
    val_desc        DECIMAL(6,0)    NOT NULL,
    val_iva         DECIMAL(6,0)    NOT NULL,
    val_neto        DECIMAL(10,0)   NOT NULL DEFAULT 0,
    PRIMARY KEY(id_factura,id_prod),
    FOREIGN KEY(id_factura)     REFERENCES tab_enc_fac(id_factura),
    FOREIGN KEY(id_prod)        REFERENCES tab_prod(id_prod)
);