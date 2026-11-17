
CREATE TABLE employees (
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
full_name text NOT null,
salary NUMERIC(12, 2) NOT NULL CHECK(salary > 0),
updated_at TIMESTAMPTZ NOT NULL DEFAULT now());

--триггер, который автоматически обновляет поле updated_at при изменении записи
CREATE OR REPLACE FUNCTION update_data()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.updated_at = NOW();
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER update_employees_updated_at
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION update_data();

-- при изменении статуса заказа происходит  автоматическoe сохранение истории заказа
CREATE TABLE order_status_history(
id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
order_id BIGINT NOT NULL,
previous_status  VARCHAR(20) NOT NULL,
next_status VARCHAR(20) NOT NULL,
changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

CREATE OR REPLACE FUNCTION save_order_history()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO order_status_history (
        order_id,
        previous_status,
        next_status
    )
    VALUES (
        OLD.id,
        OLD.status,
        NEW.status
    );

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER order_status_history_trigger
AFTER UPDATE OF status
ON orders
FOR EACH ROW
EXECUTE FUNCTION save_order_history();

--запретить сохранение сотрудников с отрицательной заработной платой
CREATE OR REPLACE FUNCTION check_product_salary()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.salary < 0 THEN
        RAISE EXCEPTION 'Цена товара не может быть отрицательной.';
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;


CREATE TRIGGER check_product_salary_trigger
BEFORE INSERT OR UPDATE
ON employees
FOR EACH ROW
EXECUTE FUNCTION check_product_salary();


---триггер, который автоматически удаляет пробелы в начале и конце названия товара
CREATE OR REPLACE FUNCTION delete_products_space()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.name = TRIM(NEW.name);
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER delete_products_space_trigger
BEFORE INSERT OR UPDATE
ON products
FOR EACH ROW
EXECUTE FUNCTION delete_products_space();

-- триггер для журнала изменения цены, если цена действительно изменилась

CREATE TABLE product_price_history (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id BIGINT NOT NULL,
    old_price NUMERIC(10,2) NOT NULL,
    new_price NUMERIC(10,2) NOT NULL,
    is_active boolean NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION save_price_history()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.price <> OLD.price THEN
    INSERT INTO product_price_history (
        product_id,
        old_price,
        new_price,
        is_active
    )
    VALUES (
        OLD.id,
        OLD.price,
        NEW.price,
		OLD.is_active
    );
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER product_price_history_trigger
AFTER UPDATE OF price
ON products
FOR EACH ROW
EXECUTE FUNCTION save_price_history();