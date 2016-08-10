defmodule Honeywell.OAuth2 do
  use OAuth2.Strategy
  alias OAuth2.Strategy.AuthCode
  alias OAuth2.Client

  @moduledoc false

  defp config do
    [strategy: __MODULE__,
     site: "https://api.honeywell.com",
     authorize_url: "https://api.honeywell.com/oauth2/authorize",
     token_url: "https://api.honeywell.com/oauth2/token"]
  end

  def client do
    [
      client_id: Application.get_env(:honeywell, :client_id),
      client_secret: Application.get_env(:honeywell, :client_secret),
      site: Application.get_env(:honeywell, :site),
      redirect_uri: Application.get_env(:honeywell, :redirect_uri)
    ]
    |> Keyword.merge(config())
    |> Client.new()
  end

  def authorize_url!(params \\ []) do
    Client.authorize_url!(client, params)
  end

  def get_token!(params \\ [], _headers \\ []) do
    Client.get_token!(client, params)
  end

  def authorize_url(cli, params) do
    AuthCode.authorize_url(cli, params)
  end

  def get_token(cli, params, headers) do
    cli
    |> put_header("Accept", "application/json")
    |> put_header("Authorization",
     "Basic " <> Base.encode64(Application.get_env(:honeywell, :client_id) <> ":" <> Application.get_env(:honeywell, :client_secret))
    )
    |> AuthCode.get_token(params, headers)
  end

  def refresh_token(token, params \\ [], headers \\ [], opts \\ [])
  def refresh_token(%Client{token: %{refresh_token: nil}}, _params, _headers, _opts) do
    {:error, %OAuth2.Error{reason: "Refresh token not available."}}
  end
  def refresh_token(%Client{token: %{refresh_token: refresh}} = cli, params, headers, opts) do
    refresh = %{cli | strategy: OAuth2.Strategy.Refresh}
    |> put_header("Accept", "application/json")
    |> put_header("Authorization",
     "Basic " <> Base.encode64(Application.get_env(:honeywell, :client_id) <> ":" <> Application.get_env(:honeywell, :client_secret))
    )
    |> put_param(:refresh_token, refresh)
    |> put_param(:grant_type, "refresh_token")

    case Client.get_token(refresh, params, headers, opts) do
      {:ok, %Client{} = client} -> {:ok, client}
      {:error, error} -> {:error, error}
    end
  end

end
