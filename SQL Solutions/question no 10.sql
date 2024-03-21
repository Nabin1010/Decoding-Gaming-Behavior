SELECT ld.P_ID, ld.Dev_ID, ld.start_datetime AS first_login_datetime
FROM level_details2 ld
JOIN (
    SELECT P_ID, MIN(start_datetime) AS first_login_time
    FROM level_details2 ld
    GROUP BY P_ID
) AS first_login ON ld.P_ID = first_login.P_ID AND ld.start_datetime = first_login.first_login_time;
