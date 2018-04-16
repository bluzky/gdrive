# Gdrive

**TODO: Add description**

## Installation

1. [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `gdrive` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gdrive, "~> 0.1.0"}
  ]
end
```



2. Create or select a project at [Google Drive API enabler wizard](https://console.developers.google.com/flows/enableapi?apiid=drive.googleapis.com). Click **Continue**. Click **Go to credentials**.

3. Select **Other non-UI** > Click **Application data** > Click **No, I have not used.** > Click **Required credentials**.

4. Input **Service account name**, Select **Porject - Owner**. Click **next**, Start download JSON automatically. Rename it to **client_secret.json** and move to ```config** folder.

5. Click **Manage service accounts** > Edit service account > Click **Enable G Suite domain wide delegation** > **Save**.

6. Browse **Google Drive** > select any folder > share with  **service account id**(like xxx-xxx@xxxx.iam.gserviceaccount.com).

7. Add to your ```config.exs``` file:

```elixir
config :goth, 
  json: "./config/client_secret.json" |> File.read!
```
  
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/gdrive](https://hexdocs.pm/gdrive).

