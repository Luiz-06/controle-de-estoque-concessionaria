-- Pessoa Física (referência a CLIENTE)
CREATE TABLE PESSOA_FISICA (
    COD_CLIENTE INT PRIMARY KEY, 
    CPF VARCHAR(14) UNIQUE NOT NULL,
    FOREIGN KEY (COD_CLIENTE) REFERENCES CLIENTE(COD_CLIENTE)
);

INSERT INTO PESSOA_FISICA (COD_CLIENTE, CPF) VALUES
(1, '11122233344'),
(2, '55566677788'),
(3, '99900011122');