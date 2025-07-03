-- DESCRIÇÃO: Retorna o(s) funcionário(s) com o maior valor total de vendas
--            registrado na coluna 'QTD_VENDIDA_NO_MES'. Lida com empates.
CREATE OR REPLACE FUNCTION fn_funcionario_campeao_de_vendas()
RETURNS TABLE (
    nome_funcionario VARCHAR,
    total_vendido_no_mes FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        F.NOME,
        F.QTD_VENDIDA_NO_MES
    FROM
        FUNCIONARIO AS F
    WHERE
        F.QTD_VENDIDA_NO_MES = (SELECT MAX(QTD_VENDIDA_NO_MES) FROM FUNCIONARIO);
END;
$$ LANGUAGE plpgsql;