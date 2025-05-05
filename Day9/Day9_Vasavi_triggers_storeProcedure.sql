-- Create a audit table
create table product_price_audit ( 
audit_id serial primary key,
product_id int,
product_name varchar(40),
old_price decimal(10,2),
new_price decimal(10,2),
change_date TIMESTAMP default CURRENT_TIMESTAMP,
user_name varchar(50) default current_user)

-- Create a trigger function that needs to be executed when a ecent occurs on table products
CREATE FUNCTION PRODUCT_PRICE_AUDIT() RETURNS TRIGGER LANGUAGE 'plpgsql' AS $$
DECLARE
begin
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
	return new;
end
$$;

-- Join th trigger with trigger function
drop trigger PRODUCTS_TRIGGER on products;
CREATE TRIGGER PRODUCTS_TRIGGER
BEFORE
DELETE
OR
UPDATE ON PRODUCTS
FOR EACH ROW EXECUTE PROCEDURE product_price_audit();

-- Test the trigger by updating the product price by 10% to any one product_id.

select * from products;
select * from product_price_audit;
update products set  unit_price = 40 where product_id = 6;
delete  from public.products where product_id = 9;

-- 2. stored procedure

 CREATE TABLE IF NOT EXISTS employee_tasks (
        task_id SERIAL PRIMARY KEY,
        employee_id INT,
        task_name VARCHAR(50),
        assigned_date DATE DEFAULT CURRENT_DATE);
-- Validate the table creation
select * from employee_tasks;


-- create a procedure to insert data into employee_tasks
create or replace procedure assign_tasks(
IN p_employee_id INT,
IN p_task_name VARCHAR(50),
INOUT p_task_count INT DEFAULT 0
 ) 
 LANGUAGE plpgsql
 as 
 $$
 begin
-- Insert employee_id, task_name  into employee_tasks
insert into employee_tasks(employee_id,task_name) values(p_employee_id,p_task_name);

-- Count total tasks for employee and put the total count into p_task_count .
select count(*) from employee_tasks into p_task_count where employee_id = p_employee_id;
--  Raise NOTICE message:
 RAISE NOTICE 'Task "%" assigned to employee %. Total tasks: %',
        p_task_name, p_employee_id, p_task_count;

 end;
 $$;
CALL assign_tasks(2,'Review Reports');
CALL assign_tasks(2,'Review Comments');

F
insert into employee_tasks(employee_id,task_name) values(1,'TEST TASK' );
delete from employee_tasks where task_id =1;
