defmodule Belfrage.AWS.Lambda do
  defdelegate invoke(function_name, payload, context, opts \\ []), to: ExAws.Lambda
end
