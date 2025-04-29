--1.      GROUP BY with WHERE - Orders by Year and Quarter
-- Display, order year, quarter, order count, avg freight cost only for those orders where freight cost > 100
SELECT * FROM orders
SELECT EXTRACT(YEAR FROM order_date) AS Year,COUNT(*),EXTRACT(QUARTER FROM order_date) AS Quarter,AVG(freight)
FROM orders
WHERE freight>100
GROUP By Year,Quarter
--2. GROUP BY with HAVING - High Volume Ship Regions
--Display, ship region, no of orders in each region, min and max freight cost
-- Filter regions where no of orders >= 5
SELECT * FROM orders
SELECT ship_region,COUNT(ship_region),MIN(freight),MAX(freight)AS HIGH_VOLUME_SHIP_REGION
FROM orders
GROUP BY ship_region
HAVING COUNT(ship_region)>=5

--3.  Get all title designations across employees and customers ( Try UNION & UNION ALL)
SELECT * FROM employees
SELECT * FROM customers
SELECT title
FROM employees
UNION
SELECT contact_title
FROM customers

SELECT title
FROM employees
UNION ALL
SELECT contact_title
FROM customers

--4.  Find categories that have both discontinued and in-stock products
--(Display category_id, instock means units_in_stock > 0, Intersect)
SELECT * FROM categories
SELECT category_id,discontinued,
---5. Find orders that have no discounted items (Display the  order_id, EXCEPT)
SELECT * FROM order_details
SELECT order_id
FROM order_details
EXCEPT 
SELECT order_id
FROm order_details 
WHERE discount = 0
