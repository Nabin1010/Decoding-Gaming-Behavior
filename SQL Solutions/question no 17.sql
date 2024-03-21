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
