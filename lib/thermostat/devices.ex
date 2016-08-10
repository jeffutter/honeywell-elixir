defmodule Honeywell.Thermostat.Devices do
  alias Honeywell.Thermostat.Thermostat
  alias Honeywell.Base

  @type t :: [Honeywell.Thermostat.Thermostat]
  @type error :: {:error, binary, Integer}
  @type fatal :: {:error, binary}

  @moduledoc """
  This module defines the actions that can be taken on the Thermostat / Devices endpoint.
  """

  @spec get(binary) :: t | error | fatal
  def get(location_id) do
    Base.get("devices", fn body -> Enum.map(body, Thermostat.from_map(location_id)) end, [locationId: location_id])
  end
end
