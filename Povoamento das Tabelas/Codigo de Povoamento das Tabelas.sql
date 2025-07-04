--================================================================================--
-- 				SCRIPT DE POVOAMENTO MASSIVO DE DADOS
--================================================================================--
-- 	Este script insere uma grande quantidade de dados em todas as tabelas
-- 	para simular um ambiente de produção e permitir testes completos.
--================================================================================--

--================================================================================--
-- 				1. LIMPEZA DOS DADOS EXISTENTES (PARA REEXECUTAR O SCRIPT)
--================================================================================--
-- A ordem é inversa à da criação para respeitar as chaves estrangeiras.
DELETE FROM ITEM_VENDA;
DELETE FROM VENDA;
DELETE FROM PESSOA_FISICA;
DELETE FROM PESSOA_JURIDICA;
DELETE FROM CLIENTE;
DELETE FROM FUNCIONARIO;
DELETE FROM LOJA_CARRO;
DELETE FROM CARRO;
DELETE FROM LOJA;
DELETE FROM MARCA;
DELETE FROM TIPO;
DELETE FROM COR;


--================================================================================--
-- 				2. POVOAMENTO DAS TABELAS BÁSICAS
--================================================================================--

-- POVOANDO A TABELA COR
INSERT INTO COR (COD_COR, NOME) VALUES
(1, 'Preto'), (2, 'Branco'), (3, 'Prata'), (4, 'Vermelho'),
(5, 'Azul Metálico'), (6, 'Cinza Grafite'), (7, 'Verde Oliva');

-- POVOANDO A TABELA TIPO
INSERT INTO TIPO (COD_TIPO, NOME) VALUES
(1, 'Hatch'), (2, 'SUV'), (3, 'Sedan'), (4, 'Picape'), (5, 'Esportivo');

-- POVOANDO A TABELA MARCA
INSERT INTO MARCA (COD_MARCA, NOME) VALUES
(1, 'Toyota'), (2, 'Chevrolet'), (3, 'Ford'), (4, 'Volkswagen'),
(5, 'Hyundai'), (6, 'Fiat'), (7, 'Honda'), (8, 'BMW');

-- POVOANDO A TABELA LOJA
INSERT INTO LOJA (COD_LOJA, NOME) VALUES
(1, 'Matriz Teresina'), (2, 'Filial Parnaíba'), (3, 'Filial Picos'), (4, 'Filial Floriano');


--================================================================================--
-- 				3. POVOAMENTO DAS TABELAS DE RELACIONAMENTO E ENTIDADES PRINCIPAIS
--================================================================================--

-- POVOANDO A TABELA CARRO
INSERT INTO CARRO (COD_CARRO, COD_COR, COD_MARCA, COD_TIPO, NOME, PRECO, ANO, QTD_EM_ESTOQUE) VALUES
-- Toyota
(1, 1, 1, 3, 'Corolla XEi', 155000.00, '2024', 20),
(2, 2, 1, 2, 'Hilux SRX', 320000.00, '2023', 15),
(3, 3, 1, 1, 'Yaris XL', 98000.00, '2024', 30),
-- Chevrolet
(4, 4, 2, 1, 'Onix Plus', 95000.00, '2023', 25),
(5, 5, 2, 2, 'Tracker RS', 134000.00, '2024', 18),
(6, 6, 2, 4, 'S10 High Country', 290000.00, '2023', 12),
-- Ford
(7, 1, 3, 4, 'Ranger Limited', 310000.00, '2024', 14),
(8, 2, 3, 2, 'Territory', 210000.00, '2023', 20),
-- Volkswagen
(9, 3, 4, 1, 'Polo Highline', 118000.00, '2024', 40),
(10, 4, 4, 2, 'Nivus', 130000.00, '2023', 35),
(11, 5, 4, 3, 'Virtus Exclusive', 148000.00, '2024', 22),
-- Hyundai
(12, 6, 5, 3, 'HB20S Platinum', 120000.00, '2024', 30),
(13, 1, 5, 2, 'Creta N-Line', 170000.00, '2023', 25),
-- Fiat
(14, 2, 6, 4, 'Toro Volcano', 195000.00, '2024', 28),
(15, 3, 6, 1, 'Pulse Abarth', 150000.00, '2023', 15),
-- Honda
(16, 4, 7, 3, 'City Sedan', 137000.00, '2024', 18),
(17, 5, 7, 2, 'HR-V Touring', 195000.00, '2023', 20),
-- BMW
(18, 1, 8, 5, 'BMW 320i', 322000.00, '2024', 8),
(19, 6, 8, 2, 'BMW X1', 350000.00, '2023', 10);

