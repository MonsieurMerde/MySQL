-- Практические задания по теме "Транзакции, переменные, представления"

-- ПЗ 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION;
INSERT INTO sample.users SELECT shop.users.id, shop.users.name FROM shop.users WHERE id = 1;
DELETE FROM shop.users WHERE id = 1;
COMMIT; 


-- ПЗ 2. Создайте представление, которое выводит название name товарной позиции из таблицы products
-- и соответствующее название каталога name из таблицы catalogs.

CREATE VIEW cat (name_products, name_catalogs)
AS SELECT products.name, catalogs.name FROM products
LEFT JOIN catalogs
ON products.catalog_id = catalogs.id


-- ПЗ 3. Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август 2018 года 
-- '2018-08-01', '2016-08-04', '2018-08-16' и '2018-08-17'. Составьте запрос, который выводит  полный список дат за август, 
-- выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице, и 0, если она отсутствует.

USE test;

DROP TEMPORARY TABLE IF EXISTS task_3_09_table;
CREATE TEMPORARY TABLE task_3_09_table (
created_at DATE
);

INSERT INTO task_3_09_table VALUES
('2018-08-01'),
('2018-08-04'),
('2018-08-16'),
('2018-08-17');

SELECT *,
(SELECT EXISTS(SELECT * FROM task_3_09_table WHERE task_3_09_table.created_at = august.dates_in_month)) AS exist
FROM
(
	SELECT * FROM
	(  
		SELECT ADDDATE('2018-08-01', tens.i*10 + units.i) AS dates_in_month FROM
			(SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS units,
			(SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) AS tens
	) AS dates
WHERE dates_in_month < '2018-09-01'
ORDER BY dates_in_month
) AS august


-- ПЗ 4. Пусть имеется любая таблица с календарным полем created_at.
-- Создайте запрос, который удаляет устаревшие записи из таблицы,оставляя только 5 самых свежих записей.

USE test;

DROP TEMPORARY TABLE IF EXISTS task_4_09_table;
CREATE TEMPORARY TABLE task_4_09_table (
created_at DATE
);

INSERT INTO task_4_09_table VALUES
('2018-08-09'),
('2012-08-04'),
('2015-08-02'),
('2014-08-23'),
('2018-08-16'),
('2000-08-17'),
('2022-01-15');

PREPARE del FROM 'DELETE FROM task_4_09_table ORDER BY created_at LIMIT ?';
SET @count = (SELECT COUNT(created_at)-5 FROM task_4_09_table);
EXECUTE del USING @count;