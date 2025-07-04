CREATE OR REPLACE FUNCTION fn_inserir_na_tabela(nome_tabela TEXT, colunas TEXT, valores TEXT)
RETURNS VOID AS $$
DECLARE
    comando_sql TEXT;
BEGIN
    comando_sql := FORMAT('INSERT INTO %I (%s) VALUES (%s)', nome_tabela, colunas, valores);
    EXECUTE comando_sql;
    RAISE NOTICE 'SUCESSO: Registro inserido na tabela %I.', nome_tabela;
EXCEPTION
    WHEN sqlstate '42P01' THEN -- undefined_table
        RAISE NOTICE 'AVISO: A tabela "%" não existe no banco de dados.', nome_tabela;
    WHEN sqlstate '42703' THEN -- undefined_column
        RAISE NOTICE 'AVISO: Uma ou mais colunas especificadas (%) não existem na tabela "%".', colunas, nome_tabela;
    WHEN sqlstate '23505' THEN -- unique_violation
        RAISE NOTICE 'AVISO: Falha ao inserir. Um dos valores já existe e viola uma restrição de chave única (ex: código duplicado).';
    WHEN sqlstate '22P02' THEN -- invalid_text_representation
        RAISE NOTICE 'AVISO: Falha ao inserir. O formato de um dos valores é incompatível com o tipo da coluna (ex: texto em um campo de número).';
    WHEN OTHERS THEN
        RAISE NOTICE 'AVISO: Ocorreu um erro inesperado ao tentar inserir na tabela "%". Detalhe: %', nome_tabela, SQLERRM;
END;
$$ LANGUAGE plpgsql;