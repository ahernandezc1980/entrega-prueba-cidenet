set serveroutput on;
declare
  v_registros_salida  			sys_refcursor;
  v_empleado_id					v_cid_empleados.empleado_id%type			 ;		
  v_tipo_identificacion_id      v_cid_empleados.tipo_identificacion_id%type  ;
  v_numero_identificacion       v_cid_empleados.numero_identificacion%type   ;
  v_tipo_identificacion         v_cid_empleados.tipo_identificacion%type     ;
  v_primer_nombre               v_cid_empleados.primer_nombre%type           ;
  v_otros_nombres               v_cid_empleados.otros_nombres%type           ;
  v_primer_apellido             v_cid_empleados.primer_apellido%type         ;
  v_segundo_apellido            v_cid_empleados.segundo_apellido%type        ;
  v_correo_electronico          v_cid_empleados.correo_electronico%type      ;
  v_area_id                     v_cid_empleados.area_id%type                 ;
  v_nombre_area                 v_cid_empleados.nombre_area%type             ;
  v_pais_id                     v_cid_empleados.pais_id%type                 ;
  v_nombre_pais                 v_cid_empleados.nombre_pais%type             ;
  v_fecha_ingreso               v_cid_empleados.fecha_ingreso%type           ;
  v_fecha_registro              v_cid_empleados.fecha_registro%type          ;
  v_fecha_edicion               v_cid_empleados.fecha_edicion%type           ;
  v_estado                      v_cid_empleados.estado%type                  ;
  p_primer_nombre  				v_cid_empleados.primer_nombre%type           ;
  p_otros_nombres  				v_cid_empleados.otros_nombres%type           ;
  p_primer_apellido 			v_cid_empleados.primer_apellido%type         ;
  p_segundo_apellido 			v_cid_empleados.segundo_apellido%type        ;
  p_tipo_identificacion_id 		v_cid_empleados.tipo_identificacion_id%type  ;
  p_pais_id  					v_cid_empleados.pais_id%type                 ;
  p_numero_identificacion  		v_cid_empleados.numero_identificacion%type   ;
  p_correo_electronico   		v_cid_empleados.correo_electronico%type      ;
  p_estado  					v_cid_empleados.estado%type                  ;
  o_cdgo_rspsta                 number;
  o_mnsje_rspsta                varchar2(400);
begin
  p_primer_nombre := null;
  p_otros_nombres := null;
  p_primer_apellido := null;
  p_segundo_apellido := null;
  p_tipo_identificacion_id := null;
  p_pais_id := null;
  p_numero_identificacion := null;
  p_correo_electronico := null;
  p_estado := null;

  pkg_gestion_empleados.prc_cn_empleados(
										p_primer_nombre 			=> p_primer_nombre,
										p_otros_nombres 			=> p_otros_nombres,
										p_primer_apellido 			=> p_primer_apellido,
										p_segundo_apellido 			=> p_segundo_apellido,
										p_tipo_identificacion_id 	=> p_tipo_identificacion_id,
										p_pais_id 					=> p_pais_id,
										p_numero_identificacion 	=> p_numero_identificacion,
										p_correo_electronico 		=> p_correo_electronico,
										p_estado 					=> p_estado,
										p_registros_salida 			=> v_registros_salida,
										o_cdgo_rspsta 				=> o_cdgo_rspsta,
										o_mnsje_rspsta 				=> o_mnsje_rspsta);

            
  loop 
    fetch v_registros_salida
    into  v_empleado_id				
	      ,v_tipo_identificacion_id
	      ,v_numero_identificacion 
	      ,v_tipo_identificacion   
	      ,v_primer_nombre         
	      ,v_otros_nombres         
	      ,v_primer_apellido       
	      ,v_segundo_apellido      
	      ,v_correo_electronico    
	      ,v_area_id               
	      ,v_nombre_area           
	      ,v_pais_id               
	      ,v_nombre_pais           
	      ,v_fecha_ingreso         
	      ,v_fecha_registro        
	      ,v_fecha_edicion         
	      ,v_estado;
	
    exit when v_registros_salida%notfound;
    dbms_output.put_line(v_empleado_id || ' | ' ||
						 v_tipo_identificacion_id || ' | ' ||
						 v_numero_identificacion  || ' | ' ||
						 v_tipo_identificacion    || ' | ' ||
						 v_primer_nombre          || ' | ' ||
                         v_otros_nombres          || ' | ' ||
                         v_primer_apellido        || ' | ' ||
                         v_segundo_apellido       || ' | ' ||
                         v_correo_electronico     || ' | ' ||
                         v_area_id                || ' | ' ||
                         v_nombre_area            || ' | ' ||
                         v_pais_id                || ' | ' ||
                         v_nombre_pais            || ' | ' ||
                         v_fecha_ingreso          || ' | ' ||
                         v_fecha_registro         || ' | ' ||
                         v_fecha_edicion          || ' | ' ||
                         v_estado);
  end loop;
  close v_registros_salida;
end;