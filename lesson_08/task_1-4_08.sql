-- Переписать запросы, заданые к ДЗ урока 6, с использованием JOIN.

-- 1. Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

USE vk_db_hw;

SELECT friends.first_name, friends.last_name, COUNT(*) AS messages_total FROM users
JOIN friendships
	ON
	(friendships.user_id = users.id OR friendships.friend_id = users.id)
    AND
    users.id = 2
JOIN users AS friends ON friendships.friend_id = friends.id
JOIN friendships_statuses
	ON
	friendships_statuses.id = friendships.status_id
    AND
	friendships_statuses.name = 'Confirmed'
JOIN messages
	ON
	(messages.from_user_id = friendships.user_id AND messages.to_user_id = friendships.friend_id)
    OR
    (messages.from_user_id = friendships.friend_id AND messages.to_user_id = friendships.user_id)
GROUP BY friends.id
ORDER BY messages_total DESC
LIMIT 1;


-- 2. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

USE vk_db_hw;

SELECT SUM(likes_total) AS likes_total FROM
(SELECT users_who_likes.user_id, profiles.birthday, COUNT(*) AS likes_total FROM users_who_likes
JOIN profiles ON users_who_likes.user_id = profiles.user_id
GROUP BY users_who_likes.user_id
ORDER BY birthday DESC LIMIT 10) AS likes_10_youngest_users;


-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?

USE vk_db_hw;

-- Вариант 1.

SELECT gender, SUM(likes_total) AS gender_likes_total FROM
(
	(SELECT profiles.gender, COUNT(*) AS likes_total FROM profiles
	JOIN media_who_likes ON media_who_likes.user_id = profiles.user_id
	GROUP BY gender
	ORDER BY likes_total)
	UNION ALL
	(SELECT profiles.gender, COUNT(*) AS likes_total_posts FROM profiles
	JOIN posts_who_likes ON posts_who_likes.user_id = profiles.user_id
	GROUP BY gender
	ORDER BY likes_total_posts)
	UNION ALL
	(SELECT profiles.gender, COUNT(*) AS likes_total_users FROM profiles
	JOIN users_who_likes ON users_who_likes.user_id_who = profiles.user_id
	GROUP BY gender
	ORDER BY likes_total_users)
) AS likes_total_all
GROUP BY gender
ORDER BY gender_likes_total DESC
LIMIT 1;

-- Вариант 2.

SELECT gender_likes_total_media.gender,
	gender_likes_total_media.likes_total_media
    +
    gender_likes_total_posts.likes_total_posts
    +
    gender_likes_total_users.likes_total_users
    AS likes_total_all
FROM
	(SELECT profiles.gender, COUNT(*) AS likes_total_media FROM profiles
	JOIN media_who_likes ON media_who_likes.user_id = profiles.user_id
	GROUP BY gender
	ORDER BY likes_total_media) AS gender_likes_total_media
JOIN
	(SELECT profiles.gender, COUNT(*) AS likes_total_posts FROM profiles
	JOIN posts_who_likes ON posts_who_likes.user_id = profiles.user_id
	GROUP BY gender
	ORDER BY likes_total_posts) AS gender_likes_total_posts
ON gender_likes_total_media.gender = gender_likes_total_posts.gender
JOIN
	(SELECT profiles.gender, COUNT(*) AS likes_total_users FROM profiles
	JOIN users_who_likes ON users_who_likes.user_id_who = profiles.user_id
	GROUP BY gender
	ORDER BY likes_total_users) AS gender_likes_total_users
ON gender_likes_total_media.gender = gender_likes_total_users.gender;


-- 4. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

USE vk_db_hw;

SELECT user_id, SUM(activity) AS activity_overall FROM
(
	(SELECT
		users.id AS user_id,
		COUNT(messages.from_user_id) AS activity
		FROM users
	LEFT JOIN messages ON users.id = messages.from_user_id
	GROUP BY users.id)
	UNION ALL
	(SELECT
		users.id,
		COUNT(media.user_id) AS media_total
		FROM users
	LEFT JOIN media ON users.id = media.user_id
	GROUP BY users.id)
	UNION ALL
	(SELECT
		users.id,
		COUNT(posts.user_id) AS posts_total
		FROM users
	LEFT JOIN posts ON users.id = posts.user_id
	GROUP BY users.id)
	UNION ALL
	(SELECT
		users.id,
		COUNT(media_who_likes.user_id) AS media_who_likes_total
		FROM users
	LEFT JOIN media_who_likes ON users.id = media_who_likes.user_id
	GROUP BY users.id)
	UNION ALL
	(SELECT
		users.id,
		COUNT(posts_who_likes.user_id) AS posts_who_likes_total
		FROM users
	LEFT JOIN posts_who_likes ON users.id = posts_who_likes.user_id
	GROUP BY users.id)
	UNION ALL
	(SELECT
		users.id,
		COUNT(users_who_likes.user_id_who) AS users_who_likes_total
		FROM users
	LEFT JOIN users_who_likes ON users.id = users_who_likes.user_id_who
	GROUP BY users.id)
) AS activity_overall
GROUP BY user_id
ORDER BY activity_overall LIMIT 10;