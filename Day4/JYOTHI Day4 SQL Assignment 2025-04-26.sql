--- DAY 4

---1.List all customers and the products they ordered with the order date. (Inner join)

--Tables used: customers, orders, order_details, products
--Output should have below columns:
    --companyname AS customer,
    --orderid,
    --productname,
    --quantity,
    --orderdate


SELECT
	o.order_id , o.order_date,  od.product_id, p.product_name, c.company_name as customer
FROM
	orders o	
	INNER JOIN 
		order_details od
			ON o.order_id = od.order_id
		INNER JOIN
			products p
				ON od.product_id = p.product_id
			INNER JOIN 
				customers c
					ON o.customer_id = c.customer_id
					;

--2.Show each order with customer, employee, shipper, and product info — even if some parts are missing. (Left Join)
-- Tables used: orders, customers, employees, shippers, order_details, products

SELECT * FROM orders;

SELECT * FROM products;

SELECT * FROM order_details;

SELECT * FROM shippers;

SELECT * FROM customers;

SELECT * FROM employees;

SELECT
     o.order_id,o.order_date,c.company_name as customer, p.product_name,od.quantity,e.first_name, s.shipper_id, s.company_name as shipper_name
FROM
    orders o
	LEFT JOIN 
	   customers c
	      	ON o.customer_id=c.customer_id
			    LEFT JOIN 
				   order_details od
				      ON o.order_id=od.order_id
                          LEFT JOIN 
							  employees e 
							     ON o.employee_id=e.employee_id
					  			     LEFT JOIN
						                products p
							                ON od.product_id=p.product_id
								                 LEFT JOIN
											         shippers s
												         ON o.ship_via= s.shipper_id
													     ;
														 
----3.Show all order details and products (include all products even if they were never ordered). (Right Join)
--Tables used: order_details, products
--Output should have below columns:
   -- orderid,
   --productid,
   --quantity,
   --productname
									
SELECT 
    od.order_id,od.product_id,p.product_id,od.quantity,p.product_name
FROM
    order_details od
	RIGHT JOIN
	    products p
		   ON od.product_id=p.product_id
		   ORDER BY od.product_id DESC
		   ;

----4.List all product categories and their products — including categories that have no products, and products that are not assigned to any category.(Outer Join)
--Tables used: categories, products
		   
SELECT * FROM products;			   
	    	
SELECT * FROM categories;	

SELECT 
    c.category_id, p.product_id, c.category_name, p.product_name
FROM 
    categories c
	   FULL OUTER JOIN 
	      products p
		     ON c.category_id=p.category_id
			 ORDER BY category_id DESC
			 ;

----5.Show all possible product and category combinations (Cross join).

SELECT * FROM products;				 
            
SELECT * FROM categories;

SELECT 
    p.product_name,c.category_name,p.product_id
FROM
    products p
	  CROSS JOIN 
	     categories c
		 ;

-----6. Show all employees and their manager(Self join(left join))

SELECT * FROM employees;

SELECT
    e1.first_name || ' ' ||e1.last_name as employee, e2.first_name || ' ' ||e2.last_name as manager
FROM 
    employees e1
	  LEFT JOIN 
	     employees e2 
		   ON e1.reports_to=e2.employee_id
		   ;
	
---7.List all customers who have not selected a shipping method.
--Tables used: customers, orders
--(Left Join, WHERE o.shipvia IS NULL)

SELECT * FROM customers;

SELECT * FROM orders;

SELECT * FROM shippers;

SELECT
    c.customer_id,c.company_name as customers,o.ship_via
FROM 
    customers c
	   LEFT JOIN
	        orders o 
			  ON c.customer_id=o.customer_id
			    WHERE o.ship_via IS NULL 
			    ;
	









