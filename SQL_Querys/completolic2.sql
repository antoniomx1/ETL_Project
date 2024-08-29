union SELECT DISTINCT
if (mu.suspended = 0, 'Activo', 'Suspendido') as status_plataforma,
if (mue.status = 0, 'Activo', 'Suspendido') as status,
case
when mr.id = 5 then 'UTEL'
when mr.id = 13 then 'Teleton'
end as 'institucion',
mu.id as id,
mu.username as matricula,
mu.city as 'ciudad',
mu.firstname as 'Nombre',
mu.lastname as 'Apellidos',
mu.email as 'correo',
mc.id as 'materia_id',
mc.shortname as clave,
mg.name as grupo,
cast(mgg.finalgrade as decimal(4,2))  as calificacion,
mr.shortname as rol,
mc.fullname as asignatura,
from_unixtime(mgm.timeadded,'%Y-%m-%d %k:%i') as 'Fecha enrolado',
from_unixtime(mra.timemodified,'%Y-%m-%d %k:%i') as 'Fecha mdf enrol',
if(mul.timeaccess is null,'Nunca',from_unixtime(mul.timeaccess,'%Y-%m-%d %k:%i')) as 'ultimo_acceso_m',
from_unixtime(mgm.timeadded,'%Y-%m-%d %k:%i') as 'fecha add grupo',
FROM_UNIXTIME(mc.startdate) as fecha_inicio,
FROM_UNIXTIME(mqz.timeclose) as fecha_fin,
if(mu.lastaccess is null or mu.lastaccess = 0 ,'Nunca',from_unixtime(mu.lastaccess,'%Y-%m-%d %k:%i')) as 'ultimo_acceso_auvi'
FROM
mdl_groups_members mgm
INNER JOIN mdl_user mu ON mu.id = mgm.userid and mu.username not like '%demo%'
INNER JOIN mdl_groups mg ON mg.id = mgm.groupid and mg.name like 'Grupo%'
LEFT JOIN mdl_user_lastaccess mul ON mul.userid = mgm.userid and mul.courseid = mg.courseid
INNER JOIN mdl_course mc ON mc.id = mg.courseid 
INNER JOIN mdl_enrol me ON me.courseid = mg.courseid
INNER JOIN mdl_user_enrolments mue ON mue.enrolid = me.id AND mue.userid = mgm.userid
INNER JOIN mdl_context mctx ON mctx.contextlevel = 50 AND mctx.instanceid = mg.courseid
INNER JOIN mdl_role_assignments mra ON mra.contextid = mctx.id AND mra.userid = mgm.userid
inner join mdl_grade_items mgi on mgi.courseid = mc.id and itemtype = 'course'
left join mdl_grade_grades mgg on mgg.userid = mu.id and mgi.id = mgg.itemid
INNER JOIN mdl_role mr ON mr.id = mra.roleid and mr.id = 5 
LEFT JOIN mdl_quiz mqz
ON mqz.course = mc.id
AND mqz.name like '%examen final%'
WHERE mu.username NOT REGEXP '^(47|48|49|50)'
AND mc.category IN