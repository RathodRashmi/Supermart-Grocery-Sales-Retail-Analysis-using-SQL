

/*

Supermart Grocery Sales-Retail Analysis

*/


-- Show Top 50 Records

SELECT * FROM supermart limit 50


--Check the top 10 customer with the most order

SELECT customer_name, COUNT(*) AS total_order
FROM supermart
GROUP BY customer_name
ORDER BY total_order DESC
LIMIT 10;


---  Top 5 city with highest sales

SELECT city, SUM(sales) as total_sales
FROM supermart
GROUP BY city
ORDER BY total_sales DESC
limit 5;


---  Last years total sales for each category ,order it from the highest sales

SELECT category, SUM(sales) as total_sales
FROM supermart
WHERE EXTRACT('year' from order_date) = 2018
GROUP BY category
ORDER BY total_sales DESC;



--Total sales by each region order by highest sales

SELECT region, SUM(sales) as total_sales
FROM supermart
--WHERE EXTRACT('year' from order_date) = 2018
GROUP BY region
ORDER BY total_sales DESC;



---average sales for beverages during 4th quarter of 2018?

SELECT AVG(sales) AS beverages_sales_average
FROM supermart
WHERE EXTRACT('year' from order_date) = 2018
AND EXTRACT('month' from order_date) >= 10
AND category = 'Beverages';


--  Monthly profits of snacks during 2016


SELECT EXTRACT('year' from order_date) as order_year,
	EXTRACT('month' from order_date) as order_month,
	SUM(profit) AS total_profit
FROM supermart
WHERE EXTRACT('year' from order_date) = 2016
GROUP BY order_year, order_month;


-- Total profit of each category during last year


SELECT category, SUM(profit) as total_profit
FROM supermart
WHERE EXTRACT('year' from order_date) = 2018
GROUP BY category
ORDER BY total_profit DESC;



---percentage of noodels order compared to all Snacks category during 2017?


CREATE OR REPLACE FUNCTION calculate_percentage_subcategory(c text, sub_c text, order_year INT)
RETURNS FLOAT
AS
$$
	DECLARE
		total_category FLOAT;
		total_sub_category FLOAT;
		percentage FLOAT;
	BEGIN
		SELECT COUNT(*) INTO total_category
		FROM supermart
		WHERE category = c
		AND EXTRACT('year' from order_date) = order_year;
		
		SELECT COUNT(*) INTO total_sub_category
		FROM supermart
		WHERE sub_category = sub_c
		AND EXTRACT('year' from order_date) = order_year;
		
		percentage := (total_sub_category/total_category)*100;
		RETURN percentage;
	END;
$$
LANGUAGE plpgsql;

SELECT calculate_percentage_subcategory('Snacks', 'Noodles', 2017)
AS "Noodles order percentage 2017 (%)";






