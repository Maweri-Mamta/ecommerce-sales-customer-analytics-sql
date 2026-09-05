# 🛒 E-Commerce Sales & Customer Analytics — SQL Project

## 📌 Project Overview

This project focuses on analyzing an e-commerce dataset using **PostgreSQL and SQL** to understand sales performance, customer behavior, product performance, and order trends.

The project includes data quality checks and business-focused SQL analysis to generate meaningful insights from raw transactional data.

---

## 🎯 Project Objectives

- Analyze overall sales and revenue performance
- Identify top-performing products and categories
- Understand customer purchasing behavior
- Analyze monthly sales trends
- Measure customer spending and repeat purchases
- Analyze payment methods and order statuses
- Segment customers based on their spending

---

## 🛠️ Tools & Technologies

- **Database:** PostgreSQL
- **SQL Tool:** pgAdmin 4
- **Language:** SQL
- **Version Control:** GitHub

---

## 🗂️ Dataset

The dataset contains six tables:

| Table | Description |
|---|---|
| `customers` | Customer information |
| `categories` | Product category information |
| `products` | Product details |
| `orders` | Order transactions |
| `order_details` | Product-level order details |
| `payments` | Payment information |

### Dataset Size

- Customers: **1,000**
- Categories: **15**
- Products: **500**
- Payments: **5,000**
- Orders: **5,000**
- Order Details: **15,007**

---

## 🔍 Data Quality Checks

Before performing business analysis, the data was validated using SQL.

Checks included:

- Row count validation
- NULL value checks
- Duplicate ID checks
- Invalid quantity checks
- Invalid price checks
- Revenue calculation validation

---

## 📊 Business Analysis

The project includes **30 SQL business analysis queries**, covering:

### Sales Analysis
- Total revenue
- Total orders
- Total quantity sold
- Monthly revenue
- Monthly orders
- Revenue by category
- Revenue by brand
- Revenue by payment method
- Revenue by order status

### Product Analysis
- Top 10 products by revenue
- Top 10 products by quantity sold
- Category with highest average selling price
- Revenue contribution by category

### Customer Analysis
- Unique customers
- Top customers by spending
- Top customers by number of orders
- Customer Lifetime Value
- Average spending per customer
- Repeat customers
- Repeat purchase rate
- Customers who never placed an order
- Customer spending segmentation

### Order Analysis
- Order status analysis
- Cancelled orders
- Cancellation percentage
- Average Order Value (AOV)
- Monthly AOV
- Month-over-Month revenue growth

---

## 🧠 SQL Concepts Used

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- LIMIT
- Aggregate Functions
- JOINs
- LEFT JOIN
- CASE WHEN
- Subqueries
- CTEs
- Window Functions
- `LAG()`
- `FILTER`
- `DATE_TRUNC()`
- `ROUND()`

---

## 📁 Project Structure

```text
ecommerce-sales-customer-analytics-sql/
│
├── README.md
│
└── sql/
    ├── 01_data_quality_checks.sql
    └── 02_business_analysis.sql
