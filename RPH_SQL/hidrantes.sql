----------------- RPH: Radio Positivo de Hidrantes -----------------------

create or replace type gps as object(
	latitud float,
	longitud float
);
/

create or replace type boquilla as object(
	tipo int,
	diametro float
);
/

-- Para el contenedor de boquillas
create or replace type boquillas as VARRAY(4) of boquilla;
/

-- Hidrante
create or replace type hidrante as object(
	direccion varchar2(100), 
	posicionGPS gps,
	misBoquillas boquillas,
	estado varchar2(30),
	caudal float,
	member function toString return varchar2
);
/

create or replace type body hidrante 
is
	member function toString return varchar2
	is
		s varchar2(5000);
	begin		
		s := CHR(13) || CHR(10)
			||'Ubicacion Hidrante: ' || direccion 
			|| CHR(13) || CHR(10)
			|| 'Boquilla 1: ' || misBoquillas(1).diametro 
			|| CHR(13) || CHR(10)
			|| 'Boquilla 2: ' || misBoquillas(2).diametro
			|| CHR(13) || CHR(10) 
			|| 'Boquilla 3: ' || misBoquillas(3).diametro 
			|| CHR(13) || CHR(10) 
			|| 'Boquilla 4: ' || misBoquillas(4).diametro 
			|| CHR(13) || CHR(10) 
			|| 'Estado: ' || estado 
			|| CHR(13) || CHR(10) 
			|| 'Caudal: ' || caudal
			|| CHR(13) || CHR(10)
			|| 'Coordenadas: ' || posicionGPS.latitud || ', ' || posicionGPS.longitud;
		return s;
	end;
end; 
/ 

create or replace type contenedorHidrantes is table of hidrante;
/

-- Creacion de tabla Hidrantes

create table Hidrantes(
	codigo_hidrante int,
	direccion varchar2(100),
	latitudGPS float,
	longitudGPS float,
	boquilla1Tipo int,
	boquilla1diametro float,
	boquilla2Tipo int,
	boquilla2diametro float,
	boquilla3Tipo int,
	boquilla3diametro float,
	boquilla4Tipo int,
	boquilla4diametro float,
	estado varchar2(30),
	caudal float,
	constraint pkH primary key (codigo_hidrante)
);

-----------------------------------------------------------------------------------------------------------------
-- Inserts tabla Hidrantes


insert into Hidrantes values (1,'Calle 8, Avenida 9', 10.019569, -84.217449, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 1500);

