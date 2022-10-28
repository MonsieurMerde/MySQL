-- Наполнение БД данными вручную

USE metal_archives;

INSERT INTO formats_albums (format) VALUES
('CD'),
('Cassette'),
('Vinyl'),
('VHS'),
('DVD'),
('Digital'),
('Blue-ray'),
('Other');

INSERT INTO types_albums (type) VALUES
('Demo'),
('Single'),
('EP'),
('Split'),
('Collaboration'),
('Full-length'),
('Compilation'),
('Boxed set'),
('Video'),
('Split video'),
('Live album');

INSERT INTO categories_albums (category) VALUES
('Main'),
('Lives'),
('Demos'),
('Misc.');

INSERT INTO statuses_bands (status) VALUES
('Active'),
('Unknown'),
('Disputed'),
('On hold'),
('Changed name'),
('Split-up');

INSERT INTO statuses_labels (status) VALUES
('active'),
('closed'),
('unknown'),
('changed name');

INSERT INTO categories_types_albums (category_id, type_id) VALUES
(1, 6),
(2, 9),
(2, 11),
(3, 1),
(4, 2),
(4, 3),
(4, 4),
(4, 5),
(4, 7),
(4, 8),
(4, 9);