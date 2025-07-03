CREATE OR REPLACE FUNCTION deletar_da_tabela(p_nome_tabela TEXT, p_condicao TEXT)
RETURNS VOID AS $$
DECLARE
	comando_sql TEXT;
BEGIN
	comando_sql := FORMAT('DELETE FROM %I WHERE %s', p_nome_tabela, p_condicao);
	RAISE NOTICE 'Tentando executar: %', comando_sql;
	EXECUTE comando_sql;
	RAISE NOTICE 'Registo(s) removido(s) com sucesso da tabela %s.', p_nome_tabela;
EXCEPTION
	WHEN foreign_key_violation THEN
		RAISE EXCEPTION 'ERRO: Não é possível remover o registo da tabela "%", pois ele está a ser utilizado por outra tabela.', p_nome_tabela;
END;
$$ LANGUAGE plpgsql;