-- POVOANDO A TABELA LOJA_CARRO (DISTRIBUINDO CARROS NAS LOJAS)
-- Cada loja terá uma seleção de carros
INSERT INTO LOJA_CARRO (COD_LOJA_CARRO, COD_LOJA, COD_CARRO) VALUES
-- Loja 1: Matriz Teresina (Vende de tudo)
(1, 1, 1), (2, 1, 2), (3, 1, 4), (4, 1, 5), (5, 1, 7), (6, 1, 9), (7, 1, 10), (8, 1, 12), (9, 1, 14), (10, 1, 18), (11, 1, 19),
-- Loja 2: Filial Parnaíba (Foco em Picapes e SUVs)
(12, 2, 2), (13, 2, 5), (14, 2, 6), (15, 2, 7), (16, 2, 8), (17, 2, 10), (18, 2, 14), (19, 2, 17),
-- Loja 3: Filial Picos (Foco em Hatch e Sedan)
(20, 3, 1), (21, 3, 3), (22, 3, 4), (23, 3, 9), (24, 3, 11), (25, 3, 12), (26, 3, 15), (27, 3, 16),
-- Loja 4: Filial Floriano (Misto popular)
(28, 4, 3), (29, 4, 4), (30, 4, 9), (31, 4, 10), (32, 4, 12), (33, 4, 13), (34, 4, 14);

-- POVOANDO A TABELA FUNCIONARIO
INSERT INTO FUNCIONARIO (COD_FUNCIONARIO, NOME, DT_NASCIMENTO, SALARIO, META_MENSAL, QTD_VENDIDA_NO_MES, COD_LOJA) VALUES
-- Loja 1
(1, 'Carlos Alberto Silva', '1985-03-15', 4500.00, 500000.00, 0, 1),
(2, 'Ana Beatriz Costa', '1992-07-20', 4200.00, 450000.00, 0, 1),
(3, 'João Pedro Martins', '1995-01-10', 3800.00, 400000.00, 0, 1),
-- Loja 2
(4, 'Ricardo Lima Azevedo', '1978-11-05', 4300.00, 480000.00, 0, 2),
(5, 'Mariana Ferreira', '1993-02-25', 4000.00, 420000.00, 0, 2),
-- Loja 3
(6, 'José Ribamar Santos', '1980-09-12', 4100.00, 440000.00, 0, 3),
(7, 'Larissa Mendes', '1998-06-30', 3600.00, 380000.00, 0, 3),
-- Loja 4
(8, 'Francisco das Chagas', '1982-04-18', 4000.00, 410000.00, 0, 4),
(9, 'Antonia de Sousa', '1991-12-08', 3700.00, 390000.00, 0, 4);

-- POVOANDO A TABELA CLIENTE E SEUS TIPOS (PF/PJ)
INSERT INTO CLIENTE (COD_CLIENTE, NOME, DT_NASCIMENTO, QTD_GASTO) VALUES
(1, 'Fernanda Moreira Costa', '1990-01-25', 0), (2, 'Lucas Dias Martins', '1988-06-10', 0),
(3, 'Juliana Pereira Alves', '2000-09-30', 0), (4, 'Marcos Vinicius Barros', '1975-05-14', 0),
(5, 'Beatriz Oliveira Lima', '1995-11-22', 0), (6, 'Rafael Sousa Andrade', '1983-08-01', 0),
(7, 'TecnoSoluções Avançadas Ltda', '2010-04-12', 0), (8, 'Comércio Varejista XYZ EIRELI', '2015-08-01', 0),
(9, 'Serviços Gerais Alfa & Filhos S.A.', '2005-11-20', 0), (10, 'Construtora Rocha Forte', '2002-02-15', 0);

INSERT INTO PESSOA_FISICA (COD_CLIENTE, CPF) VALUES
(1, '111.222.333-44'), (2, '555.666.777-88'), (3, '999.000.111-22'),
(4, '123.456.789-00'), (5, '234.567.890-11'), (6, '345.678.901-22');

