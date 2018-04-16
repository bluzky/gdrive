defmodule Gdrive.MixProject do
  use Mix.Project

  def project do
    [
      app: :gdrive,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "Elixir client for Google drive API that support upload file"
    ]
  end

  def package do
    [
      name: :gdrive,
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Dung Nguyen"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/bluzky/gdrive"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:goth, "~> 0.8.2"},
      {:httpoison, "~> 1.0"},
      {:mime, "~> 1.2"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
