defmodule Gdrive do
  @moduledoc """
  Documentation for Gdrive.
  """

  alias Gdrive.Connection
  alias Gdrive.Api.File

  # file mime type
  defp type_file() do
    "text/plain"
  end

  # folder mime type
  defp type_folder() do
    "application/vnd.google-apps.folder"
  end

  @doc """
  Create an empty file

  ## Parameters
  - name: file name

  ## Examples

      iex> Gdrive.create("Hello.txt")

  You can create file under a folder

  ## Examples

      iex> Gdrive.create("hello.txt", parents: ["parent_folder_ids"])

  """
  def create(name, opts \\ []) do
    connection
    |> File.create([name: name, mimeType: type_file()] ++ opts)
  end

  @doc """
  Upload file to google drive

  You can upload to a specific folder, similar to `Gdrive.File.create`

  ## Parameters
  - path: path to local file

  ## Examples

      iex> Gdrive.upload("/user/test/Hello.txt", name: "goodbye.txt")

  """
  def upload(path, opts \\ []) do
    connection
    |> File.upload([filename: path] ++ opts)
  end

  @doc """
  Create a new folder

  ## Parameters
  - name: folder name

  ## Examples

      iex> Gdrive.create_folder("secret")

  """
  def create_folder(name) do
    connection
    |> File.create(name: name, mimeType: type_folder())
  end

  @doc """
  Create a new folder under a parent folder

  """
  def create_folder(name, parent_id) do
    connection
    |> File.create(name: name, mimeType: type_folder(), parents: [parent_id])
  end

  @doc """
  Rename a file or folder

  ## Parameters
  - id: file id or folder id
  - new_name: new file or folder name

  ## Examples

      iex> Gdrive.rename("aKDnadYQsdfPD", "new folder")

  """
  def rename(id, new_name, opts \\ []) do
    connection
    |> File.update(id, [name: new_name] ++ opts)
  end

  @doc """
  Copy file or folder to new location

  ## Parameters
  - id: file id or folder id
  - new_folder_id: new parent folder id

  ## Examples

      Gdrive.copy("aKDnadYQsdfPD", "sIkasWEdENsdEPN")
  """
  def copy(id, new_folder_id, opts \\ []) do
    connection
    |> File.copy([parents: [new_folder_id]] ++ opts)
  end

  @doc """
  Delete file or folder

  ## Parameters
  - id: file id or folder id

  ## Examples

      iex> Gdrive.delete("aKDnadYQsdfPD")

  """
  def delete(id, opts \\ []) do
    connection
    |> File.delete(id, opts)
  end

  @doc """
  Get file/folder detail

  ## Parameters
  - id: file id or folder id

  ## Examples

      iex> Gdrive.get("aKDnadYQsdfPD")

  """
  def get(id, opts \\ []) do
    connection()
    |> File.get(id, opts)
  end

  @doc """
  List all item in default space

  ## Parameters
  - query: query string [query document](https://developers.google.com/drive/v3/web/search-parameters)

  ## Examples

      iex> Gdrive.list("name='hello.txt'")

  """
  def list(query, opts \\ []) do
    connection()
    |> File.list([q: query] ++ opts)
  end

  defp connection() do
    Connection.new(fn scopes ->
      {:ok, token} = Goth.Token.for_scope(Enum.join(scopes, " "))
      token.token
    end)
  end
end
