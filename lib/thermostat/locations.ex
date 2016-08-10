defmodule Honeywell.Thermostat.Locations do
  alias Honeywell.Thermostat.Location
  alias Honeywell.Base

  @type t :: [Location]
  @type error :: {:error, binary, Integer}
  @type fatal :: {:error, binary}

  @moduledoc """
  This module defines the actions that can be taken on the Thermostat / Locations endpoint.
  """

  @spec get() :: {:ok, t} | error | fatal
  def get do
    Base.get("locations", fn body -> Enum.map(body, &Location.from_map/1) end)
  end
end
