defmodule Routes.Platforms.Selector do
  alias Belfrage.Struct

  @callback call(Struct.Request.t()) :: MozartNews | Webcore

  # Finds the provided Selector module and calls
  # it with the provided Request as an argument.
  def call(selector, request = %Struct.Request{}) do
    ["Routes", "Platforms", "Selectors", selector]
    |> Module.concat()
    |> apply(:call, [request])
  end
end
