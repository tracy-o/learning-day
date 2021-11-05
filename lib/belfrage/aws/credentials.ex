defmodule Belfrage.AWS.Credentials do
  defstruct [:access_key_id, :secret_access_key, :session_token]

  @type t :: %__MODULE__{
          access_key_id: String.t() | nil,
          secret_access_key: String.t() | nil,
          session_token: String.t() | nil
        }
end
