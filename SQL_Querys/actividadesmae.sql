SELECT DISTINCT 
        CONCAT(mc.shortname, mg.name) as clave_g,
        mu.username as matricula,
        mc.shortname as clave,
        mg.name as grupo,
	REPLACE(REPLACE(REPLACE(REPLACE(mc.fullname, ',', ''), ';', ''), CHAR(13), ''), CHAR(10), '') AS asignatura,
        REPLACE(REPLACE(REPLACE(REPLACE(a.name, ',', ''), ';', ''), CHAR(13), ''), CHAR(10), '') AS actividad,
        asb.attemptnumber as intentos,
        if(a.duedate != 0, from_unixtime(a.duedate,'%Y-%m-%d %k:%i'), 'Sin limite') as fechalimiteentrega,
        if(asb.timecreated != 0, from_unixtime(asb.timecreated,'%Y-%m-%d %k:%i'), 'Sin envio') as fechadeenvio,
        if(asb.timemodified != 0, from_unixtime(asb.timemodified,'%Y-%m-%d %k:%i'), 'Sin envio') as modificado,
	if(ag.timemodified != 0, from_unixtime(ag.timemodified,'%Y-%m-%d %k:%i'), 'Sin envio') as fechacalif,
        if (ag.grade is not null, ag.grade, 'Sin calificar') as calificacion, 
        if (asb.status != 'new', 'Enviado para calificar', 'Sin Entrega / Visualizado') as statusentrega,
        if(afc.commenttext is not null, 'Retro', 'Sin Retro') as retro,
        maf.numfiles as num_archivos
        from mdl_assign_grades ag 
        left join mdl_assign a ON  ag.assignment = a.id
        left JOIN mdl_course mc ON a.course = mc.id 
        left join mdl_assign_submission asb ON ag.userid = asb.userid 
        and ag.assignment=asb.assignment and ag.attemptnumber = asb.attemptnumber
        left join mdl_user mu ON mu.id = ag.userid and mu.username not like '%demo%'
        LEFT JOIN mdl_groups mg ON mc.id = mg.courseid and mg.name like 'Grupo%' 
        RIGHT JOIN mdl_groups_members mgm ON mgm.userid = mu.id and mgm.groupid = mg.id 
        left join mdl_assignfeedback_comments afc on ag.id = afc.grade and ag.assignment = afc.assignment
        left join mdl_assignsubmission_file maf on a.id = maf.assignment and asb.id = maf.submission
        WHERE 
        mc.category in