----------------------------------------- Day 10 Assignment ------------------------------------------------------------------------------

--Qn1.Write  a function to Calculate the total stock value for a given category:
--   (Stock value=ROUND(SUM(unit_price * units_in_stock)::DECIMAL, 2)
--   Return data type is DECIMAL(10,2)

create or replace function get_stock_value_by_category(
    in p_category_id int
)
returns decimal(10,2)
language plpgsql
as $$
declare
    v_stock_value decimal(10,2);
begin
    select 
        round(sum(unit_price * units_in_stock)::decimal, 2)
    into 
        v_stock_value
    from 
        products
    where 
        category_id = p_category_id;

    return coalesce (v_stock_value, 0.00);
end;
$$;

select get_stock_value_by_category(7);

select *from products where category_id =7

select count(*), unit_price , units_in_stock 
from products 
where category_id =7
group by unit_price , units_in_stock ;



--Qn2.Try writing a cursor query which I executed in the training.
--  This cursor will iterate through products and adjust prices based on units in stock

CREATE OR REPLACE PROCEDURE update_prices_with_cursor()
LANGUAGE plpgsql
AS $$
DECLARE 
product_cursor CURSOR FOR
      SELECT product_id,product_name,unit_price,units_in_stock
      FROM products 
      WHERE discontinued =0 ;

 product_record RECORD;
 v_new_price DECIMAL(10,2);
 BEGIN 
    --open the cursor
    OPEN product_cursor;

    LOOP
    --fetch the next row
	FETCH product_cursor INTO product_record;
	
	--Exit whn no more rows to fetch
	EXIT WHEN NOT FOUND;

	--calculate new price
	IF product_record.units_in_stock < 10 THEN
	   v_new_price := product_record.unit_price * 1.1;-- 10% increase
    ELSE 
	   v_new_price := product_record.unit_price * 0.95;-- 5% increase
	END IF;

	--update the product
	UPDATE products
	SET unit_price = ROUND (v_new_price,2)
	WHERE product_id =product_record.product_id;

	--log  the change
	RAISE NOTICE 'updated% price from % to %',
	   product_record.product_name,
	   product_record.unit_price,
	   v_new_price;
	 END LOOP;

	 -- close the cursor
	 CLOSE product_cursor;
	 END;
	 $$;

	 --TO execute:
	 CALL update_prices_with_cursor();













	 
	