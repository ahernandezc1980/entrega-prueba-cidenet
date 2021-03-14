create or replace package body pkg_gestion_empleados as   

/* Funcion que se encarga de validar expresiones en mayusculas y sin ñ */
function fnc_vl_mayusculas_n (p_parametro_validacion in varchar2 default null)
return varchar2
as 
v_cumple_validacion number;
begin
    if  p_parametro_validacion is not null then
		begin
			select 1
			into v_cumple_validacion
			from dual 
			where regexp_like(p_parametro_validacion,'^[[:upper:]]+$')
			and not regexp_instr (p_parametro_validacion, 'Ñ')> 0
            and not regexp_like(p_parametro_validacion,'[áéíóúüÁÉÍÓÚÜ]');
		exception
			when no_data_found then
				return 'N';
		end;
		if v_cumple_validacion is not null then
			return 'S';
		end if;	
	else 
        return 'S';
	end if;
end fnc_vl_mayusculas_n;

function fnc_vl_identificacion (p_parametro_validacion in varchar2)
return varchar2
as 
v_cumple_validacion number;
begin 
	begin
		select 	1
		into  	v_cumple_validacion
		from 	dual 
		where	regexp_like(p_parametro_validacion, '^([A-Za-z0-9]+[A-Za-z0-9-]+[A-Za-z0-9]+)$');
	exception
		when no_data_found then
			return 'N';
	end;
	if v_cumple_validacion is not null then
        return 'S';
	end if;	
end fnc_vl_identificacion;

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
							  o_mnsje_rspsta				out	varchar2)
as

v_cumple_condicion			varchar(1);
v_cumple_identificacion     varchar(1);
v_correo_electronico		cid_empleados.correo_electronico%type;	
v_empleado_id				cid_empleados.empleado_id%type;	
v_dominio					cid_dominios_correos.dominio%type;
v_count_correo_electronico	number; 
			
