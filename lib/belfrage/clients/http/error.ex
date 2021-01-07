defmodule Belfrage.Clients.HTTP.Error do
  @moduledoc """
  Defines the Error struct.

  Converts error reasons from the 3rd party to a consistent
  set that Belfrage modules using the HTTP client can rely on.
  """
  defstruct [:reason]

  @type t :: %__MODULE__{
          reason: :timeout | :pool_timeout | :bad_url | :bad_url_scheme | nil
        }

  # Map the 3rd party http library error reasons, to
  # the Belfrage HTTP.Error reasons
  @map_reason_codes [
    request_timeout: :timeout,
    pool_timeout: :pool_timeout,
    bad_url: :bad_url,
    bad_url_scheme: :bad_url_scheme
  ]

  @doc ~S"""
  Create Belfrage HTTP error struct with converted
  3rd party error reason into a Belfrage error
  reason.

  ## Examples

      iex> Belfrage.Clients.HTTP.Error.new(%MachineGun.Error{reason: :request_timeout})
      %Belfrage.Clients.HTTP.Error{reason: :timeout}

      iex> Belfrage.Clients.HTTP.Error.new(%MachineGun.Error{reason: :pool_timeout})
      %Belfrage.Clients.HTTP.Error{reason: :pool_timeout}

      iex> Belfrage.Clients.HTTP.Error.new(%MachineGun.Error{reason: :unexpected_reason})
      %Belfrage.Clients.HTTP.Error{reason: nil}

      iex> Belfrage.Clients.HTTP.Error.new(%{error: :unexpected_error_format})
      %Belfrage.Clients.HTTP.Error{reason: nil}
  """
  def new(error = %MachineGun.Error{reason: reason}) do
    belfrage_http_reason = standardise_error_reason(reason)

    Belfrage.Event.record(:log, :error, %{
      info: "Http error",
      third_party_reason: MachineGun.Error.message(error),
      belfrage_http_reason: belfrage_http_reason
    })

    %__MODULE__{
      reason: belfrage_http_reason
    }
  end

  def new(_error), do: %__MODULE__{}

  defp standardise_error_reason(reason) when is_atom(reason) do
    Keyword.get(@map_reason_codes, reason, nil)
  end

  defp standardise_error_reason(_), do: nil
end

defimpl String.Chars, for: Belfrage.Clients.HTTP.Error do
  def to_string(error), do: inspect(error)
end
