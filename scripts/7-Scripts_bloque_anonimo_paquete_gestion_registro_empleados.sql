set serveroutput on;
declare
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
  p_tipo_identificacion_id := 1;
  p_area_id := 1;
  p_primer_nombre := 'ALEXANDER';
  p_otros_nombres := 'ELIAS';
  p_primer_apellido := 'HERNANDEZ';
  p_segundo_apellido := 'CUADRADO';
  p_pais_id := 2;
  p_numero_identificacion := 'V-1045742278';
  p_fecha_ingreso := sysdate;

  pkg_gestion_empleados.prc_rg_empleados( p_tipo_identificacion_id => p_tipo_identificacion_id,
                                          p_area_id                => p_area_id,
                                          p_primer_nombre          => p_primer_nombre,
                                          p_otros_nombres          => p_otros_nombres,
                                          p_primer_apellido        => p_primer_apellido,
                                          p_segundo_apellido       => p_segundo_apellido,
                                          p_pais_id                => p_pais_id,
                                          p_numero_identificacion  => p_numero_identificacion,
                                          p_fecha_ingreso          => p_fecha_ingreso,
                                          o_cdgo_rspsta            => o_cdgo_rspsta,
                                          o_mnsje_rspsta           => o_mnsje_rspsta
  );

dbms_output.put_line('o_cdgo_rspsta = ' || o_cdgo_rspsta);

dbms_output.put_line('o_mnsje_rspsta = ' || o_mnsje_rspsta);

end;
