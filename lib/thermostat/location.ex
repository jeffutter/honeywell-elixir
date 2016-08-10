defmodule Honeywell.Thermostat.Location do
  alias Honeywell.Thermostat.Thermostat

  @moduledoc """
  This module defines the actions that can be taken on the Thermostat / Location endpoint.
  """

  defstruct id: nil, name: nil, street_address: nil, city: nil, state: nil, country: nil, zipcode: nil, devices: []
  @type t :: %__MODULE__{
    id: Integer,
    name: binary,
    street_address: binary,
    city: binary,
    state: binary,
    country: binary,
    zipcode: binary,
    devices: [Thermostat.t]}

  @spec from_map(%{}) :: t
  def from_map(body) do
    id = Map.get(body, :locationID)
    name = Map.get(body, :name)
    street_address = Map.get(body, :streetAddress)
    city = Map.get(body, :city)
    state = Map.get(body, :state)
    country = Map.get(body, :country)
    zipcode = Map.get(body, :zipcode)
    devices = body
              |> Map.get(:devices)
              |> Enum.map(Thermostat.from_map(id))
    opts = %{id: id, name: name, street_address: street_address, city: city, state: state, country: country, zipcode: zipcode, devices: devices}
    struct(%__MODULE__{}, opts)
  end
end
