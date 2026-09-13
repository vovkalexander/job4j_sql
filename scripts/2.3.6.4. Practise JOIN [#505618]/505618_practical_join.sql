-- вывести кузова, которые не используются ни в одной машине.
SELECT * FROM car_bodies AS cb
LEFT OUTER JOIN cars AS c
on cb.id = c.body_id
WHERE c.body_id IS NULL;

-- вывести двигатели, которые не используются ни в одной машине.
SELECT ce.id, ce.name FROM car_engines AS ce
LEFT OUTER JOIN cars AS c
ON ce.id = c.engine_id
WHERE c.engine_id IS NULL;

-- вывести коробки передач, которые не используются ни в одной машине.
SELECT ct.id, ct.name FROM car_transmissions AS ct
LEFT OUTER JOIN cars AS c
ON ct.id = c.transmission_id
WHERE c.transmission_id IS NULL;

-- вывести список всех машин и название кузова, если оно указано.
SELECT  c.id, c.name, cb.name FROM cars AS c
LEFT OUTER JOIN car_bodies  AS cb
ON  c.body_id = cb.id;

-- вывести только те машины, у которых одновременно указаны (кузов, двигатель, коробка передач)
SELECT c.id, c.name AS car_name, cb.name AS body_name, ce.name AS engine_name,
ct.name AS transmission_name  FROM cars AS c
INNER JOIN car_bodies AS cb
ON c.body_id = cb.id
INNER JOIN car_engines AS ce
ON c.engine_id = ce.id
INNER JOIN car_transmissions AS ct
ON c.transmission_id = ct.id;

-- вывести машины, у которых есть двигатель, но нет кузова.
SELECT c.id, c.name AS car_name, cb.name AS boby_name, ce.name AS engine_name FROM cars AS c
INNER JOIN car_engines AS ce
ON c.engine_id = ce.id
LEFT OUTER JOIN car_bodies AS cb
ON c.body_id = cb.id
WHERE cb.id IS NULL;

-- вывести все кузова и машины, которые их используют.
SELECT cb.id AS body_id, cb.name AS body_name, c.id AS car_id,
c.name AS car_name FROM car_bodies AS cb
LEFT OUTER JOIN cars AS c
ON cb.id = c.engine_id;

-- вывести неиспользуемые двигатели.
SELECT ce.id, ce.name FROM  car_engines AS ce
LEFT OUTER JOIN cars AS c
ON ce.id = c.engine_id
WHERE c.id IS NULL
ORDER BY ce.id;

-- вывести машины и все их детали, но только для машин с автоматической коробкой передач.
SELECT c.id, c.name AS car_name, cb.name AS body_name, ce.name AS engine_name,
ct.name AS transmission_name FROM cars AS c
INNER JOIN car_transmissions AS ct
ON c.transmission_id = ct.id
LEFT OUTER JOIN car_bodies AS cb
ON c.body_id = cb.id
LEFT OUTER JOIN car_engines AS ce
ON c.engine_id = ce.id
where ct.name LIKE 'automatic%';

-- вывести машины, у которых отсутствует хотя бы одна деталь.
SELECT c.id, c.name AS car_name, cb.name AS body_name,
ce.name AS engine_name, ct.name AS transmission_name  FROM cars AS c
LEFT OUTER JOIN car_bodies AS cb
ON c.body_id = cb.id
LEFT OUTER JOIN car_engines AS ce
ON c.engine_id = ce.id
LEFT OUTER JOIN car_transmissions AS ct
ON c.transmission_id = ct.id
WHERE cb.id IS NULL
OR ce.id IS NULL
OR ct.id IS NULL;

-- вывести все машины с двигателями, но коробку передач подключить так, чтобы машины без коробки тоже попали в результат.
SELECT c.id, c.name AS car_name, ce.name AS engine_name,
ct.name AS transmission_name FROM cars AS c
INNER JOIN car_engines AS ce
ON c.engine_id = ce.id
LEFT OUTER JOIN car_transmissions AS ct
ON c.transmission_id = ct.id;

-- вывести все неиспользуемые детали в едином формате.

SELECT CASE
        WHEN cb.id IS NOT NULL THEN 'body'
        WHEN ce.id IS NOT NULL THEN 'engine'
        WHEN ct.id IS NOT NULL THEN 'transmission'
        END AS detail_type,
        CASE
        WHEN cb.id IS NOT NULL THEN cb.id
        WHEN ce.id IS NOT NULL THEN ce.id
        WHEN ct.id IS NOT NULL THEN ct.id
        END AS detail_id,
		CASE
        WHEN cb.id IS NOT NULL THEN cb.name
        WHEN ce.id IS NOT NULL THEN ce.name
        WHEN ct.id IS NOT NULL THEN ct.name
       END AS detail_name
	   FROM cars AS c
FULL JOIN car_bodies AS cb
ON c.body_id = cb.id
FULL JOIN car_engines AS ce
ON c.engine_id = ce.id
FULL JOIN car_transmissions AS ct
ON c.transmission_id = ct.id
WHERE c.id IS NULL;

-- вывести машины и детали только для кузовов определенных типов.
SELECT c.id, c.name, cb.name, ce.name,
ct.name FROM cars AS c
INNER JOIN car_bodies AS cb
ON c.body_id = cb.id
LEFT OUTER JOIN car_engines AS ce
ON c.engine_id = ce.id
LEFT OUTER JOIN car_transmissions AS ct
ON c.transmission_id = ct.id
WHERE cb.name IN ('sedan', 'hatchback', 'suv');



DROP TABLE IF EXISTS cars;
DROP TABLE IF EXISTS car_bodies;
DROP TABLE IF EXISTS car_engines;
DROP TABLE IF EXISTS car_transmissions;

CREATE TABLE car_bodies (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE car_engines (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE car_transmissions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE cars (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    body_id BIGINT REFERENCES car_bodies(id),
    engine_id BIGINT REFERENCES car_engines(id),
    transmission_id BIGINT REFERENCES car_transmissions(id)
);


INSERT INTO car_bodies (name)
VALUES
    ('sedan'),
    ('hatchback'),
    ('wagon'),
    ('coupe'),
    ('crossover'),
    ('suv'),
    ('pickup'),
    ('minivan'),
    ('roadster'),
    ('liftback');

INSERT INTO car_engines (name)
VALUES
    ('1.6 gasoline'),
    ('2.0 gasoline'),
    ('2.5 gasoline'),
    ('3.0 gasoline'),
    ('1.9 diesel'),
    ('2.0 diesel'),
    ('3.0 diesel'),
    ('hybrid'),
    ('electric'),
    ('v8 gasoline');

INSERT INTO car_transmissions (name)
VALUES
    ('manual 5-speed'),
    ('manual 6-speed'),
    ('automatic 6-speed'),
    ('automatic 8-speed'),
    ('robotic'),
    ('cvt'),
    ('dual clutch'),
    ('single-speed electric');

INSERT INTO cars (name, body_id, engine_id, transmission_id)
VALUES
    ('Toyota Corolla', 1, 1, 3),
    ('Toyota Camry', 1, 2, 4),
    ('Volkswagen Golf', 2, 1, 2),
    ('Skoda Octavia', 10, 2, 4),
    ('BMW 3 Series', 1, 3, 4),
    ('BMW X5', 6, 7, 4),
    ('Audi A4', 1, 2, 7),
    ('Audi Q5', 5, 6, 7),
    ('Mercedes C-Class', 1, 2, 4),
    ('Mercedes GLE', 6, 7, 4),
    ('Tesla Model 3', 1, 9, 8),
    ('Tesla Model Y', 5, 9, 8),
    ('Ford Focus', 2, 1, 2),
    ('Ford Ranger', 7, 6, 3),
    ('Mazda MX-5', 9, 2, 2),
    ('Kia Sportage', 5, 2, 4),
    ('Hyundai Tucson', 5, 6, 4),
    ('Nissan Leaf', 2, 9, 8),
    ('Lada Vesta', 1, 1, 1),
    ('Concept Car A', NULL, 9, 8),
    ('Concept Car B', 4, NULL, 7),
    ('Prototype X', NULL, NULL, NULL),
    ('Old Van', 8, 5, NULL);