# 🚗 Sistema de Gestão para Concessionária de Veículos

## 📘 Descrição do Projeto

Este sistema foi desenvolvido para gerenciar concessionárias de veículos com múltiplas lojas integradas a um **estoque centralizado**. Cada loja atua como ponto de atendimento ao cliente e processamento de solicitações de compra, mas **os veículos são armazenados no estoque principal da rede**. Quando um cliente solicita um carro em uma loja, essa unidade requisita o veículo ao **estoque central**, e realiza a entrega posteriormente ao cliente. Além disso, cada funcionário de vendas está **vinculado exclusivamente a uma única loja**, ou seja, **não atuam em toda a rede**, o que permite um controle individualizado de metas e desempenho por filial.

[cite_start]Este trabalho privilegia a manipulação de banco de dados, contendo um mínimo de 7 a 10 tabelas e abundantes movimentações de dados[cite: 5]. [cite_start]O sistema funciona exclusivamente a nível de banco de dados, sem interface gráfica [cite: 8][cite_start], e todas as funcionalidades (cadastros, alterações, remoções e movimentações) são realizadas por meio de funções e triggers.

## ⚙️ Funcionalidades Principais

* 📦 **Cadastro e controle do estoque central de veículos**
* 🏬 **Gestão de solicitações de veículos feitas pelas lojas**
* 🧾 **Registro completo de vendas**, vinculando vendedores, clientes e veículos entregues
* 👥 **Suporte a diferentes tipos de clientes** (Pessoa Física e Jurídica), com CPF ou CNPJ
* 👤 **Controle individual de desempenho e metas dos vendedores por loja**
* 📊 **Histórico detalhado das operações**, com rastreabilidade completa: quando, o quê, para quem e por quem foi vendido

### Funções Obrigatórias do Banco de Dados

[cite_start]Conforme as regras da disciplina, as seguintes funções de banco de dados são obrigatórias:

* [cite_start]Uma função para cadastramento de dados.
* Uma função para remoção de dados. [cite_start]Esta função inclui uma estratégia para manter a integridade referencial dos dados.
* [cite_start]Uma função para alteração de dados.

[cite_start]Todas essas funções recebem o nome da tabela a ser manipulada como um dos parâmetros. [cite_start]Os parâmetros repassados para as funções são os mais próximos do usuário.

## Estrutura do Banco de Dados

O banco de dados foi modelado para suportar as operações da concessionária, incluindo tabelas para `FUNCIONARIO`, `CLIENTE`, `PESSOA_FISICA`, `PESSOA_JURIDICA`, `VENDA`, `ITEM_VENDA`, `COR`, `LOJA`, `MARCA`, `TIPO`, `CARRO`, e `LOJA_CARRO`.

### Tabelas Criadas

As tabelas do banco de dados são as seguintes:

* **`FUNCIONARIO`**: Armazena informações dos vendedores, incluindo nome, data de nascimento, salário, meta mensal e quantidade vendida no mês. Cada funcionário está vinculado a uma `LOJA_CARRO`.
* **`CLIENTE`**: Tabela genérica para clientes, contendo nome, data de nascimento e o total gasto.
* **`PESSOA_FISICA`**: Detalhes específicos para clientes Pessoa Física, com CPF.
* **`PESSOA_JURIDICA`**: Detalhes específicos para clientes Pessoa Jurídica, com CNPJ.
* **`VENDA`**: Registra as vendas realizadas, vinculando funcionários e clientes, além do valor total e data da venda.
* **`ITEM_VENDA`**: Detalha os itens de cada venda, referenciando a venda e o carro associado à loja (`LOJA_CARRO`).
* **`COR`**: Tabela de referência para as cores dos carros.
* **`LOJA`**: Tabela de referência para as diferentes lojas da concessionária.
* **`MARCA`**: Tabela de referência para as marcas dos carros.
* **`TIPO`**: Tabela de referência para os tipos de veículos (e.g., Hatch, SUV, Sedan).
* **`CARRO`**: Contém as informações dos veículos, incluindo cor, marca, tipo, nome, preço, ano e quantidade em estoque.
* **`LOJA_CARRO`**: Tabela de associação que liga os carros às lojas, representando o estoque disponível em cada filial.

### `INSERT` Statements

Para popular as tabelas, foram inseridos dados iniciais nas seguintes tabelas:

