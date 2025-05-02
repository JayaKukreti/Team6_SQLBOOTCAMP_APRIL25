-----------------------------------------------------  ASSIGNMENT 8-----------------------------------------------------------------------------------------

/*Qn1.Create view vw_updatable_products (use same query whatever I used in the training)
Try updating view with below query and see if the product table also gets updated.
Update query:
UPDATE updatable_products SET unit_price = unit_price * 1.1 WHERE units_in_stock < 10;*/

--Create a view
create view vw_updatable_products as
select product_id,product_name,unit_price,units_in_stock
from products;

--update query
update vw_updatable_products
set unit_price = unit_price * 1.1
where units_in_stock < 10;

--Verifying the products table after updating the view
select product_id,product_name,unit_price,units_in_stock
from products
where units_in_stock<10;


/*Qn2.Transaction: Update the product price for products by 10% in category id=1
Try COMMIT and ROLLBACK and observe what happens.*/

begin;

update products
set unit_price = unit_price * 1.1
where category_id = 1;

-- View changes before committing
select product_id,product_name,unit_price
from products
where category_id = 1;

--committing the transaction
COMMIT;

--rollback
ROLLBACK;


/*Qn3.Create a regular view which will have below details (Need to do joins):
Employee_id,Employee_full_name,Title,Territory_id,territory_description,region_description*/

create view vw_employee_territories as
select 
    e.employee_id,
    concat(e.first_name, ' ', e.last_name) as employee_full_name,
    e.title,
    et.territory_id,
    t.territory_description,
    r.region_description
from employees e
join employee_territories et on e.employee_id = et.employee_id
join territories t on et.territory_id = t.territory_id
join region r on t.region_id = r.region_id;

select * from vw_employee_territories;

/*Qn4.Create a recursive CTE based on Employee Hierarchy*/

-- Anchor member: top-level employees (no manager)
with recursive employee_hierarchy as (
    select employee_id,first_name,last_name,reports_to,1 as level
    from employees
    where reports_to is null

    union all
	
-- Recursive member: employees reporting to others
    select e.employee_id,e.first_name,e.last_name,e.reports_to,eh.level + 1
    from employees e
    inner join employee_hierarchy eh on e.reports_to = eh.employee_id
)


select *from employee_hierarchy
order by level, employee_id;
