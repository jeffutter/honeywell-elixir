defmodule Honeywell do
  use Application

  @moduledoc """
  Honeywell is a client for the API provided by the Honeywell Round and Water Leak & Freeze Detector APIs.
  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Honeywell.TokenStore, []),
    ]

    opts = [strategy: :one_for_one, name: Honeywell.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
