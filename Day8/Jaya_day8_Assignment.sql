--1.Create view vw_updatable_products (use same query whatever I used in the training)
--Try updating view with below query and see if the product table also gets updated.
--Update query:
--UPDATE updatable_products SET unit_price = unit_price * 1.1 WHERE units_in_stock < 10;

SELECT * FROM products

CREATE VIEW vm_updatable_products AS
SELECT
product_id,
product_name,
unit_price,
units_in_stock
FROM products
WHERE unit_price>0
WITH CHECK OPTION;

Update  vm_updatable_products
SET unit_price =unit_price*1.1
WHERE units_in_stock < 10
=========================================================================
--2.Transaction:
--Update the product price for products by 10% in category id=1
--Try COMMIT and ROLLBACK and observe what happens.

SELECT * FROM products where category_id=2
BEGIN
UPDATE products
SET unit_price = unit_price*0.1
WHERE category_id=2
commit;
rollback;
====================================================================
--3.Create a regular view which will have below details (Need to do joins):
--Employee_id,
--Employee_full_name,
--Title,
--Territory_id,
--territory_description,
--Region_description
SELECT * FROM employees
SELECT * FROM territories
SELECT * FROM employees_territories
SELECT * FROM region 

CREATE VIEW vw_employees_territories AS
SELECT e.employee_id,
first_name||' '||last_name AS employee_full_name,
e.title,
t.territory_id,
t.territory_description,
r.region_description
FROM employees e
INNER JOIN employee_territories et ON
e.employee_id= et.employee_id
INNER JOIN territories t ON
t.territory_id=et.territory_id
INNER JOIN region r ON
r.region_id=t.region_id

SELECT * FROM vw_employees_territories
==============================================================================
--4.Create a recursive CTE based on Employee Hierarchy
WITH RECURSIVE cte_employeehierarchy AS (
SELECT 
employee_id,
first_name,
last_name,
reports_to,
0 as level
From
employees e
where reports_to is null

union all

select
e.employee_id,
e.first_name,
e.last_name,
e.reports_to,
eh.level+1
from
employees e
join cte_employeehierarchy eh
on
eh.employee_id = e. reports_to
)
select level,employee_id,first_name|| ' ' || last_name as employee_name
from cte_employeehierarchy
order by
level,employee_id;


