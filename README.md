# 📊 Sales Analysis using SQL

> **An End-to-End SQL Data Analytics Project built using MySQL, Star Schema, CTEs, and Window Functions.**

---

## 📌 Project Overview

This project demonstrates an end-to-end Sales Analysis solution using **MySQL**. The project starts with raw sales data, performs data cleaning and transformation, designs a **Star Schema**, loads data into fact and dimension tables, and answers real-world business questions using SQL.

The objective is to transform raw transactional data into meaningful business insights that can support decision-making.

---

## 🎯 Project Objectives

* Clean and transform raw sales data
* Design a Star Schema
* Create Fact and Dimension tables
* Build business KPIs
* Perform sales performance analysis
* Practice advanced SQL concepts used in Data Analytics

---

## 🛠️ Tools & Technologies

| Technology  | Purpose             |
| ----------- | ------------------- |
| MySQL       | Database Management |
| SQL         | Data Analysis       |
| Git         | Version Control     |
| GitHub      | Project Hosting     |
| Star Schema | Data Modeling       |

---

# 📂 Dataset

The dataset contains sales transactions with the following attributes:

* Product Category
* Sale Date
* Region
* Customer Type
* Sales Representative
* Sales Channel
* Payment Method
* Quantity Sold
* Unit Cost
* Unit Price
* Discount
* Sales Amount

---

# 🧹 Data Cleaning

The following preprocessing steps were performed:

* Converted Sale Date into DATE format
* Removed the old date column
* Renamed the cleaned date column
* Recalculated Sales Amount using:

```sql
Sales_Amount = (Unit Price × Quantity Sold) × (1 − Discount)
```

---

# ⭐ Data Modeling

A **Star Schema** was implemented to improve query performance and simplify business reporting.

## Dimension Tables

* dim_product
* dim_date
* dim_region
* dim_customer
* dim_sales_rep
* dim_sales_channel
* dim_payment

## Fact Table

* fact_sales

---

# ⭐ Star Schema

```
                dim_product
                     |
dim_region ---- fact_sales ---- dim_customer
                     |
              dim_sales_rep
                     |
            dim_sales_channel
                     |
               dim_payment
                     |
                 dim_date
```

---

# 📊 Key Performance Indicators (KPIs)

The project calculates the following KPIs:

* ✅ Total Sales Revenue
* ✅ Total Quantity Sold
* ✅ Average Sales Amount
* ✅ Total Transactions
* ✅ Highest Sale
* ✅ Lowest Sale
* ✅ Total Profit
* ✅ Profit Margin

---

# 📈 Business Analysis

The following business questions were answered using SQL.

### 1. Product Category Performance

* Total Revenue by Product Category
* Total Quantity Sold
* Average Sales Amount

---

### 2. Regional Performance

* Revenue by Region
* Total Profit
* Profit Margin
* Number of Transactions

---

### 3. Top Sales Representatives

* Revenue Generated
* Total Profit
* Profit Margin
* Quantity Sold
* Total Transactions

---

### 4. Monthly Sales Trend Analysis

* Monthly Revenue
* Monthly Profit
* Monthly Quantity Sold
* Monthly Transactions

---

### 5. Revenue Contribution by Region

Calculated each region's contribution to total company revenue using **Common Table Expressions (CTEs)**.

---

### 6. Top Product Category in Each Region

Used the **DENSE_RANK()** Window Function to identify the highest revenue-generating product category within each region.

---

### 7. Month-over-Month Revenue Growth

Used the **LAG()** Window Function to calculate:

* Previous Month Revenue
* Revenue Growth
* Revenue Growth Percentage

---

# 💻 SQL Concepts Used

### SQL Fundamentals

* SELECT
* WHERE
* GROUP BY
* HAVING
* ORDER BY

### Joins

* INNER JOIN
* CROSS JOIN

### Aggregate Functions

* SUM()
* AVG()
* COUNT()
* MAX()
* MIN()

### Date Functions

* YEAR()
* MONTH()
* DAY()
* MONTHNAME()
* DAYNAME()
* QUARTER()

### Common Table Expressions (CTEs)

* WITH

### Window Functions

* LAG()
* DENSE_RANK()

### Database Concepts

* Primary Key
* Foreign Key
* Star Schema
* Fact Table
* Dimension Table

---

# 📁 Project Structure

```
Sales-Analysis-SQL
│
├── Dataset
│   └── sales_data.csv
│
├── SQL
│   ├── 01_Data_Cleaning.sql
│   ├── 02_Star_Schema.sql
│   ├── 03_Load_Fact_Table.sql
│   ├── 04_KPIs.sql
│   └── 05_Business_Analysis.sql
│
├── ERD
│   └── star_schema.png
│
├── Results
│   ├── KPI_Output.png
│   ├── Regional_Performance.png
│   ├── Monthly_Trend.png
│   ├── Revenue_Growth.png
│   └── Top_Product_Category.png
│
└── README.md
```

---

# 🚀 Key Business Insights

* Identified the highest revenue-generating product category.
* Compared sales performance across different regions.
* Evaluated the performance of sales representatives.
* Analyzed monthly sales trends.
* Calculated month-over-month revenue growth.
* Measured regional contribution to overall company revenue.
* Evaluated overall business profitability.

---

# 🎯 Skills Demonstrated

* Data Cleaning
* Data Modeling
* Star Schema Design
* SQL Query Writing
* Business KPI Development
* Data Analysis
* Analytical Thinking
* CTEs
* Window Functions
* Database Design

---

# 📚 Learning Outcomes

Through this project, I gained practical experience in:

* SQL for Data Analytics
* Data Cleaning
* Database Design
* Star Schema Modeling
* KPI Development
* Business Analysis
* Window Functions
* Analytical SQL

---

# 🚀 Future Enhancements

* Develop an interactive Power BI Dashboard
* Add Running Total Analysis
* Add Moving Average Analysis
* Perform Year-over-Year (YoY) Analysis
* Optimize SQL Queries using Indexes
* Create Stored Procedures

---

# 👨‍💻 Author

**Om Tripathi**

📧 Email: **[omt7060@gmail.com](mailto:omt7060@gmail.com)**

---

## ⭐ If you found this project interesting, feel free to star this repository!
