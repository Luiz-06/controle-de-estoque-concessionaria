CREATE OR REPLACE FUNCTION fn_valida_meta_mensal_funcionario() RETURNS TRIGGER AS $$
BEGIN
	IF NEW.META_MENSAL < 0 THEN
		RAISE EXCEPTION 'A meta mensal (R$ %.2f) do funcionário não pode ser negativa.', NEW.META_MENSAL;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_valida_meta_mensal_funcionario BEFORE INSERT OR UPDATE ON FUNCIONARIO
FOR EACH ROW EXECUTE FUNCTION fn_valida_meta_mensal_funcionario();