defmodule Honeywell.Base do
  alias Honeywell.Http

  @moduledoc false

  @spec get(binary, (%{} -> any), Keyword.t) :: any
  def get(url, parser, params \\ []) when is_function(parser) do
    url
    |> Http.get([], [params: Keyword.merge(base_params, params)])
    |> to_response(parser)
  end

  @spec get(binary, Keyword.t, (%{} -> any), Keyword.t) :: any
  def get(endpoint, id, parser, params) when is_function(parser) do
    get("#{endpoint}/#{id}", parser, params)
  end

  @spec post(binary, Keyword.t, (%{} -> any), Keyword.t) :: any
  def post(url, body_params, parser, params \\ []) do
    url
    |> Http.post({:form, body_params}, [{'content-type', 'application/json'}], [params: Keyword.merge(base_params, params)])
    |> to_response(parser)
  end

  @spec post(binary, binary, Keyword.t, (%{} -> any), Keyword.t) :: any
  def post(endpoint, id, body_params, parser, params) do
    post("#{endpoint}/#{id}", body_params, parser, params)
  end

  @spec to_response({:ok, %HTTPoison.Response{}}, (%{} -> any)) :: {:ok, any}
  defp to_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}, parser) do
    body = Poison.decode!(body, keys: :atoms)
    {:ok, parser.(body)}
  end

  @spec to_response({:ok, %HTTPoison.Response{}}, (%{} -> any)) :: {:error, binary, integer}
  defp to_response({:ok, %HTTPoison.Response{status_code: status, body: body}}, _parser) do
    body = Poison.decode!(body, keys: :atoms, as: Honeywell.Error)
    {:error, body.message, status}
  end

  @spec to_response({:ok, %HTTPoison.Error{}}, (%{} -> any)) :: {:error, binary}
  defp to_response({:error, %HTTPoison.Error{reason: reason}}, _parser) do
    {:error, reason}
  end

  @spec base_params() :: Keyword.t
  defp base_params do
    [apikey: Application.get_env(:honeywell, :client_id)]
  end
end
