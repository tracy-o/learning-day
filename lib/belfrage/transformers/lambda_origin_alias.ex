defmodule Belfrage.Transformers.LambdaOriginAlias do
  @moduledoc """
  Appends the alias for a lambda function.
  """
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{subdomain: subdomain}, private: private}) do
    case String.match?(subdomain, ~r/[a-zA-Z0-9]/) do
      true ->
        then(
          rest,
          Struct.add(struct, :private, %{
            origin: "#{private.origin}:#{lambda_alias(private.preview_mode, subdomain, private.production_environment)}"
          })
        )

      false ->
        {
          :stop_pipeline,
          Struct.add(struct, :response, %{
            http_status: 400,
            body: "Invalid Alias"
          })
        }
    end
  end

  defp lambda_alias("on", subdomain, _), do: subdomain

  defp lambda_alias("off", _, production_environment), do: production_environment
end
