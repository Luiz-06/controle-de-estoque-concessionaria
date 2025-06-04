-- Valida a data de venda inserida, para negar qualquer data futura a data atual.

CREATE OR REPLACE FUNCTION fn_impede_venda_futura()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.DT_VENDA > CURRENT_DATE THEN
        RAISE EXCEPTION 'Não é permitido registrar vendas com data futura (Data informada: %).', TO_CHAR(NEW.DT_VENDA, 'DD/MM/YYYY');
    END IF;
    RETURN NEW; -- Permite a operação se a data for válida
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_impede_venda_futura
BEFORE INSERT OR UPDATE ON VENDA
FOR EACH ROW
EXECUTE FUNCTION fn_impede_venda_futura();

INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA)
VALUES (100, 1, 1, 500.00, CURRENT_DATE + INTERVAL '1 day');
-- Espera-se: ERRO: Não é permitido registrar vendas com data futura (...)