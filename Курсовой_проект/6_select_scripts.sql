-- Вывод групп, в названии которых есть какое-то слово.

SELECT bands.band_name, genres.genre, countries.country FROM bands
LEFT JOIN bands_genres
ON bands.id = bands_genres.band_id
LEFT JOIN genres
ON genres.id = bands_genres.genre_id
LEFT JOIN countries
ON bands.country_id = countries.id
WHERE bands.band_name LIKE '%sons%'
ORDER BY bands.band_name, countries.country;

-- Вывод профиля группы.

SELECT * FROM bands;

SELECT
 bands.band_name, 
 countries.country, 
 locations_early.location AS location_early, 
 locations_later.location AS location_later,
 statuses_bands.status,
 formed_in,
 years_active,
 genres.genre,
 lyrical_themes.lyrical_theme,
 current_labels.label_name AS current_label,
 last_labels.label_name AS last_label,
 band_image_link,
 bands.logo_image_link
FROM
 bands
LEFT JOIN countries
ON bands.country_id = countries.id
LEFT JOIN locations AS locations_early
ON bands.location_early_id = locations_early.id
LEFT JOIN locations AS locations_later
ON bands.location_later_id = locations_later.id
LEFT JOIN statuses_bands
ON 
bands.status_band_id = statuses_bands.id
LEFT JOIN bands_genres
ON bands.id = bands_genres.band_id
LEFT JOIN genres
ON genres.id = bands_genres.genre_id
LEFT JOIN bands_lyrical_themes
ON bands.id = bands_lyrical_themes.band_id
LEFT JOIN lyrical_themes
ON lyrical_themes.id = bands_lyrical_themes.lyrical_theme_id
LEFT JOIN labels AS current_labels
ON bands.current_label_id = current_labels.id
LEFT JOIN labels AS last_labels
ON bands.last_label_id = last_labels.id
WHERE band_name = 'Moore!';

-- Вывод групп, которые уже не подписаны на лейбле, но которые раньше издавали на нём свои альбомы,
-- и вывод количества изданных на этом лейбле альбомов.

SET @change_label = 'Quo';

SELECT band_name, genres.genre, countries.country, COUNT(*) AS number_of_albums_released FROM bands
JOIN bands_albums
ON bands_albums.band_id = bands.id
JOIN albums
ON bands_albums.album_id = albums.id
LEFT JOIN bands_genres
ON bands.id = bands_genres.band_id
LEFT JOIN genres
ON genres.id = bands_genres.genre_id
LEFT JOIN countries
ON bands.country_id = countries.id
WHERE
  albums.label_id = (
    SELECT id FROM labels WHERE label_name = @change_label
  )
AND
  bands.current_label_id != (
    SELECT id FROM labels WHERE labels.label_name = @change_label
  )
GROUP BY albums.id;