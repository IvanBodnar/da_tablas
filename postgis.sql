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


update pfa_2015 set x = ST_X(geom), y = ST_Y(geom);

select * from pfa_2015 where ST_DWithin(ST_SetSRID(geom, 97124), ST_SetSRID(ST_Point(-58.4688709698659, -34.629732201265), 97124), 20.0);

select ST_Distance_Sphere(geom, ST_MakePoint(-58.4688709698659,-34.629732201265)) <= 0.00005 from pfa_2015;

select * from pfa_2015 where ST_PointInsideCircle(geom, -58.4688709698659, -34.629732201265, 0.001);

select * from pfa_2015 where ST_PointInsideCircle(ST_Transform(geom, 97124), ST_Transform(ST_MakePoint(-58.4688709698659,-34.629732201265), 97124), 200);

-- Este funciona con metros, con las coord en gk
select * from pfa_2015 where ST_DWithin(ST_Transform(geom, 97124), ST_GeomFromText('POINT(99434.1139023 99998.2519356)', 97124), 100);

-- Este tambien funciona, pero transformando las coord en wgs a gk
select * from pfa_2015 where ST_DWithin(ST_Transform(geom, 97124), ST_Transform(ST_GeomFromText('POINT(-58.4688709698659 -34.629732201265)', 4326), 97124), 150);

-- Lo mismo pero usando las dos coord en float en vez de wkt. Hay que envolver makepoint en setsrid, si no no sabe en que sistema esta
select * from pfa_2015 where ST_DWithin(ST_Transform(geom, 97124), ST_Transform(ST_SetSRID(ST_MakePoint(-58.4688709698659, -34.629732201265), 4326), 97124), 150);






