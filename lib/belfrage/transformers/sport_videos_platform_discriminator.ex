defmodule Belfrage.Transformers.SportVideosPlatformDiscriminator do
  @moduledoc """
  Alters the Platform and Origin for Sport AV sections that need to be served by Webcore.
  """
  use Belfrage.Transformers.Transformer

  @webcore_sections_test [
    # Block 1
    "sports-personality",
    # Block 2
    "archery",
    "badminton",
    "bowls",
    "canoeing",
    "diving",
    "equestrian",
    "get-inspired",
    "handball",
    "hockey",
    "ice-hockey",
    "judo",
    "rowing",
    "sailing",
    "shooting",
    "squash",
    "table-tennis",
    "taekwondo",
    "triathlon",
    "weightlifting"
  ]

  @webcore_sections_prod []

  def call(_rest, struct = %Struct{request: %Struct.Request{:host => host, path_params: %{"section" => section}}}) do
    case is_webcore(host, section) do
      true ->
        then(
          ["LambdaOriginAlias", "CircuitBreaker", "Language"],
          Struct.add(struct, :private, %{
            platform: Webcore,
            origin: Application.get_env(:belfrage, :pwa_lambda_function)
          })
        )

      false ->
        then(["CircuitBreaker"], struct)
    end
  end

  defp is_webcore(host, section) do
    # Route everything to WebCore when host contains 'belfrage-preview'
    # Route to WebCore when host contains 'test' and section name is in webcore_sections_test list
    # Route to WebCore when section name is in webcore_sections_prod list
    String.contains?(host, "belfrage-preview") or
      (String.contains?(host, "test") and section in @webcore_sections_test) or
      section in @webcore_sections_prod
  end
end
