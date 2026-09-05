-- =========================================================
-- E-Commerce Sales & Customer Analytics
-- Data Quality Checks
-- =========================================================


-- 1. Row Count Check
SELECT 'categories' AS table_name, COUNT(*) AS row_count
FROM categories

UNION ALL

SELECT 'customers', COUNT(*)
FROM customers

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'payments', COUNT(*)
FROM payments

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_details', COUNT(*)
FROM order_details;


-- 2. NULL Value Check - Customers
SELECT *
FROM customers
WHERE customer_id IS NULL
   OR first_name IS NULL
   OR last_name IS NULL;


-- 3. NULL Value Check - Products
SELECT *
FROM products
WHERE product_id IS NULL
   OR product_name IS NULL
   OR category_id IS NULL;


-- 4. NULL Value Check - Orders
SELECT *
FROM orders
WHERE order_id IS NULL
   OR customer_id IS NULL
   OR order_date IS NULL;


-- 5. NULL Value Check - Order Details
SELECT *
FROM order_details
WHERE order_id IS NULL
   OR product_id IS NULL
   OR quantity IS NULL
   OR unit_price IS NULL
   OR line_total IS NULL;


-- 6. Duplicate Customer IDs
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 7. Duplicate Product IDs
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- 8. Duplicate Order IDs
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- 9. Invalid / Zero Quantity Check
SELECT *
FROM order_details
WHERE quantity <= 0;


-- 10. Invalid Price Check
SELECT *
FROM order_details
WHERE unit_price <= 0;


-- 11. Revenue Calculation Check
SELECT *
FROM order_details
WHERE line_total <> quantity * unit_price;
