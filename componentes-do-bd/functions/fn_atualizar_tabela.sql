CREATE OR REPLACE FUNCTION fn_atualizar_tabela(p_nome_tabela TEXT, p_atualizacoes TEXT, p_condicao TEXT)
RETURNS VOID AS $$
DECLARE
    comando_sql TEXT;
    rows_affected INT;
BEGIN
    IF p_nome_tabela IS NULL OR p_atualizacoes IS NULL OR p_condicao IS NULL THEN
        RAISE NOTICE 'AVISO: Os parâmetros nome_tabela, atualizacoes e condicao não podem ser nulos.';
        RETURN;
    END IF;

    comando_sql := FORMAT('UPDATE %I SET %s WHERE %s', p_nome_tabela, p_atualizacoes, p_condicao);
    EXECUTE comando_sql;

    GET DIAGNOSTICS rows_affected = ROW_COUNT;
    IF rows_affected > 0 THEN
        RAISE NOTICE 'SUCESSO: % registro(s) na tabela %s foram atualizado(s).', rows_affected, p_nome_tabela;
    ELSE
        RAISE NOTICE 'AVISO: Nenhum registro correspondente à condição foi encontrado na tabela %s.', p_nome_tabela;
    END IF;
EXCEPTION
    WHEN sqlstate '42P01' THEN -- undefined_table
        RAISE NOTICE 'AVISO: A tabela "%" não existe no banco de dados.', p_nome_tabela;
    WHEN sqlstate '42703' THEN -- undefined_column
        RAISE NOTICE 'AVISO: Uma ou mais colunas na atualização não existem na tabela "%".', p_nome_tabela;
    WHEN sqlstate '22P02' THEN -- invalid_text_representation
        RAISE NOTICE 'AVISO: Falha ao atualizar. O formato de um dos valores é incompatível com o tipo da coluna.';
    WHEN OTHERS THEN
        RAISE NOTICE 'AVISO: Ocorreu um erro inesperado ao tentar atualizar a tabela "%". Detalhe: %', p_nome_tabela, SQLERRM;
END;
$$ LANGUAGE plpgsql;