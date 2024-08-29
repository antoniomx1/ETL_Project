SELECT itemid AS id_post,rating   
FROM mdl_rating 
WHERE from_unixtime(timecreated) >= '2023-12-04'