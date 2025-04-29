                                --5.Day5
 
--1.GROUP BY with WHERE - Orders by Year and Quarter
---Display, order year, quarter, order count, avg freight cost only for those orders where freight cost > 100
select extract(year from order_Date) as order_year,
       extract( quarter from order_Date) as order_quarter,
	   count(*) as order_count,
	   avg(freight) as avg_freight
from orders
where freight>100
group by
            extract(year from order_date ),
			extract(quarter from order_date)
ORDER BY 
    order_year,
    order_quarter;			
---2. GROUP BY with HAVING - High Volume Ship Regions
--Display, ship region, no of orders in each region, min and max freight cost
--Filter regions where no of orders >= 5
select ship_region,
       count(*) as no_of_orders,
	   min(freight)as min_freight,
	   max(freight)max_freight
from orders
GROUP BY ship_region
HAVING COUNT(*) >= 5
ORDER BY no_of_orders DESC;

----3.Get all title designations across employees and customers ( Try UNION & UNION ALL)
                -- Union(without duplicates)

SELECT title
FROM employees

UNION

SELECT contact_title
FROM customers;

		              -- Union all(with duplicates)
SELECT title
FROM employees

UNION ALL

SELECT contact_title
FROM customers;

----4.Find categories that have both discontinued and in-stock products
---(Display category_id, instock means units_in_stock > 0, Intersect)

select category_id
from products
where discontinued=1
intersect
select category_id
from products
where units_in_stock>0

---5.Find orders that have no discounted items (Display the  order_id, EXCEPT)

SELECT order_id
FROM orders
EXCEPT
SELECT DISTINCT order_id
FROM order_details
WHERE discount > 0;

	