defmodule JustTravelTestBackend.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carts" do
    has_many :cart_items, JustTravelTestBackend.CartItem

    field :total_price, :float, virtual: true
    field :deducted_total_price, :float, virtual: true

    timestamps(type: :utc_datetime)
  end

  def with_virtual_fields(cart) do
    cart
    |> Map.put(:total_price, calculate_total_price(cart))
    |> Map.put(:deducted_total_price, calculate_deducted_total_price(cart))
  end

  defp calculate_total_price(cart) do
    Enum.reduce(cart.cart_items, 0.0, fn item, acc -> item.quantity * item.item.price + acc end)
  end

  defp calculate_deducted_total_price(cart) do
    calculate_total_price(cart) * 0.9
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [])
    |> validate_required([])
  end
end
