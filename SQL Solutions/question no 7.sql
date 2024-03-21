SELECT Dev_ID, score, difficulty
FROM (
    SELECT ld.Dev_ID, ld.score, ld.difficulty,
           ROW_NUMBER() OVER (PARTITION BY ld.Dev_ID ORDER BY ld.score DESC) AS 'rank'
    FROM level_details2 ld
) AS ranked_scores
WHERE ranked_scores.rank <  3
ORDER BY Dev_ID, ranked_scores.rank;
