SELECT
    mcc.name,
    mqz.course,
    mc.fullname,
    mg.name,
    quiza.quiz,
    mqz.name,
    quiza.userid,
    quiza.id AS quizattemptid,
    quiza.attempt,
    quiza.sumgrades,
    qu.preferredbehaviour,
    qa.slot,
    qa.behaviour,
    qa.questionid,
    qa.variant,
    qa.maxmark,
    qa.minfraction,
    qa.flagged,
    qas.sequencenumber,
    qas.state,
    qas.fraction,
    -- timestamptz 'epoch' + qas.timecreated * interval '1 second', --  or FROM_UNIXTIME(qas.timecreated) if you are on MySQL.
    qas.userid,
    qasd.name,
    qasd.value,
    mq.name,
    REPLACE(REPLACE(REPLACE(REPLACE(qa.questionsummary, ',', ''), ';', ''), CHAR(13), ''), CHAR(10), '') AS questionsummary,
    qa.rightanswer,
    qa.responsesummary
FROM
    mdl_quiz_attempts quiza
JOIN
    mdl_quiz mqz ON mqz.id = quiza.quiz
JOIN
    mdl_course mc ON mc.id = mqz.course
JOIN
    mdl_course_categories mcc ON mcc.id = mc.category
JOIN
    mdl_question_usages qu ON qu.id = quiza.uniqueid
JOIN
    mdl_question_attempts qa ON qa.questionusageid = qu.id
JOIN
    mdl_question mq ON mq.id = qa.questionid
JOIN
    mdl_question_attempt_steps qas ON qas.questionattemptid = qa.id
JOIN
    mdl_groups mg ON mg.courseid = mc.id AND mg.name LIKE 'Grupo%'
LEFT JOIN
    mdl_question_attempt_step_data qasd ON qasd.attemptstepid = qas.id
WHERE
    qas.state LIKE '%grade%'
    AND mqz.name LIKE '%eval%'
    AND mc.category IN 
