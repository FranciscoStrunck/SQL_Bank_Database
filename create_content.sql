USE BANK;

DELIMITER //
CREATE PROCEDURE CreateAccount(IN input_client_id INT)
BEGIN
    DECLARE dob DATE;
    DECLARE rand FLOAT;
    DECLARE account_type VARCHAR(30);
    DECLARE account_status TINYINT(1);
    DECLARE opening_date DATE;
    DECLARE total_amount FLOAT;

    SELECT date_of_birth INTO dob FROM clients WHERE client_id = input_client_id;

    SET rand = RAND();
    SET account_type = CASE
        WHEN rand < 0.8 THEN 'Conta Corrente'
        WHEN rand < 0.9 THEN 'Conta Poupança'
        ELSE 'Conta Empresarial'
    END;

    SET rand = RAND();
    SET account_status = CASE
        WHEN rand < 0.9 THEN 1
        ELSE 0
    END;

    SET opening_date = DATE_ADD(dob, INTERVAL FLOOR(20 + RAND() * 21) YEAR);
    SET total_amount = 1000 + RAND() * 499000;

    INSERT INTO accounts(client_id, account_type, opening_date, account_status, total_amount) 
    VALUES (input_client_id, account_type, opening_date, account_status, total_amount);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_client_insert 
AFTER INSERT ON clients
FOR EACH ROW 
BEGIN
  CALL CreateAccount(NEW.client_id);
END; //
DELIMITER ;

-- DELETE FROM clients;

INSERT INTO clients (client_name, identification, street_address, city, state, email, phone_number, date_of_birth) VALUES 
('Francisco Souza', '12345678901', 'Rua das Flores, 1233', 'Rio de Janeiro', 'RJ', 'francisco.souza@example.com', '21987654321', '1980-01-01'),
('Anada Silva', '34567890123', 'Rua das Rosas, 12223', 'São Paulo', 'SP', 'ananda.silva@example.com', '11987654321', '1985-02-23'),
('Clara Gema', '45678901234', 'Rua das Margaridas, 23', 'Rio de Janeiro', 'RJ', 'clara.gema@example.com', '21987654321', '1991-03-11'),
('Ana José', '56789012345', 'Rua das Tulipas, 9', 'São Paulo', 'SP', 'ana.jose@example.com', '11987654321', '1980-04-12'),
('Rita Silva', '67890123456', 'Rua dos Cravos, 673', 'Rio de Janeiro', 'RJ', 'rita.silva@example.com', '21987654321', '1999-05-01'),
('Joaquim Ribeiro', '78901234567', 'Rua das Papoulas, 345', 'Rio de Janeiro', 'RJ', 'joaquim.ribeiro@example.com', '21987654321', '2001-06-03'),
('Patricia Dorval', '33345678901', 'Rua dos Lirios, 463', 'Belo Horizonte', 'MG', 'patricia.dorval@example.com', '31987654321', '1956-07-05'),
('Anny Histon', 'C12345678', 'Rua General Glicerio, 56', 'Rio de Janeiro', 'RJ', 'anny.histon@example.com', '21987654321', '1960-08-12'),
('Richard Kenedy', 'A987F65432', 'Rua das Laranjeiras, 86', 'Rio de Janeiro', 'RJ', 'richard.kenedy@example.com', '21987654321', '1982-09-13'),
('Celso Ricardo', '14445678901', 'Rua Ipiranga, 123', 'Rio de Janeiro', 'RJ', 'celso.ricardo@example.com', '21987654321', '1920-10-15'),
('Maria Souza', '23456789012', 'Avenida Paulista, 456', 'São Paulo', 'SP', 'maria.souza@example.com', '11976543210', '1985-11-02');

SELECT * from clients;
SELECT * from accounts;

DELETE FROM transactions;

