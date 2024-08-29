SELECT DISTINCT
if (mu.suspended = 0, 'Activo', 'Suspendido') as status_plataforma,
if (mue.status = 0, 'Activo', 'Suspendido') as status,
mu.username as matricula,
mu.firstname as 'Nombre',
mu.lastname as 'Apellidos',
mu.email as 'correo',
mc.shortname as clave,
mc.fullname as asignatura,
COALESCE(CAST(mgg.finalgrade AS DECIMAL(4,2)), 0) AS calificacion,
from_unixtime(mul.timeaccess,'%Y-%m-%d %k:%i') as 'Fecha.enrolado'
FROM
mdl_user mu
INNER JOIN mdl_user_enrolments mue ON mue.userid = mu.id
INNER JOIN mdl_enrol me ON me.id = mue.enrolid 
LEFT JOIN mdl_course mc ON mc.id = me.courseid
INNER JOIN mdl_grade_items mgi ON mgi.courseid = mc.id AND mgi.itemtype = 'course'
LEFT JOIN mdl_grade_grades mgg ON mgg.userid = mu.id AND mgg.itemid = mgi.id
LEFT JOIN  mdl_user_lastaccess mul ON mul.userid = mu.id and mul.courseid = 1063
WHERE
mc.id IN (1063)