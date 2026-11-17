-- ==========================================
-- CP1 - Database Schema
-- Amazon Online Shopping
-- ==========================================

DROP SCHEMA IF EXISTS amazon CASCADE;

CREATE SCHEMA amazon;
SET search_path TO amazon;



CREATE TABLE cities (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL
);




CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT,
    is_digital BOOLEAN NOT NULL,

    CONSTRAINT fk_parent_category
        FOREIGN KEY (parent_category_id)
        REFERENCES categories(category_id)
        ON DELETE SET NULL
);




CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) UNIQUE,
    city_id INT NOT NULL,
    signup_date DATE NOT NULL,
    is_prime BOOLEAN NOT NULL,
    prime_since DATE,

    CONSTRAINT fk_customer_city
        FOREIGN KEY (city_id)
        REFERENCES cities(city_id),

    CONSTRAINT chk_prime_date
        CHECK (
            (is_prime = FALSE AND prime_since IS NULL)
            OR
            (is_prime = TRUE AND prime_since IS NOT NULL)
        )
);




CREATE TABLE sellers (
    seller_id INT PRIMARY KEY,
    business_name VARCHAR(150) NOT NULL,
    gstin VARCHAR(20) UNIQUE NOT NULL,
    city_id INT NOT NULL,
    joined_on DATE NOT NULL,
    seller_rating NUMERIC(2,1)
        CHECK (seller_rating BETWEEN 0 AND 5),
    status VARCHAR(20) NOT NULL
        CHECK (status IN ('ACTIVE','INACTIVE','SUSPENDED','CLOSED')),

    CONSTRAINT fk_seller_city
        FOREIGN KEY (city_id)
        REFERENCES cities(city_id)
);




CREATE TABLE addresses (
    address_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    label VARCHAR(30),
    line1 TEXT NOT NULL,
    city_id INT NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    is_default BOOLEAN NOT NULL,

    CONSTRAINT fk_address_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_address_city
        FOREIGN KEY (city_id)
        REFERENCES cities(city_id)
);




CREATE TABLE products (
    product_id INT PRIMARY KEY,
    asin VARCHAR(20) UNIQUE NOT NULL,
    seller_id INT NOT NULL,
    category_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    brand VARCHAR(100),
    mrp NUMERIC(10,2) NOT NULL
        CHECK (mrp >= 0),
    price NUMERIC(10,2) NOT NULL
        CHECK (price >= 0),
    stock_qty INT NOT NULL
        CHECK (stock_qty >= 0),
    is_prime_eligible BOOLEAN NOT NULL,
    avg_rating NUMERIC(2,1)
        CHECK (avg_rating BETWEEN 0 AND 5),
    review_count INT NOT NULL
        CHECK (review_count >= 0),
    listed_on DATE NOT NULL,
    status VARCHAR(20) NOT NULL
        CHECK (status IN ('ACTIVE','INACTIVE','OUT_OF_STOCK')),

    CONSTRAINT fk_product_seller
        FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id),

    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id),

    CONSTRAINT chk_price
        CHECK (price <= mrp)
);




CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    address_id INT,
    ordered_at TIMESTAMP NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    total_amount NUMERIC(10,2)
        CHECK (total_amount >= 0),
    status VARCHAR(30) NOT NULL,
    shipped_at TIMESTAMP,
    delivered_at TIMESTAMP,

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_order_address
        FOREIGN KEY (address_id)
        REFERENCES addresses(address_id)
);




CREATE TABLE order_items (
    order_id INT NOT NULL,
    line_no INT NOT NULL,
    product_id INT NOT NULL,
    seller_id INT NOT NULL,
    quantity INT NOT NULL
        CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL
        CHECK (unit_price >= 0),

    PRIMARY KEY (order_id, line_no),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
);




CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    line_no INT NOT NULL,
    reason TEXT,
    requested_at TIMESTAMP NOT NULL,
    status VARCHAR(30) NOT NULL,
    refund_amount NUMERIC(10,2)
        CHECK (refund_amount >= 0),

    FOREIGN KEY (order_id, line_no)
        REFERENCES order_items(order_id, line_no)
);




CREATE TABLE product_reviews (
    review_id INT PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT NOT NULL
        CHECK (rating BETWEEN 1 AND 5),
    title VARCHAR(255),
    body TEXT,
    verified_purchase BOOLEAN NOT NULL,
    helpful_votes INT DEFAULT 0
        CHECK (helpful_votes >= 0),
    created_at TIMESTAMP NOT NULL,

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);




CREATE TABLE cart_items (
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL
        CHECK (quantity > 0),
    added_at TIMESTAMP NOT NULL,

    PRIMARY KEY (customer_id, product_id),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE,

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);