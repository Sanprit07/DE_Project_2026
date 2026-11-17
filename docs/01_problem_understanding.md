# Problem Understanding

## Project Overview

The Amazon Online Shopping Database Management System is designed to efficiently manage the data and operations of an online e-commerce platform. It stores and organizes information related to customers, sellers, products, categories, orders, addresses, shopping carts, reviews, and returns. The objective is to provide a structured and reliable database that supports daily business operations while maintaining data integrity and consistency.

---

## Business Problem

An online shopping platform handles thousands of transactions every day. Without a properly designed database, managing customers, products, orders, and sellers becomes difficult and leads to data redundancy, inconsistency, and slow query performance.

The system must efficiently support customer purchases, inventory management, order tracking, product reviews, and return processing while ensuring accurate relationships between different entities.

---

## Stakeholders

### Customers

Customers use the platform to browse products, maintain shopping carts, place orders, review products, and request returns.

### Sellers

Sellers list products, manage inventory, update pricing, and fulfill customer orders.

### Administrators

Administrators manage categories, monitor sellers, maintain customer records, and ensure smooth platform operation.

---

## Functional Requirements

The database should support the following operations:

- Customer registration and profile management
- Seller registration and management
- Product listing and inventory management
- Category management
- Shopping cart management
- Order placement
- Order tracking
- Product reviews and ratings
- Return and refund processing
- Customer address management

---

## Data Requirements

The database stores information about:

- Cities
- Categories
- Sellers
- Products
- Customers
- Addresses
- Orders
- Order Items
- Product Reviews
- Shopping Cart
- Returns

---

## Relationships

The system maintains relationships such as:

- One customer can have multiple addresses.
- One customer can place multiple orders.
- One seller can sell multiple products.
- One category can contain multiple products.
- One order can contain multiple order items.
- One customer can review multiple products.
- One customer can add multiple products to the cart.

---

## Assumptions

The following assumptions are made while designing the database:

- Every customer has a unique email address.
- Every seller has a unique GST number.
- Every product belongs to exactly one seller.
- Every product belongs to one category.
- Every order belongs to one customer.
- Every order uses one delivery address.
- Ratings are between 1 and 5.
- Product prices cannot be negative.
- Stock quantity cannot be negative.

---

## Real-Time Operations

The following operations are customer-facing and require fast response:

- Product search
- Add to cart
- Place order
- Product reviews
- Return requests

---

## Reporting Operations

The following operations are mainly analytical:

- Total sales by seller
- Category-wise sales
- Top-selling products
- Customer purchase history
- Seller performance reports
- Product rating analysis

---

## Conclusion

The proposed database provides a structured design for managing an online shopping platform. It minimizes redundancy through normalization, enforces data integrity using constraints, and supports efficient querying for both operational and analytical workloads.