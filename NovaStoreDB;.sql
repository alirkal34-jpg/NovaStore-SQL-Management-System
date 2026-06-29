USE NovaStoreDB;
GO

-- ======================================================================
-- PART 0: SCHEMA TEARDOWN
-- Description: Clean up existing tables and views to prevent conflicts
-- during multiple executions of the script.
-- ======================================================================

DROP VIEW IF EXISTS vw_SiparisOzet;
DROP TABLE IF EXISTS OrderDetails; 
DROP TABLE IF EXISTS Orders;       
DROP TABLE IF EXISTS Fact_Sales;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS Products;     
DROP TABLE IF EXISTS Customers;    
DROP TABLE IF EXISTS Categories;  
GO

-- ======================================================================
-- PART 1: RELATIONAL DATABASE SCHEMA CREATION (OLTP)
-- Description: Establishing the core transactional tables with 
-- Primary Keys, Foreign Keys, and basic constraints.
-- ======================================================================

-- 1. CATEGORIES TABLE
CREATE TABLE Categories (
    CATEGORY_ID INT IDENTITY(1,1) PRIMARY KEY,
    CATEGORY_NAME VARCHAR(100) NOT NULL
);

-- 2. PRODUCTS TABLE
CREATE TABLE Products (
    PRODUCT_ID INT IDENTITY(1,1) PRIMARY KEY,
    PRODUCT_NAME VARCHAR(100) NOT NULL,
    PRICE DECIMAL(10,2) NOT NULL,
    STOCK INT DEFAULT 0,
    CATEGORY_ID INT,
    CONSTRAINT FK_CATEGORY FOREIGN KEY(CATEGORY_ID) REFERENCES Categories(CATEGORY_ID)
);

-- 3. CUSTOMERS TABLE
CREATE TABLE Customers(
    CUSTOMER_ID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);

-- 4. ORDERS TABLE
CREATE TABLE Orders(
      OrderID INT IDENTITY(1,1) PRIMARY KEY,
      CustomerID INT,
      OrderDate DATETIME DEFAULT GETDATE(),
      TotalAmount DECIMAL(10,2) NOT NULL, 
      CONSTRAINT FK_CUSTOMER FOREIGN KEY(CustomerID) REFERENCES Customers(CUSTOMER_ID)
);

-- 5. ORDER DETAILS TABLE
CREATE TABLE OrderDetails(
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    Product_ID INT,
    Quantity INT NOT NULL,
    CONSTRAINT FK_ORDER FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_PRODUCT FOREIGN KEY(Product_ID) REFERENCES Products(PRODUCT_ID)
);

-- ======================================================================
-- PART 2: SEEDING INITIAL DATA
-- Description: Inserting mock data into the OLTP tables for analysis.
-- ======================================================================

-- Insert 5 Different Categories
INSERT INTO Categories (CATEGORY_NAME) VALUES 
('Electronics'), ('Clothing'), ('Books'), ('Cosmetics'), ('Home & Living');

-- Insert 10 Different Products
INSERT INTO Products (PRODUCT_NAME, PRICE, STOCK, CATEGORY_ID) VALUES 
('Gaming PC', 35000.00, 15, 1), 
('Smartphone', 22000.00, 25, 1),    
('Classic Leather Jacket', 2500.00, 40, 2),   
('Cotton T-Shirt', 450.00, 100, 2),      
('Learning SQL Book', 350.00, 8, 3),
('Data Science Guide', 420.00, 12, 3),   
('Moisturizing Cream', 180.00, 50, 4),    
('Perfume EDP', 1200.00, 18, 4),          
('Office Desk', 2100.00, 5, 5),       
('Orthopedic Pillow', 650.00, 30, 5);     

-- Insert 5 Different Customers
INSERT INTO Customers (FullName, City, Email) VALUES 
('Ahmet Yilmaz', 'Istanbul', 'ahmet@mail.com'),
('Mehmet Ozturk', 'Ankara', 'mehmet@mail.com'),
('Ayse Demir', 'Izmir', 'ayse@mail.com'),
('Canan Kaya', 'Bursa', 'canan@mail.com'),
('Ali Can', 'Antalya', 'alican@mail.com');

-- Insert 8 Different Orders
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES 
(1, '2026-06-01 10:00:00', 35450.00), 
(1, '2026-06-15 14:30:00', 450.00),   
(2, '2026-05-20 11:15:00', 22000.00), 
(3, '2026-06-10 09:00:00', 2500.00),  
(4, '2026-04-01 16:45:00', 1380.00),  
(5, '2026-06-22 18:20:00', 2100.00),  
(2, '2026-06-23 12:00:00', 420.00),   
(3, '2026-06-24 15:00:00', 1200.00);  

