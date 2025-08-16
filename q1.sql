USE ssd_lab_02;

DROP PROCEDURE IF EXISTS ListAllSubscribers;

DELIMITER $$

CREATE PROCEDURE ListAllSubscribers()
BEGIN
  DECLARE v_name VARCHAR(100);
  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT SubscriberName FROM Subscribers;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
    read_loop: LOOP
      FETCH cur INTO v_name;
      IF done THEN LEAVE read_loop; END IF;
      SELECT v_name AS SubscriberName;
    END LOOP;
  CLOSE cur;
END$$
DELIMITER ;

