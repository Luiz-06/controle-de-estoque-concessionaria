CREATE OR REPLACE FUNCTION deletar_da_tabela(
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