INSERT INTO PESSOA_JURIDICA (COD_CLIENTE, CNPJ) VALUES
(7, '11.222.333/0001-44'), (8, '44.555.666/0001-88'), (9, '77.888.999/0001-22'), (10, '10.203.040/0001-50');


--================================================================================--
-- 				4. SIMULAÇÃO DE VENDAS
--================================================================================--
-- As funções e gatilhos irão calcular totais, atualizar estoque, etc.
-- Apenas inserimos os registros de VENDA e ITEM_VENDA.

-- VENDA 1: Cliente 1 compra um Corolla com Vendedor 1 (Loja 1)
INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA) VALUES (1, 1, 1, 0, '2024-01-15');
INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS) VALUES (1, 1, 1, 1); -- Corolla

-- VENDA 2: Cliente 7 (PJ) compra duas Hilux com Vendedor 2 (Loja 1)
INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA) VALUES (2, 2, 7, 0, '2024-01-20');
INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS) VALUES (2, 2, 2, 2); -- 2x Hilux

-- VENDA 3: Cliente 2 compra uma Ranger com Vendedor 4 (Loja 2)
INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA) VALUES (3, 4, 2, 0, '2024-02-10');
INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS) VALUES (3, 3, 15, 1); -- Ranger

-- VENDA 4: Cliente 3 compra um Polo e um Nivus com Vendedor 3 (Loja 1)
INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA) VALUES (4, 3, 3, 0, '2024-02-25');
INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS) VALUES (4, 4, 6, 1); -- Polo
INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS) VALUES (5, 4, 7, 1); -- Nivus

-- VENDA 5: Cliente 10 (PJ) compra 3 S10 com Vendedor 5 (Loja 2)
INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA) VALUES (5, 5, 10, 0, '2024-03-05');
INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS) VALUES (6, 5, 14, 3); -- 3x S10

-- VENDA 6: Cliente 4 compra um HB20S com Vendedor 6 (Loja 3)
INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA) VALUES (6, 6, 4, 0, '2024-03-18');
INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS) VALUES (7, 6, 25, 1); -- HB20S

-- VENDA 7: Cliente 5 compra um Pulse Abarth com Vendedor 7 (Loja 3)
INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA) VALUES (7, 7, 5, 0, '2024-04-02');
INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS) VALUES (8, 7, 26, 1); -- Pulse Abarth

-- VENDA 8: Cliente 6 compra um Onix Plus com Vendedor 8 (Loja 4)
INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA) VALUES (8, 8, 6, 0, '2024-04-20');
INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS) VALUES (9, 8, 29, 1); -- Onix Plus

-- VENDA 9: Cliente 1 (compra de novo) um BMW X1 com Vendedor 1 (Loja 1)
INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA) VALUES (9, 1, 1, 0, '2024-05-10');
INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS) VALUES (10, 9, 11, 1); -- BMW X1

-- VENDA 10: Cliente 9 (PJ) compra 5 Toro com Vendedor 9 (Loja 4)
INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA) VALUES (10, 9, 9, 0, '2024-05-22');
INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS) VALUES (11, 10, 34, 5); -- 5x Toro

-- VENDA 11: Cliente 2 compra um HR-V com Vendedor 5 (Loja 2)
INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA) VALUES (11, 5, 2, 0, '2024-06-01');
INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS) VALUES (12, 11, 19, 1); -- HR-V

-- VENDA 12: Cliente 8 (PJ) compra 4 Yaris com Vendedor 1 (Loja 1)
INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA) VALUES (12, 1, 8, 0, '2024-06-15');
INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS) VALUES (13, 12, 1, 4); -- 4x Yaris (usando o cod_loja_carro do corolla, mas vamos assumir que é o Yaris para o teste)
-- Correção para o exemplo acima: O ideal seria ter um LOJA_CARRO para o Yaris na Loja 1. Vamos adicionar para consistência.
-- Supondo que o Yaris (COD_CARRO=3) também está na Loja 1 com um novo COD_LOJA_CARRO=35
INSERT INTO LOJA_CARRO (COD_LOJA_CARRO, COD_LOJA, COD_CARRO) VALUES (35, 1, 3);
UPDATE ITEM_VENDA SET COD_LOJA_CARRO = 35 WHERE COD_ITEM_VENDA = 13;



