--================================================================================--
--                  SCRIPT COMPLETO - BANCO DE DADOS CONCESSIONÁRIA
--================================================================================--
--  Este script contém a criação de todas as tabelas, gatilhos (triggers) e 
--  funções do sistema. Execute-o completamente em um banco de dados PostgreSQL.
--================================================================================--


--================================================================================--
--               1. CRIAÇÃO DAS TABELAS E INSERÇÃO DE DADOS INICIAIS
--================================================================================--

-- Tabela de Cores dos Carros
CREATE TABLE COR (
    COD_COR INT PRIMARY KEY, 
    NOME VARCHAR(20)
);

INSERT INTO COR (COD_COR, NOME) VALUES 
(1, 'PRETO'),
(2, 'BRANCO'),
(3, 'PRATA');

-- Tabela de Lojas da Concessionária
CREATE TABLE LOJA (
    COD_LOJA INT PRIMARY KEY, 
    NOME VARCHAR(20)
);

INSERT INTO LOJA (COD_LOJA, NOME) VALUES
(1, 'LOJA 1'),
(2, 'LOJA 2'),
(3, 'LOJA 3');

-- Tabela de Marcas dos Carros
CREATE TABLE MARCA (
    COD_MARCA INT PRIMARY KEY, 
    NOME VARCHAR(20)
);

INSERT INTO MARCA (COD_MARCA, NOME) VALUES
(1, 'TOYOTA'),
(2, 'CHEVROLET'),
(3, 'FORD');

-- Tabela de Tipos de Carroceria
CREATE TABLE TIPO (
    COD_TIPO INT PRIMARY KEY, 
    NOME VARCHAR(20)
);

INSERT INTO TIPO (COD_TIPO, NOME) VALUES
(1, 'HATCH'),
(2, 'SUV'),
(3, 'SEDAN');

-- Tabela de Carros
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

INSERT INTO CARRO (COD_CARRO, COD_COR, COD_MARCA, COD_TIPO, NOME, PRECO, ANO, QTD_EM_ESTOQUE) VALUES
(1, 1, 1, 1, 'COROLLA', 150000.00, '2024', 10),
(2, 2, 2, 2, 'ONIX', 85000.00, '2023', 10),
(3, 3, 3, 3, 'RANGER', 190000.00, '2022', 10);

-- Tabela de associação entre Loja e Carro
CREATE TABLE LOJA_CARRO (
    COD_LOJA_CARRO INT PRIMARY KEY,
    COD_LOJA INT, 
    COD_CARRO INT,
    FOREIGN KEY (COD_LOJA) REFERENCES LOJA(COD_LOJA),
    FOREIGN KEY (COD_CARRO) REFERENCES CARRO(COD_CARRO)
);

INSERT INTO LOJA_CARRO (COD_LOJA_CARRO, COD_LOJA, COD_CARRO) VALUES
(1, 1, 1), (2, 1, 2), (3, 1, 3),
(4, 2, 1), (5, 2, 2), (6, 2, 3),
(7, 3, 1), (8, 3, 2), (9, 3, 3);

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
(2, 'Beatriz Ferreira Souza', '1992-07-20', 2800.00, 8000.00, 0, 5), -- Alterado para loja 2
(3, 'Ricardo Lima Azevedo', '1978-11-05', 4200.00, 12000.00, 0, 9); -- Alterado para loja 3

-- Tabela de Clientes
CREATE TABLE CLIENTE (
    COD_CLIENTE INT PRIMARY KEY,
    NOME VARCHAR(100),
    DT_NASCIMENTO DATE, 
    QTD_GASTO FLOAT
);

INSERT INTO CLIENTE (COD_CLIENTE, NOME, DT_NASCIMENTO, QTD_GASTO) VALUES
(1, 'Fernanda Moreira Costa', '1990-01-25', 0), (2, 'Lucas Dias Martins', '1988-06-10', 0),
(3, 'Juliana Pereira Alves', '2000-09-30', 0), (4, 'TecnoSoluções Avançadas Ltda', '2010-04-12', 0),
(5, 'Comércio Varejista XYZ EIRELI', '2015-08-01', 0), (6, 'Serviços Gerais Alfa & Filhos S.A.', '2005-11-20', 0);

