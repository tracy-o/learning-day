defmodule Belfrage.ResponseTransformers.ResponseHeaderGuardian do
  @moduledoc """
  Remove response headers that could result in
  clearly bad behaviour for Belfrage.
  """
  alias Belfrage.Struct
  @behaviour Belfrage.Behaviours.ResponseTransformer

  @impl true
  def call(struct = %Struct{response: response = %Struct.Response{headers: response_headers}}) do
    Map.put(struct, :response, %Struct.Response{
      response
      | headers: clean_headers(response_headers)
    })
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
