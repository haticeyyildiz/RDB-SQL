-- ASSIGNMENT 2


-- 1. Product Sales
--You need to create a report on whether customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.
--1. 'Polk Audio - 50 W Woofer - Black' -- (other_product). To generate this report, you are required to use the appropriate SQL Server Built-in functions or expressions as well as basic SQL knowledge.


WITH T1 AS
(
SELECT DISTINCT p.product_name, c.customer_id, c.first_name, c.last_name
FROM product.product p, sale.order_item oi, sale.orders o, sale.customer c
WHERE p.product_id = oi.product_id
AND oi.order_id = o.order_id
AND o.customer_id = c.customer_id
AND p.product_name =  '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
), T2 AS
(
SELECT DISTINCT p.product_name, c.customer_id, c.first_name, c.last_name
FROM product.product p, sale.order_item oi, sale.orders o, sale.customer c
WHERE p.product_id = oi.product_id
AND oi.order_id = o.order_id
AND o.customer_id = c.customer_id
AND p.product_name =  'Polk Audio - 50 W Woofer - Black'
)
SELECT T1.customer_id, T1.first_name, T1.last_name, 
	ISNULL(NULLIF(ISNULL(T2.first_name, 'No'),T2.first_name), 'Yes') is_otherproduct_order
FROM T1
    LEFT JOIN
    T2
    ON T1.customer_id = T2.customer_id


	--------------------------------------------------------------------------------------------

--2. Conversion Rate
--Below you see a table of the actions of customers visiting the website by clicking on two different types of advertisements given by an E-Commerce company. Write a query to return the conversion rate for each Advertisement type.

--a.    Create above table (Actions) and insert values,
CREATE TABLE ECommerce (	Visitor_ID INT IDENTITY (1, 1) PRIMARY KEY,	Adv_Type VARCHAR (255) NOT NULL,	Action1 VARCHAR (255) NOT NULL);
INSERT INTO ECommerce (Adv_Type, Action1)VALUES ('A', 'Left'),('A', 'Order'),('B', 'Left'),('A', 'Order'),('A', 'Review'),('A', 'Left'),('B', 'Left'),('B', 'Order'),('B', 'Review'),('A', 'Review');



--b.    Retrieve count of total Actions and Orders for each Advertisement Type,

SELECT	
Adv_Type, COUNT (Action1) action_count
FROM	
dbo.ECommerce
GROUP BY
Adv_Type ;


--Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0

WITH t1 AS
(
SELECT	
Adv_Type, COUNT (Action1) action_count
FROM	
dbo.ECommerce
GROUP BY
Adv_Type
), 
t2 AS
(
SELECT
Adv_Type, COUNT (Action1) order_count
FROM	
dbo.ECommerce
WHERE	Action1 = 'Order'
GROUP BY
Adv_Type
)
SELECT	t1.Adv_Type, CAST (ROUND (1.0*t2.order_count / t1.action_count, 2) AS numeric (3,2)) AS conversion_rate
FROM	t1, t2
WHERE	t1.Adv_Type = t2.Adv_Type;