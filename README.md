# Olist E-Commerce Data Analysis Using PostgreSQL

## 1. Project Overview

This project analyzes the Brazilian Olist e-commerce dataset using PostgreSQL to evaluate sales performance, payment behavior, customer satisfaction, delivery efficiency, customer retention, and data quality.

The objective is to transform raw e-commerce data into meaningful business insights using SQL queries and analytical techniques. The project demonstrates how SQL can be used to investigate business problems, identify trends, and support data-driven decision-making.

## 2. Project Objectives

- Validate data quality and identify inconsistencies.
- Analyze revenue, order volume, and average order value.
- Identify top-performing product categories and sellers.
- Understand customer payment preferences.
- Evaluate delivery performance across Brazilian states.
- Investigate the relationship between delivery delays and customer satisfaction.
- Analyze repeat purchasing behavior and customer retention.
- Translate analytical findings into business recommendations.

## 3. Tools and Technologies

- **Database:** PostgreSQL
- **Database management tool:** pgAdmin
- **Query language:** SQL
- **SQL concepts:** Joins, aggregations, subqueries, Common Table Expressions (CTEs), window functions, CASE expressions, date functions, and data validation.

## 4. Dataset Description

The project uses the Olist Brazilian e-commerce dataset, which contains information about customers, sellers, products, orders, payments, reviews, and geographic locations.

| Table | Number of Records |
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

These counts represent the records loaded into the project database.

## 5. Repository Structure

```text
olist-ecommerce-sql-analysis/
├── 01_data_quality_validation.sql
├── 02_revenue_analysis.sql
└── README.md
```

### SQL Files

**`01_data_quality_validation.sql`**

Contains queries for validating data quality, checking duplicate records, identifying missing values, validating relationships between tables, and investigating anomalies in orders, payments, products, and delivery timestamps.

**`02_revenue_analysis.sql`**

Contains queries analyzing revenue, average order value, payment methods, product categories, regional sales, order cancellations, delivery performance, customer satisfaction, repeat customers, freight costs, and seller performance.

## 6. Analysis Performed

### A. Data Quality Validation

The data quality analysis includes:

- Duplicate identifier checks.
- Missing value analysis.
- Referential integrity checks.
- Order status distribution.
- Product price and payment validation.
- Review score validation.
- Order and delivery timestamp validation.
- Duplicate order item checks.
- Product category translation validation.
- Missing product measurements and weight validation.

### B. Revenue and Business Analysis

The business analysis includes:

- Total recorded payment value.
- Total order volume.
- Monthly revenue and order trends.
- Average order value.
- Revenue by payment method.
- Top-performing product categories.
- Best-selling products.
- Payment value by order status.
- Highest-value orders.
- Revenue by customer state.
- Average order value by state.
- Month-over-month revenue growth.
- Product category revenue contribution.
- Monthly cancellation rates.
- Average delivery time by state.
- Late delivery rates by state.
- Customer review score distribution.
- Delivery delays and customer review scores.
- Seller sales performance.
- Repeat customer analysis.
- Freight cost analysis by state.
- Seller sales and associated order review scores.

## 7. Key Business Findings

### 7.1 Revenue and Payment Behavior

- Total recorded payment value was approximately **R$16.01 million**.
- Average order value was approximately **R$160.99**.
- Credit cards accounted for approximately **78.35% of recorded payment value**, making them the dominant payment method.

### 7.2 Top Product Categories

The leading product categories by product sales value included:

| Product Category | Product Sales |
|---|---:|
| Health and Beauty | R$1,258,681.34 |
| Watches and Gifts | R$1,205,005.68 |
| Bed, Bath and Table | R$1,036,988.68 |
| Sports and Leisure | R$988,048.97 |
| Computers and Accessories | R$911,954.32 |

These product sales figures are based on item prices and exclude freight charges.

### 7.3 Regional Sales Performance

- São Paulo recorded the highest order volume among Brazilian states.
- Product sales associated with customers in São Paulo were approximately **R$5.20 million**.
- Regional analysis also revealed differences in average order value, delivery times, late delivery rates, and freight costs.

### 7.4 Customer Satisfaction

The review score distribution was:

