CREATE ROLE funcionario;

GRANT CONNECT ON DATABASE c TO funcionario;
GRANT USAGE ON SCHEMA public TO funcionario;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO funcionario;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO funcionario;
REVOKE EXECUTE ON FUNCTION fn_inserir_na_tabela(text, text, text) FROM funcionario;
REVOKE EXECUTE ON FUNCTION fn_atualizar_tabela(text, text, text) FROM funcionario;
REVOKE EXECUTE ON FUNCTION fn_deletar_da_tabela(text, text) FROM funcionario;

DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'funcionario_user') THEN
      CREATE USER funcionario_user WITH LOGIN PASSWORD 'funcionario123';
   END IF;
END
$$;

GRANT funcionario TO funcionario_user;





