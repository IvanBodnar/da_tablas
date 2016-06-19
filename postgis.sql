select * from recorridos;

SELECT ST_AsText (ST_Transform (geom, 4326)) FROM recorridos;

create table estacionamientos (
	wkt varchar(200),
	id integer,
	nombre varchar(100)
);

copy estacionamientos from '/home/ivan/Desktop/estac.csv' csv header delimiter ';' encoding 'latin1';

alter table estacionamientos add column wkt_gk varchar(200);

alter table estacionamientos drop column geom;

update estacionamientos set geom = ST_GeomFromText(WKT, 4326);

select * from estacionamientos;

update estacionamientos set geom_gk = ST_Transform (geom, 97124);

update estacionamientos set wkt_gk = ST_AsText(geom_gk);

select * from spatial_ref_sys;

select ST_AsText(geom_gk)
from estacionamientos;

create or replace view prueba2 as
select * from estacionamientos e
where ST_DWithin(e.geom_gk, (select geom from wifi where id = 202), 1000.0);

select Find_SRID('public', 'recorridos', 'geom');

select wkt::geometry
from estacionamientos
where id = 1;

create or replace view prueba as
select distinct on (r.gid) r.gid, e.nombre, r.geom
from recorridos r
join estacionamientos e 
on ST_DWithin(e.geom_gk, r.geom, 10.0)
order by r.gid;

select * from wifi
where id = 202;


