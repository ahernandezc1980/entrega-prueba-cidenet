set serveroutput on;
declare
  p_empleado_id number;
  o_cdgo_rspsta number;
  o_mnsje_rspsta varchar2(200);
begin
  p_empleado_id := null;

  pkg_gestion_empleados.prc_el_empleados( p_empleado_id => p_empleado_id,
                                          o_cdgo_rspsta => o_cdgo_rspsta,
                                          o_mnsje_rspsta => o_mnsje_rspsta);
 
dbms_output.put_line('o_cdgo_rspsta = ' || o_cdgo_rspsta);

dbms_output.put_line('o_mnsje_rspsta = ' || o_mnsje_rspsta);


end;
