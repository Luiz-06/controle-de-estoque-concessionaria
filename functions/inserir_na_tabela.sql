CREATE OR REPLACE FUNCTION inserir_na_tabela(
    nome_tabela TEXT,
    colunas TEXT,
    valores TEXT
)
RETURNS VOID AS $$
DECLARE
    comando_sql TEXT;
BEGIN
    comando_sql := FORMAT('INSERT INTO %s (%s) VALUES (%s)', nome_tabela, colunas, valores);

    EXECUTE comando_sql;

    RAISE NOTICE 'Comando executado: %', comando_sql;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_na_tabela(
    'FUNCIONARIO',
    'COD_FUNCIONARIO, NOME, DT_NASCIMENTO, SALARIO, META_MENSAL, QTD_VENDIDA_NO_MES, COD_LOJA_CARRO',
    '5, ''XICAO DOS TECLADOS'', ''2005-06-01'', 2, 100, 0, 3'
);