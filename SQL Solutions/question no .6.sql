SELECT 
    ld.Level,
    SUM(ld.Lives_Earned) AS sum_of_lives_earned,
    pd.L2_Code,
    pd.L1_Code
FROM
    level_details2 ld
        INNER JOIN
    player_details pd ON pd.P_ID = ld.P_ID
    where ld.Level >0
GROUP BY ld.Level , pd.L2_Code , pd.L1_Code