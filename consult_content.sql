-- Selecionando o banco de dados para trabalhar nele
USE BANK;

-- Imagine que um gerente precise de informações do cliente. Procedimento que olha as estatisticas de cada cliente.
DELIMITER //
DROP PROCEDURE IF EXISTS ClientStatistics //
CREATE PROCEDURE ClientStatistics(IN input_identification VARCHAR(20))
BEGIN
    DECLARE selected_client_id INT;
    
    SELECT client_id INTO selected_client_id FROM clients WHERE identification = input_identification;

    -- Consulta inicial do operador sobre o cliente. Imprime as informações
    SELECT * FROM clients WHERE client_id = selected_client_id;
    
    -- Valor total na conta
    SELECT SUM(total_amount) AS total_amount FROM accounts WHERE client_id = selected_client_id;

    -- Numero total de transações
    SELECT COUNT(*) AS number_of_transactions FROM transactions WHERE account_id IN (SELECT account_id FROM accounts WHERE client_id = selected_client_id);
    
    -- Transação pelo tipo
    SELECT transaction_type, COUNT(*) AS frequency FROM transactions WHERE account_id IN (SELECT account_id FROM accounts WHERE client_id = selected_client_id) GROUP BY transaction_type;

    -- Valor médio da transação
    SELECT AVG(amount) AS average_transaction_amount FROM transactions WHERE account_id IN (SELECT account_id FROM accounts WHERE client_id = selected_client_id);

    -- Saldo de todas as transações
    SELECT SUM(amount) AS total_transaction_amount FROM transactions WHERE account_id IN (SELECT account_id FROM accounts WHERE client_id = selected_client_id);
    
    -- Transação mais alta
    SELECT MAX(amount) AS highest_transaction FROM transactions WHERE account_id IN (SELECT account_id FROM accounts WHERE client_id = selected_client_id);

    -- Transação mais baixa
    SELECT MIN(amount) AS lowest_transaction FROM transactions WHERE account_id IN (SELECT account_id FROM accounts WHERE client_id = selected_client_id);

	-- Porcentagem de transação fraudulenta
	SELECT (COUNT(CASE WHEN fraudulent = 1 THEN 1 ELSE NULL END) / COUNT(*)) * 100 AS percentage_fraudulent FROM transactions;

END //
DELIMITER ;

CALL ClientStatistics('12345678901');