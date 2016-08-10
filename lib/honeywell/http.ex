defmodule Honeywell.Http do
  use HTTPoison.Base

  @url "https://api.honeywell.com/v2/"

  @moduledoc false

  @spec process_url(binary) :: binary
  defp process_url(endpoint) do
    @url <> endpoint
  end

  defp process_request_headers(headers) when is_map(headers) do
    Enum.into(headers, [authorization_header])
  end
  defp process_request_headers(_headers) do
    Enum.into(%{}, [authorization_header])
  end

  @spec authorization_header() :: {:Authorization, binary}
  defp authorization_header do
    case GenServer.call(Honeywell.TokenStore, {:get, :token}) do
      nil ->
        raise ArgumentError, message: "Missing OAuth Token in TokenStore"
      token ->
        {:Authorization, "Bearer #{token.access_token}"}
    end
  end
end
