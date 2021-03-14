set serveroutput on;
declare
  p_empleado_id number;
  p_tipo_identificacion_id number;
  p_area_id number;
  p_primer_nombre varchar2(20);
  p_otros_nombres varchar2(50);
  p_primer_apellido varchar2(50);
  p_segundo_apellido varchar2(50);
  p_pais_id number;
  p_numero_identificacion varchar2(20);
  p_fecha_ingreso timestamp;
  o_cdgo_rspsta number;
  o_mnsje_rspsta varchar2(200);
begin
  p_empleado_id := null;
  p_tipo_identificacion_id := null;
  p_area_id := null;
  p_primer_nombre := null;
  p_otros_nombres := null;
  p_primer_apellido := null;
  p_segundo_apellido := null;
  p_pais_id := null;
  p_numero_identificacion := null;
  p_fecha_ingreso := null;

  pkg_gestion_empleados.prc_ac_empleados(p_empleado_id 				=> p_empleado_id,
										 p_tipo_identificacion_id 	=> p_tipo_identificacion_id,
										 p_area_id 					=> p_area_id,
										 p_primer_nombre 			=> p_primer_nombre,
										 p_otros_nombres 			=> p_otros_nombres,
										 p_primer_apellido 			=> p_primer_apellido,
										 p_segundo_apellido 		=> p_segundo_apellido,
										 p_pais_id 					=> p_pais_id,
										 p_numero_identificacion 	=> p_numero_identificacion,
										 p_fecha_ingreso 			=> p_fecha_ingreso,
										 o_cdgo_rspsta 				=> o_cdgo_rspsta,
										 o_mnsje_rspsta 			=> o_mnsje_rspsta
  );

dbms_output.put_line('o_cdgo_rspsta = ' || o_cdgo_rspsta);
 
dbms_output.put_line('o_mnsje_rspsta = ' || o_mnsje_rspsta);

end;
