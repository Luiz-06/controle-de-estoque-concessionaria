CREATE OR REPLACE FUNCTION fn_listar_carros_disponiveis_por_loja(p_cod_loja INT)
RETURNS TABLE (nome_carro VARCHAR, nome_marca VARCHAR, nome_tipo VARCHAR, nome_cor VARCHAR, ano_carro VARCHAR, preco_carro FLOAT, qtd_em_estoque INT) AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM LOJA WHERE COD_LOJA = p_cod_loja) THEN
        RAISE NOTICE 'AVISO: A loja com o código % não foi encontrada.', p_cod_loja;
        RETURN;
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