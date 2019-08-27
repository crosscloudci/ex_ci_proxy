# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ex_ci_proxy, ExCiProxy.Endpoint,
  url: [host: "0.0.0.0"],
  secret_key_base: "I8nhRiDi+2wDaqCEPXuPsMMirFgbwfVbedxm6t5YvZ5/pw2J0E9w69+ZC8Ne5qqq",
  render_errors: [view: ExCiProxy.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ExCiProxy.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: :info


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
