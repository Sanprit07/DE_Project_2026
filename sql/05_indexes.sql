CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_products_title_trgm_cp3
ON amazon.products USING GIN (title gin_trgm_ops)
WHERE status = 'ACTIVE';

CREATE INDEX idx_reviews_body_trgm_cp3
ON amazon.product_reviews USING GIN (body gin_trgm_ops);

CREATE INDEX idx_categories_parent_cp3
ON amazon.categories (parent_category_id);

CREATE INDEX idx_products_category_status_price_cp3
ON amazon.products (category_id, status, price);

CREATE INDEX idx_reviews_product_rating_cp3
ON amazon.product_reviews (product_id, rating);

CREATE INDEX idx_orders_customer_date_cp3
ON amazon.orders (customer_id, ordered_at DESC);

CREATE INDEX idx_orders_shipped_date_cp3
ON amazon.orders (shipped_at)
WHERE status = 'SHIPPED';

CREATE INDEX idx_order_items_seller_order_cp3
ON amazon.order_items (seller_id, order_id)
INCLUDE (product_id, quantity, unit_price);

CREATE INDEX idx_cart_items_added_cp3
ON amazon.cart_items (added_at)
INCLUDE (customer_id, product_id, quantity);

CREATE INDEX idx_orders_address_cp3
ON amazon.orders (address_id);

CREATE INDEX idx_returns_order_line_cp3
ON amazon.returns (order_id, line_no);

CREATE INDEX idx_order_items_order_product_cp3
ON amazon.order_items (order_id, product_id)
INCLUDE (quantity);

CREATE INDEX idx_reviews_verified_customer_product_cp3
ON amazon.product_reviews (customer_id, product_id)
WHERE verified_purchase = TRUE;

CREATE INDEX idx_customers_city_cp3
ON amazon.customers (city_id, customer_id);

CREATE INDEX idx_orders_date_cp3
ON amazon.orders (ordered_at);

CREATE INDEX idx_order_items_product_id_cp3
ON amazon.order_items (product_id)
INCLUDE (quantity, order_id);
