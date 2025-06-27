CREATE OR REPLACE FUNCTION validar_funcionario_cliente() 
RETURNS TRIGGER AS 
$$
DECLARE
    existe_funcionario BOOLEAN;
    existe_cliente BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT * FROM FUNCIONARIO 
        WHERE COD_FUNCIONARIO = NEW.COD_FUNCIONARIO
    ) INTO existe_funcionario;

    IF NOT existe_funcionario THEN
        RAISE EXCEPTION 'Funcionário com código % não existe.', NEW.COD_FUNCIONARIO;
    END IF;

    SELECT EXISTS (
        SELECT * FROM CLIENTE 
        WHERE COD_CLIENTE = NEW.COD_CLIENTE
    ) INTO existe_cliente;

    IF NOT existe_cliente THEN
        RAISE EXCEPTION 'Cliente com código % não existe.', NEW.COD_CLIENTE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER VALIDAR_FUNCIONARIO_CLIENTE_TR 
AFTER INSERT OR UPDATE ON VENDA 
FOR EACH ROW EXECUTE FUNCTION validar_funcionario_cliente()

