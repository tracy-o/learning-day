defmodule Belfrage.Services.Lambda.Lambda do
  defmacro __using__(opts) do
    quote do
      alias Belfrage.{Clients, Struct}
      alias Belfrage.Services.Lambda.{Request, Response}
      alias Belfrage.Behaviours.Service

      @behaviour Service

      @arn Keyword.fetch!(unquote(opts), :arn)
      @lambda_function Keyword.fetch!(unquote(opts), :lambda_function)

      def arn() do
        Application.fetch_env!(:belfrage, @arn)
      end

      def lambda_function() do
        Application.fetch_env!(:belfrage, @lambda_function)
      end

      def lambda_client() do
        Application.get_env(:belfrage, :lambda_client, Clients.Lambda)
      end
    end
  end
end
