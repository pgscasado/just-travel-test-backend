defmodule JustTravelTestBackendWeb.Schema.Resolvers.Item do
  @moduledoc """
  The item resolvers. Used to create, delete, view and update items.
  """
  alias JustTravelTestBackend.{Repo, Item}

  @doc """
  Get all items

  ## Examples

      iex> get_items(nil, nil, nil)
      {:ok, [%Item{}, ...]}
  """
  def get_items(_parent, _args, _resolution) do
    {:ok, Repo.all(Item)}
  end

  @doc """
  Get an item

  ## Params

  - id: The id of the item

  ## Examples

      iex> get_item(nil, %{id: "1"}, nil)
      {:ok, %Item{
        id: "1",
        name: "item1",
        description: "description1",
        price: 10.0
      }}
  """
  def get_item(_parent, %{id: id}, _resolution) do
    case Repo.get(Item, id) do
      nil -> {:error, "Item not found"}
      item -> {:ok, item}
    end
  end

  @doc """
  Insert an item

  ## Params

  - name: The name of the item
  - description: The description of the item
  - price: The price of the item

  ## Examples

      iex> insert_item(nil, %{name: "item1", description: "description1", price: 10.0}, nil)
      {:ok, %Item{
        id: "1",
        name: "item1",
        description: "description1",
        price: 10.0
      }}
  """
  def insert_item(_parent, %{name: name, description: description, price: price}, _resolution) do
    {:ok, Repo.insert!(%Item{name: name, description: description, price: price})}
  end

  @doc """
  Update an item

  ## Params

  - id: The id of the item
  - name: The name of the item
  - description: The description of the item
  - price: The price of the item

  ## Examples

      iex> update_item(nil, %{id: "1", name: "item1", description: "description1", price: 10.0}, nil)
      {:ok, %Item{
        id: "1",
        name: "item1",
        description: "description1",
        price: 10.0
      }}
  """
  def update_item(_parent, args = %{id: id, name: _name, description: _description, price: _price}, _resolution) do
    case Repo.get(Item, id) do
      nil -> {:error, "Item not found"}
      item ->
        update_params =
          args
          |> Map.drop([:id]) # Remove o ID, pois ele não deve ser atualizado
          |> Enum.filter(fn {_key, value} -> not is_nil(value) end)
          |> Enum.into(%{})
        changeset = Item.changeset(item, update_params)
        {:ok, Repo.update!(changeset)}
    end
  end

  @doc """
  Delete an item

  ## Params

  - id: The id of the item

  ## Examples

      iex> delete_item(nil, %{id: "1"}, nil)
      {:ok, %Item{
        id: "1",
        name: "item1",
        description: "description1",
        price: 10.0
      }}
  """
  def delete_item(_parent, %{id: id}, _resolution) do
    case Repo.get(Item, id) do
      nil -> {:error, "Item not found"}
      item -> {:ok, Repo.delete!(item)}
    end
  end
end
