--- Day 9
 

--Create product_price_audit table with below columns:
CREATE TABLE product_price_audit (
    audit_id serial PRIMARY KEY,
    product_id int,
    product_name VARCHAR(40),
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    change_date TIMESTAMP default current_timestamp,
    user_name VARCHAR(50) default current_user
);

-- Create a trigger function with the below logic:
CREATE OR REPLACE FUNCTION track_price_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO product_price_audit
	(
        product_id,
        product_name,
        old_price,
        new_price
    )
    VALUES
	(
        old.product_id,
        old.product_name,
        old.unit_price,
        new.unit_price
    );
    RETURN NEW;
END;
$$ language plpgsql;

-- Create the trigger on products

CREATE TRIGGER after_price_update
AFTER UPDATE OF unit_price on products
FOR EACH ROW
WHEN (old.unit_price is distinct from new.unit_price)
EXECUTE FUNCTION track_price_changes();

-- Test the trigger by updating the product price by 10% to any one product_id.

UPDATE products
SET unit_price = unit_price * 1.10
WHERE product_id = 1;

SELECT * FROM product_price_audit;

----2.Create stored procedure  using IN and INOUT parameters to assign tasks to employees

-- Create the employee_tasks table using the Parameters

--Parameters:
--IN p_employee_id INT,
--IN p_task_name VARCHAR(50),
--INOUT p_task_count INT DEFAULT 0
 
--Inside Logic: Create table employee_tasks:

CREATE TABLE IF NOT EXISTS employee_tasks
(
    task_id serial PRIMARY KEY,
    employee_id INT,
    task_name VARCHAR(50),
    assigned_date date default current_date
);

-- Create the stored procedure

CREATE OR REPLACE PROCEDURE assign_task
(
    IN p_employee_id int,
    IN p_task_name varchar(50),
    INOUT p_task_count int default 0
)
language plpgsql
AS $$
BEGIN
    INSERT INTO employee_tasks (employee_id, task_name)
    values (p_employee_id, p_task_name);

SELECT COUNT(*) INTO p_task_count
    FROM employee_tasks
    	WHERE employee_id = p_employee_id;

    RAISE NOTICE 'Task "%" assigned to employee %. Total tasks: %',
        p_task_name, p_employee_id, p_task_count;
END;
$$;

-- After creating stored procedure test by calling  it:

CALL assign_task(1, 'review reports');

-- You should see the entry in employee_tasks table.
SELECT * FROM employee_tasks;




