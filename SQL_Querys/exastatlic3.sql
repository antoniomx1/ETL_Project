WHERE mqz2.id IS NOT NULL 
    GROUP BY mqsl.quizid
) AS mqtn ON mqz.id = mqtn.quizid
GROUP BY mc.id, mqz.name
ORDER BY mc.shortname ASC