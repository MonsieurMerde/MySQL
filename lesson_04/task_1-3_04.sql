USE vk_db_hw;

DROP TABLE IF EXISTS
media_count_likes,
posts_count_likes,
users_count_likes;

SELECT * FROM users;

UPDATE users SET updated_at = created_at WHERE updated_at < created_at;

SELECT * FROM profiles LIMIT 10;

UPDATE profiles SET photo_id = FLOOR(1 + RAND() * 100);

CREATE TABLE IF NOT EXISTS user_statuses (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT KEY COMMENT "Идентификатор строки",
	name VARCHAR(50) NOT NULL COMMENT "Название статуса (уникально)",
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Таблица статусов";

SELECT * FROM user_statuses;
TRUNCATE user_statuses;
INSERT INTO user_statuses (name) VALUES
('Not chosen'),
('Not married'),
('Difficult'),
('Actively looking'),
('I meet with'),
('Engaged'),
('Married'),
('Civil marriage'),
('In love with');

SELECT * FROM user_statuses;

ALTER TABLE profiles RENAME COLUMN status TO user_status_id;
ALTER TABLE profiles ADD relationships_with INT UNSIGNED;

UPDATE profiles SET user_status_id = FLOOR(1 + RAND() * 9);

UPDATE profiles SET relationships_with = FLOOR(1 + RAND() * 100);
UPDATE profiles SET relationships_with = relationships_with + 1 WHERE user_id = relationships_with;

UPDATE profiles SET relationships_with = NULL WHERE user_status_id < 5;
UPDATE profiles SET relationships_with = NULL ORDER BY RAND() LIMIT 20;

UPDATE messages SET updated_at = created_at WHERE updated_at < created_at;

SELECT * FROM messages;

SELECT * FROM media_types;

TRUNCATE media_types;
INSERT INTO media_types (name) VALUES
('photo'),
('video'),
('audio'),
('file');

SELECT * FROM media;
DESC media;

UPDATE media SET media_type_id = FLOOR(1 + RAND() * 4);
UPDATE media SET user_id = FLOOR(1 + RAND() * 100);

-- Создаём временную таблицу форматов медиафайлов
DROP TEMPORARY TABLE IF EXISTS extensions;
CREATE TEMPORARY TABLE extensions (
	name VARCHAR(10)
);

-- Заполняем значениями
INSERT INTO extensions VALUES
('jpeg'),
('gif'),
('avi'),
('mp3')
;

UPDATE media SET filename = CONCAT(
'http://dropbox.net/vk/',
(SELECT id FROM users WHERE id = user_id),
'/',
filename,
'.',
 (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);

UPDATE media SET size = FLOOR(10000 + RAND() * 1000000) WHERE size < 1000;

UPDATE media set metadata = CONCAT(
'{"owner":"',
(SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
'"}');

ALTER TABLE media MODIFY COLUMN metadata JSON;

RENAME TABLE friendship TO friendships;

UPDATE friendships SET
user_id = FLOOR(1 + RAND() * 100),
friend_id = FLOOR(1 + RAND() * 100);

UPDATE friendships SET requested_at = confirmed_at WHERE requested_at < confirmed_at;
UPDATE friendships SET friend_id = friend_id + 1 WHERE user_id = friend_id;

TRUNCATE friendship_statuses;

INSERT INTO friendship_statuses (name) VALUES
('Requested'),
('Confirmed'),
('Rejected');

ALTER TABLE media_in_posts ADD id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY;
ALTER TABLE media_who_likes ADD id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY;
ALTER TABLE posts_who_likes ADD id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY;
ALTER TABLE users_who_likes ADD id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY;

SELECT * FROM users;
SELECT * FROM profiles;
SELECT * FROM user_statuses;
SELECT * FROM media;
SELECT * FROM media_in_posts;
SELECT * FROM media_types;
SELECT * FROM extensions;
SELECT * FROM friendships;
SELECT * FROM friendship_statuses;
SELECT * FROM communities;
SELECT * FROM communities_users;
SELECT COUNT(*) FROM communities;
UPDATE media SET metadata = "1";
UPDATE media SET filename = "";
