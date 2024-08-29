SELECT DISTINCT
    mc.fullname AS asignatura,
    mc.shortname AS clave,
    mm.id AS id_envio,
    mr.shortname AS role,
    mu.username AS matricula,
    mu.firstname AS nombre,
    mu.lastname AS apellido,
    mmu.role AS Tipo,
    FROM_UNIXTIME(mm.time, '%Y-%m-%d %k:%i') AS Fecha_Envio,
    mm.normalizedsubject AS Titulo,
    IF(mmu.unread = 0, 'Abierto', 'Sin_Abrir') AS status_lectura
FROM
    mdl_local_mail_messages mm
    INNER JOIN mdl_course mc ON mc.id = mm.courseid
    INNER JOIN mdl_local_mail_message_users mmu ON mmu.messageid = mm.id
    INNER JOIN mdl_user mu ON mu.id = mmu.userid
    INNER JOIN mdl_role_assignments mra ON mra.userid = mmu.userid
    INNER JOIN mdl_role mr ON mr.id = mra.roleid
WHERE
    mc.category IN 