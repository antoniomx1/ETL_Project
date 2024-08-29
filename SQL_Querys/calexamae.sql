SELECT 
  mu.username as 'Usuario', 
  mu.firstname as 'Nombre(s)', 
  mu.lastname as 'Apellidos', 
  mc.shortname as 'Ciclo', 
  substring(mc.shortname,14) as 'Clave', 
  REPLACE(REPLACE(REPLACE(REPLACE(mc.fullname, ',', ''), ';', ''), CHAR(13), ''), CHAR(10), '') as 'Asignatura', 
  mg.name as 'Grupo', 
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(
                mq.name, ',', ' '),
              ';', ' '),
            '"', ' '),
          '/', ' '),
        '|', ' '),
      '_', ' '),
    '-', ' ') as 'Actividad',
  from_unixtime(mqa.timestart) as 'Comenzado', 
  from_unixtime(mqa.timefinish) as 'Completado', 
  concat( 
    if(((cast(mqa.timefinish as signed)-cast(mqa.timestart as signed)) div 60)>60,((cast(mqa.timefinish as signed)-cast(mqa.timestart as signed)) div 3600),'0'), 
    ':', 
    if(((cast(mqa.timefinish as signed)-cast(mqa.timestart as signed)) div 60)>60,((cast(mqa.timefinish as signed)-cast(mqa.timestart as signed)) div 60)-60,((cast(mqa.timefinish as signed)-cast(mqa.timestart as signed)) div 60)), 
    ':', 
    ((cast(mqa.timefinish as signed)-cast(mqa.timestart as signed))) % 60 
  ) as 'Requerido', 
  COALESCE(round(((mqa.sumgrades*mq.grade)/mq.sumgrades),2), -1) as 'calificacion', 
  mqa.attempt as 'Intento',
  mqa.id as 'idlink'
FROM mdl_course as mc 
inner join mdl_groups mg on mg.courseid = mc.id, 
mdl_groups_members mgm, 
mdl_quiz_attempts mqa 
inner join mdl_quiz mq on mq.id = mqa.quiz 
inner join mdl_user mu on mu.id = mqa.userid, 
mdl_role_assignments as mra 
inner join mdl_context as mctx on mra.contextid=mctx.id 
where mctx.contextlevel = 50 and mg.id = mgm.groupid 
and mu.id=mra.userid and mu.id = mgm.userid 
and mc.id = mq.course and mctx.instanceid=mc.id 
and mra.roleid = 5 
and mc.category IN 