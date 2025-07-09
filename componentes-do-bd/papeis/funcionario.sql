DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'funcionario') THEN
      CREATE ROLE funcionario;
      RAISE NOTICE 'Role "funcionario" criada com sucesso.';
   ELSE
      RAISE NOTICE 'Role "funcionario" já existe.';
   END IF;
END
$$;

GRANT CONNECT ON DATABASE "concessionaria" TO funcionario; 
GRANT USAGE ON SCHEMA public TO funcionario;

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM funcionario;

GRANT SELECT ON TABLE CLIENTE, CARRO, MARCA, COR, TIPO, LOJA, LOJA_CARRO, VENDA, ITEM_VENDA TO funcionario;

GRANT EXECUTE ON FUNCTION fn_realizar_venda(integer, integer) TO funcionario;
GRANT EXECUTE ON FUNCTION fn_inserir_na_venda(integer, integer, integer) TO funcionario;
GRANT EXECUTE ON FUNCTION fn_detalhes_venda(integer) TO funcionario;
GRANT EXECUTE ON FUNCTION fn_listar_carros_disponiveis_por_loja(integer) TO funcionario;
GRANT EXECUTE ON FUNCTION fn_listar_vendas_por_funcionario(integer) TO funcionario;
GRANT EXECUTE ON FUNCTION fn_historico_compras_cliente(integer) TO funcionario;

DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'funcionario_user') THEN
      CREATE USER funcionario_user WITH LOGIN PASSWORD 'funcionario123';
      RAISE NOTICE 'Usuário "funcionario_user" criado com sucesso.';
   ELSE
      RAISE NOTICE 'Usuário "funcionario_user" já existe.';
   END IF;
END
$$;

GRANT funcionario TO funcionario_user;