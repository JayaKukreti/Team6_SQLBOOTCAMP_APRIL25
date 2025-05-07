-----------------------Day 10 Assignment--------------------------

1.	--Write  a function to Calculate the total stock value for a given category:
--(Stock value=ROUND(SUM(unit_price * units_in_stock)::DECIMAL, 2)
--Return data type is DECIMAL(10,2)

CREATE OR REPLACE FUNCTION get_stock_value_by_category(
    p_category_id INT
)
RETURNS DECIMAL(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock_value DECIMAL(10,2);
BEGIN
    SELECT ROUND(SUM(unit_price * units_in_stock)::DECIMAL, 2)
    INTO v_stock_value
    FROM products
    WHERE category_id = p_category_id;

    RETURN COALESCE(v_stock_value, 0.00);
END;
$$;

SELECT get_stock_value_by_category(7);

select *from products where category_id =7

select count(*), unit_price , units_in_stock 
from products 
where category_id =7
group by unit_price , units_in_stock ;

==============================================================
2.Try writing a cursor query which I executed in the training.
 CREATE OR REPLACE PROCEDURE update_price_with_cursor()--name of the store procedure
 LANGUAGE plpgsql
 AS $$
 DECLARE --starting of the cursor
product_cursor CURSOR FOR
    SELECT product_id,product_name,unit_price,units_in_stock
    FROM products
	WHERE discontinued= 0 ;

	product_record RECORD ;
	v_new_unit_price DECIMAL(10,2);
BEGIN --open the cursor
  open product_cursor;
  loop -- fetch the next row
  FETCH product_cursor INTO product_record;
  --exit when no more row to fetch
EXIT WHEN NOT FOUND;
--  CALCULATE NEW PRICE
if product_record.units_in_stock<10 THEN
v_new_unit_price := product_record.unit_price*1.10;
ELSE
v_new_unit_price := product_record.unit_price*0.95;
END IF;
UPDATE products
SET unit_price=ROUND(v_new_unit_price,2)
WHERE product_id=product_record.product_id;

RAISE NOTICE 'Updated %: old price = %, new price = %',
 product_record.product_name,
 product_record.unit_price,
 v_new_unit_price;
 END LOOP;
 CLOSE product_cursor;
 END;
 $$
 --to execut
 CALL update_price_with_cursor()