-- Insert Order Details
INSERT INTO OrderDetails (OrderID, Product_ID, Quantity) VALUES 
(1, 1, 1), (1, 5, 1), (2, 4, 1), (3, 2, 1), 
(4, 3, 1), (5, 7, 1), (5, 8, 1), (6, 9, 1), 
(7, 6, 1), (8, 8, 1);  

-- ======================================================================
-- PART 3: BASIC QUERYING & DATA ANALYSIS (DQL)
-- Description: Core SELECT statements, JOINs, and Aggregations.
-- ======================================================================

-- 1. Low Stock Alert (Filtering & Sorting)
-- List products with stock under 20, ordered from highest to lowest stock.
SELECT PRODUCT_NAME, STOCK 
FROM Products 
WHERE STOCK < 20 
ORDER BY STOCK DESC;

-- 2. Customer Order History (Data Merging)
-- Display Customer Name, City, Order Date, and Amount using INNER JOIN.
SELECT FullName, City, OrderDate, TotalAmount 
FROM Customers
INNER JOIN Orders ON Customers.CUSTOMER_ID = Orders.CustomerID;

-- 3. Comprehensive Deep Join (5-Table Join)
-- List the names, prices, and categories of products purchased by 'Ahmet Yilmaz'.
SELECT PRODUCT_NAME, PRICE, CATEGORY_NAME 
FROM Products 
INNER JOIN Categories ON Products.CATEGORY_ID = Categories.CATEGORY_ID
INNER JOIN OrderDetails ON Products.PRODUCT_ID = OrderDetails.Product_ID
INNER JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CUSTOMER_ID
WHERE FullName = 'Ahmet Yilmaz';

-- 4. Category Product Distribution (Grouping & Aggregation)
-- Calculate the total number of distinct products in each category.
SELECT CATEGORY_NAME, COUNT(*) AS ProductCount 
FROM Products
LEFT JOIN Categories ON Products.CATEGORY_ID = Categories.CATEGORY_ID
GROUP BY CATEGORY_NAME;

-- 5. Customer Lifetime Value (Turnover Analysis)
-- Calculate total revenue generated by each customer, ranked highest to lowest.
SELECT FullName, SUM(TotalAmount) AS TotalRevenue 
FROM Customers 
INNER JOIN Orders ON Customers.CUSTOMER_ID = Orders.CustomerID
GROUP BY FullName
ORDER BY TotalRevenue DESC;

-- 6. Order Aging (Time Analysis)
-- Calculate how many days have passed since each order was placed.
SELECT OrderID, DATEDIFF(DAY, OrderDate, GETDATE()) AS DaysSinceOrder 
FROM Orders 
ORDER BY DaysSinceOrder DESC;

-- ======================================================================
-- PART 4: ADVANCED DATA ANALYSIS & WINDOW FUNCTIONS
-- Description: Advanced queries utilizing CTEs and Window Functions 
-- (ROW_NUMBER, RANK, DENSE_RANK, LAG, SUM).
-- ======================================================================

-- 1. Category Sales Analysis (CTE)
-- Calculate total products sold per category and filter categories with > 0 sales.
WITH CATEGORY_SALES AS (
    SELECT CATEGORY_NAME, SUM(Quantity) AS TotalSales
    FROM OrderDetails
    INNER JOIN Products ON OrderDetails.Product_ID = Products.PRODUCT_ID
    INNER JOIN Categories ON Products.CATEGORY_ID = Categories.CATEGORY_ID
    GROUP BY CATEGORY_NAME
)
SELECT * FROM CATEGORY_SALES WHERE TotalSales > 0;

-- 2. Recent Order Tracking
-- List the latest 3 orders for each customer using ROW_NUMBER().
WITH LAST3ORDERS AS (
    SELECT FullName, OrderID, OrderDate,
    ROW_NUMBER() OVER(PARTITION BY FullName ORDER BY OrderDate DESC) AS OrderRank
    FROM Customers
    INNER JOIN Orders ON Customers.CUSTOMER_ID = Orders.CustomerID
)  
SELECT * FROM LAST3ORDERS WHERE OrderRank <= 3;

-- 3. VIP Customer Analysis
-- Find the most expensive order placed by each customer.
WITH MAXORDERS AS (
    SELECT FullName, Orders.OrderID, PRODUCT_NAME, PRICE, OrderDate,
    ROW_NUMBER() OVER (PARTITION BY FullName ORDER BY PRICE DESC) AS orderPrice
    FROM Customers
    INNER JOIN Orders ON Customers.CUSTOMER_ID = Orders.CustomerID
    INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
    INNER JOIN Products ON OrderDetails.Product_ID = Products.PRODUCT_ID
) 
SELECT * FROM MAXORDERS WHERE orderPrice = 1;

