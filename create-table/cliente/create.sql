-- Tabela de Clientes (referenciada por VENDA)
CREATE TABLE CLIENTE (
    COD_CLIENTE INT PRIMARY KEY,
    NOME VARCHAR(100),
    DT_NASCIMENTO DATE, 
    QTD_GASTO FLOAT
);

-- Inserção de dados na tabela CLIENTE
INSERT INTO CLIENTE (COD_CLIENTE, NOME, DT_NASCIMENTO, QTD_GASTO) VALUES
(1, 'Fernanda Moreira Costa', '1990-01-25', 1250.75),
(2, 'Lucas Dias Martins', '1988-06-10', 850.00),
(3, 'Juliana Pereira Alves', '2000-09-30', 2100.50),
(4, 'TecnoSoluções Avançadas Ltda', '2010-04-12', 15780.90),
(5, 'Comércio Varejista XYZ EIRELI', '2015-08-01', 22300.00),
(6, 'Serviços Gerais Alfa & Filhos S.A.', '2005-11-20', 8950.40);