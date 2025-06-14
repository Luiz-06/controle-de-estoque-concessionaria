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

INSERT INTO FUNCIONARIO (COD_FUNCIONARIO, NOME, DT_NASCIMENTO, SALARIO, META_MENSAL, QTD_VENDIDA_NO_MES, COD_LOJA_CARRO) VALUES
(1, 'Carlos Alberto Silva', '1985-03-15', 3500.00, 10000.00, 0, 1),
(2, 'Beatriz Ferreira Souza', '1992-07-20', 2800.00, 8000.00, 0, 2),
(3, 'Ricardo Lima Azevedo', '1978-11-05', 4200.00, 12000.00, 0, 3);

-- Tabela de Clientes (referenciada por VENDA)
CREATE TABLE CLIENTE (
    COD_CLIENTE INT PRIMARY KEY,
    NOME VARCHAR(100),
    DT_NASCIMENTO DATE, 
    QTD_GASTO FLOAT
);

INSERT INTO CLIENTE (COD_CLIENTE, NOME, DT_NASCIMENTO, QTD_GASTO) VALUES
(1, 'Fernanda Moreira Costa', '1990-01-25', 0),
(2, 'Lucas Dias Martins', '1988-06-10', 0),
(3, 'Juliana Pereira Alves', '2000-09-30', 0),
(4, 'TecnoSoluções Avançadas Ltda', '2010-04-12', 0),
(5, 'Comércio Varejista XYZ EIRELI', '2015-08-01', 0),
(6, 'Serviços Gerais Alfa & Filhos S.A.', '2005-11-20', 0);

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

-- Pessoa Jurídica (referência a CLIENTE)
CREATE TABLE PESSOA_JURIDICA (
    COD_CLIENTE INT PRIMARY KEY,
    CNPJ VARCHAR(18) UNIQUE NOT NULL,   
    FOREIGN KEY (COD_CLIENTE) REFERENCES CLIENTE(COD_CLIENTE)
);

INSERT INTO PESSOA_JURIDICA (COD_CLIENTE, CNPJ) VALUES
(4, '11222333000144'),
(5, '44555666000188'),
(6, '77888999000122');

-- Tabela de Vendas (referência a FUNCIONARIO e CLIENTE)
CREATE TABLE VENDA (
    COD_VENDA INT PRIMARY KEY,
    COD_FUNCIONARIO INT,
    COD_CLIENTE INT,
    VALOR_TOTAL FLOAT,
    DT_VENDA DATE,
    FOREIGN KEY (COD_FUNCIONARIO) REFERENCES FUNCIONARIO(COD_FUNCIONARIO),
    FOREIGN KEY (COD_CLIENTE) REFERENCES CLIENTE(COD_CLIENTE)
);

-- Tabela de Itens de Venda (referência a VENDA e LOJA_CARRO)
CREATE TABLE ITEM_VENDA (
    COD_ITEM_VENDA INT PRIMARY KEY,
    COD_VENDA INT,
    COD_LOJA_CARRO INT,
    QTD_DE_ITENS INT,
    FOREIGN KEY (COD_VENDA) REFERENCES VENDA(COD_VENDA),
    FOREIGN KEY (COD_LOJA_CARRO) REFERENCES LOJA_CARRO(COD_LOJA_CARRO)
);

-- Tabela de Cores (referência para CARRO)
CREATE TABLE COR (
    COD_COR INT PRIMARY KEY, 
    NOME VARCHAR(20)
);

INSERT INTO COR 
VALUES 
(1, 'PRETO'),
(2, 'BRANCO'),
(3, 'PRATA');

-- Tabela de Lojas (referência para LOJA_CARRO)
CREATE TABLE LOJA (
    COD_LOJA INT PRIMARY KEY, 
    NOME VARCHAR(20)
);

INSERT INTO LOJA
VALUES
(1, 'LOJA 1'),
(2, 'LOJA 2'),
(3, 'LOJA 3');

