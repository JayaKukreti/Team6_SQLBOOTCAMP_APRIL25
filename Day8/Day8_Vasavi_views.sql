-- 1.     Create view vw_updatable_products (use same query whatever I used in the training)
-- Try updating view with below query and see if the product table also gets updated.
-- Update query:
-- UPDATE updatable_products SET unit_price = unit_price * 1.1 WHERE units_in_stock < 10;

drop view if EXISTS vw_updatable_products
create view vw_updatable_products as (
	
	select product_id,product_name,unit_price,units_in_stock,discontinued from products
) 

select * from vw_updatable_products;
select * from products;
UPDATE vw_updatable_products SET unit_price = unit_price * 1.1 WHERE units_in_stock < 20

-- 2. Transaction:
-- Update the product price for products by 10% in category id=1
-- Try COMMIT and ROLLBACK and observe what happens.

begin;
update products set unit_price = unit_price + unit_price * 0.1 where category_id =2 and product_id =15;
commit
rollback


select product_id,product_name,unit_price from products where  category_id = 2;


-- 3.     Create a regular view which will have below details (Need to do joins):
-- Employee_id,
-- Employee_full_name,
-- Title,
-- Territory_id,
-- territory_description,
-- region_description

create view  vw_employee_territory as 
select e.Employee_id,
	   concat(e.first_name,' ',e.last_name) as Employee_full_name,
	   e.Title,
	   et.Territory_id,
	    t.territory_description,
	   r.region_description 
	   from public.employees e 
	   inner join employee_territories et using(employee_id) 
	   inner join public.territories t using (territory_id)
	   inner join public.region r using(region_id);
	   
select * from vw_employee_territory;

-- 4.     Create a recursive CTE based on Employee Hierarchy

select employee_id,first_name,title,reports_to from employees;

with recursive cte_employee_hierarchy as (
	select employee_id,first_name,title,reports_to 
	from employees e
	where employee_id =2
	UNION
	select e.employee_id,e.first_name,e.title,e.reports_to 
	from cte_employee_hierarchy eh
	join employees e on eh.employee_id = e.reports_to
)
select * from cte_employee_hierarchy;

