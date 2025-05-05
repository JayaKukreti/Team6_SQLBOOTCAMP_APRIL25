/*1.Create view vw_updatable_products (use same query whatever I used in the training)
Try updating view with below query and see if the product table also gets updated.
Update query:
UPDATE updatable_products SET unit_price = unit_price * 1.1 WHERE units_in_stock < 10;*/
create view vw_updatable_products AS
select 
    product_id,
    product_name,
    unit_price,
	units_in_stock,
	discontinued
from products
where discontinued=0
with check option;

UPDATE vw_updatable_products SET unit_price = unit_price * 1.1 WHERE units_in_stock < 10;

select * from vw_updatable_products;

2./*Update the product price for products by 10% in category id=1
Try COMMIT and ROLLBACK and observe what happens.*/

BEGIN;
UPDATE products
SET unit_price = unit_price * 1.10
WHERE category_id = 1;
commit;
Rollback;
/*3.Create a regular view which will have below details (Need to do joins):
Employee_id,
Employee_full_name,
Title,
Territory_id,
territory_description,
region_description*/

CREATE VIEW employee_territory_details as
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) as employee_full_name,
    e.title,
    t.territory_id,
    t.territory_description,
    r.region_description
from
    employees e
join
    employee_territories et ON e.employee_id = et.employee_id
join
    territories t ON et.territory_id = t.territory_id
join 
    region r ON t.region_id = r.region_id;

select * from employee_territory_details;	

