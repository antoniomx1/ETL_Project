SELECT category, most_recent_date
FROM (
    SELECT category,
           DATE(FROM_UNIXTIME(timecreated)) AS most_recent_date
    FROM mdl_course
    GROUP BY category
) AS categorized_dates
WHERE most_recent_date IN (
    SELECT DISTINCT most_recent_date
    FROM (
        SELECT DATE(FROM_UNIXTIME(timecreated)) AS most_recent_date
        FROM mdl_course
        GROUP BY category
        ORDER BY most_recent_date DESC
        LIMIT 3
    ) AS top_dates
)
ORDER BY most_recent_date DESC;
