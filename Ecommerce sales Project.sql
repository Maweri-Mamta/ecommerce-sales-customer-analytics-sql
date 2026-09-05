-- 1. CATEGORIES
DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 2. CUSTOMERS
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(100),
    join_date DATE
);


-- 3. PRODUCTS
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150),
    category_id INT,
    brand VARCHAR(100),
    price DECIMAL(10,2),
    stock INT,

    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);


-- 4. PAYMENTS
DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    payment_method VARCHAR(50),
    payment_status VARCHAR(30),
    amount DECIMAL(12,2),
    payment_date DATE
);


-- 5. ORDERS
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(30),
    payment_id INT,

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_order_payment
        FOREIGN KEY (payment_id)
        REFERENCES payments(payment_id)
);


-- 6. ORDER DETAILS
DROP TABLE IF EXISTS order_details;
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    line_total DECIMAL(12,2),

    CONSTRAINT fk_detail_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_detail_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);


SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM payments
SELECT * FROM products
SELECT * FROM orders
SELECT * FROM order_details

--Check Row count

SELECT 'categories' AS Table_name, COUNT(*) AS row_count
FROM categories

UNION ALL

SELECT 'customers', COUNT(*)
FROM customers

UNION ALL 

SELECT 'payments',COUNT(*)
FROM payments

UNION ALL 

SELECT 'products',COUNT(*)
FROM products

UNION ALL 

SELECT 'orders',COUNT(*)
FROM orders

UNION ALL

SELECT 'order_details', COUNT(*)
FROM order_details;


--Check Duplicates

SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*)>1;

SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*)>1;

SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*)>1;


SELECT order_detail_id, COUNT(*)
FROM order_details
GROUP BY order_detail_id
HAVING COUNT(*)>1;

--Check NULL Values
--CUSTOMER NULL CHECK
SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS customer_id,
    COUNT(first_name) AS first_name,
    COUNT(last_name) AS last_name,
    COUNT(gender) AS gender,
    COUNT(email) AS email,
    COUNT(phone) AS phone,
    COUNT(city) AS city,
    COUNT(state) AS state,
    COUNT(join_date) AS join_date
FROM customers;

--PRODUCT NULL CHECK
SELECT
    COUNT(*) AS total_rows,
    COUNT(product_id) AS product_id,
    COUNT(product_name) AS product_name,
    COUNT(category_id) AS category_id,
    COUNT(brand) AS brand,
    COUNT(price) AS price,
    COUNT(stock) AS stock
FROM products;

--ORDER NULL CHECK
SELECT
    COUNT(*) AS total_rows,
    COUNT(order_id) AS order_id,
    COUNT(customer_id) AS customer_id,
    COUNT(order_date) AS order_date,
    COUNT(order_status) AS order_status,
    COUNT(payment_id) AS payment_id
FROM orders;

--PAYMENT NULL CHECK
SELECT
    COUNT(*) AS total_rows,
    COUNT(payment_id) AS payment_id,
    COUNT(payment_method) AS payment_method,
    COUNT(payment_status) AS payment_status,
    COUNT(amount) AS amount,
    COUNT(payment_date) AS payment_date
FROM payments;

--ORDER_DETAILS NULL CHECK
SELECT
    COUNT(*) AS total_rows,
    COUNT(order_detail_id) AS order_detail_id,
    COUNT(order_id) AS order_id,
    COUNT(product_id) AS product_id,
    COUNT(quantity) AS quantity,
    COUNT(unit_price) AS unit_price,
    COUNT(line_total) AS line_total
FROM order_details;


-- Duplicate Customer IDs
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


--Duplicate Product IDs
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


--Duplicate Order IDs
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


--Invalid / Zero Quantity Check
SELECT *
FROM order_details
WHERE quantity <= 0;


--Invalid Price Check
SELECT *
FROM order_details
WHERE unit_price <= 0;


--Revenue Calculation Check
SELECT *
FROM order_details
WHERE line_total <> quantity * unit_price;


🎯 Q1 — Total Orders

Business Question:

--How many total orders are present in the e-commerce database?
SELECT COUNT(*) AS Total_orders
FROM orders;


--Q2.What is the total revenue generated from all orders?
SELECT SUM(line_total) AS Total_revenue
FROM order_details;


--Q3.What is the average amount spent per order?
SELECT SUM(line_total)/ COUNT(DISTINCT order_id) AS avg_order_value 
FROM order_details;


