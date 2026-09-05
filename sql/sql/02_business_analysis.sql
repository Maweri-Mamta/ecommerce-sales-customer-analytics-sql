-- =========================================================
-- E-Commerce Sales & Customer Analytics
-- PostgreSQL / SQL Business Analysis
-- =========================================================


-- Q01. Total Revenue
SELECT
    SUM(line_total) AS total_revenue
FROM order_details;


-- Q02. Average Unit Price
SELECT
    ROUND(AVG(unit_price), 2) AS average_unit_price
FROM order_details;


-- Q03. Total Revenue and Total Orders
SELECT
    SUM(line_total) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_details;


-- Q04. Total Quantity Sold
SELECT
    SUM(quantity) AS total_quantity_sold
FROM order_details;


-- Q05. Number of Unique Customers
SELECT
    COUNT(DISTINCT customer_id) AS unique_customers
FROM orders;


-- Q06. Revenue by Category
SELECT
    c.category_name,
    SUM(od.line_total) AS total_revenue
FROM order_details od
JOIN products p
    ON p.product_id = od.product_id
JOIN categories c
    ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;


-- Q07. Top 10 Products by Revenue
SELECT
    p.product_id,
    p.product_name,
    SUM(od.line_total) AS total_revenue
FROM order_details od
JOIN products p
    ON p.product_id = od.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_revenue DESC
LIMIT 10;


-- Q08. Revenue by Brand
SELECT
    p.brand,
    SUM(od.line_total) AS total_revenue
FROM order_details od
JOIN products p
    ON p.product_id = od.product_id
GROUP BY p.brand
ORDER BY total_revenue DESC;


-- Q09. Monthly Revenue
SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(od.line_total) AS total_revenue
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY month
ORDER BY month;


-- Q10. Monthly Orders
SELECT
    DATE_TRUNC('month', order_date) AS month,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;


-- Q11. Top 10 Customers by Spending
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(od.line_total) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spending DESC
LIMIT 10;


-- Q12. Number of Repeat Customers
SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) AS repeat_customers;


-- Q13. Monthly Average Order Value (AOV)
SELECT
    DATE_TRUNC('month', o.order_date) AS month,
    ROUND(
        SUM(od.line_total) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY month
ORDER BY month;


-- Q14. Customers Who Never Placed an Order
SELECT
    COUNT(*) AS customers_without_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Q15. Top 10 Customers by Number of Orders
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_orders DESC
LIMIT 10;


-- Q16. Top 10 Best-Selling Products by Quantity
SELECT
    p.product_id,
    p.product_name,
    SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN products p
    ON p.product_id = od.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- Q17. Revenue by Payment Method
SELECT
    p.payment_method,
    SUM(od.line_total) AS total_revenue
FROM order_details od
JOIN orders o
    ON o.order_id = od.order_id
JOIN payments p
    ON o.payment_id = p.payment_id
GROUP BY p.payment_method
ORDER BY total_revenue DESC;


-- Q18. Revenue by Customer City
SELECT
    c.city,
    SUM(od.line_total) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY c.city
ORDER BY total_revenue DESC;


-- Q19. Customer Lifetime Value / Total Customer Spending
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(od.line_total) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spending DESC;


-- Q20. Average Spending per Customer
SELECT
    ROUND(
        SUM(od.line_total) / COUNT(DISTINCT c.customer_id),
        2
    ) AS average_spending_per_customer
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_details od
    ON o.order_id = od.order_id;


-- Q21. Orders by Order Status
SELECT
    order_status,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- Q22. Cancelled Orders and Cancellation Percentage
SELECT
    COUNT(*) FILTER (
        WHERE order_status = 'Cancelled'
    ) AS cancelled_orders,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) FILTER (
            WHERE order_status = 'Cancelled'
        ) * 100.0 / COUNT(*),
        2
    ) AS cancelled_percentage
FROM orders;


-- Q23. Average Order Value by Payment Method
SELECT
    p.payment_method,
    ROUND(
        SUM(od.line_total) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM payments p
JOIN orders o
    ON p.payment_id = o.payment_id
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY p.payment_method
ORDER BY average_order_value DESC;


-- Q24. Revenue by Order Status
SELECT
    o.order_status,
    SUM(od.line_total) AS total_revenue
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY o.order_status
ORDER BY total_revenue DESC;


-- Q25. Month-over-Month (MoM) Revenue Growth
SELECT
    month,
    total_revenue,
    previous_month_revenue,
    ROUND(
        (total_revenue - previous_month_revenue)
        * 100.0 / previous_month_revenue,
        2
    ) AS mom_growth_percentage
FROM (
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(od.line_total) AS total_revenue,
        LAG(SUM(od.line_total)) OVER (
            ORDER BY DATE_TRUNC('month', o.order_date)
        ) AS previous_month_revenue
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    GROUP BY DATE_TRUNC('month', o.order_date)
) AS revenue_data
ORDER BY month;


-- Q26. Repeat Purchase Rate
SELECT
    ROUND(
        COUNT(*) FILTER (
            WHERE total_orders > 1
        ) * 100.0 / COUNT(*),
        2
    ) AS repeat_purchase_rate
FROM (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
) AS customer_orders;


-- Q27. Revenue Contribution by Category
SELECT
    c.category_name,
    SUM(od.line_total) AS category_revenue,
    ROUND(
        SUM(od.line_total) * 100.0
        / SUM(SUM(od.line_total)) OVER (),
        2
    ) AS revenue_contribution_percentage
FROM order_details od
JOIN products p
    ON od.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY category_revenue DESC;


-- Q28. Category with Highest Average Selling Price
SELECT
    c.category_name,
    ROUND(AVG(od.unit_price), 2) AS average_selling_price
FROM order_details od
JOIN products p
    ON od.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY average_selling_price DESC
LIMIT 1;


-- Q29. Top 10 Products by Revenue
SELECT
    p.product_id,
    p.product_name,
    SUM(od.line_total) AS total_revenue
FROM order_details od
JOIN products p
    ON od.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_revenue DESC
LIMIT 10;


-- Q30. Customer Spending Segmentation
SELECT
    spending_category,
    COUNT(*) AS customer_count
FROM (
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
        ON c.customer_id = o.customer_id
    JOIN order_details od
        ON o.order_id = od.order_id
    GROUP BY c.customer_id
) AS customer_spending
GROUP BY spending_category
ORDER BY customer_count DESC;
