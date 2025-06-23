CREATE OR REPLACE FUNCTION deletar_de_tabela(
    nome_tabela TEXT,
    condicao TEXT
)
RETURNS VOID AS $$
DECLARE
    comando_sql TEXT;
BEGIN
    comando_sql := FORMAT('DELETE FROM %s WHERE %s', nome_tabela, condicao);

    EXECUTE comando_sql;

    RAISE NOTICE 'Comando executado: %', comando_sql;
END;
$$ LANGUAGE plpgsql;

SELECT inserir_na_tabela(
    'FUNCIONARIO',
    'COD_FUNCIONARIO, NOME, DT_NASCIMENTO, SALARIO, META_MENSAL, QTD_VENDIDA_NO_MES, COD_LOJA_CARRO',
    '4, ''XICAO DOS TECLADOS'', ''2005-06-01'', 2, 100, 0, 3'
);

select * from funcionario

SELECT deletar_da_tabela(
	'FUNCIONARIO',
	'COD_FUNCIONARIO = 4'
);

select * from funcionario