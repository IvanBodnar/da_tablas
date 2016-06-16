CREATE TABLE hechos (
	orden integer,
	id integer,
	fuente varchar(25),
	mes varchar(25),
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
	x double precision,
	y double precision
);

CREATE TABLE victimas (
	id_hecho integer,
	causa varchar(50),
	rol varchar(50),
	tipo varchar(150),
	marca varchar(50),
	modelo varchar(50),
	colectivo varchar(25),
	interno_colectivo varchar(25),
	sexo varchar(25),
	edad integer,
	sumario integer,
	repetido integer
);

CREATE TABLE acusados (
	id_hecho integer,
	rol varchar(50),
	tipo varchar(150),
	marca varchar(50),
	modelo varchar(50),
	colectivo varchar(25),
	interno_colectivo varchar(25),
	sexo varchar(25),
	edad integer,
	repetido integer
);

copy hechos from '/home/observatorio/Projects/da_arreglos/da_tablas/hechos_coordenadas.csv' header csv encoding 'latin3';

copy victimas from '/home/observatorio/Projects/da_arreglos/da_tablas/victimas.csv' header csv encoding 'latin3';

copy acusados from '/home/observatorio/Projects/da_arreglos/da_tablas/acusados.csv' header csv encoding 'latin3';

-- Borrar duplicados
delete from hechos where repetido = 1;
delete from victimas where repetido = 1;
delete from acusados where repetido = 1;

-- Agregar claves primarias
alter table hechos add constraint id_pk primary key (id);
alter table victimas add column id serial primary key;
alter table acusados add column id serial primary key;

-- Agregar claves foraneas
alter table victimas add foreign key (id_hecho) references hechos(id);
alter table acusados add foreign key (id_hecho) references hechos(id);

-- Drop columna repetido
alter table hechos drop column repetido;
alter table victimas drop column repetido;
alter table acusados drop column repetido;


select * from hechos;
select * from victimas;
select * from acusados;

-- Join en las tres tablas
select hechos.id, hechos.lugar_hecho, victimas.sexo, victimas.edad as edad_victima, acusados.edad as edad_acusado
from hechos
inner join victimas on hechos.id = id_victima
inner join acusados on hechos.id = id_acusado; 

-- Promedio de edad por mes sacando los 999 con subquery
select periodo, avg(edad) promedio_edad
from hechos
join victimas
on id = id_victima
where edad in (select edad from victimas where edad <> 999)
group by periodo;

-- Join especificando rango de edad de las victimas
select id, lugar_hecho, victimas.edad
from hechos
join victimas
on hechos.id = id_victima
where victimas.edad between 18 and 25
order by id;

-- Join especificando un caso concreto
select id, victimas.sexo sexo, victimas.edad edad
from hechos 
join victimas
on id = id_victima
where id = 8893;

select hechos.id, count(victimas.id_victima)
from hechos
join victimas
on hechos.id = victimas.id_victima
group by hechos.id;

select hechos.id, lugar_hecho, causa
from hechos
right outer join victimas
on hechos.id = victimas.id_hecho
where causa = 'HOMICIDIO'; 

select id_victima, causa
from victimas
where causa = 'HOMICIDIO';

drop table hechos;
drop table victimas;
drop table acusados;

alter database prueba_tablas rename to pfa_dgc;
