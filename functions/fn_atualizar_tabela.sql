CREATE OR REPLACE FUNCTION fn_atualizar_tabela(p_nome_tabela TEXT, p_atualizacoes TEXT, p_condicao TEXT)
RETURNS VOID AS $$
DECLARE
    comando_sql TEXT;
BEGIN
    IF p_nome_tabela IS NULL OR p_atualizacoes IS NULL OR p_condicao IS NULL THEN
        RAISE EXCEPTION 'ERRO: Nome da tabela, atualizações e condição não podem ser nulos.';
    END IF;
    comando_sql := FORMAT('UPDATE %I SET %s WHERE %s', p_nome_tabela, p_atualizacoes, p_condicao);
    RAISE NOTICE 'Executando comando: %', comando_sql;
    EXECUTE comando_sql;
    IF FOUND THEN
        RAISE NOTICE 'Registro(s) na tabela %s atualizado(s) com sucesso.', p_nome_tabela;
    ELSE
        RAISE NOTICE 'Nenhum registro correspondente à condição foi encontrado na tabela %s.', p_nome_tabela;
    END IF;
END;
$$ LANGUAGE plpgsql;