defmodule Honeywell.Error do
  defstruct [:message]
  @type t :: %__MODULE__{message: binary}

  @moduledoc false

end
