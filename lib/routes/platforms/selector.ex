defmodule Routes.Platforms.Selector do
  alias Belfrage.Struct

  @callback call(Struct.Request.t()) :: {:ok, String.t()} | {:error, integer()}

  # Here we iterate through a list of Platform strings, which
  # are used to create function clauses that return the Platform
  # string if the first argument to the function clause matches
  # the said Platform.
  for platform <- Routes.Platforms.list() do
    def call(unquote(platform), _request), do: {:ok, unquote(platform)}
  end

  # Finds the provided Selector module and calls
  # it with the provided Request as an argument.
  def call(selector, request = %Struct.Request{}) do
    ["Routes", "Platforms", "Selectors", selector]
    |> Module.concat()
    |> apply(:call, [request])
  end
end
