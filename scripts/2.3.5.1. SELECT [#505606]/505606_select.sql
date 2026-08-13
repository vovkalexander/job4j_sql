SELECT * FROM users;

SELECT name, email
FROM users;

SELECT id AS user_id, name AS user_name, email AS user_email
FROM users;

SELECT id, order_id, product_id, quantity, unit_price, quantity * unit_price AS line_total
FROM order_items;


SELECT id, name, price, price - (price * 0.1) AS discounted_price
FROM products;