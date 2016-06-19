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


INSERT into spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext) values ( 97124, 'sr-org', 7124, '+proj=tmerc +lat_0=-34.6297166 +lon_0=-58.4627 +k=0.9999980000000001 +x_0=100000 +y_0=100000 +ellps=intl +units=m +no_defs ', 'PROJCS["GKBA",GEOGCS["International 1909 (Hayford)",DATUM["CAI",SPHEROID["intl",6378388,297]],PRIMEM["Greenwich",0],UNIT["degree",0.0174532925199433]],PROJECTION["Transverse_Mercator"],PARAMETER["latitude_of_origin",-34.6297166],PARAMETER["central_meridian",-58.4627],PARAMETER["scale_factor",0.999998],PARAMETER["false_easting",100000],PARAMETER["false_northing",100000],UNIT["Meter",1]]');


select * from pfa_2015;

select ST_GeomFromText(wkt_gk, 97124) from pfa_2015 as cosa;

update pfa_2015 set geom = ST_Transform(ST_GeomFromText(wkt_gk, 97124), 4326);

-- Borrar los 0 porque si no tira error ST_GeomFromText
delete from pfa_2015 where wkt_gk = '0';

update pfa_2015 set wkt_wgs = ST_AsText(geom);


