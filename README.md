# 🛒 NovaStore DB Management & Analytics System

<p align="center">
  <img src="https://img.shields.io/badge/SQL%20Server-NovaStoreDB-blue?style=for-the-badge&logo=microsoftsqlserver" alt="SQL Server Badge" />
  <img src="https://img.shields.io/badge/Database-E--Commerce%20System-2ea44f?style=for-the-badge&logo=databricks" alt="Database Badge" />
  <img src="https://img.shields.io/badge/Language-T--SQL-orange?style=for-the-badge&logo=sqlite" alt="T-SQL Badge" />
</p>

<p align="center">
  End-to-end Microsoft SQL Server project covering OLTP design, analytics, star schema modeling, indexing, and transaction management.
</p>

---

## 📌 Overview

**NovaStore DB** is a comprehensive relational database project built with **Microsoft SQL Server** and **T-SQL**. It models a realistic e-commerce workflow and bridges the gap between transactional processing and analytical reporting.

This project demonstrates a complete data lifecycle:

- normalized **OLTP** schema design
- sample data seeding
- complex business and analytical queries
- transformation into a **Star Schema (OLAP)** for data warehousing
- performance testing with indexing
- ACID-compliant transaction handling

---

## 🚀 Key Features

- **Robust OLTP Architecture:** Normalized tables for categories, products, customers, orders, and order details with primary and foreign keys.
- **Data Warehouse Transformation (ETL):** Transforms transactional data into a Star Schema using `dim_customer`, `dim_product`, and `Fact_Sales`.
- **Advanced Analytical Querying:** Uses CTEs and window functions such as `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, and `SUM`.
- **Performance Tuning Simulation:** Generates 100,000 mock products to demonstrate the difference between table scans and non-clustered index seeks.
- **ACID Transaction Management:** Uses `TRY...CATCH`, `BEGIN TRANSACTION`, `COMMIT`, and `ROLLBACK` to protect data consistency.

---

## 🗄️ Database Schema

### Transactional Setup (OLTP)

| Table | Description |
| --- | --- |
| `Categories` | Stores product categories |
| `Products` | Stores product name, price, stock, and category reference |
| `Customers` | Stores customer information |
| `Orders` | Stores order headers and totals |
| `OrderDetails` | Stores order line items |

### Analytical Setup (OLAP - Star Schema)

| Table | Description |
| --- | --- |
| `dim_customer` | Customer dimension for analytical reporting |
| `dim_product` | Product dimension for analytical slicing and filtering |
| `Fact_Sales` | Fact table containing measurable sales data |

---

## ⚙️ Getting Started

To run this project locally:

1. Install **Microsoft SQL Server** and **SQL Server Management Studio (SSMS)** or **Azure Data Studio**.
2. Clone this repository to your machine.
3. Open the script file `NovaStoreDB;.sql` in your SQL client.
4. Run the full script from top to bottom.
   - The script includes a teardown section using `DROP ... IF EXISTS` to avoid conflicts on repeated execution.
5. Optional: create the `C:\Yedek\` directory on the SQL Server host if you want the backup command to run successfully.

> Note: The script is designed as a self-contained demo and includes schema creation, data insertion, analytics queries, OLAP transformation, indexing, and transaction examples.

---

## 🧠 Learning Outcomes & Demonstrated Skills

- **Database Normalization & Constraints:** Maintaining data integrity across relational tables.
- **Data Engineering & ETL Concepts:** Converting OLTP data into OLAP-ready dimension and fact tables.
- **Query Optimization:** Using execution statistics and indexing to compare performance patterns.
- **Error Handling:** Preventing partial writes with transaction control and exception handling.
- **Analytical SQL:** Working with joins, aggregations, CTEs, and window functions.

---

## 🔍 Script Highlights

### OLTP Schema Creation
Creates the core transactional tables with identity primary keys and foreign key relationships.

### Analytical Queries
Includes practical queries for:

- low stock alerts
- customer order history
- deep multi-table joins
- customer lifetime value
- order aging analysis
- ranking and retention analysis
- cumulative sales tracking
- monthly sales growth

### View Layer
A reusable view named **`vw_SiparisOzet`** combines customer, order, and product data for reporting.

### Performance Test
The script generates **100,000 mock product records** and compares:

- baseline query performance without an index
- optimized query performance after creating `IX_ProductName`

### Transaction Example
A mock checkout flow demonstrates:

- order creation
- order detail insertion
- stock deduction
- rollback on error

### Backup Command
The script includes a SQL Server backup command:

```sql
BACKUP DATABASE NovaStoreDB TO DISK = 'C:\Yedek\NovaStoreDB.bak';
```

---

## 🛠️ Technologies Used

- Microsoft SQL Server
- T-SQL
- Relational Database Design
- DDL / DML / DQL
- CTEs and Window Functions
- Star Schema / OLAP Concepts
- Database Indexing
- Transaction Management
- SQL Server Backup Operations

---

## 📚 Learning Outcomes

This project helped strengthen skills in:

- schema design
- normalization and constraint management
- analytical SQL writing
- ETL-style transformation
- performance analysis
- backup and maintenance operations
- data warehouse modeling
- robust transaction handling

---


