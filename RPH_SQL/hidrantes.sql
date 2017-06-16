----------------- RPH: Radio Positivo de Hidrantes -----------------------

create or replace type gps as object(
	latitud float,
	longitud float
	--constructor function gps(lat float, lon float) return self as result
);
/

/* create or replace type body gps 
is
	constructor function gps(lat float, lon float)
	return self as result
	is
	begin
		self.latitud := lat;
		self.longitud := lon;
		return;
	end;
end; 
/ */


create or replace type boquilla as object(
	tipo int,
	diametro float
	--constructor function boquilla(xtipo int, xdiametro float) return self as result
);
/

/* create or replace type body boquilla 
is
	constructor function boquilla(xtipo int, xdiametro float)
	return self as result
	is
	begin
		self.tipo := xtipo;
		self.diametro := xdiametro;
		return;
	end;
end; 
/ */

-- Para el contenedor de boquillas
create or replace type boquillas as VARRAY(4) of boquilla;
/

-- Hidrante
create or replace type hidrante as object(
	direccion varchar2(30), 
	posicionGPS gps,
	misBoquillas boquillas,
	estado int
	--constructor function hidrante(xdireccion varchar2, xposicionGPS gps, xmisBoquillas boquillas, xestado int) return self as result
);
/

/* create or replace type body hidrante 
is
 	constructor function hidrante(xdireccion varchar2, xposicionGPS gps, xmisBoquillas boquillas, xestado int)
	return self as result
	is
	begin
		self.direccion := xdireccion;
		self.posicionGPS := xposicionGPS;
		self.misBoquillas := xmisBoquillas;
		self.estado := xestado;
		return;
	end; 
end; 
/ */

create or replace type contenedorHidrantes is table of hidrante;
/

-- Creacion de tabla Hidrantes
--Poner caudal?
create table Hidrantes(
	codigo_hidrante int,
	direccion varchar2(30),
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
	estado int,
	constraint pkH primary key (codigo_hidrante)
);

insert into Hidrantes values(1, 'donde kim :V', 11.1, 22.2, 1, 1.1, 2, 2.2, 3, 3.3, 4, 4.4, 1);
insert into Hidrantes values(2, 'donde juanjo :V', 11.1, 22.2, 1, 1.1, 2, 2.2, 3, 3.3, 4, 4.4, 1);
insert into Hidrantes values(3, 'donde dani :V', 11.1, 22.2, 1, 1.1, 2, 2.2, 3, 3.3, 4, 4.4, 1);
------------------
-- Creacion de funciones

--Return radianes
create or replace function degreesToRadians(x float)
return float
is
	miPi float;

begin
	miPi := 3.141592;
	return x * (miPi / 180);
end;
/

-- Debe retornar el valor absoluto xd
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
	return 2 * 3961 * asin( sqrt( POWER(sin(deLat/2), 2) + cos(lat1) * cos(lat2) * POWER(sin(deLon/2), 2)) );
end;
/


create or replace procedure RPH
is
	cursor totalHidrantes is 
	select direccion, latitudGPS, longitudGPS, boquilla1Tipo, boquilla1diametro,
		boquilla2Tipo, boquilla2diametro, boquilla3Tipo, boquilla3diametro, boquilla4Tipo,
		boquilla4diametro, estado
	from Hidrantes; 
	
	misHidrantes contenedorHidrantes := contenedorHidrantes();
	nuevasBoquillas boquillas := boquillas();
	
	dir varchar2(30);
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
	est int;

	i int;
	
begin
	i := 1;
	open totalHidrantes;
	LOOP
		fetch totalHidrantes into dir, latGPS, lonGPS,
			boq1Tipo, boq1diametro,
			boq2Tipo, boq2diametro,
			boq3Tipo, boq3diametro,
			boq4Tipo, boq4diametro,
			est;
		exit when totalHidrantes%notfound;	
		
		nuevasBoquillas := boquillas();
		nuevasBoquillas.extend(4);
		nuevasBoquillas(1) := boquilla(boq1Tipo, boq1diametro);
		nuevasBoquillas(2) := boquilla(boq2Tipo, boq2diametro);
		nuevasBoquillas(3) := boquilla(boq3Tipo, boq3diametro);
		nuevasBoquillas(4) := boquilla(boq4Tipo, boq4diametro);
		
		misHidrantes.extend();
		misHidrantes(i) := hidrante(dir, gps(latGPS, lonGPS), nuevasBoquillas, est);
		dbms_output.put_line(misHidrantes(i).posicionGPS.latitud);
		i := i + 1;		
	END LOOP;
end;
/





