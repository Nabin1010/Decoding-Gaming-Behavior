SELECT 
    pd.L1_Code, AVG(ld.Kill_Count) AS avg_kill
FROM
    level_details2 ld
        INNER JOIN
    player_details pd ON pd.P_ID = ld.P_ID
WHERE
    ld.Lives_Earned = 2
        AND ld.Stages_crossed >= 3
GROUP BY pd.L1_Code