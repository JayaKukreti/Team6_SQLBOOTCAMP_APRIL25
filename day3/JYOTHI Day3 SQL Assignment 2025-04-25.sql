------ Day 3

--USE Northwind from Kaggle:
--1) Update the categoryName From “Beverages” to "Drinks" in the categories table.

UPDATE categories
SET category_name = 'Drinks'
WHERE category_name = 'Beverages'; 

SELECT * FROM categories;

--2) Insert into shipper new record (give any values) Delete that new record from shippers table.

INSERT INTO shippers(shipper_id,company_name,phone)
VALUES(7,'USPS','425-000-7598');

DELETE FROM shippers
WHERE shipper_id=7;

SELECT * FROM shippers;

--3) Update categoryID=1 to categoryID=1001. Make sure related products update their categoryID too. Display the both category and products table to show the cascade.
--Delete the categoryID= “3”  from categories. Verify that the corresponding records are deleted automatically from products.
--(HINT: Alter the foreign key on products(categoryID) to add ON UPDATE CASCADE, ON DELETE CASCADE, add ON DELETE CASCADE for order_details(productid) )

SELECT * FROM products;

ALTER TABLE products
DROP CONSTRAINT fk_products_categories;

ALTER TABLE products
    ADD CONSTRAINT fk_products_categories FOREIGN KEY (category_id) REFERENCES categories (category_id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
	;
	
UPDATE categories
SET category_id=1001
WHERE category_id=1;


SELECT * FROM categories;

SELECT * FROM products
ORDER BY category_id;

--------

DELETE FROM categories
WHERE category_id=3;

SELECT * FROM categories;

SELECT * FROM products;

ALTER TABLE order_details
DROP CONSTRAINT fk_order_details_products;

ALTER TABLE products
    ADD CONSTRAINT fk_order_details_products FOREIGN KEY (product_id) REFERENCES products (product_id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
	;

DELETE FROM categories
WHERE category_id=3;

SELECT * FROM categories;

SELECT * FROM products;	

SELECT * FROM products
ORDER BY category_id;

----4) Delete the customer = “VINET”  from customers. Corresponding customers in orders table should be set to null
--(HINT:Alter the foreign key on orders(customerID) to use ON DELETE SET NULL)

SELECT * FROM customers
WHERE customer_id='VINET';

SELECT * FROM orders;

ALTER TABLE orders
DROP CONSTRAINT fk_orders_customers;

ALTER TABLE orders
    ADD CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
	ON DELETE SET NULL
	;

DELETE FROM customers
WHERE customer_id='VINET';

SELECT * FROM orders
WHERE customer_id='VINET';


SELECT * FROM orders
WHERE order_id in(10248, 10274, 10295, 10737, 10739);


--- 5)      Insert the following data to Products using UPSERT:

-- product_id = 100, product_name = Wheat bread, quantityperunit=1,unitprice = 13, discontinued = 0, categoryID=3

-- product_id = 101, product_name = White bread, quantityperunit=5 boxes,unitprice = 13, discontinued = 0, categoryID=3

-- product_id = 100, product_name = Wheat bread, quantityperunit=10 boxes,unitprice = 13, discontinued = 0, categoryID=3
-- (this should update the quantityperunit for product_id = 100)

SELECT*FROM products WHERE product_id=100;

INSERT INTO products(product_id,product_name,quantity_per_unit,unit_price,discontinued,category_id)
VALUES(100,'Wheat bread',1,13,0,3);
ON CONFLICT(product_id)
DO UPDATE
SET product_name=excluded.product_name,
    quantity_per_unit=excluded.quantity_per_unit,
	unit_price=excluded.unit_price,
	discontinued=excluded.discontinued,
    category_id=excluded.category_id;

ALTER TABLE products
DROP CONSTRAINT fk_products_categories;

INSERT INTO products(product_id,product_name,quantity_per_unit,unit_price,discontinued,category_id)
VALUES(101,'White bread',5,13,0,3)
ON CONFLICT(product_id)
DO UPDATE
SET product_name=excluded.product_name,
    quantity_per_unit=excluded.quantity_per_unit,
	unit_price=excluded.unit_price,
	discontinued=excluded.discontinued,
    category_id=excluded.category_id;

INSERT INTO products(product_id,product_name,quantity_per_unit,unit_price,discontinued,category_id)
VALUES(100,'Wheat bread',10,13,0,3)
ON CONFLICT(product_id)
DO UPDATE
SET product_name=excluded.product_name,
    quantity_per_unit=excluded.quantity_per_unit,
	unit_price=excluded.unit_price,
	discontinued=excluded.discontinued,
    category_id=excluded.category_id;	
	
select * from products WHERE product_id IN(100,101);

----6)      Write a MERGE query:

--Create temp table with name:  ‘updated_products’ and insert values as below:
 
--productID	productName	quantityPerUnit	unitPrice	discontinued	categoryID
--100	Wheat bread	10	20	1	5
--101	White bread	5 boxes	19.99	0	5
--102	Midnight Mango Fizz	24 - 12 oz bottles	19	0	1
--103	Savory Fire Sauce	12 - 550 ml bottles	10	0	2
 
--Update the price and discontinued status for from below table ‘updated_products’ only if there are matching products and updated_products .discontinued =0 

--If there are matching products and updated_products .discontinued =1 then delete 
 
--Insert any new products from updated_products that don’t exist in products only if updated_products .discontinued =0.

DROP TABLE updated_products;

CREATE TABLE updated_products
(
productID INTEGER PRIMARY KEY,
productName VARCHAR(20) NOT NULL,
quantityPerUnit VARCHAR(20),
unitPrice NUMERIC (10,2),
discontinued INTEGER,
categoryID INTEGER
);

TRUNCATE TABLE updated_products;

INSERT INTO updated_products
VALUES(100,	'Wheat bread',10,20,1,3),
(101,'White bread','5 boxes',19.99,0,5),
(102,'Midnight Mango Fizz','24 - 12 oz bottles',19,0,1),
(103,'Savory Fire Sauce','12 - 550 ml bottles',10,0,2)
;



SELECT * FROM updated_products;


SELECT * FROM products WHERE product_id IN (100,101,102,103);


MERGE INTO products p
USING updated_products up
ON p.product_id=up.productID
WHEN MATCHED AND up.discontinued=0 THEN 
UPDATE SET
unit_price=up.unitPrice,
discontinued=up.discontinued
WHEN MATCHED AND up.discontinued=1 THEN
DELETE
WHEN NOT MATCHED AND up.discontinued=0 THEN
INSERT (product_id, product_name, unit_price,quantity_per_unit, discontinued,category_id)
VALUES (up.productid, up.productname, up.unitprice, up.quantityPerUnit,up.discontinued, up.categoryid);


-------

SELECT * FROM products WHERE product_id IN (100,101,102,103);

------

---7)List all orders with employee full names. (Inner join)

SELECT * FROM orders;

SELECT * FROM employees;

SELECT * FROM orders o
INNER JOIN employees e 
ON o.employee_id=e.employee_id
;

SELECT o.*,e.first_name,e.last_name, e.first_name||' '||e.last_name AS full_name FROM orders o
INNER JOIN employees e
ON o.employee_id=e.employee_id
;





