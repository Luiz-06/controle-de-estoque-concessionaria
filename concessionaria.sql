--================================================================================--
-- 				SCRIPT FINAL E COMPLETO - BANCO DE DADOS CONCESSIONÁRIA
--================================================================================--
-- 	Versão final com organização, padronização e inclusão de restrições NOT NULL
-- 	para garantir a integridade e consistência dos dados.
--================================================================================--


--================================================================================--
-- 				1. CRIAÇÃO DAS TABELAS
--================================================================================--

CREATE TABLE COR (
	COD_COR INT PRIMARY KEY,
	NOME VARCHAR(20) NOT NULL
);

CREATE TABLE LOJA (
	COD_LOJA INT PRIMARY KEY,
	NOME VARCHAR(20) NOT NULL
);

CREATE TABLE MARCA (
	COD_MARCA INT PRIMARY KEY,
	NOME VARCHAR(20) NOT NULL
);

CREATE TABLE TIPO (
	COD_TIPO INT PRIMARY KEY,
	NOME VARCHAR(20) NOT NULL
);

CREATE TABLE CARRO (
	COD_CARRO INT PRIMARY KEY,
	COD_COR INT NOT NULL REFERENCES COR(COD_COR),
	COD_MARCA INT NOT NULL REFERENCES MARCA(COD_MARCA),
	COD_TIPO INT NOT NULL REFERENCES TIPO(COD_TIPO),
	NOME VARCHAR(20) NOT NULL,
	PRECO FLOAT NOT NULL,
	ANO VARCHAR(20) NOT NULL,
	QTD_EM_ESTOQUE INT NOT NULL
);

CREATE TABLE LOJA_CARRO (
	COD_LOJA_CARRO INT PRIMARY KEY,
	COD_LOJA INT NOT NULL REFERENCES LOJA(COD_LOJA),
	COD_CARRO INT NOT NULL REFERENCES CARRO(COD_CARRO)
);

CREATE TABLE FUNCIONARIO (
	COD_FUNCIONARIO INT PRIMARY KEY,
	NOME VARCHAR(100) NOT NULL,
	DT_NASCIMENTO DATE NOT NULL,
	SALARIO FLOAT NOT NULL,
	META_MENSAL FLOAT NOT NULL,
	QTD_VENDIDA_NO_MES FLOAT NOT NULL,
	COD_LOJA INT NOT NULL REFERENCES LOJA(COD_LOJA)
);

CREATE TABLE CLIENTE (
	COD_CLIENTE INT PRIMARY KEY,
	NOME VARCHAR(100) NOT NULL,
	DT_NASCIMENTO DATE NOT NULL,
	QTD_GASTO FLOAT NOT NULL
);

CREATE TABLE PESSOA_FISICA (
	COD_CLIENTE INT PRIMARY KEY REFERENCES CLIENTE(COD_CLIENTE),
	CPF VARCHAR(14) UNIQUE NOT NULL
);

CREATE TABLE PESSOA_JURIDICA (
	COD_CLIENTE INT PRIMARY KEY REFERENCES CLIENTE(COD_CLIENTE),
	CNPJ VARCHAR(18) UNIQUE NOT NULL
);

CREATE TABLE VENDA (
	COD_VENDA INT PRIMARY KEY,
	COD_FUNCIONARIO INT NOT NULL REFERENCES FUNCIONARIO(COD_FUNCIONARIO),
	COD_CLIENTE INT NOT NULL REFERENCES CLIENTE(COD_CLIENTE),
	VALOR_TOTAL FLOAT NOT NULL,
	DT_VENDA DATE NOT NULL
);

CREATE TABLE ITEM_VENDA (
	COD_ITEM_VENDA INT PRIMARY KEY,
	COD_VENDA INT NOT NULL REFERENCES VENDA(COD_VENDA),
	COD_LOJA_CARRO INT NOT NULL REFERENCES LOJA_CARRO(COD_LOJA_CARRO),
	QTD_DE_ITENS INT NOT NULL
);











