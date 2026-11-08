
-- 1. Monthly revenue analysis
SELECT
    YEAR(invoice_date) AS year,
    MONTH(invoice_date) AS month,
    ROUND(SUM(invoice_total), 2) AS revenue,
    SUM(total_quantity) AS units_sold,
    COUNT(*) AS invoice_count
FROM workspace.retail_warehouse.gold_invoice_summary
GROUP BY YEAR(invoice_date), MONTH(invoice_date)
ORDER BY year, month;


-- 2. Top 10 customers by revenue
SELECT
    customer_id,
    country,
    COUNT(*) AS invoice_count,
    ROUND(SUM(invoice_total), 2) AS total_revenue
FROM workspace.retail_warehouse.gold_invoice_summary
WHERE customer_id IS NOT NULL
GROUP BY customer_id, country
ORDER BY total_revenue DESC
LIMIT 10;


-- 3. Sales by country
SELECT
    country,
    COUNT(*) AS invoice_count,
    SUM(total_quantity) AS units_sold,
    ROUND(SUM(invoice_total), 2) AS revenue
FROM workspace.retail_warehouse.gold_invoice_summary
GROUP BY country
ORDER BY revenue DESC;


-- 4. Silver-to-Gold revenue reconciliation
SELECT
    ROUND(s.silver_revenue, 2) AS silver_revenue,
    ROUND(g.gold_revenue, 2) AS gold_revenue,
    ROUND(s.silver_revenue - g.gold_revenue, 2) AS revenue_difference,
    CASE
        WHEN ABS(s.silver_revenue - g.gold_revenue) < 0.01
        THEN 'PASS'
        ELSE 'FAIL'
    END AS validation_status
FROM
    (
        SELECT SUM(total_amount) AS silver_revenue
        FROM workspace.retail_warehouse.silver_retail_transactions
    ) s
CROSS JOIN
    (
        SELECT SUM(invoice_total) AS gold_revenue
        FROM workspace.retail_warehouse.gold_invoice_summary
    ) g;