-- Tabela de Marcas (referência para CARRO)
CREATE TABLE MARCA (
    COD_MARCA INT PRIMARY KEY, 
    NOME VARCHAR(20)
);

INSERT INTO MARCA
VALUES
(1, 'TOYOTA'),
(2, 'CHEVROLET'),
(3, 'FORD');

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

-- Tabela de Carros (referência para LOJA_CARRO)
CREATE TABLE CARRO (
    COD_CARRO INT PRIMARY KEY,
    COD_COR INT,
    COD_MARCA INT,
    COD_TIPO INT,
    NOME VARCHAR(20),
    PRECO FLOAT,
    ANO VARCHAR(20),
    QTD_EM_ESTOQUE INT,
    FOREIGN KEY (COD_COR) REFERENCES COR(COD_COR),
    FOREIGN KEY (COD_MARCA) REFERENCES MARCA(COD_MARCA),
    FOREIGN KEY (COD_TIPO) REFERENCES TIPO(COD_TIPO)
);

INSERT INTO CARRO 
VALUES
(1, 1, 1, 1, 'COROLLA', 150000.00, '2024', 10),
(2, 2, 2, 2, 'ONIX', 85000.00, '2023', 10),
(3, 3, 3, 3, 'RANGER', 190000.00, '2022', 10);

-- Tabela de associação entre Loja e Carro (referência a LOJA e CARRO, usada por ITEM_VENDA)
CREATE TABLE LOJA_CARRO (
	COD_LOJA_CARRO INT PRIMARY KEY,
	COD_LOJA INT, 
	COD_CARRO INT,
	FOREIGN KEY (COD_LOJA) REFERENCES LOJA(COD_LOJA),
	FOREIGN KEY (COD_CARRO) REFERENCES CARRO(COD_CARRO)
);

INSERT INTO LOJA_CARRO (COD_LOJA_CARRO, COD_LOJA, COD_CARRO) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 2, 1),
(5, 2, 2),
(6, 2, 3),
(7, 3, 1),
(8, 3, 2),
(9, 3, 3);

-- Triggers

-- Calcular valor total da venda e decrementar ou incrementar no estoque 

