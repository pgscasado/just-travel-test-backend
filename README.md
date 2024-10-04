# API de Carrinho de compras para o teste da Just Travel

## 📑 Introdução

Este projeto é uma API GraphQL desenvolvida em Elixir, usando Phoenix. A API tem a funcionalidade de:
- Gerir itens do sistema
- Criar um carrinho de compras (com controle de itens)
- Adicionar itens ao carrinho
- Remover itens do carrinho
- Finalizar a compra de um carrinho
   - Gerir a forma de pagamento
   - Gerir o valor da compra

## 👷‍♂️ Instalação

Para instalar o projeto, são necessárias algumas dependências:

```bash
erlang > 27
elixir > 1.17
```

Para instalar o projeto, execute:

```bash
mix deps.get
```

## 🪶 Banco de dados

Visando simplicidade, o projeto utiliza SQLite como banco de dados.

Para criar o banco de dados, execute:

```bash
mix ecto.migrate
```

## 🌱 Seed

Para popular o banco de dados, execute:

```bash
mix run priv/repo/seeds.exs
```

## 🔄️ Executar

Para executar o servidor, execute:

```bash
mix phx.server
```

### 🛝 Playground

O projeto foi desenvolvido para análise usando Playground do GraphiQL. Para acessar o playground certifique-se de executar o servidor e acesse: http://localhost:4000/api/graphiql.

Eu incluí as queries usadas nos testes no workspace do GraphiQL. Importe o arquivo `graphiql-workspace-2024-10-04-02-48-25.json` para o playground para visualizar as queries.

## ✅ Testes

Para executar os testes, execute:

```bash
mix test
```

Os testes se encontram na pasta `test/just_travel_test_backend`, no arquivo `schema_test.exs`.

## 📝 Documentação

A documentação do projeto está no seguinte link: https://pgscasado.github.io/just-travel-test-backend/api-reference.html.

Por ser uma API GraphQL, os módulos mais importantes são os resolvers de [Item](https://pgscasado.github.io/just-travel-test-backend/JustTravelTestBackendWeb.Schema.Resolvers.Item.html) e [Cart](https://pgscasado.github.io/just-travel-test-backend/JustTravelTestBackendWeb.Schema.Resolvers.Cart.html).

Também é de se notar que a documentação em código foi escrita, visando exemplificar o funcionamento do projeto e facilitar a referência para a inspeção.

## 🙏 Agradecimentos

Este projeto foi desenvolvido com o intuito de apresentar minhas habilidades e experiência na linguagem Elixir à equipe de recrutamento da Just Travel. Muito obrigado pela atenção e pelo seu tempo.



