-- with window function
SELECT P_ID, DATE(start_datetime) AS date,
       SUM(kill_count) OVER (PARTITION BY P_ID ORDER BY DATE(start_datetime)) AS total_kill_count_so_far
FROM level_details2;

-- without window function 

SELECT ld1.P_ID, DATE(ld1.start_datetime) AS date,
       SUM(ld2.kill_count) AS total_kill_count_so_far
FROM level_details2 ld1
JOIN level_details2 ld2 ON ld1.P_ID = ld2.P_ID AND ld1.start_datetime >= ld2.start_datetime
GROUP BY ld1.P_ID, DATE(ld1.start_datetime);

