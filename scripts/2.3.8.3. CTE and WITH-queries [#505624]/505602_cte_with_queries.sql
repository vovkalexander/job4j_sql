-- используя CTE, вычислите общую стоимость каждого заказа.
WITH every_amount  AS ( SELECT o.id AS order_id, (oi.quantity * oi.unit_price) AS per_amount
FROM orders AS o
INNER JOIN order_items AS oi
ON o.id = oi.order_id)

SELECT order_id, SUM(per_amount) AS total_amount FROM every_amount
GROUP BY order_id;

--найди пользователей, общая сумма оплаченных заказов которых
--выше средней суммы оплаченных заказов по всем пользователям.
WITH user_totals AS (
SELECT o.user_id, SUM(quantity * unit_price) AS  total_amount FROM orders AS o
INNER JOIN order_items AS oi
ON o.id = oi.order_id
WHERE o.status = 'PAID'
GROUP BY o.user_id
),
average_total AS (
    SELECT AVG(total_amount) AS avg_total
    FROM user_totals
)

SELECT  u.id, u.name, ut.total_amount FROM users AS u
INNER JOIN user_totals AS ut
ON ut.user_id = u.id
CROSS JOIN average_total AS at
WHERE ut.total_amount > at.avg_total;

-- используя CTE, найдите товары, которые ни разу не были заказаны.
WITH  ordered_products  AS (SELECT oi.product_id, p.name FROM products AS p
INNER JOIN order_items AS oi
ON p.id = oi.product_id)
SELECT p.id AS product_id, p.name AS product_name FROM products AS p
LEFT OUTER JOIN ordered_products AS op
ON p.id = op.product_id
WHERE op.product_id IS NULL
;

-- используя CTE, определите пять самых продаваемых товаров по количеству проданных единиц.
WITH total_products AS(SELECT product_id, SUM(quantity) AS total_quantity  FROM order_items
GROUP BY product_id)
SELECT p.id AS product_id, p.name AS product_name, tp.total_quantity
FROM products AS p
INNER JOIN total_products AS tp
ON p.id = tp.product_id
ORDER BY tp.total_quantity  DESC
LIMIT 5;
