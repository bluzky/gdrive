defmodule Gdrive.Connection do
  use HTTPoison.Base

  defstruct headers: [{"User-Agent", "Elixir"}],
            url: "",
            method: :get,
            type: :none,
            body: [],
            query: [],
            parts: []

  defmodule Part do
    defstruct headers: [], body: []
  end

  # Add any middleware here (authentication)
  def base_url, do: "https://www.googleapis.com/drive/v3"

  @scopes [
    "https://www.googleapis.com/auth/drive",
    "https://www.googleapis.com/auth/drive.file",
    "https://www.googleapis.com/auth/drive.readonly",
    "https://www.googleapis.com/auth/drive.metadata.readonly",
    "https://www.googleapis.com/auth/drive.metadata",
    "https://www.googleapis.com/auth/drive.photos.readonly"
  ]

  @spec new(String.t()) :: Tesla.Env.client()
  def new(token) when is_binary(token) do
    %__MODULE__{url: base_url()}
    |> add_header("Authorization", "Bearer #{token}")
  end

  @spec new((list(String.t()) -> String.t())) :: Tesla.Env.client()
  def new(token_fetcher) when is_function(token_fetcher) do
    token_fetcher.(@scopes)
    |> new
  end

  def add_header(conn, key, value) do
    Map.update!(conn, :headers, &List.keystore(&1, key, 0, {key, value}))
  end

  def add_header(conn, headers) when is_list(headers) do
    Enum.reduce(headers, conn, fn {k, v}, acc -> add_header(acc, k, v) end)
  end

  def add_optional_params(conn, _, []), do: conn

  def add_optional_params(conn, definitions, [{key, value} | tail]) do
    case definitions do
      %{^key => location} ->
        conn
        |> add_param(location, key, value)
        |> add_optional_params(definitions, tail)

      _ ->
        add_optional_params(conn, definitions, tail)
    end
  end

  def add_param(conn, :query, key, value) do
    Map.update!(conn, :query, &Enum.concat(&1, [{key, value}]))
  end

  def add_param(conn, :form, key, value) do
    Map.update!(conn, :body, &Enum.concat(&1, [{key, value}]))
    |> Map.put(:type, :form)
  end

  def add_param(conn, :body, key, value) do
    Map.update!(conn, :body, &Enum.concat(&1, [{key, value}]))
    |> Map.put(:type, :multipart)
  end

  def add_param(conn, :file, _key, file_path) do
    conn
    |> Map.put(:type, :multipart)
    |> add_file(file_path)
  end

  def add_file(conn, path, opts \\ []) do
    {filename, opts} = Keyword.pop_first(opts, :filename, Path.basename(path))
    {headers, opts} = Keyword.pop_first(opts, :headers, [])

    # add in detected content-type if necessary
    headers = List.keystore(headers, "Content-Type", 0, {"Content-Type", MIME.from_path(path)})
    data = File.stream!(path, [:read], 2048)

    Map.update!(conn, :parts, &Enum.concat(&1, [%Part{headers: headers, body: data}]))
  end

  def decode(%HTTPoison.Response{status_code: 200, body: body} = rs) do
    {content_type_header, _} = List.keytake(rs.headers, "Content-Type", 0)

    content_type_header =
      if content_type_header do
        content_type_header
      else
        List.keytake(rs.headers, "Content-Type", 0)
        |> elem(0)
      end

    content_type = elem(content_type_header || {nil, nil}, 1)

    if String.starts_with?(content_type, ["application/json"]) do
      Poison.decode(body)
    else
      {:ok, body}
    end
  end

  def decode(%HTTPoison.Response{status_code: 204}), do: {:ok, %{}}

  def decode(response) do
    {:error, response}
  end

  def method(conn, method) when method in [:get, :post, :put, :delete, :patch] do
    conn
    |> Map.put(:method, method)
  end

  def url(conn, path) do
    if String.starts_with?(path, ["http://", "https://"]) do
      Map.put(conn, :url, path)
    else
      Map.put(conn, :url, Path.join(conn.url, path))
    end
  end

  def execute!(conn) do
    conn = prepare_params(conn)
    # |> IO.inspect()

    request!(conn.method, conn.url, conn.body || "", conn.headers)
  end

  defp prepare_params(conn) do
    url =
      if length(conn.query) > 0 do
        "#{conn.url}?#{URI.encode_query(conn.query)}"
      else
        conn.url
      end

    boundary_str = unique_string(32)

    headers = prepare_headers(conn, boundary_str)
    body = prepare_body(conn, boundary_str)

    Map.merge(conn, %{url: url, headers: headers, body: body})
  end

  defp prepare_headers(conn, boundary_str) do
    case conn.type do
      :form ->
        List.keystore(conn.headers, "Content-Type", 0, {"Content-Type", "application/json"})

      :multipart ->
        List.keystore(
          conn.headers,
          "Content-Type",
          0,
          {"Content-Type", "multipart/related; boundary=#{boundary_str}"}
        )

      _ ->
        conn.headers
    end
  end

  defp prepare_body(conn, boundary_str) do
    case conn.type do
      :form ->
        Poison.encode!(conn.body |> Enum.into(%{}))

      :multipart ->
        body_json = [
          ["--#{boundary_str}\r\n"],
          ["Content-Type: application/json; charset=UTF-8\r\n"],
          ["\r\n"],
          [Poison.encode!(conn.body |> Enum.into(%{}))],
          ["\r\n"]
        ]

        body_stream =
          Enum.map(conn.parts, fn part ->
            part_headers = Enum.map(part.headers, fn {k, v} -> "#{k}: #{v}\r\n" end)

            Stream.concat([
              ["--#{boundary_str}\r\n"],
              [part_headers],
              ["\r\n"],
              part.body,
              ["\r\n"]
            ])
          end)

        {:stream, Stream.concat(body_json ++ body_stream ++ [["--#{boundary_str}--\r\n"]])}

      _ ->
        nil
    end
  end

  @boundary_chars "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
                  |> String.split("")

  @spec unique_string(pos_integer) :: String.t()
  defp unique_string(length) do
    Enum.reduce(1..length, [], fn _i, acc ->
      [Enum.random(@boundary_chars) | acc]
    end)
    |> Enum.join("")
  end
end
