USE NovaStoreDB;
GO

DROP TABLE IF EXISTS OrderDetails; 
DROP TABLE IF EXISTS Orders;       
DROP TABLE IF EXISTS Products;     
DROP TABLE IF EXISTS Customers;    
DROP TABLE IF EXISTS Categories;  
GO

--PART 1

--CATEGORIES TABLE
CREATE TABLE  Categories (
    CATEGORY_ID INT IDENTITY(1,1) PRIMARY KEY,
    CATEGORY_NAME  VARCHAR(100) NOT NULL
);

---PRODUCTS TABLE
CREATE TABLE Products (
    PRODUCT_ID INT IDENTITY(1,1) PRIMARY KEY,
    PRODUCT_NAME VARCHAR(100) NOT NULL,
    PRICE DECIMAL(10,2) NOT NULL,
    STOCK INT DEFAULT 0,
    CATEGORY_ID INT,
    CONSTRAINT FK_CATEGORY FOREIGN KEY(CATEGORY_ID) REFERENCES Categories(CATEGORY_ID)
);

--CUSTOMERS TABLE
CREATE TABLE Customers(
    CUSTOMER_ID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);

--ORDERS TABLE
CREATE TABLE Orders(
      OrderID INT IDENTITY(1,1) PRIMARY KEY,
      CustomerID INT,
      OrderDate DATETIME DEFAULT GETDATE(),
      TotalAmount DECIMAL(10,2) NOT NULL, 
      CONSTRAINT FK_CUSTOMER FOREIGN KEY(CustomerID) REFERENCES Customers(CUSTOMER_ID)
);

--ORDER DETAILTS TABLE
CREATE TABLE OrderDetails(
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    Product_ID INT,
    Quantity INT NOT NULL,
    CONSTRAINT FK_ORDER FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_PRODUCT FOREIGN KEY(Product_ID) REFERENCES Products(PRODUCT_ID)
);

--part 2

-- 1. cATEGORIES (5 Different Categories)
INSERT INTO Categories (CATEGORY_NAME) VALUES 
('Elektronik'), ('Giyim'), ('Kitap'), ('Kozmetik'), ('Ev ve Yaşam');

-- 2. PRODUCTS (at least 10 different products, each belonging to one of the categories)
INSERT INTO Products (PRODUCT_NAME, PRICE, STOCK, CATEGORY_ID) VALUES 
('Oyuncu Bilgisayarı', 35000.00, 15, 1), 
('Akıllı Telefon', 22000.00, 25, 1),    
('Klasik Deri Ceket', 2500.00, 40, 2),   
('Pamuklu Tişört', 450.00, 100, 2),      
('SQL Öğreniyorum Kitabı', 350.00, 8, 3),
('Veri Bilimi Rehberi', 420.00, 12, 3),   
('Nemlendirici Krem', 180.00, 50, 4),    
('Parfüm EDP', 1200.00, 18, 4),          
('Çalışma Masası', 2100.00, 5, 5),       
('Ortopedik Yastık', 650.00, 30, 5);     

-- 3. customers (5 Different Customers)

INSERT INTO Customers (FullName, City, Email) VALUES 
('Ahmet Yılmaz', 'İstanbul', 'ahmet@mail.com'),
('Mehmet Öztürk', 'Ankara', 'mehmet@mail.com'),
('Ayşe Demir', 'İzmir', 'ayse@mail.com'),
('Canan Kaya', 'Bursa', 'canan@mail.com'),
('Ali Can', 'Antalya', 'alican@mail.com');

-- 4. orders (8 Different Orders)

INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES 
(1, '2026-06-01 10:00:00', 35450.00), 
(1, '2026-06-15 14:30:00', 450.00),   
(2, '2026-05-20 11:15:00', 22000.00), 
(3, '2026-06-10 09:00:00', 2500.00),  
(4, '2026-04-01 16:45:00', 1380.00),  
(5, '2026-06-22 18:20:00', 2100.00),  
(2, '2026-06-23 12:00:00', 420.00),   
(3, '2026-06-24 15:00:00', 1200.00);  

-- 5. order details 

INSERT INTO OrderDetails (OrderID, Product_ID, Quantity) VALUES 
(1, 1, 1),  
(1, 5, 1),  
(2, 4, 1),  
(3, 2, 1),  
(4, 3, 1),  
(5, 7, 1),  
(5, 8, 1),  
(6, 9, 1),  
(7, 6, 1),  
(8, 8, 1);  



--CHAPTER 3: Querying and Analysis (DQL - SELECT and Joins)

--1. Basic Listing:
-- List the names and stock quantities of products
-- with a stock quantity of less than 20, sorted in descending order by stock quantity.
Select PRODUCT_NAME, Stock FROM Products 
Where Stock < 20 ORDER BY Stock DESC;

--2.DATA MERGING (JOINING TABLES)
--Which customer placed an order, and on what date? The results should display Customer Name, City, Order Date, and Total Amount.
SELECT FullName, City, OrderDate, TotalAmount FROM Customers
INNER JOIN Orders ON Customers.CUSTOMER_ID = Orders.CustomerID;


--3. Multiple Consolidation and Detail Report:
--List the names, prices, and categories of the products purchased by the customer named "Ahmet Yılmaz" (or a customer in your data).

SELECT  PRODUCT_NAME, PRICE, CATEGORY_NAME FROM Products 
INNER JOIN Categories on Products.CATEGORY_ID=Categories.CATEGORY_ID
INNER JOIN OrderDetails on Products.PRODUCT_ID=OrderDetails.Product_ID
INNER JOIN Orders on OrderDetails.OrderID=Orders.OrderID
INNER JOIN Customers on Orders.CustomerID=Customers.CUSTOMER_ID
WHERE FullName='Ahmet Yılmaz';

--4. Grouping and Aggregate Functions:
--How many products do we have in total in each category? (Example: Electronics - 5 products).

SELECT CATEGORY_NAME,COUNT(*)
 AS ProductCount FROM Products
 LEFT JOIN Categories ON Products.CATEGORY_ID=Categories.CATEGORY_ID
 GROUP BY CATEGORY_NAME;

 --5. Turnover Analysis
 --What is the total revenue each customer generates for the company? 
 --Rank them from the highest-spending customer to the lowest.

 SELECT FullName,sum(TotalAmount) AS TotalRevenue FROM Customers INNER JOIN Orders ON Customers.CUSTOMER_ID=Orders.CustomerID
 GROUP BY FullName
 ORDER BY TotalRevenue DESC;

--6. Time Analysis
--Write a query that calculates how many days have passed since the orders were placed, based on today's date.

Select OrderId,DATEDIFF(DAY,OrderDate,GETDATE()) AS DaysSinceOrder 
FROM Orders 
ORDER BY DaysSinceOrder DESC;

--CHAPTER 4: Advanced Database Objects

--1. Creating a View:

--To avoid repeatedly writing long JOIN queries, 
--create a VIEW named `vw_SiparisOzet` that retrieves Customer Name, Order Date, Product Name, and Quantity 
--information as if they were in a single table.
Go
CREATE VIEW vw_SiparisOzet AS
SELECT FullName,OrderDate,PRODUCT_NAME,Quantity FROM Customers
INNER JOIN Orders ON Customers.CUSTOMER_ID=Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID=OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.Product_ID=Products.PRODUCT_ID;
GO

Select * FROM vw_SiparisOzet;

--2. Backup
--After completing your project,
-- write the T-SQL command to back up the NovaStoreDB database to the C:\Yedek\ folder.
BACKUP DATABASE NovaStoreDB TO DISK = 'C:\Yedek\NovaStoreDB.bak';