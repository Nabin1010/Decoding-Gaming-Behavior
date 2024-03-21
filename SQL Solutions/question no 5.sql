SELECT 
    ld.P_ID, ld.Level, SUM(ld.Kill_Count) AS sum
FROM
    level_details2 ld
WHERE
    ld.Kill_Count > (SELECT 
            AVG(Kill_Count)
        FROM
            level_details2
        WHERE
            Difficulty = 'Medium')
GROUP BY ld.level , ld.P_ID
ORDER BY ld.level
