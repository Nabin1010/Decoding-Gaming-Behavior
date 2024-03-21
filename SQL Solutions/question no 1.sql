SELECT 
    pd.P_ID, pd.PName, ld.Dev_ID, ld.Difficulty, ld.Level
FROM
    level_details2 ld
        INNER JOIN
    player_details pd ON pd.P_ID = ld.P_ID
WHERE
    ld.Level = 0;