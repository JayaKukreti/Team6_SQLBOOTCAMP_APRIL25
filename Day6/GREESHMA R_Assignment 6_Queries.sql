--Greeshma R DA164
-------------------------------------------------Assignment 6------------------------------------------------------------------------------------------

-- 1.Categorize products by stock status
--   (Display product_name, a new column stock_status whose values are based on below condition
--    (units_in_stock = 0  is 'Out of Stock' units_in_stock < 20  is 'Low Stock')

SELECT
	PRODUCT_NAME,
	CASE
		WHEN UNITS_IN_STOCK = 0 THEN 'Out of Stock'
		WHEN UNITS_IN_STOCK < 20 THEN 'Low Stock'
		ELSE 'In Stock'
	END AS STOCK_STATUS
FROM PRODUCTS;

----------------------------------------------------------------------------------------------------------------------------------------------------------

--2.Find All Products in Beverages Category
--  (Subquery, Display product_name,unitprice)

SELECT
	PRODUCT_NAME,
	UNIT_PRICE
FROM
	PRODUCTS
WHERE
	CATEGORY_ID = (
		SELECT
			CATEGORY_ID
		FROM
			CATEGORIES
		WHERE
			CATEGORY_NAME = 'Beverages'
	);

-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3.Find Orders by Employee with Most Sales
--   (Display order_id,   order_date,  freight, employee_id.
--   Employee with Most Sales=Get the total no.of of orders for each employee then order by DESC and limit 1. Use Subquery)

SELECT
	ORDER_ID,
	ORDER_DATE,
	FREIGHT,
	EMPLOYEE_ID
FROM
	ORDERS
WHERE
	EMPLOYEE_ID = (
		SELECT
			EMPLOYEE_ID
		FROM
			ORDERS
		GROUP BY
			EMPLOYEE_ID
		ORDER BY
			COUNT(*) DESC
		LIMIT
			1
	);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--4.Find orders  where for country!= ‘USA’ with freight costs higher than any order from USA. 
--  (Subquery, Try with ANY, ALL operators)

--Any 

SELECT
	ORDER_ID,
	CUSTOMER_ID,
	FREIGHT,
	SHIP_COUNTRY
FROM
	ORDERS
WHERE
	SHIP_COUNTRY != 'USA'
	AND FREIGHT > ANY (
		SELECT
			FREIGHT
		FROM
			ORDERS
		WHERE
			SHIP_COUNTRY = 'USA'
	);

--Using ALL
SELECT
	ORDER_ID,
	CUSTOMER_ID,
	FREIGHT,
	SHIP_COUNTRY
FROM
	ORDERS
WHERE
	SHIP_COUNTRY != 'USA'
	AND FREIGHT > ALL (
		SELECT
			FREIGHT
		FROM
			ORDERS
		WHERE
			SHIP_COUNTRY = 'USA'
	);---End