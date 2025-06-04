-- Valida se a meta mensal inserida é negativa

CREATE OR REPLACE FUNCTION fn_valida_meta_mensal_funcionario()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.META_MENSAL < 0 THEN
        RAISE EXCEPTION 'A meta mensal (R$ %.2f) do funcionário não pode ser negativa.', NEW.META_MENSAL;
    END IF;
    RETURN NEW; -- Permite a operação se a validação passar
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_valida_meta_mensal_funcionario
BEFORE INSERT OR UPDATE ON FUNCIONARIO
FOR EACH ROW
EXECUTE FUNCTION fn_valida_meta_mensal_funcionario();

INSERT INTO FUNCIONARIO (COD_FUNCIONARIO, NOME, DT_NASCIMENTO, SALARIO, META_MENSAL, QTD_VENDIDA_NO_MES)
VALUES (4, 'Teste Func Negativo', '1990-01-01', 3000.00, -100.00, 0);