--================================================================================--
-- 				2. GATILHOS (TRIGGERS) E SUAS FUNÇÕES
--================================================================================--

-- 2.1. Gatilho para calcular o total da venda e atualizar o estoque
CREATE OR REPLACE FUNCTION fn_total_da_venda() RETURNS TRIGGER AS $$
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

CREATE TRIGGER tg_total_da_venda AFTER INSERT OR UPDATE OR DELETE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION fn_total_da_venda();

-- 2.2. Gatilho para validar a existência do funcionário e do cliente na venda
CREATE OR REPLACE FUNCTION fn_validar_funcionario_cliente() RETURNS TRIGGER AS $$
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

CREATE TRIGGER tg_validar_funcionario_cliente BEFORE INSERT OR UPDATE ON VENDA
FOR EACH ROW EXECUTE FUNCTION fn_validar_funcionario_cliente();

-- 2.3. Gatilho para validar se a quantidade vendida não é maior que o estoque
CREATE OR REPLACE FUNCTION fn_validar_qtd() RETURNS TRIGGER AS $$
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

CREATE TRIGGER tg_validar_qtd BEFORE INSERT OR UPDATE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION fn_validar_qtd();

-- 2.4. Gatilho para impedir o registro de vendas com data futura
CREATE OR REPLACE FUNCTION fn_impede_venda_futura() RETURNS TRIGGER AS $$
BEGIN
	IF NEW.DT_VENDA > CURRENT_DATE THEN
		RAISE EXCEPTION 'Não é permitido registrar vendas com data futura (Data informada: %).', TO_CHAR(NEW.DT_VENDA, 'DD/MM/YYYY');
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_impede_venda_futura BEFORE INSERT OR UPDATE ON VENDA
FOR EACH ROW EXECUTE FUNCTION fn_impede_venda_futura();

-- 2.5. Gatilho para atualizar o total vendido pelo funcionário
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

CREATE TRIGGER tg_atualiza_qtd_vendida_funcionario AFTER INSERT OR UPDATE OR DELETE ON VENDA
FOR EACH ROW EXECUTE FUNCTION fn_atualiza_qtd_vendida_funcionario();

-- 2.6. Gatilho para impedir que a meta mensal de um funcionário seja negativa
CREATE OR REPLACE FUNCTION fn_valida_meta_mensal_funcionario() RETURNS TRIGGER AS $$
BEGIN
	IF NEW.META_MENSAL < 0 THEN
		RAISE EXCEPTION 'A meta mensal (R$ %.2f) do funcionário não pode ser negativa.', NEW.META_MENSAL;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_valida_meta_mensal_funcionario BEFORE INSERT OR UPDATE ON FUNCIONARIO
FOR EACH ROW EXECUTE FUNCTION fn_valida_meta_mensal_funcionario();

-- 2.7. Gatilho para atualizar o valor total gasto pelo cliente
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

CREATE TRIGGER tg_atualiza_gasto_cliente AFTER INSERT OR UPDATE OR DELETE ON VENDA
FOR EACH ROW EXECUTE FUNCTION fn_atualiza_gasto_cliente();

-- 2.8. Gatilho para emitir um aviso quando o funcionário atinge a meta mensal
CREATE OR REPLACE FUNCTION fn_checa_meta() RETURNS TRIGGER AS $$
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

CREATE TRIGGER tg_checa_meta BEFORE INSERT OR UPDATE ON VENDA
FOR EACH ROW EXECUTE FUNCTION fn_checa_meta();

-- 2.9. Gatilho para garantir que um funcionário só venda carros da sua própria loja
CREATE OR REPLACE FUNCTION fn_verificar_funcionario_loja_item_venda() RETURNS TRIGGER AS $$
DECLARE
	v_cod_loja_funcionario INT;
	v_cod_loja_carro INT;
	v_cod_funcionario INT;
