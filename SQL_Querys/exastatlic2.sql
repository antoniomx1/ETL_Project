LEFT JOIN mdl_quiz_slots mqsl ON mqz.id = mqsl.quizid 
LEFT JOIN (
    SELECT 
        COUNT(mqsl.id) AS `slotid`, 
        mqsl.quizid
    FROM mdl_quiz_slots mqsl 
    INNER JOIN mdl_quiz mqz2 ON mqz2.id = mqsl.quizid
    INNER JOIN mdl_course mc2 ON mqz2.course = mc2.id AND mc2.category in