-- 4. Retention Analysis (First Steps)
-- Find the very first order (oldest date) placed by each customer.
WITH FIRSTORDERS AS (
    SELECT FullName, Orders.OrderID, OrderDate,
    ROW_NUMBER() OVER (PARTITION BY FullName ORDER BY OrderDate ASC) AS orderRank
    FROM Customers
    INNER JOIN Orders ON Customers.CUSTOMER_ID = Orders.CustomerID
) 
SELECT * FROM FIRSTORDERS WHERE orderRank = 1;

-- 5. Category Leaders
-- Find the most expensive product in each category.
WITH MAXPRICE AS (
    SELECT CATEGORY_NAME, PRODUCT_NAME, PRICE,
    ROW_NUMBER() OVER (PARTITION BY CATEGORY_NAME ORDER BY PRICE DESC ) AS PriceRank
    FROM Products
    INNER JOIN Categories ON Products.CATEGORY_ID = Categories.CATEGORY_ID
)
SELECT * FROM MAXPRICE WHERE PriceRank = 1;

-- 6. Comparing RANK() vs DENSE_RANK()
-- Observe the behavioral difference between ranking functions based on TotalAmount.
WITH RANKED_ORDERS AS ( 
    SELECT FullName, OrderID, TotalAmount, OrderDate,
    RANK() OVER(PARTITION BY FullName ORDER BY TotalAmount ASC) AS OrderRank,
    DENSE_RANK() OVER(PARTITION BY FullName ORDER BY TotalAmount ASC) AS DenseOrderRank
    FROM Customers 
    INNER JOIN Orders ON Customers.CUSTOMER_ID = Orders.CustomerID
) 
SELECT * FROM RANKED_ORDERS; 

-- 7. Customer Growth Analysis (LAG)
-- Determine if a customer's spending increased or decreased compared to their previous order.
WITH GROWTH_ANALYSIS AS (
    SELECT FullName, OrderDate, TotalAmount,
    LAG(TotalAmount) OVER(PARTITION BY FullName ORDER BY OrderDate) AS PreviousAmount
    FROM Customers 
    INNER JOIN Orders ON Customers.CUSTOMER_ID = Orders.CustomerID
)
SELECT * FROM GROWTH_ANALYSIS;
   
-- 8. Cumulative Sales Analysis (Running Total)
WITH CUMULATIVE_SALES AS (
    SELECT FullName, OrderDate, TotalAmount,
    SUM(TotalAmount) OVER(PARTITION BY FullName ORDER BY OrderDate ASC) AS CumulativeAmount
    FROM Customers 
    INNER JOIN Orders ON Customers.CUSTOMER_ID = Orders.CustomerID
) 
SELECT * FROM CUMULATIVE_SALES;

-- 9. Monthly Growth Aggregation
WITH MONTHLY_AGGREGATE AS (
    SELECT MONTH(OrderDate) AS OrderMonth, SUM(TotalAmount) AS MonthlyTotal
    FROM Orders
    GROUP BY MONTH(OrderDate)
)
SELECT 
    OrderMonth, 
    MonthlyTotal,
    LAG(MonthlyTotal) OVER(ORDER BY OrderMonth) AS PreviousMonthTotal
FROM MONTHLY_AGGREGATE
ORDER BY OrderMonth;

-- ======================================================================
-- PART 5: ADVANCED DATABASE OBJECTS (VIEWS & BACKUPS)
-- Description: Creating reusable virtual tables and securing the database.
-- ======================================================================
GO

-- 1. Create a View for Order Summaries
-- Simplifies complex joins into a single, reusable virtual table.
CREATE VIEW vw_SiparisOzet AS
SELECT FullName, OrderDate, PRODUCT_NAME, Quantity 
FROM Customers
INNER JOIN Orders ON Customers.CUSTOMER_ID = Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.Product_ID = Products.PRODUCT_ID;
GO

-- Test the newly created View
SELECT * FROM vw_SiparisOzet;

-- 2. Database Backup Command
-- Ensure the logical state of the database is safely backed up to disk.
-- Note: Directory 'C:\Yedek\' must exist on the SQL Server host.
BACKUP DATABASE NovaStoreDB TO DISK = 'C:\Yedek\NovaStoreDB.bak';

-- ======================================================================
-- PART 6: DATA WAREHOUSE TRANSFORMATION (OLAP)
-- Description: Transforming normalized tables into a Star Schema 
-- (Fact and Dimension tables) for analytical processing.
-- ======================================================================