BEGIN
	SELECT V.COD_FUNCIONARIO INTO v_cod_funcionario FROM VENDA AS V WHERE V.COD_VENDA = NEW.COD_VENDA;
	IF v_cod_funcionario IS NULL THEN
		RETURN NEW;
	END IF;
	SELECT F.COD_LOJA INTO v_cod_loja_funcionario FROM FUNCIONARIO AS F WHERE F.COD_FUNCIONARIO = v_cod_funcionario;
	SELECT LC.COD_LOJA INTO v_cod_loja_carro FROM LOJA_CARRO AS LC WHERE LC.COD_LOJA_CARRO = NEW.COD_LOJA_CARRO;

	IF v_cod_loja_funcionario <> v_cod_loja_carro THEN
		RAISE EXCEPTION 'O funcionário (da loja %) só pode vender carros da sua própria loja (tentativa de vender da loja %).', v_cod_loja_funcionario, v_cod_loja_carro;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_verificar_funcionario_loja_item_venda BEFORE INSERT OR UPDATE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION fn_verificar_funcionario_loja_item_venda();











--================================================================================--
-- 				3. FUNÇÕES
--================================================================================--

------------------------------------------------------------------------------------
-- 3.1. FUNÇÕES GENÉRICAS DE MANIPULAÇÃO DE DADOS
------------------------------------------------------------------------------------

-- DESCRIÇÃO: Insere um registro em uma tabela dinamicamente.
CREATE OR REPLACE FUNCTION fn_inserir_na_tabela(nome_tabela TEXT, colunas TEXT, valores TEXT)
RETURNS VOID AS $$
DECLARE
	comando_sql TEXT;
BEGIN
	comando_sql := FORMAT('INSERT INTO %I (%s) VALUES (%s)', nome_tabela, colunas, valores);
	EXECUTE comando_sql;
	RAISE NOTICE 'Comando executado: %', comando_sql;
END;
$$ LANGUAGE plpgsql;

-- DESCRIÇÃO: Deleta um registro de uma tabela com base em uma condição, com tratamento de erro.
CREATE OR REPLACE FUNCTION fn_deletar_da_tabela(p_nome_tabela TEXT, p_condicao TEXT)
RETURNS VOID AS $$
DECLARE
	comando_sql TEXT;
BEGIN
	comando_sql := FORMAT('DELETE FROM %I WHERE %s', p_nome_tabela, p_condicao);
	RAISE NOTICE 'Tentando executar: %', comando_sql;
	EXECUTE comando_sql;
	RAISE NOTICE 'Registro(s) removido(s) com sucesso da tabela %s.', p_nome_tabela;
EXCEPTION
	WHEN foreign_key_violation THEN
		RAISE EXCEPTION 'ERRO: Não é possível remover o registro da tabela "%", pois ele está a ser utilizado por outra tabela.', p_nome_tabela;
END;
$$ LANGUAGE plpgsql;

-- DESCRIÇÃO: Atualiza um ou mais registros em uma tabela com base em uma condição.
CREATE OR REPLACE FUNCTION fn_atualizar_tabela(p_nome_tabela TEXT, p_atualizacoes TEXT, p_condicao TEXT)
RETURNS VOID AS $$
DECLARE
    comando_sql TEXT;
BEGIN
    IF p_nome_tabela IS NULL OR p_atualizacoes IS NULL OR p_condicao IS NULL THEN
        RAISE EXCEPTION 'ERRO: Nome da tabela, atualizações e condição não podem ser nulos.';
    END IF;
    comando_sql := FORMAT('UPDATE %I SET %s WHERE %s', p_nome_tabela, p_atualizacoes, p_condicao);
    RAISE NOTICE 'Executando comando: %', comando_sql;
    EXECUTE comando_sql;
    IF FOUND THEN
        RAISE NOTICE 'Registro(s) na tabela %s atualizado(s) com sucesso.', p_nome_tabela;
    ELSE
        RAISE NOTICE 'Nenhum registro correspondente à condição foi encontrado na tabela %s.', p_nome_tabela;
    END IF;
END;
$$ LANGUAGE plpgsql;

