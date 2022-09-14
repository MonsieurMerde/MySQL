SELECT * FROM catalogs;
DESC orders;

-- ПЗ 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет-магазине.

USE shop;

INSERT INTO orders(id, user_id) VALUES
  (NULL, NULL),
  (NULL, NULL),
  (NULL, NULL),
  (NULL, NULL),
  (NULL, NULL),
  (NULL, NULL),
  (NULL, NULL),
  (NULL, NULL),
  (NULL, NULL),  
  (NULL, NULL),  
  (NULL, NULL);
  
UPDATE orders SET user_id = FLOOR(1 + RAND() * 6);

SELECT name FROM users
WHERE id IN (SELECT user_id FROM orders);


-- ПЗ 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

USE shop; 

SELECT products.name,
(SELECT catalogs.name FROM catalogs WHERE id = catalog_id) AS 'catalog_name'
FROM products;


-- ПЗ 3. Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское.
-- Выведите список рейсов flights с русскими названиями городов. 


DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(255) COMMENT 'Город вылета',
  `to` VARCHAR(255) COMMENT 'Город прилета'
  ) COMMENT = 'Таблица рейсов';
  
  INSERT INTO flights VALUES
  (NULL, 'moscow', 'omsk'),
  (NULL, 'novgorod', 'kazan'),
  (NULL, 'irkutsk', 'moscow'),
  (NULL, 'omsk', 'irkutsk'),
  (NULL, 'moscow', 'kazan');
  
SELECT * FROM flights;
  
DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  `label` VARCHAR(255) COMMENT 'Город',
  `name` VARCHAR(255) COMMENT 'Город (русское название)'
  ) COMMENT = 'Таблица городов';
  
  INSERT INTO cities VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');
  
SELECT id,
(SELECT name FROM cities WHERE label = `from`) AS `from`,
(SELECT name FROM cities WHERE label = `to`) AS `to`
FROM flights;