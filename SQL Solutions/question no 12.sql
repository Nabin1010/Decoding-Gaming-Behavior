SELECT P_ID, start_datetime, stages_crossed,
       SUM(stages_crossed) OVER (PARTITION BY P_ID ORDER BY start_datetime) AS cumulative_stages_crossed
FROM level_details2;
