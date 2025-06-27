CREATE OR REPLACE FUNCTION loja_campea_de_vendas(
    p_mes INT, 
    p_ano INT
)
RETURNS TABLE (nome_loja VARCHAR, total_vendido FLOAT) AS $$
BEGIN
    IF p_mes IS NULL OR p_mes NOT BETWEEN 1 AND 12 THEN
        RAISE EXCEPTION 'Mês inválido. Forneça um valor entre 1 e 12.';
    END IF;

    IF p_ano IS NULL OR p_ano < 1900 THEN
        RAISE EXCEPTION 'Ano inválido. Forneça um ano válido.';
    END IF;

    RETURN QUERY
    SELECT
        L.NOME,
        SUM(V.VALOR_TOTAL) AS "Total Vendido"
    FROM VENDA AS V
    JOIN FUNCIONARIO AS F ON V.COD_FUNCIONARIO = F.COD_FUNCIONARIO
    JOIN LOJA_CARRO AS LC ON F.COD_LOJA_CARRO = LC.COD_LOJA_CARRO
    JOIN LOJA AS L ON LC.COD_LOJA = L.COD_LOJA
    WHERE
        EXTRACT(MONTH FROM V.DT_VENDA) = p_mes
        AND EXTRACT(YEAR FROM V.DT_VENDA) = p_ano
    GROUP BY
        L.NOME
    ORDER BY
        "Total Vendido" DESC
    LIMIT 1; 

END;
$$ LANGUAGE plpgsql;
