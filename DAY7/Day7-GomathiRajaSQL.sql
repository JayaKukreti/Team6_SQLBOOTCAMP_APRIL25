
                   --Day7
---1.Rank employees by their total sales
---(Total sales = Total no of orders handled, JOIN employees and orders table)
select e.employee_id,
       e.first_name,
	   e.last_name,
	   count(o.order_id)as total_orders,
	   rank() over(order by count(o.order_id) desc) as sales_rank
from employees e
join orders o on e.employee_id = o.employee_id
GROUP BY 
    e.employee_id, e.first_name, e.last_name;



----2.Compare current order's freight with previous and next order for each customer.
--(Display order_id,  customer_id,  order_date,  freight,
---Use lead(freight) and lag(freight).
SELECT 
    order_id,
    customer_id,
    order_date,
    freight,
    LAG(freight) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_freight,
    LEAD(freight) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_freight
FROM 
    orders;

--3.Show products and their price categories, product count in each category, avg price:
        
WITH price_cte AS (
    SELECT 
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


