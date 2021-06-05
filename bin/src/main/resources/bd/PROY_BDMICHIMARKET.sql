-- Validando existencia de BD
drop database if exists PROY_DAWI_MICHIMARKET;

-- Creando BD
create database PROY_DAWI_MICHIMARKET;

-- Activando BD
use PROY_DAWI_MICHIMARKET;

-- Creando tablas
create table tb_tipos(
id_tipo		int				not null	primary key,
des_tipo	varchar(20)		not null
);

create table tb_categorias(
id_cat		int				not null	primary key,
des_cat		varchar(50)		not null
);

create table tb_distritos(
cod_dis		int				not null	primary key,
nom_dis		varchar(50)		not null
);

create table tb_usuarios(
cod_usu		char(5)			not null,
nom_usu		varchar(20)		not null,
ape_usu		varchar(20)		not null,
cod_dis		int				not null,	
user_usu	char(50)		not null unique,
cla_usu		char(5)			not null,
fnac_usu	date			not null,
id_tipo		int				not null,
est_usu		int(1) 			default 1,
primary key (cod_usu),
foreign key (cod_dis) references tb_distritos(cod_dis),
foreign key (id_tipo) references tb_tipos(id_tipo)
);

create table tb_productos(
id_prod		char(5)			not null	primary key,
des_prod	varchar(50)		not null,
preu_prod	decimal(8,2)	not null,
sto_prod	int				not null CHECK (sto_prod >= 0),
id_cat		int				not null,
est_prod	int				not null	default 1,
foreign key (id_cat) references tb_categorias(id_cat)
);

create table tb_boleta(
num_bol		char(5)			not null,
fec_bol		date			not null,
cod_usu		char(5)			not null,
tot_bol		decimal(8,2),
primary key (num_bol),
foreign key (cod_usu) references tb_usuarios(cod_usu)
);

create table tb_detalleboleta(
num_bol		char(5)			not null,
id_prod		char(5)			not null,
can_bol		int				not null CHECK (sto_prod > 0),
prepro_bol	decimal(8,2)	not null,
imp_bol		decimal(8,2)	not null,
foreign key (num_bol) references tb_boleta(num_bol),
foreign key (id_prod) references tb_productos(id_prod),
primary key (num_bol, id_prod)
);

-- @@ REGISTROS DE TABLAS @@

-- REGISTRO TIPOS
insert into tb_tipos values(1, 'Administrador');
insert into tb_tipos values(2, 'Moderador');
insert into tb_tipos values(3, 'Cliente');

-- REGISTRO DISTRITOS
insert into tb_distritos values (1, 'Chorrilos');
insert into tb_distritos values (2, 'Miraflores');
insert into tb_distritos values (3, 'San Isidro');
insert into tb_distritos values (4, 'Los Olivos');

-- REGISTRO USUARIOS
insert into tb_usuarios values ('U0001', 'Carmen', 'Rosales', 1, 'admin@minimarket.com', 'admin', '1994-07-16', 1, 1);
insert into tb_usuarios values ('U0002', 'André', 'Aguilar', 1, 'andr@minimarket.com', 'andre', '1996-05-12', 2, 1);
insert into tb_usuarios values ('U0003', 'Luis', 'Gonzales', 2, 'luis@minimarket.com', 'luiss', '1998-07-22', 3, 1);
insert into tb_usuarios values ('U0004', 'Maria', 'Rojas', 2, 'mari@minimarket.com', 'maria', '1999-05-02', 3, 1);


-- REGISTROS CATEGORIAS
insert into tb_categorias values (1, 'Bebidas');
insert into tb_categorias values (2, 'Lácteos');
insert into tb_categorias values (3, 'Granos y cereales');
insert into tb_categorias values (4, 'Frutas y verduras');
insert into tb_categorias values (5, 'Carnes');

-- REGISTROS PRODUCTOS
insert into tb_productos values ('P0001', 'Leche', 2.50, 20, 2, 1);
insert into tb_productos values ('P0002', 'Sandía', 5.50, 10, 4, 1);
insert into tb_productos values ('P0003', 'Refresco de naranja', 1.50, 15, 1, 1);
insert into tb_productos values ('P0004', 'Bistec de tapa', 4.00, 12, 5, 1);
insert into tb_productos values ('P0005', 'Queso fresco', 1.20, 30, 2, 1);

-- REGISTROS CABECERA VENTAS
insert into tb_boleta values ('V0001', '2020-03-21', 'U0003', '45.50');
insert into tb_boleta values ('V0002', '2020-03-25', 'U0003', '50.00');

-- REGISTROS DETALLE VENTAS
insert into tb_detalleboleta values ('V0001', 'P0002', 2, 5.50, 11.00);
insert into tb_detalleboleta values ('V0001', 'P0001', 4, 2.50, 6.00);
insert into tb_detalleboleta values ('V0001', 'P0003', 1, 1.50, 1.50);
insert into tb_detalleboleta values ('V0001', 'P0004', 2, 4.00, 8.00);
insert into tb_detalleboleta values ('V0002', 'P0002', 3, 5.50, 11.50);
insert into tb_detalleboleta values ('V0002', 'P0003', 1, 1.50, 1.50);
insert into tb_detalleboleta values ('V0002', 'P0004', 4, 4.00, 16.00);

-- @@ PROCEDIMIENTOS @@

-- PROCEDIMIENTOS USUARIOS
DELIMITER $$
create procedure usp_listadoUsuarios()
begin
	select u.cod_usu, u.nom_usu, u.ape_usu, d.nom_dis, u.user_usu, u.cla_usu, u.fnac_usu, t.des_tipo, u.est_usu
    from tb_usuarios as u
    inner join tb_distritos as d on (u.cod_dis = d.cod_dis)
    inner join tb_tipos as t on (u.id_tipo = t.id_tipo)
    where u.est_usu < 3
    order by u.cod_usu asc;
end $$
DELIMITER ;

call usp_listadoUsuarios();

DELIMITER $$
CREATE PROCEDURE usp_validaUsuario (usr char (50), pas char(5))
BEGIN
	select * from tb_usuarios where user_usu = usr and cla_usu = pas;
END $$
DELIMITER ;

call usp_validaUsuario('admin@minimarket.com', 'carme');

-- PROCEDIMIENTOS PRODUCTOS
DELIMITER $$
create procedure usp_listadoProductos()
begin
	select p.id_prod, p.des_prod, p.preu_prod, p.sto_prod, c.des_cat
    from tb_productos as p
    inner join tb_Categorias as c on (p.id_cat = c.id_cat)
    where p.est_prod = 1
    order by p.id_prod asc;
end $$
DELIMITER ;

call usp_listadoProductos;

select * from tb_productos;

select * from tb_usuarios;

select * from tb_tipos;

select curdate() from dual;

select * from tb_boleta;
select * from tb_detalleboleta;

select substring(max(num_bol), 2) from tb_boleta;