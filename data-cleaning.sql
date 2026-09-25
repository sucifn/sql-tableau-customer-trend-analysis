## Data Cleaning - SQL

-- DATA CLEANING
-- 1. Remove Duplicates
-- check duplicates
WITH duplicate_cte_customers AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY customer_id, gender, city, `signup_date`, loyalty_member) AS row_num
FROM customers
)
SELECT *
FROM duplicate_cte_customers
WHERE row_num > 1;

WITH duplicate_cte_orders AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY order_id, customer_id, product_id, `order_date`, quantity, payment_method) AS row_num
FROM orders
)
SELECT *
FROM duplicate_cte_orders
WHERE row_num > 1;

WITH duplicate_cte_products AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY product_id, product_name, category, price) AS row_num
FROM products
)
SELECT *
FROM duplicate_cte_products
WHERE row_num > 1;

-- delete duplicates from customers table with create new table and add row_num column
SELECT * 
FROM orders;

CREATE TABLE `customer_trend`.`orders_staging`
(`order_id` text,
`customer_id` text,
`product_id` text,
`order_date` text,
`quantity` text,
`payment_method` text,
`row_num` int
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM orders_staging
WHERE row_num > 1;

INSERT INTO `customer_trend`.`orders_staging`
(`order_id`,
`customer_id`,
`product_id`,
`order_date`,
`quantity`,
`payment_method`,
`row_num`)
SELECT `order_id`,
`customer_id`,
`product_id`,
`order_date`,
`quantity`,
`payment_method`,
		ROW_NUMBER() OVER(
		PARTITION BY order_id, customer_id, product_id, order_date, quantity, payment_method) AS row_num
		FROM customer_trend.orders;

DELETE FROM customer_trend.orders_staging
WHERE row_num >= 2;

-- 2. Sandardize Data
-- change the inconsistent city Notingham with Nottingham
SELECT DISTINCT city
FROM customers
ORDER BY city;

SELECT *
FROM customers
WHERE city = 'Notingham';

UPDATE customers
SET city = 'Nottingham'
WHERE city = 'Notingham';

-- fix the format column 
ALTER TABLE customers
MODIFY COLUMN `signup_date` DATE;

ALTER TABLE orders_staging
MODIFY COLUMN `order_date` DATE;

ALTER TABLE customers
MODIFY COLUMN age INT;

ALTER TABLE orders_staging
MODIFY COLUMN quantity INT;

-- 3. Check Null Values
-- there isn't null values

-- 4. Add Columns
-- add total revenue column in orders
SELECT 
t1.product_id,
t1.quantity,
t2.price,
(t1.quantity * t2.price) AS revenue
FROM orders_staging t1
INNER JOIN products t2
	ON t1.product_id = t2.product_id;

ALTER TABLE orders_staging
ADD revenue INT;

UPDATE orders_staging t1
INNER JOIN products t2 
	ON t1.product_id = t2.product_id
SET t1.revenue = (t1.quantity * t2.price);

-- add age group column in customers
ALTER TABLE customers
ADD age_group VARCHAR(50);

UPDATE customers
SET age_group = CASE
	WHEN age <= 19  THEN 'Teenager'
    WHEN age BETWEEN 20 AND 29 THEN 'Young Adult'
    WHEN age BETWEEN 30 AND 39 THEN 'Adult'
	WHEN age BETWEEN 40 AND 59 THEN 'Middle-Aged'
	ELSE 'Senior'
END;

-- 5. Remove any Columns
ALTER TABLE orders_staging
DROP COLUMN row_num;
