defmodule Routes.Platforms.Selector do
  alias Belfrage.Envelope

  @callback call(Envelope.t()) :: {:ok, Envelope.t()} | {:error, integer()}

  # Finds the provided Selector module and calls
  # it with the provided Request as an argument.
  def call(selector, envelope = %Envelope{}) do
    ["Belfrage", "PreFlightTransformers", selector]
    |> Module.concat()
    |> apply(:call, [envelope])
  end
end
