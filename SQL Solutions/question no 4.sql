SELECT 
    ld.P_ID,
    COUNT(DISTINCT DATE(ld.start_datetime)) AS total_repeat
FROM
    level_details2 ld
GROUP BY ld.P_ID
HAVING COUNT(DISTINCT DATE(ld.start_datetime)) > 1
