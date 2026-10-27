
WITH daily_sales AS (
SELECT DATE(created_at) AS sale_date,
SUM(oi.quantity * unit_price) AS sales_amount
     FROM orders AS o
INNER JOIN order_items AS oi
ON o.id = oi.order_id
GROUP BY DATE(o.created_at)
ORDER BY sale_date
)
SELECT sale_date, sales_amount,
LAG(sales_amount) OVER (ORDER BY sale_date) AS previous_day_sales,
LEAD(sales_amount) OVER (ORDER BY sale_date) AS next_day_sales,
ROUND(
(sales_amount - LAG(sales_amount) OVER (ORDER BY sale_date))/
LAG(sales_amount) OVER (ORDER BY sale_date), 2) AS sales_diff,
SUM(sales_amount) OVER (
ORDER BY sale_date
ROWS BETWEEN UNBOUNDED PRECEDING
AND CURRENT ROW ) AS running_total,
ROUND(
AVG(sales_amount) OVER (
ORDER BY sale_date
ROWS BETWEEN 2 PRECEDING
AND CURRENT ROW ), 2)
AS avg_last_three_days
FROM daily_sales;