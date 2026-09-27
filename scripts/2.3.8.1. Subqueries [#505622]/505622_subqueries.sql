-- вывести товары, цена которых меньше средней цены всех товаров.
SELECT id AS product_id, name AS product_name, price
FROM products
WHERE price < (SELECT AVG(price) FROM products);

-- вывести пользователей, у которых есть хотя бы один заказ со статусом PAID.
SELECT u.id AS user_id, u.name AS user_name,
u.email AS email FROM users AS u
WHERE EXISTS (
SELECT 1 FROM orders AS o
WHERE o.user_id = u.id
AND o.status = 'PAID'
);

-- вывести пользователей, у которых нет ни одного заказа.
SELECT u.id AS user_id, u.name AS user_name,
u.email AS email FROM users AS u
WHERE NOT EXISTS (
SELECT 1 FROM orders AS o
WHERE o.user_id = u.id
)
ORDER BY u.id;

-- вывести товары, которые хотя бы раз встречались в order_items.
SELECT p.id AS product_id, p.name AS product_name,
p.price AS price  FROM products AS p
WHERE p.id IN (SELECT product_id FROM order_items);


-- вывести заказы, сумма которых больше 10000.
SELECT
    order_id,
	order_total FROM
(SELECT oi.order_id,  SUM(quantity * unit_price) AS order_total
FROM order_items AS oi
GROUP BY oi.order_id) AS t
WHERE
order_total > 10000
ORDER BY order_total;

-- вывести пользователей и количество их заказов через коррелированный подзапрос
SELECT u.id AS user_id, u.name AS user_name,
(SELECT COUNT(*)
 FROM orders AS o
 WHERE o.user_id = u.id) AS orders_count
FROM users AS u
ORDER BY u.id;

-- вывести товары, по которым суммарно продано больше, чем среднее количество продаж на товар.
SELECT product_id, SUM(quantity) AS total_quantity
FROM order_items
GROUP BY product_id
HAVING SUM(quantity) > (
SELECT AVG(total_quantity) FROM
  (SELECT product_id, SUM(quantity) AS total_quantity
   FROM order_items
   GROUP BY product_id) AS product_totals
);

-- вывести заказы, у которых сумма выше средней суммы заказа.
SELECT t.order_id, t.order_total
FROM ( SELECT order_id, SUM(quantity * unit_price) AS order_total
    FROM order_items
    GROUP BY order_id) AS t
WHERE t.order_total > (
    SELECT AVG(order_total)  FROM
 (SELECT order_id, SUM(quantity * unit_price) AS order_total
        FROM order_items
        GROUP BY order_id
    ) AS order_totals);