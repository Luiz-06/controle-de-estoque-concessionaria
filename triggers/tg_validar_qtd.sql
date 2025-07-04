CREATE OR REPLACE FUNCTION fn_validar_qtd() RETURNS TRIGGER AS $$
DECLARE
	qtd_presente_no_estoque INT;
BEGIN
	SELECT C.QTD_EM_ESTOQUE INTO qtd_presente_no_estoque FROM CARRO AS C JOIN LOJA_CARRO AS LC ON LC.COD_CARRO = C.COD_CARRO WHERE LC.COD_LOJA_CARRO = NEW.COD_LOJA_CARRO;
	IF NEW.QTD_DE_ITENS > qtd_presente_no_estoque THEN
		RAISE EXCEPTION 'Quantidade de itens (%), maior que a presente no estoque (%)', NEW.QTD_DE_ITENS, qtd_presente_no_estoque;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_validar_qtd BEFORE INSERT OR UPDATE ON ITEM_VENDA
FOR EACH ROW EXECUTE FUNCTION fn_validar_qtd();