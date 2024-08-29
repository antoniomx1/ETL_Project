SELECT 
	mc.id as id,	
    mc.shortname as clave,
    REPLACE(REPLACE(REPLACE(REPLACE(mc.fullname, ',', ''), ';', ''), CHAR(13), ''), CHAR(10), '') AS asignatura,
    REPLACE(REPLACE(REPLACE(REPLACE(mq.name, ',', ''), ';', ''), CHAR(13), ''), CHAR(10), '') AS actividad,
    "Examenes" as Tipo
    FROM
	mdl_course mc 
	LEFT JOIN mdl_quiz mq  ON  mc.id = mq.course

