# Database Schema Design

## 1. Introduction

The Amazon Online Shopping Database is designed to store and manage data related to an e-commerce platform. The database supports customers, sellers, products, orders, reviews, shopping carts, and return management while maintaining data integrity and minimizing redundancy.

The schema follows relational database design principles and uses primary keys, foreign keys, constraints, and normalization to ensure consistency.

---

# 2. Database Tables

The database consists of the following tables:

1. Cities
2. Categories
3. Sellers
4. Customers
5. Addresses
6. Products
7. Orders
8. Order_Items
9. Returns
10. Product_Reviews
11. Cart_Items

---

# 3. Data Dictionary

## Cities

| Column | Data Type | Constraints |
|---------|-----------|-------------|
| city_id | INT | Primary Key |
| city_name | VARCHAR(100) | NOT NULL |
| state | VARCHAR(100) | NOT NULL |

Purpose:

Stores the cities used by customers, sellers, and addresses.

---

## Categories

| Column | Data Type | Constraints |
|---------|-----------|-------------|
| category_id | INT | Primary Key |
| category_name | VARCHAR(100) | NOT NULL |
| parent_category_id | INT | Foreign Key |
| is_digital | BOOLEAN | NOT NULL |

Purpose:

Stores product categories and supports hierarchical categories.

---

## Sellers

| Column | Data Type | Constraints |
|---------|-----------|-------------|
| seller_id | INT | Primary Key |
| business_name | VARCHAR(150) | NOT NULL |
| gstin | VARCHAR(20) | UNIQUE |
| city_id | INT | Foreign Key |
| joined_on | DATE | NOT NULL |
| seller_rating | NUMERIC | CHECK (0–5) |
| status | VARCHAR(20) | CHECK |

Purpose:

Stores seller information.

---

## Customers

| Column | Data Type | Constraints |
|---------|-----------|-------------|
| customer_id | INT | Primary Key |
| full_name | VARCHAR(150) | NOT NULL |
| email | VARCHAR(255) | UNIQUE |
| phone | VARCHAR(20) | UNIQUE |
| city_id | INT | Foreign Key |
| signup_date | DATE | NOT NULL |
| is_prime | BOOLEAN | NOT NULL |
| prime_since | DATE | CHECK |

Purpose:

Stores registered customer information.

---

## Addresses

| Column | Data Type | Constraints |
|---------|-----------|-------------|
| address_id | INT | Primary Key |
| customer_id | INT | Foreign Key |
| label | VARCHAR(30) | |
| line1 | TEXT | NOT NULL |
| city_id | INT | Foreign Key |
| pincode | VARCHAR(10) | NOT NULL |
| is_default | BOOLEAN | NOT NULL |

Purpose:

Stores customer delivery addresses.

---

## Products

| Column | Data Type | Constraints |
|---------|-----------|-------------|
| product_id | INT | Primary Key |
| asin | VARCHAR(20) | UNIQUE |
| seller_id | INT | Foreign Key |
| category_id | INT | Foreign Key |
| title | VARCHAR(255) | NOT NULL |
| brand | VARCHAR(100) | |
| mrp | NUMERIC | CHECK |
| price | NUMERIC | CHECK |
| stock_qty | INT | CHECK |
| is_prime_eligible | BOOLEAN | |
| avg_rating | NUMERIC | CHECK |
| review_count | INT | CHECK |
| listed_on | DATE | |
| status | VARCHAR(20) | CHECK |

Purpose:

Stores all products listed by sellers.

---

## Orders

Stores order information placed by customers.

---

## Order_Items

Stores individual products belonging to an order.

Composite Primary Key:

- order_id
- line_no

---

## Returns

Stores return requests and refund information.

---

## Product_Reviews

Stores customer ratings and reviews.

---

## Cart_Items

Stores products currently added to a customer's shopping cart.

Composite Primary Key:

- customer_id
- product_id

---

# 4. Primary Keys

The schema uses the following primary keys:

- city_id
- category_id
- seller_id
- customer_id
- address_id
- product_id
- order_id
- review_id
- return_id

Composite Keys:

- (order_id, line_no)
- (customer_id, product_id)

---

# 5. Foreign Keys

The database maintains referential integrity through foreign keys.

Examples include:

- Sellers → Cities
- Customers → Cities
- Addresses → Customers
- Addresses → Cities
- Products → Sellers
- Products → Categories
- Orders → Customers
- Orders → Addresses
- Order_Items → Orders
- Order_Items → Products
- Returns → Order_Items
- Product_Reviews → Products
- Product_Reviews → Customers
- Cart_Items → Customers
- Cart_Items → Products

---

# 6. Constraints

The schema uses the following constraints:

- PRIMARY KEY
- FOREIGN KEY
- UNIQUE
- NOT NULL
- CHECK

Example CHECK constraints include:

- Rating between 1 and 5
- Price greater than or equal to 0
- MRP greater than or equal to Price
- Quantity greater than 0
- Stock quantity greater than or equal to 0
- Seller rating between 0 and 5
- Refund amount greater than or equal to 0

---

# 7. Relationships

The database supports the following relationships:

- One city can have many customers.
- One city can have many sellers.
- One customer can have many addresses.
- One customer can place many orders.
- One seller can sell many products.
- One category can contain many products.
- One order contains multiple order items.
- One customer can write multiple product reviews.
- One customer can maintain multiple cart items.

---

# 8. Functional Dependencies

Examples:

customer_id → full_name, email, phone, city_id

seller_id → business_name, gstin, seller_rating

product_id → title, brand, price, seller_id

order_id → customer_id, ordered_at, payment_method

review_id → rating, title, body

---

# 9. Normalization

The schema satisfies First Normal Form (1NF) because all attributes are atomic.

It satisfies Second Normal Form (2NF) because every non-key attribute is fully dependent on the whole primary key.

It satisfies Third Normal Form (3NF) because transitive dependencies have been removed by separating customers, sellers, products, categories, addresses, and orders into individual tables.

Most relations also satisfy Boyce-Codd Normal Form (BCNF) because every determinant is a candidate key.

---

# 10. Integrity Checks

The database enforces the following integrity rules:

- Every order belongs to a valid customer.
- Every product belongs to a valid seller.
- Every review references an existing customer and product.
- Every cart item references a valid customer and product.
- Every return references an existing order item.
- Product prices cannot be negative.
- Ratings must be between 1 and 5.

---

# 11. ER Diagram

The Entity Relationship Diagram illustrates the relationships among all entities including customers, sellers, products, categories, orders, order items, reviews, returns, addresses, cities, and shopping carts.

The ER diagram is included in the `diagrams/er_diagram.png` file.

---

# 12. Conclusion

The proposed schema provides a normalized relational database for an online shopping platform. It minimizes redundancy, enforces referential integrity, supports efficient querying, and provides a scalable foundation for future enhancements.