CREATE OR REPLACE FUNCTION total_da_venda() RETURNS TRIGGER AS 
$$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Atualiza o valor total da venda
        UPDATE VENDA 
        SET VALOR_TOTAL = (
            SELECT SUM(IV.QTD_DE_ITENS * C.PRECO)
            FROM ITEM_VENDA AS IV
            JOIN LOJA_CARRO AS LC ON IV.COD_LOJA_CARRO = LC.COD_LOJA_CARRO
            JOIN CARRO AS C ON LC.COD_CARRO = C.COD_CARRO
            WHERE IV.COD_VENDA = NEW.COD_VENDA
        )
        WHERE COD_VENDA = NEW.COD_VENDA;

        -- Atualiza o estoque do carro
        UPDATE CARRO 
        SET QTD_EM_ESTOQUE = QTD_EM_ESTOQUE - NEW.QTD_DE_ITENS
        WHERE COD_CARRO = (
            SELECT LC.COD_CARRO
            FROM LOJA_CARRO AS LC
            WHERE LC.COD_LOJA_CARRO = NEW.COD_LOJA_CARRO
        );

    ELSIF TG_OP = 'UPDATE' THEN
        -- Recalcula o total da venda
        UPDATE VENDA 
        SET VALOR_TOTAL = (
            SELECT SUM(IV.QTD_DE_ITENS * C.PRECO)
            FROM ITEM_VENDA AS IV
            JOIN LOJA_CARRO AS LC ON IV.COD_LOJA_CARRO = LC.COD_LOJA_CARRO
            JOIN CARRO AS C ON LC.COD_CARRO = C.COD_CARRO
            WHERE IV.COD_VENDA = NEW.COD_VENDA
        )
        WHERE COD_VENDA = NEW.COD_VENDA;

        -- Devolve estoque antigo
        UPDATE CARRO
        SET QTD_EM_ESTOQUE = QTD_EM_ESTOQUE + OLD.QTD_DE_ITENS
        WHERE COD_CARRO = (
            SELECT LC.COD_CARRO
            FROM LOJA_CARRO AS LC
            WHERE LC.COD_LOJA_CARRO = OLD.COD_LOJA_CARRO
        );

        -- Reduz estoque novo
        UPDATE CARRO
        SET QTD_EM_ESTOQUE = QTD_EM_ESTOQUE - NEW.QTD_DE_ITENS
        WHERE COD_CARRO = (
            SELECT LC.COD_CARRO
            FROM LOJA_CARRO AS LC
            WHERE LC.COD_LOJA_CARRO = NEW.COD_LOJA_CARRO
        );

    ELSIF TG_OP = 'DELETE' THEN
        -- Recalcula o total da venda
        UPDATE VENDA 
        SET VALOR_TOTAL = (
            SELECT COALESCE(SUM(IV.QTD_DE_ITENS * C.PRECO), 0)
            FROM ITEM_VENDA AS IV
            JOIN LOJA_CARRO AS LC ON IV.COD_LOJA_CARRO = LC.COD_LOJA_CARRO
            JOIN CARRO AS C ON LC.COD_CARRO = C.COD_CARRO
            WHERE IV.COD_VENDA = OLD.COD_VENDA
        )
        WHERE COD_VENDA = OLD.COD_VENDA;

        -- Devolve estoque do carro
        UPDATE CARRO 
        SET QTD_EM_ESTOQUE = QTD_EM_ESTOQUE + OLD.QTD_DE_ITENS
        WHERE COD_CARRO = (
            SELECT LC.COD_CARRO
            FROM LOJA_CARRO AS LC
            WHERE LC.COD_LOJA_CARRO = OLD.COD_LOJA_CARRO
        );
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER total_da_venda_tr 
AFTER INSERT OR UPDATE OR DELETE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION total_da_venda();

-- Validar se o funcionário e o cliente existem

CREATE OR REPLACE FUNCTION validar_funcionario_cliente() 
RETURNS TRIGGER AS 
$$
DECLARE
    existe_funcionario BOOLEAN;
    existe_cliente BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT * FROM FUNCIONARIO 
        WHERE COD_FUNCIONARIO = NEW.COD_FUNCIONARIO
    ) INTO existe_funcionario;

    IF NOT existe_funcionario THEN
        RAISE EXCEPTION 'Funcionário com código % não existe.', NEW.COD_FUNCIONARIO;
    END IF;

    SELECT EXISTS (
        SELECT * FROM CLIENTE 
        WHERE COD_CLIENTE = NEW.COD_CLIENTE
    ) INTO existe_cliente;

    IF NOT existe_cliente THEN
        RAISE EXCEPTION 'Cliente com código % não existe.', NEW.COD_CLIENTE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER VALIDAR_FUNCIONARIO_CLIENTE_TR 
AFTER INSERT OR UPDATE ON VENDA 
FOR EACH ROW EXECUTE FUNCTION validar_funcionario_cliente();

-- Validar se a quantidade de itens inseridos em item_venda condiz com a presente no estoque 

CREATE OR REPLACE FUNCTION validar_qtd() RETURNS TRIGGER AS 
$$
DECLARE 
	qtd_presente_no_estoque INT;
BEGIN
	SELECT C.QTD_EM_ESTOQUE INTO qtd_presente_no_estoque
	FROM CARRO AS C 
	JOIN LOJA_CARRO AS LC ON LC.COD_CARRO = C.COD_CARRO
	WHERE LC.COD_LOJA_CARRO = NEW.COD_LOJA_CARRO;

	IF NEW.QTD_DE_ITENS > qtd_presente_no_estoque THEN
		RAISE EXCEPTION 'Quantidade de itens (%), maior que a presente no estoque (%)',
			NEW.QTD_DE_ITENS, qtd_presente_no_estoque;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validar_qtd_tr 
