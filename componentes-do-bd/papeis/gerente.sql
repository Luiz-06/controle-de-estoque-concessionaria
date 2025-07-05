CREATE ROLE gerente;

GRANT CONNECT ON DATABASE "nome_do_seu_bd" TO gerente; 
GRANT USAGE ON SCHEMA public TO gerente;

GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO gerente;

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO gerente;
REVOKE EXECUTE ON FUNCTION fn_deletar_da_tabela(text, text) FROM gerente;

INSERT INTO FUNCIONARIO (COD_FUNCIONARIO, NOME, DT_NASCIMENTO, SALARIO, META_MENSAL, QTD_VENDIDA_NO_MES, COD_LOJA)
VALUES (10, 'Roberto o gerente', '1980-05-20', 10000.00, 600000.00, 0, 1);

DO $$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'gerente_user') THEN
      CREATE USER gerente_user WITH LOGIN PASSWORD 'gerente123';
   END IF;
END
$$;

GRANT gerente TO gerente_user;




