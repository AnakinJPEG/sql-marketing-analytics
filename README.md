# sql-marketing-analytics

# Marketing Analytics SQL Project

**Author:** Damian / AnakinJPEG  
**Date:** August, 2026  
**Database:** MySQL  

---

## Project Overview

This project simulates a **real‑world marketing analytics pipeline**. It demonstrates how to use SQL to track campaign performance, analyze customer behavior, and generate actionable business insights.

The database includes:
- Customers
- Campaigns
- Campaign contacts
- Conversions (purchases)
- Products

- Walkthrough:

https://sql-promo.s3.eu-north-1.amazonaws.com/index.html

!!! If for ANY Reason you experience delay, please download the video via the *download link* (three dots inside the video player).

---

## Key Business Questions Answered

This project answers the following questions using **SQL only**:

1. **Which campaigns have the highest conversion rate and ROI?**
2. **Which channels have the highest revenue**
3. **What does the funnel look like per channel?** (Contact → Conversion → Repeat)
4. **Which channel converts the fastest?** (Recency Analysis)
5. **Which campaigns should get more budget based on 7/30/90‑day performance?**

---

## SQL Skills Demonstrated

| Concept | Usage |
|--------|-------|
| **CTEs (`WITH`)** | Break down complex logic into readable steps |
| **Window Functions** | `RANK()`, `ROW_NUMBER()`, `SUM() OVER()`, `LAG()`, `LEAD()` |
| **Conditional Logic** | `CASE` statements for segmentation and recommendations |
| **Aggregations** | `COUNT(DISTINCT)`, `SUM()`, `AVG()`, `ROUND()` |
| **Joins** | `INNER JOIN`, `LEFT JOIN`, self‑joins, multi‑table joins |
| **Date Functions** | `DATEDIFF()`, `DATE_FORMAT()`, `MONTHNAME()` |
| **Subqueries** | Nested and correlated subqueries |

---

## Repository Structure

sql-marketing-analytics/
├── 📄 README.md
/sql
├── 📄 schema.sql # Database structure
├── 📄 sample_data.sql # Sample data (customers, campaigns, etc.)
├── 📄 complex-queries.sql # Complex Dashboard Queries (4 deliverables)
├── 📄 simple-queries.sql # Simple Dashboard Queries (4 deliverables)
/dashboard
├── complex-dashboard.json
├── simple-dashboard.json

---

## How to Run This Project

1. **Clone the repository**
2. **Run `schema.sql`** to create the database and tables
3. **Run `sample_data.sql`** to populate the tables with test data
4. **Run `simple-queries.sql` & `complex-queries.sql`** to see all analysis results
5. **Optionally**, run them as Stored Procedure (I have left a copy-paste blueprint in each .sql) to create reusable procedures

```sql
-- Example: Call the channel ranking procedure
CALL channel_performance();

```

## Tools Used:
- MySQL Workbench for query development
- Grafana for visualization & monitoring
- GitHub for version control

## About Author
Damian
damian.hristov@proton.me

I’m an aspiring data analyst with a passion for uncovering insights through SQL. This project is part of my portfolio to demonstrate my ability to work with real‑world data and deliver business value.


