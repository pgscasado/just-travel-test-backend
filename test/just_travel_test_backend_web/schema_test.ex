defmodule JustTravelTestBackendWeb.SchemaTest do
  use JustTravelTestBackendWeb.ConnCase

  @all_items_query """
    query {
      get_items {
        id
        name
        description
        price
      }
    }
  """

  @get_item_query """
    query($id: ID!) {
      get_item(id: $id) {
        id
        name
        description
        price
      }
    }
  """

  @insert_item_mutation """
    mutation($name: String!, $description: String!, $price: Float!) {
      insert_item(name: $name, description: $description, price: $price) {
        id
        name
        description
        price
      }
    }
  """

  @update_item_mutation """
    mutation($id: ID!, $name: String, $description: String, $price: Float!) {
      update_item(id: $id, name: $name, description: $description, price: $price) {
        id
        name
        description
        price
      }
    }
  """

  @delete_item_mutation """
    mutation($id: ID!) {
      delete_item(id: $id) {
        id
        name
        description
        price
      }
    }
  """

  @create_cart_mutation """
    mutation {
      create_cart {
        id
        cartItems {
          id
        }
      }
    }
  """

  @delete_cart_mutation """
    mutation($id: ID!) {
      delete_cart(id:$id) {
        id
      }
    }
  """

  @view_cart_query """
    query($id: Int!) {
      view_cart(id: $id) {
        id
        totalPrice
        deductedTotalPrice
        cartItems {
          quantity
          item {
            id
            name
            description
            price
          }
        }
      }
    }
  """

  @add_item_to_cart_mutation """
    mutation($cart_id:Int!, $item_id:Int!, $quantity:Int!) {
      add_item_to_cart(
        cartId:$cart_id,
        itemId:$item_id,
        quantity:$quantity,
      ) {
        id,
        item { id, name, price, description},
        quantity
      }
    }
  """

  @remove_item_from_cart_mutation """
    mutation ($cart_id:Int!, $item_id:Int!, $quantity_to_remove:Int!) {
      removeItemFromCart(
        cartId: $cart_id,
        itemId: $item_id,
        quantity: $quantity_to_remove
      ) {
        id,
        item { id, name, price, description },
        quantity
      }
    }
  """

  @finish_cart_mutation """
    mutation ($id: Int!, $payment_method: String!){
      finish_cart(
        id: $id,
        paymentMethod: $payment_method
      ) {
        id
        paymentMethod
        price
        cartItems {
          quantity
          item {
            name
          }
        }
      }
    }
  """

  test "all_items" do
    # create some items
    Absinthe.run(@insert_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"name" => "test", "description" => "test", "price" => 10.0})
    Absinthe.run(@insert_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"name" => "test2", "description" => "test2", "price" => 20.0})
    Absinthe.run(@insert_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"name" => "test3", "description" => "test3", "price" => 30.0})

    # list all items
    assert {:ok, %{data: data}} = Absinthe.run(@all_items_query, JustTravelTestBackendWeb.Schema)
    assert %{
      "get_items" => items
    } = data
    # there must be at least 3 items
    assert length(items) >= 3

    # there must be test, test2 and test3 in the list
    assert Enum.any?(items, fn item -> item["name"] == "test" end)
    assert Enum.any?(items, fn item -> item["name"] == "test2" end)
    assert Enum.any?(items, fn item -> item["name"] == "test3" end)
  end

  test "get_item" do
    # create an item
    assert {:ok, %{data: %{"insert_item" => created_item}}} = Absinthe.run(@insert_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"name" => "test", "description" => "test", "price" => 10.0})

    # get the item
    assert {:ok, %{data: %{"get_item" => item}}} = Absinthe.run(@get_item_query, JustTravelTestBackendWeb.Schema, variables: %{"id" => created_item["id"]})

    assert created_item["id"] == item["id"]
  end

  test "insert_item" do
    # insert an item
    assert {:ok, %{data: %{"insert_item" => item}}} = Absinthe.run(@insert_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"name" => "test", "description" => "test", "price" => 10.0})

    assert item["name"] == "test"
    assert item["description"] == "test"
    assert item["price"] == 10.0
  end

  test "update_item" do
    # insert an item
    assert {:ok, %{data: %{"insert_item" => item}}} = Absinthe.run(@insert_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"name" => "test", "description" => "test", "price" => 10.0})

    # update the item
    assert {:ok, %{data: %{"update_item" => _item}}} = Absinthe.run(@update_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"id" => item["id"], "name" => "test2", "description" => "test2", "price" => 20.0})

    # check if the item was updated
    assert {:ok, %{data: %{"get_item" => updated_item}}} = Absinthe.run(@get_item_query, JustTravelTestBackendWeb.Schema, variables: %{"id" => item["id"]})
    assert updated_item["name"] == "test2"
    assert updated_item["description"] == "test2"
    assert updated_item["price"] == 20.0
  end

  test "delete_item" do
    # insert an item
    assert {:ok, %{data: %{"insert_item" => item}}} = Absinthe.run(@insert_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"name" => "test", "description" => "test", "price" => 10.0})

    # delete the item
    assert {:ok, %{data: %{"delete_item" => _item}}} = Absinthe.run(@delete_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"id" => item["id"]})
    # check if the item was deleted
    assert {:ok, %{data: %{"get_item" => deleted_item}}} = Absinthe.run(@get_item_query, JustTravelTestBackendWeb.Schema, variables: %{"id" => item["id"]})
    assert deleted_item == nil
  end

  test "create_cart" do
    # create a cart
    assert {:ok, %{data: %{"create_cart" => cart}}} = Absinthe.run(@create_cart_mutation, JustTravelTestBackendWeb.Schema)
    # check if the cart was created
    assert {:ok, %{data: %{"view_cart" => view_cart}}} = Absinthe.run(@view_cart_query, JustTravelTestBackendWeb.Schema, variables: %{"id" => 1})

    assert view_cart["id"] == cart["id"]
    assert view_cart["totalPrice"] == 0.0
    assert view_cart["deductedTotalPrice"] == 0.0
    assert view_cart["cartItems"] == []
  end

  test "delete_cart" do
    # create a cart
    assert {:ok, %{data: %{"create_cart" => cart}}} = Absinthe.run(@create_cart_mutation, JustTravelTestBackendWeb.Schema)
    # delete the cart
    assert {:ok, %{data: %{"delete_cart" => _cart}}} = Absinthe.run(@delete_cart_mutation, JustTravelTestBackendWeb.Schema, variables: %{"id" => 1})
    # check if the cart was deleted
    assert {:ok, %{data: %{"view_cart" => view_cart}}} = Absinthe.run(@view_cart_query, JustTravelTestBackendWeb.Schema, variables: %{"id" => 1})
    assert view_cart == nil
  end

  test "add_item_to_cart" do
    # create a cart
    assert {:ok, %{data: %{"create_cart" => cart}}} = Absinthe.run(@create_cart_mutation, JustTravelTestBackendWeb.Schema)
    # insert an item
    assert {:ok, %{data: %{"insert_item" => item}}} = Absinthe.run(@insert_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"name" => "test", "description" => "test", "price" => 10.0})
    # add the item to the cart
    assert {:ok, %{data: %{"add_item_to_cart" => cart_item}}} = Absinthe.run(@add_item_to_cart_mutation, JustTravelTestBackendWeb.Schema, variables: %{"cart_id" => 1, "item_id" => 1, "quantity" => 1})

    # check if the cart item was added
    assert {:ok, %{data: %{"view_cart" => cart}}} = Absinthe.run(@view_cart_query, JustTravelTestBackendWeb.Schema, variables: %{"id" => 1})

    assert length(cart["cartItems"]) == 1
    assert cart["cartItems"] == [%{"quantity" => 1, "item" => %{"id" => "1", "name" => "test", "description" => "test", "price" => 10.0}}]
    assert cart["totalPrice"] == 10.0
    assert cart["deductedTotalPrice"] == 9.0

    ### check item quantity increment
    # add one more item to the cart
    assert {:ok, %{data: %{"add_item_to_cart" => cart_item}}} = Absinthe.run(@add_item_to_cart_mutation, JustTravelTestBackendWeb.Schema, variables: %{"cart_id" => 1, "item_id" => 1, "quantity" => 1})
    # check if the cart item was added
    assert {:ok, %{data: %{"view_cart" => cart}}} = Absinthe.run(@view_cart_query, JustTravelTestBackendWeb.Schema, variables: %{"id" => 1})

    assert length(cart["cartItems"]) == 1
    assert cart["cartItems"] == [%{"quantity" => 2, "item" => %{"id" => "1", "name" => "test", "description" => "test", "price" => 10.0}}]
    assert cart["totalPrice"] == 20.0

    ### check item duplicity
    # add one more item to the system
    assert {:ok, %{data: %{"insert_item" => item}}} = Absinthe.run(@insert_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"name" => "test2", "description" => "test2", "price" => 30.0})
    # add the item to the cart
    assert {:ok, %{data: %{"add_item_to_cart" => cart_item}}} = Absinthe.run(@add_item_to_cart_mutation, JustTravelTestBackendWeb.Schema, variables: %{"cart_id" => 1, "item_id" => 2, "quantity" => 1})
    # check if the cart item was added
    assert {:ok, %{data: %{"view_cart" => cart}}} = Absinthe.run(@view_cart_query, JustTravelTestBackendWeb.Schema, variables: %{"id" => 1})

    assert length(cart["cartItems"]) == 2
  end

  test "remove_item_from_cart" do
    # create a cart
    assert {:ok, %{data: %{"create_cart" => cart}}} = Absinthe.run(@create_cart_mutation, JustTravelTestBackendWeb.Schema)
    # insert an item
    assert {:ok, %{data: %{"insert_item" => item}}} = Absinthe.run(@insert_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"name" => "test", "description" => "test", "price" => 10.0})
    # add the item to the cart
    assert {:ok, %{data: %{"add_item_to_cart" => cart_item}}} = Absinthe.run(@add_item_to_cart_mutation, JustTravelTestBackendWeb.Schema, variables: %{"cart_id" => 1, "item_id" => 1, "quantity" => 10})
    # remove the item from the cart
    assert {:ok, %{data: %{"removeItemFromCart" => cart_item}}} = Absinthe.run(@remove_item_from_cart_mutation, JustTravelTestBackendWeb.Schema, variables: %{"cart_id" => 1, "item_id" => 1, "quantity_to_remove" => 5})

    # check if the cart item was removed
    assert {:ok, %{data: %{"view_cart" => cart}}} = Absinthe.run(@view_cart_query, JustTravelTestBackendWeb.Schema, variables: %{"id" => 1})

    assert length(cart["cartItems"]) == 1
    assert cart["cartItems"] == [%{"quantity" => 5, "item" => %{"id" => "1", "name" => "test", "description" => "test", "price" => 10.0}}]
    assert cart["totalPrice"] == 50.0
    assert cart["deductedTotalPrice"] == 45.0
  end

  test "finish_cart_cash" do
    # create a cart
    assert {:ok, %{data: %{"create_cart" => cart}}} = Absinthe.run(@create_cart_mutation, JustTravelTestBackendWeb.Schema)
    # insert an item
    assert {:ok, %{data: %{"insert_item" => item}}} = Absinthe.run(@insert_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"name" => "test", "description" => "test", "price" => 10.0})
    # insert one more item
    assert {:ok, %{data: %{"insert_item" => item}}} = Absinthe.run(@insert_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"name" => "test2", "description" => "test2", "price" => 20.0})
    # add items to the cart
    assert {:ok, %{data: %{"add_item_to_cart" => cart_item}}} = Absinthe.run(@add_item_to_cart_mutation, JustTravelTestBackendWeb.Schema, variables: %{"cart_id" => 1, "item_id" => 1, "quantity" => 10})
    assert {:ok, %{data: %{"add_item_to_cart" => cart_item}}} = Absinthe.run(@add_item_to_cart_mutation, JustTravelTestBackendWeb.Schema, variables: %{"cart_id" => 1, "item_id" => 2, "quantity" => 20})

    # finish the cart
    assert {:ok, %{data: %{"finish_cart" => cart}}} = Absinthe.run(@finish_cart_mutation, JustTravelTestBackendWeb.Schema, variables: %{"id" => 1, "payment_method" => "cash"})
    # check if the cart was finished
    assert cart["paymentMethod"] == "cash"
    assert cart["price"] == (10 * 10.0 + 20 * 20.0) * 0.9 # 10% discount
    assert length(cart["cartItems"]) == 2

    # check if the cart was deleted
    assert {:ok, %{data: %{"view_cart" => cart}}} = Absinthe.run(@view_cart_query, JustTravelTestBackendWeb.Schema, variables: %{"id" => 1})
    assert cart == nil
  end

  test "finish_cart_credit_card" do
    # create a cart
    assert {:ok, %{data: %{"create_cart" => cart}}} = Absinthe.run(@create_cart_mutation, JustTravelTestBackendWeb.Schema)
    # insert an item
    assert {:ok, %{data: %{"insert_item" => item}}} = Absinthe.run(@insert_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"name" => "test", "description" => "test", "price" => 10.0})
    # insert one more item
    assert {:ok, %{data: %{"insert_item" => item}}} = Absinthe.run(@insert_item_mutation, JustTravelTestBackendWeb.Schema, variables: %{"name" => "test2", "description" => "test2", "price" => 20.0})
    # add items to the cart
    assert {:ok, %{data: %{"add_item_to_cart" => cart_item}}} = Absinthe.run(@add_item_to_cart_mutation, JustTravelTestBackendWeb.Schema, variables: %{"cart_id" => 1, "item_id" => 1, "quantity" => 10})
    assert {:ok, %{data: %{"add_item_to_cart" => cart_item}}} = Absinthe.run(@add_item_to_cart_mutation, JustTravelTestBackendWeb.Schema, variables: %{"cart_id" => 1, "item_id" => 2, "quantity" => 20})

    # finish the cart
    assert {:ok, %{data: %{"finish_cart" => cart}}} = Absinthe.run(@finish_cart_mutation, JustTravelTestBackendWeb.Schema, variables: %{"id" => 1, "payment_method" => "credit_card"})
    # check if the cart was finished
    assert cart["paymentMethod"] == "credit_card"
    assert cart["price"] == (10 * 10.0 + 20 * 20.0)
    assert length(cart["cartItems"]) == 2

    # check if the cart was deleted
    assert {:ok, %{data: %{"view_cart" => cart}}} = Absinthe.run(@view_cart_query, JustTravelTestBackendWeb.Schema, variables: %{"id" => 1})
    assert cart == nil
  end
end
