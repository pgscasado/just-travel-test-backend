defmodule JustTravelTestBackendWeb.Schema do
  use Absinthe.Schema

  import_types JustTravelTestBackendWeb.Schema.ContentTypes

  alias JustTravelTestBackendWeb.Schema.Resolvers

  query do
    @desc "Get all items"
    field :get_items, list_of(:item) do
      resolve &Resolvers.Item.get_items/3
    end

    @desc "Get an item"
    field :get_item, :item do
      arg :id, non_null(:id)
      resolve &Resolvers.Item.get_item/3
    end

    @desc "Get all carts"
    field :get_carts, list_of(:cart) do
      resolve &Resolvers.Cart.get_carts/3
    end

    @desc "View a cart"
    field :view_cart, :cart do
      arg :id, non_null(:integer)
      resolve &Resolvers.Cart.get_cart/3
    end
  end

  mutation do
    @desc "Insert an item"
    field :insert_item, :item do
      arg :name, :string
      arg :description, :string
      arg :price, :float
      resolve &Resolvers.Item.insert_item/3
    end

    @desc "Update an item, being every field optional, except id"
    field :update_item, :item do
      arg :id, non_null(:id)
      arg :name, :string
      arg :description, :string
      arg :price, :float
      resolve &Resolvers.Item.update_item/3
    end

    @desc "Delete an item"
    field :delete_item, :item do
      arg :id, non_null(:id)
      resolve &Resolvers.Item.delete_item/3
    end

    @desc "Create a cart"
    field :create_cart, :cart do
      resolve &Resolvers.Cart.insert_cart/3
    end

    @desc "Delete a cart"
    field :delete_cart, :cart do
      arg :id, non_null(:id)
      resolve &Resolvers.Cart.delete_cart/3
    end

    @desc "Add an item to a cart"
    field :add_item_to_cart, :cart_item do
      arg :cart_id, non_null(:integer)
      arg :item_id, non_null(:integer)
      arg :quantity, non_null(:integer)
      resolve &Resolvers.Cart.add_item_to_cart/3
    end

    @desc "Remove an item from a cart"
    field :remove_item_from_cart, :cart_item do
      arg :cart_id, non_null(:integer)
      arg :item_id, non_null(:integer)
      arg :quantity, :integer
      resolve &Resolvers.Cart.remove_item_from_cart/3
    end

    @desc "Finish a purchase"
    field :finish_cart, :finished_cart do
      arg :id, non_null(:integer)
      arg :payment_method, :string
      resolve &Resolvers.Cart.finish_cart/3
    end
  end
end
