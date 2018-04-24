defmodule GdriveTest do
  use ExUnit.Case
  doctest Gdrive
  alias Gdrive.Connection
  alias Gdrive.Api.File

  @tag :skip
  test "greets the world" do
    assert Gdrive.hello() == :world
  end

  @tag :skip
  test "token" do
    {status, token} = Goth.Token.for_scope("https://www.googleapis.com/auth/drive")
    assert status == :ok
  end

  #@tag :skip
  test "list api" do
    connection =
      Connection.new(fn scopes ->
        {:ok, token} = Goth.Token.for_scope(Enum.join(scopes, " "))
        token.token
      end)

    {status, data} =
      Gdrive.Api.File.list(
        connection,
        fields: "files/parents,files/webContentLink,files/id,files/name,files/kind"
      )

    # data["files"]
    # |> Enum.map(fn x ->
    #   Gdrive.Api.File.delete(connection, x["id"])
    # end)

    IO.inspect(data)
    assert status == :ok
  end

  @tag :skip
  test "copy file" do
    connection =
      Connection.new(fn scopes ->
        {:ok, token} = Goth.Token.for_scope(Enum.join(scopes, " "))
        token.token
      end)

    {status, data} =
      Gdrive.Api.File.copy(
        connection,
        "1G-IG0kf6SbtDA0f87cCfMzt-W8Vxe0QG",
        name: "new_name.jpg",
        contentHints: %{
          thumbnail: %{
            image: "test.png"
          }
        }
      )

    assert status == :ok
  end

  @tag :skip
  test "Create new file" do
    connection =
      Connection.new(fn scopes ->
        {:ok, token} = Goth.Token.for_scope(Enum.join(scopes, " "))
        token.token
      end)

    {status, data} =
      Gdrive.Api.File.create(
        connection,
        name: "new_name_created.jpg"
      )

    IO.inspect(data)
    assert status == :ok
  end

  @tag :skip
  test "Delete a file" do
    connection =
      Connection.new(fn scopes ->
        {:ok, token} = Goth.Token.for_scope(Enum.join(scopes, " "))
        token.token
      end)

    {status, data} =
      Gdrive.Api.File.delete(
        connection,
        "1r0MirL3sxVlwVgcptYM8288AMe1CQ2qy"
      )

    IO.inspect(data)
    assert status == :ok
  end

  @tag :skip
  test "Empty trash" do
    connection =
      Connection.new(fn scopes ->
        {:ok, token} = Goth.Token.for_scope(Enum.join(scopes, " "))
        token.token
      end)

    {status, data} = Gdrive.Api.File.empty_trash(connection)

    IO.inspect(data)
    assert status == :ok
  end

  @tag :skip
  test "Export File" do
    connection =
      Connection.new(fn scopes ->
        {:ok, token} = Goth.Token.for_scope(Enum.join(scopes, " "))
        token.token
      end)

    {status, data} =
      Gdrive.Api.File.export(
        connection,
        "1dTp2BMIEIl-tqJ9GvnZpnyvFHyLEGnD3eeLUAix5XNc",
        mimeType: "application/pdf"
      )

    IO.inspect(data)
    assert status == :ok
  end

  @tag :skip
  test "Get File" do
    connection =
      Connection.new(fn scopes ->
        {:ok, token} = Goth.Token.for_scope(Enum.join(scopes, " "))
        token.token
      end)

    {status, data} =
      Gdrive.Api.File.get(
        connection,
        "1aHYgX6wbExFUpSZWBhrxRnYDRKfF5FtL",
        fields: "webContentLink,webViewLink"
      )

    IO.inspect(data)
    assert status == :ok
  end

  @tag :skip
  test "Update File" do
    connection =
      Connection.new(fn scopes ->
        {:ok, token} = Goth.Token.for_scope(Enum.join(scopes, " "))
        token.token
      end)

    {status, data} =
      Gdrive.Api.File.update(
        connection,
        "1EjwBxrctEvm5CAcEa_K1hvBuCcBN7vF1",
        name: "hehe"
      )

    IO.inspect(data)
    assert status == :ok
  end

  # @tag :skip
  test "Upload a File" do
    connection =
      Connection.new(fn scopes ->
        {:ok, token} = Goth.Token.for_scope(Enum.join(scopes, " "))
        token.token
      end)

    {status, data} =
      Gdrive.Api.File.upload(
        connection,
        name: "haha_kaka",
        filename: "/Users/flex/Downloads/icon2.png",
        fields: "webContentLink,webViewLink,id,name",
        parents: ["152mKEu8VJyomp_-X6C4EXj0QHFgIEIuS"]
      )

    IO.inspect(data)
    assert status == :ok
  end
end
