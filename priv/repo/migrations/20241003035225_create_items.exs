defmodule JustTravelTestBackend.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :description, :string
      add :price, :float

      timestamps(type: :utc_datetime)
    end
  end
end
