SELECT fn_inserir_na_tabela('cor', 'cod_cor, nome', '4, ''AZUL''');
SELECT * FROM COR

SELECT fn_atualizar_tabela('carro', 'preco = 152000.00', 'cod_carro = 1');
SELECT * FROM CARRO

SELECT fn_deletar_da_tabela('cor', 'cod_cor = 4');
SELECT * FROM COR

SELECT fn_realizar_venda(1, 1);
SELECT * FROM VENDA

SELECT fn_inserir_na_venda(1, 1, 1);
SELECT * FROM ITEM_VENDA

SELECT * FROM fn_detalhes_venda(1);

SELECT * FROM fn_cliente_maior_gasto();

SELECT * FROM fn_funcionario_campeao_de_vendas();

SELECT * FROM fn_loja_campea_de_vendas(7, 2025);

SELECT * FROM fn_total_vendido_por_loja();

SELECT * FROM fn_listar_carros_disponiveis_por_loja(1);

SELECT * FROM fn_listar_vendas_por_funcionario(1);

SELECT * FROM fn_historico_compras_cliente(1);

SELECT * FROM fn_listar_funcionarios_abaixo_meta();



