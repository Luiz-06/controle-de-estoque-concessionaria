CREATE OR REPLACE FUNCTION realizarVenda(p_cod_cliente INT, p_cod_funcionario INT)
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