-- Практические задания по теме "Хранимые процедуры и функции, триггеры"

-- ПЗ 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", 
-- с 00:00 до 6:00 — "Доброй ночи".

DROP FUNCTION IF EXISTS hello;

DELIMITER //

CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
  DECLARE hour INT;
  SET hour = HOUR(NOW());
  CASE
  WHEN (hour > 6) AND (hour <= 12) THEN
    RETURN "Доброе утро";
  WHEN (hour > 12) AND (hour <= 18) THEN
    RETURN "Добрый день";
  WHEN (hour > 18) OR (hour = 0) THEN
    RETURN "Добрый вечер";
  ELSE
    RETURN "Доброй ночи";
  END CASE;
END//

DELIMITER ;

SELECT hello();


-- ПЗ 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL, неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

USE shop;

DROP TRIGGER IF EXISTS check_name_and_description_update;

DELIMITER //

CREATE TRIGGER check_name_and_description_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  IF (NEW.name IS NULL) AND (NEW.description IS NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "One of 'name' or 'description' must be NULL";
  END IF;
END//

DELIMITER ;

UPDATE products SET name = NULL, description = NULL;


-- ПЗ 3. Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. Числами Фибоначчи называется последовательность, 
-- в которой число равно сумме двух предыдущих чисел. Вызов функции FIBONACCI(10) должен возвращать число 55.

DROP FUNCTION IF EXISTS FIBONACCI;

DELIMITER //

CREATE FUNCTION FIBONACCI(fn INT)
RETURNS INT DETERMINISTIC
BEGIN
  DECLARE i, sum INT DEFAULT 0;
  DECLARE j INT DEFAULT 1;
  IF (fn = 0) THEN
    RETURN 0;
  ELSEIF (fn = 1) THEN
    RETURN 1;
  ELSE
    WHILE fn > 1 DO
      SET sum = i + j;
      SET i = j;
      SET j = sum;
      SET fn = fn - 1;
    END WHILE;
    RETURN sum;
  END IF;
END//

DELIMITER ;

SELECT FIBONACCI(10);