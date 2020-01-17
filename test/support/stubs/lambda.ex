defmodule Belfrage.AWS.LambdaStub do
  @behaviour Belfrage.AWS.Lambda

  def invoke(function_name, payload, context) do
    ExAws.Lambda.invoke(function_name, payload, context)
  end
end
