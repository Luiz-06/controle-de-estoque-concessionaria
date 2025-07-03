CREATE OR REPLACE FUNCTION fn_atualizar_preco_carro(p_cod_carro INT, p_novo_preco FLOAT)
RETURNS VOID AS $$
DECLARE
	v_carro_existe INT;
BEGIN
	IF p_novo_preco <= 0 THEN
		RAISE EXCEPTION 'O novo preço (R$ %.2f) deve ser um valor positivo.', p_novo_preco;
	END IF;
	SELECT COUNT(*) INTO v_carro_existe FROM CARRO WHERE COD_CARRO = p_cod_carro;
	IF v_carro_existe = 0 THEN
		RAISE EXCEPTION 'O carro com código % não foi encontrado.', p_cod_carro;
	END IF;
	UPDATE CARRO SET PRECO = p_novo_preco WHERE COD_CARRO = p_cod_carro;
	RAISE NOTICE 'Preço do carro % atualizado para R$ %.2f com sucesso.', p_cod_carro, p_novo_preco;
END;
$$ LANGUAGE plpgsql;