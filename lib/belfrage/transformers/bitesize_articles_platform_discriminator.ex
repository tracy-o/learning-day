defmodule Belfrage.Transformers.BitesizeArticlesPlatformDiscriminator do
  @moduledoc """
  Alters the Platform and Origin for a subset of Bitesize Articles IDs that need to be served by Webcore.
  """
  use Belfrage.Transformers.Transformer

  @webcore_ids [
    "zm8fhbk",
    "zjykkmn",
    "zj8yydm"
  ]

  def call(
        _rest,
        struct = %Struct{request: %Struct.Request{path_params: %{"id" => id, "slug" => _slug}}}
      )
      when id in @webcore_ids do
    {
      :redirect,
      Struct.add(struct, :response, %{
        http_status: 302,
        headers: %{
          "location" => "/bitesize/articles/#{id}",
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, stale-while-revalidate=10, max-age=60"
        },
        body: "Redirecting"
      })
    }
  end

  def call(_rest, struct = %Struct{request: %Struct.Request{path_params: %{"id" => id}}}) when id in @webcore_ids do
    then(
      ["Personalisation", "LambdaOriginAlias", "PlatformKillSwitch", "CircuitBreaker", "Language"],
      Struct.add(struct, :private, %{
        platform: Webcore,
        origin: Application.get_env(:belfrage, :pwa_lambda_function)
      })
    )
  end

  def call(_rest, struct), do: then(["CircuitBreaker"], struct)
end
