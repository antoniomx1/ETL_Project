SELECT DISTINCT
    IF(mu.suspended = 0, 'Activo', 'Suspendido') AS status_plataforma,
    IF(mue.status = 0, 'Activo', 'Suspendido') AS status,
    CASE
        WHEN mr.id = 5 THEN 'UTEL'
        WHEN mr.id = 13 THEN 'Teleton'
    END AS institucion,
    mu.id AS id,
    mu.username AS matricula,
    mu.city AS ciudad,
    mu.firstname AS Nombre,
    mu.lastname AS Apellidos,
    mu.email AS correo,
    mc.id AS materia_id,
    mc.shortname AS clave,
    mg.name AS grupo,
    CAST(mgg.finalgrade AS DECIMAL(4,2)) AS calificacion,
    mr.shortname AS rol,
    mc.fullname AS asignatura,
    FROM_UNIXTIME(mgm.timeadded,'%Y-%m-%d %k:%i') AS Fecha_enrolado,
    FROM_UNIXTIME(mra.timemodified,'%Y-%m-%d %k:%i') AS Fecha_mdf_enrol,
    IF(mul.timeaccess IS NULL,'Nunca',FROM_UNIXTIME(mul.timeaccess,'%Y-%m-%d %k:%i')) AS ultimo_acceso_m,
    FROM_UNIXTIME(mgm.timeadded,'%Y-%m-%d %k:%i') AS fecha_add_grupo,
    FROM_UNIXTIME(mc.startdate) AS fecha_inicio,
    FROM_UNIXTIME(mqz.timeclose) AS fecha_fin,
    IF(mu.lastaccess IS NULL OR mu.lastaccess = 0,'Nunca',FROM_UNIXTIME(mu.lastaccess,'%Y-%m-%d %k:%i')) AS ultimo_acceso_auvi
FROM
    mdl_groups_members mgm
    INNER JOIN mdl_user mu ON mu.id = mgm.userid AND mu.username NOT LIKE '%demo%'
    INNER JOIN mdl_groups mg ON mg.id = mgm.groupid AND mg.name LIKE 'Grupo%'
    LEFT JOIN mdl_user_lastaccess mul ON mul.userid = mgm.userid AND mul.courseid = mg.courseid
    INNER JOIN mdl_course mc ON mc.id = mg.courseid 
    INNER JOIN mdl_enrol me ON me.courseid = mg.courseid
    INNER JOIN mdl_user_enrolments mue ON mue.enrolid = me.id AND mue.userid = mgm.userid
    INNER JOIN mdl_context mctx ON mctx.contextlevel = 50 AND mctx.instanceid = mg.courseid
    INNER JOIN mdl_role_assignments mra ON mra.contextid = mctx.id AND mra.userid = mgm.userid
    INNER JOIN mdl_grade_items mgi ON mgi.courseid = mc.id AND mgi.itemtype = 'course'
    LEFT JOIN mdl_grade_grades mgg ON mgg.userid = mu.id AND mgi.id = mgg.itemid
    INNER JOIN mdl_role mr ON mr.id = mra.roleid AND mr.id IN (5, 13) -- Asegúrate de incluir todos los IDs de roles relevantes aquí
    LEFT JOIN mdl_quiz mqz ON mqz.course = mc.id AND mqz.name LIKE "%examen final%"
WHERE
    mu.username NOT REGEXP '^(47|48|49|50)'
AND mc.category IN