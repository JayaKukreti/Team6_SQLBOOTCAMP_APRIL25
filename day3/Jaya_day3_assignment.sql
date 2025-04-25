--1.)Update the categoryName From “Beverages” to "Drinks" in the categories table.
UPDATE categories
SET categoryname= 'Drinks'
WHERE categoryname='Beverages'
SELECT * FROM categories

--2.)Insert into shipper new record (give any values) Delete that new record from shippers table.
SELECT * FROM shippers
INSERT INTO shippers(shipperid,companyname)
VALUES(4,'United Postal'),
(5,'FedX')
DELETE FROM shippers
WHERE shipperid IN(4,5)
SELECT * FROM shippers

--3. Update categoryID=1 to categoryID=1001. Make sure related products update their categoryID too. Display the both category and products table to show the cascade.
--Delete the categoryID= “3”  from categories. Verify that the corresponding records are deleted automatically from products.
SELECT * FROM categories
UPDATE categories
SET categoryid=1001
WHERE categoryid=1
--DROP THE CONSTRAINTS(relationship of primary and foreign key)--
ALTER TABLE products
DROP CONSTRAINT IF EXISTS products_categoryid_fkey 
--Again add the constraints---
SELECT * FROM products
ALTER TABLE products
ADD CONSTRAINT fk_category
FOREIGN KEY(categoryid)
REFERENCES categories(categoryid)
ON UPDATE CASCADE
ON DELETE CASCADE

UPDATE categories
SET categoryid=1001
WHERE categoryid=1

SELECT * FROM products


ALTER TABLE order_details
DROP CONSTRAINT IF EXISTS  order_details_productid_fkey

ALTER TABLE order_details
ADD CONSTRAINT productid_fk_category
FOREIGN KEY(productid)
REFERENCES products(productid)
ON DELETE CASCADE

DELETE  FROM categories
WHERE categoryid=3

--4.Delete the customer = “VINET”  from customers. Corresponding customers in orders table should be set to null (HINT: Alter the foreign key on orders(customerID) to use ON DELETE SET NULL)
ALTER TABLE orders
DROP CONSTRAINT  IF EXISTS orders_customerid_fkey

ALTER TABLE orders
ADD CONSTRAINT orders_customerid_fk_category
FOREIGN KEY(customerid)
REFERENCES customers(customerid)
ON DELETE SET NULL
SELECT * FROM customers

DELETE FROM customers
WHERE customerid='VINET'

--5.  Insert the following data to Products using UPSERT:
product_id = 100, product_name = Wheat bread, quantityperunit=1,unitprice = 13, discontinued = 0, categoryID=5
product_id = 101, product_name = White bread, quantityperunit=5 boxes,unitprice = 13, discontinued = 0, categoryID=5
product_id = 100, product_name = Wheat bread, quantityperunit=10 boxes,unitprice = 13, discontinued = 0, categoryID=5
SELECT * FROM products

INSERT INTO products 
VALUES 
    (100, 'Wheat bread', '1', 13, false, 5)
ON CONFLICT (productid)
DO UPDATE SET 
    productname = EXCLUDED.productname,
    quantityperunit = EXCLUDED.quantityperunit,
    unitprice = EXCLUDED.unitprice,
    discontinued = EXCLUDED.discontinued,
    categoryid = EXCLUDED.categoryid

INSERT INTO products 
VALUES 
    (101, 'Wheat bread', '5', 13,false,5)
ON CONFLICT (productid)
DO UPDATE SET 
    productname = EXCLUDED.productname,
    quantityperunit = EXCLUDED.quantityperunit,
    unitprice = EXCLUDED.unitprice,
    discontinued = EXCLUDED.discontinued,
    categoryid = EXCLUDED.categoryid
INSERT INTO products 
VALUES 
    (100, 'Wheat bread', '10', 13, false, 5)
ON CONFLICT (productid)
DO UPDATE SET 
    productname = EXCLUDED.productname,
    quantityperunit = EXCLUDED.quantityperunit,
    unitprice = EXCLUDED.unitprice,
    discontinued = EXCLUDED.discontinued,
    categoryid = EXCLUDED.categoryid

SELECT * FROM products


--6.Create temp table with name:  ‘updated_products’ and insert values as below:
CREATE TEMP TABLE updated_products(
productid INT PRIMARY KEY,
productName VARCHAR(200),
quantityPerUnit TEXT,
unitPrice DECIMAL(10,2),
discontinued BOOLEAN,
categoryid INT
);

SELECT * FROM updated_products
INSERT INTO updated_products(productid,productName,quantityPerUnit,unitPrice,discontinued,categoryid)
VALUES (100,'Wheat bread','10',20,'true',5),
(101,'White bread','5 boxes',19.99,'false',5),
(102,'Midnight Mango Fizz','24-12 oz bottles',19,'false',1),
(103,'Savoury Fire Sauce','12-550ml bottles',10,'false',2)

--6a Update the price and discontinued status for from below table ‘updated_products’ only if there are matching products and updated_products .discontinued =0 
--We need to drop it for merge to happen as there is a foreign key constraint
ALTER TABLE products
DROP CONSTRAINT fk_category 

MERGE INTO products AS p
USING updated_products AS u
ON p.productid=u.productid
WHEN MATCHED  AND u.discontinued='false'THEN
UPDATE SET
unitprice=u.unitprice,
discontinued=u.discontinued
WHEN  NOT MATCHED THEN
INSERT(productId,productname,quantityPerUnit,unitPrice,discontinued,categoryid)
VALUES(u.productId,u.productname,u.quantityPerUnit,u.unitPrice,u.discontinued,u.categoryid)
SELECT * FROM products

--6b. If there are matching products and updated_products .discontinued =1 then delete
MERGE INTO products AS p
USING updated_products AS u
ON p.productid=u.productid
WHEN MATCHED  AND u.discontinued='true'THEN
DELETE

SELECT * FROM pro

--6c. Insert any new products from updated_products that don’t exist in products only if updated_products .discontinued =0.

INSERT INTO updated_products(productid,productName,quantityPerUnit,unitPrice,discontinued,categoryid)
VALUES ('104','dosa','8', 100,'true', 6),
('105','idli ','8', 100,'false', 6)
SELECT *  FROM updated_products
--In this we need only those data to get included whose discontinued is false
MERGE INTO products AS p
USING updated_products AS u
ON p.productid=u.productid
WHEN NOT MATCHED  AND u.discontinued='false'THEN
INSERT(productId,productname,quantityPerUnit,unitPrice,discontinued,categoryid)
VALUES(u.productId,u.productname,u.quantityPerUnit,u.unitPrice,u.discontinued,u.categoryid)
SELECT * FROM products