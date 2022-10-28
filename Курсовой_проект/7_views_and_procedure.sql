-- Представление, в котором хранятся группы, которые поменяли название, и годы их ативности.

CREATE OR REPLACE VIEW bands_changed_name AS
SELECT band_name, years_active
FROM bands
WHERE status_band_id = (
  SELECT id FROM statuses_bands WHERE status = 'Changed name'
)
ORDER BY band_name;

-- Представление, в котором хранятся лейблы из Гваделупы, и их год основания.

CREATE OR REPLACE VIEW labels_guadeloupe AS
SELECT label_name, founding_date
FROM labels
WHERE country_id = (
  SELECT id FROM countries WHERE country = 'Guadeloupe'
)
ORDER BY founding_date;

-- Процедура, которая подсчитывает количество стран (не учитывая N/A).

DROP PROCEDURE IF EXISTS num_countries;

DELIMITER //

CREATE PROCEDURE num_countries (OUT total INT)
BEGIN
  SELECT COUNT(*) INTO total FROM countries WHERE country != 'N/A';
END//

DELIMITER ;

CALL num_countries(@a);
SELECT @a AS number_of_countries;