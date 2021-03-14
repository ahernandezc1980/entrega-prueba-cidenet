create or replace package pkg_gestion_empleados as

/* Funcion que se encarga de validar expresiones en mayusculas y sin ñ */
function fnc_vl_mayusculas_n (p_parametro_validacion in varchar2 default null)
return varchar2;

/* Funcion que se encarga de validar el formato de la identificacion del empelado */
function fnc_vl_identificacion (p_parametro_validacion in varchar2)
return varchar2;

/* Procedimineto encargado de realizar el registro de empleado */
procedure prc_rg_empleados	( p_tipo_identificacion_id 		in  cid_empleados.tipo_identificacion_id%type,
							  p_area_id 					in  cid_empleados.area_id%type,
							  p_primer_nombre 				in  cid_empleados.primer_nombre%type,
							  p_otros_nombres 				in  cid_empleados.otros_nombres%type,
							  p_primer_apellido				in  cid_empleados.primer_apellido%type,
							  p_segundo_apellido			in  cid_empleados.segundo_apellido%type,
							  p_pais_id						in  cid_empleados.pais_id%type,
							  p_numero_identificacion		in  cid_empleados.numero_identificacion%type,
							  p_fecha_ingreso				in  cid_empleados.fecha_ingreso%type,												  
							  o_cdgo_rspsta					out number,
							  o_mnsje_rspsta				out	varchar2);
							  
/* Procedimineto encargado de actualizar la informacion del empleado */
procedure prc_ac_empleados	( p_empleado_id					in 	cid_empleados.empleado_id%type,
							  p_tipo_identificacion_id 		in  cid_empleados.tipo_identificacion_id%type default null,
							  p_area_id 					in  cid_empleados.area_id%type default null,
							  p_primer_nombre 				in  cid_empleados.primer_nombre%type default null,
							  p_otros_nombres 				in  cid_empleados.otros_nombres%type default null,
							  p_primer_apellido				in  cid_empleados.primer_apellido%type default null,
							  p_segundo_apellido			in  cid_empleados.segundo_apellido%type default null,
							  p_pais_id						in  cid_empleados.pais_id%type default null,
							  p_numero_identificacion		in  cid_empleados.numero_identificacion%type default null,
							  p_fecha_ingreso				in  cid_empleados.fecha_ingreso%type,
							  o_cdgo_rspsta					out number,
							  o_mnsje_rspsta				out	varchar2);
							  
/* Procedimineto encargado de actualizar la informacion del empleado */
procedure prc_el_empleados	( p_empleado_id					in 	cid_empleados.empleado_id%type,
							  o_cdgo_rspsta					out number,
							  o_mnsje_rspsta				out	varchar2);	

/* Procedimineto encargado de consultar la informacion del empleado */

procedure prc_cn_empleados	( p_primer_nombre 				in  cid_empleados.primer_nombre%type default null,
							  p_otros_nombres 				in  cid_empleados.otros_nombres%type default null,
							  p_primer_apellido				in  cid_empleados.primer_apellido%type default null,
							  p_segundo_apellido			in  cid_empleados.segundo_apellido%type default null,
							  p_tipo_identificacion_id 		in  cid_empleados.tipo_identificacion_id%type default null,
							  p_pais_id						in  cid_empleados.pais_id%type default null,
							  p_numero_identificacion		in  cid_empleados.numero_identificacion%type default null,
							  p_correo_electronico			in  cid_empleados.correo_electronico%type default null,													  
							  p_estado						in	cid_empleados.estado%type default null,	
							  p_registros_salida			out sys_refcursor,
							  o_cdgo_rspsta					out number,
							  o_mnsje_rspsta				out	varchar2);							  
end;