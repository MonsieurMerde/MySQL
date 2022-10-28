USE metal_archives;

-- Таблицы со связями

DROP TABLE IF EXISTS locations;
CREATE TABLE locations (
  id SERIAL PRIMARY KEY,
  country_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу стран',
  location VARCHAR(50) NOT NULL COMMENT 'Название местонахождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT = 'Места';

DROP TABLE IF EXISTS labels;
CREATE TABLE labels (
  id SERIAL PRIMARY KEY,
  country_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу стран',
  status_label_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу статусов лейблов',
  label_name VARCHAR(100) COMMENT 'Название лейбла',
  adress VARCHAR(50) COMMENT 'Почтовый адрес',
  email VARCHAR(50) COMMENT 'Электронный адрес',
  phone VARCHAR(50) COMMENT 'Телефон',
  founding_date VARCHAR(4) COMMENT 'Год основания',
  notes TEXT COMMENT 'Заметки о лейбле',
  online_shopping VARCHAR(5) COMMENT 'Наличие интернет-магазина',
  website_link VARCHAR(255) COMMENT 'Ссылка на сайт лейбла',
  logo_image_link VARCHAR(255) COMMENT 'Ссылка на изображение логотипа лейбла',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (status_label_id) REFERENCES statuses_labels(id) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT = 'Лейблы';

DROP TABLE IF EXISTS labels_styles;
CREATE TABLE labels_styles (
  label_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу лейблов',
  style_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу стилей',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  FOREIGN KEY (label_id) REFERENCES labels(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (style_id) REFERENCES styles(id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (label_id, style_id)
) COMMENT = 'На каких стилях специализируются лейблы';

DROP TABLE IF EXISTS bands;
CREATE TABLE bands (
  id SERIAL PRIMARY KEY,
  country_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу стран',
  location_early_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу мест (бывшее местоположение)',
  location_later_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу мест (текущее местоположение)',
  status_band_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу статусов групп',
  current_label_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу лейблов',
  last_label_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу лейблов (последний лейбл до того, как группа распалась)',
  band_name VARCHAR(100) NOT NULL COMMENT 'Название группы',
  years_active VARCHAR(50) COMMENT 'Годы активной деятельности группы',
  formed_in VARCHAR(5) COMMENT 'Год основания',
  band_image_link VARCHAR(255) COMMENT 'Ссылка на изображение группы',
  logo_image_link VARCHAR(255) COMMENT 'Ссылка на изображение логотипа группы',
  notes TEXT COMMENT 'Заметки о группе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE SET NULL,
  FOREIGN KEY (location_early_id) REFERENCES locations(id) ON DELETE SET NULL,
  FOREIGN KEY (location_later_id) REFERENCES locations(id) ON DELETE SET NULL,
  FOREIGN KEY (status_band_id) REFERENCES statuses_bands(id) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (current_label_id) REFERENCES labels(id) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT = 'Группы';

DROP TABLE IF EXISTS bands_genres;
CREATE TABLE bands_genres (
  band_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу групп',
  genre_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу жанров',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  FOREIGN KEY (band_id) REFERENCES bands(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (genre_id) REFERENCES genres(id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (band_id, genre_id)
) COMMENT = 'В каких жанрах играют группы';

DROP TABLE IF EXISTS bands_lyrical_themes;
CREATE TABLE bands_lyrical_themes (
  band_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу групп',
  lyrical_theme_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу тематик текстов песен',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  FOREIGN KEY (band_id) REFERENCES bands(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (lyrical_theme_id) REFERENCES lyrical_themes(id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (band_id, lyrical_theme_id)
) COMMENT = 'Какая тематика текстов у групп';

DROP TABLE IF EXISTS albums;
CREATE TABLE albums (
  id SERIAL PRIMARY KEY,
  type_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу типов альбомов',
  label_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу лейблов',
  format_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу форматов альбомов',
  title VARCHAR(100) COMMENT 'Название альбома',
  release_date VARCHAR(25) COMMENT 'Дата релиза',
  catalog_label_number VARCHAR(25) COMMENT 'Номер альбома в каталоге лейбла',
  `description` VARCHAR(50) COMMENT 'Особенности издания',
  limitation VARCHAR(20) COMMENT 'Количество изданных копий (если альбом выпущен лимитированным тиражом)',
  album_image_link VARCHAR(255) COMMENT 'Ссылка на изображение обложки альбома',
  reviews_count INT UNSIGNED COMMENT 'Количество рецензий',
  reviews_avg_rating INT UNSIGNED COMMENT 'Средняя оценка альбома',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  FOREIGN KEY (type_id) REFERENCES types_albums(id) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (label_id) REFERENCES labels(id) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (format_id) REFERENCES formats_albums(id) ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT = 'Альбомы';

DROP TABLE IF EXISTS bands_albums;
CREATE TABLE bands_albums(
  band_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу групп',
  album_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу альбомов',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  FOREIGN KEY (band_id) REFERENCES bands(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (album_id) REFERENCES albums(id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (band_id, album_id)
) COMMENT = 'Какие альбомы записали группы';

DROP TABLE IF EXISTS categories_types_albums;
CREATE TABLE categories_types_albums (
category_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу категорий альбомов',
type_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу типов альбомов',
FOREIGN KEY (category_id) REFERENCES categories_albums(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (type_id) REFERENCES types_albums(id) ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY (category_id, type_id)
) COMMENT = 'К какой категории относятся типы альбомов';

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
id SERIAL PRIMARY KEY,
album_id BIGINT UNSIGNED COMMENT 'Внешний ключ на таблицу альбомов',
grade INT UNSIGNED COMMENT 'Оценка (от 0 до 100)',
review TEXT COMMENT 'Рецензия',
FOREIGN KEY (album_id) REFERENCES albums(id) ON DELETE CASCADE ON UPDATE CASCADE
) COMMENT = 'Рецензии на альбомы (с оценками)';