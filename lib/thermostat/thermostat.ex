defmodule Honeywell.Thermostat.Thermostat do
  alias Honeywell.Base

  defstruct temperature: nil, location_id: nil, device_id: nil
  @type t :: %__MODULE__{temperature: float, location_id: binary, device_id: binary}
  @type error :: {:error, binary, Integer}
  @type fatal :: {:error, binary}

  @endpoint "devices/thermostats"

  @moduledoc """
  This module defines the actions that can be taken on the Thermostat endpoint.
  """

  @spec get(binary, binary) :: {:ok, t} | error | fatal
  def get(location_id, device_id) do
    Base.get(@endpoint, device_id, from_map(location_id, device_id), [locationId: location_id])
  end

  @spec post(binary, binary, Keyword.t) :: {:ok, :ok} | error | fatal
  def post(location_id, device_id, mode: mode, auto_changeover_active: auto_changeover_active, emergency_heat_active: emergency_heat_active, heat_setpoint: heat_setpoint, cool_setpoint: cool_setpoint) do
    body = %{
      "mode" => mode,
      "autoChangeoverActive" => auto_changeover_active,
      "emergencyHeatActive" => emergency_heat_active,
      "heatSetpoint" => heat_setpoint,
      "coolSetpoint" => cool_setpoint
    }
    Base.post(@endpoint, device_id, Poison.encode!(body), fn _body -> :ok end, [locationId: location_id])
  end

  @spec from_map(binary, binary) :: (%{} -> t)
  def from_map(location_id, device_id) do
    fn body ->
      temp = Map.get(body, :indoorTemperature)
      opts = %{temperature: temp, location_id: location_id, device_id: device_id}
      struct(%__MODULE__{}, opts)
    end
  end

  @spec from_map(binary) :: (%{} -> t)
  def from_map(location_id) do
    fn body ->
      temp = Map.get(body, :indoorTemperature)
      device_id = Map.get(body, :deviceID)
      opts = %{temperature: temp, location_id: location_id, device_id: device_id}
      struct(%__MODULE__{}, opts)
    end
  end
end
