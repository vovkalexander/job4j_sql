-- получить общий список идентификаторов пользователей, которые:
 --либо делали заказы со статусом PAID;
 --либо делали заказы со статусом NEW.
SELECT user_id FROM orders
WHERE status = 'NEW'
UNION
SELECT user_id FROM orders
WHERE status = 'PAID';

-- получить общий список событий из таблиц users, products, orders.
SELECT 'user' AS entity_type, u.id AS entity_id, u.created_at
FROM users AS u
UNION ALL
SELECT 'product' AS entity_type, p.id AS entity_id, p.created_at
FROM products AS p
UNION ALL
SELECT 'order' AS entity_type, o.id AS  entity_id, o.created_at
FROM orders AS o
ORDER BY created_at DESC;

-- найти товары, которые: активны и хотя бы раз встречались в заказах.
SELECT id AS product_id, name AS product_name  FROM products
WHERE is_active = true
INTERSECT
SELECT oi.product_id, p.name AS product_name FROM products AS p
JOIN order_items AS oi
ON p.id = oi.product_id
ORDER BY product_id;

-- найти активные товары, которые ни разу не встречались в заказах.
SELECT id AS product_id, name AS product_name  FROM products
WHERE is_active = true
EXCEPT
SELECT oi.product_id, p.name AS product_name FROM products AS p
JOIN order_items AS oi
ON p.id = oi.product_id
ORDER BY product_id;

-- получить общий список пользователей, которые делали заказы и были созданы после 2025-01-01
SELECT u.id AS user_id, u.name AS user_name from users AS u
JOIN orders AS o
ON u.id = o.user_id
UNION
SELECT id AS user_id, name AS user_name from users
WHERE created_at > DATE '2025-01-01'
ORDER BY user_id;


-- получить список товаров, которые дороже средней цены товаров и при этом встречались в заказах.
SELECT id AS product_id, name AS product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
INTERSECT
SELECT p.id AS product_id, name AS product_name, price FROM products AS p
JOIN order_items AS oi
ON p.id = oi.product_id;

-- получить список пользователей, которые делали заказы, но не делали заказов со статусом CANCELLED.
SELECT u.id AS user_id, u.name AS user_name FROM users AS u
JOIN orders AS o
ON u.id = o.user_id
EXCEPT
SELECT u.id AS user_id, u.name AS user_name FROM users AS u
JOIN orders AS o
ON u.id = o.user_id
WHERE o.status = 'CANCELED'
ORDER BY user_id;


--получить общий список объектов для поиска по названию/имени из таблиц users и products.
SELECT 'user' AS entity_type, u.id AS entity_id, u.name AS display_name
FROM users AS u
UNION ALL
SELECT 'product' AS entity_type, p.id AS entity_id, p.name AS display_name
FROM products AS p;