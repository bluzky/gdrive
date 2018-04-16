defmodule Gdrive.Api.Permission do
  import Gdrive.Connection

  defp standard_params() do
    %{
      :alt => :query,
      :fields => :query,
      :prettyPrint => :query,
      :quotaUser => :query,
      :userIp => :query
    }
  end

  def create(connection, file_id, opts \\ []) do
    optional_params =
      %{
        :emailMessage => :query,
        :sendNotificationEmail => :query,
        :supportsTeamDrives => :query,
        :transferOwnership => :query,
        :useDomainAdminAccess => :query,
        :role => :form,
        :type => :form,
        :allowFileDiscovery => :form,
        :domain => :form,
        :emailAddress => :form
      }
      |> Map.merge(standard_params())

    connection
    |> method(:post)
    |> url("/files/#{URI.encode_www_form(file_id)}/permissions")
    |> add_optional_params(optional_params, opts)
    |> execute!()
    |> decode()
  end

  def delete(connection, file_id, permission_id, opts \\ []) do
    optional_params =
      %{
        :supportsTeamDrives => :query,
        :useDomainAdminAccess => :query
      }
      |> Map.merge(standard_params())

    connection
    |> method(:delete)
    |> url(
      "/files/#{URI.encode_www_form(file_id)}/permissions/#{URI.encode_www_form(permission_id)}"
    )
    |> add_optional_params(optional_params, opts)
    |> execute!()
    |> decode()
  end

  def get(connection, file_id, permission_id, opts \\ []) do
    optional_params =
      %{
        :supportsTeamDrives => :query,
        :useDomainAdminAccess => :query
      }
      |> Map.merge(standard_params())

    connection
    |> method(:get)
    |> url(
      "/files/#{URI.encode_www_form(file_id)}/permissions/#{URI.encode_www_form(permission_id)}"
    )
    |> add_optional_params(optional_params, opts)
    |> execute!()
    |> decode()
  end

  def list(connection, file_id, opts \\ []) do
    optional_params =
      %{
        :supportsTeamDrives => :query,
        :useDomainAdminAccess => :query,
        :pageSize => :query,
        :pageToken => :query
      }
      |> Map.merge(standard_params())

    connection
    |> method(:get)
    |> url("/files/#{URI.encode_www_form(file_id)}/permissions")
    |> add_optional_params(optional_params, opts)
    |> execute!()
    |> decode()
  end

  def update(connection, file_id, permission_id, opts \\ []) do
    optional_params =
      %{
        :supportsTeamDrives => :query,
        :useDomainAdminAccess => :query,
        :removeExpiration => :query,
        :transferOwnership => :query,
        :expirationTime => :form,
        :role => :form
      }
      |> Map.merge(standard_params())

    connection
    |> method(:patch)
    |> url(
      "/files/#{URI.encode_www_form(file_id)}/permissions/#{URI.encode_www_form(permission_id)}"
    )
    |> add_optional_params(optional_params, opts)
    |> execute!()
    |> decode()
  end
end
