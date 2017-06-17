show user
prompt Por favor digite la informacion:
accept xlatitud prompt "Latitud: "
accept xlongitud prompt "Longitud: "
accept xradio prompt "Radio: "
execute RPH(gps(&xlatitud, &xlongitud), &xradio);
commit;
set term off
set term ON
