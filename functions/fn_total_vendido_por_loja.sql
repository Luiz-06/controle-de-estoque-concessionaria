-- DESCRIÇÃO: Calcula e lista o total vendido por TODAS as lojas, mostrando 0
--            para aquelas que não tiveram vendas.
CREATE OR REPLACE FUNCTION fn_total_vendido_por_loja()
RETURNS TABLE (
    nome_da_loja VARCHAR,
    valor_total_vendido FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        L.NOME,
        -- Usamos COALESCE para transformar o resultado NULL (de lojas sem vendas) em 0
        COALESCE(SUM(V.VALOR_TOTAL), 0) AS total_vendido
    FROM
        LOJA AS L -- 1. Começamos pela tabela LOJA para garantir que todas apareçam
    LEFT JOIN
        FUNCIONARIO AS F ON L.COD_LOJA = F.COD_LOJA -- 2. Usamos LEFT JOIN
    LEFT JOIN
        VENDA AS V ON F.COD_FUNCIONARIO = V.COD_FUNCIONARIO -- 3. Usamos LEFT JOIN novamente
    GROUP BY
        L.NOME
    ORDER BY
        total_vendido DESC;
END;
$$ LANGUAGE plpgsql;