------------------------------------------------------------------------------------
-- 3.2. FUNÇÕES DE LÓGICA DE NEGÓCIO (OPERAÇÕES DE VENDA)
------------------------------------------------------------------------------------

-- DESCRIÇÃO: Cria um novo registro de venda para um cliente e funcionário.
CREATE OR REPLACE FUNCTION fn_realizar_venda(p_cod_cliente INT, p_cod_funcionario INT)
RETURNS INT AS $$
DECLARE
	v_nova_venda_id INT;
BEGIN
	SELECT COALESCE(MAX(COD_VENDA), 0) + 1 INTO v_nova_venda_id FROM VENDA;
	INSERT INTO VENDA (COD_VENDA, COD_CLIENTE, COD_FUNCIONARIO, VALOR_TOTAL, DT_VENDA)
	VALUES (v_nova_venda_id, p_cod_cliente, p_cod_funcionario, 0, CURRENT_DATE);
	RAISE NOTICE 'Venda com código % criada com sucesso. Agora, adicione os itens da venda.', v_nova_venda_id;
	RETURN v_nova_venda_id;
END;
$$ LANGUAGE plpgsql;

-- DESCRIÇÃO: Adiciona um item (carro) a uma venda existente, com validações.
CREATE OR REPLACE FUNCTION fn_inserir_na_venda(p_cod_venda INT, p_cod_loja_carro INT, p_qtd_de_itens INT)
RETURNS VOID AS $$
DECLARE
	v_novo_item_venda_id INT;
BEGIN
	IF NOT EXISTS (SELECT 1 FROM VENDA WHERE VENDA.COD_VENDA = p_cod_venda) THEN
		RAISE EXCEPTION 'ERRO: A venda com o código % não foi encontrada. Impossível adicionar o item.', p_cod_venda;
	END IF;
	IF p_qtd_de_itens <= 0 THEN
		RAISE EXCEPTION 'ERRO: A quantidade de itens para venda (%) deve ser um número positivo maior que zero.', p_qtd_de_itens;
	END IF;
	SELECT COALESCE(MAX(COD_ITEM_VENDA), 0) + 1 INTO v_novo_item_venda_id FROM ITEM_VENDA;
	INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS)
	VALUES (v_novo_item_venda_id, p_cod_venda, p_cod_loja_carro, p_qtd_de_itens);
	RAISE NOTICE 'Item (COD_LOJA_CARRO: %) adicionado com sucesso à venda de código %.', p_cod_loja_carro, p_cod_venda;
END;
$$ LANGUAGE plpgsql;

------------------------------------------------------------------------------------
-- 3.3. FUNÇÕES DE CONSULTA E RELATÓRIO
------------------------------------------------------------------------------------

-- DESCRIÇÃO: Retorna uma visão completa (recibo) de uma venda específica.
CREATE OR REPLACE FUNCTION fn_detalhes_venda(p_cod_venda INT)
RETURNS TABLE (id_da_venda INT, data_venda DATE, valor_total_venda FLOAT, nome_cliente VARCHAR, nome_funcionario VARCHAR, nome_carro VARCHAR, marca_carro VARCHAR, quantidade_itens INT, preco_unitario FLOAT, subtotal FLOAT) AS $$
DECLARE
	v_venda_existe INT;
BEGIN
	SELECT COUNT(*) INTO v_venda_existe FROM VENDA WHERE VENDA.COD_VENDA = p_cod_venda;
	IF v_venda_existe = 0 THEN
		RAISE EXCEPTION 'Venda com código % não encontrada.', p_cod_venda;
	END IF;
	RETURN QUERY
	SELECT V.COD_VENDA, V.DT_VENDA, V.VALOR_TOTAL, CL.NOME, F.NOME, C.NOME, M.NOME, IV.QTD_DE_ITENS, C.PRECO, (IV.QTD_DE_ITENS * C.PRECO)::FLOAT
	FROM VENDA AS V
	JOIN CLIENTE AS CL ON V.COD_CLIENTE = CL.COD_CLIENTE
	JOIN FUNCIONARIO AS F ON V.COD_FUNCIONARIO = F.COD_FUNCIONARIO
	JOIN ITEM_VENDA AS IV ON V.COD_VENDA = IV.COD_VENDA
	JOIN LOJA_CARRO AS LC ON IV.COD_LOJA_CARRO = LC.COD_LOJA_CARRO
	JOIN CARRO AS C ON LC.COD_CARRO = C.COD_CARRO
	JOIN MARCA AS M ON C.COD_MARCA = M.COD_MARCA
	WHERE V.COD_VENDA = p_cod_venda;