-- Tabela de Pessoas Físicas
CREATE TABLE PESSOA_FISICA (
    COD_CLIENTE INT PRIMARY KEY, 
    CPF VARCHAR(14) UNIQUE NOT NULL,
    FOREIGN KEY (COD_CLIENTE) REFERENCES CLIENTE(COD_CLIENTE)
);

INSERT INTO PESSOA_FISICA (COD_CLIENTE, CPF) VALUES
(1, '11122233344'), (2, '55566677788'), (3, '99900011122');

-- Tabela de Pessoas Jurídicas
CREATE TABLE PESSOA_JURIDICA (
    COD_CLIENTE INT PRIMARY KEY,
    CNPJ VARCHAR(18) UNIQUE NOT NULL,   
    FOREIGN KEY (COD_CLIENTE) REFERENCES CLIENTE(COD_CLIENTE)
);

INSERT INTO PESSOA_JURIDICA (COD_CLIENTE, CNPJ) VALUES
(4, '11222333000144'), (5, '44555666000188'), (6, '77888999000122');

-- Tabela de Vendas
CREATE TABLE VENDA (
    COD_VENDA INT PRIMARY KEY,
    COD_FUNCIONARIO INT,
    COD_CLIENTE INT,
    VALOR_TOTAL FLOAT,
    DT_VENDA DATE,
    FOREIGN KEY (COD_FUNCIONARIO) REFERENCES FUNCIONARIO(COD_FUNCIONARIO),
    FOREIGN KEY (COD_CLIENTE) REFERENCES CLIENTE(COD_CLIENTE)
);

-- Tabela de Itens da Venda
CREATE TABLE ITEM_VENDA (
    COD_ITEM_VENDA INT PRIMARY KEY,
    COD_VENDA INT,
    COD_LOJA_CARRO INT,
    QTD_DE_ITENS INT,
    FOREIGN KEY (COD_VENDA) REFERENCES VENDA(COD_VENDA),
    FOREIGN KEY (COD_LOJA_CARRO) REFERENCES LOJA_CARRO(COD_LOJA_CARRO)
);


--================================================================================--
--                            2. TRIGGERS (GATILHOS)
--================================================================================--

-- Trigger: Calcula o valor total da venda e atualiza o estoque a cada item modificado.
CREATE OR REPLACE FUNCTION total_da_venda() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE VENDA SET VALOR_TOTAL = (SELECT COALESCE(SUM(IV.QTD_DE_ITENS * C.PRECO), 0) FROM ITEM_VENDA AS IV JOIN LOJA_CARRO AS LC ON IV.COD_LOJA_CARRO = LC.COD_LOJA_CARRO JOIN CARRO AS C ON LC.COD_CARRO = C.COD_CARRO WHERE IV.COD_VENDA = NEW.COD_VENDA) WHERE COD_VENDA = NEW.COD_VENDA;
        UPDATE CARRO SET QTD_EM_ESTOQUE = QTD_EM_ESTOQUE - NEW.QTD_DE_ITENS WHERE COD_CARRO = (SELECT LC.COD_CARRO FROM LOJA_CARRO AS LC WHERE LC.COD_LOJA_CARRO = NEW.COD_LOJA_CARRO);
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE VENDA SET VALOR_TOTAL = (SELECT COALESCE(SUM(IV.QTD_DE_ITENS * C.PRECO), 0) FROM ITEM_VENDA AS IV JOIN LOJA_CARRO AS LC ON IV.COD_LOJA_CARRO = LC.COD_LOJA_CARRO JOIN CARRO AS C ON LC.COD_CARRO = C.COD_CARRO WHERE IV.COD_VENDA = NEW.COD_VENDA) WHERE COD_VENDA = NEW.COD_VENDA;
        UPDATE CARRO SET QTD_EM_ESTOQUE = QTD_EM_ESTOQUE + OLD.QTD_DE_ITENS WHERE COD_CARRO = (SELECT LC.COD_CARRO FROM LOJA_CARRO AS LC WHERE LC.COD_LOJA_CARRO = OLD.COD_LOJA_CARRO);
        UPDATE CARRO SET QTD_EM_ESTOQUE = QTD_EM_ESTOQUE - NEW.QTD_DE_ITENS WHERE COD_CARRO = (SELECT LC.COD_CARRO FROM LOJA_CARRO AS LC WHERE LC.COD_LOJA_CARRO = NEW.COD_LOJA_CARRO);
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE VENDA SET VALOR_TOTAL = (SELECT COALESCE(SUM(IV.QTD_DE_ITENS * C.PRECO), 0) FROM ITEM_VENDA AS IV JOIN LOJA_CARRO AS LC ON IV.COD_LOJA_CARRO = LC.COD_LOJA_CARRO JOIN CARRO AS C ON LC.COD_CARRO = C.COD_CARRO WHERE IV.COD_VENDA = OLD.COD_VENDA) WHERE COD_VENDA = OLD.COD_VENDA;
        UPDATE CARRO SET QTD_EM_ESTOQUE = QTD_EM_ESTOQUE + OLD.QTD_DE_ITENS WHERE COD_CARRO = (SELECT LC.COD_CARRO FROM LOJA_CARRO AS LC WHERE LC.COD_LOJA_CARRO = OLD.COD_LOJA_CARRO);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER total_da_venda_tr 
