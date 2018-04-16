defmodule GdriveTest.PermissionTest do
  use ExUnit.Case
  doctest Gdrive
  alias Gdrive.Connection
  alias Gdrive.Api.Permission

  @tag :skip
  test "public file" do
    connection =
      Connection.new(fn scopes ->
        {:ok, token} = Goth.Token.for_scope(Enum.join(scopes, " "))
        token.token
      end)

    {status, data} =
      Permission.create(
        connection,
        "1aHYgX6wbExFUpSZWBhrxRnYDRKfF5FtL",
        type: "anyone",
        role: "reader"
      )

    IO.inspect(data)
    assert status == :ok
  end
end
