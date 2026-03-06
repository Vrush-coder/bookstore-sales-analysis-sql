-- ==========================================
-- BookStore Sales Analysis using MySQL
-- ==========================================

-- Create Database
CREATE DATABASE IF NOT EXISTS BookStoreDB;
USE BookStoreDB;



-- ==========================================
-- BOOKS TABLE
-- ==========================================
DROP TABLE IF EXISTS Books;

CREATE TABLE Books (
    Book_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price DECIMAL(10,2),
    Stock INT
);

-- ==========================================
-- CUSTOMERS TABLE
-- ==========================================
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

-- ==========================================
-- ORDERS TABLE
-- ==========================================
DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
    Order_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT,
    Book_ID INT,
    Order_Date DATE,
    Quantity INT,
    Total_Amount DECIMAL(10,2),

    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);

-- ==========================================
-- VIEW TABLE DATA
-- ==========================================
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- ==========================================
-- BASIC SQL QUERIES
-- ==========================================

-- 1 Retrieve all Fiction books
SELECT *
FROM Books
WHERE Genre = 'Fiction';

-- 2 Books published after 1950
SELECT *
FROM Books
WHERE Published_Year > 1950;

-- 3 Customers from Canada
SELECT *
FROM Customers
WHERE Country = 'Canada';

-- 4 Orders placed in November 2023
SELECT *
FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5 Total stock of books available
SELECT SUM(Stock) AS Total_Stock
FROM Books;

-- 6 Most expensive book
SELECT *
FROM Books
ORDER BY Price DESC
LIMIT 1;

-- 7 Orders with quantity greater than 1
SELECT *
FROM Orders
WHERE Quantity > 1;

-- 8 Orders where total amount > 20
SELECT *
FROM Orders
WHERE Total_Amount > 20;

-- 9 List all book genres
SELECT DISTINCT Genre
FROM Books;

-- 10 Book with lowest stock
SELECT *
FROM Books
ORDER BY Stock ASC
LIMIT 1;

-- 11 Total revenue generated
SELECT SUM(Total_Amount) AS Total_Revenue
FROM Orders;

-- ==========================================
-- ADVANCED ANALYSIS QUERIES
-- ==========================================

-- 1 Total books sold per genre
SELECT 
    b.Genre,
    SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b
ON o.Book_ID = b.Book_ID
GROUP BY b.Genre;

-- 2 Average price of Fantasy books
SELECT 
    AVG(Price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 3 Customers who placed at least 2 orders
SELECT 
    o.Customer_ID,
    c.Name,
    COUNT(o.Order_ID) AS Order_Count
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
GROUP BY o.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2;

-- 4 Most frequently ordered book
SELECT 
    b.Title,
    COUNT(o.Order_ID) AS Total_Orders
FROM Orders o
JOIN Books b
ON o.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY Total_Orders DESC
LIMIT 1;

-- 5 Top 3 most expensive Fantasy books
SELECT *
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

-- 6 Total books sold by each author
SELECT 
    b.Author,
    SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b
ON o.Book_ID = b.Book_ID
GROUP BY b.Author;

-- 7 Cities where customers spent more than $30
SELECT DISTINCT
    c.City
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
WHERE o.Total_Amount > 30;

-- 8 Customer who spent the most money
SELECT 
    c.Customer_ID,
    c.Name,
    SUM(o.Total_Amount) AS Total_Spent
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC
LIMIT 1;

-- 9 Remaining stock after fulfilling orders
SELECT 
    b.Book_ID,
    b.Title,
    b.Stock,
    COALESCE(SUM(o.Quantity),0) AS Ordered_Quantity,
    b.Stock - COALESCE(SUM(o.Quantity),0) AS Remaining_Stock
FROM Books b
LEFT JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock
ORDER BY b.Book_ID;

-- ==========================================
-- EXTRA ANALYSIS QUERY (Added Improvement)
-- ==========================================

-- Top 5 best-selling books
SELECT 
    b.Title,
    SUM(o.Quantity) AS Total_Sold
FROM Orders o
JOIN Books b
ON o.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY Total_Sold DESC
LIMIT 5;