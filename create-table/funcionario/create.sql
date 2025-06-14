-- Tabela de Funcionários
CREATE TABLE FUNCIONARIO (
    COD_FUNCIONARIO INT PRIMARY KEY,
    NOME VARCHAR(100),
    DT_NASCIMENTO DATE,
    SALARIO FLOAT,
    META_MENSAL FLOAT,
    QTD_VENDIDA_NO_MES FLOAT,
    COD_LOJA_CARRO INT,
    FOREIGN KEY (COD_LOJA_CARRO) REFERENCES LOJA_CARRO(COD_LOJA_CARRO)
);

-- Inserção de dados na tabela FUNCIONARIO
INSERT INTO FUNCIONARIO (COD_FUNCIONARIO, NOME, DT_NASCIMENTO, SALARIO, META_MENSAL, QTD_VENDIDA_NO_MES, COD_LOJA_CARRO) VALUES
(1, 'Carlos Alberto Silva', '1985-03-15', 3500.00, 10000.00, 0, 1),
(2, 'Beatriz Ferreira Souza', '1992-07-20', 2800.00, 8000.00, 0, 2),
(3, 'Ricardo Lima Azevedo', '1978-11-05', 4200.00, 12000.00, 0, 3);