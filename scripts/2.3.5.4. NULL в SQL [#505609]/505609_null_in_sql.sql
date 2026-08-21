SELECT id, name, middle_name FROM users
WHERE middle_name IS NULL;

SELECT id, name, description FROM products
WHERE description IS NULL;

SELECT id, name, price, discount_price FROM products
WHERE discount_price IS NULL;

SELECT id, name, phone FROM users
WHERE phone IS NULL
OR phone = '';

SELECT id, name,  COALESCE(description, 'описание отсутствует')
AS display_description FROM products;


SELECT id, name, price, discount_price, COALESCE(discount_price, price)
AS final_price FROM products;