--Q4.How many total units/products have been sold across all orders?
SELECT SUM(quantity) AS total_quantity
FROM order_details;


--Q5.How many unique customers have placed orders?
SELECT COUNT(DISTINCT customer_id) AS customers
FROM orders;


--Q6.How much revenue did each product category generate?
SELECT SUM(od.line_total) AS total_revenue,c.category_name
FROM order_details od
JOIN products p
ON p.product_id=od.product_id
JOIN categories c
ON c.category_id=p.category_id
GROUP BY c.category_name;


--Q7.Which 10 products generated the highest revenue?
SELECT SUM(od.line_total) AS Total_revenue,p.product_name
FROM order_details od
JOIN products p
ON p.product_id=od.product_id
GROUP BY p.product_name
ORDER BY SUM(od.line_total)DESC limit 10;


--Q8.How much revenue did each brand generate?
SELECT SUM(od.line_total) AS total_revenue,p.brand
FROM order_details od
JOIN products p
ON p.product_id=od.product_id
GROUP BY p.brand;


--Q9.How much revenue did the business generate in each month?
SELECT DATE_TRUNC('Month',o.order_date)AS Month,
   SUM(line_total) AS total_revenue
FROM orders o
JOIN order_details od
ON o.order_id=od.order_id
GROUP BY Month
ORDER BY Month;


--Q10.How many orders were placed in each month?
SELECT DATE_TRUNC('Month',o.order_date)AS Month,
   COUNT (DISTINCT o.order_id)AS placed_order
FROM orders o
JOIN order_details od
ON o.order_id=od.order_id
GROUP BY Month
ORDER BY Month;


--Q11.Which 10 customers have spent the most money on the platform?
SELECT c.first_name,c.last_name,c.customer_id,
     SUM(od.line_total) AS Total_Spending
FROM orders o
JOIN order_details od
ON o.order_id=od.order_id
JOIN customers c
ON c.customer_id=o.customer_id
GROUP BY c.first_name,c.last_name,c.customer_id
ORDER BY Total_Spending DESC LIMIT 10;


--Q12.How many customers have placed more than one order?
SELECT COUNT(*) AS repeat_customers
FROM(
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id)>1
) AS repeat_customers;


--Q13.What is the Average amount spent per order in each month?
SELECT DATE_TRUNC('Month',o.order_date) AS Month,
    ROUND(
    SUM(od.line_total) / COUNT(DISTINCT o.order_id),2) AS Avg_order_value
FROM order_details od
JOIN orders o
ON o.order_id=od.order_id
GROUP BY Month
ORDER BY Month;


--Q14.How many customers have registered but never placed an order?
SELECT COUNT(*) AS customers_without_orders
FROM customers c
LEFT JOIN orders o
      ON c.customer_id=o.customer_id
WHERE o.order_id IS NULL;


--Q15 Which customers have placed the highest number of orders?
SELECT COUNT(DISTINCT o.order_id) AS Total_orders,
       c.customer_id,
	   c.first_name,
	   c.last_name
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_id,
         c.first_name,
		 c.last_name
ORDER BY Total_orders DESC LIMIT 10;


--Q16.Which 10 Products have sold the highest number of units?
SELECT
       p.product_name,
	   p.product_id,
	   SUM(od.quantity) AS Total_quantity_sold
FROM order_details od
JOIN products p
    ON p.product_id=od.product_id
GROUP BY p.product_name,p.product_id
ORDER BY Total_quantity_sold DESC LIMIT 10;


--Q17.How much revenue was generated through each payment method?
SELECT SUM(od.line_total) AS total_revenue,p.payment_method
FROM order_details od
JOIN orders o
ON o.order_id=od.order_id
JOIN payments p
ON o.payment_id=p.payment_id
GROUP BY p.payment_method
ORDER BY total_revenue DESC;


--Q18.Which cities generated the highest revenue?
SELECT c.city,
       SUM(od.line_total) AS Total_revenue
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_details od
ON od.order_id=o.order_id
GROUP BY c.city
ORDER BY Total_revenue DESC;


--Q19.What is the total amount spent by each customer?
SELECT c.customer_id,c.first_name,c.last_name,
       SUM(od.line_total) AS Total_spending
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_details od
ON od.order_id=o.order_id
GROUP BY c.customer_id,c.first_name,c.last_name
ORDER BY Total_spending DESC;



