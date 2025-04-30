
                                                  --Day 6
 
 
--1.Categorize products by stock status
--(Display product_name, a new column stock_status whose values are based on below condition
-- units_in_stock = 0  is 'Out of Stock'
--  units_in_stock < 20  is 'Low Stock')

select product_name,
case
    when units_in_stock = 0  then 'Out of Stock'
    when units_in_stock < 20  then 'Low Stock'
    else 'no stock'
end as stock_status
from products;
 
--2Find All Products in Beverages Category
--(Subquery, Display product_name,unitprice)
select product_name,unit_price
from products
where category_id=(
select category_id
from categories
 WHERE category_name = 'Beverages'
);
--3.Find Orders by Employee with Most Sales
--(Display order_id,   order_date,  freight, employee_id.
--Employee with Most Sales=Get the total no.of of orders for each employee then order by DESC and limit 1. Use Subquery)
select order_id,order_date,freight,employee_id
from orders
where employee_id=(
  select employee_id
  from(
  select employee_id, count(*) as totalorders
  from orders
  group by employee_id
 order by totalorders desc
 limit 1) as top_employee
);
 
---4.Find orders  where for country!= ‘USA’ with freight costs higher than any order from USA. (Subquery, Try with ANY, ALL operators)

select order_id,order_date,freight,ship_country
from orders
where ship_country!='USA'
and freight>any(
select freight
from orders
where ship_country='USA');


select order_id,order_date,freight,ship_country
from orders
where ship_country!='USA'
and freight>all(
select freight
from orders
where ship_country='USA');

)







































 
2.      Find All Products in Beverages Category
(Subquery, Display product_name,unitprice)
 
3.      Find Orders by Employee with Most Sales
(Display order_id,   order_date,  freight, employee_id.
Employee with Most Sales=Get the total no.of of orders for each employee then order by DESC and limit 1. Use Subquery)
 
4.      Find orders  where for country!= ‘USA’ with freight costs higher than any order from USA. (Subquery, Try with ANY, ALL operators)
 
 
 


