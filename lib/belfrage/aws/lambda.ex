defmodule Belfrage.AWS.Lambda do
  @type function_name :: String.t()
  @type payload :: map()
  @type context :: map()
  @type opts :: List.t()

  @callback invoke(function_name, payload, context, opts) :: ExAws.Operation.JSON.t()

  defdelegate invoke(function_name, payload, context, opts \\ []), to: ExAws.Lambda
end
