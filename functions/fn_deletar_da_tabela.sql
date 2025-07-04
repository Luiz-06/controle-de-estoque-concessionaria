CREATE OR REPLACE FUNCTION fn_deletar_da_tabela(p_nome_tabela TEXT, p_condicao TEXT)
RETURNS VOID AS $$
DECLARE
    comando_sql TEXT;
    rows_affected INT;
BEGIN
    comando_sql := FORMAT('DELETE FROM %I WHERE %s', p_nome_tabela, p_condicao);
    EXECUTE comando_sql;
    
    GET DIAGNOSTICS rows_affected = ROW_COUNT;
    IF rows_affected > 0 THEN
        RAISE NOTICE 'SUCESSO: % registro(s) removido(s) da tabela %s.', rows_affected, p_nome_tabela;
    ELSE
        RAISE NOTICE 'AVISO: Nenhum registro correspondia à condição na tabela %s. Nada foi deletado.', p_nome_tabela;
    END IF;
EXCEPTION
    WHEN sqlstate '42P01' THEN -- undefined_table
        RAISE NOTICE 'AVISO: A tabela "%" não existe no banco de dados.', p_nome_tabela;
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'AVISO: Não é possível remover o registro, pois ele está sendo usado por outra tabela.';
    WHEN OTHERS THEN
        RAISE NOTICE 'AVISO: Ocorreu um erro inesperado ao tentar deletar da tabela "%". Detalhe: %', p_nome_tabela, SQLERRM;
END;
$$ LANGUAGE plpgsql;