CREATE DATABASE BANK;
USE BANK;

CREATE TABLE clients (
  client_id INT AUTO_INCREMENT,
  client_name VARCHAR(50),
  identification VARCHAR(20),
  street_address VARCHAR(100),
  city VARCHAR(100),
  state VARCHAR(100),
  email VARCHAR(100),
  phone_number VARCHAR(20),
  date_of_birth DATE,
  PRIMARY KEY (client_id));

CREATE TABLE accounts (
  account_id INT AUTO_INCREMENT,
  client_id INT,
  account_type VARCHAR(20),
  opening_date DATE,
  account_status TINYINT(1),
  total_amount FLOAT,
  PRIMARY KEY (account_id),
  FOREIGN KEY (client_id) REFERENCES clients(client_id));
  
  CREATE TABLE transactions (
  transaction_id INT AUTO_INCREMENT,
  account_id INT,
  transaction_type VARCHAR(20),
  transaction_date DATE,  
  amount FLOAT,
  fraudulent TINYINT(1) default 0,
  PRIMARY KEY (transaction_id),
  FOREIGN KEY (account_id) REFERENCES accounts(account_id));

CREATE INDEX idx_clients_identification
ON clients (identification);

CREATE INDEX idx_clients_client_name
ON clients (client_name);

CREATE INDEX idx_accounts_client_id
ON accounts (client_id);

CREATE INDEX idx_transactions_account_id
ON transactions (account_id);

ALTER TABLE clients
ADD CONSTRAINT unique_identification
UNIQUE (identification);




