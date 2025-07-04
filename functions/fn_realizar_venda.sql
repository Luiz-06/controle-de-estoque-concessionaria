CREATE OR REPLACE FUNCTION fn_realizar_venda(p_cod_cliente INT, p_cod_funcionario INT)
RETURNS INT AS $$
DECLARE
    v_nova_venda_id INT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM CLIENTE WHERE COD_CLIENTE = p_cod_cliente) THEN
        RAISE NOTICE 'AVISO: Não foi possível criar a venda. O cliente com código % não existe.', p_cod_cliente;
        RETURN NULL;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM FUNCIONARIO WHERE COD_FUNCIONARIO = p_cod_funcionario) THEN
        RAISE NOTICE 'AVISO: Não foi possível criar a venda. O funcionário com código % não existe.', p_cod_funcionario;
        RETURN NULL;
    END IF;

    SELECT COALESCE(MAX(COD_VENDA), 0) + 1 INTO v_nova_venda_id FROM VENDA;
    INSERT INTO VENDA (COD_VENDA, COD_CLIENTE, COD_FUNCIONARIO, VALOR_TOTAL, DT_VENDA)
    VALUES (v_nova_venda_id, p_cod_cliente, p_cod_funcionario, 0, CURRENT_DATE);
    
    RAISE NOTICE 'SUCESSO: Venda com código % criada para o cliente %.', v_nova_venda_id, p_cod_cliente;
    RETURN v_nova_venda_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'AVISO: Ocorreu um erro inesperado ao criar a venda. Detalhe: %', SQLERRM;
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;