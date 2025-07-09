DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'cliente') THEN
      CREATE ROLE cliente;
      RAISE NOTICE 'Role "cliente" criada com sucesso.';
   ELSE
      RAISE NOTICE 'Role "cliente" já existe.';
   END IF;
END
$$;

GRANT CONNECT ON DATABASE "nome_do_seu_bd" TO cliente;
GRANT USAGE ON SCHEMA public TO cliente;

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM cliente;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM cliente; 

REVOKE EXECUTE ON FUNCTION fn_realizar_venda(integer, integer) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION fn_inserir_na_venda(integer, integer, integer) FROM PUBLIC;

GRANT EXECUTE ON FUNCTION fn_detalhes_venda(integer) TO cliente;
GRANT EXECUTE ON FUNCTION fn_historico_compras_cliente(integer) TO cliente;

DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'cliente_user') THEN
      CREATE USER cliente_user WITH LOGIN PASSWORD 'cliente123';
      RAISE NOTICE 'Usuário "cliente_user" criado com sucesso.';
   ELSE
      RAISE NOTICE 'Usuário "cliente_user" já existe.';
   END IF;
END;
$$;

GRANT cliente TO cliente_user;

