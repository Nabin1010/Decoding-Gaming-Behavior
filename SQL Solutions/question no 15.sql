SELECT 
    P_ID, SUM(score) AS total_score
FROM
    level_details2
GROUP BY P_ID
HAVING SUM(score) > (SELECT 
        0.5 * AVG(sum_score)
    FROM
        (SELECT 
            SUM(score) AS sum_score
        FROM
            level_details2
        GROUP BY P_ID) AS avg_scores);
