SELECT DISTINCT 
    mu.username as matricula,
    mc.shortname as clave,
    mc.fullname as asignatura,
    a.name as actividad,
    asb.attemptnumber as intentos,
    if(a.duedate != 0, from_unixtime(a.duedate,'%Y-%m-%d %k:%i'), 'Sin limite') as fechalimiteentrega,
    if(asb.timecreated != 0, from_unixtime(asb.timecreated,'%Y-%m-%d %k:%i'), 'Sin envio') as fechadeenvio,
    if(asb.timemodified != 0, from_unixtime(asb.timemodified,'%Y-%m-%d %k:%i'), 'Sin envio') as modificado,
    if(ag.timemodified != 0, from_unixtime(ag.timemodified,'%Y-%m-%d %k:%i'), 'Sin envio') as fechacalif,
    if (ag.grade is not null, ag.grade, 'Sin calificar') as calificacion, 
    if (asb.status != 'new', 'Enviado para calificar', 'Sin Entrega / Visualizado') as statusentrega,
    maf.numfiles as num_archivos
FROM 
    mdl_assign_submission asb
    LEFT JOIN mdl_user mu ON mu.id = asb.userid AND mu.username NOT LIKE '%demo%'
    LEFT JOIN mdl_assign a ON asb.assignment = a.id
    LEFT JOIN mdl_course mc ON a.course = mc.id 
    LEFT JOIN mdl_course_modules mcm ON mcm.course = mc.id AND mcm.instance = a.id 
    LEFT JOIN mdl_assign_grades ag ON asb.userid = ag.userid AND asb.assignment = ag.assignment AND asb.attemptnumber = ag.attemptnumber
    LEFT JOIN mdl_assignfeedback_comments afc ON ag.id = afc.grade AND ag.assignment = afc.assignment
    LEFT JOIN mdl_assignsubmission_file maf ON a.id = maf.assignment AND asb.id = maf.submission
WHERE 
	ag.grade = 0
	AND LOWER(afc.commenttext) LIKE '%plagio%'
	AND asb.status != 'new'
	AND mc.category IN 