BEFORE INSERT OR UPDATE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION validar_qtd();

-- Valida a data de venda inserida, para negar qualquer data futura a data atual.

CREATE OR REPLACE FUNCTION fn_impede_venda_futura()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.DT_VENDA > CURRENT_DATE THEN
        RAISE EXCEPTION 'Não é permitido registrar vendas com data futura (Data informada: %).', TO_CHAR(NEW.DT_VENDA, 'DD/MM/YYYY');
    END IF;
    RETURN NEW; -- Permite a operação se a data for válida
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_impede_venda_futura
BEFORE INSERT OR UPDATE ON VENDA
FOR EACH ROW
EXECUTE FUNCTION fn_impede_venda_futura();

-- Valida a adição de valor a venda do funcionario

CREATE OR REPLACE FUNCTION fn_atualiza_qtd_vendida_funcionario()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Adiciona o valor da nova venda ao funcionário
        UPDATE FUNCIONARIO
        SET QTD_VENDIDA_NO_MES = COALESCE(QTD_VENDIDA_NO_MES, 0) + NEW.VALOR_TOTAL
        WHERE COD_FUNCIONARIO = NEW.COD_FUNCIONARIO;

    ELSIF TG_OP = 'UPDATE' THEN
        -- Se o valor da venda mudou ou o funcionário responsável mudou
        IF OLD.VALOR_TOTAL IS DISTINCT FROM NEW.VALOR_TOTAL OR OLD.COD_FUNCIONARIO IS DISTINCT FROM NEW.COD_FUNCIONARIO THEN
            -- Remove o valor antigo do funcionário antigo (se houver)
            IF OLD.COD_FUNCIONARIO IS NOT NULL THEN
                UPDATE FUNCIONARIO
                SET QTD_VENDIDA_NO_MES = COALESCE(QTD_VENDIDA_NO_MES, 0) - OLD.VALOR_TOTAL
                WHERE COD_FUNCIONARIO = OLD.COD_FUNCIONARIO;
            END IF;

            -- Adiciona o novo valor ao novo funcionário
            UPDATE FUNCIONARIO
            SET QTD_VENDIDA_NO_MES = COALESCE(QTD_VENDIDA_NO_MES, 0) + NEW.VALOR_TOTAL
            WHERE COD_FUNCIONARIO = NEW.COD_FUNCIONARIO;
        END IF;

    ELSIF TG_OP = 'DELETE' THEN
        -- Subtrai o valor da venda deletada do funcionário
        UPDATE FUNCIONARIO
        SET QTD_VENDIDA_NO_MES = COALESCE(QTD_VENDIDA_NO_MES, 0) - OLD.VALOR_TOTAL
        WHERE COD_FUNCIONARIO = OLD.COD_FUNCIONARIO;
    END IF;

    RETURN NULL; -- Para triggers AFTER, o valor de retorno é geralmente ignorado
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_atualiza_qtd_vendida_funcionario
AFTER INSERT OR UPDATE OR DELETE ON VENDA
FOR EACH ROW
EXECUTE FUNCTION fn_atualiza_qtd_vendida_funcionario();

-- Valida se a meta mensal inserida é negativa

CREATE OR REPLACE FUNCTION fn_valida_meta_mensal_funcionario()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.META_MENSAL < 0 THEN
        RAISE EXCEPTION 'A meta mensal (R$ %.2f) do funcionário não pode ser negativa.', NEW.META_MENSAL;
    END IF;
    RETURN NEW; -- Permite a operação se a validação passar
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_valida_meta_mensal_funcionario
BEFORE INSERT OR UPDATE ON FUNCIONARIO
FOR EACH ROW
EXECUTE FUNCTION fn_valida_meta_mensal_funcionario();

-- Valida o valor da venda ao Cliente

