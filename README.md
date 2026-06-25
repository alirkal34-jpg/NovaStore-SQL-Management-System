# NovaStore DB Management System

<p align="center">
  <img src="https://img.shields.io/badge/SQL%20Server-NovaStoreDB-blue?style=for-the-badge&logo=microsoftsqlserver" alt="SQL Server Badge" />
  <img src="https://img.shields.io/badge/Database-E--Commerce%20System-2ea44f?style=for-the-badge&logo=databricks" alt="Database Badge" />
  <img src="https://img.shields.io/badge/Language-T--SQL-orange?style=for-the-badge&logo=sqlite" alt="T-SQL Badge" />
</p>

<p align="center">
  A sleek and structured SQL Server project designed for an e-commerce database management system.
</p>

---

## Overview

**NovaStore DB Management System** is a relational database project built with **Microsoft SQL Server** and **T-SQL**.  
It models a realistic e-commerce workflow with tables for products, categories, customers, orders, and order details.

The project demonstrates:

- Database schema design
- Primary and foreign key relationships
- Data insertion and management
- Analytical SQL queries
- View creation
- Backup operations

---

## Database Diagram

<p align="center">
  <img src="image1" alt="NovaStore Database Diagram" />
</p>

---

## Core Features

- Clean relational schema design
- Identity-based primary keys
- Foreign key constraints for data integrity
- Sample data for real-world testing
- JOIN-based reporting queries
- Aggregate and time-based analysis
- SQL View for simplified reporting
- Backup command for database export

---

## Tables

| Table | Description |
|------|-------------|
| `Categories` | Stores product categories |
| `Products` | Stores product name, price, stock, and category reference |
| `Customers` | Stores customer information |
| `Orders` | Stores order headers and totals |
| `OrderDetails` | Stores order line items |

---

## Sample Queries Included

This project includes practical SQL examples such as:

- Listing low-stock products
- Displaying customer order history
- Showing purchased product details by customer
- Counting products per category
- Calculating total revenue per customer
- Measuring days since each order was placed

---

## Advanced Objects

### View
A reusable view named **`vw_SiparisOzet`** combines customer, order, and product data into a single reporting layer.

### Backup
The project also includes a SQL Server backup command:

```sql
BACKUP DATABASE NovaStoreDB TO DISK = 'C:\Yedek\NovaStoreDB.bak';
```

---

## Technologies Used

- Microsoft SQL Server
- T-SQL
- Relational Database Design
- DDL / DML / DQL
- DB Diagram tools

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

---

