defmodule Belfrage.Clients.HTTP.Error do
  @moduledoc """
  Defines the Error struct.

  Converts error reasons from the 3rd party to a consistent
  set that Belfrage modules using the HTTP client can rely on.
  """
  require Logger
  defstruct [:reason]

  @type t :: %__MODULE__{
          reason: :timeout | :pool_timeout | :bad_url_scheme | nil
        }

  @doc ~S"""
  Create Belfrage HTTP error struct with converted
  3rd party error reason into a Belfrage error
  reason.
  """
  def new(reason) do
    new(:error, reason)
  end

  def new(error_type, reason) do
    Logger.log(:error, "", %{
      info: "Http error",
      third_party_reason: third_party_reason(error_type, reason),
      belfrage_http_reason: format_error(reason)
    })

    %__MODULE__{
      reason: format_error(reason)
    }
  end

  defp third_party_reason(:error, reason) when is_struct(reason), do: Exception.message(reason)
  defp third_party_reason(:error, reason), do: "errored with reason: #{inspect(reason)}"
  defp third_party_reason(:exit, reason), do: "exited with reason: #{inspect(reason)}"
  defp third_party_reason(:throw, reason), do: "threw error with reason: #{inspect(reason)}"

  defp format_error({:timeout, {NimblePool, :checkout, _pids}}), do: :pool_timeout
  defp format_error(%ArgumentError{message: "scheme is required for url:" <> _rest}), do: :bad_url_scheme
  defp format_error(%ArgumentError{message: "invalid scheme" <> _rest}), do: :bad_url_scheme
  defp format_error(%Mint.TransportError{reason: :timeout}), do: :timeout
  defp format_error(_reason), do: nil
end

defimpl String.Chars, for: Belfrage.Clients.HTTP.Error do
  def to_string(error), do: inspect(error)
end
