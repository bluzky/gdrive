# Gdrive


[Online document](https://hexdocs.pm/gdrive)

## Installation

1. [available in Hex](https://hex.pm/packages/gdrive), the package can be installed
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

4. Input **Service account name**, Select **Porject - Owner**. Click **next**, Start download JSON automatically. Rename it to **client_secret.json** and move to **config** folder.

5. Click **Manage service accounts** > Edit service account > Click **Enable G Suite domain wide delegation** > **Save**.

6. Browse **Google Drive** > select any folder > share with  **service account id**(like xxx-xxx@xxxx.iam.gserviceaccount.com).

7. Add to your ```config.exs``` file:

```elixir
config :goth, 
  json: "./config/client_secret.json" |> File.read!
```
  
## Usage

### 1. Basic usage
Gdrive wrap basic Files api with:
- create files
- create folder
- list
- get files
- upload files
- update, copy, delete file/folder

```elixir
{status, file_info} = Gdrive.upload("/user/my_folder/file.txt", name: "first-file.txt")
```

### 2. Advance
You can make a request with `Gdrive.Api.File` which support all params

```elixir
# grab google token
{_, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/drive,https://www.googleapis.com/auth/drive.file,https://www.googleapis.com/auth/drive.appdata")

# send request
{status, data} = Gdrive.Api.File.create(name: "empty.txt", mimeType: "text/plain")
```

[Online document](http://hexdocs.pm/gdrive)
