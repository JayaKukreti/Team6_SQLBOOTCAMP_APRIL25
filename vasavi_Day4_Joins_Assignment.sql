-- 1.List all customers and the products they ordered with the order date. (Inner join)
-- Tables used: customers, orders, order_details, products
-- Output should have below columns:
--     companyname AS customer,
--     orderid,
--     productname,
--     quantity,
--     orderdate

SELECT C."companyName" AS CUSTOMER,
	O."orderID",
	P."productName",
	D.QUANTITY,
	O."orderDate"
FROM CUSTOMERS C
INNER JOIN ORDERS O ON O."customerID" = C."customerID"
INNER JOIN ORDER_DETAILS D ON O."orderID" = D."orderID"
INNER JOIN PRODUCTS P ON P."productID" = D."productID"
ORDER BY O."orderID",
	O."orderDate";

-- 2. Show each order with customer, employee, shipper, and product info — even if some parts are missing. (Left Join)
-- Tables used: orders, customers, employees, shippers, order_details, products

SELECT O."orderID",
	C."companyName" AS CUSTOMER,
	E1."employeeName",
	S."companyName" AS SHIPPERNAME,
	P."productName"
FROM ORDERS O
LEFT JOIN CUSTOMERS C ON O."customerID" = C."customerID"
LEFT JOIN EMPLOYEES E1 ON E1."employeeID" = O."employeeID"
LEFT JOIN SHIPPERS S ON S."shipperID" = O."shipperID"
LEFT JOIN ORDER_DETAILS D ON D."orderID" = O."orderID"
INNER JOIN PRODUCTS P ON P."productID" = D."productID" -- 		order by o."orderID", o."orderDate"

ORDER BY O."orderID" DESC NULLS FIRST --   3.Show all order details and products (include all products even if they were never ordered). (Right Join)
-- Tables used: order_details, products
-- Output should have below columns:
--     orderid,
--     productid,
--     quantity,
--     productname

SELECT D."orderID",
	D."unitPrice",
	D.QUANTITY,
	D.DISCOUNT,
	P."productID",
	P."productName"
FROM ORDER_DETAILS D
RIGHT JOIN PRODUCTS P ON D."productID" = P."productID"
ORDER BY P."productID" DESC NULLS FIRST -- 4. List all product categories and their products —
-- including categories that have no products, and products that are not assigned to any category.(Outer Join)
-- Tables used: categories, products

SELECT P."productName",
	C."categoryName"
FROM CATEGORIES C
FULL OUTER JOIN PRODUCTS P ON P."categoryID" = C."categoryID"
ORDER BY C."categoryName",
	P."productName" DESC -- 5. 	Show all possible product and category combinations (Cross join).

SELECT C."categoryName",
	P."productName"
FROM CATEGORIES C
CROSS JOIN PRODUCTS P
ORDER BY C."categoryName",
	P."productName" DESC -- 6. 	Show all employees and their manager(Self join(left join))

SELECT *
FROM EMPLOYEES;


SELECT E."employeeID",
	E."employeeName",
	E1."employeeID",
	E1."employeeName" AS MANAGER
FROM PUBLIC.EMPLOYEES E
LEFT JOIN EMPLOYEES E1 ON E1."employeeID" = E."reportsTo" -- 7. 	List all customers who have not selected a shipping method.
-- Tables used: customers, orders
-- (Left Join, WHERE o.shipvia IS NULL)

SELECT *
FROM CUSTOMERS;


SELECT *
FROM SHIPPERS
SELECT *
FROM ORDERS
WHERE "shipperID" = NULL;


SELECT C."contactName",
	C."customerID",
	O."orderID"
FROM PUBLIC.CUSTOMERS C
LEFT JOIN ORDERS O ON O."customerID" = C."customerID"
WHERE O."shipperID" = NULL;