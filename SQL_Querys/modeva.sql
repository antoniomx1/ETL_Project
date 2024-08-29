SELECT DISTINCT
mu.username as matricula,
mc.shortname as clave,
mg.name as modalidad
FROM
mdl_groups_members mgm
INNER JOIN mdl_user mu ON mu.id = mgm.userid and mu.username not like '%demo%'
INNER JOIN mdl_groups mg ON mg.id = mgm.groupid and mg.name not like 'Grupo%'
LEFT JOIN mdl_user_lastaccess mul ON mul.userid = mgm.userid and mul.courseid = mg.courseid
INNER JOIN mdl_course mc ON mc.id = mg.courseid
INNER JOIN mdl_enrol me ON me.courseid = mg.courseid
INNER JOIN mdl_user_enrolments mue ON mue.enrolid = me.id AND mue.userid = mgm.userid
INNER JOIN mdl_context mctx ON mctx.contextlevel = 50 AND mctx.instanceid = mg.courseid
INNER JOIN mdl_role_assignments mra ON mra.contextid = mctx.id AND mra.userid = mgm.userid
INNER JOIN mdl_role mr ON mr.id = mra.roleid and mr.id in (5,13)
WHERE
mc.category IN