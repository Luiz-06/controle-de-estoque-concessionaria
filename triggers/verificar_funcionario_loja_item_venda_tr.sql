CREATE OR REPLACE FUNCTION verificar_funcionario_loja_item_venda() RETURNS TRIGGER AS $$
DECLARE
	v_cod_loja_funcionario INT;
	v_cod_loja_carro INT;
	v_cod_funcionario INT;
BEGIN
	SELECT V.COD_FUNCIONARIO INTO v_cod_funcionario FROM VENDA AS V WHERE V.COD_VENDA = NEW.COD_VENDA;
	IF v_cod_funcionario IS NULL THEN
		RETURN NEW;
	END IF;
	SELECT F.COD_LOJA INTO v_cod_loja_funcionario FROM FUNCIONARIO AS F WHERE F.COD_FUNCIONARIO = v_cod_funcionario;
	SELECT LC.COD_LOJA INTO v_cod_loja_carro FROM LOJA_CARRO AS LC WHERE LC.COD_LOJA_CARRO = NEW.COD_LOJA_CARRO;

	IF v_cod_loja_funcionario <> v_cod_loja_carro THEN
		RAISE EXCEPTION 'O funcionário (da loja %) só pode vender carros da sua própria loja (tentativa de vender da loja %).', v_cod_loja_funcionario, v_cod_loja_carro;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verificar_funcionario_loja_item_venda_tr BEFORE INSERT OR UPDATE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION verificar_funcionario_loja_item_venda();