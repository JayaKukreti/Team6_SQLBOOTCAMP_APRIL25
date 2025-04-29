-- 1.      GROUP BY with WHERE - Orders by Year and Quarter
-- Display, order year, quarter, order count, avg freight cost only for those orders where freight cost > 100

SELECT 
	EXTRACT(YEAR FROM "orderDate") as OrderYear,
	EXTRACT(QUARTER FROM "orderDate") as OrderQuarter,
	COUNT("orderID") AS ORDERCOUNTS ,
	round(AVG(FREIGHT),2) as AverageFright
FROM PUBLIC.ORDERS
WHERE FREIGHT > 100
GROUP BY EXTRACT(YEAR FROM "orderDate") ,EXTRACT(QUARTER FROM "orderDate") 
order by EXTRACT(YEAR FROM "orderDate"), EXTRACT(QUARTER FROM "orderDate") asc;

-- 2. GROUP BY with HAVING - High Volume Ship Regions
-- Display, ship region, no of orders in each region, min and max freight cost
--  Filter regions where no of orders >= 5

select "shipperID",
	   count("orderID"),
	   min(freight),
	   max(freight) 
from public.orders 
group by "shipperID"
having count("orderID") >= 5

-- 3. Get all title designations across employees and customers ( Try UNION & UNION ALL)
select "contactTitle"
from public.customers 
UNION 
select (title)
from public.employees;

select "contactTitle" 
from public.customers 
UNION ALL
select title
from public.employees;


-- 4.Find categories that have both discontinued and in-stock products
-- (Display category_id, instock means units_in_stock > 0, Intersect)

select DISTINCT("categoryID")
from public.products
where discontinued = '1'
intersect
select DISTINCT("categoryID")
from  public.products
where "unitPrice" > 0;


-- 5.Find orders that have no discounted items (Display the  order_id, EXCEPT)
select DISTINCT(o."orderID"), p."productID",p.discontinued
from public.order_details o 
inner join public.products p on o."productID" = p."productID"
where p.discontinued = '0';







