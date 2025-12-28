-- Retrieve all records from the orders table
SELECT * FROM dataanalysis_project.orders;

-- Top 10 highest revenue generating products
SELECT product_id, round(sum(sale_price),2) as revenue
FROM orders
GROUP BY product_id
ORDER BY revenue DESC;

-- Top 5 selling products in each region
SELECT region, product_id, sales
FROM (
    SELECT
        region,
        product_id,
        SUM(sale_price) AS sales,
        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY SUM(sale_price) DESC
        ) AS rn
    FROM orders
    GROUP BY region, product_id
) t
WHERE rn <= 5
ORDER BY region, sales DESC;

-- Month-over-month sales comparison from 2022 to 2023
SELECT
    MONTH(order_date) AS ordmonth, 
    ROUND(SUM(CASE WHEN YEAR(order_date) = 2022 THEN sale_price ELSE 0 END),2) AS 2022_Sales,
    ROUND(SUM(CASE WHEN YEAR(order_date) = 2023 THEN sale_price ELSE 0 END),2) AS 2023_Sales
FROM orders
WHERE YEAR(order_date) IN (2022, 2023)
GROUP BY ordmonth
ORDER BY ordmonth;

-- Finding the Month with highest sales for each category
SELECT category, ord_year_month, total_sales
FROM (
SELECT 
	category, 
    DATE_FORMAT(order_date, "%Y-%m") as ord_year_month, 
    ROUND(SUM(sale_price),2) as total_sales, 
    ROW_NUMBER () OVER (
		PARTITION BY category
        ORDER BY SUM(sale_price) DESC
	) AS row_num
FROM orders
GROUP BY category, ord_year_month
)t
WHERE row_num = 1
ORDER BY category, ord_year_month 

-- Finding the highest selling category & sub category in each state
 SELECT state, category, sub_category, total_sales
FROM (
    SELECT
        state,
        category,
        sub_category,
        ROUND(SUM(sale_price),2) AS total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY state
            ORDER BY SUM(sale_price) DESC
        ) AS rn
    FROM orders
    GROUP BY state, category, sub_category
) t
WHERE rn = 1
ORDER BY state; 