begin
o_cdgo_rspsta:= 0;
o_mnsje_rspsta:= ' Empleado registrado con Exito ';

	/*  Paso: validar mayusculas */
	declare
		type validacion_array_t is varray(4) of varchar2(50);
		array validacion_array_t := validacion_array_t(p_primer_nombre,replace(p_primer_apellido,' ',''),replace(p_segundo_apellido,' ',''),replace(p_otros_nombres,' ','') ); 
	begin
	   for i in 1..array.count loop
		   v_cumple_condicion:= pkg_gestion_empleados.fnc_vl_mayusculas_n (array(i));	
		
		   if v_cumple_condicion = 'N' then
				o_cdgo_rspsta:= 10;
				o_mnsje_rspsta:= o_cdgo_rspsta||' - ' || array(i) || ' debe estar en letras mayusculas y no contener acentos ni la letra ñ.' ;
				return;
		   end if;
	   end loop;
	end;
	
	/*  Paso: validar identificacion */
	begin
		 v_cumple_identificacion:= pkg_gestion_empleados.fnc_vl_identificacion (p_numero_identificacion);
		 if v_cumple_identificacion = 'N' then
			o_cdgo_rspsta:= 20;
			o_mnsje_rspsta:= o_cdgo_rspsta||' - La identificacion no cumple con el formato establecido.' ;
			return;
		 end if;	
	end;

	/* Paso: validacion fecha ingreso */
	if ( p_fecha_ingreso > sysdate) or (p_fecha_ingreso < (sysdate -30)) then
		    rollback;
			o_cdgo_rspsta:= 30;
			o_mnsje_rspsta:= o_cdgo_rspsta||' - la Fecha de ingreso debe estar entre : ' ||sysdate ||' y '||(sysdate -30);
			return;	
	end if;
	/* Paso: Seleccion de dominio segun pais*/
	begin
		select 	dominio
		into 	v_dominio
		from 	cid_paises p
		join 	cid_dominios_correos d on p.dominio_correo_id = d.dominio_correo_id
		where 	pais_id = p_pais_id;
	exception
		when others then
			rollback;
			o_cdgo_rspsta:= 40;
			o_mnsje_rspsta:= o_cdgo_rspsta||' - Verifique la asociacion de paises con un dominio de correos: ' || sqlerrm;
			return;	
	end;
		
	/* Paso: Construccion de Correo*/	
	begin
		select count(correo_electronico)
		into  v_count_correo_electronico
		from  cid_empleados
		where primer_nombre 	= p_primer_nombre 
		and   primer_apellido 	= p_primer_apellido
		and   pais_id 			= p_pais_id;	
		if v_count_correo_electronico > 0  then
			v_correo_electronico:= lower(p_primer_nombre) ||'.'||replace(lower(p_primer_apellido),' ','')||'.'||(v_count_correo_electronico + 1)||'@'||v_dominio;
		else
			v_correo_electronico:= lower(p_primer_nombre) ||'.'||replace(lower(p_primer_apellido),' ','')||'@'||v_dominio;
		end if;
	exception
		when others then
			rollback;
			o_cdgo_rspsta:= 50;
			o_mnsje_rspsta:= o_cdgo_rspsta||' - No se pudo generar el correo electronico: ' || sqlerrm;
			return;		
	end;	
		
	/* Validacion del tipo de identiciacion + identificacion del empleado */
	begin
		select empleado_id
		into v_empleado_id
		from cid_empleados
		where tipo_identificacion_id = p_tipo_identificacion_id
		and   numero_identificacion  = p_numero_identificacion;	
	exception
		when no_data_found then
				begin
					insert into cid_empleados  (tipo_identificacion_id	
												,area_id
												,primer_nombre			
												,otros_nombres			
												,primer_apellido			
												,segundo_apellido		
												,pais_id				
												,numero_identificacion	
												,correo_electronico	
												,fecha_ingreso)
										values ( p_tipo_identificacion_id 	
												 ,p_area_id 				
												 ,p_primer_nombre 			
												 ,p_otros_nombres 			
												 ,p_primer_apellido			
												 ,p_segundo_apellido		
												 ,p_pais_id					
												 ,p_numero_identificacion
												 ,v_correo_electronico		
												 ,p_fecha_ingreso);	
                                                 commit;
				exception
					when others then
						rollback;
						o_cdgo_rspsta:= 60;
						o_mnsje_rspsta:= o_cdgo_rspsta||' - No se Pudo realizar el registro del empelado, debido a: ' || sqlerrm;
						return;	
				end;	
	end;
	if v_empleado_id is not null then
		rollback;
		o_cdgo_rspsta:= 70;
		o_mnsje_rspsta:= o_cdgo_rspsta||' - No se Pudo realizar el registro del empelado, '||
						'ya existe en el sistema un empleado con tipo y numero de identificacion igual';
		return;	
	end if;
	

end prc_rg_empleados;

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
							  o_mnsje_rspsta				out	varchar2)
as

