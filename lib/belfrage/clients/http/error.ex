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

      iex> Belfrage.Clients.HTTP.Error.new(:request_timeout)
      %Belfrage.Clients.HTTP.Error{reason: :timeout}

      iex> Belfrage.Clients.HTTP.Error.new(:pool_timeout)
      %Belfrage.Clients.HTTP.Error{reason: :pool_timeout}

      iex> Belfrage.Clients.HTTP.Error.new(:unexpected_reason)
      %Belfrage.Clients.HTTP.Error{reason: nil}

      iex> Belfrage.Clients.HTTP.Error.new(%{error: :unexpected_error_format})
      %Belfrage.Clients.HTTP.Error{reason: nil}
  """
  def new(reason) do
    belfrage_http_reason = standardise_error_reason(reason)

    Stump.log(:error, %{
      info: "Http error",
      third_party_reason: reason,
      belfrage_http_reason: belfrage_http_reason
    })

    %__MODULE__{
      reason: belfrage_http_reason
    }
  end

  defp standardise_error_reason(reason) when is_atom(reason) do
    Keyword.get(@map_reason_codes, reason, nil)
  end

  defp standardise_error_reason(_), do: nil
end
