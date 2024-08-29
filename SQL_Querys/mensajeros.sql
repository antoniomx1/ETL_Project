SELECT 
    mm.conversationid,
    mu1.username as De, -- Alias mu1 para el usuario 'De'
    mu2.username as Para, -- Alias mu2 para el usuario 'Para'
    from_unixtime(mm.timecreated, '%Y-%m-%d %H:%i') as 'Fecha.envio'
FROM 
    mdl_messages mm
JOIN mdl_message_conversation_members mmcm ON mmcm.conversationid = mm.conversationid 
JOIN mdl_user mu1 ON mu1.id = mm.useridfrom -- Primer JOIN a mdl_user para el emisor
JOIN mdl_user mu2 ON mu2.id = mmcm.userid -- Segundo JOIN a mdl_user para el receptor, usando un alias distinto
WHERE 
    mm.timecreated >= UNIX_TIMESTAMP('2024-04-22 00:00:00') 
    AND mm.timecreated <= UNIX_TIMESTAMP(NOW()) -- Reemplazado con la fecha/hora actual
    AND mm.useridfrom <> mmcm.userid
