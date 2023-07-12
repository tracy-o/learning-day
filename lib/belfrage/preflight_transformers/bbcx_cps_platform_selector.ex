defmodule Belfrage.PreflightTransformers.BBCXCPSPlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.{Brands, Envelope}
  alias Belfrage.Envelope.Request

  # CPS IDs generated after 1st of January 2021
  # have been ingested in the BBCX middlelayer.
  @cps_id_min_value 55_491_197

  @impl Transformer
  def call(envelope) do
    {:ok,
     Envelope.add(envelope, :private, %{
       bbcx_enabled: Brands.bbcx_enabled?(),
       platform: select_platform(envelope)
     })}
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
