create or replace view v_cid_empleados as
select a.empleado_id
     , a.tipo_identificacion_id
     , a.numero_identificacion
     , b.descripcion as tipo_identificacion
     , a.primer_nombre
     , a.otros_nombres
     , a.primer_apellido
     , a.segundo_apellido
     , a.correo_electronico
     , a.area_id
     , c.nombre as nombre_area
     , a.pais_id
     , d.nombre as nombre_pais
     , a.fecha_ingreso
     , a.fecha_registro
	 , a.fecha_edicion
     , a.estado
  from cid_empleados         a
  join cid_tipo_identificacion b on b.tipo_identificacion_id = a.tipo_identificacion_id
  join cid_areas               c on c.area_id                = a.area_id  
  join cid_paises              d on d.pais_id                = a.pais_id;