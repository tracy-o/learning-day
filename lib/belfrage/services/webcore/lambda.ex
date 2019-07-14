defmodule Belfrage.Services.Webcore.Lambda do
  defmacro __using__(opts) do
    quote do
      alias Belfrage.{Clients, Struct}
      alias Belfrage.Services.Webcore.{Request, Response}
      alias Belfrage.Behaviours.Service

      @behaviour Service

      @arn Keyword.fetch!(unquote(opts), :arn)
      @lambda_function Keyword.fetch!(unquote(opts), :lambda_function)

      defp arn() do
        Application.fetch_env!(:belfrage, @arn)
      end

      defp lambda_function() do
        Application.fetch_env!(:belfrage, @lambda_function)
      end

      defp lambda_client() do
        Application.get_env(:belfrage, :lambda_client, Clients.Lambda)
      end
    end
  end
end
