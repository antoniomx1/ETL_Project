SELECT 
	mc.id as id,	
    mc.shortname as clave,
    REPLACE(REPLACE(REPLACE(REPLACE(mc.fullname, ',', ''), ';', ''), CHAR(13), ''), CHAR(10), '') AS asignatura,
    REPLACE(REPLACE(REPLACE(REPLACE(a.name, ',', ''), ';', ''), CHAR(13), ''), CHAR(10), '') AS actividad,
    "Actividades" as Tipo
FROM
	mdl_course mc 
	LEFT JOIN mdl_assign a ON  mc.id = a.course 
