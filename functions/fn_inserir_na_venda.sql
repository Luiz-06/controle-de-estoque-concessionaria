CREATE OR REPLACE FUNCTION fn_inserir_na_venda(p_cod_venda INT, p_cod_loja_carro INT, p_qtd_de_itens INT)
RETURNS VOID AS $$
DECLARE
    v_novo_item_venda_id INT;
    v_estoque_atual INT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM VENDA WHERE VENDA.COD_VENDA = p_cod_venda) THEN
        RAISE NOTICE 'AVISO: A venda com o código % não foi encontrada. Impossível adicionar o item.', p_cod_venda;
        RETURN;
    END IF;

    IF p_qtd_de_itens <= 0 THEN
        RAISE NOTICE 'AVISO: A quantidade de itens para venda (%) deve ser um número positivo maior que zero.', p_qtd_de_itens;
        RETURN;
    END IF;

    SELECT C.QTD_EM_ESTOQUE INTO v_estoque_atual FROM CARRO C JOIN LOJA_CARRO LC ON C.COD_CARRO = LC.COD_CARRO WHERE LC.COD_LOJA_CARRO = p_cod_loja_carro;
    IF NOT FOUND THEN
        RAISE NOTICE 'AVISO: O item de loja/carro com código % não existe.', p_cod_loja_carro;
        RETURN;
    END IF;

    IF p_qtd_de_itens > v_estoque_atual THEN
		RAISE NOTICE 'AVISO: Quantidade solicitada (%) maior que o estoque disponível (%).', p_qtd_de_itens, v_estoque_atual;
		RETURN;
    END IF;

    SELECT COALESCE(MAX(COD_ITEM_VENDA), 0) + 1 INTO v_novo_item_venda_id FROM ITEM_VENDA;
    INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS)
    VALUES (v_novo_item_venda_id, p_cod_venda, p_cod_loja_carro, p_qtd_de_itens);
    RAISE NOTICE 'SUCESSO: Item (COD_LOJA_CARRO: %) adicionado à venda de código %.', p_cod_loja_carro, p_cod_venda;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'AVISO: Ocorreu um erro inesperado ao adicionar item à venda. Detalhe: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;