/* INSERCION DE DATOS EN LA TABLA  CID_TIPO_IDENTIFICACION*/
insert into cid_tipo_identificacion (cod_tipo_identificacion,descripcion) values ('CC','CEDULA CIUDADNIA');
insert into cid_tipo_identificacion (cod_tipo_identificacion,descripcion) values ('CE','CEDULA EXTRANGERIA');
insert into cid_tipo_identificacion (cod_tipo_identificacion,descripcion) values ('PS','PASAPORTE');
insert into cid_tipo_identificacion (cod_tipo_identificacion,descripcion) values ('PE','PERMISO ESPECIAL');
/
commit;
/* INSERCION DE DATOS EN LA TABLA  CID_AREAS */

insert into cid_areas (nombre) values ('ADMINISTRACION');
insert into cid_areas (nombre) values ('FINANCIERA');
insert into cid_areas (nombre) values ('COMPRAS');
insert into cid_areas (nombre) values ('INFRAESTRUCTURA');
insert into cid_areas (nombre) values ('OPERACION');
insert into cid_areas (nombre) values ('TALENTO HUMANO');
insert into cid_areas (nombre) values ('SERVICIOS VARIOS');
/
commit;
/
/* INSERCION DE DATOS EN LA TABLA  SQ_CID_DOMINIOS_CORREOS  Y */
declare 
v_dominio_correo_id  number;

begin
	begin
		insert into cid_dominios_correos (dominio) 
		values ('cidenet.com.co')
		returning dominio_correo_id into v_dominio_correo_id;
		
		insert into cid_paises (nombre,dominio_correo_id) 
		values ('COLOMBIA',v_dominio_correo_id);		
	end;
	begin 
		insert into cid_dominios_correos (dominio)
		values ('cidenet.com.us')
		returning dominio_correo_id into v_dominio_correo_id;
		
		insert into cid_paises (nombre,dominio_correo_id) 
		values ('ESTADOS UNIDOS',v_dominio_correo_id);
	end;
end;
/
commit;