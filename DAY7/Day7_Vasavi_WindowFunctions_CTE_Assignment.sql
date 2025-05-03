-- Day7 Assignment


-- 1. Rank employees by their total sales
-- (Total sales = Total no of orders handled, JOIN employees and orders table)

select * from employees;

select employee_id,
		concat(first_name,' ',last_name) as EmployeeName,
		count(order_id) as TotalSales,
		rank() over(order by count(order_id) asc) as SalesRank
from public.employees e
join orders using(employee_id)
group by employee_id;




-- 2. Compare current order's freight with previous and next order for each customer.
-- (Display order_id,  customer_id,  order_date,  freight,
-- Use lead(freight) and lag(freight).

select order_id,  
	   customer_id,  
	   order_date,  
	   freight,
	   lag(freight,1) over(PARTITION by customer_id order by freight ) as Previous_freight,
-- 	   freight - lag(freight,1) over (PARTITION by customer_id order by freight) as Current_previous_freight_difference,
	   lead(freight,1) over(partition by customer_id order by freight) as Next_Freight
-- 	   freight - lead(freight,1) over(partition by customer_id order by freight) as current_next_freight_difference
	from orders 
	
	
-- 3.     Show products and their price categories, product count in each category, avg price:
--         	(HINT:
-- ·  	Create a CTE which should have price_category definition:
--         	WHEN unit_price < 20 THEN 'Low Price'
--             WHEN unit_price < 50 THEN 'Medium Price'
--             ELSE 'High Price'
-- ·  	In the main query display: price_category,  product_count in each price_category,  ROUND(AVG(unit_price)::numeric, 2) as avg_price)

WITH CTE_PRODUCT_PRICECAT AS
	(SELECT PRODUCT_ID,
			UNIT_PRICE,
			CASE
				WHEN UNIT_PRICE < 20 THEN 'Low Price'
				WHEN UNIT_PRICE < 50 THEN 'Medium Price'
				ELSE 'High Price'
			END price_category
		FROM PUBLIC.PRODUCTS)
SELECT price_category,count(*) as product_count_in_category, round(avg(unit_price)::numeric,2)as avg_price
FROM CTE_PRODUCT_PRICECAT group by price_category;

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

			
