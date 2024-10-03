defmodule JustTravelTestBackend.Repo do
  use Ecto.Repo,
    otp_app: :just_travel_test_backend,
    adapter: Ecto.Adapters.SQLite3
end
