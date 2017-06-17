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
	estado int,
	member function toString return varchar2
	--constructor function hidrante(xdireccion varchar2, xposicionGPS gps, xmisBoquillas boquillas, xestado int) return self as result
);
/

create or replace type body hidrante 
is
 	/*constructor function hidrante(xdireccion varchar2, xposicionGPS gps, xmisBoquillas boquillas, xestado int)
	return self as result
	is
	begin
		self.direccion := xdireccion;
		self.posicionGPS := xposicionGPS;
		self.misBoquillas := xmisBoquillas;
		self.estado := xestado;
		return;
	end;*/
	member function toString return varchar2
	is
		s varchar2(1000);
	begin		
		s := '[ Ubicacion Hidrante: ' || direccion || ' Boquilla 1: ' || misBoquillas(1).diametro 
			||  ' Boquilla 2:' || misBoquillas(2).diametro ||  ' Boquilla 3:' || misBoquillas(3).diametro
			||  'Boquilla 4:' || misBoquillas(4).diametro || ' Estado: ' || estado || ' ]';
		return s;
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

insert into Hidrantes values(1, 'donde kim :V', 99.987692, -84.097697, 1, 1.1, 2, 2.2, 3, 3.3, 4, 4.4, 1);
insert into Hidrantes values(2, 'donde juanjo :V', 9.988626, -84.095980, 1, 1.1, 2, 2.2, 3, 3.3, 4, 4.4, 1);
insert into Hidrantes values(3, 'donde dani :V', 9.987676, -84.098681, 1, 1.1, 2, 2.2, 3, 3.3, 4, 4.4, 1);
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
	distancia := 2 * 6371 * asin( sqrt( POWER(sin(deLat/2), 2) + cos(lat1) * cos(lat2) * POWER(sin(deLon/2), 2)) );
	distancia := ABS(distancia);
	return distancia * 1000;
end;
/


create or replace procedure RPH
--create or replace procedure RPH(miPosicion gps, radio float)
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
	
	hidrantesUtiles contenedorHidrantes := contenedorHidrantes();
	
	recorrido float;
	
	radio float;
	
begin
	radio := 200;
	i := 1;
	-- Para cargar array con TODOS LOS hidrantes
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
		i := i + 1;		
	END LOOP;
	
	--Metodos para meter en el array los más cercanos
	for contador in misHidrantes.FIRST .. misHidrantes.LAST
	loop 
		--recorrido := calcularDistancia(miPosicion, misHidrantes(contador).posicionGPS);
		recorrido := calcularDistancia(gps(9.988549, -84.096393), misHidrantes(contador).posicionGPS);
		if recorrido <= radio then
			hidrantesUtiles.extend();
			hidrantesUtiles(hidrantesUtiles.last) := misHidrantes(contador);
		end if;
		
	end loop;
	
	if hidrantesUtiles.count > 0
	then
		for contador2 in hidrantesUtiles.FIRST .. hidrantesUtiles.LAST
		loop 
			dbms_output.put_line(hidrantesUtiles(contador2).toString());
		end loop;
	else
		dbms_output.put_line('No hay, no existe');
	end if;
	
end;
/





