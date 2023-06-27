defmodule Belfrage.PreflightTransformers.BBCXCPSPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.{Brands, Envelope}
  alias Belfrage.Envelope.{Private, Request}

  # CPS IDs generated after 1st of September 2022
  # have been ingested in the BBCX middlelayer.
  @cps_id_min_value 62_729_302

  @impl Transformer
  def call(envelope) do
    {:ok,
     Envelope.add(envelope, :private, %{
       bbcx_enabled: bbcx_enabled?(envelope),
       platform: select_platform(envelope)
     })}
  end

  defp bbcx_enabled?(%Envelope{private: %Private{production_environment: prod_env}}) do
    prod_env == "test"
  end

  defp select_platform(envelope) do
    if Brands.is_bbcx?(envelope) and match_id?(envelope) do
      "BBCX"
    else
      "Webcore"
    end
  end

  defp match_id?(%Envelope{request: %Request{path_params: %{"id" => id}}}) do
    case String.split(id, "-") |> List.last() |> Integer.parse() do
      :error -> false
      {id, _decimal} -> id >= @cps_id_min_value
    end
  end

  defp match_id?(_), do: false
end
