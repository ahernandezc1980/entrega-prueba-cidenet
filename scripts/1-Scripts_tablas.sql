create sequence sq_cid_tipo_identificacion start with 1 increment by 1;
create table cid_tipo_identificacion (
	tipo_identificacion_id		number(2)		default sq_cid_tipo_identificacion.nextval
												constraint cid_tip_idn_tpo_idn_id_pk	primary key
												constraint cid_tip_idn_tpo_idn_id_nn	not null,
	cod_tipo_identificacion		varchar2(3)		constraint cid_tip_idn_cod_tpo_idn_nn	not null,
	descripcion					varchar2(50)	constraint cid_tip_idn_descrpcion_nn	not null

);
comment on table cid_tipo_identificacion is  'Tabla que almacena los diferentes tipo de identificación. Ej: Cedula, Pasaporte, etc';
comment on column cid_tipo_identificacion.tipo_identificacion_id	is 'identificador unico del tipo de identificación';
comment on column cid_tipo_identificacion.cod_tipo_identificacion	is 'Código de los tipo de identificación';
comment on column cid_tipo_identificacion.descripcion			is 'Descripción del tipo de identificación';

/

create sequence sq_areas start with 1 increment by 1;
create table cid_areas(
	area_id				number(4)			default    sq_areas.nextval
											constraint areas_area_id_pk					primary key
											constraint areas_area_id_nn					not null,
	nombre				varchar2(100)		constraint areas_nombre_un					unique
											constraint areas_nombre_nn					not null
);
comment on table cid_areas				is 'Tabla que almacena las areas de trabajo ejemplo: Administración, Financiera, Compras, Infraestructura, Operación, Talento Humano, Servicios Varios, etc.';
comment on column cid_areas.area_id		is 'Identificador unico de la tabla';
comment on column cid_areas.nombre		is 'nombre del area de trabajo';

/


create sequence sq_cid_dominios_correos start with 1 increment by 1;
create table cid_dominios_correos(
	dominio_correo_id 	number(4)			default    sq_cid_dominios_correos.nextval
											constraint cid_dmn_crr_domn_crr_id_pk			primary key
											constraint cid_dmn_crr_domn_crr_id_nn			not null,
	dominio				varchar2(50)		constraint cid_dmn_crr_dominio_un				unique
											constraint cid_dmn_crr_dominio_nn				not null
);
comment on table cid_dominios_correos						is 'Tabla que almacena los dominio de correo electronico ejemplo: cidenet.com.co ,cidenet.com.us ';
comment on column cid_dominios_correos.dominio_correo_id	is 'Identificador unico de la tabla';
comment on column cid_dominios_correos.dominio				is 'nombre dedominio ejemplo: cidenet.com.co ,cidenet.com.us ';
/
create sequence sq_id_correo_electronico start with 1 increment by 1;
/
create sequence sq_cid_paises start with 1 increment by 1;
create table cid_paises(
	pais_id				number(4)			default    sq_cid_paises.nextval
											constraint cid_pais_id_pais_pk					primary key
											constraint cid_pais_id_pais_nn					not null,
	nombre				varchar2(100)   	constraint cid_pais_nombre_un					unique
											constraint cid_pais_nombre_nn					not null,
	dominio_correo_id	number(4)			constraint cid_pais_dominio_correo_id_fk					references cid_dominios_correos (dominio_correo_id)
											constraint cid_pais_dominio_correo_id_nn					not null
);
comment on table cid_paises			is 'Entidad que almacena los paises';
comment on column cid_paises.pais_id	is 'Identificador de la tabla';
comment on column cid_paises.nombre		is 'Nombre del pais';
comment on column cid_paises.dominio_correo_id		is 'identificador del dominio de correo de cada pais';

/

create sequence sq_cid_empleados start with 1 increment by 1;
create table cid_empleados(
	empleado_id				number(10)		default    sq_cid_empleados.nextval
											constraint cid_empleados_empleado_id_pk				primary key
											constraint cid_empleados_empleado_id_nn				not null,
	tipo_identificacion_id	number(2)		constraint cid_empld_tpo_idntfccion_id_fk			references cid_tipo_identificacion (tipo_identificacion_id)
											constraint cid_empld_tpo_idntfccion_id_nn			not null,
	area_id					number(2)		constraint cid_empleados_tipo_area_id_fk			references cid_areas (area_id)
											constraint cid_empleados_tipo_area_id_nn			not null,
	
	primer_nombre			varchar2(20)	constraint cid_empleados_primer_nomnbre_nn			not null,	
	otros_nombres			varchar2(50),              
	primer_apellido			varchar2(50)	constraint cid_empleados_prmr_aplldo_nn				not null,
	segundo_apellido		varchar2(50)	constraint cid_empleados_sgndo_aplldo_nn			not null,
	pais_id					number(4)		constraint cid_empleados_pais_id_fk 				references cid_paises(pais_id)
											constraint cid_empleados_pais_id_nn					not null, 		
	numero_identificacion	varchar(20)	    constraint cid_emplds_nmro_idntfccion_nn			not null,
	correo_electronico	    varchar(300)	constraint cid_emplds_crreo_elctrnco_un				unique
											constraint cid_emplds_crreo_elctrnco_nn				not null,
	fecha_ingreso			timestamp(6)	--constraint cid_empleados_fecha_ingreso_ck			--check ((sysdate - interval '1' month )<fecha_ingreso < sysdate)
											constraint cid_empleados_fecha_ingreso_nn		    not null,
	fecha_registro			timestamp(6)	default    systimestamp,
	fecha_edicion			timestamp(6),
	estado					varchar2(10)    default 'ACTIVO',
	constraint cid_emplds_tpo_idn_num_ide_un unique (tipo_identificacion_id,numero_identificacion)	
);


comment on table cid_empleados 							is 'Tabla que almacena la información básica de los empelados';
comment on column cid_empleados.empleado_id				is 'Identificador de la tabla';
comment on column cid_empleados.tipo_identificacion_id	is 'Tipo de identificacion';
comment on column cid_empleados.area_id					is 'Identificación del area de trabajo del empleado';
comment on column cid_empleados.primer_nombre			is 'Primer Nombre';
comment on column cid_empleados.otros_nombres			is 'otros Nombre';
comment on column cid_empleados.primer_apellido			is 'Primer Apellido';
comment on column cid_empleados.segundo_apellido		is 'Segundo Apellido';
comment on column cid_empleados.pais_id					is 'Pais del empleado';
comment on column cid_empleados.numero_identificacion	is 'identificacion del empelado';
comment on column cid_empleados.correo_electronico		is 'correo electronico generado de manera automatica del empleado';
comment on column cid_empleados.fecha_ingreso			is 'Fecha de ingreso';
comment on column cid_empleados.fecha_registro			is 'Fecha de registro';
comment on column cid_empleados.estado					is 'estado del empleado';

