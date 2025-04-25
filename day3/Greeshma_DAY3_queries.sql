---------------------DAY 3 Assignment--------------------------

--Q1)Update the categoryName From “Beverages” to "Drinks" in the categories table.

UPDATE categories
SET categoryname='Drinks'
WHERE categoryname='Beverages';
select * from categories;

--Q2)Insert into shipper new record (give any values) Delete that new record from shippers table.
SELECT * FROM shippers;

INSERT INTO shippers(shipperid,companyname)
VALUES (4,'DTC shipping')

DELETE FROM shippers
WHERE shipperid = 4;

--- IF The above Throws Error, Then Execute below 

ALTER TABLE orders
DROP CONSTRAINT IF EXISTS orders_shipperid_fkey


--Q3) Update categoryID=1 to categoryID=1001. Make sure related products update their categoryID too. 
--    Display the both category and products table to show the cascade.
--    Delete the categoryID= “3”  from categories. Verify that the corresponding records are deleted automatically from products.
--    (HINT: Alter the foreign key on products(categoryID) to add ON UPDATE CASCADE, ON DELETE CASCADE, add ON DELETE CASCADE for order_details(productid))


/*ALTERING THE PRODUCTS TABLE*/
ALTER TABLE products
DROP CONSTRAINT IF EXISTS products_categoryid_fkey;

ALTER TABLE products
ADD CONSTRAINT products_categoryid_fkey
FOREIGN KEY (categoryID)
REFERENCES categories(categoryID)
ON UPDATE CASCADE
ON DELETE CASCADE;

/*ALTERING Order_details Table*/
ALTER TABLE order_details
DROP CONSTRAINT IF EXISTS order_details_productid_fkey;

ALTER TABLE order_details
ADD CONSTRAINT order_details_productid_fkey
FOREIGN KEY (productid)
REFERENCES products(productid)
ON DELETE CASCADE;

--Updating categoryid
UPDATE categories
SET categoryid = 1001
WHERE categoryid = 1;

--Checking if updates are reflected
select * from categories
select * from products;

-- Delete category categoryid = 3
-- Throws Error message so we should alter the table
ALTER TABLE order_details
DROP CONSTRAINT IF EXISTS order_details_productid_fkey;

ALTER TABLE order_details
ADD CONSTRAINT order_details_productid_fkey
FOREIGN KEY (productid)
REFERENCES products(productid)
ON DELETE CASCADE;

DELETE FROM categories
WHERE categoryid = 3;

-- To verify the above
SELECT * FROM categories WHERE categoryid=3;
SELECT * FROM products WHERE categoryid = 3;


-- Q4)Delete the customer = “VINET”  from customers. 
--    Corresponding customers in orders table should be set to null 
--    (HINT: Alter the foreign key on orders(customerID) to use ON DELETE SET NULL)

ALTER TABLE orders 
DROP CONSTRAINT IF EXISTS orders_customerid_fkey;

ALTER TABLE orders
ADD CONSTRAINT orders_customerid_fkey
FOREIGN KEY (customerid)
REFERENCES customers(customerid)
ON DELETE SET NULL;

-- DELETING 
DELETE FROM customers
WHERE customerid = 'VINET';

-- Verifying 
SELECT * FROM customers WHERE customerid IS NULL;
SELECT * FROM orders WHERE customerid IS NULL;

-- Q5)Insert the following data to Products using UPSERT:
--   product_id = 100, product_name = Wheat bread, quantityperunit=1,unitprice = 13, discontinued = 0, categoryID=5
--   product_id = 101, product_name = White bread, quantityperunit=5 boxes,unitprice = 13, discontinued = 0, categoryID=5
--   product_id = 100, product_name = Wheat bread, quantityperunit=10 boxes,unitprice = 13, discontinued = 0, categoryID=5
--   (this should update the quantityperunit for product_id = 100)

---Insert product_id 100
INSERT INTO products (productid, productname, quantityperunit, unitprice, discontinued, categoryid)
VALUES (100, 'Wheat bread', '1', 13, 0, 5)
ON CONFLICT (productid)
DO UPDATE SET 
  quantityperunit = EXCLUDED.quantityperunit;

---Insert product_id 101
INSERT INTO products (productid, productname, quantityperunit, unitprice, discontinued, categoryid)
VALUES (101, 'White bread', '5 boxes', 13, 0, 5)
ON CONFLICT (productid)
DO UPDATE SET quantityperunit = EXCLUDED.quantityperunit;

-- Update product_id 100 again with new quantityperunit
INSERT INTO products (productid, productname, quantityperunit, unitprice, discontinued, categoryid)
VALUES (100, 'Wheat bread', '10 boxes', 13, 0, 5)
ON CONFLICT (productid)
DO UPDATE SET quantityperunit = EXCLUDED.quantityperunit;

SELECT * FROM products WHERE productid IN (100,101)

------------------------------Q6)Write a MERGE query:----------------------------------------------------------

-- Temporary table
CREATE TEMP TABLE updated_products (
    productid INT PRIMARY KEY,
    productName VARCHAR(100),
    quantityPerUnit VARCHAR(50),
    unitPrice NUMERIC,
    discontinued INT,
    categoryid INT
);

-- Inserting the values
INSERT INTO updated_products (productid, productName, quantityPerUnit, unitPrice, discontinued, categoryid)
VALUES
    (100, 'Wheat bread', '10', 20, 1, 5),
    (101, 'White bread', '5 boxes', 19.99, 0, 5),
    (102, 'Midnight Mango Fizz', '24 - 12 oz bottles', 19, 0, 1),
    (103, 'Savory Fire Sauce', '12 - 550 ml bottles', 10, 0, 2);

/*ALTERING TABLE*/
ALTER TABLE products
DROP CONSTRAINT products_categoryid_fkey;

ALTER TABLE products
ADD CONSTRAINT products_categoryid_fkey
FOREIGN KEY (categoryID) REFERENCES categories(categoryID)
ON DELETE SET NULL;  

/*Inserting Missing Categories*/
SELECT DISTINCT categoryID FROM updated_products;
SELECT categoryID FROM categories;

INSERT INTO categories (categoryID, categoryName, description)
VALUES
    (1, 'Beverages', 'Auto-added for foreign key'),
    (2, 'Condiments', 'Auto-added for foreign key'),
    (5, 'Bakery', 'Auto-added for foreign key')
ON CONFLICT (categoryID) DO NOTHING;


/*MERGING*/
MERGE INTO products AS p
USING updated_products AS u
ON p.productID = u.productID

-- 1. Update if discontinued = 0
WHEN MATCHED AND u.discontinued = 0 THEN
    UPDATE SET
        unitPrice = u.unitPrice,
        discontinued = u.discontinued

-- 2. Delete if discontinued = 1
WHEN MATCHED AND u.discontinued = 1 THEN
    DELETE

-- 3. Insert if not exists and discontinued = 0
WHEN NOT MATCHED AND u.discontinued = 0 THEN
    INSERT (productID, productName, quantityPerUnit, unitPrice, discontinued, categoryID)
    VALUES (u.productID, u.productName, u.quantityPerUnit, u.unitPrice, u.discontinued, u.categoryID);
	
SELECT * FROM products
WHERE productID IN (100, 101, 102, 103);

-- --------------------------------------------Q7)(Inner join)-------------------------------------------------------
---- NEW DATABSE
--List all orders with employee full names. (Inner join)

SELECT 
    orders.order_id,
    orders.order_date,
    employees.first_name || ' ' || employees.last_name AS employee_full_name
FROM 
    orders
INNER JOIN 
    employees ON orders.employee_id = employees.employee_id;

