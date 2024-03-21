WITH RankedLD AS (
    SELECT P_ID, start_datetime, stages_crossed,
           ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY start_datetime DESC) AS rn
    FROM level_details2
)
SELECT P_ID, start_datetime, stages_crossed,
       SUM(stages_crossed) OVER (PARTITION BY P_ID ORDER BY start_datetime) - 
       CASE WHEN rn = 1 THEN stages_crossed ELSE 0 END AS cumulative_stages_crossed
FROM RankedLD
WHERE rn <> 1;
