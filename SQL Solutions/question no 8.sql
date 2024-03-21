SELECT Dev_ID, MIN(start_datetime) AS first_login
FROM level_details2
GROUP BY Dev_ID;
