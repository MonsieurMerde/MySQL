USE vk_db_hw;

-- 2. Создать все необходимые внешние ключи.

UPDATE communities_users SET updated_at = created_at WHERE updated_at < created_at;


UPDATE friendships SET requested_at = created_at WHERE requested_at < created_at;
UPDATE friendships SET confirmed_at = requested_at WHERE confirmed_at < requested_at;


ALTER TABLE media MODIFY COLUMN user_id INT(10) UNSIGNED;
ALTER TABLE media
ADD CONSTRAINT media_user_id_fk
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE SET NULL,
ADD CONSTRAINT media_type_id_fk
FOREIGN KEY (media_type_id) REFERENCES media_types(id)
ON DELETE CASCADE;


ALTER TABLE posts
ADD CONSTRAINT posts_user_id_fk
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE;

UPDATE posts SET updated_at = created_at WHERE updated_at < created_at;


ALTER TABLE media_in_posts
ADD CONSTRAINT media_id_fk
FOREIGN KEY (media_id) REFERENCES media(id)
ON DELETE CASCADE,
ADD CONSTRAINT post_id_fk
FOREIGN KEY (post_id) REFERENCES posts(id)
ON DELETE CASCADE;


ALTER TABLE profiles MODIFY COLUMN user_status_id INT(10) UNSIGNED;

ALTER TABLE profiles
ADD CONSTRAINT profiles_photo_id_fk
FOREIGN KEY (photo_id) REFERENCES media(id)
ON DELETE SET NULL,
ADD CONSTRAINT profiles_user_statuses_id_fk
FOREIGN KEY (user_status_id) REFERENCES user_statuses(id)
ON DELETE SET NULL,
ADD CONSTRAINT profiles_relationships_with_fk
FOREIGN KEY (relationships_with) REFERENCES users(id)
ON DELETE SET NULL;


ALTER TABLE messages
ADD CONSTRAINT messages_from_user_id_fk
FOREIGN KEY (from_user_id) REFERENCES users(id),
ADD CONSTRAINT messages_to_user_id_fk
FOREIGN KEY (to_user_id) REFERENCES users(id);


ALTER TABLE media_who_likes
ADD CONSTRAINT media_who_likes_media_id_fk
FOREIGN KEY (media_id) REFERENCES media(id)
ON DELETE CASCADE,
ADD CONSTRAINT media_who_likes_user_id_fk
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE;

UPDATE media_who_likes SET updated_at = created_at WHERE updated_at < created_at;


ALTER TABLE posts_who_likes
ADD CONSTRAINT posts_who_likes_media_id_fk
FOREIGN KEY (post_id) REFERENCES posts(id)
ON DELETE CASCADE,
ADD CONSTRAINT posts_who_likes_user_id_fk
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE;

UPDATE posts_who_likes SET updated_at = created_at WHERE updated_at < created_at;


ALTER TABLE users_who_likes
ADD CONSTRAINT users_who_likes_user_id_fk
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE,
ADD CONSTRAINT users_who_likes_user_id_who_fk
FOREIGN KEY (user_id_who) REFERENCES users(id)
ON DELETE CASCADE;

UPDATE users_who_likes SET updated_at = created_at WHERE updated_at < created_at;


-- 3. Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

INSERT INTO messages VALUES
(NULL, 52, 2, 'Hello', 1, 1, NOW(), NOW()),
(NULL, 20, 2, 'Wats up?', 0, 1, NOW(), NOW()),
(NULL, 20, 2, 'Fjwerugherughtrughgg dfkgjdfgdfiqyqwteqwyeqw kadjqwu!', 1, 1, NOW(), NOW()),
(NULL, 52, 2, 'Wfqemfnru8vherygtrvbgygty vhfdjdfhvjvhvygv. DcsdjhdhHjdhcsdh!', 0, 1, NOW(), NOW()),
(NULL, 52, 2, 'Fewkfoiweufweuf, Ycygdyvcsvd? Fkbfgklnkryoiweouqwydcv', 1, 1, NOW(), NOW());

SET @selected_user = 2;
SELECT from_user_id AS user_id,
(SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id) AS fullname,
COUNT(*) AS total_messages
FROM messages WHERE to_user_id = @selected_user AND from_user_id IN(
(SELECT friend_id
FROM friendships
WHERE user_id = @selected_user
AND
status_id = (
    SELECT id FROM friendship_statuses WHERE name = 'Confirmed'
  )
)
UNION
(SELECT user_id
FROM friendships
WHERE friend_id = @selected_user
AND
status_id = (
SELECT id FROM friendship_statuses WHERE name = 'Confirmed'
)
)
)
GROUP BY from_user_id
ORDER BY total_messages DESC
LIMIT 1;


-- 5. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

SELECT SUM(likes) AS total_likes FROM (
SELECT user_id, COUNT(*) AS likes,
(SELECT birthday FROM profiles WHERE user_id = users_who_likes.user_id) AS birthday
FROM users_who_likes
GROUP BY user_id
ORDER BY birthday DESC LIMIT 10
) AS likes_10_young_users;


-- 6. Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT gender, MAX(likes) as total_likes FROM ( 
SELECT gender, COUNT(*) as likes FROM (
SELECT user_id,
(SELECT gender FROM profiles WHERE user_id = users_who_likes.user_id) AS gender
FROM users_who_likes
) AS gender_of_users_who_likes
GROUP BY gender  
) AS total_likes_gender


-- 7. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

(SELECT id as user_id,
CONCAT(first_name, ' ', last_name) as fullname
FROM users
WHERE id NOT IN
(SELECT from_user_id FROM messages
GROUP BY from_user_id)
)
UNION
(
(SELECT user_id, fullname FROM (
SELECT from_user_id as user_id,
(SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = messages.from_user_id) as fullname,
COUNT(*) as total_messages FROM messages
GROUP BY from_user_id
ORDER BY total_messages) as activity_users)
)
LIMIT 10;

-- Вариант 2 с выводом количества сообщений (костыль в виде IF)

(SELECT id as user_id,
CONCAT(first_name, ' ', last_name) as fullname,
IF (TRUE, 0, 0) as total_messages
FROM users
WHERE id NOT IN
(SELECT from_user_id FROM messages
GROUP BY from_user_id)
)
UNION
(
SELECT from_user_id as user_id,
(SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = messages.from_user_id) as fullname,
COUNT(*) as total_messages FROM messages
GROUP BY from_user_id
ORDER BY total_messages
)