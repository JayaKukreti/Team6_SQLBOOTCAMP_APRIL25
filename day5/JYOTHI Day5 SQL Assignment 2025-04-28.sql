---Day 5
 
--1.GROUP BY with WHERE - Orders by Year and Quarter
--Display, order year, quarter, order count, avg freight cost only for those orders where freight cost > 100

SELECT * FROM orders;

SELECT
    order_date, freight 
FROM 
	orders 
WHERE 
	freight > 100;

SELECT 
	EXTRACT (YEAR FROM order_date) as order_year, 
	EXTRACT (QUARTER FROM order_date) as order_quarter,
	COUNT(*), AVG(freight)
FROM 
	orders 
WHERE 
	freight > 100
GROUP BY 
EXTRACT (YEAR FROM order_date) ,
EXTRACT (QUARTER FROM order_date) 

;	

---2. GROUP BY with HAVING - High Volume Ship Regions
--Display, ship region, no of orders in each region, min and max freight cost
--Filter regions where no of orders >= 5

SELECT * FROM orders;

SELECT
   ship_region, order_id, freight
FROM 
	orders
;

SELECT
   ship_region, 
   COUNT(order_id), 
   MIN(freight),
   MAX(freight)
FROM 
	orders
GROUP BY
	ship_region
HAVING 
	COUNT(order_id) >= 5

;
	  
---3.Get all title designations across employees and customers ( Try UNION & UNION ALL)	

SELECT * FROM employees;

SELECT * FROM customers;

SELECT
	title
FROM 
    employees

UNION ALL

SELECT
	contact_title
FROM 
    customers
;	

---4.Find categories that have both discontinued and in-stock products
--(Display category_id, instock means units_in_stock > 0, Intersect)

SELECT * FROM products;

SELECT
	category_id,
	units_in_stock,
	discontinued
FROM
    products
;	

SELECT
	category_id
FROM
    products
WHERE
	discontinued = 1
	
INTERSECT	

SELECT
	category_id
FROM
    products
WHERE
	units_in_stock > 0 	
;

---5.Find orders that have no discounted items (Display the  order_id, EXCEPT)

SELECT * FROM order_details;


SELECT order_id FROM order_details

EXCEPT

SELECT
	order_id
FROM 
	order_details
WHERE discount > 0 

;

















	

