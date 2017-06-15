----------------- RPH: Radio Positivo de Hidrantes -----------------------

-- Creacion de tablas
-- Longitud y latitud según google maps

create or replace table Hidrantes(
	codigo_hidrante int,
	calle varchar(10),
	avenida varchar(10),
	caudal float,
	cantidadSalidas int,
	tamañoSalida float,
	estado int, --Esto puede ser varchar "buen", "mal", "mantenimiento" ect
	latitud float,
	longitud float,
	constraint pkH primary key (codigo_hidrante)
);

--- Hidrante debe ser un tipo, posicion gps tipo, un contenedor de boquillas(4)

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

-- No sé si debe tener dimensiones de la boquilla
create or replace type boquilla as object(
	tipo int,
	constructor function boquilla(xtipo int) return self as result
);
/

create or replace type body boquilla 
is
	constructor function boquilla(xtipo int)
	return self as result
	is
	begin
		self.tipo := xtipo;
		return;
	end;
end; 
/

-- Para el contenedor de boquillas
create or replace type boquillas as VARRAY(4) of boquilla;

create or replace type hidrante as object(
	-- Posicion normal ?
	posicionGPS gps,
	misBoquillas boquillas,
	estado int, -- o puede ser varchar
	constructor function hidrante(xposicionGPS gps, xmisBoquillas boquillas, xestado int)
);
/


