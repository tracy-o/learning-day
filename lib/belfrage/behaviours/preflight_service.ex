defmodule Belfrage.Behaviours.PreflightService do
  alias Belfrage.Envelope

  @callback request(Envelope.t()) :: map()
  @callback cache_key(Envelope.t()) :: binary()
  @callback callback_success(any()) :: {:ok, any()} | {:error, atom()}
  @callback callback_error(any()) :: {:error, any()}

  @optional_callbacks callback_success: 1, callback_error: 1
end
