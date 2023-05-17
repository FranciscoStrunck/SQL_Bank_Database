-- Criando o banco de dados
CREATE DATABASE BANK;
-- Selecionando o banco de dados para trabalhar nele
USE BANK;

-- Criando a tabela "clients"
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
  credit_score INT,
  -- Criando a chave primária - cada cliente tera um "client_id" unico
  PRIMARY KEY (client_id));

CREATE TABLE accounts (
  account_id INT AUTO_INCREMENT,
  client_id INT,
  account_type VARCHAR(20),
  opening_date DATE,
  account_status TINYINT(1),
  total_amount FLOAT,
  PRIMARY KEY (account_id),
  -- Determina que "client_id" da tabela "accounts" está relacionada com "client_id" da tabela "clients" 
  FOREIGN KEY (client_id) REFERENCES clients(client_id));
  
/*
Uma chave estrangeira em uma tabela aponta para uma chave primária em outra tabela. As chaves estrangeiras são usadas para
estabelecer e impor um vínculo entre os dados em duas tabelas, a fim de controlar os dados que podem ser armazenados na tabela
de chaves estrangeiras.

Por exemplo, na tabela 'accounts', a coluna 'client_id' é uma chave estrangeira que aponta para a chave primária 'client_id'
na tabela 'clients'. Isso significa que para cada registro na tabela 'accounts', o valor em 'client_id' deve corresponder a
um valor existente em 'client_id' na tabela 'clients'.

Mas note que 'client_id' na tabela 'accounts' não necessariamente precisa ter o mesmo nome que na tabela 'clients', poderia
ser 'c_id' ou 'id_cliente', por exemplo. O que importa é que ele faça referência à chave primária adequada na outra tabela.

No entanto, em muitos casos, é conveniente e mais compreensível manter os mesmos nomes para chaves primárias e estrangeiras
que se correlacionam.
*/
  
  CREATE TABLE transactions (
  transaction_id INT AUTO_INCREMENT,
  account_id INT,
  transaction_type VARCHAR(20),
  transaction_date DATE,  
  amount FLOAT,
  fraudulent TINYINT(1) default 0,
  PRIMARY KEY (transaction_id),
  FOREIGN KEY (account_id) REFERENCES accounts(account_id));

-- Criação de indice para tornar a busca de dados mais rápida
CREATE INDEX idx_clients_identification
ON clients (identification);

CREATE INDEX idx_clients_client_name
ON clients (client_name);

CREATE INDEX idx_accounts_client_id
ON accounts (client_id);

CREATE INDEX idx_transactions_account_id
ON transactions (account_id);

/* Adição de uma restrição para garantir que todos os valores da coluna de identificação sejam
dififerentes, uma vez que cada pessoa tem apenas um documento de identidade */
ALTER TABLE clients
ADD CONSTRAINT unique_identification
UNIQUE (identification);

SELECT * FROM clients;
SELECT * FROM accounts;
SELECT * FROM transactions;