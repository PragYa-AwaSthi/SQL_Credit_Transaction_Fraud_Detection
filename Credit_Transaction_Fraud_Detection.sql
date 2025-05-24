DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS cardholders;
DROP TABLE IF EXISTS merchants;

CREATE TABLE cardholders (
    cardholder_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    country VARCHAR(50),
    credit_limit DECIMAL(10, 2) NOT NULL
);

CREATE TABLE merchants (
    merchant_id INT PRIMARY KEY,
    merchant_name VARCHAR(100) NOT NULL,
    merchant_category VARCHAR(50), -- e.g., 'Groceries', 'Online Retail', 'Travel'
    merchant_city VARCHAR(100),
    merchant_country VARCHAR(50)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    cardholder_id INT NOT NULL,
    merchant_id INT NOT NULL,
    transaction_date_time DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    transaction_type VARCHAR(20), -- e.g., 'Purchase', 'Refund', 'ATM Withdrawal'
    location VARCHAR(100),        -- City or country of transaction
    is_fraudulent NUMBER(1) DEFAULT 0,  -- 1 for TRUE, 0 for FALSE
    FOREIGN KEY (cardholder_id) REFERENCES cardholders(cardholder_id),
    FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id)
);

INSERT INTO cardholders (cardholder_id, first_name, last_name, email, phone_number, address, city, state, zip_code, country, credit_limit) VALUES
(1001, 'Alice', 'Smith', 'alice.smith@example.com', '555-111-2222', '123 Main St', 'New York', 'NY', '10001', 'USA', 5000.00),
(1002, 'Bob', 'Johnson', 'bob.johnson@example.com', '555-333-4444', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA', 7500.00),
(1003, 'Carol', 'Davis', 'carol.davis@example.com', '555-555-6666', '789 Pine Rd', 'Chicago', 'IL', '60601', 'USA', 10000.00),
(1004, 'David', 'Brown', 'david.brown@example.com', '555-777-8888', '101 Elm Blvd', 'Houston', 'TX', '77001', 'USA', 6000.00),
(1005, 'Eve', 'Miller', 'eve.miller@example.com', '555-999-0000', '202 Birch Ln', 'Miami', 'FL', '33101', 'USA', 8000.00);

-- Merchants
INSERT INTO merchants (merchant_id, merchant_name, merchant_category, merchant_city, merchant_country) VALUES
(2001, 'Amazon', 'Online Retail', NULL, 'USA'),
(2002, 'Walmart', 'Supermarket', 'Bentonville', 'USA'),
(2003, 'Starbucks', 'Coffee Shop', 'Seattle', 'USA'),
(2004, 'Shell Gas Station', 'Fuel', 'Houston', 'USA'),
(2005, 'Best Buy', 'Electronics', 'Richfield', 'USA'),
(2006, 'Fancy Clothes Boutique', 'Apparel', 'Paris', 'France'), -- International merchant
(2007, 'Quick Food Mart', 'Convenience Store', 'New York', 'USA'),
(2008, 'Airline Tickets Online', 'Travel', NULL, 'USA');


-- Transactions
-- Legitimate Transactions
INSERT INTO transactions (transaction_id, cardholder_id, merchant_id, transaction_date_time, amount, currency, transaction_type, location, is_fraudulent) VALUES
(1, 1001, 2002, TO_DATE('2023-10-26 10:00:00','YYYY-MM-DD HH24:MI:SS'), 55.75, 'USD', 'Purchase', 'New York, USA', 0),
(2, 1001, 2003, TO_DATE('2023-10-26 11:30:00','YYYY-MM-DD HH24:MI:SS'), 4.50, 'USD', 'Purchase', 'New York, USA', 0),
(3, 1002, 2001, TO_DATE('2023-10-26 14:00:00','YYYY-MM-DD HH24:MI:SS'), 120.00, 'USD', 'Purchase', 'Online', 0),
(4, 1003, 2005, TO_DATE('2023-10-26 16:30:00','YYYY-MM-DD HH24:MI:SS'), 899.99, 'USD', 'Purchase', 'Chicago, USA', 0),
(5, 1004, 2004, TO_DATE('2023-10-26 18:00:00','YYYY-MM-DD HH24:MI:SS'), 60.25, 'USD', 'Purchase', 'Houston, USA', 0),
(6, 1001, 2007, TO_DATE('2023-10-27 09:00:00','YYYY-MM-DD HH24:MI:SS'), 15.00, 'USD', 'Purchase', 'New York, USA', 0),
(7, 1002, 2003, TO_DATE('2023-10-27 12:00:00','YYYY-MM-DD HH24:MI:SS'), 7.25, 'USD', 'Purchase', 'Los Angeles, USA', 0),
(8, 1005, 2001, TO_DATE('2023-10-27 15:00:00','YYYY-MM-DD HH24:MI:SS'), 25.50, 'USD', 'Purchase', 'Online', 0),
(9, 1003, 2002, TO_DATE('2023-10-28 10:30:00','YYYY-MM-DD HH24:MI:SS'), 30.00, 'USD', 'Purchase', 'Chicago, USA', 0),
(10, 1004, 2008, TO_DATE('2023-10-28 11:00:00','YYYY-MM-DD HH24:MI:SS'), 450.00, 'USD', 'Purchase', 'Online', 0);

-- Fraudulent Transactions (examples of common fraud patterns)
INSERT INTO transactions (transaction_id, cardholder_id, merchant_id, transaction_date_time, amount, currency, transaction_type, location, is_fraudulent) VALUES
-- High-value transaction shortly after a normal one
(11, 1001, 2001, TO_DATE('2023-10-26 10:05:00','YYYY-MM-DD HH24:MI:SS'), 1500.00, 'USD', 'Purchase', 'Online', 1), -- Suspiciously high for Alice so soon after a small purchase

-- International transaction while cardholder is supposedly local
(12, 1001, 2006, TO_DATE('2023-10-26 11:45:00','YYYY-MM-DD HH24:MI:SS'), 300.00, 'EUR', 'Purchase', 'Paris, France', 1), -- Alice is in NY, but transaction in Paris

-- Multiple small, rapid transactions (card testing)
(13, 1003, 2007, TO_DATE('2023-10-27 02:01:00','YYYY-MM-DD HH24:MI:SS'), 1.00, 'USD', 'Purchase', 'New York, USA', 1),
(14, 1003, 2007, TO_DATE('2023-10-27 02:02:00','YYYY-MM-DD HH24:MI:SS'), 1.00, 'USD', 'Purchase', 'New York, USA', 1),
(15, 1003, 2007, TO_DATE('2023-10-27 02:03:00','YYYY-MM-DD HH24:MI:SS'), 1.00, 'USD', 'Purchase', 'New York, USA', 1),

-- Large purchase at unusual hour
(16, 1002, 2005, TO_DATE('2023-10-28 03:30:00','YYYY-MM-DD HH24:MI:SS'), 700.00, 'USD', 'Purchase', 'Los Angeles, USA', 1),

-- Transaction exceeding credit limit (hypothetical, as a real system would block this)
(17, 1005, 2001, TO_DATE('2023-10-29 09:00:00','YYYY-MM-DD HH24:MI:SS'), 9000.00, 'USD', 'Purchase', 'Online', 1);

-- 3. SQL Queries for Fraud Detection Patterns

SELECT
    t.transaction_id,
    c.first_name,
    c.last_name,
    m.merchant_name,
    t.transaction_date_time,
    t.amount,
    t.location,
    t.is_fraudulent
FROM
    transactions t
JOIN
    cardholders c ON t.cardholder_id = c.cardholder_id
JOIN
    merchants m ON t.merchant_id = m.merchant_id
WHERE
    t.is_fraudulent = TRUE;

-- Query 2: Transactions with unusually high amounts for a cardholder's average
-- (This requires calculating average, so it's a bit more complex)
-- For simplicity, let's just pick transactions above a certain threshold for a cardholder.
SELECT
    t.transaction_id,
    c.first_name,
    c.last_name,
    m.merchant_name,
    t.transaction_date_time,
    t.amount
FROM
    transactions t
JOIN
    cardholders c ON t.cardholder_id = c.cardholder_id
JOIN
    merchants m ON t.merchant_id = m.merchant_id
WHERE
    t.amount > (SELECT AVG(amount) * 5 FROM transactions WHERE cardholder_id = c.cardholder_id) -- 5x average
ORDER BY
    c.cardholder_id, t.amount DESC;

-- Query 3: Transactions occurring in geographically disparate locations within a short time frame
-- This requires comparing transaction locations and timestamps.
-- For this simple SQL example, we'll look for transactions outside the cardholder's city/country.
SELECT
    t.transaction_id,
    c.first_name,
    c.last_name,
    m.merchant_name,
    t.transaction_date_time,
    t.amount,
    t.location AS transaction_location,
    c.city AS cardholder_city,
    c.country AS cardholder_country,
    m.merchant_country
FROM
    transactions t
JOIN
    cardholders c ON t.cardholder_id = c.cardholder_id
JOIN
    merchants m ON t.merchant_id = m.merchant_id
WHERE
    (t.location IS NOT NULL AND c.city IS NOT NULL AND t.location NOT LIKE '%' || c.city || '%') -- Location mismatch with cardholder's city
    OR (t.location IS NOT NULL AND c.country IS NOT NULL AND t.location NOT LIKE '%' || c.country || '%') -- Location mismatch with cardholder's country
    OR (m.merchant_country IS NOT NULL AND c.country IS NOT NULL AND m.merchant_country <> c.country); -- Merchant country mismatch with cardholder country


-- Query 4: Multiple small, rapid transactions from the same cardholder (potential card testing)
SELECT
    t.cardholder_id,
    c.first_name,
    c.last_name,
    COUNT(t.transaction_id) AS number_of_transactions,
    MIN(t.transaction_date_time) AS first_transaction,
    MAX(t.transaction_date_time) AS last_transaction,
    SUM(t.amount) AS total_amount_in_period
FROM
    transactions t
JOIN
    cardholders c ON t.cardholder_id = c.cardholder_id
WHERE
    t.amount < 10.00 -- Small amount
    AND t.transaction_date_time >= SYSDATE - INTERVAL '5' MINUTE -- In the last 5 minutes (adjust as needed)
GROUP BY
    t.cardholder_id, c.first_name, c.last_name
HAVING
    COUNT(t.transaction_id) > 2; -- More than 2 small transactions in 5 minutes

-- Query 5: Transactions at unusual hours (e.g., between 1 AM and 5 AM local time)
SELECT
    t.transaction_id,
    c.first_name,
    c.last_name,
    m.merchant_name,
    t.transaction_date_time,
    t.amount
FROM
    transactions t
JOIN
    cardholders c ON t.cardholder_id = c.cardholder_id
JOIN
    merchants m ON t.merchant_id = m.merchant_id
WHERE
    TO_NUMBER(TO_CHAR(t.transaction_date_time, 'HH24')) BETWEEN '01' AND '05'; -- Adjust for specific hours (01 to 05 for 1 AM to 5 AM)

-- Query 6: Transactions exceeding credit limit (for analysis of attempted fraud)
SELECT
    t.transaction_id,
    c.first_name,
    c.last_name,
    t.amount,
    c.credit_limit
FROM
    transactions t
JOIN
    cardholders c ON t.cardholder_id = c.cardholder_id
WHERE
    t.amount > c.credit_limit;