v_cumple_condicion			varchar(1);
v_cumple_identificacion     varchar(1);
v_primer_nombre				cid_empleados.primer_nombre%type;
v_primer_apellido			cid_empleados.primer_apellido%type;
v_pais_id					cid_empleados.pais_id%type;
v_correo_electronico		cid_empleados.correo_electronico%type;	
v_empleado_id				cid_empleados.empleado_id%type;	
v_dominio					cid_dominios_correos.dominio%type;
v_count_correo_electronico	number; 
e_cero_actualizacion		exception;			
begin
o_cdgo_rspsta:= 0;
o_mnsje_rspsta:= ' Empleado Actualizado con Exito ';

	/*  Paso: validar mayusculas */
	declare
		type validacion_array_t is varray(4) of varchar2(50);
		array validacion_array_t := validacion_array_t(p_primer_nombre,replace(p_primer_apellido,' ',''),replace(p_segundo_apellido,' ',''),replace(p_otros_nombres,' ','') ); 
	begin
	   for i in 1..array.count loop
		   v_cumple_condicion:= pkg_gestion_empleados.fnc_vl_mayusculas_n (array(i));	
		
		   if v_cumple_condicion = 'N' then
				o_cdgo_rspsta:= 10;
				o_mnsje_rspsta:= o_cdgo_rspsta||' - ' || array(i) || ' debe estar en letras mayusculas y no contener la letra ñ.' ;
				return;
		   end if;
	   end loop;
	end;
	
	/*  Paso: validar identificacion */
	if p_numero_identificacion is not null then
		begin
			 v_cumple_identificacion:= pkg_gestion_empleados.fnc_vl_identificacion (p_numero_identificacion);
			 if v_cumple_identificacion = 'N' then
				o_cdgo_rspsta:= 20;
				o_mnsje_rspsta:= o_cdgo_rspsta||' - La identificacion no cumple con el formato establecido.' ;
				return;
			 end if;	
		end;
	end if;
	/* Paso: validacion fecha de ingreso */
	if ( p_fecha_ingreso > sysdate) or (p_fecha_ingreso < (sysdate -30)) then
		    rollback;
			o_cdgo_rspsta:= 30;
			o_mnsje_rspsta:= o_cdgo_rspsta||' - la Fecha de edicion debe estar entre : ' ||sysdate ||' y '||(sysdate -30);
			return;	
	end if;
	/* corroborar si nombre y apellidos se van a actualizar para volver a generar el correo */
	begin
		select primer_nombre
			  ,primer_apellido
			  ,pais_id
		into   v_primer_nombre
			  ,v_primer_apellido
			  ,v_pais_id
		from   cid_empleados
		where  empleado_id = p_empleado_id;
	exception
		when others then
			rollback;
			o_cdgo_rspsta:= 40;
			o_mnsje_rspsta:= o_cdgo_rspsta||' - No existe empleado con este id , verifique : ' || sqlerrm;
			return;		
	end;
	
	/* condicion para volver a generar el correo */
	if ( v_primer_nombre <> p_primer_nombre) or (v_primer_apellido <> p_primer_apellido) or (v_pais_id <> p_pais_id) then 
	/* Paso: Seleccion de dominio segun pais*/
		begin
			select 	dominio
			into 	v_dominio
			from 	cid_paises p
			join 	cid_dominios_correos d on p.dominio_correo_id = d.dominio_correo_id
			where 	pais_id = nvl(p_pais_id,v_pais_id);
		exception
			when others then
				rollback;
				o_cdgo_rspsta:= 50;
				o_mnsje_rspsta:= o_cdgo_rspsta||' - Verifique la asociacion de paises con un dominio de correos: ' || sqlerrm;
				return;	
		end;
			
		/* Paso: Construccion de Correo*/	
		begin
			select count(correo_electronico)
			into  v_count_correo_electronico
			from  cid_empleados
			where primer_nombre   = nvl(p_primer_nombre,v_primer_nombre)
			and   primer_apellido = nvl(p_primer_apellido,v_primer_apellido)
			and   pais_id         = nvl(p_pais_id,v_pais_id);	
			if v_count_correo_electronico > 0  then
				v_correo_electronico:= lower(nvl(p_primer_nombre,v_primer_nombre)) ||'.'||replace(lower(nvl(p_primer_apellido,v_primer_apellido)),' ','')||'.'||(v_count_correo_electronico + 1)||'@'||v_dominio;
			else
				v_correo_electronico:= lower(nvl(p_primer_nombre,v_primer_nombre)) ||'.'||replace(lower(nvl(p_primer_apellido,v_primer_apellido)),' ','')||'@'||v_dominio;
			end if;
		exception
			when others then
				rollback;
				o_cdgo_rspsta:= 60;
				o_mnsje_rspsta:= o_cdgo_rspsta||' - No se pudo generar el correo electronico: ' || sqlerrm;
				return;		
		end;	
	end if;	
	/* Actualizcion de la informacion del empleado */
	
	begin
		update cid_empleados 
		set    tipo_identificacion_id	= nvl(p_tipo_identificacion_id,tipo_identificacion_id)
              ,area_id                  = nvl(p_area_id,area_id)
              ,primer_nombre			= nvl(p_primer_nombre,primer_nombre)
              ,otros_nombres			= nvl(p_otros_nombres,otros_nombres)
              ,primer_apellido		    = nvl(p_primer_apellido,primer_apellido)
              ,segundo_apellido		    = nvl(p_segundo_apellido,segundo_apellido) 
              ,pais_id				    = nvl(p_pais_id,pais_id)
              ,numero_identificacion	= nvl(p_numero_identificacion,numero_identificacion )
              ,correo_electronico	    = nvl(v_correo_electronico,correo_electronico)
              ,fecha_edicion            = sysdate
		where empleado_id = p_empleado_id;
		if sql%notfound then
			raise e_cero_actualizacion;
		
		else
			commit;
		end if;
		
	exception
		when e_cero_actualizacion then
			rollback;
			o_cdgo_rspsta:= 70;
			o_mnsje_rspsta:= o_cdgo_rspsta||' - No se realizo la actulizacion del empelado, debido a: ' || sqlerrm;
			return;
		when others then
			rollback;
			o_cdgo_rspsta:= 80;
			o_mnsje_rspsta:= o_cdgo_rspsta||' - No se realizo la actulizacion del empelado, debido a: ' || sqlerrm;
			return;	
	end;	
	

