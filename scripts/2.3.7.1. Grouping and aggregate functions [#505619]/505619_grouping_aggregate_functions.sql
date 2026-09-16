-- для каждого статуса заказа вывести количество заказов.
SELECT status, COUNT(*) AS orders_count
FROM orders
GROUP BY status;

-- для каждого пользователя вывести общую сумму всех его заказов.
SELECT u.id AS user_id, u.name AS user_name,
SUM(quantity * unit_price) AS total_spent FROM users AS u
LEFT JOIN orders AS o
ON o.user_id = u.id
LEFT JOIN order_items oi
ON oi.order_id = o.id
GROUP BY u.id, u.name
ORDER BY total_spent;

-- для каждого товара вывести:
SELECT p.id AS product_id, p.name AS product_name,
COUNT(oi.id) AS order_items_count,  SUM (quantity)  AS total_quantity FROM products AS p
LEFT OUTER JOIN order_items AS oi
ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY p.id;

-- для каждого заказа вывести: количество строк в заказе, итоговую сумму заказа.
SELECT o.id AS order_id, COUNT(o.id) AS items_count,
SUM(quantity * unit_price) AS order_total FROM orders AS o
LEFT OUTER JOIN order_items AS oi
ON o.id = oi.order_id
GROUP BY o.id
ORDER BY o.id;


-- для каждого пользователя и для каждого статуса его заказов вывести количество таких заказов.
SELECT u.id AS user_id, u.name AS user_name,
status, COUNT(o.id) AS orders_count FROM users AS u
LEFT OUTER JOIN orders AS o
ON u.id = o.user_id
GROUP BY u.id, user_name, status
ORDER BY u.id;


-- вывести минимальную, максимальную и среднюю цену продажи по каждому товару на основании order_items.
SELECT p.id AS product_id, p.name AS product_name,
MIN(unit_price) AS min_unit_price, MAX(unit_price) max_unit_price,
AVG(unit_price) AS avg_unit_price FROM products AS p
INNER JOIN order_items AS oi
ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY p.id;

-- вывести пользователей и количество их заказов, включая пользователей, у которых заказов нет.
SELECT u.id AS user_id, u.name AS user_name,
COUNT(o.id) AS orders_count FROM users AS u
LEFT OUTER JOIN orders AS o
ON u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY u.id;





