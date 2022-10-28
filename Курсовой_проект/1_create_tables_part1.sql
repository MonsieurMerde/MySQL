DROP DATABASE IF EXISTS metal_archives;
CREATE DATABASE metal_archives;
USE metal_archives;

-- Таблицы без связей

-- Таблицы, относящиеся к группам и лейблам

DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
  id SERIAL PRIMARY KEY,
  country VARCHAR(50) NOT NULL UNIQUE COMMENT 'Название страны',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT = 'Страны';

-- Таблицы, относящиеся к группам

DROP TABLE IF EXISTS statuses_bands;
CREATE TABLE statuses_bands (
  id SERIAL PRIMARY KEY,
  status VARCHAR(50) NOT NULL UNIQUE COMMENT 'Статус группы',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT = 'Статусы групп';

DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
  id SERIAL PRIMARY KEY,
  genre VARCHAR(100) NOT NULL UNIQUE COMMENT 'Жанр',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT = 'Жанры, в которых играют группы';

DROP TABLE IF EXISTS lyrical_themes;
CREATE TABLE lyrical_themes (
  id SERIAL PRIMARY KEY,
  lyrical_theme VARCHAR(100) NOT NULL UNIQUE COMMENT 'Тематика текстов песен',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT = 'Тематика текстов песен у групп';

-- Таблицы, относящиеся к альбомам

DROP TABLE IF EXISTS types_albums;
CREATE TABLE types_albums (
  id SERIAL PRIMARY KEY,
  type VARCHAR(50) NOT NULL UNIQUE COMMENT 'Тип альбома',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT = 'Типы альбомов';

DROP TABLE IF EXISTS categories_albums;
CREATE TABLE categories_albums (
  id SERIAL PRIMARY KEY,
  category VARCHAR(50) NOT NULL UNIQUE COMMENT 'Категория альбома',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT = 'Категории альбомов';

DROP TABLE IF EXISTS formats_albums;
CREATE TABLE formats_albums (
  id SERIAL PRIMARY KEY,
  format VARCHAR(50) NOT NULL UNIQUE COMMENT 'Формат издания альбома',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT = 'Форматы изданий альбомов';

-- Таблицы, относящиеся к лейблам

DROP TABLE IF EXISTS statuses_labels;
CREATE TABLE statuses_labels (
  id SERIAL PRIMARY KEY,
  status VARCHAR(50) NOT NULL UNIQUE COMMENT 'Статус лейбла',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT = 'Статусы лейблов';

DROP TABLE IF EXISTS styles;
CREATE TABLE styles (
  id SERIAL PRIMARY KEY,
  style VARCHAR(100) NOT NULL UNIQUE COMMENT 'Стили или стиль, на котором специализируется лейбл',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT = 'Стили, на которых специализируются лейблы';