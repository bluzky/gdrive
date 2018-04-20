defmodule Gdrive.Api.File do
  import Gdrive.Connection

  @moduledoc """
  Support Google drive Files api [here](https://developers.google.com/drive/v3/reference/files)

  Support all query params.

  ## Send a request

  1. Create a connection

      iex> connection = Connection.new(fn scopes ->
               {:ok, token} = Goth.Token.for_scope(Enum.join(your_scopes_list, " "))
                token.token
          end)

      or

      `iex> connection = Connection.new(gg_token)`

  2. Send a request

      {status, data} = Gdrive.Api.File.list(
                connection,
                fields: "files/parents,files/webContentLink,files/id,files/name,files/kind"
            )

  """

  defp standard_params() do
    %{
      :alt => :query,
      :fields => :query,
      :prettyPrint => :query,
      :quotaUser => :query,
      :userIp => :query
    }
  end

  def create(connection, opts \\ []) do
    optional_params =
      %{
        :ignoreDefaultVisibility => :query,
        :keepRevisionForever => :query,
        :ocrLanguage => :query,
        :supportsTeamDrives => :query,
        :useContentAsIndexableText => :query,
        :appProperties => :form,
        :description => :form,
        :folderColorRgb => :form,
        :id => :form,
        :mimeType => :form,
        :modifiedTime => :form,
        :name => :form,
        :originalFilename => :form,
        :parents => :form,
        :properties => :form,
        :starred => :form,
        :viewedByMeTime => :form,
        :viewersCanCopyContent => :form,
        :writersCanShare => :form
      }
      |> Map.merge(standard_params())

    connection
    |> method(:post)
    |> url("/files")
    |> add_optional_params(optional_params, opts)
    |> execute!()
    |> decode()
  end

  def copy(connection, file_id, opts \\ []) do
    optional_params =
      %{
        :ignoreDefaultVisibility => :query,
        :keepRevisionForever => :query,
        :ocrLanguage => :query,
        :supportsTeamDrives => :query,
        :appProperties => :form,
        :description => :form,
        :mimeType => :form,
        :modifiedTime => :form,
        :name => :form,
        :parents => :form,
        :properties => :form,
        :starred => :form,
        :viewedByMeTime => :form,
        :viewersCanCopyContent => :form,
        :writersCanShare => :form
      }
      |> Map.merge(standard_params())

    connection
    |> method(:post)
    |> url("/files/#{URI.encode_www_form(file_id)}/copy")
    |> add_optional_params(optional_params, opts)
    |> execute!()
    |> decode()
  end

  @spec list(Tesla.Env.client(), keyword()) :: {:ok, map()} | {:error, Tesla.Env.t()}
  def list(connection, opts \\ []) do
    optional_params =
      %{
        :corpora => :query,
        :corpus => :query,
        :includeTeamDriveItems => :query,
        :orderBy => :query,
        :pageSize => :query,
        :pageToken => :query,
        :q => :query,
        :spaces => :query,
        :supportsTeamDrives => :query,
        :teamDriveId => :query
      }
      |> Map.merge(standard_params())

    connection
    |> method(:get)
    |> url("/files")
    |> add_optional_params(optional_params, opts)
    |> execute!()
    |> decode()
  end

  def get(connection, file_id, opts \\ []) do
    optional_params =
      %{
        acknowledgeAbuse: :query,
        supportsTeamDrives: :query
      }
      |> Map.merge(standard_params())

    connection
    |> method(:get)
    |> url("/files/#{URI.encode_www_form(file_id)}")
    |> add_optional_params(optional_params, opts)
    |> execute!()
    |> decode()
  end

  def update(connection, file_id, opts \\ []) do
    optional_params =
      %{
        :addParents => :query,
        :keepRevisionForever => :query,
        :ocrLanguage => :query,
        :removeParents => :query,
        :supportsTeamDrives => :query,
        :useContentAsIndexableText => :query,
        :appProperties => :form,
        :description => :form,
        :contentHints => :form,
        :folderColorRgb => :form,
        :mimeType => :form,
        :modifiedTime => :form,
        :name => :form,
        :originalFilename => :form,
        :properties => :form,
        :starred => :form,
        :viewedByMeTime => :form,
        :viewersCanCopyContent => :form,
        :writersCanShare => :form
      }
      |> Map.merge(standard_params())

    connection
    |> method(:patch)
    |> url("/files/#{URI.encode_www_form(file_id)}")
    |> add_optional_params(optional_params, opts)
    |> execute!()
    |> decode()
  end

  def delete(connection, file_id, opts \\ []) do
    optional_params =
      %{
        supportsTeamDrives: :query
      }
      |> Map.merge(standard_params())

    connection
    |> method(:delete)
    |> url("/files/#{URI.encode_www_form(file_id)}")
    |> add_optional_params(optional_params, opts)
    |> execute!
    |> decode()
  end

  @doc """
  Exports a Google Doc to the requested MIME type and returns the exported content. Please note that the exported content is limited to 10MB.
  """
  def export(connection, file_id, opts \\ []) do
    optional_params =
      %{
        mimeType: :query
      }
      |> Map.merge(standard_params())

    connection
    |> method(:get)
    |> url("/files/#{URI.encode_www_form(file_id)}/export")
    |> add_optional_params(optional_params, opts)
    |> execute!()
    |> decode()
  end

  def watch(connection, file_id, opts \\ []) do
    optional_params =
      %{
        :acknowledgeAbuse => :query,
        :supportsTeamDrives => :query,
        :kind => :form,
        :id => :form,
        :resourceID => :form,
        :resourceUri => :form,
        :token => :form,
        :expiration => :form,
        :type => :form,
        :address => :form,
        :payload => :form,
        :params => :form
      }
      |> Map.merge(standard_params())

    connection
    |> method(:post)
    |> url("/files/#{URI.encode_www_form(file_id)}/watch")
    |> add_optional_params(optional_params, opts)
    |> execute!()
    |> decode()
  end

  def empty_trash(connection) do
    connection
    |> method(:delete)
    |> url("/files/trash")
    |> execute!()
    |> decode()
  end

  def upload(connection, opts \\ []) do
    optional_params =
      %{
        :uploadType => :query,
        :ignoreDefaultVisibility => :query,
        :keepRevisionForever => :query,
        :ocrLanguage => :query,
        :supportsTeamDrives => :query,
        :useContentAsIndexableText => :query,
        :appProperties => :body,
        :description => :body,
        :folderColorRgb => :body,
        :id => :body,
        :mimeType => :body,
        :modifiedTime => :body,
        :name => :body,
        :originalFilename => :body,
        :parents => :body,
        :properties => :body,
        :starred => :body,
        :viewedByMeTime => :body,
        :viewersCanCopyContent => :body,
        :writersCanShare => :body,
        :filename => :file
      }
      |> Map.merge(standard_params())

    opts = Keyword.put(opts, :uploadType, "multipart")

    connection
    |> method(:post)
    |> url("https://www.googleapis.com/upload/drive/v3/files")
    |> add_optional_params(optional_params, opts)
    |> execute!()
    |> decode()
  end
end
