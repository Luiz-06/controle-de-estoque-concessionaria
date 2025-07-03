CREATE OR REPLACE FUNCTION fn_impede_venda_futura() RETURNS TRIGGER AS $$
BEGIN
	IF NEW.DT_VENDA > CURRENT_DATE THEN
		RAISE EXCEPTION 'Não é permitido registrar vendas com data futura (Data informada: %).', TO_CHAR(NEW.DT_VENDA, 'DD/MM/YYYY');
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_impede_venda_futura BEFORE INSERT OR UPDATE ON VENDA
FOR EACH ROW EXECUTE FUNCTION fn_impede_venda_futura();