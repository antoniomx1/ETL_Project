SELECT 
    mm.id as Conversacion,	
    mu1.username as De, 
    mu2.username as Para, 
    FROM_UNIXTIME(mm.time, '%Y-%m-%d %k:%i') as f_envio,
    IF(LEFT(mu1.username, 3) = '019', 'Docente', 'Alumno') as tipo_usuario
FROM 
    mdl_local_mail_messages mm 
JOIN 
    mdl_local_mail_message_users mmu_from 
    ON mmu_from.messageid = mm.id AND mmu_from.role = "from"
JOIN 
    mdl_local_mail_message_users mmu_to
    ON mmu_to.messageid = mm.id AND mmu_to.role = "to"
JOIN 
    mdl_user mu1 
    ON mu1.id = mmu_from.userid
JOIN 
    mdl_user mu2 
    ON mu2.id = mmu_to.userid
WHERE 
    mm.time >= UNIX_TIMESTAMP('2024-06-17 00:00:00')
    AND mm.time <= UNIX_TIMESTAMP('2024-08-20 23:59:59') 