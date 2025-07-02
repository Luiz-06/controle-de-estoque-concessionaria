--================================================================================--
--                         FUNÇÃO PARA REALIZAR UMA VENDA
--================================================================================--

-- Função: Cria um novo registro na tabela VENDA.
-- Recebe o código do cliente e do funcionário como parâmetros.
-- Retorna o código da nova venda criada, que será usado para inserir os itens.
CREATE OR REPLACE FUNCTION realizarVenda(
    p_cod_cliente INT,
    p_cod_funcionario INT
)
RETURNS INT AS $$
DECLARE
    v_nova_venda_id INT;
BEGIN
    -- 1. Gera um novo código para a venda, pegando o maior código existente e somando 1.
    -- A função COALESCE garante que, se a tabela estiver vazia, a contagem começará em 1.
    SELECT COALESCE(MAX(COD_VENDA), 0) + 1 INTO v_nova_venda_id FROM VENDA;

    -- 2. Insere os dados na tabela VENDA.
    --   - O VALOR_TOTAL é inicializado como 0 e será atualizado pelos gatilhos
    --     quando os itens forem adicionados na tabela ITEM_VENDA.
    --   - A DT_VENDA é definida como a data atual do sistema (CURRENT_DATE).
    --   - Os gatilhos existentes (como 'validar_funcionario_cliente_tr' e
    --     'tg_impede_venda_futura') serão acionados automaticamente para validar os dados.
    INSERT INTO VENDA (COD_VENDA, COD_CLIENTE, COD_FUNCIONARIO, VALOR_TOTAL, DT_VENDA)
    VALUES (v_nova_venda_id, p_cod_cliente, p_cod_funcionario, 0, CURRENT_DATE);

    -- 3. Emite um aviso para o usuário informando o sucesso da operação
    -- e o código da venda que foi gerado.
    RAISE NOTICE 'Venda com código % criada com sucesso. Agora, adicione os itens da venda na tabela ITEM_VENDA.', v_nova_venda_id;

    -- 4. Retorna o ID da nova venda para que possa ser utilizado em operações futuras,
    -- como a inserção de itens na venda.
    RETURN v_nova_venda_id;
END;
$$ LANGUAGE plpgsql;
