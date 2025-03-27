--drop table housing_data;
--TABLE IF EXISTS real_estate_data;,
--\copy housing_data FROM 'C:\Users\derej\OneDrive\Desktop\Boot_Camp\project_4_datasets\cleaned_completed_data.csv' WITH CSV HEADER;
\COPY housing_data
FROM 'C:\Users\derej\OneDrive\Desktop\Boot_Camp\project_4_datasets\cleaned_completed_data.csv'
DELIMITER ','
CSV HEADER;
CREATE TABLE housing_data (
    date DATE,
    index_sa DOUBLE PRECISION,
    redfin_hpi_mom DOUBLE PRECISION,
    case_shiller_index_mom DOUBLE PRECISION,
    period_duration INTEGER,
    region_type TEXT,
    table_id INTEGER,
    is_seasonally_adjusted BOOLEAN,
    region TEXT,
    state TEXT,
    property_type TEXT,
    median_sale_price INTEGER,
    median_sale_price_mom DOUBLE PRECISION,
    median_sale_price_yoy DOUBLE PRECISION,
    median_list_price DOUBLE PRECISION,
    median_list_price_mom DOUBLE PRECISION,
    median_list_price_yoy DOUBLE PRECISION,
    median_ppsf DOUBLE PRECISION,
    median_ppsf_mom DOUBLE PRECISION,
    median_ppsf_yoy DOUBLE PRECISION,
    median_list_ppsf DOUBLE PRECISION,
    median_list_ppsf_mom DOUBLE PRECISION,
    median_list_ppsf_yoy DOUBLE PRECISION,
    homes_sold INTEGER,
    homes_sold_mom DOUBLE PRECISION,
    homes_sold_yoy DOUBLE PRECISION,
    pending_sales DOUBLE PRECISION,
    pending_sales_mom DOUBLE PRECISION,
    pending_sales_yoy DOUBLE PRECISION,
    new_listings DOUBLE PRECISION,
    new_listings_mom DOUBLE PRECISION,
    new_listings_yoy DOUBLE PRECISION,
    inventory DOUBLE PRECISION,
    inventory_mom DOUBLE PRECISION,
    inventory_yoy DOUBLE PRECISION,
    months_of_supply DOUBLE PRECISION,
    months_of_supply_mom DOUBLE PRECISION,
    months_of_supply_yoy DOUBLE PRECISION,
    median_dom DOUBLE PRECISION,
    median_dom_mom DOUBLE PRECISION,
    median_dom_yoy DOUBLE PRECISION,
    avg_sale_to_list DOUBLE PRECISION,
    avg_sale_to_list_mom DOUBLE PRECISION,
    avg_sale_to_list_yoy DOUBLE PRECISION,
    sold_above_list DOUBLE PRECISION,
    sold_above_list_mom DOUBLE PRECISION,
    sold_above_list_yoy DOUBLE PRECISION,
    price_drops DOUBLE PRECISION,
    price_drops_mom DOUBLE PRECISION,
    price_drops_yoy DOUBLE PRECISION,
    off_market_in_two_weeks DOUBLE PRECISION,
    off_market_in_two_weeks_mom DOUBLE PRECISION,
    off_market_in_two_weeks_yoy DOUBLE PRECISION,
    "30_year_%" DOUBLE PRECISION,
    price_drops_is_blank BOOLEAN,
    price_drops_mom_is_blank BOOLEAN,
    price_drops_yoy_is_blank BOOLEAN
);

--Select few rows from the housing_data

select * from housing_data
limit 5

-- Total rows

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT state) AS unique_states
FROM housing_data
SELECT 
    (SELECT COUNT(*) FROM housing_data) AS total_rows,
    (SELECT COUNT(DISTINCT state) FROM housing_data) AS unique_states,
    (SELECT COUNT(*) 
     FROM housing_data;
-- Average median sale price per state

SELECT state, ROUND(AVG(median_sale_price), 2) AS avg_sale_price
FROM housing_data
GROUP BY state
ORDER BY avg_sale_price DESC


-- Top 10 States by Homes Sold in Latest Month

SELECT
    state,
    MAX(date) AS latest_date,
    SUM(homes_sold) AS total_homes_sold
FROM housing_data
WHERE date = (SELECT MAX(date) FROM housing_data)
GROUP BY state
ORDER BY total_homes_sold DESC
LIMIT 10;

-- avg inventory and avg new listing by state

SELECT
    state,
    ROUND(AVG(inventory)) AS avg_inventory,
    ROUND(AVG(new_listings)) AS avg_new_listings
FROM housing_data
GROUP BY state
ORDER BY avg_inventory DESC;

--categorizes homes by price range.

SELECT
  region,
  median_sale_price ,
  CASE
    WHEN median_sale_price > 750000 THEN 'Luxury'
    WHEN median_sale_price > 250000 THEN 'Mid-Range'
    ELSE 'Affordable'
  END AS price_category
FROM housing_data
ORDER BY price_category, region;

--- Sold Above List percentage MN vs. All

SELECT
    CASE WHEN state = 'Minnesota' THEN 'Minnesota' ELSE 'Other States' END AS region_group,
    ROUND(CAST(AVG(sold_above_list) * 100 AS NUMERIC), 2) AS avg_sold_above_list_percent
FROM housing_data
GROUP BY region_group;

--Days on Market MN vs. Others

SELECT
    CASE WHEN state = 'Minnesota' THEN 'Minnesota' ELSE 'Other States' END AS region_group,
    ROUND(CAST(AVG(median_dom) AS NUMERIC), 2) AS avg_days_on_market
FROM housing_data
GROUP BY region_group;

---Average price drop % MN vs other states

SELECT
    CASE WHEN state = 'Minnesota' THEN 'Minnesota' ELSE 'Other States' END AS region_group,
    ROUND(CAST(AVG(price_drops) * 100 AS NUMERIC), 2) AS avg_price_drop_percent
FROM housing_data
GROUP BY region_group
--Top 10 States by % of Homes Sold Above List Price
SELECT
    state,
    ROUND(CAST(AVG(sold_above_list) * 100 AS NUMERIC), 2) AS avg_sold_above_list_percent
FROM housing_data
GROUP BY state
ORDER BY avg_sold_above_list_percent DESC
LIMIT 10;
--Max days on the market per state
SELECT
    region,
    state,
    MAX(median_dom) AS max_days_on_market
FROM
    housing_data
GROUP BY
    region, state
ORDER BY
    max_days_on_market ;

