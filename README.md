# 🚗 Sistema de Gestão para Concessionária (PostgreSQL)

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)

Este repositório contém um script SQL completo para a criação e gerenciamento de um banco de dados de uma rede de concessionárias de veículos. O projeto foi desenvolvido em **PostgreSQL** e utiliza recursos avançados como **Triggers** e **Functions** para automatizar processos e garantir a integridade dos dados, simulando um ambiente de sistema de gestão robusto.

## 📘 Sobre o Projeto

O objetivo deste projeto é estruturar um banco de dados relacional que modele as operações de uma concessionária, incluindo:

* **Gestão de Múltiplas Lojas:** Controle de diferentes filiais da rede.
* **Controle de Inventário:** Gerenciamento detalhado do estoque de veículos, com alocação por loja.
* **Vendas e Faturamento:** Registro de transações, clientes e performance dos vendedores.
* **Recursos Humanos:** Cadastro de funcionários, com controle de salários e metas de vendas.

Uma regra de negócio central implementada é a restrição de que **um funcionário só pode vender carros alocados na sua própria loja**, garantindo o realismo da operação.

## ✨ Funcionalidades e Regras de Negócio

O sistema é automatizado através de um conjunto de **Triggers (Gatilhos)** e **Functions (Funções)** que garantem a consistência dos dados:

### Automações Principais (Triggers)
- **`tg_total_da_venda`**: Atualiza automaticamente o valor total de uma venda e ajusta o estoque do carro sempre que um item é adicionado, alterado ou removido.
- **`tg_atualiza_qtd_vendida_funcionario`**: Calcula e atualiza em tempo real o total vendido por cada funcionário no mês.
- **`tg_atualiza_gasto_cliente`**: Mantém um registro do valor total gasto por cada cliente na concessionária.
- **`tg_verificar_funcionario_loja_item_venda`**: Garante que um funcionário não possa vender um carro de outra filial.
- **`tg_validar_qtd`**: Impede a venda de mais carros do que o disponível em estoque.
- **`tg_impede_venda_futura`**: Bloqueia o registro de vendas com data futura para manter a consistência temporal.
- **`tg_checa_meta`**: Emite um aviso (NOTICE) quando um funcionário atinge sua meta de vendas.

### Operações e Relatórios (Functions)
O banco de dados possui funções prontas para realizar operações e extrair relatórios importantes:
- **`fn_realizar_venda()`**: Inicia uma nova transação de venda.
- **`fn_inserir_na_venda()`**: Adiciona itens a uma venda existente.
- **`fn_detalhes_venda()`**: Gera um recibo detalhado de uma venda específica.
- **`fn_listar_carros_disponiveis_por_loja()`**: Mostra o inventário de uma filial.
- **`fn_funcionario_campeao_de_vendas()`**: Retorna o vendedor com melhor performance no mês.
- **`fn_cliente_maior_gasto()`**: Identifica o cliente que mais investiu.
- E muitas outras...

## 🔧 Estrutura do Banco de Dados

O banco de dados é composto por 12 tabelas interligadas:

1.  **Tabelas de Catálogo:**
    - `COR`
    - `MARCA`
    - `TIPO`
    - `LOJA`
2.  **Tabelas Principais (Entidades):**
    - `CARRO`
    - `FUNCIONARIO`
    - `CLIENTE` (com especializações `PESSOA_FISICA` e `PESSOA_JURIDICA`)
3.  **Tabelas de Transação e Ligação:**
    - `LOJA_CARRO` (Associa carros às lojas)
    - `VENDA`
    - `ITEM_VENDA`

## 🚀 Como Utilizar

Para configurar e rodar este banco de dados, siga os passos abaixo:

1.  **Pré-requisito:** Tenha um servidor **PostgreSQL** instalado e em execução.
2.  **Clone o Repositório:**
    ```bash
    git clone [https://github.com/Luiz-06/controle-de-estoque-concessionaria.git](https://github.com/Luiz-06/controle-de-estoque-concessionaria.git)
    ```
3.  **Crie o Banco de Dados:** Use um cliente SQL (como pgAdmin ou DBeaver) para criar um novo banco de dados.
    ```sql
    CREATE DATABASE concessionaria;
    ```
4.  **Execute o Script:** Abra o arquivo `script-final.sql` no seu cliente SQL, conecte-se ao banco de dados recém-criado e execute o script por completo.

Isso criará todas as tabelas, funções, gatilhos e inserirá os dados de exemplo, deixando o banco de dados pronto para uso.

## 👥 Colaboradores

Este projeto foi desenvolvido em colaboração:

| [<img src="https://avatars.githubusercontent.com/u/89664539?v=4" width=115><br><sub>Luiz Felipe</sub>](https://github.com/Luiz-06) | [<img src="https://avatars.githubusercontent.com/u/89663953?v=4" width=115><br><sub>Pedro Victor</sub>](https://github.com/PedroVenanci0) |
| :---: | :---: |
