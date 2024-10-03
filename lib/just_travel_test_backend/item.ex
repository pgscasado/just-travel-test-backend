defmodule JustTravelTestBackend.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    field :description, :string
    field :price, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :description, :price])
    |> validate_required([:name, :description, :price])
  end
end
