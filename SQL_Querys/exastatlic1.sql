SELECT DISTINCT
    mc.id, 
    REPLACE(REPLACE(mc.fullname, ',', ''), ';', '') AS `Asignatura`,  
    mc.shortname AS `clave`, 
    IF(mc.fullname REGEXP '_D', CONCAT(mc.shortname, '_D'), 
        IF(mc.fullname REGEXP '_C', CONCAT(mc.shortname, '_C'), 
            IF(mc.fullname REGEXP '_B', CONCAT(mc.shortname, '_B'),
                mc.shortname))) AS `clave_bloques`, 
    mqz.name AS `Nombre`, 
    FROM_UNIXTIME(mqz.timeopen) AS `Apertura`, 
    FROM_UNIXTIME(mqz.timeclose) AS `Cierre`, 
    mqz.attempts AS `Intentos`, 
    mqtn.slotid AS `preguntas`
FROM mdl_quiz AS mqz 
INNER JOIN mdl_course mc ON mqz.course = mc.id AND mc.category in