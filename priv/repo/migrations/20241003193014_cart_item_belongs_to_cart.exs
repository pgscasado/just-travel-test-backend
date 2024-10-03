defmodule JustTravelTestBackend.Repo.Migrations.CartItemBelongsToCart do
  use Ecto.Migration

  def change do
    alter table(:cart_items) do
      add :cart_id, references(:carts, on_delete: :delete_all)
      add :item_id, references(:items)
    end
  end
end
