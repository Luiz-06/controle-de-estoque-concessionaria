-- Valida o valor da venda ao Cliente

CREATE OR REPLACE FUNCTION fn_atualiza_gasto_cliente()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Adiciona o valor da nova venda ao cliente
        UPDATE CLIENTE
        SET QTD_GASTO = COALESCE(QTD_GASTO, 0) + NEW.VALOR_TOTAL
        WHERE COD_CLIENTE = NEW.COD_CLIENTE;

    ELSIF TG_OP = 'UPDATE' THEN
        -- Se o valor da venda mudou ou o cliente mudou
        IF OLD.VALOR_TOTAL IS DISTINCT FROM NEW.VALOR_TOTAL OR OLD.COD_CLIENTE IS DISTINCT FROM NEW.COD_CLIENTE THEN
            -- Remove o valor antigo do cliente antigo (se houver)
            IF OLD.COD_CLIENTE IS NOT NULL THEN
                UPDATE CLIENTE
                SET QTD_GASTO = COALESCE(QTD_GASTO, 0) - OLD.VALOR_TOTAL
                WHERE COD_CLIENTE = OLD.COD_CLIENTE;
            END IF;

            -- Adiciona o novo valor ao novo cliente
            UPDATE CLIENTE
            SET QTD_GASTO = COALESCE(QTD_GASTO, 0) + NEW.VALOR_TOTAL
            WHERE COD_CLIENTE = NEW.COD_CLIENTE;
        END IF;

    ELSIF TG_OP = 'DELETE' THEN
        -- Subtrai o valor da venda deletada do cliente
        UPDATE CLIENTE
        SET QTD_GASTO = COALESCE(QTD_GASTO, 0) - OLD.VALOR_TOTAL
        WHERE COD_CLIENTE = OLD.COD_CLIENTE;
    END IF;

    RETURN NULL; -- Para triggers AFTER, o valor de retorno é geralmente ignorado
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tg_atualiza_gasto_cliente
AFTER INSERT OR UPDATE OR DELETE ON VENDA
FOR EACH ROW
EXECUTE FUNCTION fn_atualiza_gasto_cliente();

SELECT COD_CLIENTE, NOME, QTD_GASTO FROM CLIENTE WHERE COD_CLIENTE = 1;
-- Suponha que QTD_GASTO seja Xc antes da inserção.

INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA)
VALUES (300, 1, 1, 250.00, CURRENT_DATE);

-- Verificação:
SELECT COD_CLIENTE, NOME, QTD_GASTO FROM CLIENTE WHERE COD_CLIENTE = 1;
-- Espera-se: QTD_GASTO = Xc + 250.00
