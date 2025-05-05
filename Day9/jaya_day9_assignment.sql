-- 2.Create stored procedure  using IN and INOUT parameters to assign tasks to employees
-- Parameters:
--IN p_employee_id INT,
--IN p_task_name VARCHAR(50),
-- INOUT p_task_count INT DEFAULT 0
--Insert employee_id, task_name  into employee_tasks
--Count total tasks for employee and put the total count into p_task_count .
--Raise NOTICE message:
--RAISE NOTICE 'Task "%" assigned to employee %. Total tasks: %',
--p_task_name, p_employee_id, p_task_count;
--After creating stored procedure test by calling  it:
-- CALL assign_task(1, 'Review Reports');
 

CREATE TABLE IF NOT EXISTS employee_tasks(
task_id SERIAL PRIMARY KEY,
employee_id INT,
task_name VARCHAR(50),
assigned_date DATE DEFAULT CURRENT_DATE
)
INSERT INTO employee_tasks(employee_id,task_name)
VALUES(1,'Insert Data'),
     (2,'Update Data'),
     (3,'Delete Data')
SELECT * FROM employee_tasks

CREATE OR REPLACE procedure assign_employeetask_value(
IN p_employee_id INT,
IN p_task_name VARCHAR(50),
INOUT p_task_count INT DEFAULT 0
)
LANGUAGE plpgsql
AS $$
BEGIN
  IF NOT  EXISTS (SELECT 1 FROM employee_tasks WHERE employee_id=p_employee_id ) THEN
  RAISE EXCEPTION 'Employee_id % doesnot exist',p_employee_id;
  END IF;
  INSERT INTO employee_tasks(employee_id,task_name)
  VALUES (p_employee_id,p_task_name);
  SELECT COUNT(task_id)INTO p_task_count
  FROM employee_tasks
  WHERE employee_id=p_employee_id;
  RAISE NOTICE 'Task "%" assigned to employee %. Total tasks: %',
     p_task_name, p_employee_id, p_task_count;
 END;
 $$;
 
 CALL assign_employeetask_value(1,'delete Reports');

 --1.Create AFTER UPDATE trigger to track product price changes
-- Create product_price_audit table with below columns:
--audit_id SERIAL PRIMARY KEY,
--product_id INT,
--product_name VARCHAR(40),
--old_price DECIMAL(10,2),
--new_price DECIMAL(10,2),
--change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--user_name VARCHAR(50) DEFAULT CURRENT_USER
-- Create a trigger function with the below logic:
--INSERT INTO product_price_audit (product_id,product_name,old_price,new_price)
-- VALUES (OLD.product_id,OLD.product_name,OLD.unit_price,NEW.unit_price);
--Create a row level trigger for below event:
--AFTER UPDATE OF unit_price ON products
--Test the trigger by updating the product price by 10% to any one product_id.
--first create the table
--1. create a table
CREATE TABLE product_price_audit(
    audit_id SERIAL PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(40),
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_name VARCHAR(50) DEFAULT CURRENT_USER
   )
   SELECT * FROM product_price_audit
--2.Create a function
CREATE OR REPLACE FUNCTION log_new_price()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO product_price_audit (
        product_id,
        product_name,
        old_price,
        new_price
    )
    VALUES (
        OLD.product_id,
        OLD.product_name,
        OLD.unit_price,
        NEW.unit_price
    );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql; --now to bind the trigger with functions
--3. Create a trigger
CREATE TRIGGER product_update
AFTER UPDATE OF unit_price ON products
FOR EACH ROW
WHEN (OLD.unit_price IS DISTINCT FROM NEW.unit_price)
EXECUTE FUNCTION log_new_price();
--4. Update the products
UPDATE products
SET unit_price = unit_price * 1.10
WHERE product_id = 10;