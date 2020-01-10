defmodule Belfrage.AWS.Lambda do
  @type function_name :: String.t()
  @type payload :: map()
  @type context :: map()

  @callback invoke(function_name, payload, context) :: ExAws.Operation.JSON.t()

  defdelegate invoke(function_name, payload, context), to: ExAws.Lambda
end
