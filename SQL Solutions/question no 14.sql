WITH RankedScores AS (
    SELECT P_ID, Dev_ID, SUM(score) AS total_score,
           ROW_NUMBER() OVER (PARTITION BY Dev_ID ORDER BY SUM(score) DESC) AS a
    FROM level_details2
    GROUP BY P_ID, Dev_ID
)
SELECT P_ID, Dev_ID, total_score
FROM RankedScores
WHERE a <= 3;
