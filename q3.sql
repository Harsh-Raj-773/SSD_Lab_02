USE ssd_lab_02;

DROP PROCEDURE IF EXISTS AddSubscriberIfNotExists;

DELIMITER $$

CREATE PROCEDURE AddSubscriberIfNotExists(IN subName VARCHAR(100))
BEGIN
  DECLARE v_clean_name VARCHAR(100) DEFAULT TRIM(subName);
  DECLARE v_exists INT DEFAULT 0;
  DECLARE v_new_id INT DEFAULT NULL;
  DECLARE v_existing_id INT DEFAULT NULL;

  SELECT COUNT(*)
    INTO v_exists
  FROM Subscribers
  WHERE LOWER(TRIM(SubscriberName)) = LOWER(v_clean_name);

  IF v_exists > 0 THEN
    SELECT SubscriberID
      INTO v_existing_id
    FROM Subscribers
    WHERE LOWER(TRIM(SubscriberName)) = LOWER(v_clean_name)
    LIMIT 1;

    SELECT 'Subscriber already exists' AS msg, v_existing_id AS SubscriberID, v_clean_name AS SubscriberName;
  ELSE
    SELECT COALESCE(MAX(SubscriberID), 0) + 1
      INTO v_new_id
    FROM Subscribers;

    INSERT INTO Subscribers (SubscriberID, SubscriberName, SubscriptionDate)
    VALUES (v_new_id, v_clean_name, CURDATE());

    SELECT 'Inserted' AS msg, v_new_id AS SubscriberID, v_clean_name AS SubscriberName;
  END IF;
END$$

DELIMITER ;

-- Tests
CALL AddSubscriberIfNotExists('Emily Clark');         -- should say exists
CALL AddSubscriberIfNotExists('  emily clark  ');     -- should say exists (trim/case-insensitive)
CALL AddSubscriberIfNotExists('New Person');          -- should insert
SELECT * FROM Subscribers ORDER BY SubscriberID;