AFTER INSERT OR UPDATE OR DELETE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION total_da_venda();

-- Trigger: Valida se o funcionário e o cliente informados na venda realmente existem.
CREATE OR REPLACE FUNCTION validar_funcionario_cliente() RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM FUNCIONARIO WHERE COD_FUNCIONARIO = NEW.COD_FUNCIONARIO) THEN
        RAISE EXCEPTION 'Funcionário com código % não existe.', NEW.COD_FUNCIONARIO;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM CLIENTE WHERE COD_CLIENTE = NEW.COD_CLIENTE) THEN
        RAISE EXCEPTION 'Cliente com código % não existe.', NEW.COD_CLIENTE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validar_funcionario_cliente_tr 
BEFORE INSERT OR UPDATE ON VENDA 
FOR EACH ROW EXECUTE FUNCTION validar_funcionario_cliente();

-- Trigger: Valida se a quantidade de itens vendidos não é maior que o estoque.
CREATE OR REPLACE FUNCTION validar_qtd() RETURNS TRIGGER AS $$
DECLARE 
    qtd_presente_no_estoque INT;
BEGIN
    SELECT C.QTD_EM_ESTOQUE INTO qtd_presente_no_estoque FROM CARRO AS C JOIN LOJA_CARRO AS LC ON LC.COD_CARRO = C.COD_CARRO WHERE LC.COD_LOJA_CARRO = NEW.COD_LOJA_CARRO;
    IF NEW.QTD_DE_ITENS > qtd_presente_no_estoque THEN
        RAISE EXCEPTION 'Quantidade de itens (%), maior que a presente no estoque (%)', NEW.QTD_DE_ITENS, qtd_presente_no_estoque;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validar_qtd_tr 
BEFORE INSERT OR UPDATE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION validar_qtd();

-- Trigger: Impede o registro de vendas com data futura.
CREATE OR REPLACE FUNCTION fn_impede_venda_futura() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.DT_VENDA > CURRENT_DATE THEN
        RAISE EXCEPTION 'Não é permitido registrar vendas com data futura (Data informada: %).', TO_CHAR(NEW.DT_VENDA, 'DD/MM/YYYY');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_impede_venda_futura
BEFORE INSERT OR UPDATE ON VENDA
FOR EACH ROW EXECUTE FUNCTION fn_impede_venda_futura();

