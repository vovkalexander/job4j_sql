--- Лучшие клиенты (TOP)
SELECT o.customer_name, SUM(quantity * price) AS total_revenue
FROM order_items AS oi
INNER JOIN products AS p
ON oi.product_id = p.product_id
INNER JOIN orders AS o
ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY (customer_name)
ORDER BY total_revenue DESC
LIMIT 2;

--- Посчитайте общее количество проданных товаров и суммарную выручку для каждой категории (только успешные заказы).
SELECT p.category, SUM(quantity) AS total_items_sold,
	SUM(oi.quantity * p.price) AS category_revenue
FROM order_items AS oi
LEFT JOIN products p
ON oi.product_id = p.product_id
INNER JOIN orders o
ON oi.order_id = o.order_id
WHERE status = 'completed'
GROUP BY p.category
HAVING SUM(oi.quantity * p.price) > 30000
ORDER BY category,total_items_sold, category_revenue;


--- среднее количество товарных позиций (штук) находится в одном успешном заказе
WITH OrderAverenge AS (
  SELECT
       o.order_id, COUNT(quantity) AS order_count
    FROM order_items oi
    JOIN orders AS o
	ON oi.order_id = o.order_id
    WHERE o.status = 'completed'
    GROUP BY o.order_id
)

SELECT
      AVG(order_count) AS avg_items_per_order,
      COUNT(order_id) AS total_orders
      FROM OrderAverenge;


-- Создание таблиц
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price NUMERIC(10, 2) NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL
);

-- Заполнение тестовыми данными
INSERT INTO products (product_name, category, price) VALUES
('Ноутбук Apple MacBook Air', 'Электроника', 90000.00),
('Мышь Logitech MX Master', 'Аксессуары', 8000.00),
('Клавиатура Keychron K2', 'Аксессуары', 7500.00),
('Наушники Sony WH-1000XM5', 'Аудио', 25000.00);

INSERT INTO orders (customer_name, order_date, status) VALUES
('Иван Иванов', '2023-10-01', 'completed'),
('Петр Петров', '2023-10-02', 'completed'),
('Анна Смирнова', '2023-10-03', 'completed'),
('Елена Попова', '2023-10-04', 'cancelled'), -- Отмененный заказ!
('Иван Иванов', '2023-10-05', 'completed');

-- Состав заказов
-- Заказ 1: 1 Ноутбук + 1 Мышь
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1), (1, 2, 1);
-- Заказ 2: 2 Клавиатуры
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(2, 3, 2);
-- Заказ 3: 1 Наушники + 1 Мышь
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(3, 4, 1), (3, 2, 1);
-- Заказ 4 (Отменен): 1 Ноутбук
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(4, 1, 1);
-- Заказ 5: 1 Мышь + 1 Клавиатура
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(5, 2, 1), (5, 3, 1);
