import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :just_travel_test_backend, JustTravelTestBackend.Repo,
  database: Path.expand("../just_travel_test_backend_test.sqlite3", Path.dirname(__ENV__.file)),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :just_travel_test_backend, JustTravelTestBackendWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "rjjWDIuulg2tEeGAhfYdVzyWINOP7P9hi1e0HaHYV8wAqWJMtT4WYkDimRgnEdR8",
  server: false

# In test we don't send emails.
config :just_travel_test_backend, JustTravelTestBackend.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
