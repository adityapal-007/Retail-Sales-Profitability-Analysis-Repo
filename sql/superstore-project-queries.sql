-- Dataset view

SELECT *
FROM superstore;

-- KPI's (Total Sales, Profit, Order, Profit Margin)

SELECT SUM(Sales) AS total_sales,
	   SUM(profit) As total_profit,
       ROUND((SUM(profit)/ NULLIF(SUM(sales), 0)) * 100, 2) AS profit_margin,
       COUNT(DISTINCT order_id) AS total_orders
FROM superstore;

-- Category Performance

SELECT category,
	   SUM(sales) AS total_sales,
       SUM(profit) AS total_profit
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;

-- Sales Percentage by Customer Segment

SELECT segment,
	   ROUND(
       SUM(sales) * 100 / SUM(SUM(sales)) OVER()) AS sales_percentage
FROM superstore
GROUP BY segment;

-- Sales by Region

SELECT region,
	   SUM(sales) AS total_sales
FROM superstore
GROUP BY region
ORDER BY total_sales DESC;

-- Sub-Categories ordered by Loss to Profit

SELECT sub_category,
	   SUM(profit) AS total_profit
FROM superstore
GROUP BY sub_category
ORDER BY total_profit ASC;

-- Monthly Sales and Profit Trend (Seasonal)

SELECT
	MONTH(order_date) AS mon_num,
    MONTHNAME(order_date) AS month_name,
	SUM(sales) AS total_sales,
	SUM(profit) AS total_profit
FROM superstore
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY mon_num;
	
-- Impact of Discount on Profit

SELECT
	CASE
		WHEN discount = 0 THEN '0%'
        WHEN discount <= 0.1 THEN '0-10%'
        WHEN discount <= 0.2 THEN '10-20%'
        WHEN discount <= 0.3 THEN '20-30%'
        WHEN discount <= 0.4 THEN '30-40%'
        ELSE '40%+'
	END AS discount_group,
    ROUND(AVG(profit), 2) AS avg_profit
FROM superstore
GROUP BY discount_group
ORDER BY
	FIELD(discount_group, '0%', '0-10%', '10-20%', '20-30%', '30-40%', '40%+');
      
-- Top 10 States by Sales

SELECT
	state_province,
    SUM(sales) AS total_sales
FROM superstore
GROUP BY state_province
ORDER BY total_sales DESC
LIMIT 10;