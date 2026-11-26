
-- курсор products_cursor, который будет читать список товаров из таблицы products.
BEGIN;

DECLARE products_cursor CURSOR FOR
SELECT id, name, price
FROM products;

FETCH 3 FROM products_cursor;
FETCH 2 FROM products_cursor;
CLOSE products_cursor;

COMMIT;


-- курсор, который будет читать  данные из таблицы orders небольшими порциями.
BEGIN;

DECLARE orders_cursor CURSOR FOR
SELECT *
FROM orders
ORDER by id;

FETCH 5 FROM orders_cursor;
FETCH 5 FROM orders_cursor;
CLOSE orders_cursor;

COMMIT;

-- курсор с поддержкой перемещения в обоих направлениях.

BEGIN;
DECLARE products_cursor SCROLL CURSOR FOR
SELECT id, name, price
FROM products
ORDER BY id;

FETCH 3 FROM products_cursor;
MOVE BACKWARD 2 FROM products_cursor;
FETCH 2 FROM products_cursor;

CLOSE products_cursor;

COMMIT;



