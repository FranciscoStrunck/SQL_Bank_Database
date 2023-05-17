-- Selecionando o banco de dados para trabalhar nele
USE BANK;

/* Antes de adiconar os dados mais importantes que devem vir anteriormente dos dados do clientes, deve-se adicionar
procedimentos, gatilhos e funções. Será criado a função de criar uma conta "CreateAccount" que terá acionada logo após
a criação dos dados do cliente, todo cliente tem que ter uma conta. */

-- Criando um procedimento para criar uma nova conta
DELIMITER //
CREATE PROCEDURE CreateAccount(IN input_client_id INT)
BEGIN
    DECLARE dob DATE;
    DECLARE rand FLOAT;
    DECLARE account_type VARCHAR(30);
    DECLARE account_status TINYINT(1);
    DECLARE opening_date DATE;
    DECLARE total_amount FLOAT;
    DECLARE vcredit_score INT;

	-- rand é um valor aleatório de 0 a 1
    SET rand = RAND();
    -- A conta será escolhida aleatóriamente com change de 80% ser conta corrente, 10% conta corrente e 10% conta empresárial
    SET account_type = CASE
        WHEN rand < 0.8 THEN 'Conta Corrente'
        WHEN rand < 0.9 THEN 'Conta Poupança'
        ELSE 'Conta Empresarial'
    END;

	-- Determinando um status de conta aleatório do mesmo raciocinio da criação de conta. 1 para uma conta ativa e 0 para contas inativas.
    -- Contas inativas não podem receber trasações porque foram canceladas ou estão com algum outro problema.
    SET rand = RAND();
    SET account_status = CASE
        WHEN rand < 0.92 THEN 1
        ELSE 0
    END;
    
	-- Seleciona a data de nascimento do cliente para posteriormente realizar a criação da conta em uma data depois
    SELECT date_of_birth INTO dob FROM clients WHERE client_id = input_client_id;
    
    -- Seleciona a pontuação de crédito do cliente
    SELECT credit_score INTO vcredit_score FROM clients WHERE client_id = input_client_id;
    
	-- Setando aleatóriamente a data de abertura e o valor total na conta
    SET opening_date = DATE_ADD(dob, INTERVAL FLOOR(20 + RAND() * 21) YEAR);
    SET total_amount =  500 + ROUND(10*RAND()*vcredit_score*vcredit_score, 0);

	-- Guardando a informação na tabela
    INSERT INTO accounts(client_id, account_type, opening_date, account_status, total_amount) 
    VALUES (input_client_id, account_type, opening_date, account_status, total_amount);
END //
DELIMITER ;

-- Criando um gatilho (trigger) para chamar a função CreateAccount sempre que um novo cliente for inserido
DELIMITER //
CREATE TRIGGER after_client_insert 
AFTER INSERT ON clients
FOR EACH ROW 
BEGIN
  CALL CreateAccount(NEW.client_id);
END; //
DELIMITER ;

-- Inserindo valores na tabela de clientes
INSERT INTO clients (client_name, identification, street_address, city, state, email, phone_number, date_of_birth, credit_score) VALUES 
('Francisco Souza', '12345678901', 'Rua das Flores, 1233', 'Rio de Janeiro', 'RJ', 'francisco.souza@example.com', '21987654321', '1980-01-01','32'),
('Anada Silva', '34567890123', 'Rua das Rosas, 12223', 'São Paulo', 'SP', 'ananda.silva@example.com', '11987654321', '1985-02-23','50'),
('Clara Gema', '45678901234', 'Rua das Margaridas, 23', 'Rio de Janeiro', 'RJ', 'clara.gema@example.com', '21987654321', '1991-03-11','90'),
('Ana José', '56789012345', 'Rua das Tulipas, 9', 'São Paulo', 'SP', 'ana.jose@example.com', '11987654321', '1980-04-12','80'),
('Rita Silva', '67890123456', 'Rua dos Cravos, 673', 'Rio de Janeiro', 'RJ', 'rita.silva@example.com', '21987654321', '1999-05-01','40'),
('Joaquim Ribeiro', '78901234567', 'Rua das Papoulas, 345', 'Rio de Janeiro', 'RJ', 'joaquim.ribeiro@example.com', '21987654321', '2001-06-03','55'),
('Patricia Dorval', '33345678901', 'Rua dos Lirios, 463', 'Belo Horizonte', 'MG', 'patricia.dorval@example.com', '31987654321', '1956-07-05','80'),
('Anny Histon', 'C12345678', 'Rua General Glicerio, 56', 'Rio de Janeiro', 'RJ', 'anny.histon@example.com', '21987654321', '1960-08-12','82'),
('Richard Kenedy', 'A987F65432', 'Rua das Laranjeiras, 86', 'Rio de Janeiro', 'RJ', 'richard.kenedy@example.com', '21987654321', '1982-09-13','92'),
('Celso Ricardo', '14445678901', 'Rua Ipiranga, 123', 'Rio de Janeiro', 'RJ', 'celso.ricardo@example.com', '21987654321', '1920-10-15','98'),
('Maria Souza', '23456789012', 'Avenida Paulista, 456', 'São Paulo', 'SP', 'maria.souza@example.com', '11976543210', '1985-11-02','100'),
('André Almeida', '13445678905', 'Rua Ipiranga, 12', 'Rio de Janeiro', 'RJ', 'andre.almeida@example.com', '21967654321', '1920-04-25','78'),
('Laura Ferreira', '23434789022', 'Avenida Carioca, 45', 'São Paulo', 'SP', 'laura.ferreira@example.com', '11976544210', '1985-10-30','100'),
('Gabriel Cardoso', '13455678910', 'Rua dos Amores, 100', 'Rio de Janeiro', 'RJ', 'gabriel.cardoso@example.com', '21987652321', '1920-03-25','10'),
('Carolina Martins', '23456459419', 'Avenida Buenos Aires, 106', 'São Paulo', 'SP', 'carolina.martins@example.com', '11976543212', '1985-02-01','15'),
('Carlos Pereira', '9F567U8901', 'Rua Uruguai, 23', 'Rio de Janeiro', 'RJ', 'carlos.pereira@example.com', '21989954321', '1920-11-11','60'),
('Sofia Rodrigues', '23456799912', 'Avenida Colombia, 4856', 'São Paulo', 'SP', 'sofia.rodrigues@example.com', '11976543990', '1985-12-12','20');

