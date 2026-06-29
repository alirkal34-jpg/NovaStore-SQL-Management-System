# NovaStore DB Management System

<p align="center">
  <img src="https://img.shields.io/badge/SQL%20Server-NovaStoreDB-blue?style=for-the-badge&logo=microsoftsqlserver" alt="SQL Server Badge" />
  <img src="https://img.shields.io/badge/Database-E--Commerce%20System-2ea44f?style=for-the-badge&logo=databricks" alt="Database Badge" />
  <img src="https://img.shields.io/badge/Language-T--SQL-orange?style=for-the-badge&logo=sqlite" alt="T-SQL Badge" />
</p>

<p align="center">
  A structured SQL Server project designed for an e-commerce database management system.
</p>

---

## Overview

**NovaStore DB Management System** is a relational database project built with **Microsoft SQL Server** and **T-SQL**.  
It models a realistic e-commerce workflow with tables for categories, products, customers, orders, and order details.

The script also includes:

- Schema teardown and recreation for repeatable execution
- Sample data seeding
- Analytical SQL queries
- Window functions and CTE examples
- A reusable SQL view
- OLAP-style dimension and fact tables
- Indexing simulation
- Transaction management with TRY...CATCH

---

## Database Schema

### OLTP Tables

| Table | Description |
|------|-------------|
| `Categories` | Stores product categories |
| `Products` | Stores product name, price, stock, and category reference |
| `Customers` | Stores customer information |
| `Orders` | Stores order headers and totals |
| `OrderDetails` | Stores order line items |

### OLAP Tables

| Table | Description |
|------|-------------|
| `dim_customer` | Customer dimension for analytical reporting |
| `dim_product` | Product dimension for analytical reporting |
| `Fact_Sales` | Sales fact table for warehouse-style analysis |

---

## Main Features

- Clean relational schema design
- Identity-based primary keys
- Foreign key constraints for data integrity
- Sample data for real-world testing
- JOIN-based reporting queries
- Aggregate and time-based analysis
- CTEs and window functions
- SQL View for simplified reporting
- Backup command for database export
- Star schema transformation for OLAP-style analysis
- Transaction handling for order processing
- Index creation and query performance demonstration

---

## Sample Queries Included

This project includes practical SQL examples such as:

- Listing low-stock products
- Displaying customer order history
- Showing purchased product details by customer
- Counting products per category
- Calculating total revenue per customer
- Measuring days since each order was placed
- Finding latest orders per customer
- Comparing `RANK()` and `DENSE_RANK()`
- Running total and growth analysis
- Monthly sales aggregation

---

## Advanced Database Objects

### View
A reusable view named **`vw_SiparisOzet`** combines customer, order, and product data into a single reporting layer.

### Backup
The project also includes a SQL Server backup command:

```sql
BACKUP DATABASE NovaStoreDB TO DISK = 'C:\Yedek\NovaStoreDB.bak';
```

---

## Performance and Transaction Examples

The SQL script also demonstrates:

- Generating mock product data for performance testing
- Comparing table scans and index seeks
- Creating a non-clustered index on `PRODUCT_NAME`
- Using `BEGIN TRY...BEGIN CATCH` for transaction safety
- Rolling back failed checkout operations

---

## Technologies Used

- Microsoft SQL Server
- T-SQL
- Relational Database Design
- DDL / DML / DQL
- Window Functions
- CTEs
- Star Schema / OLAP Concepts
- Database Indexing
- Transaction Management

---

## Learning Outcomes

This project helped strengthen skills in:

- Database normalization
- Schema design
- Constraint management
- Query writing
- Joins and aggregation
- SQL views
- Data analysis
- Backup and maintenance operations
- Data warehouse modeling
- Performance optimization basics

---

## Source

This README was updated by reading the `NovaStoreDB;.sql` script in the repository.
