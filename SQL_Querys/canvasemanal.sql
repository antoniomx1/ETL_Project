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
  -- Extraer el enlace completo usando el delimitador y patrón de "watch?embed"
  SUBSTRING(
    mfp.message,
    INSTR(mfp.message, 'https://www.canva.com/design/'),
    LOCATE('"', mfp.message, INSTR(mfp.message, 'https://www.canva.com/design/')) - INSTR(mfp.message, 'https://www.canva.com/design/')
  ) AS enlace_completo,
  mfp.discussion AS linkforo
FROM mdl_forum mf 
LEFT JOIN mdl_forum_discussions mfd ON mfd.forum = mf.id 
LEFT JOIN mdl_forum_posts mfp ON mfp.discussion = mfd.id
LEFT JOIN mdl_course mc ON mc.id = mf.course
LEFT JOIN mdl_groups mg ON mg.id = mfd.groupid 
LEFT JOIN mdl_user mu ON mu.id = mfp.userid
WHERE mfp.message LIKE '%https://www.canva.com/design/%watch?embed%'
  AND mf.name LIKE 'Espacio del profesor%'
  AND mc.category IN 
