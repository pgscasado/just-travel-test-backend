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

<details>
  <summary>O que vai ser inserido:</summary>

  Itens adicionados: 
  id | name | description | price
  --- | ---- | ----------- | ----
  1 | Banana | A banana | 3.0
  2 | Apple | An apple | 2.0
  3 | Milk | A milk | 5.0
  4 | Orange | An orange | 4.0
  5 | Egg | An egg | 1.0
  6 | Meat | Meat | 10.0
  7 | Cheese | Cheese | 8.0
  8 | Coke | Coke | 6.0
  9 | Pepsi | Pepsi | 7.0
  10 | Water | Water | 1.0

  Carrinhos criados:
```json
[
  {
    "cartItems": [
      {
        "item": {
          "name": "Banana",
          "price": 3
        },
        "quantity": 1
      },
      {
        "item": {
          "name": "Apple",
          "price": 2
        },
        "quantity": 5
      },
      {
        "item": {
          "name": "Milk",
          "price": 5
        },
        "quantity": 2
      }
    ],
    "deductedTotalPrice": 20.7,
    "id": "1",
    "totalPrice": 23
  },
  {
    "cartItems": [
      {
        "item": {
          "name": "Egg",
          "price": 1
        },
        "quantity": 2
      },
      {
        "item": {
          "name": "Meat",
          "price": 10
        },
        "quantity": 10
      }
    ],
    "deductedTotalPrice": 91.8,
    "id": "2",
    "totalPrice": 102
  }
]
```
  
</details>

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



