USE shop;

-- Практическое задание по теме "Операторы, фильтрация, сортировка и ограничение"

-- Задание 1
UPDATE users SET created_at = NOW(), updated_at = NOW();

-- Задание 2
UPDATE users SET 
created_at = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i'),
updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');

ALTER TABLE users MODIFY COLUMN created_at DATETIME, MODIFY COLUMN updated_at DATETIME;

-- Задание 3
SELECT * FROM storehouses_products ORDER BY value = 0, value;

-- Задание 4
SELECT name, birthday_at FROM users
WHERE
DATE_FORMAT(birthday_at, '%M') = 'may'
OR
DATE_FORMAT(birthday_at, '%M') = 'august';

-- Задание 5
SELECT * FROM catalogs ORDER BY FIELD(id,'2','1','5') DESC LIMIT 3;


-- Практическое задание по теме "Агрегация данных"

-- Задание 1
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS average_age FROM users;

-- Задание 2
SELECT COUNT(*) as total,
DATE_FORMAT(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at)), '%W') AS weekday
FROM users
GROUP BY weekday;

-- Задание 3 
SELECT ROUND(exp(SUM(ln(value))), 0) as multiplication_value FROM storehouses_products;