CREATE OR REPLACE FUNCTION fn_atualiza_gasto_cliente()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Adiciona o valor da nova venda ao cliente
        UPDATE CLIENTE
        SET QTD_GASTO = COALESCE(QTD_GASTO, 0) + NEW.VALOR_TOTAL
        WHERE COD_CLIENTE = NEW.COD_CLIENTE;

    ELSIF TG_OP = 'UPDATE' THEN
        -- Se o valor da venda mudou ou o cliente mudou
        IF OLD.VALOR_TOTAL IS DISTINCT FROM NEW.VALOR_TOTAL OR OLD.COD_CLIENTE IS DISTINCT FROM NEW.COD_CLIENTE THEN
            -- Remove o valor antigo do cliente antigo (se houver)
            IF OLD.COD_CLIENTE IS NOT NULL THEN
                UPDATE CLIENTE
                SET QTD_GASTO = COALESCE(QTD_GASTO, 0) - OLD.VALOR_TOTAL
                WHERE COD_CLIENTE = OLD.COD_CLIENTE;
            END IF;

            -- Adiciona o novo valor ao novo cliente
            UPDATE CLIENTE
            SET QTD_GASTO = COALESCE(QTD_GASTO, 0) + NEW.VALOR_TOTAL
            WHERE COD_CLIENTE = NEW.COD_CLIENTE;
        END IF;

    ELSIF TG_OP = 'DELETE' THEN
        -- Subtrai o valor da venda deletada do cliente
        UPDATE CLIENTE
        SET QTD_GASTO = COALESCE(QTD_GASTO, 0) - OLD.VALOR_TOTAL
        WHERE COD_CLIENTE = OLD.COD_CLIENTE;
    END IF;

    RETURN NULL; -- Para triggers AFTER, o valor de retorno é geralmente ignorado
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_atualiza_gasto_cliente
AFTER INSERT OR UPDATE OR DELETE ON VENDA
FOR EACH ROW
EXECUTE FUNCTION fn_atualiza_gasto_cliente();

-- Funcionario bateu a meta

CREATE OR REPLACE FUNCTION checa_meta()
RETURNS TRIGGER AS $$
DECLARE
total FLOAT;
meta FLOAT;
BEGIN
SELECT QTD_VENDIDA_NO_MES, META_MENSAL INTO total, meta
FROM FUNCIONARIO
WHERE COD_FUNCIONARIO = NEW.COD_FUNCIONARIO;

IF (total + NEW.VALOR_TOTAL) >= meta THEN
RAISE NOTICE 'Funcionário atingiu ou ultrapassou a meta mensal!';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_checa_meta
BEFORE INSERT ON VENDA
FOR EACH ROW EXECUTE FUNCTION checa_meta();

-- Validar para que o funcionario so venda carros da sua loja 

CREATE OR REPLACE FUNCTION verificar_funcionario_loja_item_venda()
RETURNS TRIGGER AS $$
DECLARE
    loja_funcionario INT;
    loja_carro INT;
    cod_funcionario INT;
BEGIN
    -- Pegar o código do funcionário na venda
    SELECT COD_FUNCIONARIO INTO cod_funcionario
    FROM VENDA
    WHERE COD_VENDA = NEW.COD_VENDA;

    -- Pegar a loja do funcionário
    SELECT LC.COD_LOJA INTO loja_funcionario
    FROM FUNCIONARIO F
    JOIN LOJA_CARRO LC ON F.COD_LOJA_CARRO = LC.COD_LOJA_CARRO
    WHERE F.COD_FUNCIONARIO = cod_funcionario;

    -- Pegar a loja do carro no item de venda
    SELECT COD_LOJA INTO loja_carro
    FROM LOJA_CARRO
    WHERE COD_LOJA_CARRO = NEW.COD_LOJA_CARRO;

    -- Comparar as lojas
    IF loja_funcionario <> loja_carro THEN
        RAISE EXCEPTION 'Funcionário só pode vender carros da loja onde trabalha.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verificar_funcionario_loja_item_venda_tr
BEFORE INSERT OR UPDATE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION verificar_funcionario_loja_item_venda();


