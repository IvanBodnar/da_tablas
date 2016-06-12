CREATE TABLE hechos (
	orden integer,
	id integer,
	fuente varchar(25),
	periodo varchar(25),
	comisaria varchar(5),
	fecha date,
	hora time,
	tipo_colision varchar(100),
	tipo_hecho varchar(25),
	lugar_hecho varchar(200),
	direccion_normalizada varchar(200),
	tipo_calle varchar(50),
	direccion_normalizada_arcgis varchar(200),
	calle1 varchar(100),
	altura integer,
	calle2 varchar(100),
	codigo_calle integer,
	codigo_cruce integer,
	geocodificacion varchar(300),
	franja_horaria integer,
	dia_semana varchar(25),
	semestre integer,
	repetido integer,
	franja_etaria_acusado integer,
	franja_etaria_victima integer
);

copy hechos from '/home/ivan/Projects/pruebas/da_tablas/hechos.csv' header csv encoding 'latin3';

select * from hechos;

drop table hechos;