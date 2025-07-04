CREATE OR REPLACE FUNCTION fn_loja_campea_de_vendas(p_mes INT, p_ano INT)
RETURNS TABLE (nome_loja VARCHAR, total_vendido FLOAT) AS $$
BEGIN
    IF p_mes IS NULL OR p_mes NOT BETWEEN 1 AND 12 THEN
        RAISE NOTICE 'AVISO: Mês inválido. Forneça um valor entre 1 e 12.';
        RETURN;
    END IF;
    IF p_ano IS NULL OR p_ano < 1900 THEN
        RAISE NOTICE 'AVISO: Ano inválido. Forneça um ano válido.';
        RETURN;
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