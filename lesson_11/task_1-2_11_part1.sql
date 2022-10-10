-- Практические задания по теме "Оптимизация запросов"

-- ПЗ 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products 
-- в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

USE shop;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  created_at DATETIME,
  table_name VARCHAR(255),
  id BIGINT(20),
  name VARCHAR(255)
) ENGINE = ARCHIVE;

DROP TRIGGER IF EXISTS log_users;

DELIMITER //

CREATE TRIGGER log_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
  INSERT INTO logs VALUES (NOW(), 'users', NEW.id, NEW.name);
END//

DELIMITER ;

INSERT INTO products (name, birthday_at) VALUES
  ('Виктор', '1974-01-22');

SELECT * FROM logs;

DROP TRIGGER IF EXISTS log_catalogs;

DELIMITER //

CREATE TRIGGER log_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
  INSERT INTO logs VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END//

DELIMITER ;

INSERT INTO catalogs (name)
  VALUES ('Мониторы');

SELECT * FROM logs;

DROP TRIGGER IF EXISTS log_products;

DELIMITER //

CREATE TRIGGER log_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
  INSERT INTO logs VALUES (NOW(), 'products', NEW.id, NEW.name);
END//

DELIMITER ;

INSERT INTO products (name, description, price, catalog_id)
  VALUES ('AOC E970SWN 18.5"', 'Монитор черный 18.5", 1366x768@60 Гц, TN, 5 мс, 700 : 1, 200 Кд/м², 90°/65°, VGA (D-Sub)', 7599.00, 4);
  
SELECT * FROM logs;

-- ПЗ 2. Создайте SQL-запрос, который помещает в таблицу users миллион записей.

-- Вариант 1.

USE test;

DROP TABLE IF EXISTS users;

CREATE TABLE users AS
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 1000
)
SELECT CONCAT('user_', table_1.n) AS name FROM cte table_1
JOIN
cte table_2;

SELECT COUNT(*) AS total_users FROM users;

SELECT * FROM users;

-- Вариант 2 (с уникальными именами пользователей).

SET SESSION cte_max_recursion_depth = 1000000;

USE test;

DROP TABLE IF EXISTS users;

CREATE TABLE users AS
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte
  LIMIT 1000000
)
SELECT CONCAT('user_', table_1.n) AS name FROM cte table_1;

SELECT COUNT(*) AS total_users FROM users;