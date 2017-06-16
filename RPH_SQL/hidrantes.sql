----------------- RPH: Radio Positivo de Hidrantes -----------------------


create or replace type gps as object(
	latitud float,
	longitud float,
	constructor function gps(lat float, lon float) return self as result
);
/

create or replace type body gps 
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
/


create or replace type boquilla as object(
	tipo int,
	diametro float,
	constructor function boquilla(xtipo int, xdiametro float) return self as result
);
/

create or replace type body boquilla 
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
/

-- Para el contenedor de boquillas
create or replace type boquillas as VARRAY(4) of boquilla;
/

-- Hidrante
create or replace type hidrante as object(
	direccion varchar2(30), 
	posicionGPS gps,
	misBoquillas boquillas,
	estado int,
	constructor function hidrante(xdireccion varchar2, xposicionGPS gps, xmisBoquillas boquillas, xestado int) return self as result
);
/

create or replace type body hidrante 
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
/

create or replace type contenedorHidrantes is table of hidrante;
/


-- Creacion de tabla Hidrantes
--Poner caudal?
create table Hidrantes(
	codigo_hidrante int,
	direccion varchar2(30),
	posicionGPS gps,
	isBoquillas boquillas,
	estado int,
	constraint pkH primary key (codigo_hidrante)
);
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

create or replace procedure RPH(posicion gps, radio float)

is
	cursor totalHidrantes is select * from contenedorHidrantes;
	posi gps;
	
begin
	-- OPEN totalHidrantes;
	-- LOOP
		-- FETCH totalHidrantes INTO miHidrante;
		
		-- exit when totalHidrantes%notfound;
	-- END LOOP;
	-- close totalHidrantes;
	posi := posicion;
end;
/



