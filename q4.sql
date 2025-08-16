USE ssd_lab_02;

DROP PROCEDURE IF EXISTS SendWatchTimeReport;

DELIMITER $$

CREATE PROCEDURE SendWatchTimeReport()
BEGIN
  DECLARE v_id INT;
  DECLARE v_name VARCHAR(100);
  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT s.SubscriberID, s.SubscriberName
    FROM Subscribers s
    WHERE EXISTS (SELECT 1 FROM WatchHistory w WHERE w.SubscriberID = s.SubscriberID)
    ORDER BY s.SubscriberID;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  loop_subs: LOOP
    FETCH cur INTO v_id, v_name;
    IF done = 1 THEN
      LEAVE loop_subs;
    END IF;

    -- Header row
    SELECT CONCAT('Watch Time Report for Subscriber ', v_id, ' - ', TRIM(v_name)) AS Header;

    -- Detailed rows via existing procedure
    CALL GetWatchHistoryBySubscriber(v_id);
  END LOOP;

  CLOSE cur;
END$$

DELIMITER ;

-- Test
CALL SendWatchTimeReport();