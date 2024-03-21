SELECT 
    ld.Difficulty,
    SUM(ld.Stages_crossed) AS sum_of_stage_crossed,
    ld.Level,
    ld.Dev_ID
FROM
    level_details2 ld
        INNER JOIN
    player_details pd ON pd.P_ID = ld.P_ID
WHERE
    ld.Level = 2 AND ld.Dev_ID LIKE 'zm%'
GROUP BY ld.Difficulty , ld.Level , ld.Dev_ID
ORDER BY sum_of_stage_crossed DESC