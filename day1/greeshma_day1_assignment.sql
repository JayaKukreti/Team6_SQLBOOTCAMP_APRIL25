--Categories table
CREATE TABLE categories (
categoryID INT PRIMARY KEY,
categoryName VARCHAR(200),
description TEXT
);

-- Employees Table
CREATE TABLE employees (
    employeeID INTEGER PRIMARY KEY,
    employeeName VARCHAR(100) NOT NULL,
    title VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50),
    reportsTo INTEGER,
    FOREIGN KEY (reportsTo) REFERENCES employees(employeeID)
);

-- Products Table
CREATE TABLE products (
    productID INT PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    quantityPerUnit VARCHAR(50),
    unitPrice NUMERIC,
    discontinued INT NOT NULL,
    categoryID INT,
    FOREIGN KEY (categoryID) REFERENCES categories(categoryID)
);


-- Shippers Table
CREATE TABLE shippers (
    shipperID INTEGER PRIMARY KEY,
    companyName VARCHAR(100) NOT NULL
);

-- Customers Table
CREATE TABLE customers (
    customerID VARCHAR(10) PRIMARY KEY,
    companyName VARCHAR(100) NOT NULL,
    contactName VARCHAR(100),
    contactTitle VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

-- Orders Table
CREATE TABLE orders (
    orderID INTEGER PRIMARY KEY,
    customerID VARCHAR(10) REFERENCES customers(customerID),
    employeeID INTEGER REFERENCES employees(employeeID),
    orderDate DATE,
    requiredDate DATE,
    shippedDate DATE,
    shipperID INTEGER REFERENCES shippers(shipperID),
    freight NUMERIC(10,2)
);

-- Order_details Table
CREATE TABLE order_details (
    orderID INTEGER REFERENCES orders(orderID),
    productID INTEGER REFERENCES products(productID),
    unitPrice NUMERIC,
    quantity INTEGER,
    discount NUMERIC,
    PRIMARY KEY (orderID, productID)
);

select * from categories
select * from customers
select * from  employees
select * from order_details
select * from orders
select * from products
select * from shippers


-- Why have I chose these constraints
/* Primary Key*/ 
-- As per the data dictionary the following columns uniquely identifies each record
-- categoryid, customerid, employeeid, shipperid, orderid, productid 

/* Composite Primary Key*/
-- (orderid, productid)  in order_details table
-- Because one order can have multiple products, and each product can be in multiple orders. 
-- The combination of orderid and productid ensures uniqueness.

/* Foreign Key*/
-- The following columns creates relationship between two tables. They refer to Primary Key in other Table
-- FOREIGN KEY (reportsTo) REFERENCES employees(employeeID)
-- FOREIGN KEY (categoryID) REFERENCES categories(categoryID)
-- customerID VARCHAR(10) REFERENCES customers(customerID)
-- employeeID INTEGER REFERENCES employees(employeeID)
-- shipperID INTEGER REFERENCES shippers(shipperID)
-- orderID INTEGER REFERENCES orders(orderID)
-- productID INTEGER REFERENCES products(productID)