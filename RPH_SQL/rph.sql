prompt ~~~ CALCULAR RADIO POSITIVO DE HIDRANTES ~~~
prompt Por favor digite la informacion:
accept xlatitud prompt "Latitud: "
accept xlongitud prompt "Longitud: "
accept xradio prompt "Radio: "
prompt HIDRANTES ENCONTRADOS:
execute RPH(gps(&xlatitud, &xlongitud), &xradio);
commit;
set term off
set term ON