-- Antes de adicionar as transações, é importante adicionar a trigger pque chama  uma procedura para atualizar o valor da conta do cliente.
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


/* O objetivo desse projeto é criar transações para compor o banco de dados.
Esta função é para criar 10 mil transações para compor o banco de dados. */
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
    DECLARE v_account_id INT;
    DECLARE vcredit_score INT;
    DECLARE rand FLOAT;
    
    WHILE count < 20000 DO
		
		-- Conta a quantidade de contas
		SELECT COUNT(*) INTO accountCount FROM accounts;
        -- Definir um numero aleatorio
        SET randomAccount = FLOOR(RAND() * accountCount);
        -- Seta a conta
        SET randomAccount = (SELECT account_id FROM accounts LIMIT randomAccount, 1);
		-- Check the account status
		SELECT account_status INTO accountStatus FROM accounts WHERE account_id = randomAccount;
        
		-- Seleciona a pontuação de crédito do cliente
		SELECT credit_score INTO vcredit_score FROM clients INNER JOIN accounts ON clients.client_id = accounts.client_id
        WHERE accounts.account_id = randomAccount;    
		
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
			SET rand = RAND();
			SET transactionAmount = CASE 
				WHEN rand < 0.98 THEN IF(RAND() > 0.8, 1, -1)*ROUND(RAND()*8*vcredit_score, 2)
				ELSE IF(rand > 0.5, 1, -1)*ROUND(RAND()*8*vcredit_score*vcredit_score, 0)
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

-- Chamando a função
SELECT createNewTransaction();

/* Pensando em um projeto futuro, decidi adicionar uma coluna de detecção de transações fraudulentas.
É bastante comum o cliente vir reclamar movimentações que não foram gerados por eles e esse feedback
do cliente seria utiliado para marcar as transações que não deveriam ocorrer.

Neste projeto os valores fraudulentos serão definidos considerando o valor médio de transação. Quando
muito menor (cliente fazendo um pagamento ou transferência) do que o dobro média para valores maiores
que 200. 

Futuramente esses dados podem ser utilzizados por uma inteligência artificial para prever falhas.
Claro que na vida real, outros fatores devem ser considerados como: transferência para uma pessoa que
o cliente não tinha uma relação prévia, horario de transferência dentre outros. */

-- Criar uma tabela temporária que calcula o valor média de transfêrencia de cada cliente
CREATE TEMPORARY TABLE avg_amounts AS
SELECT account_id, AVG(amount) AS avg_amount
FROM transactions GROUP BY account_id;

-- Mudar o valor da tabela de transações fraudulentas nos casos que se aplicam
UPDATE transactions
JOIN avg_amounts ON transactions.account_id = avg_amounts.account_id
SET fraudulent = 1 WHERE transactions.amount < -3*avg_amounts.avg_amount AND transactions.amount < -200;

-- Remove a tabela temporária
DROP TEMPORARY TABLE avg_amounts;

-- Consultas importantes
SELECT * from clients;
SELECT * from accounts;
SELECT * from transactions;
SELECT * FROM transactions WHERE amount < -1000;
SELECT * from transactions WHERE fraudulent = 1;