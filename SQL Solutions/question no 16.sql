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
