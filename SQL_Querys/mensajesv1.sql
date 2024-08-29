SELECT 
    mm.conversationid as Conversacion,	
    mu1.username as De, 
    mu2.username as Para, 
    FROM_UNIXTIME(mm.timecreated, '%Y-%m-%d %H:%i') as f_envio,
    IF(LEFT(mu1.username, 3) = '019', 'Docente', 'Alumno') as tipo_usuario
FROM 
    mdl_messages mm 
JOIN 
    mdl_message_conversation_members mcm 
    ON mcm.conversationid = mm.conversationid AND mm.useridfrom <> mcm.userid
JOIN 
    mdl_user mu1 
    ON mu1.id = mm.useridfrom 
JOIN 
    mdl_user mu2 
    ON mu2.id = mcm.userid 
WHERE 
            mm.timecreated >= UNIX_TIMESTAMP('2024-07-29 00:00:00')
        AND mm.timecreated <= UNIX_TIMESTAMP('2024-08-04 23:59:59')
        
ORDER BY 
    f_envio DESC