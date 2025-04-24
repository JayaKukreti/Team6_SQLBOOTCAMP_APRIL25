----categories-----
CREATE TABLE categories(
categoryID SERIAL PRIMARY KEY, 
categoryName VARCHAR(200)NOT NULL UNIQUE, 
description TEXT)
--SERIAL--auto-incrementing primary key---
---PRIMARY KEY --------
--UNIQUE should not be empty and its should be not repetative---
SELECT * FROM categories

------customers-------
CREATE TABLE customers(
customerID CHAR(5)PRIMARY KEY,
companyName VARCHAR(200),
contactName VARCHAR(50),
contactTitle VARCHAR(50),
city VARCHAR(50),
country VARCHAR(50)
)
--customerID  acts as a PRIMARY KEY   
SELECT * FROM customers;

------employees-----
CREATE TABLE employees(
employeeID INT PRIMARY KEY,
employeeName TEXT NOT NULL,
title TEXT,
city TEXT,
country TEXT, 
reportsTo INT,
FOREIGN KEY(reportsTo)REFERENCES employees(employeeID)
)
--employeeID PRIMARY KEY- Acts as a primary key.
--employeeName NOT NULL - Column should not have null Value
--FOREIGN KEY(reportsTo)REFERENCES- self-referencing foreign key
select * FROM employees

---orders----
CREATE TABLE orders(
orderID INT PRIMARY KEY,
customerID CHAR(5)REFERENCES customers(customerID),
employeeID INT REFERENCES employees(employeeID),
orderDate DATE,
requiredDate DATE,
shippedDate DATE,
shipperID INT REFERENCES shippers(shipperID),
freight DECIMAL(10,2)
)
--orderID primary key- Act as Primary key
--customerID, employeeID, shipperID: Foreign keys to their respective tables
SELECT * FROM orders
 ----order_details------
CREATE TABLE order_details(
orderID INT REFERENCES orders(orderID),
productID INT REFERENCES products(productID),
unitPrice DECIMAL(10,2),
quantity INT,
discount DECIMAL(10,2),
PRIMARY KEY(orderID,productID) ---its a composite primary key to avoid duplication
)
-- orderID ,productID : Foreign keys to their respective tables
--PRIMARY KEY -Ensures that each product appears only once per order
SELECT * FROM order_details;
----products----
CREATE TABLE products(
productID SERIAL PRIMARY KEY,
productName TEXT NOT NULL,
quantityPerUnit TEXT,
unitPrice DECIMAL(10,2),
discontinued BOOLEAN, 
categoryID INT REFERENCES categories(categoryID)
)
DROP TABLE products
----shippers----
CREATE TABLE shippers(
shipperID SERIAL PRIMARY KEY,
companyName TEXT NOT NULL
)
SELECT * FROM shippers