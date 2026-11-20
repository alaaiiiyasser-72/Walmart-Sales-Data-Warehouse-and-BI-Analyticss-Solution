


--- CHECK ROWS COUNT

SELECT COUNT(*) AS Total_Rows
FROM bronze.walmart_sales_raw;

--- CHECK NULLS
SELECT
    SUM(CASE WHEN City IS NULL OR TRIM(City) = '' THEN 1 ELSE 0 END) AS City_Missing,
    SUM(CASE WHEN Customer_Age IS NULL OR TRIM(Customer_Age) = '' THEN 1 ELSE 0 END) AS Customer_Age_Missing,
    SUM(CASE WHEN Customer_Name IS NULL OR TRIM(Customer_Name) = '' THEN 1 ELSE 0 END) AS Customer_Name_Missing,
    SUM(CASE WHEN Customer_Segment IS NULL OR TRIM(Customer_Segment) = '' THEN 1 ELSE 0 END) AS Customer_Segment_Missing,
    SUM(CASE WHEN Discount IS NULL OR TRIM(Discount) = '' THEN 1 ELSE 0 END) AS Discount_Missing,
    SUM(CASE WHEN Number_of_Records IS NULL OR TRIM(Number_of_Records) = '' THEN 1 ELSE 0 END) AS Number_of_Records_Missing,
    SUM(CASE WHEN Order_Date IS NULL OR TRIM(Order_Date) = '' THEN 1 ELSE 0 END) AS Order_Date_Missing,
    SUM(CASE WHEN Order_ID IS NULL OR TRIM(Order_ID) = '' THEN 1 ELSE 0 END) AS Order_ID_Missing,
    SUM(CASE WHEN Order_Priority IS NULL OR TRIM(Order_Priority) = '' THEN 1 ELSE 0 END) AS Order_Priority_Missing,
    SUM(CASE WHEN Order_Quantity IS NULL OR TRIM(Order_Quantity) = '' THEN 1 ELSE 0 END) AS Order_Quantity_Missing,
    SUM(CASE WHEN Product_Base_Margin IS NULL OR TRIM(Product_Base_Margin) = '' THEN 1 ELSE 0 END) AS Product_Base_Margin_Missing,
    SUM(CASE WHEN Product_Category IS NULL OR TRIM(Product_Category) = '' THEN 1 ELSE 0 END) AS Product_Category_Missing,
    SUM(CASE WHEN Product_Container IS NULL OR TRIM(Product_Container) = '' THEN 1 ELSE 0 END) AS Product_Container_Missing,
    SUM(CASE WHEN Product_Name IS NULL OR TRIM(Product_Name) = '' THEN 1 ELSE 0 END) AS Product_Name_Missing,
    SUM(CASE WHEN Product_Sub_Category IS NULL OR TRIM(Product_Sub_Category) = '' THEN 1 ELSE 0 END) AS Product_Sub_Category_Missing,
    SUM(CASE WHEN Profit IS NULL OR TRIM(Profit) = '' THEN 1 ELSE 0 END) AS Profit_Missing,
    SUM(CASE WHEN Region IS NULL OR TRIM(Region) = '' THEN 1 ELSE 0 END) AS Region_Missing,
    SUM(CASE WHEN Row_ID IS NULL OR TRIM(Row_ID) = '' THEN 1 ELSE 0 END) AS Row_ID_Missing,
    SUM(CASE WHEN Sales IS NULL OR TRIM(Sales) = '' THEN 1 ELSE 0 END) AS Sales_Missing,
    SUM(CASE WHEN Ship_Date IS NULL OR TRIM(Ship_Date) = '' THEN 1 ELSE 0 END) AS Ship_Date_Missing,
    SUM(CASE WHEN Ship_Mode IS NULL OR TRIM(Ship_Mode) = '' THEN 1 ELSE 0 END) AS Ship_Mode_Missing,
    SUM(CASE WHEN Shipping_Cost IS NULL OR TRIM(Shipping_Cost) = '' THEN 1 ELSE 0 END) AS Shipping_Cost_Missing,
    SUM(CASE WHEN State IS NULL OR TRIM(State) = '' THEN 1 ELSE 0 END) AS State_Missing,
    SUM(CASE WHEN Unit_Price IS NULL OR TRIM(Unit_Price) = '' THEN 1 ELSE 0 END) AS Unit_Price_Missing,
    SUM(CASE WHEN Zip_Code IS NULL OR TRIM(Zip_Code) = '' THEN 1 ELSE 0 END) AS Zip_Code_Missing
FROM bronze.walmart_sales_raw;

-- 903 Customer_Age_Missing , 63 Product_Base_Margin_Missing

--==========================================================
--DSTINCT VALUE FOR CATEGORICAL COLS
--==========================================================

-- CHECK Customer_Segment

SELECT DISTINCT
    Customer_Segment
FROM bronze.walmart_sales_raw
ORDER BY Customer_Segment;

-- CHECK Order Priority

SELECT DISTINCT
    Order_Priority
FROM bronze.walmart_sales_raw
ORDER BY Order_Priority;

--Critical
--High
--Low
--Medium
--Not Specified

-- CHECK Product_Category

SELECT DISTINCT
    Product_Category
FROM bronze.walmart_sales_raw
ORDER BY Product_Category;

--Furniture
--Office Supplies
--Technology

---CHECK Product_Container

SELECT DISTINCT
    Product_Container
FROM bronze.walmart_sales_raw
ORDER BY Product_Container;

--Jumbo Box
--Jumbo Drum
--Large Box
--Medium Box
--Small Box
--Small Pack
--Wrap Bag

--CHECK Region

SELECT DISTINCT
    Region
FROM bronze.walmart_sales_raw
ORDER BY Region;

--Central
--East
--South
--West

---CHECK Ship_Mode

SELECT DISTINCT
    Ship_Mode
FROM bronze.walmart_sales_raw
ORDER BY Ship_Mode;

--Delivery Truck
--Express Air
--Regular Air

