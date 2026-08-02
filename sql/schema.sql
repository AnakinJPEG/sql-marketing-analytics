CREATE DATABASE marketing_analytics;
USE marketing_analytics;

-- 1. Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    signup_date DATE,
    country VARCHAR(50),
    age_group VARCHAR(20),
    lifetime_value DECIMAL(10,2)
);

-- 2. Campaigns
CREATE TABLE campaigns (
    campaign_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    channel VARCHAR(50),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10,2)
);

-- 3. Campaign Contacts
CREATE TABLE campaign_contacts (
    customer_id INT,
    campaign_id INT,
    contact_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

-- 4. Conversions
CREATE TABLE conversions (
    conversion_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    campaign_id INT,
    conversion_date DATE,
    revenue DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

-- 5. Products (optional)
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);
