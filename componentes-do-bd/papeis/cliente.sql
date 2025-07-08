
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

-- 2. Concede as permissões MÍNIMAS e ESSENCIAIS para a role 'cliente'.
--    - CONNECT: Permite que o usuário se conecte ao banco de dados.
--    - USAGE: Permite que o usuário "veja" e utilize objetos dentro do schema 'public'.
GRANT CONNECT ON DATABASE "concessionaria" TO cliente; -- << IMPORTANTE: Substitua pelo nome real do seu banco de dados!
GRANT USAGE ON SCHEMA public TO cliente;

-- 3. Revoga TODAS as permissões diretas em TODAS as tabelas do schema public.
--    Esta é uma medida de segurança crucial para garantir que o cliente
--    NÃO possa fazer SELECT, INSERT, UPDATE ou DELETE diretamente nas tabelas.
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM cliente;

-- 4. Concede permissão para EXECUTAR apenas as funções necessárias.
--    A segurança interna das funções é garantida pelo 'SECURITY DEFINER',
--    então o cliente só precisa da permissão para chamá-las.
GRANT EXECUTE ON FUNCTION fn_detalhes_venda(integer) TO cliente;
GRANT EXECUTE ON FUNCTION fn_historico_compras_cliente(integer) TO cliente;

-- 5. Cria o usuário de login 'cliente_user', se ele ainda não existir.
--    Este é o usuário que a sua aplicação usará para se conectar ao banco.
DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'cliente_user') THEN
      CREATE USER cliente_user WITH LOGIN PASSWORD 'cliente123';
      RAISE NOTICE 'Usuário "cliente_user" criado com sucesso.';
   ELSE
      RAISE NOTICE 'Usuário "cliente_user" já existe.';
   END IF;
END
$$;

-- 6. Associa a role 'cliente' (com todas as suas permissões) ao usuário 'cliente_user'.
--    Agora, 'cliente_user' herda tudo que foi concedido à role 'cliente'.
GRANT cliente TO cliente_user;




