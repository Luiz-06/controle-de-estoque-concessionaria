CREATE OR REPLACE FUNCTION fn_inserir_na_tabela(nome_tabela TEXT, colunas TEXT, valores TEXT)
RETURNS VOID AS $$
DECLARE
	comando_sql TEXT;
BEGIN
	comando_sql := FORMAT('INSERT INTO %I (%s) VALUES (%s)', nome_tabela, colunas, valores);
	EXECUTE comando_sql;
	RAISE NOTICE 'Comando executado: %', comando_sql;
END;
$$ LANGUAGE plpgsql;
