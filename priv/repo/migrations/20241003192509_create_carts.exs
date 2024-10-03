defmodule JustTravelTestBackend.Repo.Migrations.CreateCarts do
  use Ecto.Migration

  def change do
    create table(:carts) do

      timestamps(type: :utc_datetime)
    end
  end
end
