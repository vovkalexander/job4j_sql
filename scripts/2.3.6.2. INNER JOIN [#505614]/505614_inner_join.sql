SELECT o.id, o.status, u.email FROM users AS u
INNER JOIN orders AS o
ON u.id = o.user_id
ORDER BY o.id;


SELECT oi.id, o.id, p.name, oi.quantity  FROM orders AS o
INNER JOIN order_items AS oi
ON o.id = oi.order_id
INNER JOIN products AS p
ON oi.product_id = p.id
WHERE oi.quantity > 1;


SELECT o.id, p.name, oi.quantity, p.price FROM orders AS o
INNER JOIN order_items AS oi
ON o.id = oi.order_id
INNER JOIN products AS p
ON oi.product_id = p.id
where o.user_id = 1;

SELECT o.id, o.status, u.name FROM orders AS o
INNER JOIN users AS u
ON o.user_id = u.id
where status = 'NEW';

SELECT oi.id, p.name, oi.quantity, oi.quantity * oi.unit_price AS line_total  FROM orders AS o
INNER JOIN order_items AS oi
ON o.id = oi.order_id
INNER JOIN products AS p
ON oi.product_id = p.id;