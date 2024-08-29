SELECT DISTINCT
        if (mue.status = 0, 'Activo', 'Suspendido') as status,
        mr.id as permiso, 
        mu.auth as auth,
        mu.id as 'id_prof',
        mu.username as matricula,
        concat(mu.firstname, ' ', mu.lastname) as 'profesor',
        mu.email as mail_profesor,
        mc.shortname as clave,
	REPLACE(REPLACE(REPLACE(REPLACE(mc.fullname, ',', ''), ';', ''), CHAR(13), ''), CHAR(10), '') AS asignatura,
        mg.name as grupo,
        mr.shortname as rol,
        if(mul.timeaccess is null,'Nunca',from_unixtime(mul.timeaccess,'%Y-%m-%d %k:%i')) as 'ultimo_acceso',
        from_unixtime(mgm.timeadded,'%Y-%m-%d %k:%i') as fecha_add_grupo,
        mc.id as idc
        FROM
        mdl_groups_members mgm
        INNER JOIN mdl_user mu ON mu.id = mgm.userid and mu.username not like '%demo%'
        INNER JOIN mdl_groups mg ON mg.id = mgm.groupid
        LEFT JOIN mdl_user_lastaccess mul ON mul.userid = mgm.userid and mul.courseid = mg.courseid
        INNER JOIN mdl_course mc ON mc.id = mg.courseid
        INNER JOIN mdl_enrol me ON me.courseid = mg.courseid
        INNER JOIN mdl_user_enrolments mue ON mue.enrolid = me.id AND mue.userid = mgm.userid
        INNER JOIN mdl_context mctx ON mctx.contextlevel = 50 AND mctx.instanceid = mg.courseid
        INNER JOIN mdl_role_assignments mra ON mra.contextid = mctx.id AND mra.userid = mgm.userid
        INNER JOIN mdl_role mr ON mr.id = mra.roleid and mr.id = 22 OR mr.id = 15
        WHERE
        mc.category in 


