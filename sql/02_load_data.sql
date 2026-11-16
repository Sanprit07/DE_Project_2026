-- ==========================================
-- CP1 - Load Seed Data
-- Amazon Online Shopping
-- ==========================================

SET search_path TO amazon;

-- Parent tables

-- The loading order we used respects the foreign-key dependencies

\copy cities FROM 'seed_data/cities.csv' CSV HEADER;

\copy categories FROM 'seed_data/categories.csv' CSV HEADER;

\copy sellers FROM 'seed_data/sellers.csv' CSV HEADER;

\copy customers FROM 'seed_data/customers.csv' CSV HEADER;

-- Tables depending on parent tables

\copy addresses FROM 'seed_data/addresses.csv' CSV HEADER;

\copy products FROM 'seed_data/products.csv' CSV HEADER;

\copy orders FROM 'seed_data/orders.csv' CSV HEADER;

\copy order_items FROM 'seed_data/order_items.csv' CSV HEADER;

\copy returns FROM 'seed_data/returns.csv' CSV HEADER;

\copy product_reviews FROM 'seed_data/product_reviews.csv' CSV HEADER;

\copy cart_items FROM 'seed_data/cart_items.csv' CSV HEADER;

ANALYZE;