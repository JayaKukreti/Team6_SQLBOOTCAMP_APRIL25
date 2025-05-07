--1.Write  a function to Calculate the total stock value for a given category:
(Stock value=ROUND(SUM(unit_price * units_in_stock)::DECIMAL, 2)
Return data type is DECIMAL(10,2)

CREATE OR REPLACE FUNCTION get_total_stock_value(cate_name TEXT)
RETURNS DECIMAL(10,2)
AS $$
BEGIN
    RETURN ROUND(
        (
            SELECT SUM(unit_price * units_in_stock)::DECIMAL
            FROM products p
            JOIN categories c ON p.category_id = c.category_id
            WHERE c.category_name = cate_name
        ), 2
    );
END;
$$ 
LANGUAGE plpgsql;

SELECT get_total_stock_value('Beverages');

--
2.	Try writing a   cursor query which I executed in the training.

CREATE OR REPLACE PROCEDURE update_prices_with_cursor()
LANGUAGE plpgsql
AS $$
DECLARE 
    product_cursor CURSOR FOR
        SELECT product_id, product_name, unit_price, units_in_stock
        FROM products
        WHERE discontinued = 0;
        
    product_record RECORD;
    v_new_price DECIMAL(10,2);
BEGIN
    OPEN product_cursor;
    
    LOOP 
        FETCH product_cursor INTO product_record;
        EXIT WHEN NOT FOUND;

        IF product_record.unit_price < 10 THEN
            v_new_price := product_record.unit_price * 1.10;
        ELSE
            v_new_price := product_record.unit_price * 0.95;
        END IF;

        UPDATE products
        SET unit_price = ROUND(v_new_price, 2)
        WHERE product_id = product_record.product_id;

        RAISE NOTICE 'Updated %: old price = %, new price = %',
            product_record.product_name,
            product_record.unit_price,
            v_new_price;
    END LOOP;
    
    CLOSE product_cursor;
END;
$$;
CALL update_prices_with_cursor();