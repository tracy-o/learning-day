defmodule Belfrage.Transformers.SportVideosPlatformDiscriminator do
  @moduledoc """
  Alters the Platform and Origin for Sport AV sections that need to be served by Webcore.
  """
  use Belfrage.Transformers.Transformer

  @webcore_sections_test [
    # Block 6
    "get-inspired"
  ]

  @webcore_sections_live [
    # Block 1
    "sports-personality",

    # Block 2
    "archery",
    "badminton",
    "bowls",
    "canoeing",
    "diving",
    "equestrian",
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
    "weightlifting",

    # Block 3
    "american-football",
    "baseball",
    "basketball",
    "boxing",
    "cycling",
    "darts",
    "disability-sport",
    "gaelic-games",
    "gymnastics",
    "mixed-martial-arts",
    "motorsport",
    "netball",
    "olympics",
    "snooker",
    "swimming",
    "winter-sports",
    "winter-olympics",

    # Block 4
    "formula1",
    "cricket",
    "rugby-union",
    "rugby-league",
    "tennis",
    "golf",
    "athletics"
  ]

  def call(_rest, struct) do
    case is_webcore?(struct) do
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

  defp is_webcore?(struct = %Struct{request: %Struct.Request{path_params: %{"section" => section}}}) do
    cond do
      is_preview_mode?(struct) -> true
      test_production_environment?(struct) and (is_test_section?(section) or is_live_section?(section)) -> true
      live_production_environment?(struct) and is_live_section?(section) -> true
      true -> false
    end
  end

  defp test_production_environment?(struct), do: struct.private.production_environment == "test"

  defp live_production_environment?(struct), do: struct.private.production_environment == "live"

  defp is_preview_mode?(struct), do: struct.private.preview_mode == "on"

  defp is_test_section?(section), do: section in @webcore_sections_test

  defp is_live_section?(section), do: section in @webcore_sections_live
end
