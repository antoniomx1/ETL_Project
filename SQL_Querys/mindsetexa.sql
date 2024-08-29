SELECT DISTINCT
    IF(mu.suspended = 0, 'Activo', 'Suspendido') AS status_plataforma,
    IF(mra.roleid = 17, 'Profesor', 'Estudiante') AS perfil,
    mu.username AS 'matricula',
    mu.firstname AS 'nombre',
    mu.lastname AS 'apellidos',
    mc.shortname AS 'ciclo',
    mc.fullname AS 'asignatura',
    mq.name AS 'actividad',
    FROM_UNIXTIME(mqa.timestart) AS 'comenzado',
    IF(mqa.timefinish <> 0, FROM_UNIXTIME(mqa.timefinish), '') AS 'completado',
    IF(mqa.timefinish <> 0,
        CONCAT(
            IF(((CAST(mqa.timefinish AS signed) - CAST(mqa.timestart AS signed)) DIV 60) > 60,
               ((CAST(mqa.timefinish AS signed) - CAST(mqa.timestart AS signed)) DIV 3600), '0'),
            ':',
            IF(((CAST(mqa.timefinish AS signed) - CAST(mqa.timestart AS signed)) DIV 60) > 60,
               ((CAST(mqa.timefinish AS signed) - CAST(mqa.timestart AS signed)) DIV 60) - 60,
               ((CAST(mqa.timefinish AS signed) - CAST(mqa.timestart AS signed)) DIV 60)),
            ':',
            ((CAST(mqa.timefinish AS signed) - CAST(mqa.timestart AS signed)) % 60)
        ), '') AS 'Requerido',
    CAST(ROUND(((mqa.sumgrades * mq.grade) / mq.sumgrades), 2) AS DECIMAL(4,2)) AS 'calificacion',
    mqa.attempt AS 'intento'
FROM
    mdl_user mu
    INNER JOIN mdl_user_enrolments mue ON mue.userid = mu.id
    INNER JOIN mdl_enrol me ON me.id = mue.enrolid
    LEFT JOIN mdl_course mc ON mc.id = me.courseid
    INNER JOIN mdl_quiz_attempts mqa ON mu.id = mqa.userid
    INNER JOIN mdl_quiz mq ON mq.id = mqa.quiz AND mc.id = mq.course
    INNER JOIN mdl_role_assignments mra ON mu.id = mra.userid
    INNER JOIN mdl_context mctx ON mra.contextid = mctx.id
WHERE
    mctx.contextlevel = 50
    AND mctx.instanceid = mc.id
    AND mra.roleid IN (5, 16, 17)
    AND mc.id IN (1063)
