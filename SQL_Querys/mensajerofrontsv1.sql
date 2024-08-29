WITH LastMessages AS (
    SELECT 
        conversationid,
        MAX(timecreated) AS latest_time
    FROM 
        mdl_messages
    WHERE
        timecreated >= UNIX_TIMESTAMP('2024-04-22 00:00:00')
        AND timecreated <= UNIX_TIMESTAMP('2024-05-14 23:59:59')
    GROUP BY 
        conversationid
)
SELECT 
    mm.conversationid,
    mu1.username AS De, -- Alias mu1 para el usuario 'De'
    mu2.username AS Para, -- Alias mu2 para el usuario 'Para'
    -- Usamos REGEXP_REPLACE para eliminar caracteres no deseados
    REGEXP_REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(mm.smallmessage, ',', ''), ';', ''), CHAR(13), ''), CHAR(10), ''), '[^a-zA-Z0-9 .,]', '') as Mensaje,
    FROM_UNIXTIME(mm.timecreated, '%Y-%m-%d %H:%i') AS 'Fecha.envio'
FROM 
    mdl_messages mm
JOIN 
    LastMessages lm ON mm.conversationid = lm.conversationid AND mm.timecreated = lm.latest_time
JOIN 
    mdl_message_conversation_members mmcm ON mmcm.conversationid = mm.conversationid
JOIN 
    mdl_user mu1 ON mu1.id = mm.useridfrom -- Primer JOIN a mdl_user para el emisor
JOIN 
    mdl_user mu2 ON mu2.id = mmcm.userid -- Segundo JOIN a mdl_user para el receptor
WHERE 
    mm.useridfrom <> mmcm.userid;
