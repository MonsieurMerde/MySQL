-- С использованием JOIN

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

SELECT users.name FROM users
JOIN orders
ON users.id = orders.user_id
GROUP BY users.name;


-- ПЗ 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

USE shop;

SELECT products.name, catalogs.name AS catalog_name FROM products
JOIN catalogs
ON products.catalog_id = catalogs.id;


-- ПЗ 3. Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское.
-- Выведите список рейсов flights с русскими названиями городов.

USE shop; 

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

UPDATE flights
JOIN cities AS cities_from
ON flights.from = cities_from.label
JOIN cities AS cities_to
ON flights.to = cities_to.label
SET
flights.from = cities_from.name,
flights.to = cities_to.name;