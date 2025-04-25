---1)      Update the categoryName From “Beverages” to "Drinks" in the categories table.
update categories
set categoryName='Drinks'
where categoryName='Beverages';

Select  * from categories ;

--2)      Insert into shipper new record (give any values) Delete that new record from shippers table.
 insert into shippers(shipperID,companyName)
 values(99,'fedex');

delete from shippers
where shipperID=99;

---3)      Update categoryID=1 to categoryID=1001. Make sure related products update their categoryID too. Display the both category and products table to show the cascade.
--- Delete the categoryID= “3”  from categories. Verify that the corresponding records are deleted automatically from products.
-- (HINT: Alter the foreign key on products(categoryID) to add ON UPDATE CASCADE, ON DELETE CASCADE)
alter table products
add constraint fk_categories
foreign key (categoryID)
REFERENCES Categories(CategoryID)
ON update cascade
on delete cascade;

update categories
set CategoryID=1001
where CategoryID=1;

delete from categories
where CategoryID=3;

select * from products;
select * from Categories
where CategoryID=3;

--4)      Delete the customer = “VINET”  from customers. Corresponding customers in orders table should be set to null 
--(HINT: Alter the foreign key on orders(customerID) to use ON DELETE SET NULL)

alter table orders
add constraint fk_customers
foreign key (customerID)
REFERENCES customers(customerID)
ON DELETE SET NULL;

ALTER TABLE orders
ALTER COLUMN customerID DROP NOT NULL;

ALTER TABLE customers
ALTER COLUMN customerID DROP NOT NULL;

delete from customers
where customerID='VINET';

select * from orders
where customerID is null;

select * from customers
where customerID='VINET';


---5)Insert the following data to Products using UPSERT:
--product_id = 100, product_name = Wheat bread, quantityperunit=1,unitprice = 13, discontinued = 0, categoryID=3

insert into products(productID,productName,quantityPerUnit,unitPrice,discontinued,categoryID)
values(100,'Wheat bread',1,13,'false',3)
on conflict(productID)
do update
set productName=excluded.productName,
    quantityPerUnit=excluded.quantityPerUnit,
	unitPrice=excluded.unitPrice,
	discontinued=excluded.discontinued,
    categoryID=excluded.categoryID;

ALTER TABLE products
DROP CONSTRAINT fk_categories;

insert into products(productID,productName,quantityPerUnit,unitPrice,discontinued,categoryID)
values(101,'Wheat bread',5,13,'false',3)
on conflict(productID)
do update
set productName=excluded.productName,
    quantityPerUnit=excluded.quantityPerUnit,
	unitPrice=excluded.unitPrice,
	discontinued=excluded.discontinued,
    categoryID=excluded.categoryID;

insert into products(productID,productName,quantityPerUnit,unitPrice,discontinued,categoryID)
values(100,'Wheat bread',10,13,'false',3)
on conflict(productID)
do update
set productName=excluded.productName,
    quantityPerUnit=excluded.quantityPerUnit,
	unitPrice=excluded.unitPrice,
	discontinued=excluded.discontinued,
    categoryID=excluded.categoryID;	
	
select * from products;

--6)Write a MERGE query:
--Create temp table with name:  ‘updated_products’ and insert values as below:

CREATE TABLE updated_products (
    productID integer PRIMARY KEY,
    productName TEXT NOT NULL,
    quantityPerUnit TEXT,
    unitPrice NUMERIC(10, 2),
    discontinued BOOLEAN,
    categoryID INTEGER
);
insert into updated_products
values(100,'Wheat bread',10,20,'true',3),
(101,'White bread','5 boxes',19.99,'false',3),
(102,'Midnight Mango Fizz','24 - 12 oz bottles',19,'false',1),
(103,'Savory Fire Sauce','12 - 550 ml bottles',10,'false',2);
select * from updated_products;

merge into products p
using updated_products up
on p.productid=up.productid
when matched and up.discontinued='false' then
update set
unitprice=up.unitprice,
discontinued=up.discontinued
when matched and up.diccontinued='true' then
delete
when not matched and up.discontinued=0 then
insert into updated_products;

MERGE INTO products p
USING updated_products up
ON p.productid = up.productid
WHEN MATCHED AND up.discontinued = false THEN
    UPDATE SET
        unitprice = up.unitprice,
        discontinued = up.discontinued
WHEN MATCHED AND up.discontinued = true THEN
    DELETE
WHEN NOT MATCHED AND up.discontinued = false THEN
    INSERT (productid, productname, unitprice,quantityPerUnit, discontinued,categoryid)
    VALUES (up.productid, up.productname, up.unitprice, up.quantityPerUnit,up.discontinued, up.categoryid);


select * from products where productid in(100,101,102,103);

-- 7.List all orders with employee full names. (Inner join)
  select * from orders o
  INNER JOIN employees e ON o.employee_id = e.employee_id;

