WITH order_totals AS (
    SELECT
        o.user_id,
        order_id,
        o.created_at,
        SUM(oi.quantity * oi.unit_price) AS order_amount
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.id
    GROUP BY
         o.user_id,
         order_id,
        o.created_at
)
SELECT
    user_id,
    order_id,
    created_at,
    order_amount,
    FIRST_VALUE(order_amount) OVER (
        PARTITION BY user_id
        ORDER BY created_at
    ) AS first_order_amount,
    LAST_VALUE(order_amount) OVER (
	    PARTITION BY user_id
        ORDER BY created_at
     ROWS BETWEEN UNBOUNDED PRECEDING
             AND UNBOUNDED FOLLOWING
    ) AS last_order_amount,
   NTH_VALUE(order_amount, 2) OVER (
   PARTITION BY user_id
        ORDER BY created_at
   ROWS BETWEEN UNBOUNDED PRECEDING
             AND UNBOUNDED FOLLOWING
  ) AS second_order_amount
  FROM order_totals
  ORDER BY
    user_id,
    created_at;
