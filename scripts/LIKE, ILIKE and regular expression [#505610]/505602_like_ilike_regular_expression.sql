SELECT id, name, email FROM users
WHERE email like '%mail%';

SELECT id, name, price FROM products
WHERE name ILIKE '%air%';

SELECT id, name, price FROM products
WHERE name ILIKE 'i%';

SELECT id, name, price FROM products
WHERE name ILIKE '%pro';

SELECT id, name, email FROM users
WHERE name ILIKE 'A%'
OR name ILIKE 'I%';

SELECT id, title, company, description FROM vacancies
WHERE title ~* '(java|go|postgres)'
OR description ~* '(java|go|postgres)';

SELECT id, name, price FROM products
WHERE name ~* '^iPhone [0-9]+$';