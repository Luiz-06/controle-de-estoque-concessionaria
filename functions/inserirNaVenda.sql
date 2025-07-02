-- Função: Adiciona um item (carro) a uma venda existente.
CREATE OR REPLACE FUNCTION inserirNaVenda(
    p_cod_venda INT,
    p_cod_loja_carro INT,
    p_qtd_de_itens INT
)
RETURNS VOID AS $$
DECLARE
    v_novo_item_venda_id INT;
BEGIN
    SELECT COALESCE(MAX(COD_ITEM_VENDA), 0) + 1 INTO v_novo_item_venda_id FROM ITEM_VENDA;

    INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS)
    VALUES (v_novo_item_venda_id, p_cod_venda, p_cod_loja_carro, p_qtd_de_itens);

    RAISE NOTICE 'Item (COD_LOJA_CARRO: %) adicionado com sucesso à venda de código %.', p_cod_loja_carro, p_cod_venda;

END;
$$ LANGUAGE plpgsql;