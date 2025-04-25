-- 1)      Update the categoryName From “Beverages” to "Drinks" in the categories table.

SELECT *
FROM CATEGORIES;


SELECT *
FROM ORDERS;


SELECT *
FROM PRODUCTS;


UPDATE PUBLIC.CATEGORIES
SET "categoryName" = 'Drinks'
WHERE "categoryName" = 'Beverages';

-- 2)      Insert into shipper new record (give any values) Delete that new record from shippers table.

SELECT *
FROM SHIPPERS;


INSERT INTO PUBLIC.SHIPPERS ("shipperID",

																					"companyName")
VALUES (12345,'vasavi shipping corporation');


DELETE
FROM SHIPPERS
WHERE "shipperID" = 12345;

-- 3)      Update categoryID=1 to categoryID=1001. Make sure related products update their categoryID too.
-- Display the both category and products table to show the cascade.
--  Delete the categoryID= “3”  from categories. Verify that the corresponding records are deleted automatically from products.
--  (HINT: Alter the foreign key on products(categoryID) to add ON UPDATE CASCADE, ON DELETE CASCADE, add ON DELETE CASCADE for order_details(productid) )

ALTER TABLE PUBLIC.PRODUCTS
DROP CONSTRAINT FK_CATEGORIES_CATEGORYID;


ALTER TABLE PUBLIC.PRODUCTS ADD CONSTRAINT FK_CATEGORIES_CATEGORYID
FOREIGN KEY ("categoryID") REFERENCES CATEGORIES ("categoryID") ON
UPDATE CASCADE ON
DELETE CASCADE;


ALTER TABLE PUBLIC.ORDER_DETAILS
DROP CONSTRAINT ORDER_DETAILS_PRODUCT_FKEY ;


ALTER TABLE PUBLIC.ORDER_DETAILS ADD CONSTRAINT FK_PRODUCTS_PRODUCTID
FOREIGN KEY ("productID") REFERENCES PRODUCTS ("productID") ON
UPDATE CASCADE ON
DELETE CASCADE;

-- Update categoryID=1 to categoryID=1001. Make sure related products update their categoryID too.

UPDATE PUBLIC.CATEGORIES
SET "categoryID" = 1001
WHERE "categoryID" = 1 -- Display the both category and products table to show the cascade

	SELECT *
	FROM CATEGORIES WHERE "categoryID" = 3;


SELECT *
FROM PRODUCTS
WHERE "categoryID" = 3;


SELECT *
FROM ORDER_DETAILS
WHERE "productID" = 19;

--  Delete the categoryID= “3”  from categories. Verify that the corresponding records are deleted automatically from products.

DELETE
FROM PUBLIC.CATEGORIES
WHERE "categoryID" = 3;

-- 5)      Insert the following data to Products using UPSERT:
-- product_id = 100, product_name = Wheat bread, quantityperunit=1,unitprice = 13, discontinued = 0, categoryID=5
-- product_id = 101, product_name = White bread, quantityperunit=5 boxes,unitprice = 13, discontinued = 0, categoryID=5
-- product_id = 100, product_name = Wheat bread, quantityperunit=10 boxes,unitprice = 13, discontinued = 0, categoryID=5
-- (this should update the quantityperunit for product_id = 100)

SELECT *
FROM PRODUCTS
WHERE "productID" in (100,
																							101,
																							100);


INSERT INTO PRODUCTS ("productID",

														"productName",
														"quantityPerUnit",
														"unitPrice",
														DISCONTINUED,
														"categoryID")
VALUES (100,'Wheat bread',10,13,'0',5),
							(101,'White bread',5,13,'0',5) ON CONFLICT ("productID") DO
UPDATE
SET "productName" = EXCLUDED."productName",
	"quantityPerUnit" = EXCLUDED."quantityPerUnit",
	"unitPrice" = EXCLUDED."unitPrice",
	DISCONTINUED = EXCLUDED.DISCONTINUED,
	"categoryID" = EXCLUDED."categoryID";

/**6)      Write a MERGE query:
Create temp table with name:  ‘updated_products’ and insert values as below:

productID
productName
quantityPerUnit
unitPrice
discontinued
categoryID
2
 Update the price and discontinued status for from below table ‘updated_products’ only if
there are matching products and updated_products .discontinued =0

If there are matching products and updated_products .discontinued =1 then delete

 Insert any new products from updated_products that don’t exist in products only if updated_products .discontinued =0.**/ --  create a temp table to hold the data

CREATE TEMP TABLE UPDATED_PRODUCTS ("productID" integer NOT NULL,
																																					"productName" CHARACTER VARYING(55),
																																					"quantityPerUnit" CHARACTER VARYING(55),
																																					"unitPrice" numeric, DISCONTINUED boolean, "categoryID" integer, PRIMARY KEY ("productID"))
DELETE
FROM UPDATED_PRODUCTS ;

-- Insert data into temp table

INSERT INTO UPDATED_PRODUCTS
VALUES (1000,'Wheat bread', '10', 20,'1',5),
							(1010,'White bread', '5 boxes UPDATED', 39.99,'0',5),
							(1040,'MidNight Mango Fizz', '2 - 12 oz bottles', 19,'0',2),
							(1050,'Savory Fire Sauce', '12 - 550 ml bottles', 10,'0',2);

-- Validate the data in temp table

SELECT *
FROM UPDATED_PRODUCTS;

SELECT *
FROM PRODUCTS
WHERE "productID" IN (1000,1010,1050,1040);

SELECT *
FROM CATEGORIES;

-- Update products table using conditions

MERGE INTO PRODUCTS P USING UPDATED_PRODUCTS U ON P."productID" = U."productID" WHEN MATCHED
AND U.DISCONTINUED = '1' THEN
DELETE WHEN MATCHED
AND U.DISCONTINUED = '0' THEN
UPDATE
SET "productID" = U."productID",
	"productName" = U."productName",
	"quantityPerUnit" = U."quantityPerUnit",
	"unitPrice" = U."unitPrice",
	DISCONTINUED = U.DISCONTINUED,
	"categoryID" = U."categoryID" WHEN NOT MATCHED THEN
INSERT ("productID",
									"productName",
									"quantityPerUnit",
									"unitPrice",
									DISCONTINUED,
									"categoryID")
VALUES (U."productID", U."productName", U."quantityPerUnit", U."unitPrice", U.DISCONTINUED, U."categoryID") RETURNING *;