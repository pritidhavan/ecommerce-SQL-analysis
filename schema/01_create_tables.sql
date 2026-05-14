-- =====================================================
--   E-Commerce SQL Analysis — Database Schema
--   Project 1 | Priti | B.Tech AI & DS | PCU Pune
-- =====================================================

CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- Customers Table
CREATE TABLE IF NOT EXISTS customers (
    customer_id     INT PRIMARY KEY AUTO_INCREMENT,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    phone           VARCHAR(15),
    city            VARCHAR(50),
    state           VARCHAR(50),
    country         VARCHAR(50) DEFAULT 'India',
    age             INT,
    gender          ENUM('Male','Female','Other'),
    signup_date     DATE NOT NULL,
    is_active       BOOLEAN DEFAULT TRUE
);

-- Categories Table
CREATE TABLE IF NOT EXISTS categories (
    category_id     INT PRIMARY KEY AUTO_INCREMENT,
    category_name   VARCHAR(100) NOT NULL,
    parent_category VARCHAR(100)
);

-- Products Table
CREATE TABLE IF NOT EXISTS products (
    product_id      INT PRIMARY KEY AUTO_INCREMENT,
    product_name    VARCHAR(200) NOT NULL,
    category_id     INT,
    brand           VARCHAR(100),
    price           DECIMAL(10,2) NOT NULL,
    cost_price      DECIMAL(10,2) NOT NULL,
    stock_quantity  INT DEFAULT 0,
    rating          DECIMAL(3,2),
    is_active       BOOLEAN DEFAULT TRUE,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Orders Table
CREATE TABLE IF NOT EXISTS orders (
    order_id        INT PRIMARY KEY AUTO_INCREMENT,
    customer_id     INT NOT NULL,
    order_date      DATETIME NOT NULL,
    delivery_date   DATETIME,
    status          ENUM('Pending','Processing','Shipped','Delivered','Cancelled','Returned') DEFAULT 'Pending',
    payment_method  ENUM('UPI','Credit Card','Debit Card','COD','Net Banking'),
    shipping_city   VARCHAR(50),
    shipping_state  VARCHAR(50),
    discount_amount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items Table
CREATE TABLE IF NOT EXISTS order_items (
    item_id         INT PRIMARY KEY AUTO_INCREMENT,
    order_id        INT NOT NULL,
    product_id      INT NOT NULL,
    quantity        INT NOT NULL,
    unit_price      DECIMAL(10,2) NOT NULL,
    discount_pct    DECIMAL(5,2) DEFAULT 0,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Reviews Table
CREATE TABLE IF NOT EXISTS reviews (
    review_id       INT PRIMARY KEY AUTO_INCREMENT,
    product_id      INT NOT NULL,
    customer_id     INT NOT NULL,
    rating          INT CHECK (rating BETWEEN 1 AND 5),
    review_text     TEXT,
    review_date     DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

SELECT 'All tables created successfully!' AS status;