defmodule JustTravelTestBackend.Repo.Migrations.CreateCartItems do
  use Ecto.Migration

  def change do
    create table(:cart_items) do
      add :quantity, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
