defmodule Routes.Platforms.Selector do
  alias Belfrage.Envelope

  @callback call(Envelope.Request.t()) :: {:ok, String.t()} | {:error, integer()}

  # Finds the provided Selector module and calls
  # it with the provided Request as an argument.
  def call(selector, request = %Envelope.Request{}) do
    ["Routes", "Platforms", "Selectors", selector]
    |> Module.concat()
    |> apply(:call, [request])
  end
end
