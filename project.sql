use ge;
-- Customer Analysis: Demographic Distribution by Gender and Age
-- This query calculates the total number of customers by gender and their average age.
SELECT Gender, 
       COUNT(CustomerKey) AS Total_Customers, 
       AVG(DATEDIFF(CURDATE(), Birthday) / 365.25) AS Average_Age
FROM Customers
GROUP BY Gender;

-- Customer Analysis: Demographic Distribution by Location (City, State, Country, Continent)
-- This query calculates the number of customers in each location (city, state, country, continent).
SELECT City, State, Country, Continent, COUNT(CustomerKey) AS Total_Customers
FROM Customers
GROUP BY City, State, Country, Continent
ORDER BY Total_Customers DESC;

-- Purchase Patterns: Average Order Value and Frequency of Purchases
-- This query calculates the average order value and number of orders per customer.
SELECT CustomerKey, 
       COUNT(`Order Number`) AS Total_Orders, 
       AVG(Quantity) AS Average_Order_Value
FROM Sales
GROUP BY CustomerKey
LIMIT 1000;

-- Customer Segmentation: Segmentation Based on Gender and Purchase Behavior
-- This query segments customers by gender and calculates the average quantity ordered.
SELECT c.Gender, 
       COUNT(DISTINCT o.CustomerKey) AS Total_Customers, 
       AVG(o.Quantity) AS Avg_Quantity
FROM Customers c
JOIN Sales o ON c.CustomerKey = o.CustomerKey
GROUP BY c.Gender;

-- Sales Analysis: Overall Sales Performance Over Time
-- This query calculates total sales over time (by order date), showing both quantity and revenue.
SELECT DATE(Order_date) AS Order_Date, 
       SUM(Quantity) AS Total_Quantity, 
       SUM(Quantity * p.`Unit Price USD`) AS Total_Sales
FROM Sales o
JOIN Products p ON o.ProductKey = p.ProductKey
GROUP BY Order_Date
ORDER BY Order_Date ASC;

-- Sales Analysis: Top Performing Products by Quantity and Revenue
-- This query identifies top-performing products based on the total quantity sold and revenue generated.
SELECT p.ProductKey, 
       p.`Product Name`, 
       SUM(o.Quantity) AS Total_Quantity_Sold, 
       SUM(o.Quantity * p.`Unit Price USD`) AS Total_Revenue
FROM Sales o
JOIN Products p ON o.ProductKey = p.ProductKey
GROUP BY p.ProductKey, p.`Product Name`
ORDER BY Total_Revenue DESC
LIMIT 5;

-- Sales Analysis: Store Performance Based on Sales and Revenue
-- This query assesses the performance of stores by calculating total quantity sold and revenue for each store.
SELECT s.StoreKey, 
       SUM(o.Quantity) AS Total_Quantity_Sold, 
       SUM(o.Quantity * p.`Unit Price USD`) AS Total_Revenue
FROM Sales o
JOIN Products p ON o.ProductKey = p.ProductKey
JOIN Stores s ON o.StoreKey = s.StoreKey
GROUP BY s.StoreKey
ORDER BY Total_Revenue DESC;

-- Product Analysis: Product Profitability
-- This query calculates the total quantity sold, revenue, and profit for each product.
SELECT p.ProductKey, 
       p.`Product Name`, 
       SUM(o.Quantity) AS Total_Quantity_Sold, 
       SUM(o.Quantity * p.`Unit Price USD`) AS Total_Revenue, 
       SUM(o.Quantity * (p.`Unit Price USD` - p.`Unit Cost USD`)) AS Total_Profit
FROM Sales o
JOIN Products p ON o.ProductKey = p.ProductKey
GROUP BY p.ProductKey, p.`Product Name`
ORDER BY Total_Profit DESC;

-- Store Analysis: Sales by Store Location (Geographical Analysis)
-- This query analyzes store performance by geographical location, calculating total quantity sold and revenue.
SELECT s.`State`, 
       s.Country, 
       SUM(o.Quantity) AS Total_Quantity_Sold, 
       SUM(o.Quantity * p.`Unit Price USD`) AS Total_Revenue
FROM Sales o
JOIN Products p ON o.ProductKey = p.ProductKey
JOIN Stores s ON o.StoreKey = s.StoreKey
GROUP BY s.`State`, s.Country
ORDER BY Total_Revenue DESC;

-- Customer Purchase Frequency and Recency Analysis
-- This query calculates the total number of orders for each customer
-- and determines how many days have passed since their last order.
SELECT c.CustomerKey, 
       COUNT(o.`Order Number`) AS Total_Orders, 
       MAX(o.Order_date) AS Last_Order_Date, 
       DATEDIFF(CURDATE(), MAX(o.Order_date)) AS Days_Since_Last_Order
FROM Customers c
JOIN Sales o ON c.CustomerKey = o.CustomerKey
GROUP BY c.CustomerKey
ORDER BY Days_Since_Last_Order ASC;
