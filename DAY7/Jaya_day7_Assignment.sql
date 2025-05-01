--1.Rank employees by their total sales
--(Total sales = Total no of orders handled, JOIN employees and orders table)
SELECT e.first_name||''||e.last_name AS Full_name,
count(o.order_id) AS Total_sales,
RANK() OVER(
ORDER BY count(o.order_id) DESC
)As sales_rank
FROM orders o
INNER JOIN 
employees e 
ON o.employee_id= e.employee_id
GROUP BY 
Full_name

--2.Compare current order's freight with previous and next order for each customer.
--(Display order_id,  customer_id,  order_date,  freight,
--Use lead(freight) and lag(freight).

SELECT order_id, customer_id,order_date,freight,
lag(freight) over(partition by customer_id ORDER BY order_date )As previous_freight,
lead(freight) over(partition by customer_id ORDER BY order_date )As next_freight
FROM orders

--3.Show products and their price categories, product count in each category, avg price:
--(HINT:Create a CTE which should have price_category definition:
-- 	WHEN unit_price < 20 THEN 'Low Price'
-- WHEN unit_price < 50 THEN 'Medium Price'
-- ELSE 'High Price'
·--In the main query display: price_category,  product_count in each price_category,  ROUND(AVG(unit_price)::numeric, 2) as avg_price)

WITH price_cte AS (
    SELECT 
        product_id,
        product_name,
        unit_price,
        CASE 
            WHEN unit_price < 20 THEN 'Low Price'
            WHEN unit_price < 50 THEN 'Medium Price'
            ELSE 'High Price'
        END AS price_category
    FROM 
        products
)

SELECT 
    price_category,
    COUNT(*) AS product_count,
    ROUND(AVG(unit_price)::numeric, 2) AS avg_price
FROM 
    price_cte
GROUP BY 
    price_category
ORDER BY 
    price_category;