----Day 8
 
--1.Create view vw_updatable_products (use same query whatever I used in the training)
--Try updating view with below query and see if the product table also gets updated.
--Update query:
--UPDATE updatable_products SET unit_price = unit_price * 1.1 WHERE units_in_stock < 10;

SELECT * FROM products;

CREATE VIEW vw_updatable_products AS
SELECT 
	product_id,
	product_name,
	unit_price,
	units_in_stock,
	discontinued
FROM
	products
	WHERE discontinued=0
	WITH CHECK OPTION;

	UPDATE vw_updatable_products SET unit_price = unit_price * 1.1 WHERE units_in_stock < 10;
	
SELECT * FROM vw_updatable_products;	
	
--2.Transaction:
--Update the product price for products by 10% in category id=1
--Try COMMIT and ROLLBACK and observe what happens.

SELECT 
	product_id,
	category_id,
	product_name,
	unit_price,
	units_in_stock
FROM
	products
	ORDER BY category_id;
	
BEGIN;
UPDATE products
SET unit_price=unit_price*1.10
WHERE category_id=1;

ROLLBACK;

COMMIT;

---3.Create a regular view which will have below details (Need to do joins):
--Employee_id,
--Employee_full_name,
--Title,
--Territory_id,
--territory_description,
--region_description

SELECT 
	employee_id,
	first_name ||' '|| last_name AS full_name,
	title
	
FROM
	employees;
		
SELECT	
	territory_id,
	territory_description,
	region_id
FROM
	territories;
	
SELECT
	region_description
FROM
	region;
	
SELECT
	employee_id,	
	territory_id
FROM
	employee_territories;

---

CREATE VIEW vw_employee_region_territory
	AS
SELECT 
	e.employee_id,
	e.first_name ||' '|| e.last_name AS full_name,
	e.title,
	-- et.employee_id,	
	-- et.territory_id,
	t.territory_id,
	t.territory_description,
	-- t.region_id,
	r.region_description
	-- r.region_id
FROM
	employees e
INNER JOIN
	employee_territories et
	ON e.employee_id = et.employee_id

INNER JOIN
	territories t
	ON et.territory_id = t.territory_id

INNER JOIN
	region r
	ON t.region_id = r.region_id;

SELECT * FROM vw_employee_region_territory;

--- 4.Create a recursive CTE based on Employee Hierarchy

-- Anchor member: top-level employees (no manager)

WITH RECURSIVE employee_hierarchy AS
(
    SELECT employee_id,first_name,last_name,reports_to,1 AS emp_level
    FROM employees
    WHERE reports_to IS NULL

    UNION ALL
	
-- Recursive member: employees reporting to others
    SELECT e.employee_id,e.first_name,e.last_name,e.reports_to,eh.emp_level + 1
    FROM employees e
    INNER JOIN employee_hierarchy eh on e.reports_to = eh.employee_id
)

SELECT *FROM employee_hierarchy
ORDER BY emp_level, employee_id;












	