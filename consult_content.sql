## Vamos normalizar os dados dos clientes tornndo eles mais eficientes e menos redundante

SELECT * FROM clients;
SELECT * FROM accounts;
SELECT * FROM transactions;

DELIMITER //
DROP PROCEDURE IF EXISTS ClientStatistics //
CREATE PROCEDURE ClientStatistics(IN input_identification VARCHAR(20))
BEGIN
    DECLARE selected_client_id INT;
    
    SELECT client_id INTO selected_client_id FROM clients WHERE identification = input_identification;

    -- Print client details
    SELECT * FROM clients WHERE client_id = selected_client_id;
    
    -- Total amount
    SELECT SUM(total_amount) AS total_amount FROM accounts WHERE client_id = selected_client_id;

    -- Number of transactions
    SELECT COUNT(*) AS number_of_transactions FROM transactions WHERE account_id IN (SELECT account_id FROM accounts WHERE client_id = selected_client_id);
    
    -- Transaction type frequency
    SELECT transaction_type, COUNT(*) AS frequency FROM transactions WHERE account_id IN (SELECT account_id FROM accounts WHERE client_id = selected_client_id) GROUP BY transaction_type;

    -- Average transaction amount
    SELECT AVG(amount) AS average_transaction_amount FROM transactions WHERE account_id IN (SELECT account_id FROM accounts WHERE client_id = selected_client_id);

    -- Balance of all transactions
    SELECT SUM(amount) AS total_transaction_amount FROM transactions WHERE account_id IN (SELECT account_id FROM accounts WHERE client_id = selected_client_id);
    
    -- Highest transaction
    SELECT MAX(amount) AS highest_transaction FROM transactions WHERE account_id IN (SELECT account_id FROM accounts WHERE client_id = selected_client_id);

    -- Lowest transaction
    SELECT MIN(amount) AS lowest_transaction FROM transactions WHERE account_id IN (SELECT account_id FROM accounts WHERE client_id = selected_client_id);

	-- % fraudulent transaction
	SELECT (COUNT(CASE WHEN fraudulent = 1 THEN 1 ELSE NULL END) / COUNT(*)) * 100 AS percentage_fraudulent FROM transactions;

END //
DELIMITER ;


CALL ClientStatistics('12345678901');