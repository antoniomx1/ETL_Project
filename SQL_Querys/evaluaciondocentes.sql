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
--    timestamptz 'epoch' + qas.timecreated * interval '1 second', --  // or FROM_UNIXTIME(qas.timecreated) if you are on MySQL.
    qas.userid,
    qasd.name,
    qasd.value,
    mq.name,
    REPLACE(REPLACE(REPLACE(REPLACE(qa.questionsummary, ',', ''), ';', ''), CHAR(13), ''), CHAR(10), '') AS questionsummary
    qa.rightanswer,
    qa.responsesummary
FROM mdl_quiz_attempts quiza
join mdl_quiz mqz on mqz.id = quiza.quiz
join mdl_course mc on mc.id = mqz.course
join mdl_course_categories mcc on mcc.id = mc.category 
JOIN mdl_question_usages qu ON qu.id = quiza.uniqueid
JOIN mdl_question_attempts qa ON qa.questionusageid = qu.id
join mdl_question mq on mq.id = qa.questionid 
JOIN mdl_question_attempt_steps qas ON qas.questionattemptid = qa.id
join mdl_groups mg on mg.courseid = mc.id and mg.name like 'Grupo%'
LEFT JOIN mdl_question_attempt_step_data qasd ON qasd.attemptstepid = qas.id

WHERE
qas.state like '%grade%'
and mqz.name like '%eval%'
and mc.category in