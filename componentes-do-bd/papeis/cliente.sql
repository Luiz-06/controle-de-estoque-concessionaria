CREATE ROLE cliente;

GRANT CONNECT ON DATABASE "nome-do-seu-bd" TO cliente;
GRANT USAGE ON SCHEMA public TO cliente;

GRANT SELECT ON TABLE CLIENTE TO cliente;
GRANT SELECT ON TABLE VENDA TO cliente;
GRANT SELECT ON TABLE ITEM_VENDA TO cliente;
GRANT SELECT ON TABLE LOJA_CARRO TO cliente;
GRANT SELECT ON TABLE CARRO TO cliente;
GRANT SELECT ON TABLE MARCA TO cliente;
GRANT SELECT ON TABLE FUNCIONARIO TO cliente;
GRANT EXECUTE ON FUNCTION fn_detalhes_venda(integer) TO cliente;
GRANT EXECUTE ON FUNCTION fn_historico_compras_cliente(integer) TO cliente;

DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'cliente_user') THEN
      CREATE USER cliente_user WITH LOGIN PASSWORD 'cliente123';
   END IF;
END
$$;

GRANT cliente TO cliente_user;