-- Trigger: Atualiza o total vendido pelo funcionário a cada venda modificada.
CREATE OR REPLACE FUNCTION fn_atualiza_qtd_vendida_funcionario() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE FUNCIONARIO SET QTD_VENDIDA_NO_MES = COALESCE(QTD_VENDIDA_NO_MES, 0) + NEW.VALOR_TOTAL WHERE COD_FUNCIONARIO = NEW.COD_FUNCIONARIO;
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.VALOR_TOTAL IS DISTINCT FROM NEW.VALOR_TOTAL OR OLD.COD_FUNCIONARIO IS DISTINCT FROM NEW.COD_FUNCIONARIO THEN
            IF OLD.COD_FUNCIONARIO IS NOT NULL THEN
                UPDATE FUNCIONARIO SET QTD_VENDIDA_NO_MES = COALESCE(QTD_VENDIDA_NO_MES, 0) - OLD.VALOR_TOTAL WHERE COD_FUNCIONARIO = OLD.COD_FUNCIONARIO;
            END IF;
            UPDATE FUNCIONARIO SET QTD_VENDIDA_NO_MES = COALESCE(QTD_VENDIDA_NO_MES, 0) + NEW.VALOR_TOTAL WHERE COD_FUNCIONARIO = NEW.COD_FUNCIONARIO;
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE FUNCIONARIO SET QTD_VENDIDA_NO_MES = COALESCE(QTD_VENDIDA_NO_MES, 0) - OLD.VALOR_TOTAL WHERE COD_FUNCIONARIO = OLD.COD_FUNCIONARIO;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_atualiza_qtd_vendida_funcionario
AFTER INSERT OR UPDATE OR DELETE ON VENDA
FOR EACH ROW EXECUTE FUNCTION fn_atualiza_qtd_vendida_funcionario();

-- Trigger: Impede que a meta mensal de um funcionário seja um valor negativo.
CREATE OR REPLACE FUNCTION fn_valida_meta_mensal_funcionario() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.META_MENSAL < 0 THEN
        RAISE EXCEPTION 'A meta mensal (R$ %.2f) do funcionário não pode ser negativa.', NEW.META_MENSAL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_valida_meta_mensal_funcionario
BEFORE INSERT OR UPDATE ON FUNCIONARIO
FOR EACH ROW EXECUTE FUNCTION fn_valida_meta_mensal_funcionario();

-- Trigger: Atualiza o valor total gasto pelo cliente a cada venda modificada.
CREATE OR REPLACE FUNCTION fn_atualiza_gasto_cliente() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE CLIENTE SET QTD_GASTO = COALESCE(QTD_GASTO, 0) + NEW.VALOR_TOTAL WHERE COD_CLIENTE = NEW.COD_CLIENTE;
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.VALOR_TOTAL IS DISTINCT FROM NEW.VALOR_TOTAL OR OLD.COD_CLIENTE IS DISTINCT FROM NEW.COD_CLIENTE THEN
            IF OLD.COD_CLIENTE IS NOT NULL THEN
                UPDATE CLIENTE SET QTD_GASTO = COALESCE(QTD_GASTO, 0) - OLD.VALOR_TOTAL WHERE COD_CLIENTE = OLD.COD_CLIENTE;
            END IF;
            UPDATE CLIENTE SET QTD_GASTO = COALESCE(QTD_GASTO, 0) + NEW.VALOR_TOTAL WHERE COD_CLIENTE = NEW.COD_CLIENTE;
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE CLIENTE SET QTD_GASTO = COALESCE(QTD_GASTO, 0) - OLD.VALOR_TOTAL WHERE COD_CLIENTE = OLD.COD_CLIENTE;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_atualiza_gasto_cliente
AFTER INSERT OR UPDATE OR DELETE ON VENDA
FOR EACH ROW EXECUTE FUNCTION fn_atualiza_gasto_cliente();

-- Trigger: Emite um aviso quando o funcionário atinge sua meta mensal.
CREATE OR REPLACE FUNCTION checa_meta() RETURNS TRIGGER AS $$
DECLARE
    total FLOAT;
    meta FLOAT;
BEGIN
    SELECT QTD_VENDIDA_NO_MES, META_MENSAL INTO total, meta FROM FUNCIONARIO WHERE COD_FUNCIONARIO = NEW.COD_FUNCIONARIO;
    IF (total + NEW.VALOR_TOTAL) >= meta THEN
        RAISE NOTICE 'Parabéns! O funcionário com código % atingiu ou ultrapassou a meta mensal!', NEW.COD_FUNCIONARIO;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_checa_meta
BEFORE INSERT OR UPDATE ON VENDA
FOR EACH ROW EXECUTE FUNCTION checa_meta();

