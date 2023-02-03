-- E COMMERCE PROJECT


SELECT *
FROM [dbo].[e_commerce_data]

--1. Find the top 3 customers who have the maximum count of orders.


SELECT	TOP 3 Cust_ID,  COUNT(DISTINCT Ord_ID) order_count
FROM	[dbo].[e_commerce_data]
GROUP BY	
		Cust_ID
ORDER BY 
		2 DESC

--------------------------------------------------------------------------------------------------------------------------------

--2. Find the customer whose order took the maximum time to get shipping.

ALTER TABLE[dbo].[e_commerce_data]  ADD Date_Difference INT 

SELECT *, DATEDIFF(DAY, Order_Date, Ship_Date)
FROM [dbo].[e_commerce_data]


UPDATE [dbo].[e_commerce_data]
SET Date_Difference = DATEDIFF(DAY, Order_Date, Ship_Date)

SELECT TOP 1 Customer_Name
FROM [dbo].[e_commerce_data]
ORDER BY 
		Date_Difference DESC

----------------------------------------------------------------------------------------------------------------------------------------------

--3. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011.

SELECT	DISTINCT Cust_ID
FROM	[dbo].[e_commerce_data]
WHERE	YEAR(Order_Date) = 2011
AND		MONTH(Order_Date) = 1



SELECT	MONTH(Order_Date) ORD_MONTH , COUNT (DISTINCT Cust_ID) Customer_Count
FROM	[dbo].[e_commerce_data] A
WHERE	EXISTS	(
						SELECT	1
						FROM	[dbo].[e_commerce_data] B
						WHERE	YEAR(Order_Date) = 2011
						AND		MONTH(Order_Date) = 1
						AND		A.Cust_ID = B.Cust_ID
					)
AND		YEAR(Order_Date) = 2011
GROUP BY 
		MONTH(Order_Date)
ORDER BY
		1


----------------------------------------------------------------------------------------------------------------------------

--4. Write a query to return for each user the time elapsed between the first purchasing and the third purchasing, in ascending order by Customer ID.

WITH T1 AS
(
SELECT	 Cust_ID, Ord_ID, Order_Date,
		MIN (Order_Date) OVER (PARTITION BY Cust_ID) first_order,
		DENSE_RANK() OVER (PARTITION BY Cust_ID ORDER BY Order_Date, Ord_ID) ORDER_NUMBER
FROM	[dbo].[e_commerce_data]
) 
SELECT Cust_ID, Ord_ID, Order_Date, first_order, ORDER_NUMBER,
		DATEDIFF(DAY, first_order, order_date)
FROM	T1
WHERE	ORDER_NUMBER = 3


----------------------------------------------------------------------------------------------------------------------------


--5. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by the customer.

WITH T1 AS
(
SELECT	Cust_ID,
		SUM (CASE WHEN Prod_ID = 'Prod_11' THEN Order_Quantity ELSE 0 END) product_11,
		SUM (CASE WHEN Prod_ID = 'Prod_14' THEN Order_Quantity ELSE 0 END) product_14,
		SUM (Order_Quantity) total_product
FROM	[dbo].[e_commerce_data]
GROUP  BY 
		Cust_ID
HAVING
		SUM (CASE WHEN Prod_ID = 'Prod_11' THEN Order_Quantity ELSE 0 END) > 0
		AND
		SUM (CASE WHEN Prod_ID = 'Prod_14' THEN Order_Quantity ELSE 0 END) > 0
)
SELECT  cust_ID, 
		CAST(1.0*product_11/total_product AS NUMERIC (3,2))as prod_11_ratio,
		CAST (1.0*product_14/total_product AS NUMERIC (3,2)) as prod_14_ratio
		
FROM	T1


------------------------------------***********************-------------------------------------------------------------------


------Customer Segmentation

--1. Create a “view” that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)

CREATE VIEW cust_logs AS
SELECT	Cust_ID, YEAR(Order_Date) ord_year, MONTH(Order_Date) ord_month, 
		COUNT (*) logs
FROM	[dbo].[e_commerce_data]
GROUP BY 
		Cust_ID, YEAR(Order_Date), MONTH(Order_Date)

-----------------------------------------------------------------------------------------------------------------------------------

--2. Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning business)



