--1.List all customers and the products they ordered with the order date. (Inner join)
--Tables used: customers, orders, order_details, products
--Output should have below columns:
-- companyname AS customer,
-- orderid,
-- productname,
-- quantity,
-- orderdate
SELECT c.company_name AS customer,od.quantity,p.product_name,o.order_date,o.order_id
FROM order_details od
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN orders o ON o.order_id=od.order_id
INNER JOIN customers c ON c.customer_id=o.customer_id

--2.Show each order with customer, employee, shipper, and product info — even if some parts are missing. (Left Join)
--Tables used: orders, customers, employees, shippers, order_details, products
SELECT *
FROM orders o
LEFT JOIN customers c ON o.customer_id=c.customer_id
LEFT JOIN employees e ON e.employee_id=o.employee_id
LEFT JOIN order_details od ON od.order_id=o.order_id
LEFT JOIN products p ON od.product_id=p.product_id

--3. Show all order details and products (include all products even if they were never ordered). (Right Join)
--Tables used: order_details, products
--Output should have below columns:
 --   orderid,
  --  productid,
  --  quantity,
  --  productname
  --SELECT * FROM order_details
  --SELECT * FROM products
  --WHERE product_id NOT IN (SELECT product_id FROM order_details)
 SELECT p.product_id,p.product_name,od.order_id,od.quantity
 FROM  order_details od
 RIGHT JOIN
 products p ON od.product_id=p.product_id


--4.List all product categories and their products — including categories that have no products, and products that are not assigned to any category.(Outer Join)
--Tables used: categories, products
SELECT * FROM categories
SELECT c.category_id , c.category_name ,p.product_id ,p.product_name 
FROM products p
FULL OUTER JOIN categories c
ON p.category_id=c.category_id;

--5.Show all possible product and category combinations (Cross join).
--Example : clothing stores there are different sizes, and color , here cross join helps as it will display the sizes with all the available colors
SELECT product_id,product_name,category_name
FROM products
CROSS JOIN categories


--6.Show all employees and their manager(Self join(left join))
SELECT e.first_name||' ' ||e.last_name AS employee,m.first_name||' '||m.last_name AS manager
FROM employees e
LEFT JOIN employees m ON m.employee_id=e.reports_to 
ORDER BY manager;

--7. List all customers who have not selected a shipping method.
--Tables used: customers, orders
--(Left Join, WHERE o.shipvia IS NULL)
SELECT * FROM customers
SELECT * FROM orders
SELECT o.ship_via,c.contact_name,c.company_name
FROM customers c
LEFT JOIN orders o
ON o.customer_id=c.customer_id
WHERE o.ship_via IS NULL



