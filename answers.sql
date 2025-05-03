-- question 1
-- Create a new table ProductDetail_1NF to store the data in 1NF.
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255)
);

-- Insert data into ProductDetail_1NF, splitting the Products column into individual rows.
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
FROM
    ProductDetail
CROSS JOIN (
    SELECT 1 AS n UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 -- Add more numbers if you expect more than 4 products in the Products column
) AS numbers
WHERE
    n <= LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) + 1;

-- Optionally, you can drop the original ProductDetail table if you no longer need it.
-- DROP TABLE ProductDetail;

-- Verify the result by selecting all rows from ProductDetail_1NF.
SELECT * FROM ProductDetail_1NF;

-- question 2
-- Create a new table Customers to store customer information (OrderID, CustomerName).
CREATE TABLE Customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Insert data into the Customers table.
INSERT INTO Customers (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create a new table OrderProducts to store order and product information (OrderID, Product, Quantity).
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Customers(OrderID)
);

-- Insert data into the OrderProducts table.
INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Drop the original OrderDetails table as it is no longer needed.
-- DROP TABLE OrderDetails;

-- Verify the results by selecting all rows from the new tables.
SELECT * FROM Customers;
SELECT * FROM OrderProducts;
