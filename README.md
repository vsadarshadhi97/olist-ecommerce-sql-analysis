# Olist E-Commerce Data Analysis Using PostgreSQL

## Project Overview

This project analyzes the Brazilian Olist e-commerce dataset using PostgreSQL to understand sales performance, customer satisfaction, delivery efficiency, payment behavior, and data quality.

The goal is to transform raw e-commerce data into actionable business insights using SQL.

## Objectives

- Validate data quality and identify inconsistencies.
- Analyze revenue, order volume, and average order value.
- Identify top-performing product categories and sellers.
- Evaluate payment methods and customer purchasing behavior.
- Investigate delivery delays and their relationship with customer reviews.
- Analyze repeat customer behavior and regional performance.

## Tools and Technologies

- PostgreSQL
- pgAdmin
- SQL
- Common Table Expressions (CTEs)
- Window functions
- Joins and aggregations
- Date and time functions

## Dataset

The project uses the Olist Brazilian e-commerce dataset, covering customers, sellers, products, orders, payments, reviews, and geographic information.

| Table | Records |
|---|---:|
| Customers | 99,441 |
| Sellers | 3,095 |
| Products | 32,951 |
| Orders | 99,441 |
| Order Items | 112,650 |
| Order Payments | 103,886 |
| Order Reviews | 99,224 |
| Product Category Translation | 71 |
| Geolocation | 1,000,163 |

## Project Structure

```text
Olist_Ecommerce_SQL_Project/
├── 01_data_quality_validation.sql
├── 02_revenue_analysis.sql
└── README.md
```

## Analysis Performed

### 1. Data Quality Validation

- Duplicate identifier checks
- Missing value analysis
- Referential integrity checks
- Order status validation
- Price and payment validation
- Review score validation
- Delivery date anomaly checks
- Product category and measurement validation

### 2. Revenue and Business Analysis

- Total recorded payment value
- Average order value
- Monthly revenue and order volume
- Revenue by payment method
- Product category and product sales
- Revenue by customer state
- Month-over-month revenue growth
- Order cancellation rates
- Delivery performance by state
- Customer review distribution
- Repeat customer analysis
- Freight cost analysis
- Seller sales and associated customer review scores

## Key Business Findings

### Revenue and Payments

- Total recorded payment value was approximately **R$16.01 million**.
- Average order value was approximately **R$160.99**.
- Credit cards represented approximately **78.35%** of recorded payment value.
- São Paulo was the largest state market by order volume and product sales.

### Customer Satisfaction

- **57.78%** of reviews received five stars.
- **77.07%** of reviews received four or five stars.
- **14.69%** of reviews received one or two stars.

### Delivery Performance

| Delivery Category | Reviewed Orders | Average Review Score |
|---|---:|---:|
| Late | 7,661 | 2.57 |
| On-time | 88,163 | 4.29 |

Late-delivered orders had substantially lower average review scores than on-time orders. This indicates an association between delivery performance and customer satisfaction, not proof of causation.

### Customer Retention

- Approximately **96,096 unique customers** were identified.
- Approximately **2,997 customers** placed repeat orders.
- The repeat-customer rate was approximately **3.00%**.

## Business Recommendations

1. Investigate late deliveries and identify regional logistics bottlenecks.
2. Examine low-rated orders to understand potential delivery and product-related issues.
3. Investigate opportunities to improve repeat purchasing and customer retention.
4. Compare regional revenue, average order value, and freight costs.
5. Improve data quality by investigating missing product attributes and inconsistent delivery timestamps.

## Limitations

- The analysis is based on the available historical dataset.
- Some final months contain very few records and may be incomplete.
- Month-over-month growth can be affected by missing months.
- Customer reviews alone cannot establish the cause of dissatisfaction.
- Recorded payment value and product sales represent different measures.

## Conclusion

This project demonstrates the use of PostgreSQL for data validation, business analysis, customer behavior analysis, and performance monitoring. It showcases how SQL can support data-driven business decisions.

## Author

**Adarsh**

Aspiring Data Analyst | PostgreSQL | Data Analysis
