defmodule JustTravelTestBackendWeb.Schema.Resolvers.Cart do
  @moduledoc """
  The cart resolvers. Used to create, delete, view and finish cart.
  """
  import Ecto.Query, only: [from: 2]

  require Logger
  alias JustTravelTestBackendWeb.Schema.Resolvers
  alias JustTravelTestBackend.{Repo, Cart, CartItem}

  defp fetch_cart(cart_id) do
    query = from c in Cart, where: c.id == ^cart_id, preload: [cart_items: :item]
    case Repo.get(query, cart_id) do
      nil -> {:error, "Cart not found"}
      cart -> {:ok, cart |> Cart.with_virtual_fields()}
    end
  end

  defp fetch_all_carts do
    carts = Repo.all(Cart) |> Repo.preload([cart_items: :item])
    case carts do
      [] -> {:error, "No carts found"}
      _ -> {:ok, carts |> Cart.with_virtual_fields()}
    end
  end

  defp fetch_cart_item(cart_id, item_id) do
    case Repo.get_by(CartItem, cart_id: cart_id, item_id: item_id) do
      nil -> {:error, "Item not found"}
      cart_item -> {:ok, cart_item}
    end
  end

  defp update_or_delete_item(cart_item, nil) do
    {:ok, Repo.delete!(cart_item) |> Repo.preload([:item])}
  end

  defp update_or_delete_item(cart_item, 0) do
    {:ok, Repo.delete!(cart_item) |> Repo.preload([:item])}
  end

  defp update_or_delete_item(cart_item, quantity) do
    new_quantity = cart_item.quantity - quantity
    changeset = CartItem.changeset(cart_item, %{quantity: new_quantity})
    {:ok, Repo.update!(changeset) |> Repo.preload([:item])}
  end

  defp find_or_create_cart_item(cart_id, item_id) do
    case Repo.get_by(CartItem, cart_id: cart_id, item_id: item_id) do
      nil ->
        {:ok, Repo.insert!(%CartItem{cart_id: cart_id, item_id: item_id, quantity: 0}) |> Repo.preload([:item])}
      cart_item ->
        {:ok, cart_item}
    end
  end

  defp update_cart_item_quantity(cart_item, quantity) do
    updated_quantity = cart_item.quantity + quantity

    cart_item
    |> CartItem.changeset(%{quantity: updated_quantity})
    |> Repo.update!()
    |> Repo.preload([:item])

    {:ok, Repo.get_by(CartItem, cart_id: cart_item.cart_id, item_id: cart_item.item_id)}
  end

  @doc """
  Get all carts
  """
  def get_carts(_parent, _args, _resolution) do
    with {:ok, carts} <- fetch_all_carts() do
      {:ok, carts}
    else
      {:error, message} -> {:error, message}
    end
  end

  @doc """
  Get a cart

  ## Params

  - id: The id of the cart

  ## Examples

      iex> get_cart(nil, %{id: "1"}, nil)
      {:ok, %Cart{
        id: "1",
        price: 0,
        cart_items: []
      }}
  """
  def get_cart(_parent, %{id: id}, _resolution) do
    with {:ok, cart} <- fetch_cart(id) do
      {:ok, cart}
    else
      {:error, message} -> {:error, message}
    end
  end

  @doc """
  Create a new cart

  ## Examples

      iex> create_cart(nil, %{}, nil)
      {:ok, %Cart{
        id: "1",
        price: 0,
        cart_items: []
      }}
  """
  def insert_cart(_parent, _args, _resolution) do
    {:ok, Repo.insert!(%Cart{})}
  end

  @doc """
  Delete a cart

  ## Params

  - id: The id of the cart

  ## Examples

      iex> delete_cart(nil, %{id: "1"}, nil)
      {:ok, %Cart{
        id: "1",
        price: 0,
        cart_items: []
      }}
  """
  def delete_cart(_parent, %{id: id}, _resolution) do
    case Repo.get(Cart, id) do
      nil -> {:error, "Cart not found"}
      cart -> {:ok, Repo.delete!(cart)}
    end
  end

  @doc """
  Finish a cart

  ## Params

  - id: The id of the cart
  - payment_method: The payment method of the cart

  ## Examples

      iex> finish_cart(nil, %{id: "1", payment_method: "credit_card"}, nil)
      {:ok, %Cart{
        id: "1",
        price: 0,
        cart_items: []
      }}
  """
  def finish_cart(_parent, %{id: id, payment_method: payment_method}, _resolution) do
    with :ok <- validate_payment_method(payment_method),
        {:ok, cart} <- fetch_cart(id),
        {:ok, _cart} <- delete_cart(nil, %{id: id}, nil) do
      total_price = if payment_method == "credit_card", do: cart.total_price, else: cart.deducted_total_price
      {:ok, %{
        id: cart.id,
        price: total_price,
        payment_method: payment_method,
        cart_items: cart.cart_items
      }}
    else
      {:error, message} -> {:error, message}
    end
  end

  @doc """
  Add an item to a cart

  ## Params

  - cart_id: The id of the cart
  - item_id: The id of the item
  - quantity: The quantity of the item

  ## Examples

      iex> add_item_to_cart(nil, %{cart_id: "1", item_id: "1", quantity: 1}, nil)
      {:ok, %CartItem{
        id: "1",
        quantity: 1
      }}
  """
  def add_item_to_cart(_parent, %{cart_id: cart_id, item_id: item_id, quantity: quantity}, _resolution) do
    with :ok <- validate_add_quantity(quantity),
        {:ok, _cart} <- fetch_cart(cart_id),
        {:ok, _item} <- Resolvers.Item.get_item(nil, %{id: item_id}, nil),
        {:ok, cart_item} <- find_or_create_cart_item(cart_id, item_id) do
      update_cart_item_quantity(cart_item, quantity)
    else
      {:error, message} -> {:error, message}
    end
  end

  @doc """
  Remove an item from a cart

  ## Params

  - cart_id: The id of the cart
  - item_id: The id of the item
  - quantity: The quantity of the item

  ## Examples

      iex> remove_item_from_cart(nil, %{cart_id: "1", item_id: "1", quantity: 1}, nil)
      {:ok, %CartItem{
        id: "1",
        quantity: 1
      }}
  """
  def remove_item_from_cart(_parent, %{cart_id: cart_id, item_id: item_id, quantity: quantity}, _resolution) do
    with {:ok, _cart} <- fetch_cart(cart_id),
        {:ok, cart_item} <- fetch_cart_item(cart_id, item_id),
        :ok <- validate_sub_quantity(cart_item, quantity) do
      update_or_delete_item(cart_item, quantity)
    else
      {:error, message} -> {:error, message}
    end
  end

  ## validators

  defp validate_sub_quantity(_cart_item, nil), do: :ok
  defp validate_sub_quantity(_cart_item, 0), do: :ok
  defp validate_sub_quantity(cart_item, quantity) when quantity > cart_item.quantity or quantity < 0, do: {:error, "Quantity must be between 0 (to remove) and #{cart_item.quantity}"}
  defp validate_sub_quantity(_cart_item, _quantity), do: :ok

  defp validate_add_quantity(quantity) when quantity <= 0, do: {:error, "Quantity must be greater than zero"}
  defp validate_add_quantity(_quantity), do: :ok

  defp validate_payment_method("cash"), do: :ok
  defp validate_payment_method("credit_card"), do: :ok
  defp validate_payment_method(_payment_method), do: {:error, "Invalid payment method. Must be 'cash' or 'credit_card'."}
end
