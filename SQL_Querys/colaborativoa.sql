SELECT 
    mc.shortname AS clave,
    mc.fullname AS asignatura,
    mf.name AS foro,
    TRIM(REPLACE(REPLACE(REPLACE(REPLACE(mfd.name, ',', ''), ';', ''), ':', ''), '_', '')) AS tema_foro,
    TRIM(REPLACE(REPLACE(REPLACE(REPLACE(mfp.subject, ',', ''), ';', ''), ':', ''), '_', '')) AS asunto,
    -- REPLACE(REPLACE(REPLACE(REPLACE(mfd.name, ',', ''), ';', ''), ':', ''), '_', '') AS tema_foro,
    -- REPLACE(REPLACE(REPLACE(REPLACE(mfp.subject, ',', ''), ';', ''), ':', ''), '_', '') AS asunto,
    if (from_unixtime(mf.assesstimestart)='1969-12-31 18:00:00', '-', from_unixtime(mf.assesstimestart)) AS inicio_valuacion,
    if (from_unixtime(mf.assesstimefinish) ='1969-12-31 18:00:00', '-', from_unixtime(mf.assesstimefinish)) AS fin_valuacion,
    mg.name AS grupo,
    mu.username AS matricula_participante,
    from_unixtime(mfp.created) AS fecha_envio,
    IF(from_unixtime(mfp.modified) = from_unixtime(mfp.created), '-', from_unixtime(mfp.modified)) AS fecha_rating,
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
WHERE mf.name LIKE '%Foro _'
AND mc.category IN 