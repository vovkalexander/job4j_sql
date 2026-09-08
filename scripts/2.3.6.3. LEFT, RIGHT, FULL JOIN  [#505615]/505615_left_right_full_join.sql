
-- вывести всех пользователей и количество их заказов, включая пользователей без заказов.
SELECT u.id, u.name, COUNT(o.user_id) AS count_orders FROM users AS u
LEFT OUTER JOIN orders AS o
on u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY u.id;

-- найти заказы, по которым еще не было платежа.
SELECT  o.id, o.status, o.created_at FROM orders AS o
LEFT OUTER JOIN payments AS p
ON o.id = p.order_id
WHERE p.id IS NULL
AND o.status NOT IN ('PAID');

-- вывести товары, которые встречались хотя бы в одном заказе, и рядом показать, сколько раз они встречались в order_items.
SELECT p.id, p.name, COUNT(oi.order_id)  FROM products AS p
LEFT OUTER JOIN order_items AS oi
ON p.id = oi.product_id
WHERE order_id IS NOT NULL
GROUP BY p.id, p.name
ORDER BY p.id;

-- вывести все роли и количество пользователей, которым назначена каждая роль.
SELECT r.name, count(u.id) AS count_roles  FROM roles AS r
LEFT JOIN user_roles AS ur
ON r.id = ur.role_id
LEFT JOIN users AS u
ON ur.user_id = u.id
GROUP BY r.name, r.code
ORDER BY r.code;

-- найти пользователей, которым не назначена ни одна роль.
SELECT u.id, u.name  FROM users AS u
LEFT JOIN user_roles AS ur
ON u.id = ur.user_id
WHERE ur.role_id IS NULL;

-- сделать сверочный запрос по ролям и назначениям ролей
SELECT r.code, u.id AS user_id FROM roles AS r
FULL JOIN user_roles AS ur
ON ur.role_id = r.id
FULL JOIN users AS u
on ur.user_id = u.id;

-- построить все комбинации “роль × окружение”.
SELECT r.code AS role_code,
e.code AS environment_code
FROM roles AS r
CROSS JOIN environments AS e;

-- вывести все категории вместе с именем их родительской категории.
SELECT c.name AS category_name, p.name AS parent_name  FROM categories AS c
LEFT JOIN categories AS p
on c.parent_id = p.id;