END;
$$ LANGUAGE plpgsql;

-- DESCRIÇÃO: Retorna o cliente que mais gastou na concessionária.
CREATE OR REPLACE FUNCTION fn_cliente_maior_gasto()
RETURNS TABLE (nome_cliente VARCHAR, total_gasto FLOAT) AS $$
BEGIN
	RETURN QUERY
	SELECT C.NOME, C.QTD_GASTO FROM CLIENTE AS C
	WHERE C.QTD_GASTO > 0
	ORDER BY C.QTD_GASTO DESC
	LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- DESCRIÇÃO: Retorna o(s) funcionário(s) com o maior valor de vendas no mês, tratando empates.
CREATE OR REPLACE FUNCTION fn_funcionario_campeao_de_vendas()
RETURNS TABLE (nome_funcionario VARCHAR, total_vendido_no_mes FLOAT) AS $$
BEGIN
	RETURN QUERY
	SELECT F.NOME, F.QTD_VENDIDA_NO_MES
	FROM FUNCIONARIO AS F
	WHERE F.QTD_VENDIDA_NO_MES = (SELECT MAX(QTD_VENDIDA_NO_MES) FROM FUNCIONARIO WHERE QTD_VENDIDA_NO_MES > 0);
END;
$$ LANGUAGE plpgsql;

-- DESCRIÇÃO: Retorna a loja com maior volume de vendas em um determinado mês e ano.
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
	JOIN LOJA AS L ON F.COD_LOJA = L.COD_LOJA
	WHERE EXTRACT(MONTH FROM V.DT_VENDA) = p_mes AND EXTRACT(YEAR FROM V.DT_VENDA) = p_ano
	GROUP BY L.NOME
	ORDER BY "Total Vendido" DESC
	LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- FUNÇÃO DE RELATÓRIO DE METAS ABAIXO
CREATE OR REPLACE FUNCTION fn_listar_funcionarios_abaixo_meta()
RETURNS TABLE (
    nome_funcionario VARCHAR,
    nome_loja VARCHAR,
    total_vendido FLOAT,
    meta_mensal FLOAT,
    valor_restante_para_meta FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        F.NOME,
        L.NOME,
        F.QTD_VENDIDA_NO_MES,
        F.META_MENSAL,
        (F.META_MENSAL - F.QTD_VENDIDA_NO_MES)::FLOAT AS valor_restante
    FROM
        FUNCIONARIO AS F
    JOIN
        LOJA AS L ON F.COD_LOJA = L.COD_LOJA
    WHERE
        F.QTD_VENDIDA_NO_MES < F.META_MENSAL
    ORDER BY
        valor_restante DESC;
END;
$$ LANGUAGE plpgsql;

-- DESCRIÇÃO: Calcula e lista o total vendido por TODAS as lojas, mostrando 0 para aquelas que não tiveram vendas.
CREATE OR REPLACE FUNCTION fn_total_vendido_por_loja()
RETURNS TABLE (nome_da_loja VARCHAR, valor_total_vendido FLOAT) AS $$
BEGIN
	RETURN QUERY
	SELECT L.NOME, COALESCE(SUM(V.VALOR_TOTAL), 0) AS total_vendido
	FROM LOJA AS L
	LEFT JOIN FUNCIONARIO AS F ON L.COD_LOJA = F.COD_LOJA
	LEFT JOIN VENDA AS V ON F.COD_FUNCIONARIO = V.COD_FUNCIONARIO
	GROUP BY L.NOME
	ORDER BY total_vendido DESC;
END;
$$ LANGUAGE plpgsql;

-- DESCRIÇÃO: Lista todos os carros disponíveis (estoque > 0) em uma loja específica.
CREATE OR REPLACE FUNCTION fn_listar_carros_disponiveis_por_loja(p_cod_loja INT)
RETURNS TABLE (nome_carro VARCHAR, nome_marca VARCHAR, nome_tipo VARCHAR, nome_cor VARCHAR, ano_carro VARCHAR, preco_carro FLOAT, qtd_em_estoque INT) AS $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM LOJA WHERE COD_LOJA = p_cod_loja) THEN
		RAISE EXCEPTION 'ERRO: A loja com o código % não foi encontrada.', p_cod_loja;
	END IF;
	RETURN QUERY
	SELECT C.NOME, M.NOME, T.NOME, CO.NOME, C.ANO, C.PRECO, C.QTD_EM_ESTOQUE
	FROM CARRO AS C
	JOIN MARCA AS M ON C.COD_MARCA = M.COD_MARCA
	JOIN TIPO AS T ON C.COD_TIPO = T.COD_TIPO
	JOIN COR AS CO ON C.COD_COR = CO.COD_COR
	JOIN LOJA_CARRO AS LC ON C.COD_CARRO = LC.COD_CARRO
	WHERE LC.COD_LOJA = p_cod_loja AND C.QTD_EM_ESTOQUE > 0;
