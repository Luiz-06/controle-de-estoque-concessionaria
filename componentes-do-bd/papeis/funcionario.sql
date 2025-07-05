CREATE ROLE funcionario;

GRANT CONNECT ON DATABASE "nome_do_seu_bd" TO funcionario; 
GRANT USAGE ON SCHEMA public TO funcionario;

GRANT SELECT ON
   CARRO,
   CLIENTE,
   COR,
   ITEM_VENDA,
   LOJA,
   LOJA_CARRO,
   MARCA,
   PESSOA_FISICA,
   PESSOA_JURIDICA,
   TIPO,
   VENDA
TO funcionario;

GRANT EXECUTE ON FUNCTION fn_realizar_venda(integer, integer) TO funcionario;
GRANT EXECUTE ON FUNCTION fn_inserir_na_venda(integer, integer, integer) TO funcionario;

DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'funcionario_user') THEN
      CREATE USER funcionario_user WITH LOGIN PASSWORD 'funcionario123';
   END IF;
END
$$;

GRANT funcionario TO funcionario_user;
