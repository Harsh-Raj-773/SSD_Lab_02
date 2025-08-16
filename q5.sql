USE ssd_lab_02;

DROP PROCEDURE IF EXISTS PrintAllSubscribersWatchHistory;

DELIMITER $$

CREATE PROCEDURE PrintAllSubscribersWatchHistory()
BEGIN
  DECLARE v_id INT;
  DECLARE v_name VARCHAR(100);
  DECLARE v_cnt INT DEFAULT 0;
  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT SubscriberID, SubscriberName
    FROM Subscribers
    ORDER BY SubscriberID;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  loop_all: LOOP
    FETCH cur INTO v_id, v_name;
    IF done = 1 THEN
      LEAVE loop_all;
    END IF;

    -- Header row
    SELECT CONCAT('Watch History for Subscriber ', v_id, ' - ', TRIM(v_name)) AS Header;

    -- If has history, show it; else, say none
    SELECT COUNT(*) INTO v_cnt FROM WatchHistory WHERE SubscriberID = v_id;
    IF v_cnt > 0 THEN
      CALL GetWatchHistoryBySubscriber(v_id);
    ELSE
      SELECT 'No watch history found' AS Info;
    END IF;
  END LOOP;

  CLOSE cur;
END$$

DELIMITER ;

-- Test
CALL PrintAllSubscribersWatchHistory();