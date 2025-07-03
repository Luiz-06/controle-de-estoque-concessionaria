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