end prc_ac_empleados;

procedure prc_el_empleados	( p_empleado_id					in 	cid_empleados.empleado_id%type,
							  o_cdgo_rspsta					out number,
							  o_mnsje_rspsta				out	varchar2)
as
e_cero_eliminacion exception;
begin
o_cdgo_rspsta:= 0;
o_mnsje_rspsta:= 'Empleado Eliminado con Exito ';
    begin
        delete cid_empleados
        where  empleado_id = p_empleado_id;
        if sql%notfound then
            raise e_cero_eliminacion;
        else
            commit;
        end if;
    exception
		when e_cero_eliminacion then
			rollback;
			o_cdgo_rspsta:= 10;
			o_mnsje_rspsta:= o_cdgo_rspsta||' - No se realizo la eliminacion del empelado, no se encontro el id del empelado ' ;
			return;
		when others then
			rollback;
			o_cdgo_rspsta:= 20;
			o_mnsje_rspsta:= o_cdgo_rspsta||' - No se realizo la eliminacion del empelado, debido a: ' || sqlerrm;
			return;
     end;       
end prc_el_empleados;							

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
							  o_mnsje_rspsta				out	varchar2)
as

begin
	begin
		open p_registros_salida for
			select a.empleado_id
				, a.tipo_identificacion_id
				, a.numero_identificacion
				, a.tipo_identificacion
				, a.primer_nombre
				, a.otros_nombres
				, a.primer_apellido
				, a.segundo_apellido
				, a.correo_electronico
				, a.area_id
				, a.nombre_area
				, a.pais_id
				, a.nombre_pais
				, a.fecha_ingreso
				, a.fecha_registro
				, a.fecha_edicion
				, a.estado
			from v_cid_empleados         a
			where a.primer_nombre like '%'||nvl(upper(p_primer_nombre),a.primer_nombre)||'%'
			and   a.otros_nombres like '%'||nvl(upper(p_otros_nombres),a.otros_nombres)||'%'
			and   a.primer_apellido like '%'||nvl(upper(p_primer_apellido),a.primer_apellido)||'%'	
			and   a.segundo_apellido like '%'||nvl(upper(p_segundo_apellido),a.segundo_apellido)||'%'
			and   a.tipo_identificacion_id like '%'||nvl(p_tipo_identificacion_id,a.tipo_identificacion_id)||'%'	
			and   a.numero_identificacion like '%'||nvl(upper(p_numero_identificacion),a.numero_identificacion)||'%'
			and   a.pais_id like '%'||nvl(p_pais_id,a.pais_id)||'%'
			and   a.correo_electronico like '%'||nvl(p_correo_electronico,a.correo_electronico)||'%'
			and   a.estado like '%'||nvl(upper(p_estado),a.estado)||'%'
			order by empleado_id;
	exception
		when others then
			rollback;
			o_cdgo_rspsta:= 20;
			o_mnsje_rspsta:= o_cdgo_rspsta||' - No se realizo la eliminacion del empelado, debido a: ' || sqlerrm;
			return;
	end;
	
end prc_cn_empleados;	

end pkg_gestion_empleados;