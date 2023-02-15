defmodule Belfrage.Behaviours.Selector do
  alias Belfrage.Envelope

  @type selector_type :: :spec | :platform

  @callback call(Envelope.Request.t()) ::
              {:ok, String.t()}
              | {:ok, {String.t(), non_neg_integer() | String.t()}}
              | {:error, any()}

  @spec call(String.t(), selector_type(), Envelope.Request.t()) ::
          {:ok, String.t()}
          | {:ok, {String.t(), non_neg_integer() | String.t()}}
          | {:error, any()}
  def call(selector, type, request = %Envelope.Request{}) do
    ["Routes", type_to_selector_module(type), "Selectors", selector]
    |> Module.concat()
    |> apply(:call, [request])
  end

  def selector?(name) do
    String.ends_with?(name, "Selector")
  end

  defp type_to_selector_module(:platform), do: "Platforms"
  defp type_to_selector_module(:spec), do: "Specs"
end
