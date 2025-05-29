-- Tabela de Tipos (referência para CARRO)
CREATE TABLE TIPO (
    COD_TIPO INT PRIMARY KEY, 
    NOME VARCHAR(20)
);

INSERT INTO TIPO 
VALUES
(1, 'HATCH'),
(2, 'SUV'),
(3, 'SEDAN');