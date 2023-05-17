/*
Unificando as tabelas para trabalho posterior. Será feito um arquivo bruto para ser melhorado.
O principal projeto futuro será analisar se com aprendizado de máquina é posssivel prever transações fraudulentas e,
portanto, a tabela que terá informações adicionadas é a de transações com as informações do cliente e da conta.
*/
CREATE TABLE unified_table AS
SELECT 
    clients.client_id,
    clients.client_name,
    clients.identification,
    clients.street_address,
    clients.city,
    clients.state,
    clients.email,
    clients.phone_number,
    clients.date_of_birth,
    clients.credit_score,
    accounts.account_id,
    accounts.account_type,
    accounts.opening_date,
    accounts.account_status,
    accounts.total_amount,
    transactions.transaction_id,
    transactions.transaction_type,
    transactions.transaction_date,
    transactions.amount,
    transactions.fraudulent
FROM clients
INNER JOIN accounts ON clients.client_id = accounts.client_id
INNER JOIN transactions ON accounts.account_id = transactions.account_id;
    
    SELECT * FROM unified_table;
