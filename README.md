# SQL_Credit_Transaction_Fraud_Detection

This SQL script creates a basic fraud detection system by defining tables for cardholders, merchants, and transactions. It includes sample data with both normal and suspicious activity, such as high-value purchases shortly after small ones, international charges, rapid low-value transactions, and spending at odd hours or over credit limits. The script also includes queries to detect these patterns, helping identify potentially fraudulent behavior based on location mismatches, transaction timing, and abnormal amounts.



🏗️ 1. Schema Creation

You define three main tables:
cardholders:

Holds personal details of credit card users (name, email, credit limit, etc.)
merchants:

Contains information about businesses where transactions occur (e.g., Amazon, Walmart).
transactions:

Tracks all purchases, including amount, time, location, and fraud status.



🧪 2. Test Data Insertion

You insert realistic data to simulate:

    Legitimate transactions

    Fraudulent scenarios like:

        Large purchases soon after small ones

        International transactions

        Multiple low-value charges (possible card testing)

        Activity during odd hours (e.g., 2 AM)

        Purchases exceeding the cardholder’s credit limit




🕵️ 3. Fraud Detection Queries

You run six analytical queries, each targeting a common fraud pattern:
🔍 Query 1: Identify Marked Fraud

Finds transactions explicitly flagged as is_fraudulent = 1.
📊 Query 2: Unusually High Amounts

Compares each transaction against the cardholder’s average spending.

t.amount > (SELECT AVG(amount) * 5 FROM transactions WHERE cardholder_id = c.cardholder_id)

🌍 Query 3: Geographic Mismatches

Looks for:

    Mismatches between transaction and cardholder location

    Differences in merchant and cardholder countries





⚡ Query 4: Rapid Small Transactions

Flags multiple transactions under $10 within 5 minutes — a sign of card testing.
🌙 Query 5: Unusual Hours

Finds transactions between 1 AM and 5 AM, which are often higher-risk.

TO_NUMBER(TO_CHAR(t.transaction_date_time, 'HH24')) BETWEEN 1 AND 5

    🔧 Note: You had '01' AND '05' (as strings) — should be numbers as shown above.

💳 Query 6: Exceeding Credit Limits

Detects transactions where the amount exceeds the cardholder’s credit limit.
✅ Summary

Your script is:

    Well-structured for setting up a test environment

    Realistic in simulating different types of fraud

    A strong starting point for fraud detection models or dashboards

Would you like help expanding this into a dashboard, visualization, or stored procedure for automated fraud checks?
You said:
summarize
ChatGPT said:

Here's a concise summary of your SQL script:
🔐 Purpose:

To simulate and analyze credit card transactions for fraud detection using SQL.
📂 Database Structure:

    cardholders: Stores personal info and credit limits of users.

    merchants: Contains business details where transactions occur.

    transactions: Logs each card transaction, including amount, location, time, and fraud status.

🧪 Test Data Includes:

    Normal, everyday transactions.

    Simulated fraudulent behavior:

        Large purchases shortly after small ones.

        International use inconsistent with user location.

        Rapid small charges (possible card testing).

        Activity during odd hours (e.g., 2–5 AM).

        Purchases above credit limits.

🕵️ Fraud Detection Queries:

    Flagged fraud (where is_fraudulent = 1)

    Transactions much higher than the user’s average

    Location mismatches between user and transaction

    Rapid small transactions (potential card testing)

    Transactions at unusual hours (1–5 AM)

    Amounts exceeding credit limits
