-- для каждого заказа необходимо вывести:
SELECT oi.order_id, o.user_id, (oi.quantity * oi.unit_price) AS total_amount,
SUM(oi.quantity * oi.unit_price) OVER( PARTITION BY o.user_id) AS user_total
FROM orders as o
INNER JOIN order_items AS oi
ON o.id = oi.order_id;

-- для каждого заказа необходимо вывести:
SELECT oi.order_id, o.user_id, (oi.quantity * oi.unit_price) AS total_amount,
AVG(oi.quantity * oi.unit_price) OVER( PARTITION BY o.user_id) AS average_order_amount
FROM orders as o
INNER JOIN order_items AS oi
ON o.id = oi.order_id;

-- для каждого заказа необходимо определить его порядковый номер среди заказов этого пользователя по дате оформления.
SELECT oi.order_id, o.user_id, o.created_at, ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY created_at
    ) AS row_number FROM order_items AS oi
INNER JOIN orders AS o
ON o.id = oi.order_id;

--  рейтинг заказов по их стоимости в порядке убывания.
SELECT  order_id, (unit_price * quantity)  AS total_amount, RANK() OVER (
        PARTITION BY order_id
        ORDER BY (unit_price * quantity) DESC
    ) AS order_rank FROM order_items;

--  рейтинг заказов по их стоимости в порядке убывания используя функцию DENSE_RANK().
    SELECT  order_id, (unit_price * quantity)  AS total_amount, DENSE_RANK() OVER (
        PARTITION BY order_id
        ORDER BY (unit_price * quantity) DESC
    ) AS order_rank FROM order_items;

--RANK() одинаковым значениям присваивает одинаковый ранг, но пропускает следующий доступный ранг после такой группы
--DENSE_RANK() тоже присваивает одинаковый ранг одинаковым значениям, но без пропусков (непрерывная нумерация).

-- разделение всех заказов на четыре примерно равные группы по стоимости заказа в порядке убывания.
SELECT order_id, (unit_price * quantity)  AS total_amount,
NTILE(4) OVER (ORDER BY (unit_price * quantity)  DESC) AS group_number
FROM order_items;

-- для каждого пользователя одновременно выведите: общую сумму его заказов, среднюю стоимость заказа, количество заказов.
SELECT order_id, user_id, (unit_price * quantity)  AS total_amount,
SUM(unit_price * quantity) OVER w AS user_total,
AVG(oi.quantity * oi.unit_price) OVER w AS average_order_amount,
COUNT(*) OVER w AS orders_count FROM order_items AS oi
INNER JOIN orders AS o
ON oi.order_id = o.id
WINDOW w AS (
    PARTITION BY user_id
);

