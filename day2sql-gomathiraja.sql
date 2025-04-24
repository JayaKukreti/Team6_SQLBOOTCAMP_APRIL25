                                --1.Alter Table

 --Add a new column linkedin_profile to employees table to store LinkedIn URLs as varchar.

alter table employees
add column linkedin_profile varchar(50);

--Change the linkedin_profile column data type from VARCHAR to TEXT.
alter table employees
alter column linkedin_profile type text;

 --Add unique, not null constraint to linkedin_profile
--alter table employees
--alter column linkedin_profile set not null;check

alter table employees 
ADD CONSTRAINT unique_linkedin_profile UNIQUE (linkedin_profile);

--Drop column linkedin_profile

alter table employees
drop column  linkedin_profile;
                        ---2.Querying (Select)
 --Retrieve the first name, last name, and title of all employees
select employeename, title from employees;

--Find all unique unit prices of products 
select distinct unitprice from products;
 --List all customers sorted by company name in ascending order
 select * from customers
 order by companyname;
 --Display product name and unit price, but rename the unit_price column as price_in_usd 
SELECT productname, unitprice AS price_in_usd
FROM products;                             


                                       ----3.Filtering
--Get all customers from Germany.
select customerid from customers
where country='Germany';
--Find all customers from France or Spain
select customerid from customers
where country='France'or country='Spain';
--Retrieve all orders placed in 1997 (based on order_date), and either have freight greater than 50 or the shipped date available (i.e., non-NULL)  (Hint: EXTRACT(YEAR FROM order_date))

select orderID from orders
where extract(year from orderDate)=2014
and (freight>50 or shippedDate is not null);

                                   --4.Filtering
 --Retrieve the product_id, product_name, and unit_price of products where the unit_price is greater than 15.
select productid, productname,unitprice
from products
where unitprice>50;

 --List all employees who are located in the USA and have the title "Sales Representative".
 select employeeID,employeeName
 from employees
 where country='USA' and title='Sales Representative';
 
--Retrieve all products that are not discontinued and priced greater than 30.
select productID,productName
from products
where discontinued=false and unitPrice<30;

                                --5.LIMIT/FETCH
-- Retrieve the first 10 orders from the orders table.
select * from orders
limit 10;
-- Retrieve orders starting from the 11th order, fetching 10 rows (i.e., fetch rows 11-20).

select * from orders
offset 10
limit 10;

                                --6.Filtering (IN, BETWEEN)
--List all customers who are either Sales Representative, Owner

select customerid,contactname
from customers
where contacttitle in('Sales Representative','Owner');

--Retrieve orders placed between January 1, 2013, and December 31, 2013.
select orderID
from orders
where orderDate between '2013-01-01' and '2013-12-31';

                             --7. Filtering
--List all products whose category_id is not 1, 2, or 3.

select productName
from products
where categoryID not in(1,2,3);

--Find customers whose company name starts with "A".
select customerid,contactname
from customers
where contactname like 'A%';

                        --8. INSERT into orders table:
insert into orders( orderID,customerID,employeeID,orderDate,requiredDate,shippedDate,shipperID,freight)
values(11078,'ALFKI',5,'2025-04-23',' 2025-04-30','2025-04-25',2,45.50);

 --9.Increase(Update)  the unit price of all products in category_id =2 by 10%.
(HINT: unit_price =unit_price * 1.10)

update products
set unitprice =unitprice * 1.10
where categoryid=2;


