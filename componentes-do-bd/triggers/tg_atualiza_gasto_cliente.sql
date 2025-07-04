CREATE OR REPLACE FUNCTION fn_atualiza_gasto_cliente() RETURNS TRIGGER AS $$
BEGIN
	IF TG_OP = 'INSERT' THEN
		UPDATE CLIENTE SET QTD_GASTO = COALESCE(QTD_GASTO, 0) + NEW.VALOR_TOTAL WHERE COD_CLIENTE = NEW.COD_CLIENTE;
	ELSIF TG_OP = 'UPDATE' THEN
		IF OLD.VALOR_TOTAL IS DISTINCT FROM NEW.VALOR_TOTAL OR OLD.COD_CLIENTE IS DISTINCT FROM NEW.COD_CLIENTE THEN
			IF OLD.COD_CLIENTE IS NOT NULL THEN
				UPDATE CLIENTE SET QTD_GASTO = COALESCE(QTD_GASTO, 0) - OLD.VALOR_TOTAL WHERE COD_CLIENTE = OLD.COD_CLIENTE;
			END IF;
			UPDATE CLIENTE SET QTD_GASTO = COALESCE(QTD_GASTO, 0) + NEW.VALOR_TOTAL WHERE COD_CLIENTE = NEW.COD_CLIENTE;
		END IF;
	ELSIF TG_OP = 'DELETE' THEN
		UPDATE CLIENTE SET QTD_GASTO = COALESCE(QTD_GASTO, 0) - OLD.VALOR_TOTAL WHERE COD_CLIENTE = OLD.COD_CLIENTE;
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_atualiza_gasto_cliente AFTER INSERT OR UPDATE OR DELETE ON VENDA
FOR EACH ROW EXECUTE FUNCTION fn_atualiza_gasto_cliente();