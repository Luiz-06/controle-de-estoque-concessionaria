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

-- 2. Concede as permissões MÍNIMAS e ESSENCIAIS para a role 'funcionario'.
GRANT CONNECT ON DATABASE "concessionaria" TO funcionario; -- << IMPORTANTE: Substitua pelo nome real do seu banco de dados!
GRANT USAGE ON SCHEMA public TO funcionario;

-- 3. Revoga TODAS as permissões de modificação (INSERT, UPDATE, DELETE) em TODAS as tabelas.
--    Esta é a medida de segurança mais importante.
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM funcionario;

-- 4. Concede permissão de SELECT APENAS nas tabelas que o funcionário
--    precisa consultar para realizar seu trabalho.
GRANT SELECT ON TABLE CLIENTE, CARRO, MARCA, COR, TIPO, LOJA, LOJA_CARRO, VENDA, ITEM_VENDA TO funcionario;

-- 5. Concede permissão para EXECUTAR as funções de negócio.
--    O funcionário poderá criar vendas e adicionar itens através destas funções seguras.
GRANT EXECUTE ON FUNCTION fn_realizar_venda(integer, integer) TO funcionario;
GRANT EXECUTE ON FUNCTION fn_inserir_na_venda(integer, integer, integer) TO funcionario;
-- Permissão para consultar relatórios (opcional, mas útil)
GRANT EXECUTE ON FUNCTION fn_detalhes_venda(integer) TO funcionario;
GRANT EXECUTE ON FUNCTION fn_listar_carros_disponiveis_por_loja(integer) TO funcionario;
GRANT EXECUTE ON FUNCTION fn_listar_vendas_por_funcionario(integer) TO funcionario;
GRANT EXECUTE ON FUNCTION fn_historico_compras_cliente(integer) TO funcionario;


-- 6. Cria o usuário de login 'funcionario_user', se ele ainda não existir.
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

-- 7. Associa a role 'funcionario' ao usuário 'funcionario_user'.
GRANT funcionario TO funcionario_user;