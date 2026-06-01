-- 1. Retrieve all products with their brand names and category names
SELECT
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    p.model_year,
    p.list_price
FROM   production.products  p
JOIN   production.brands    b ON p.brand_id    = b.brand_id
JOIN   production.categories c ON p.category_id = c.category_id
ORDER BY p.product_name;

-- 2. Count the total number of products available in each category
SELECT
    c.category_name,
    COUNT(p.product_id) AS total_products
FROM   production.categories c
LEFT JOIN production.products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY total_products DESC;

-- 3. List all brands that have products priced above $500, along with product details
SELECT
    b.brand_name,
    p.product_name,
    p.list_price,
    p.model_year
FROM   production.products p
JOIN   production.brands   b ON p.brand_id = b.brand_id
WHERE  p.list_price > 500
ORDER BY b.brand_name, p.list_price DESC;

-- 4. Calculate the average price of products for each brand, sorted in descending order
SELECT
    b.brand_name,
    ROUND(AVG(p.list_price), 2) AS avg_price
FROM   production.products p
JOIN   production.brands   b ON p.brand_id = b.brand_id
GROUP BY b.brand_id, b.brand_name
ORDER BY avg_price DESC;

-- 5. Find the most expensive product in each category
SELECT
    c.category_name,
    p.product_name,
    p.list_price,
    b.brand_name
FROM   production.products    p
JOIN   production.categories  c ON p.category_id = c.category_id
JOIN   production.brands      b ON p.brand_id    = b.brand_id
WHERE  p.list_price = (
    SELECT MAX(p2.list_price)
    FROM   production.products p2
    WHERE  p2.category_id = p.category_id
)
ORDER BY c.category_name;

-- 6. Display all categories that have no associated products
SELECT
    c.category_id,
    c.category_name
FROM   production.categories c
LEFT JOIN production.products p ON c.category_id = p.category_id
WHERE  p.product_id IS NULL
ORDER BY c.category_name;

-- 7. List the top 3 most expensive products with their brands and categories
SELECT TOP 3
    p.product_name,
    b.brand_name,
    c.category_name,
    p.list_price
FROM   production.products    p
JOIN   production.brands      b ON p.brand_id    = b.brand_id
JOIN   production.categories  c ON p.category_id = c.category_id
ORDER BY p.list_price DESC;

-- 8. Calculate the percentage of total products contributed by each brand
SELECT
    b.brand_name,
    COUNT(p.product_id) AS product_count,
    ROUND(
        COUNT(p.product_id) * 100.0
        / (SELECT COUNT(*) FROM production.products),
        2
    ) AS percentage
FROM   production.products p
JOIN   production.brands   b ON p.brand_id = b.brand_id
GROUP BY b.brand_id, b.brand_name
ORDER BY percentage DESC;

-- 9. Identify products that belong to multiple categories (if applicable)
SELECT
    p.product_name,
    COUNT(DISTINCT p.category_id) AS category_count
FROM   production.products p
GROUP BY p.product_id, p.product_name
HAVING COUNT(DISTINCT p.category_id) > 1;

-- 10. Find products introduced after 2018 and group them by category with their count
SELECT
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM   production.products    p
JOIN   production.categories  c ON p.category_id = c.category_id
WHERE  p.model_year > 2018
GROUP BY c.category_id, c.category_name
ORDER BY product_count DESC;