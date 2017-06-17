show user
prompt Por favor digite la informacion:
accept xlatitud prompt "Latitud: "
accept xlongitud prompt "Longitud: "
accept xradio prompt "Radio: "
set term off
execute RPH(&xlatitud, &xlongitud, &xradio);
commit;
set term ON
