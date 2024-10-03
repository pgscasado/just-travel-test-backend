defmodule JustTravelTestBackendWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation

  object :item do
    field :id, :id
    field :name, :string
    field :description, :string
    field :price, :float
  end

  object :cart_item do
    field :id, :id
    field :item, :item
    field :cart, :cart
    field :quantity, :integer
  end

  object :cart do
    field :id, :id
    field :total_price, :float
    field :deducted_total_price, :float
    field :cart_items, list_of(:cart_item)
  end

  object :finished_cart do
    field :id, :integer
    field :payment_method, :string
    field :price, :float
    field :cart_items, list_of(:cart_item)
  end
end