END;
$$ LANGUAGE plpgsql;

-- DESCRIÇÃO: Lista todas as vendas realizadas por um funcionário específico.
CREATE OR REPLACE FUNCTION fn_listar_vendas_por_funcionario(p_cod_funcionario INT)
RETURNS TABLE (id_venda INT, data_da_venda DATE, nome_cliente VARCHAR, valor_total FLOAT) AS $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM FUNCIONARIO WHERE COD_FUNCIONARIO = p_cod_funcionario) THEN
		RAISE EXCEPTION 'ERRO: O funcionário com o código % não foi encontrado.', p_cod_funcionario;
	END IF;
	RETURN QUERY
	SELECT V.COD_VENDA, V.DT_VENDA, C.NOME, V.VALOR_TOTAL
	FROM VENDA AS V
	JOIN CLIENTE AS C ON V.COD_CLIENTE = C.COD_CLIENTE
	WHERE V.COD_FUNCIONARIO = p_cod_funcionario
	ORDER BY V.DT_VENDA DESC;
END;
$$ LANGUAGE plpgsql;

-- DESCRIÇÃO: Lista o histórico completo de compras de um cliente.
CREATE OR REPLACE FUNCTION fn_historico_compras_cliente(p_cod_cliente INT)
RETURNS TABLE (data_da_compra DATE, id_venda INT, nome_carro VARCHAR, marca_carro VARCHAR, quantidade INT, preco_unitario FLOAT, subtotal FLOAT) AS $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM CLIENTE WHERE COD_CLIENTE = p_cod_cliente) THEN
		RAISE EXCEPTION 'ERRO: O cliente com o código % não foi encontrado.', p_cod_cliente;
	END IF;
	RETURN QUERY
	SELECT V.DT_VENDA, V.COD_VENDA, C.NOME, M.NOME, IV.QTD_DE_ITENS, C.PRECO, (IV.QTD_DE_ITENS * C.PRECO)::FLOAT
	FROM VENDA AS V
	JOIN ITEM_VENDA AS IV ON V.COD_VENDA = IV.COD_VENDA
	JOIN LOJA_CARRO AS LC ON IV.COD_LOJA_CARRO = LC.COD_LOJA_CARRO
	JOIN CARRO AS C ON LC.COD_CARRO = C.COD_CARRO
	JOIN MARCA AS M ON C.COD_MARCA = M.COD_MARCA
	WHERE V.COD_CLIENTE = p_cod_cliente
	ORDER BY V.DT_VENDA DESC, V.COD_VENDA;
END;
$$ LANGUAGE plpgsql;
