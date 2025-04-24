
-- Creation of orders table
CREATE TABLE public.orders
(
    "orderID" integer NOT NULL,
    "customerID" character varying(55),
    "employeeID" integer,
    "orderDate" date,
    "requiredDate" date,
    "shippedDate" date,
    "shipperID" integer,
    freight numeric,
    PRIMARY KEY ("orderID"),
    CONSTRAINT order_customer_fkey FOREIGN KEY ("customerID")
        REFERENCES public.customers ("customerID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT order_employee_fkey FOREIGN KEY ("employeeID")
        REFERENCES public.employees ("employeeID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT order_shipper_fkey FOREIGN KEY ("shipperID")
        REFERENCES public.shippers ("shipperID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.orders
    OWNER to postgres;
	
-- create order_details table
CREATE TABLE public.order_details
(
    "orderID" integer,
    "productID" integer,
    "unitPrice" numeric,
    quantity integer,
    discount numeric,
    CONSTRAINT order_details_order_fkey FOREIGN KEY ("orderID")
        REFERENCES public.orders ("orderID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT order_details_product_fkey FOREIGN KEY ("productID")
        REFERENCES public.products ("productID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.order_details
    OWNER to postgres;
	
-- create customer table

CREATE TABLE public.customers
(
    "customerID" character varying(25) NOT NULL,
    "companyName" character varying(55),
    "contactName" character varying(55),
    city character varying(55),
    country character varying(55),
    CONSTRAINT "customerID" PRIMARY KEY ("customerID")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.customers
    OWNER to postgres;
	
--create table product
CREATE TABLE public.products
(
    "productID" integer NOT NULL,
    "productName" character varying(55),
    "quantityPerUnit" character varying(55),
    "unitPrice" numeric,
    discontinued boolean,
    "categoryID" integer,
    PRIMARY KEY ("productID"),
    CONSTRAINT product_category_fkey FOREIGN KEY ("categoryID")
        REFERENCES public.categories ("categoryID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.products
    OWNER to postgres;
	
--create table categories
CREATE TABLE public.categories
(
    "categoryID" integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    "categoryName" character varying(55),
    description character varying(255),
    PRIMARY KEY ("categoryID")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.categories
    OWNER to postgres;
-- create table employees
	
	CREATE TABLE public.employees
(
    "employeeID" integer NOT NULL,
    "employeeName" character varying(55),
    title character varying(55),
    city character varying(55),
    country character varying(55),
    "reportsTo" integer,
    PRIMARY KEY ("employeeID")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.employees
    OWNER to postgres;
	

-- create table shipper
		CREATE TABLE public.shippers
(
    "shipperID" integer NOT NULL,
    "companyName" character varying(55),
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.shippers
    OWNER to postgres;
	


	

