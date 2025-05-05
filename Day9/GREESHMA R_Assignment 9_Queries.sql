-------------------------------------------------Assignment 9----------------------------------------------------------------------------

--Qn1. Create AFTER UPDATE trigger to track product price changes

--Create product_price_audit table with below columns:
create table product_price_audit (
    audit_id serial primary key,
    product_id int,
    product_name varchar(40),
    old_price decimal(10,2),
    new_price decimal(10,2),
    change_date timestamp default current_timestamp,
    user_name varchar(50) default current_user
);

-- Create a trigger function with the below logic:
create or replace function track_price_changes()
returns trigger as $$
begin
    insert into product_price_audit (
        product_id,
        product_name,
        old_price,
        new_price
    )
    values (
        old.product_id,
        old.product_name,
        old.unit_price,
        new.unit_price
    );
    return new;
end;
$$ language plpgsql;

-- Create the trigger on products

create trigger after_price_update
after update of unit_price on products
for each row
when (old.unit_price is distinct from new.unit_price)
execute function track_price_changes();

-- Test the trigger by updating the product price by 10% to any one product_id.

update products
set unit_price = unit_price * 1.10
where product_id = 1;

select * from product_price_audit;



--Qn2.Create stored procedure  using IN and INOUT parameters to assign tasks to employees

-- Create the employee_tasks table using the Parameters

create table if not exists employee_tasks (
    task_id serial primary key,
    employee_id int,
    task_name varchar(50),
    assigned_date date default current_date
);

-- Create the stored procedure

create or replace procedure assign_task(
    in p_employee_id int,
    in p_task_name varchar(50),
    inout p_task_count int default 0
)
language plpgsql
as $$
begin
    insert into employee_tasks (employee_id, task_name)
    values (p_employee_id, p_task_name);

    select count(*) into p_task_count
    from employee_tasks
    where employee_id = p_employee_id;

    raise notice 'Task "%" assigned to employee %. Total tasks: %',
        p_task_name, p_employee_id, p_task_count;
end;
$$;

-- After creating stored procedure test by calling  it:

call assign_task(1, 'review reports');

-- You should see the entry in employee_tasks table.
select * from employee_tasks;
