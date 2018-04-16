use Mix.Config

# Configure your database
config :goth, json: "secret/test-key.json" |> File.read!()
