create view vw_product_sales_summary AS
select 
    p.product_name,
    c.category_name,
    sum(od.quantity) as total_units_sold,
    sum(od.quantity * od.unit_price) as total_revenue
from products p
join order_details od on p.product_id=od.product_id
join categories c on p.category_id=c.category_id
group by p.product_name, c.category_name; 

select *  from vw_product_sales_summary;