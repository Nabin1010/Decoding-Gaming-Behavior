-- question no 1
SELECT 
    pd.P_ID, pd.PName, ld.Dev_ID, ld.Difficulty, ld.Level
FROM
    level_details2 ld
        INNER JOIN
    player_details pd ON pd.P_ID = ld.P_ID
WHERE
    ld.Level = 0;
    
-- question no 2
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
-- question no 3
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
-- question no 4

SELECT 
    ld.P_ID,
    COUNT(DISTINCT DATE(ld.start_datetime)) AS total_repeat
FROM
    level_details2 ld
GROUP BY ld.P_ID
HAVING COUNT(DISTINCT DATE(ld.start_datetime)) > 1
 -- q no 5
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
-- q no 6 
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

-- q no .7
SELECT Dev_ID, score, difficulty
FROM (
    SELECT ld.Dev_ID, ld.score, ld.difficulty,
           ROW_NUMBER() OVER (PARTITION BY ld.Dev_ID ORDER BY ld.score DESC) AS 'rank'
    FROM level_details2 ld
) AS ranked_scores
WHERE ranked_scores.rank <  3
ORDER BY Dev_ID, ranked_scores.rank;

-- question no 8
SELECT Dev_ID, MIN(start_datetime) AS first_login
FROM level_details2
GROUP BY Dev_ID;
-- no 9
SELECT Dev_ID, score, difficulty, a
FROM (
    SELECT Dev_ID, score, difficulty,
           RANK() OVER (PARTITION BY difficulty ORDER BY score DESC) AS a
    FROM level_details2
) AS ranked_scores
WHERE a <= 5
ORDER BY difficulty, a;
-- no 10
SELECT ld.P_ID, ld.Dev_ID, ld.start_datetime AS first_login_datetime
FROM level_details2 ld
JOIN (
    SELECT P_ID, MIN(start_datetime) AS first_login_time
    FROM level_details2 ld
    GROUP BY P_ID
) AS first_login ON ld.P_ID = first_login.P_ID AND ld.start_datetime = first_login.first_login_time;

-- no 11:
-- with window function
SELECT P_ID, DATE(start_datetime) AS date,
       SUM(kill_count) OVER (PARTITION BY P_ID ORDER BY DATE(start_datetime)) AS total_kill_count_so_far
FROM level_details2;

-- without window function 

SELECT ld1.P_ID, DATE(ld1.start_datetime) AS date,
       SUM(ld2.kill_count) AS total_kill_count_so_far
FROM level_details2 ld1
JOIN level_details2 ld2 ON ld1.P_ID = ld2.P_ID AND ld1.start_datetime >= ld2.start_datetime
GROUP BY ld1.P_ID, DATE(ld1.start_datetime);

-- no 12:
SELECT P_ID, start_datetime, stages_crossed,
       SUM(stages_crossed) OVER (PARTITION BY P_ID ORDER BY start_datetime) AS cumulative_stages_crossed
FROM level_details2;

-- no 13: 
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

-- no 14:
WITH RankedScores AS (
    SELECT P_ID, Dev_ID, SUM(score) AS total_score,
           ROW_NUMBER() OVER (PARTITION BY Dev_ID ORDER BY SUM(score) DESC) AS a
    FROM level_details2
    GROUP BY P_ID, Dev_ID
)
SELECT P_ID, Dev_ID, total_score
FROM RankedScores
WHERE a <= 3;

-- no 15:
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
-- no 16
DELIMITER //

CREATE PROCEDURE FindTopNHeadshots(
    IN n INT
)
BEGIN
    SELECT Dev_ID, headshots_count, difficulty, a
    FROM (
        SELECT Dev_ID, headshots_count, difficulty,
               ROW_NUMBER() OVER (PARTITION BY Dev_ID ORDER BY headshots_count ASC) AS a
        FROM level_details2
    ) AS ranked_headshots
    WHERE a <= n;
END//

DELIMITER ;
 -- no 17:
 DELIMITER //

CREATE FUNCTION GetTotalScoreForPlayer(
    player_id INT
)
RETURNS INT
BEGIN
    DECLARE total_score INT;
    
    SELECT SUM(score) INTO total_score
    FROM level_details2
    WHERE P_ID = player_id;
    
    RETURN total_score;
END//

DELIMITER ;

