-- SQL ASSIGNMENT 1

--1. How many customers are in each city? Your solution should include the city name and the number of customers sorted from highest to lowest.

SELECT  city, COUNT (customer_id) AS total_cust 
FROM sale.customer 
GROUP BY city 
ORDER BY total_cust DESC;



--2. Find the total product quantity of the orders. Your solution should include order ids and quantity of products.

SELECT * 
FROM sale.order_item

SELECT product_id, SUM(quantity) AS sum_of_quantity
FROM sale.order_item 
GROUP BY product_id ;



--3. Find the first order date for each customer_id.

SELECT * 
FROM sale.orders

SELECT customer_id, MIN(order_date) AS first_order_date 
FROM sale.orders
GROUP BY customer_id;





--4. Find the total amount of each order. Your solution should include order id and total amount sorted from highest to lowest.
SELECT * 
FROM sale.order_item


SELECT order_id, SUM (quantity) AS total_quantity 
FROM sale.order_item 
GROUP BY order_id 
ORDER BY total_quantity DESC;


--5. Find the order id that has the maximum average product price. Your solution should include only one row with the order id and average product price.
SELECT TOP(1)order_id, AVG(list_price) AS avg_product_price
FROM sale.order_item
GROUP BY order_id;





--6. Write a query that displays brand_id, product_id and list_price sorted first by brand_id (in ascending order), and then by list_price  (in descending order).

SELECT * 
FROM product.product


SELECT brand_id, category_id, list_price
FROM product.product
ORDER BY brand_id ASC, list_price DESC;




--7. Write a query that displays brand_id, product_id and list_price, but this time sorted first by list_price (in descending order), and then by brand_id (in ascending order).


SELECT brand_id, product_id, list_price
FROM product.product
ORDER BY list_price DESC,brand_id ASC;






--8. Compare the results of these two queries above. How are the results different when you switch the column you sort on first? (Explain it in your own words.)

--In both queries, the same result was obtained in terms of the highest list price.


--9. Write a query to pull the first 10 rows and all columns from the product table that have a list_price greater than or equal to 3000.

SELECT TOP 10 *
FROM product.product
WHERE list_price >= 3000;


--10. Write a query to pull the first 5 rows and all columns from the product table that have a list_price less than 3000.

SELECT TOP 5 *
FROM product.product
WHERE list_price < 3000;





--11. Find all customer last names that start with 'B' and end with 's'.

SELECT *
FROM sale.customer


SELECT last_name
FROM sale.customer
WHERE first_name LIKE '%B_s%';





--12. Use the customer table to find all information regarding customers whose address is Allen or Buffalo or Boston or Berkeley.


SELECT *
FROM sale.customer
WHERE city = 'Allen' OR city = 'Buffalo' OR city = 'Boston' OR city = 'Berkeley'
;

