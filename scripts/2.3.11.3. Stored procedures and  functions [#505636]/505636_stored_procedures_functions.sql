
-- Функция, которая возвращает стоимость товара после применения скидки
CREATE OR REPLACE FUNCTION calculate_discount(
    price NUMERIC,
    discount_percent NUMERIC
)
RETURNS NUMERIC
LANGUAGE SQL
AS
$$
    SELECT price * (100 - discount_percent) / 100;
$$;


-- функция full_name, которая принимает имя и фамилию пользователя и возвращает строку

CREATE OR REPLACE FUNCTION full_name (
    name text,
    last_name text
)
RETURNS text
LANGUAGE SQL
AS
$$
    SELECT name || ' ' || last_name;
$$;


---процедура увеличивает стоимость всех товаров указанной категории на заданный процент
CREATE OR REPLACE PROCEDURE increase_category_prices(
    category_name TEXT,
    percent NUMERIC
)
LANGUAGE SQL
AS
$$

WITH join_products_category AS (
SELECT p.name AS product_name, p.price, c.name AS category_name
from products as p
INNER JOIN categories as c
ON p.category_id = c.id
)
    UPDATE products
    SET price = price * (100 + percent) / 100
    WHERE category_name = category_name;
$$;


-- Процедура  переносит все заказы, созданные более года назад, из таблицы orders в таблицу orders_archive,
-- а затем удаляет их из таблицы orders.

CREATE OR REPLACE PROCEDURE archive_old_orders(
)
LANGUAGE SQL
AS
$$
INSERT INTO orders_archive (id, user_id, created_at)
SELECT id, user_id, created_at from orders
WHERE EXTRACT(YEAR FROM created_at) <  '2026';

DELETE FROM orders
WHERE EXTRACT(YEAR FROM created_at) <  '2026';
$$;


CREATE TABLE orders (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE orders_archive (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL
);

