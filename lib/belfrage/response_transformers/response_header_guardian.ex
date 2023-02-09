defmodule Belfrage.ResponseTransformers.ResponseHeaderGuardian do
  @moduledoc """
  Remove response headers that could result in
  clearly bad behaviour for Belfrage.
  """
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope = %Envelope{response: response = %Envelope.Response{headers: response_headers}}) do
    envelope =
      Map.put(envelope, :response, %Envelope.Response{
        response
        | headers: clean_headers(response_headers)
      })

    {:ok, envelope}
  end

  @doc ~S"""
  Output headers as a map, with the keys downcased.

  ## Examples
      iex> clean_headers(%{"cache-control" => "private"})
      %{"cache-control" => "private"}

      iex> clean_headers(%{"connection" => "close"})
      %{}

      iex> clean_headers(%{"content-type" => "application/json", "connection" => "close"})
      %{"content-type" => "application/json"}
  """
  def clean_headers(response_headers) do
    response_headers
    |> Map.delete("connection")
    |> Map.delete("transfer-encoding")
  end
end