-- Create & Populate Customer Dimension
CREATE TABLE dim_customer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,  
    Customer_ID INT NOT NULL,                     
    FullName VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL
);

INSERT INTO dim_customer (Customer_ID, FullName, City, Email)
SELECT CUSTOMER_ID, FullName, City, Email FROM Customers;

-- Create & Populate Product Dimension
CREATE TABLE dim_product (
    productKey INT IDENTITY(1,1) PRIMARY KEY,
    PRODUCT_ID INT ,
    PRODUCT_NAME VARCHAR(100) NOT NULL,
    PRICE DECIMAL(10,2) NOT NULL,
    STOCK INT DEFAULT 0,
    CATEGORY_ID INT
);

INSERT INTO dim_product(PRODUCT_ID, PRODUCT_NAME, PRICE, STOCK, CATEGORY_ID)
SELECT PRODUCT_ID, PRODUCT_NAME, PRICE, STOCK, CATEGORY_ID FROM Products;

-- Create & Populate Sales Fact Table
CREATE TABLE Fact_Sales (
    SalesKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerKey INT NOT NULL,
    ProductKey INT NOT NULL,
    OrderDate DATE NOT NULL,
    Quantity INT NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL
);

INSERT INTO Fact_Sales (CustomerKey, ProductKey, OrderDate, Quantity, TotalAmount)
SELECT
    dim_customer.CustomerKey,
    dim_product.ProductKey,
    Orders.OrderDate,
    OrderDetails.Quantity,
    Orders.TotalAmount
FROM Orders
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN dim_customer ON Orders.CustomerID = dim_customer.Customer_ID
INNER JOIN dim_product ON OrderDetails.Product_ID = dim_product.PRODUCT_ID;

-- ======================================================================
-- PART 7: PERFORMANCE OPTIMIZATION & INDEXING SIMULATION
-- Description: Generating 100k mock records to demonstrate the 
-- performance difference between Table Scans and Index Seeks.
-- ======================================================================

-- Generate 100,000 mock products via WHILE loop (RBAR approach)
DECLARE @Counter INT = 0;
WHILE @Counter < 100000 BEGIN
    INSERT INTO Products (PRODUCT_NAME, PRICE, STOCK, CATEGORY_ID)
    VALUES (
        'Mock Product ' + CAST(@Counter AS VARCHAR(10)),
        ROUND(RAND() * 1000, 2),
        ROUND(RAND() * 100, 0),
        ROUND(RAND() * 4 + 1, 0) -- Random Category ID between 1 and 5
    );
    SET @Counter = @Counter + 1;
END;

-- Enable IO and TIME statistics to monitor query cost
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Baseline Query: No Index (Will result in a Table Scan)
SELECT * FROM Products WHERE PRODUCT_NAME = 'Gaming PC';

-- Create Non-Clustered Index on PRODUCT_NAME
CREATE INDEX IX_ProductName ON Products(PRODUCT_NAME);

-- Optimized Query: With Index (Will result in an Index Seek + Key Lookup)
SELECT * FROM Products WHERE PRODUCT_NAME = 'Gaming PC';

-- Turn off statistics
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

-- ======================================================================
-- PART 8: TRANSACTION MANAGEMENT (ACID PROPERTIES)
-- Description: Using TRY...CATCH blocks to ensure data consistency 
-- across multiple tables during a mock checkout process.
-- ======================================================================

-- SCENARIO: Placing an order requires inserting into Orders, 
-- inserting into OrderDetails, and deducting Stock from Products.
-- If any step fails, the entire transaction rolls back.

BEGIN TRY 
    BEGIN TRANSACTION;

    DECLARE @NewOrderID INT;
    
    -- Step 1: Create the Order
    INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
    VALUES (2, GETDATE(), 2500.00);
    
    -- Capture the newly generated OrderID
    SET @NewOrderID = SCOPE_IDENTITY();

    -- Step 2: Add Order Details 
    INSERT INTO OrderDetails (OrderID, Product_ID, Quantity)
    VALUES (@NewOrderID, 5, 1);

    -- Step 3: Deduct Inventory Stock
    UPDATE Products
    SET STOCK = STOCK - 1
    WHERE PRODUCT_ID = 5;
    
    -- If all steps succeed, commit changes to the database
    COMMIT TRANSACTION;
    PRINT 'Order completed successfully!';

END TRY
BEGIN CATCH
    -- If any step fails, rollback all changes to maintain consistency
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
        
    PRINT 'An error occurred, transaction rolled back: ' + ERROR_MESSAGE();
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
