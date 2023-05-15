# SQL_Bank_Database
## A fictional bank database implemented in SQL

Este projeto visa a criação de um banco de dados em um banco fictício do zero e traballhar esses dados.

## Criação das tabelas

Para começar, foram criadas três tabelas: clientes, contas e transações. A primeira tabela que foi criada foi a tabela 'clients'.
Esta tabela foi destinada a armazenar informações sobre os clientes do banco. Cada cliente tinha um ID único (client_id), um nome
(client_name), um número de identificação (identification), endereço (street_address), cidade (city), estado (state), email, número
de telefone (phone_number), e data de nascimento (date_of_birth). O ID do cliente era a chave primária, o que significava que cada
cliente tinha um ID único.

Em seguida, foi criada a tabela 'accounts'. Esta tabela foi destinada a armazenar informações sobre as contas bancárias dos clientes.
Cada conta tinha um ID único (account_id), um ID do cliente (client_id), um tipo de conta (account_type), uma data de abertura
(opening_date), um status da conta (account_status), e um valor total (total_amount). A chave primária era o ID da conta. Além disso,
o ID do cliente nesta tabela era uma chave estrangeira, que se referia ao ID do cliente na tabela de clientes. Isso significava que
cada conta estava associada a um cliente.

A terceira tabela que foi criada foi a tabela 'transactions'. Esta tabela foi destinada a armazenar informações sobre as transações
realizadas nas contas. Cada transação tinha um ID único (transaction_id), um ID da conta (account_id), um tipo de transação
(transaction_type), uma data de transação (transaction_date), um valor (amount), e uma marcação para indicar se a transação era
fraudulenta (fraudulent). A chave primária era o ID da transação e o ID da conta nesta tabela era uma chave estrangeira que se
referia ao ID da conta na tabela de contas. Isso significava que cada transação estava associada a uma conta.

Para facilitar a busca de clientes, contas e transações, foram criados índices para a identificação do cliente na tabela de
clientes, para o nome do cliente na tabela de clientes, para o ID do cliente na tabela de contas, e para o ID da conta na
tabela de transações.

Finalmente, para garantir que cada cliente tinha uma identificação única, foi adicionada uma restrição UNIQUE para a coluna
de identificação na tabela de clientes.
