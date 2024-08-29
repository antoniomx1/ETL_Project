SELECT DISTINCT 
IF(mu.suspended = 0, 'Activo', 'Suspendido') AS status_plataforma,
mu.id AS `id`,
mu.username AS `Matricula`,
mu.firstname AS `Nombre`,
mu.lastname AS `Apellido`,
mu.email AS `Email`,
CASE
    WHEN mr.id = 5 THEN 'Alumno'
    WHEN mr.id = 17 THEN 'Profesor'
    WHEN mr.id = 3 THEN 'Profesor'
    WHEN mr.id = 4 THEN 'Profesor'
    WHEN mr.id = 20 THEN 'Gestor'
    WHEN mr.id = 18 THEN 'Revisor'
    WHEN mr.id = 9 THEN 'Tutor'
    WHEN mr.id = 13 THEN 'Teleton'
    WHEN mr.id = 16 THEN 'Reporteador'
    WHEN mr.id = 14 THEN 'Asesor'
    WHEN mr.id = 21 THEN 'Prof Aux'
    ELSE 'No definido'
END AS `tipo`,
mr.id rol,
IF(mu.lastaccess = 0, 'Nunca', FROM_UNIXTIME(mu.lastaccess)) AS `Ultimo_Acceso`
FROM mdl_user AS mu
LEFT JOIN mdl_groups_members mgm ON mu.id = mgm.userid
LEFT JOIN mdl_role_assignments mra ON mra.userid = mgm.userid
LEFT JOIN mdl_role mr ON mr.id = mra.roleid
WHERE 
mr.id NOT IN (17,5,21)
ORDER BY mr.id