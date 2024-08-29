SELECT DISTINCT
if (mu.suspended = 0, 'Activo', 'Suspendido') as status_plataforma,
if (mue.status = 0, 'Activo', 'Suspendido') as status,
mu.username as matricula,
mu.id as id,
mc.id as 'materia_id',
mc.shortname as clave,
mg.name as grupo,
mg.id as idgrupo
FROM
mdl_groups_members mgm
INNER JOIN mdl_user mu ON mu.id = mgm.userid and mu.username not like '%demo%'
INNER JOIN mdl_groups mg ON mg.id = mgm.groupid and mg.name like 'Grupo%'
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
AND mqz.name like '%examen final%' WHERE
mc.category IN