| Review Score | Percentage of Reviews |
|---|---:|
| 1 Star | 11.51% |
| 2 Stars | 3.18% |
| 3 Stars | 8.24% |
| 4 Stars | 19.29% |
| 5 Stars | 57.78% |

Approximately **77.07% of reviews received four or five stars**, while approximately 14.69% received one or two stars.

### 7.5 Delivery Performance and Customer Satisfaction

The analysis compared average review scores for orders delivered late and orders delivered on time.

| Delivery Category | Reviewed Orders | Average Review Score |
|---|---:|---:|
| Late | 7,661 | 2.57 |
| On-time | 88,163 | 4.29 |

Orders delivered late had substantially lower average review scores than orders delivered on time.

This finding indicates an association between delivery performance and customer satisfaction. It does not establish that delivery delays alone caused lower review scores.

### 7.6 Customer Retention

The repeat customer analysis used unique customer identifiers to distinguish repeat purchasing from multiple orders associated with the same customer.

- Total unique customers: approximately 96,096.
- Repeat customers: approximately 2,997.
- Repeat customer rate: approximately **3.00%**.

This result highlights an opportunity to investigate customer retention and repeat purchasing behavior.

### 7.7 Data Quality Findings

The validation queries identified several issues requiring investigation:

- 610 products had no category information.
- 13 product category records were missing translations.
- Four products had zero recorded weight.
- Two products had all four product measurement fields missing.
- Some delivery records contained timestamp inconsistencies.
- Eight delivered orders lacked a customer delivery timestamp.
- Two delivered orders lacked a carrier handoff timestamp.

These findings demonstrate the importance of validating data before using it for business reporting and decision-making.

## 8. Business Recommendations

Based on the findings, the following actions could be considered:

### 1. Improve Delivery Reliability

Investigate late deliveries and identify regional logistics bottlenecks. Prioritize further analysis of states with higher late delivery rates.

### 2. Improve Customer Satisfaction

Investigate low-rated orders to understand whether delivery delays, product issues, or service problems are associated with negative customer experiences.

### 3. Strengthen Customer Retention

Analyze repeat purchasing patterns and investigate opportunities to encourage existing customers to make additional purchases.

### 4. Optimize Regional Operations

Compare sales, average order value, delivery time, and freight costs across states to identify regional differences and potential operational improvements.

### 5. Improve Data Quality

Investigate missing product attributes, category information, and inconsistent delivery timestamps to improve the reliability of future reporting.

### 6. Monitor Business Performance

Track revenue, order volume, cancellation rates, payment method distribution, delivery performance, and customer satisfaction to support ongoing business decisions.

These recommendations are proposed actions based on the analysis, not outcomes of business changes already implemented.

## 9. Limitations

- The analysis uses a historical dataset and may not represent current business performance.
- Some months, particularly the final months, contain relatively few records and may be incomplete.
- Month-over-month growth comparisons can be affected by missing months.
- Product sales and recorded payment value are different measures. Product sales calculations exclude freight where specified.
- Customer reviews are associated with orders and do not necessarily measure individual seller performance independently.
- Associations between delivery performance and customer satisfaction do not establish causation.
- Data quality issues may affect the interpretation of some results and require further investigation.

## 10. Conclusion

This project demonstrates how PostgreSQL can be used to validate e-commerce data, investigate data quality issues, analyze sales performance, and extract actionable business insights.

By combining data validation with revenue, delivery, customer satisfaction, regional performance, and retention analysis, the project illustrates how SQL supports data-driven business decision-making.

The project also demonstrates practical SQL skills relevant to Data Analyst roles, including joins, aggregations, CTEs, window functions, date-based analysis, and translating query results into business recommendations.

## 11. Skills Demonstrated

- PostgreSQL and SQL query writing.
- Data cleaning and validation.
- Data aggregation and transformation.
- Relational joins and subqueries.
- Common Table Expressions (CTEs).
- Window functions.
- Revenue and business analysis.
- Customer behavior analysis.
- Delivery performance analysis.
- Data interpretation and business recommendations.

## Author

**Adarsh V S**

Aspiring Data Analyst | PostgreSQL | SQL | Data Analysis
