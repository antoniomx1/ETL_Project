SELECT DISTINCT
    IF (mue.status = 0, 'Activo', 'Suspendido') AS status,
    mu.auth AS auth,
    mu.id AS id_prof,
    mu.username AS matricula,
    CONCAT(mu.firstname, ' ', mu.lastname) AS profesor,
    mu.email AS mail_profesor,
    mc.shortname AS clave,
    REPLACE(REPLACE(mc.fullname, ',', ''), ';', '') AS asignatura,
    mg.name AS grupo,
    mr.shortname AS rol,
    IF (mul.timeaccess IS NULL, 'Nunca', FROM_UNIXTIME(mul.timeaccess, '%Y-%m-%d %k:%i')) AS ultimo_acceso,
    FROM_UNIXTIME(mgm.timeadded, '%Y-%m-%d %k:%i') AS fecha_add_grupo
FROM
    mdl_groups_members mgm
    INNER JOIN mdl_user mu ON mu.id = mgm.userid AND mu.username NOT LIKE '%demo%'
    INNER JOIN mdl_groups mg ON mg.id = mgm.groupid
    LEFT JOIN mdl_user_lastaccess mul ON mul.userid = mgm.userid AND mul.courseid = mg.courseid
    INNER JOIN mdl_course mc ON mc.id = mg.courseid
    INNER JOIN mdl_enrol me ON me.courseid = mg.courseid
    INNER JOIN mdl_user_enrolments mue ON mue.enrolid = me.id AND mue.userid = mgm.userid
    INNER JOIN mdl_context mctx ON mctx.contextlevel = 50 AND mctx.instanceid = mg.courseid
    INNER JOIN mdl_role_assignments mra ON mra.contextid = mctx.id AND mra.userid = mgm.userid
    INNER JOIN mdl_role mr ON mr.id = mra.roleid AND mr.id = 17
WHERE
    mc.category IN

