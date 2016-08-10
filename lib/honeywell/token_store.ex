defmodule Honeywell.TokenStore do
  use GenServer
  require Logger
  alias Elixir.OAuth2.AccessToken
  alias Elixir.Honeywell.OAuth2

  @valid_keys [:token, :client]

  @moduledoc false

  # Client
  def start_link do
    GenServer.start_link(__MODULE__, %{token: nil, client: nil}, name: __MODULE__)
  end

  # Server (Callbacks)

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:set, key, val}, state) when key in @valid_keys do
    {:noreply, %{state | key => val}}
  end

  def handle_call({:get, :token}, _from, state) do
    new_state = refresh_token(state)

    {:reply, Map.get(new_state, :token), new_state}
  end
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  defp refresh_token(state, time \\ unix_now)
  defp refresh_token(%{client: client, token: %AccessToken{expires_at: expires_at}}, time) when time >= (expires_at - 15) do
    Logger.info "Refreshing Token"
    case OAuth2.refresh_token(client) do
      {:ok, new_client} ->
        %{client: new_client, token: new_client.token}
      {:error, _} ->
        %{client: client, token: nil}
    end
  end
  defp refresh_token(state, _time), do: state

  defp unix_now do
    {mega, sec, _micro} = :os.timestamp
    (mega * 1_000_000) + sec
  end
end