DELIMITER //
DROP FUNCTION IF EXISTS createNewTransaction //
CREATE FUNCTION createNewTransaction() RETURNS VARCHAR(100)
BEGIN
    DECLARE transactionType VARCHAR(20);
    DECLARE transactionDate DATE;
    DECLARE transactionAmount FLOAT;
    DECLARE accountCount INT;
    DECLARE randomAccount INT;
    DECLARE result VARCHAR(100);
    DECLARE count INT DEFAULT 0;
    DECLARE accountStatus INT;
    
    WHILE count < 1000 DO
		
		-- Conta a quantidade de contas
		SELECT COUNT(*) INTO accountCount FROM accounts;
        -- Definir um numero aleatorio
        SET randomAccount = FLOOR(RAND() * accountCount);
        -- Seta a conta
        SET randomAccount = (SELECT account_id FROM accounts LIMIT randomAccount, 1);
		-- Check the account status
		SELECT account_status INTO accountStatus FROM accounts WHERE account_id = randomAccount;
		
         IF accountStatus = 1 THEN
			
			-- Numero randomico de 0 a 9
			SELECT FLOOR(RAND() * 100) INTO @randomTransactionType;		
			IF @randomTransactionType < 10 THEN
				SET transactionType = 'cartão de débito';
			ELSEIF @randomTransactionType < 40 THEN
				SET transactionType = 'cartão de crédito';
			ELSEIF @randomTransactionType < 98 THEN
				SET transactionType = 'PIX';
			ELSE
				SET transactionType = 'TED';
			END IF;
			
			-- Retrieve client_id associated with the account
			SET @client_id = (SELECT client_id FROM accounts WHERE account_id = randomAccount);
			-- Retrieve date_of_birth of the selected account
			SET transactionDate = (SELECT date_of_birth FROM clients WHERE client_id = @client_id);
			SET transactionDate = DATE_ADD(transactionDate, INTERVAL FLOOR(RAND() * 3650) DAY);
			
			-- Generate random transaction amount
			SET transactionAmount = CASE 
				WHEN RAND() < 0.9 THEN IF(RAND() > 0.7, 1, -1)*ROUND(RAND()*(100), 2)
				ELSE IF(RAND() > 0.2, 1, -1)*ROUND(RAND()*(10000), 0)
			END;
			
			-- Insert transaction into transactions table
			INSERT INTO transactions (account_id, transaction_type, transaction_date, amount)
			VALUES (randomAccount, transactionType, transactionDate, transactionAmount);
			
			SET count = count + 1;
            
        END IF;
	END WHILE;
		
    SET result = 'New transactions created!';
    RETURN result;
END //
DELIMITER ;



SELECT * from clients;
SELECT * from accounts;
SELECT * from transactions;


## Atualizando o saldo da conta "total_amount" ##

-- Procedure que calcula
DELIMITER //
CREATE PROCEDURE UpdateTotalAmount(IN input_account_id INT, IN input_amount FLOAT)
BEGIN
    UPDATE accounts
    SET total_amount = total_amount + input_amount
    WHERE account_id = input_account_id;
END //
DELIMITER ;


-- Trigger quando adiciona uma transação
-- Quando usado "INSERT" ou "UPDATE" o "NEW" permite acessar os valores que estão sendo inseridos.
-- "FOR EACH ROW" especifica que é para ser realizado para cada linha e não para todo um conjunto de dados adicionado
DELIMITER //
CREATE TRIGGER after_transaction_insert
AFTER INSERT ON transactions
FOR EACH ROW 
BEGIN
   CALL UpdateTotalAmount(NEW.account_id, NEW.amount);
END; //
DELIMITER ;



SELECT * from clients;
SELECT * from accounts;
SELECT * from transactions;
SELECT createNewTransaction();
SELECT * from clients;
SELECT * from accounts;
SELECT * from transactions;
SELECT * from transactions WHERE account_id = 9;


-- Adicionar coluna de transações fraudulentas
ALTER TABLE transactions
ADD COLUMN fraudulent TINYINT(1) DEFAULT 0;
SELECT * from transactions;

-- Mudar para 1 as transações fraudulentas
CREATE TEMPORARY TABLE avg_amounts AS
SELECT account_id, AVG(amount) AS avg_amount
FROM transactions
GROUP BY account_id;
SELECT * from avg_amounts;

UPDATE transactions
JOIN avg_amounts ON transactions.account_id = avg_amounts.account_id
SET fraudulent = 1
WHERE transactions.amount < -2*avg_amounts.avg_amount AND transactions.amount < -200 ;

DROP TEMPORARY TABLE avg_amounts;
SELECT * from transactions;

-- Set to 0 again
UPDATE transactions
SET fraudulent = 0;
SELECT * from transactions;