* `FUNCIONARIO`
* `CLIENTE`
* `PESSOA_FISICA`
* `PESSOA_JURIDICA`
* `COR`
* `LOJA`
* `MARCA`
* `TIPO`
* `CARRO`
* `LOJA_CARRO`

### `TRIGGERS` Implementados

Os seguintes `TRIGGER`s foram desenvolvidos para garantir a integridade dos dados e automatizar processos:

* **`total_da_venda_tr`**: Ativado após `INSERT`, `UPDATE` ou `DELETE` na tabela `ITEM_VENDA`. Calcula o `VALOR_TOTAL` da venda e atualiza a `QTD_EM_ESTOQUE` do `CARRO` correspondente.
* **`VALIDAR_FUNCIONARIO_CLIENTE_TR`**: Ativado após `INSERT` ou `UPDATE` na tabela `VENDA`. Valida a existência do `COD_FUNCIONARIO` e `COD_CLIENTE` informados.
* **`validar_qtd_tr`**: Ativado antes de `INSERT` ou `UPDATE` na tabela `ITEM_VENDA`. Verifica se a `QTD_DE_ITENS` solicitada é menor ou igual à `QTD_EM_ESTOQUE` disponível para o carro.
* **`tg_impede_venda_futura`**: Ativado antes de `INSERT` ou `UPDATE` na tabela `VENDA`. Impede o registro de vendas com data futura.
* **`tg_atualiza_qtd_vendida_funcionario`**: Ativado após `INSERT`, `UPDATE` ou `DELETE` na tabela `VENDA`. Atualiza a `QTD_VENDIDA_NO_MES` do `FUNCIONARIO` com base no `VALOR_TOTAL` da venda.
* **`tg_valida_meta_mensal_funcionario`**: Ativado antes de `INSERT` ou `UPDATE` na tabela `FUNCIONARIO`. Garante que a `META_MENSAL` do funcionário não seja um valor negativo.
* **`tg_atualiza_gasto_cliente`**: Ativado após `INSERT`, `UPDATE` ou `DELETE` na tabela `VENDA`. Atualiza a `QTD_GASTO` total do `CLIENTE` com base no `VALOR_TOTAL` da venda.
* **`trg_checa_meta`**: Ativado antes de `INSERT` na tabela `VENDA`. Verifica se o `FUNCIONARIO` atingiu ou ultrapassou a `META_MENSAL` após a nova venda, emitindo um `NOTICE`.
* **`verificar_funcionario_loja_item_venda_tr`**: Ativado antes de `INSERT` ou `UPDATE` na tabela `ITEM_VENDA`. Garante que um funcionário só possa vender carros associados à loja em que trabalha.

## Colaboradores

* **Luiz Felipe**
    GitHub: [Link do GitHub](https://github.com/Luiz-06)

* **Pedro Victor**
    GitHub: [Link do GitHub](https://github.com/PedroVenanci0)

## 🚀 Como Utilizar

1.  Clone o repositório:
    ```bash
    git clone [https://github.com/SEU_USUARIO/NOME_DO_REPOSITORIO.git](https://github.com/SEU_USUARIO/NOME_DO_REPOSITORIO.git)
    ```
2.  Navegue até o diretório do projeto.
3.  Crie o banco de dados PostgreSQL.
4.  Execute os scripts SQL fornecidos (tabelas, inserts e triggers) na ordem para configurar o banco de dados.
    * Primeiro, crie as tabelas.
    * Em seguida, insira os dados de exemplo.
    * Por fim, crie as funções e os triggers.
5.  Interaja com o banco de dados através de comandos SQL para realizar operações de cadastro, alteração, remoção e movimentação de dados. Por exemplo:
    ```sql
    -- Exemplo de inserção de uma venda
    INSERT INTO VENDA (COD_VENDA, COD_FUNCIONARIO, COD_CLIENTE, VALOR_TOTAL, DT_VENDA) VALUES
    (1, 1, 1, 0, CURRENT_DATE);

    -- Exemplo de inserção de um item de venda
    INSERT INTO ITEM_VENDA (COD_ITEM_VENDA, COD_VENDA, COD_LOJA_CARRO, QTD_DE_ITENS) VALUES
    (1, 1, 1, 1);
    ```
    Lembre-se que as funcionalidades de cálculo de total da venda e atualização de estoque, além das validações de funcionários e clientes, são gerenciadas pelos triggers.