insert into Hidrantes values (2,'Calle 12, Avenida 7',10.018174, -84.219377, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Fuera de uso', 2000);

insert into Hidrantes values (3,'Calle Central, Avenida 9',10.020346, -84.214620, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 2500);

insert into Hidrantes values (4,'Calle 3, Avenida 9',10.020810, -84.212923, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 3000);

insert into Hidrantes values (5,'Calle 9, Avenida 9',10.021534, -84.210366, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Fuera de uso', 3500);

insert into Hidrantes values (6,'Calle 11, Avenida 3',10.019249, -84.208871, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 4000);

insert into Hidrantes values (7,'Calle 11, Avenida 1',10.018356, -84.208645, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 4500);

insert into Hidrantes values (8,'Calle 7, Avenida 3',10.018733, -84.210555 , 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 5500);

insert into Hidrantes values (9,'Calle 3, Avenida 5',10.019176, -84.212380,1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Fuera de uso', 1500);

insert into Hidrantes values (10,'Calle Central, Avenida 5',10.018606, -84.214129, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 1500);

insert into Hidrantes values (11,'Calle 4, Avenida 3', 10.017416, -84.215514, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 2000);
                        
insert into Hidrantes values (12,'Calle 9, Avenida 1',10.017280, -84.212851,1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 1000);

insert into Hidrantes values (13,'Calle 2, Avenida Central',10.016009, -84.214181, 1, 10.1, 2,12.2, 3, 14.3, 4, 15.4, 'Utilizable', 1900);

insert into Hidrantes values (14,'Calle 6, Avenida Central',10.015571, -84.215910, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 7000); 

insert into Hidrantes values (15,'Calle 12, Avenida Central',10.014856, -84.218443, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Fuera de uso', 3000);

insert into Hidrantes values (16,'Calle 3, Avenida 2 - Avenida central',10.016168, -84.211602, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Fuera de uso', 3500);

insert into Hidrantes values (17,'Calle 6, Avenida 4',10.013836, -84.215438, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 2500);

insert into Hidrantes values (18,'Calle 4, Avenida 4',10.014090, -84.214661,1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 2500);

insert into Hidrantes values (19,'Calle 6, Avenida 6',10.013058, -84.215230, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 1500);

insert into Hidrantes values (20,'Calle 1, Avenida 6',10.013885, -84.211890, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Fuera de uso', 1000);

insert into Hidrantes values (21,'Calle 3, Avenida 6 - Avenida 10',10.013226, -84.210450, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Fuera de uso', 1000); 

insert into Hidrantes values (22,'Calle 2, Avenida 10',10.011827, -84.213111, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 1500);

insert into Hidrantes values (23,'Calle 8, Avenida 10',10.011193, -84.215577, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 2500);

insert into Hidrantes values (24,'Calle 12, Avenida 6A',10.011699, -84.217999, 1, 10.1, 2, 12.2, 3, 14.3, 4, 15.4, 'Utilizable', 2000);

------------------------------------------------------------------------------------------------------------------
-- Creacion de funciones

-- Return radianes
create or replace function degreesToRadians(x float)
return float
is
	miPi float;

begin
	miPi := 3.141592;
	return x * (miPi / 180);
end;
/

-- Retorna metros
create or replace function calcularDistancia(posicion1 gps, posicion2 gps)
return float
is
	deLat float;
	deLon float;
	lat1 float;
	lat2 float;
	distancia float;
begin
	deLat := degreesToRadians(posicion2.latitud - posicion1.latitud);
	deLon := degreesToRadians(posicion2.longitud - posicion1.longitud);
	lat1 := degreesToRadians(posicion1.latitud);
	lat2 := degreesToRadians(posicion2.latitud);
	distancia := 2 * 6371 * asin( sqrt( POWER(sin(deLat/2), 2) + cos(lat1) * cos(lat2) * POWER(sin(deLon/2), 2)) );
	distancia := ABS(distancia);
	return distancia * 1000;
end;
/


create or replace procedure RPH(miPosicion gps, radio float)
is
 cursor totalHidrantes is 
 select direccion, latitudGPS, longitudGPS, boquilla1Tipo, boquilla1diametro,
  boquilla2Tipo, boquilla2diametro, boquilla3Tipo, boquilla3diametro, boquilla4Tipo,
  boquilla4diametro, estado, caudal
 from Hidrantes; 
 
 misHidrantes contenedorHidrantes := contenedorHidrantes();
 nuevasBoquillas boquillas := boquillas();
 
 dir varchar2(100);
 latGPS float;
 lonGPS float;
 boq1Tipo int;
 boq1diametro float;
 boq2Tipo int;
 boq2diametro float;
 boq3Tipo int;
 boq3diametro float;
 boq4Tipo int;
 boq4diametro float;
 est varchar2(30);
 caudalEsperado float;
 utiles integer;
 i int;
 recorrido float(10);
 
 
begin
 i := 1;
 -- Para cargar array con TODOS LOS hidrantes
 open totalHidrantes;
 LOOP
  fetch totalHidrantes into dir, latGPS, lonGPS,
   boq1Tipo, boq1diametro,
   boq2Tipo, boq2diametro,
   boq3Tipo, boq3diametro,
   boq4Tipo, boq4diametro,
   est, caudalEsperado;
  exit when totalHidrantes%notfound; 
  
  nuevasBoquillas := boquillas();
  nuevasBoquillas.extend(4);
  nuevasBoquillas(1) := boquilla(boq1Tipo, boq1diametro);
  nuevasBoquillas(2) := boquilla(boq2Tipo, boq2diametro);
  nuevasBoquillas(3) := boquilla(boq3Tipo, boq3diametro);
  nuevasBoquillas(4) := boquilla(boq4Tipo, boq4diametro);
  
  misHidrantes.extend();
  misHidrantes(i) := hidrante(dir, gps(latGPS, lonGPS), nuevasBoquillas, est, caudalEsperado);
  i := i + 1;  
 END LOOP;
 
 --Metodos para meter en el array los más cercanos
 utiles := 0;
 for contador in misHidrantes.FIRST .. misHidrantes.LAST
 loop
  recorrido := calcularDistancia(miPosicion, misHidrantes(contador).posicionGPS);
  if recorrido <= radio then
	dbms_output.put_line(misHidrantes(contador).toString() || CHR(13) || CHR(10) || 'Distancia: ' || recorrido || ' metros');
	utiles := utiles + 1;
  end if;
 end loop; 
 if utiles = 0 then
  dbms_output.put_line('No se encuentran hidrantes disponibles!');
 end if;
end;
/


drop table hidrantes;
drop type contenedorHidrantes;
drop type hidrante;
drop type boquillas;
drop type boquilla;
drop type gps;
drop function calcularDistancia;
drop function degreesToRadians;
drop procedure RPH;

execute rph(10.015990, -84.214207, 200);






