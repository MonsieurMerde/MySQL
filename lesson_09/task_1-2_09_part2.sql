-- Практические задания по теме "Администрирование MySQL" 

-- ПЗ 1. Создайте двух пользователей, которые имеют доступ к базе данных shop. 
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
-- второму пользователю shop — любые операции в пределах базы данных shop.

CREATE USER shop_read;
GRANT SELECT ON *.* TO shop_read;

CREATE USER shop;
GRANT ALL ON shop.* TO shop;


-- ПЗ 2. Пусть имеется таблица accounts, содержащая три столбца id, name, password, содержащие первичный ключ, имя пользователя и его пароль.
-- Создайте представление username таблицы accounts, предоставляющий доступ к столбцам id и name. 
-- Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.

USE test;

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
id SERIAL PRIMARY KEY,
name VARCHAR(255),
password CHAR(12)
);
INSERT INTO accounts (name, password) VALUES
('John', '74238hd656@1'),
('Michael', '131212%efrck'),
('Katherine', 'hsccbR29^5'),
('Dina', 'wqduevfty6u$'),
('Alex', 'dvfrB87!');

CREATE VIEW username AS
SELECT id, name FROM accounts;

CREATE USER user_read;
GRANT SELECT ON username TO user_read;