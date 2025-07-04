CREATE ROLE funcionario;

GRANT CONNECT ON DATABASE postgres TO funcionario;
GRANT USAGE ON SCHEMA public TO funcionario;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO funcionario;

GRANT EXECUTE ON FUNCTION fn_realizar_venda(integer, integer) TO funcionario;
GRANT EXECUTE ON FUNCTION fn_inserir_na_venda(integer, integer, integer) TO funcionario;