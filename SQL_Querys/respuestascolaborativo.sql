SELECT 
  mfp.discussion AS linkforo,
  COUNT(DISTINCT CASE WHEN mu.username NOT LIKE '019%' THEN mfp.id END) AS total_respuestas,
  SUM(CASE WHEN mu.username LIKE '019%' THEN 1 ELSE 0 END) AS total_respuestas_docente
FROM mdl_forum_posts mfp
LEFT JOIN mdl_forum_discussions mfd ON mfd.id = mfp.discussion
LEFT JOIN mdl_forum mf ON mf.id = mfd.forum
LEFT JOIN mdl_course mc ON mc.id = mf.course
LEFT JOIN mdl_user mu ON mu.id = mfp.userid
WHERE LOWER(mfp.subject) LIKE 're:%'
  AND mf.name LIKE '%Espacio colaborativo%'
  AND mc.category IN