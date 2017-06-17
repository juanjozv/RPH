show user 
prompt Por favor haga su seleccion:
prompt 1: Calcular RPH
prompt 2: Salir
accept op prompt "Digite 1 o 2: "
set term off 
column script new_value v_script 
select case '&op'
	when '1' then 'C:/Users/Juanjo/Desktop/RPH/RPH_SQL/rph'
	when '2' then 'C:/Users/Juanjo/Desktop/RPH/RPH_SQL/exitmenu'
	else 'c:/menu/menu'
	end as script
from dual; 
set term on 
@&v_script.