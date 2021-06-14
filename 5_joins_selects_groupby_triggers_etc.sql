USE postcrossing;

-- ****************** скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы) ******************

-- Самые популярные открытки
SELECT 
	target_id AS postcard, 
	COUNT(target_id) AS total 
FROM likes 
GROUP BY target_id
ORDER BY total DESC;

-- Пользователь, у которого больше всего потерянных открыток
SELECT 
	p.sender AS sender_id,
    u.user_name AS sender,
    u.nickname AS sender_nick,
    COUNT(sender) AS total_lost
FROM postcards p JOIN users u
	ON u.id = p.sender
WHERE card_status = 3
GROUP BY sender
ORDER BY total_lost DESC LIMIT 1;

-- Посты на форуме, где упоминается Alice (filldb сгенерировал много постов с этим именем, показалось инетерсным.....)
SELECT 
	f.forum_text, 
    u.user_name AS author 
FROM forum f JOIN users u
ON u.id = f.author
WHERE forum_text LIKE '%Alice%';

-- Все открытки и их статус, которые отправил или получил конкретный пользователь
SELECT 
	p.id,
	p.sender, 
    p.receiver,
    s.status_name
FROM postcards p JOIN postcard_status s
ON s.id = p.card_status
WHERE (p.sender = 10 OR p.receiver = 10)
ORDER BY status_name;

-- ************************* представления *****************************

-- Подсчёт отправленных открыток пользователей
CREATE OR REPLACE VIEW sent_cards AS	
    SELECT 
		u.user_name, 
		u.nickname, 
		COUNT(p.sender) AS sent_postcards
	FROM users u JOIN postcards p
		ON u.id = p.sender
		GROUP BY p.sender
		ORDER BY sent_postcards DESC;
SELECT * FROM sent_cards;
    
-- Подсчёт полученных открыток пользователей
CREATE OR REPLACE VIEW received_cards AS		
    SELECT 
		u.user_name, 
		u.nickname, 
		COUNT(p.receiver) AS received_postcards
	FROM users u JOIN postcards p
		ON u.id = p.receiver
		GROUP BY p.receiver
		ORDER BY received_postcards DESC;
SELECT * FROM received_cards;
 
-- ************************ хранимые процедуры / триггеры ***********************************

-- Добавление в таблицу logs открыток
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	log_created_at DATETIME NOT NULL,
    log_table_name VARCHAR(255) NOT NULL,
    log_id_key BIGINT(10) NOT NULL,
    log_name VARCHAR(255) NOT NULL
) COMMENT = 'логи', ENGINE=Archive;

DROP TRIGGER IF EXISTS log_cards;
DELIMITER //
CREATE TRIGGER log_cards AFTER INSERT ON postcards
FOR EACH ROW
BEGIN
	INSERT INTO logs (log_created_at, log_table_name, log_id_key, log_name)
	VALUES (NOW(), 'postcard', NEW.id, NEW.card_status, NEW.sender, NEW.receiver);
END //
DELIMITER ;

-- Backup для форума (то вдруг кто-то решит удалить многочисленные посты про какую-то Alice)
DROP TRIGGER IF EXISTS forum_check;
CREATE TABLE forum_backup (
id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
row_id INT(11) UNSIGNED NOT NULL,
content TEXT NOT NULL
) ENGINE = Archive;

DELIMITER //
CREATE TRIGGER update_forum BEFORE UPDATE ON forum
FOR EACH ROW 
BEGIN
	INSERT INTO forum_backup SET row_id = OLD.id, content = OLD.forum_text;
END;

CREATE TRIGGER delete_forum BEFORE DELETE ON forum
FOR EACH ROW 
BEGIN
	INSERT INTO forum_backup SET row_id = OLD.id, content = OLD.forum_text;
END // 
DELIMITER ;
    
    
    