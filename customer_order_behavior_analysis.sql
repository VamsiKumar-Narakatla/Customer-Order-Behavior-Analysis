-- 1: Overall KPIs
SELECT
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(order_id) AS total_orders,
    SUM(order_value) AS total_revenue
FROM orders
WHERE order_status = 'Completed';

-- 2: Orders per Customer
SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
WHERE order_status = 'Completed'
GROUP BY customer_id
ORDER BY total_orders DESC;

-- 3: Repeat vs One-Time Customers
SELECT
    customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT
        customer_id,
        CASE 
            WHEN COUNT(order_id) = 1 THEN 'One-Time Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
) t
GROUP BY customer_type;

-- 4: Average Order Value
SELECT
    AVG(order_value) AS avg_order_value
FROM orders
WHERE order_status = 'Completed';

-- 5: Top Customers by Revenue
SELECT
    customer_id,
    SUM(order_value) AS total_spent
FROM orders
WHERE order_status = 'Completed'
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 6: Monthly Orders & Revenue Trend
SELECT
    DATE_FORMAT(order_date,'%Y-%m') AS month,
    COUNT(order_id) AS total_orders,
    SUM(order_value) AS total_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY DATE_FORMAT(order_date,'%Y-%m')
ORDER BY month;

-- 7: Customer Lifetime Value
SELECT
    customer_id,
    SUM(order_value) AS customer_lifetime_value
FROM orders
WHERE order_status = 'Completed'
GROUP BY customer_id
ORDER BY customer_lifetime_value DESC;

-- 8: Customer Activity Span
SELECT
    customer_id,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MAX(order_date), MIN(order_date)) AS active_days
FROM orders
WHERE order_status = 'Completed'
GROUP BY customer_id
ORDER BY active_days DESC;

-- 9: Inactive Customers
SELECT
    customer_id,
    MAX(order_date) AS last_order_date
FROM orders
WHERE order_status = 'Completed'
GROUP BY customer_id
HAVING MAX(order_date) < DATE_SUB('2024-08-31', INTERVAL 60 DAY);

-- 10: Category Revenue
SELECT
    category,
    SUM(quantity * price) AS category_revenue
FROM order_items
GROUP BY category
ORDER BY category_revenue DESC;
