# 🚗 Sistema de Gestão de Concessionária

## 📘 Sobre o Projeto

Este é um sistema completo para gerenciar uma rede de concessionárias de carros. Todo o controle de vendas, estoque, funcionários e clientes é feito diretamente no banco de dados, utilizando comandos SQL.

O sistema simula um cenário real onde cada loja tem seu próprio estoque de carros, e os vendedores só podem negociar os veículos da filial onde trabalham.

## ✨ Funcionalidades Principais

* **Controle de Estoque:** Gerencia os carros disponíveis em cada loja.
* **Registro de Vendas:** Salva todas as informações de uma venda, como quem vendeu, quem comprou e qual carro foi vendido.
* **Gestão de Clientes e Funcionários:** Cadastra clientes (Pessoa Física e Jurídica) e vendedores, controlando as metas de venda de cada um.
* **Automação Inteligente:** O sistema calcula totais, atualiza o estoque e o total de vendas de um funcionário automaticamente após cada transação.

## 🚀 Como Usar

1.  **Copie o Código:** Baixe ou clone os arquivos do projeto.
2.  **Crie o Banco de Dados:** Use PostgreSQL para criar um novo banco de dados.
3.  **Execute o Script:** Abra o arquivo SQL principal e execute-o por completo. Isso irá criar todas as tabelas, regras e funções necessárias.
4.  **Gerencie a Loja com SQL:** Agora, você pode usar comandos SQL para realizar as operações.

    * **Para cadastrar uma nova cor de carro:**
        ```sql
        SELECT inserir_na_tabela('COR', 'COD_COR, NOME', '4, ''AZUL''');
        ```

    * **Para ver qual loja vendeu mais em Junho de 2025:**
        ```sql
        SELECT * FROM fn_loja_campea_de_vendas(6, 2025);
        ```

## 👥 Colaboradores

| Nome          | GitHub                                                                                                        |
|---------------|---------------------------------------------------------------------------------------------------------------|
| **Luiz Felipe** | [![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Luiz-06)      |
| **Pedro Victor** | [![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/PedroVenanci0) |