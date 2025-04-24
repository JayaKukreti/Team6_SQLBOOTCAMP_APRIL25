

CREATE TABLE employees (
    employeeID INTEGER PRIMARY KEY,
	employeeName VARCHAR(50),
	title VARCHAR(50),
	city VARCHAR(50),
	country VARCHAR(50),
	reportsTO INTEGER
);


CREATE TABLE customers (
    customerID VARCHAR(50) PRIMARY KEY,
	companyName VARCHAR(100),
	CONTACTName VARCHAR(50),
	contactTitle VARCHAR(50),
	city VARCHAR(50),
	country VARCHAR(50)
);


CREATE TABLE shippers (
     shipperID INTEGER PRIMARY KEY,
	 companyName VARCHAR(50)
);



CREATE TABLE products (
     productID INTEGER PRIMARY KEY,
	 productName VARCHAR(50),
	 quantityPerUnit VARCHAR(50),
	 unitPrice NUMERIC(10,2) NOT NULL,
	 discontinued BOOLEAN,
	 categoryID INTEGER
);

CREATE TABLE order_details (
    orderID INTEGER NOT NULL,
    productID INTEGER NOT NULL,
    unitPrice NUMERIC(10, 2) NOT NULL,
    quantity INTEGER NOT NULL,
    discount NUMERIC(10, 2) DEFAULT 0.00,
    PRIMARY KEY (orderID, productID)
);

CREATE TABLE orders (
    orderID SERIAL PRIMARY KEY,
	customerID TEXT not null,
    employeeID INTEGER NOT NULL,
    orderDate DATE NOT NULL,
    requiredDate DATE,
    shippedDate DATE,
    shipperID INTEGER,
    freight NUMERIC(10, 2)
);

CREATE TABLE categories (
     categoryID INTEGER PRIMARY KEY,
     categoryName VARCHAR(50),
     description VARCHAR(100)
);

select * from employees;

select * from customers;

select * from shippers;

select * from products;

select * from order_details;

select * from orders;

select * from categories;

