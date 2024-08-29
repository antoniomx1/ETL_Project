SELECT 
  mc.shortname AS clave,
  mc.fullname AS asignatura,
  mf.name AS foro,
  mfd.name AS tema_foro,
  mfp.subject AS asunto,
  SUBSTRING(mfp.subject, LOCATE('Semana', mfp.subject), 10) AS semana_texto,
  CAST(SUBSTRING(mfp.subject, LOCATE('Semana', mfp.subject) + LENGTH('Semana'), 2) AS UNSIGNED) AS semans,
  IF (FROM_UNIXTIME(mf.assesstimestart) = '1969-12-31 18:00:00', '-', FROM_UNIXTIME(mf.assesstimestart)) AS inicio_valuacion,
  IF (FROM_UNIXTIME(mf.assesstimefinish) = '1969-12-31 18:00:00', '-', FROM_UNIXTIME(mf.assesstimefinish)) AS fin_valuacion,
  mg.name AS grupo,
  mu.username AS matricula_participante,
  FROM_UNIXTIME(mfp.created) AS fecha_envio,
  mfp.attachment AS archivos,
  mf.course AS curso,
  mfd.userid AS creador_foro,
  mfp.id AS id_post,
  mfp.parent AS parent_post,
  mfp.discussion AS linkforo
FROM mdl_forum mf 
LEFT JOIN mdl_forum_discussions mfd ON mfd.forum = mf.id 
LEFT JOIN mdl_forum_posts mfp ON mfp.discussion = mfd.id
LEFT JOIN mdl_course mc ON mc.id = mf.course
LEFT JOIN mdl_groups mg ON mg.id = mfd.groupid 
LEFT JOIN mdl_user mu ON mu.id = mfp.userid
WHERE LOWER(mfp.subject) LIKE '%semana%'
  AND LOWER(mfp.subject) NOT LIKE 're:%'
  AND LOWER(mfp.subject) NOT LIKE '%video%'
  AND LOWER(mfp.subject) NOT LIKE '%diapositiva%'
  AND LOWER(mfp.subject) NOT LIKE '%presentacion%'
  AND LOWER(mfp.subject) NOT LIKE '%virtual%'
  AND LOWER(mfp.subject) NOT LIKE '%duda%'
  AND LOWER(mfp.subject) NOT LIKE '%horarios%'
  AND LOWER(mfp.subject) NOT LIKE '%open%'
  AND LOWER(mfp.subject) NOT LIKE '%preguntas%'
  AND LOWER(mfp.subject) NOT LIKE '%hacer%'
  AND LOWER(mfp.subject) NOT LIKE '%conceptos%'
  AND LOWER(mfp.subject) NOT LIKE '%caso%'
  AND LOWER(mfp.subject) NOT LIKE '%reseña%'
  AND LOWER(mfp.subject) NOT LIKE '%actividad%'
  AND LOWER(mfp.subject) NOT LIKE '%taller%'
  AND LOWER(mfp.subject) NOT LIKE '%tema%'
  AND LOWER(mfp.subject) NOT LIKE '%material%'
  AND LOWER(mfp.subject) NOT LIKE '%evidencias%'
  AND LOWER(mfp.subject) NOT LIKE '%tips%'
  AND LOWER(mfp.subject) NOT LIKE '%revis%'
  AND LOWER(mfp.subject) NOT LIKE '%agenda%'
  AND LOWER(mfp.subject) NOT LIKE '%apoyo%'
  AND LOWER(mfp.subject) NOT LIKE '%sula%'
  AND LOWER(mfp.subject) NOT LIKE '%asunto%'
  AND LOWER(mfp.subject) NOT LIKE '%clase%'
  AND LOWER(mfp.subject) NOT LIKE '%evidencia%'
  AND LOWER(mfp.subject) NOT LIKE '%comunicado%'
  AND LOWER(mfp.subject) NOT LIKE '%bienve%'
  AND LOWER(mfp.subject) NOT LIKE '%formato%'
  AND LOWER(mfp.subject) NOT LIKE '%graba%'
  AND mf.name LIKE '%Espacio del profesor%'
  AND mc.category IN