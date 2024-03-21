SELECT Dev_ID, score, difficulty, a
FROM (
    SELECT Dev_ID, score, difficulty,
           RANK() OVER (PARTITION BY difficulty ORDER BY score DESC) AS a
    FROM level_details2
) AS ranked_scores
WHERE a <= 5
ORDER BY difficulty, a;
