WITH base_query AS (
    SELECT 
        mm.conversationid as Conversacion,    
        mu1.username as De, 
        mu2.username as Para, 
        REPLACE(REPLACE(REPLACE(REPLACE(mm.smallmessage, ',', ''), ';', ''), CHAR(13), ''), CHAR(10), '') AS Mensaje,
        FROM_UNIXTIME(mm.timecreated, '%Y-%m-%d %H:%i:%s') as f_envio,
        IF(LEFT(mu1.username, 3) = '019', 'Docente', 'Alumno') as tipo_usuario,
        FROM_UNIXTIME('2024-04-28', '%Y-%m-%d') as fec
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
        mm.timecreated >= UNIX_TIMESTAMP('2024-04-22 00:00:00')
        AND mm.timecreated <= UNIX_TIMESTAMP('2024-04-28 23:59:59')
),
conversation_counts AS (
    SELECT
        Conversacion,
        COUNT(DISTINCT De) + COUNT(DISTINCT Para) AS num_integrantes,
        SUM(CASE WHEN LEFT(De, 3) = '019' OR LEFT(Para, 3) = '019' THEN 1 ELSE 0 END) AS count_docente,
        SUM(CASE WHEN LEFT(De, 3) <> '019' OR LEFT(Para, 3) <> '019' THEN 1 ELSE 0 END) AS count_alumno
    FROM base_query
    GROUP BY Conversacion
),
filtered_conversations AS (
    SELECT 
        bq.*
    FROM 
        base_query bq
    JOIN 
        conversation_counts cc
    ON 
        bq.Conversacion = cc.Conversacion
    WHERE 
        cc.num_integrantes <= 2
        AND cc.count_docente > 0
        AND cc.count_alumno > 0
),
ordered_mensajes AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY Conversacion ORDER BY f_envio) AS cuenta,
        COUNT(*) OVER (PARTITION BY Conversacion) AS total_mensajes
    FROM filtered_conversations
),
tipo_respuesta_calculado AS (
    SELECT 
        *,
        CASE 
            WHEN cuenta = total_mensajes AND tipo_usuario = 'Alumno' THEN 'Sin_Respuesta'
            ELSE 'Respuesta'
        END AS tipo_respuesta
    FROM ordered_mensajes
),
respuesta_pendiente_calculado AS (
    SELECT 
        *,
        CASE 
            WHEN tipo_respuesta = 'Sin_Respuesta' 
                 AND f_envio BETWEEN '2024-04-28 19:00:00' AND '2024-04-28 23:59:59' THEN 'Respuesta_Pendiente'
            ELSE tipo_respuesta
        END AS respuesta_pendiente
    FROM tipo_respuesta_calculado
),
mensajes_filtrados AS (
    SELECT *
    FROM respuesta_pendiente_calculado
    WHERE respuesta_pendiente != 'Respuesta'
)
SELECT 
    *,
    ROUND(TIMESTAMPDIFF(MINUTE, f_envio, STR_TO_DATE(fec, '%Y-%m-%d 00:00:00')) / 60, 2) AS tiempo_transcurrido_horas
FROM mensajes_filtrados;
