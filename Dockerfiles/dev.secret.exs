use Mix.Config
config :ex_ci_proxy, ExCiProxy.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "user",
  password: "database",
  database: "ciproxy",
  hostname: "postgres",
  ownership_timeout: 300_000,
  timeout: 300_000,
  pool_timeout: 300_000,
  pool: Ecto.Adapters.SQL.Sandbox


