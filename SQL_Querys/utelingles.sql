SELECT DISTINCT
    IF(mu.suspended = 0, 'Activo', 'Suspendido') AS status_plataforma,
    IF(mra.roleid = 17, 'Profesor', 'Estudiante') AS perfil,
    mu.username AS matricula,
    mu.firstname AS nombre,
    mu.lastname AS apellidos,
    mc.shortname AS ciclo,
    mu.email AS correo,
    SUBSTRING(mc.shortname, 14) AS clave,
    mc.fullname AS asignatura,
    mg.name AS grupo,
    mq.name AS actividad,
    FROM_UNIXTIME(mqa.timestart) AS comenzado,
    IF(mqa.timefinish <> 0, FROM_UNIXTIME(mqa.timefinish), '') AS completado,
    IF(
        mqa.timefinish <> 0,
        CONCAT(
            IF(((CAST(mqa.timefinish AS signed) - CAST(mqa.timestart AS signed)) DIV 60) > 60,
                ((CAST(mqa.timefinish AS signed) - CAST(mqa.timestart AS signed)) DIV 3600),
                '0'
            ), ':',
            IF(((CAST(mqa.timefinish AS signed) - CAST(mqa.timestart AS signed)) DIV 60) > 60,
                ((CAST(mqa.timefinish AS signed) - CAST(mqa.timestart AS signed)) DIV 60) - 60,
                ((CAST(mqa.timefinish AS signed) - CAST(mqa.timestart AS signed)) DIV 60)
            ), ':',
            ((CAST(mqa.timefinish AS signed) - CAST(mqa.timestart AS signed)) % 60)
        ),
        ''
    ) AS Requerido,
    CAST(ROUND(((mqa.sumgrades * mq.grade) / mq.sumgrades), 2) AS DECIMAL(4,2)) AS calificacion,
    mqa.attempt AS intento,
    CASE
        WHEN CAST(ROUND(((mqa.sumgrades * mq.grade) / mq.sumgrades), 2) AS DECIMAL(4,2)) BETWEEN 25 AND 25 THEN 'Aprobado'
        ELSE 'Reprobado'
    END AS Estatus
FROM
    mdl_course AS mc
    INNER JOIN mdl_groups mg ON mg.courseid = mc.id AND mg.name LIKE 'G%'
    INNER JOIN mdl_groups_members mgm ON mg.id = mgm.groupid
    INNER JOIN mdl_user mu ON mu.id = mgm.userid
    INNER JOIN mdl_role_assignments AS mra ON mu.id = mra.userid
    INNER JOIN mdl_context AS mctx ON mra.contextid = mctx.id AND mctx.contextlevel = 50 AND mctx.instanceid = mc.id
    INNER JOIN mdl_quiz_attempts mqa ON mu.id = mqa.userid
    INNER JOIN mdl_quiz mq ON mq.id = mqa.quiz AND mq.course = mc.id
WHERE
    mra.roleid IN (5, 16, 17)
    AND mc.category IN (16)
 ORDER BY (Estatus)