--Q20.What is the average amount spent per customer?
SELECT ROUND(
       SUM(od.line_total)/COUNT(DISTINCT c.customer_id),2)
	   AS Average_spending_per_customer
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_details od
ON od.order_id=o.order_id;



--Q21.How many orders are there for each order status?
SELECT order_status,
       COUNT(order_id) AS Total_orders
FROM orders
GROUP BY order_status;



--Q22. How many orders were cancelled, and what percentage of total orders were cancelled?
SELECT COUNT(*) FILTER(WHERE order_status='Cancelled') AS Cancelled_orders,
       COUNT(*) AS Total_orders,
	   ROUND(COUNT(*)FILTER (WHERE order_status='Cancelled')*100.00/COUNT(*),2)
	   AS Cancelled_percentage
FROM orders;



--Q23.What is the average order value for each payment method?
SELECT p.payment_method,
       ROUND(
       SUM(od.line_total)/COUNT(DISTINCT o.order_id),2) AS average_order_value	   
FROM payments p
JOIN orders o
     ON p.payment_id=o.payment_id
JOIN order_details od
     ON od.order_id=o.order_id
GROUP BY p.payment_method
ORDER BY average_order_value DESC;



--Q24.How much total revenue was generated for each order status?
SELECT o.order_status,
       SUM(od.line_total) AS Total_revenue
FROM orders o
JOIN order_details od
      ON o.order_id=od.order_id 
GROUP BY o.order_status
ORDER BY Total_revenue DESC;



--Q25.What is the month-over-month(MoM) revenue growth percentage?
WITH monthly_revenue AS(
SELECT 
      DATE_TRUNC('month' , o.order_date) AS month,
	  SUM(od.line_total) AS total_revenue
FROM orders o
JOIN order_details od
    ON o.order_id=od.order_id
GROUP BY month),

revenue_with_previous AS(
SELECT 
      month,
	  total_revenue,
	  LAG(total_revenue) OVER(ORDER BY month) AS previous_month_revenue
FROM monthly_revenue)

SELECT 
      month,
	  total_revenue,
	  previous_month_revenue,
	  ROUND(
      (total_revenue - previous_month_revenue)*100.0/previous_month_revenue,2)
	  AS MoM_growth_percentage
FROM revenue_with_previous	
ORDER BY month;



--Q26. What percentage of customers placed more than one order?
SELECT
      ROUND(
	  COUNT(*) FILTER(WHERE total_orders>1)*100.0/COUNT(*),2)
	  AS repeat_purchase_rate
FROM(
     SELECT
	    customer_id,
		COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id)
AS customer_orders;
  


--Q27.What percentage of total revenue does each product category contribute?
SELECT c.category_name,
       SUM(od.line_total) AS category_revenue,
	   ROUND(
	       SUM(od.line_total) * 100.0
		   /SUM(SUM(od.line_total)) OVER (),2)
		   AS revenue_contribution_percentage
FROM order_details od
JOIN products p
ON p.product_id=od.product_id
JOIN categories c
ON c.category_id=p.category_id
GROUP BY c.category_name
ORDER BY category_revenue DESC;



--Q28. Which product category has the highest average selling price?
SELECT c.category_name,
       ROUND(AVG(od.unit_price), 2) AS average_selling_price
FROM order_details od
JOIN products p
    ON p.product_id=od.product_id
JOIN categories c
    ON p.category_id=c.category_id
GROUP BY c.category_name
ORDER BY average_selling_price DESC
LIMIT 1;



--Q29. Which 10 products generated the highest total revenue?
SELECT p.product_id,p.product_name,
       SUM(od.line_total) AS total_revenue
FROM order_details od
JOIN products p
   ON p.product_id=od.product_id
GROUP BY 
      p.product_id,
      p.product_name
ORDER BY total_revenue DESC
LIMIT 10;



--Q30. How many customers fall into each spending category?
SELECT spending_category,
       COUNT(*) AS customer_count
FROM(
    SELECT
        c.customer_id,
		SUM(od.line_total) AS total_spending,
		CASE
		   WHEN SUM(od.line_total) > 100000
THEN 'High Value'
           WHEN SUM(od.line_total) >= 50000
THEN 'Medium Value'
           ELSE 'Low Value'
		 END AS spending_category
   FROM customers c
   JOIN orders o
       ON c.customer_id=o.customer_id
   JOIN order_details od
       ON o.order_id=od.order_id
   GROUP BY c.customer_id)
   AS customer_spending
   GROUP BY spending_category
   ORDER BY customer_count DESC;
   
