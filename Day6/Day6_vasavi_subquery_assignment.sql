-- Day6 Assignment
	
-- 1.  Categorize products by stock status
-- (Display product_name, a new column stock_status whose values are based on below condition
--  units_in_stock = 0  is 'Out of Stock'
--        units_in_stock < 20  is 'Low Stock')

SELECT product_name,
	CASE
		WHEN "unit_price" = 0 THEN 'Out of Stock'
		WHEN "unit_price" < 20 THEN 'Low Stock'
		ELSE 'In stock'
	END AS "stock_status"
FROM PUBLIC.PRODUCTS
ORDER BY product_id;

-- 2.Find All Products in Beverages Category
-- (Subquery, Display product_name,unitprice)


select * from public.categories;

SELECT *
FROM public.products
WHERE PRODUCTS."category_id" =
		(SELECT "category_id"
			FROM PUBLIC.CATEGORIES
			WHERE "category_name" = 'Beverages')



-- 3.  Find Orders by Employee with Most Sales
-- (Display order_id,   order_date,  freight, employee_id.
-- Employee with Most Sales=Get the total no.of of orders for each employee then order by DESC and limit 1. Use Subquery)

SELECT order_id,order_date,employee_id,freight
FROM public.orders
WHERE "employee_id" =
		(SELECT employee_id
			FROM public.orders
			GROUP BY employee_id
			ORDER BY COUNT("employee_id") DESC
			LIMIT 1)
		
-- 4. Find orders  where for country!= ‘USA’ with freight costs higher than any order from USA. (Subquery, Try with ANY, ALL operators)



SELECT ORDER_ID,
	SHIP_COUNTRY,
	FREIGHT
FROM PUBLIC.ORDERS
WHERE SHIP_COUNTRY != 'USA'
	AND FREIGHT > ANY
		(SELECT FREIGHT
			FROM PUBLIC.ORDERS
			WHERE SHIP_COUNTRY = 'USA' )
			
SELECT ORDER_ID,
	SHIP_COUNTRY,
	FREIGHT
FROM PUBLIC.ORDERS
WHERE SHIP_COUNTRY != 'USA'
	AND FREIGHT > all
		(SELECT FREIGHT
			FROM PUBLIC.ORDERS
			WHERE SHIP_COUNTRY = 'USA' )
 