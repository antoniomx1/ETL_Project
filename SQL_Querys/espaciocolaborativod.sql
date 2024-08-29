SELECT 
  mc.shortname AS clave,
  mc.fullname AS asignatura,
  mf.name AS foro,
  mfd.name AS tema_foro,
  mfp.subject AS asunto,
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
WHERE mf.name LIKE '%Espacio colaborativo%'
  AND LOWER(mfp.subject) NOT LIKE 're:%'
  AND LOWER(mfp.subject) LIKE '%distr%'
  AND LOWER(mfd.name) LIKE '%distr%'
  AND mc.category IN