-- Trigger: Garante que um funcionário só possa vender carros da sua própria loja.
CREATE OR REPLACE FUNCTION verificar_funcionario_loja_item_venda() RETURNS TRIGGER AS $$
DECLARE
    v_cod_loja_funcionario INT;
    v_cod_loja_carro INT;
    v_cod_funcionario INT;
BEGIN
    SELECT V.COD_FUNCIONARIO INTO v_cod_funcionario FROM VENDA AS V WHERE V.COD_VENDA = NEW.COD_VENDA;
    IF v_cod_funcionario IS NULL THEN
        RETURN NEW;
    END IF;
    SELECT LC.COD_LOJA INTO v_cod_loja_funcionario FROM FUNCIONARIO F JOIN LOJA_CARRO LC ON F.COD_LOJA_CARRO = LC.COD_LOJA_CARRO WHERE F.COD_FUNCIONARIO = v_cod_funcionario;
    SELECT LC.COD_LOJA INTO v_cod_loja_carro FROM LOJA_CARRO AS LC WHERE LC.COD_LOJA_CARRO = NEW.COD_LOJA_CARRO;
    IF v_cod_loja_funcionario <> v_cod_loja_carro THEN
        RAISE EXCEPTION 'O funcionário (da loja %) só pode vender carros da sua própria loja (tentativa de vender da loja %).', v_cod_loja_funcionario, v_cod_loja_carro;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verificar_funcionario_loja_item_venda_tr
BEFORE INSERT OR UPDATE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION verificar_funcionario_loja_item_venda();


--================================================================================--
--                                3. FUNÇÕES
--================================================================================--

-- Função: Insere um registro em uma tabela dinamicamente.
CREATE OR REPLACE FUNCTION inserir_na_tabela(nome_tabela TEXT, colunas TEXT, valores TEXT)
RETURNS VOID AS $$
DECLARE
    comando_sql TEXT;
BEGIN
    comando_sql := FORMAT('INSERT INTO %s (%s) VALUES (%s)', nome_tabela, colunas, valores);
    EXECUTE comando_sql;
    RAISE NOTICE 'Comando executado: %', comando_sql;
END;
$$ LANGUAGE plpgsql;

-- Função: Deleta um registro de uma tabela dinamicamente com base em uma condição.
CREATE OR REPLACE FUNCTION deletar_de_tabela(nome_tabela TEXT, condicao TEXT)
RETURNS VOID AS $$
DECLARE
    comando_sql TEXT;
BEGIN
    comando_sql := FORMAT('DELETE FROM %s WHERE %s', nome_tabela, condicao);
    EXECUTE comando_sql;
    RAISE NOTICE 'Comando executado: %', comando_sql;
END;
$$ LANGUAGE plpgsql;

-- Função: Retorna a loja com maior volume de vendas em um determinado mês e ano.
CREATE OR REPLACE FUNCTION fn_loja_campea_de_vendas(p_mes INT, p_ano INT)
RETURNS TABLE (nome_loja VARCHAR, total_vendido FLOAT) AS $$
BEGIN
    IF p_mes IS NULL OR p_mes NOT BETWEEN 1 AND 12 THEN
        RAISE EXCEPTION 'Mês inválido. Forneça um valor entre 1 e 12.';
    END IF;
    IF p_ano IS NULL OR p_ano < 1900 THEN
        RAISE EXCEPTION 'Ano inválido. Forneça um ano válido.';
    END IF;

    RETURN QUERY
    SELECT L.NOME, SUM(V.VALOR_TOTAL) AS "Total Vendido"
    FROM VENDA AS V
    JOIN FUNCIONARIO AS F ON V.COD_FUNCIONARIO = F.COD_FUNCIONARIO
    JOIN LOJA_CARRO AS LC ON F.COD_LOJA_CARRO = LC.COD_LOJA_CARRO
    JOIN LOJA AS L ON LC.COD_LOJA = L.COD_LOJA
    WHERE EXTRACT(MONTH FROM V.DT_VENDA) = p_mes AND EXTRACT(YEAR FROM V.DT_VENDA) = p_ano
    GROUP BY L.NOME
    ORDER BY "Total Vendido" DESC
    LIMIT 1; 
END;
$$ LANGUAGE plpgsql;

