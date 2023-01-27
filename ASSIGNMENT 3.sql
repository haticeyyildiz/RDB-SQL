
--Discount Effects
--Generate a report including product IDs and discount effects on whether the increase in the discount rate positively impacts the number of orders for the products.
--In this assignment, you are expected to generate a solution using SQL with a logical approach. 



--**With average values:

WITH effect_calculate as
(
	SELECT DISTINCT order_id,discount,quantity, AVG(discount) OVER(PARTITION BY order_id)avg_disc,
	AVG(quantity) OVER(PARTITION BY order_id) avg_quantity,

		CASE

			WHEN quantity > AVG(quantity) OVER(PARTITION BY order_id) and  discount > AVG(discount) OVER(PARTITION BY order_id) THEN 'Positive'
			WHEN quantity < AVG(quantity) OVER(PARTITION BY order_id) and discount < AVG(discount) OVER(PARTITION BY order_id) THEN 'Negative'
			ELSE  'Neutral'

		END  discount_effect

	FROM sale.order_item
	GROUP BY order_id, discount, quantity
)
SELECT DISTINCT order_id, discount_effect
FROM effect_calculate;


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--**With previous and following values:

WITH effect_calculate as
(
	SELECT DISTINCT order_id,discount,quantity, LEAD(discount) OVER(PARTITION BY order_id ORDER BY order_id) next_disc,
	LEAD(quantity) OVER(ORDER BY order_id) next_quantity,

		CASE

			WHEN LEAD(quantity) OVER(PARTITION BY order_id ORDER BY order_id) > quantity  and LEAD( discount )OVER(PARTITION BY order_id ORDER BY order_id)> discount  THEN 'Positive'
			WHEN LEAD(quantity)OVER(PARTITION BY order_id ORDER BY order_id)<  quantity  and LEAD( discount ) OVER(PARTITION BY order_id ORDER BY order_id) < discount  THEN 'Negative'
			ELSE  'Neutral'
		END  discount_effect

	FROM sale.order_item
	GROUP BY order_id, discount, quantity
	)

SELECT DISTINCT order_id, discount_effect
FROM effect_calculate