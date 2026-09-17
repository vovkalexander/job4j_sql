
-- вывести статусы заказов, по которым количество заказов не меньше 3.
SELECT status, COUNT(*) AS orders_count FROM orders
GROUP BY status
HAVING COUNT(*) >= 3;

-- для каждого пользователя вывести суммарную стоимость всех его заказов, но оставить только тех пользователей,
-- у которых общая сумма заказов больше 10000.
SELECT u.id AS user_id, u.name AS user_name,
SUM(quantity * unit_price)  AS total_spent FROM users AS u
LEFT OUTER JOIN orders AS o
ON u.id = o.user_id
LEFT OUTER JOIN order_items AS oi
ON o.id = oi.order_id
GROUP BY  u.id, u.name
HAVING SUM(quantity * unit_price) > 10000
ORDER BY u.id;

-- вывести товары, по которым суммарно продано от 5 единиц и больше,
-- но учитывать только те строки заказа, где unit_price >= 1000.
SELECT p.id AS product_id, p.name AS product_name,
SUM(quantity) >= 5 AS total_quantity FROM products AS p
INNER JOIN order_items AS oi
ON p.id = oi.product_id
WHERE unit_price >= 1000
GROUP BY p.id, p.name
HAVING SUM(quantity) >= 5;

-- для каждого пользователя и каждого статуса заказа вывести количество заказов,
-- но оставить только те группы, где количество заказов больше 1.
SELECT u.id AS user_id, u.name AS user_name,
status, COUNT(o.id) AS orders_count FROM users AS u
LEFT OUTER JOIN orders AS o
ON u.id = o.user_id
GROUP BY u.id, u.name, status
HAVING COUNT(*) > 1;

-- вывести заказы, в которых суммарно куплено не меньше 4 единиц товара.
SELECT o.id AS order_id,
SUM(quantity) AS total_quantity FROM orders AS o
INNER JOIN order_items AS oi
ON o.id = oi.order_id
GROUP BY o.id
HAVING SUM(quantity) >= 4;

-- вывести пользователей, у которых есть хотя бы 2 заказа со статусом PAID.
SELECT u.id AS user_id, u.name AS user_name,
COUNT(*) AS paid_orders_count FROM users AS u
INNER JOIN orders AS o
ON u.id = o.user_id
WHERE status = 'PAID'
GROUP BY u.id, u.name
HAVING COUNT(*) >= 2 ;


-- для каждого товара вывести минимальную и максимальную цену продажи из order_items,
-- но оставить только те товары, у которых максимальная цена продажи больше 5000.

SELECT p.id AS product_id, p.name AS product_name,
MIN(unit_price) AS min_unit_price, MAX(unit_price) AS max_unit_price FROM products AS p
INNER JOIN order_items AS oi
ON p.id = oi.product_id
GROUP BY p.id, p.name
HAVING MAX(unit_price) > 5000
ORDER BY p.id;

-- вывести статусы заказов, для которых средняя сумма строки заказа больше 2000,
-- но учитывать только заказы, созданные начиная с 1 января 2025 года.
SELECT status, AVG(quantity * unit_price) AS avg_line_total FROM orders AS o
INNER JOIN order_items AS oi
ON o.id = oi.order_id
WHERE o.created_at >= DATE '2025-01-01'
GROUP BY status
HAVING AVG(quantity * unit_price) > 2000;




