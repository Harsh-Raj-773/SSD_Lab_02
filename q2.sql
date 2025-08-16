USE ssd_lab_02;

DROP PROCEDURE IF EXISTS GetWatchHistoryBySubscriber;
DELIMITER $$

CREATE PROCEDURE GetWatchHistoryBySubscriber(IN p_sub_id INT)
BEGIN
  SELECT
    s.SubscriberID,
    TRIM(s.SubscriberName) AS SubscriberName,
    sh.ShowID,
    sh.Title,
    TRIM(sh.Genre) AS Genre,
    sh.ReleaseYear,
    wh.WatchTime
  FROM WatchHistory AS wh
  JOIN Subscribers AS s ON s.SubscriberID = wh.SubscriberID
  JOIN Shows AS sh ON sh.ShowID = wh.ShowID
  WHERE wh.SubscriberID = p_sub_id
  ORDER BY wh.HistoryID;
END$$

DELIMITER ;

-- Tests
CALL GetWatchHistoryBySubscriber(1);
CALL GetWatchHistoryBySubscriber(2);
CALL GetWatchHistoryBySubscriber(3);